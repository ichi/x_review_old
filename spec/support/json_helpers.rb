require "rspec/json_matcher"

module JsonHelpers
  def response_json
    @json ||= JSON.parse(response.body)
  end

  def jsonize(val)
    case val
    when Class, Regexp # rspec-json_matcher用
      val
    when Array
      val.map{|v| jsonize(val) }
    when Hash
      val.map{|k, v| [k.to_s, jsonize(v)] }.to_h
    else
      val.as_json
    end
  end

  def json_timestamp_regexp
    /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$/
  end
end

Autodoc.configuration.tap do |config|
  config.suppressed_request_header = %w(
    Host
    Content-Length
  )
  config.suppressed_response_header = %w(
    Content-Length
    ETag
    Set-Cookie
    X-Request-Id
    X-Frame-Options
    X-XSS-Protection
    X-Content-Type-Options
    X-Runtime
  )
end

RSpec.configure do |config|
  config.include JsonHelpers, type: :request
  config.include RSpec::JsonMatcher
end
