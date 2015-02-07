FactoryGirl.define do

  factory :account do
    name "Test Account"
    total 0
  end

  factory :allocation do
    account
    amount 0
    name "Test Allocation"
    priority 0
  end

  factory :expense do
    account
    amount 0
    bucket_id { FactoryGirl.create(:bucket).id }
    name "Test Expense"
  end

  factory :bucket do
    account
    amount 0
    name "Test Bucket"
    priority 0
  end

  factory :income do
    account
    amount 500
    name "Test Income"
    origin "Test Source"
  end
end
