require "net/https"



def botScript
	res = get("/getMe")
	puts res.body
	puts res["result"]

	updateID = 0 #TODO: fix duplicates
	while true
		res = get("/getUpdates") #TODO: parse as JSON
		puts res.body
		sleep 10		
	end
end

private
def get(method)
	uri = URI.parse("#{getUrl}#{method}")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	req = Net::HTTP::Get.new(uri.request_uri)
	http.request(req)
end

def post(method)

end

def getUrl
	apiKey = "185310328:AAGAYHjHL-8-ZA4b-cWz6Bqi_DKywhjJCbA"
	"https://api.telegram.org/bot#{apiKey}"
end