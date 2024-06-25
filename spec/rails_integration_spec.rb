RSpec.describe "Rails integration" do
  describe "Controller Helper", type: :request do
    it "returns correct language values from header" do
      headers = {"HTTP_ACCEPT_LANGUAGE" => "en-us,en-gb;q=0.8,en;q=0.6,es-419"}

      get root_path, headers: headers

      expect(response.body)
        .to include("Languages: en-US : es-419 : en-GB : en")
    end
  end

  describe "Middleware" do
    it "inserts middleware into the Rails application" do
      expect(Rails.application.middleware.middlewares)
        .to include(HttpAcceptLanguage::Middleware)
    end
  end
end
