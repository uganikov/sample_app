require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  it "full title helper" do
    expect(full_title).to eq "Ruby on Rails Tutorial Sample App"
    expect(full_title("Help")).to eq "Help | Ruby on Rails Tutorial Sample App"
  end
end
