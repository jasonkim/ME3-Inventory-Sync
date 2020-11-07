# Automatically update Mass Effect 3 - Pack Odds and Cost
[Link to reddit post](https://www.reddit.com/r/MECoOp/comments/8skt5i/mass_effect_3_pack_odds_and_cost_spreadsheet/)

[Link to the google sheet](https://docs.google.com/spreadsheets/d/1GOfFa6wJktdmTUkAiXIAzLBTbXOAtTBr0aM_p1bnB28/edit#gid=0)

# Setting up

1. Copy the sheet into your account so that it can be edited.

1. `bundle install` (may need to install [bundler](https://bundler.io/))

1. Follow Step 1 of [Google sheet quickstart guide](https://developers.google.com/sheets/api/quickstart/ruby) to enable google sheets api and download credentials.json

1. Fill in [urls.json](./urls.json) file with N7 profile and google sheet urls. Make sure the profile is set to public under [My Account](http://n7hq.masseffect.com/account/).

1. `ruby run.rb`

1. The first time you run, it will prompt you to authorize access:
  * The application will attempt to open a new window or tab in your default browser. If this fails, copy the URL from the console and manually open it in your browser.
  * If you are not already logged into your Google account, you will be prompted to log in. If you are logged into multiple Google accounts, you will be asked to select one account to use for the authorization.
  * Click the Accept button. (see Note 1)
  * The application will proceed automatically, and you may close the window/tab. (see Note 2)



#### Note 1
The OAuth consent screen that is presented to the user may show the warning "This app isn't verified" if it is requesting scopes that provide access to sensitive user data. These applications must eventually go through the verification process to remove that warning and other limitations. During the development phase you can continue past this warning by clicking Advanced > Go to {Project Name} (unsafe).

#### Note 2
It may ask you to copy and paste the token into the console. Doing so will authorize the application and will proceed automatically.
