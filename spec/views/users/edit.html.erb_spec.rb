require 'spec_helper'

=begin
describe "users/edit.html.erb" do
	it "contains a submit button" do
		#assign(:user, [mock_model(User, :id => 1, :name => "First")])
    mock_model(User, :id => 1, :name => "mock")
    #stub_template "users/edit.html.erb"
		render "users/edit.html.erb"
		expect(rendered).to have_submit_button('Update User')
	end
end
=end