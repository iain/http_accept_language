class LanguagesController < ApplicationController
  def index
    render plain: "Languages: #{languages.join(" : ")}"
  end

  private

  def languages
    http_accept_language.user_preferred_languages
  end
end
