FactoryBot.define do
  factory :user_client, class: User do
    email { "satoshi@nakamoto.com" }
    password { "03012009" }
    user_type { "client" }
    birthday { Date.today - 1 }
    country { "Spain" }
  end

  factory :user_corporation, class: User do
    email { "son@goku.com" }
    password { "03012009" }
    user_type { "corporation" }
    birthday { Date.today - 1 }
    country { "Spain" }
  end
end
