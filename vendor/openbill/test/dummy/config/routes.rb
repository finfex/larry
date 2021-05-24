Rails.application.routes.draw do
  mount Openbill::Engine => "/openbill"
end
