class JsonPlaceholderService
  BASE_URL = "https://jsonplaceholder.typicode.com"

  def initialize
    @client = HTTP.timeout(connect: 5, read: 5)
                  .headers("Content-Type" => "application/json")
  end

  def get_post(post_id)
    response = @client.get("#{BASE_URL}/posts/#{post_id}")
    parse_response(response)
  end

  def get_all_posts
    response = @client.get("#{BASE_URL}/posts")
    parse_response(response)
  end

  def create_post(title:, body:, user_id:)
    payload = { title: title, body: body, userId: user_id }
    response = @client.post("#{BASE_URL}/posts", json: payload)
    parse_response(response)
  end

  private

  def parse_response(response)
    if response.status.success?
      JSON.parse(response.body.to_s)
    else
      { "error" => "API call failed", "status" => response.status.to_i }
    end
  end

end