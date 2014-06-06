require 'net/https'
require 'json'
require 'uri'
require 'librato/metrics'

class PageSpeed 
  def initialize(domain,strategy='desktop',key=ENV['PAGESPEED_API_TOKEN'])
    @domain = domain
    @strategy = strategy
    @key = key
    @url = "https://www.googleapis.com/pagespeedonline/v1/runPagespeed?url=" + \
      URI.encode(@domain) + \
      "&key=#{@key}&strategy=#{@strategy}"
  end

  def get_results
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    JSON.parse(response.body)
  end

  def submit(name, value)
    Librato::Metrics.authenticate "ops@bleacherreport.com", ENV['LIBRATO_TOKEN']
    Librato::Metrics.submit name.to_sym  => {:type => :gauge, :value => value, :source => 'cukebot'}
  end

end
