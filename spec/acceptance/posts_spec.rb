require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Post' do
  explanation 'Posts resource'

  header 'Content_Type', 'application/json'

  post '/api/v1/posts' do
    explanation 'Creating a post'

    parameter :username, 'Username', required: true
    parameter :title, 'Post title', required: true
    parameter :body, 'Post body', required: true

    context '200' do
      let(:username) { 'John Dow' }
      let(:title) { 'Lorem Ipsum' }
      let(:body) { 'Lorem Ipsum Dolor Sit Amet' }

      let(:expected_response) do
        {
          success: true,
          data: {
            id: Post.last.id,
            title: 'Lorem Ipsum',
            body: 'Lorem Ipsum Dolor Sit Amet',
            rating: 0.0,
            username: 'John Dow',
            ip: '127.0.0.1',
          },
          errors: [],
        }.to_json
      end

      example_request 'Create post' do
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response)
      end
    end

    context '422' do
      let(:expected_response) do
        {
          success: false,
          data: [],
          errors: ["Title can't be blank", "Body can't be blank", "Username can't be blank"],
        }.to_json
      end

      example_request 'Create post - validation errors' do
        expect(status).to eq(422)
        expect(response_body).to eq(expected_response)
      end
    end
  end

  put '/api/v1/posts/:id/rate' do
    explanation 'Rate a post'

    parameter :rate, 'Rate for post, 1 to 5', required: true, type: :integer

    let(:user) { create(:user, username: 'John Dow') }
    let(:user_ip) { create(:user_ip, ip: '192.168.10.39') }
    let!(:post) do
      create(
          :post,
          user: user,
          user_ip: user_ip,
          title: 'Lorem Ipsum',
          body: 'Lorem Ipsum Dolor Sit Amet',
          rate_total: 10,
          rate_count: 2,
          rating: 5.0,
          )
    end

    context '200' do
      let(:id) { post.id }
      let(:rate) { 2 }

      let(:expected_response) do
        {
          success: true,
          data: {
            id: post.id,
            title: 'Lorem Ipsum',
            body: 'Lorem Ipsum Dolor Sit Amet',
            rating: 4.0,
            username: 'John Dow',
            ip: '192.168.10.39',
          },
          errors: [],
        }.to_json
      end

      example_request 'Rate post' do
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response)
      end
    end

    context '422' do
      let(:id) { post.id }
      let(:rate) { 6 }

      let(:expected_response) do
        {
          success: false,
          data: [],
          errors: ['Rate must be less than or equal to 5'],
        }.to_json
      end

      example_request 'Rate post - validation errors' do
        expect(status).to eq(422)
        expect(response_body).to eq(expected_response)
      end
    end

    context '404' do
      let(:id) { 'xxx' }
      let(:rate) { 5 }

      let(:expected_response) do
        {
          success: false,
          data: [],
          errors: ["Couldn't find Post with 'id'=xxx"],
        }.to_json
      end

      example_request 'Rate post - not found error' do
        expect(status).to eq(404)
        expect(response_body).to eq(expected_response)
      end
    end
  end

  get '/api/v1/posts/top' do
    explanation 'Get top rated posts'

    parameter :count, 'Top %{count} posts', required: true, type: :integer

    let!(:post1) { create(:post, rating: 4.9) }
    let!(:post2) { create(:post, rating: 4.99) }
    let!(:post3) { create(:post, rating: 4.95) }

    context '200' do
      let(:count) { 2 }

      let(:expected_response) do
        {
          success: true,
          data: [post2, post3].map(&:serialize),
          errors: [],
        }.to_json
      end

      example_request 'Top rated posts' do
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response)
      end
    end
  end
end