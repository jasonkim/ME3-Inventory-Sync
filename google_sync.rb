require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

# Follow https://developers.google.com/sheets/api/quickstart/ruby to enable google sheets api

OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
APPLICATION_NAME = "ME3 Sync".freeze
CREDENTIALS_PATH = "credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = "token.yaml".freeze
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

SHEET_TITLE_MAP = {
  weapon: 'Weapons',
  mod: 'Mods',
  character: 'Characters',
  consumable: 'Consumables',
  gear: 'Gear',
}

SPREADSHEET_ID = /docs.google.com\/spreadsheets\/d\/(.{44})/
class GoogleSync
  attr_reader :id, :title_id_map

  def initialize(url)
    if match = url.match(SPREADSHEET_ID)
      @id = match.captures.first
    else
      raise "No ID found for #{url}"
    end

    @title_id_map = {}
    service.get_spreadsheet(id).sheets.each{|s| @title_id_map[s.properties.title] = s.properties.sheet_id}
  end

  def service
    if @service.nil?
      # Initialize the API
      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.client_options.application_name = APPLICATION_NAME
      @service.authorization = authorize
    end
    return @service
  end

  def update(inventory)
    service.batch_update_spreadsheet(id, request(inventory), {})
  end

  def request(inventory)
    requests = []
    # requests += prep_requests(inventory.weapons, ["common"])
    requests += prep_requests(inventory.weapons, ["common","uncommon","rare","ultrarare"])
    requests += prep_requests(inventory.mods, ["common","uncommon","rare"])
    requests += prep_requests(inventory.characters, ["common","uncommon","rare","ultrarare"])
    requests += prep_requests(inventory.consumables, ["consumable"])
    requests += prep_requests(inventory.gears, ["uncommon","rare"])
    {requests: requests}
  end

  def prep_requests(items, cols)
    type = items.first.type
    cols.map do |rarity|
      index = index_by_rarity(type, rarity)
      rows = filter_by_type(items, type, rarity)
        .map { |item| {values:[{user_entered_value: {number_value: item.level}}]} }
      {update_cells: {
        start: {sheet_id: title_id_map[SHEET_TITLE_MAP[type]], row_index: 0, column_index: index},
        fields: "*",
        rows: rows,
      }}
    end
  end

  def filter_by_type(items, type, rarity)
    case type
    when :consumable
      items.first(9)
    else
      items.select{ |item| item.rarity == rarity }
    end
  end

  def index_by_rarity(type, rarity)
    rarity_index = {"common" => 1, "uncommon" => 3, "rare" => 5, "ultrarare" => 7}
    case type
    when :weapon, :mod
      {"common" => 1, "uncommon" => 3, "rare" => 5, "ultrarare" => 7}[rarity]
    when :character
      {"common" => 1, "uncommon" => 4, "rare" => 7, "ultrarare" => 10}[rarity]
    when :consumable
      1
    when :gear
      {"uncommon" => 1, "rare" => 3}[rarity]
    end
  end

private
  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end
end
