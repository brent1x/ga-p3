## URL STRUCTURE FOR CANCELLATION
## https://m.opentable.com/reservation/view?RestaurantID=5825&ConfirmationNumber=1736688354&DateTime=05%2F14%2F2015%2019%3A00%3A00&PartySize=2
## https | hardcoded | restaurant id | confirmation number | datetime 05/12/2015 19:00:00 | party size
## %2F is a /
## %20 is a space
## %3A is a :

## BUTTON ON MOBILE WEB FOR CANCELLATION – POPS UP THE MODAL
# <a id="CancelButton" href="#" class="btn btn-default btn-block font-color-primary watch-for-touch-toggle" ng-click="cancelPrompt($event)">Cancel</a>

## SECOND BUTTON ON MOBILE WEB FOR CANCELLATION – ON MODAL ITSELF
# <button ng-repeat="btn in buttons" id="dynamicDialogYes" ng-click="close(btn.result)" class="btn btn-default ng-scope ng-binding btn-primary" ng-class="btn.cssClass">Yes</button>

require 'rubygems'
require 'mechanize'
require 'logger'

agent = Mechanize.new
agent.log = Logger.new "mech.log"
agent.user_agent_alias = 'Mac Safari'

page = agent.get "https://m.opentable.com/reservation/view?RestaurantID=47881&ConfirmationNumber=1820467707"

link1 = page.link_with(:class => 'btn btn-default btn-block font-color-primary watch-for-touch-toggle')
page = link1.click


sleep 2


link2 = page.button_with(:class => "btn btn-default ng-scope ng-binding btn-primary")


page = link2.click_button

