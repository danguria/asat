require 'rails_helper'

RSpec.describe "qsheets/new", type: :view do
  before(:each) do
    assign(:qsheet, Qsheet.new(
      :contest => "MyString",
      :division => "MyString"
    ))
  end

  # it "renders new qsheet form" do
  #   render

  #   assert_select "form[action=?][method=?]", qsheets_path, "post" do

  #     assert_select "input#qsheet_contest[name=?]", "qsheet[contest]"

  #     assert_select "input#qsheet_division[name=?]", "qsheet[division]"
  #   end
  # end
end
