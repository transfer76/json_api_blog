require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Post" do
  explanation 'Posts resource'

  header "Content_Type", "application/json"

  post "/api/v1/posts" do
    explanation "Creating a post"

    parameter :username, 'Username', required: true
    parameter :title, 'Post title', required: true
    parameter :body, 'Post body', required: true

    context "200" do
      let(:username) { "John Dow" }
      let(:title) { "Lorem Ipsum" }
      let(:body) { "Lorem Ipsum Dolor Sit Amet" }

      let(:expected_response) do
        {
            success: true,
            data: {
                id: Post.last.id,
                title: "Lorem Ipsum",
                body: "Lorem Ipsum Dolor Sit Amet",
                rating: 0.0,
                username: "John Dow",
                ip: "127.0.0.1",
            },
            errors: [],
        }.to_json
      end

      example_request "Create post" do
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response)
      end
    end

    context "422" do
      let(:expected_response) do
        {
            success: false,
            data: [],
            errors: ["Title can't be blank", "Body can't be blank", "Username can't be blank"],
        }.to_json
      end

      example_request "Create post - validation errors" do
        expect(status).to eq(422)
        expect(response_body).to eq(expected_response)
      end
    end
  end
end