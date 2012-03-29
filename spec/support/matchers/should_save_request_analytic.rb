RSpec::Matchers.define :save_request_analytic do
  match do |actual|
    pre_count = RequestAnalytic.count
    actual.call
    post_count = RequestAnalytic.count
    post_count - pre_count == 1
  end

  failure_message_for_should do |actual|
    "expected that the block would save an RequestAnalytic"
  end

  failure_message_for_should_not do |actual|
    "expected that the block would not save an RequestAnalytic"
  end

  description do
    "save a request analytic"
  end
end