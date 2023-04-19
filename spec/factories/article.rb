FactoryBot.define do
  factory :article do
    title { "The article" }
    body { "This is a factory article" }
    status { "public" }
  end
end