module JsonHelpers
  def response_json
    @json ||= JSON.parse(response.body)
  end

  def jsonize(val)
    case val
    when Array
      val.map{|v| jsonize(val) }
    when Hash
      val.map{|k, v| [k, jsonize(v)] }.to_h
    else
      val.as_json
    end
  end
end

RSpec.configure do |config|
  config.include JsonHelpers, type: :request
end
