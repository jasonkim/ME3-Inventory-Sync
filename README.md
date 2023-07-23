# Automatically update Mass Effect 3 - Pack Odds and Cost
[Link to reddit post](https://www.reddit.com/r/MECoOp/comments/8skt5i/mass_effect_3_pack_odds_and_cost_spreadsheet/)

[Link to the google sheet](https://docs.google.com/spreadsheets/d/1GOfFa6wJktdmTUkAiXIAzLBTbXOAtTBr0aM_p1bnB28/edit#gid=0)

# Setting up

1. Copy the sheet into your account so that it can be edited.

1. Create a [Google API service account](https://cloud.google.com/iam/docs/service-account-creds#key-types). This will be used to edit the google sheet.

1. Download the credentials.json once the service account is created.

1. Add the email associated with the service account to the google sheet as an editor (under share option). It should be [name of the service account]@[some string].iam.gserviceaccount.com.

1. `bundle install` (may need to install [bundler](https://bundler.io/))

1. Fill in [urls.json](./urls.json) file with N7 profile of the inventory and google sheet url. Make sure the profile is set to public under [My Account](http://n7hq.masseffect.com/account/) so it can be accessed without logging in.

1. `ruby run.rb`

#### Note 1
You can pass in the credential and url as environment variables. It's `CREDENTIAL` as the credential hash and `urls` as an array of hash (`[{"profile": "...", "sheet": "..."}]`)
