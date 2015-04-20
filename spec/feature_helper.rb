module FeatureHelper
  def login_with_oauth(service = :facebook)
    visit "/auth/#{service}/callback"
  end
end