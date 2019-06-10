require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'User_Ips' do
  explanation 'UserIps resource'
  
  header 'Content-Type', 'application/json'
  
  get '/api/v1/user_ips/groups' do
    explanation 'Get shared IPs'
    
    let(:user1) { create(:user, username: 'John') }
    let(:user2) { create(:user, username: 'Bill') }
    let(:user3) { create(:user, username: 'Sam') }
    
    let(:user_ip1) { create(:user_ip, ip: '10.123.231.19') }
    let(:user_ip2) { create(:user_ip, ip: '10.123.231.20') }
    let(:user_ip3) { create(:user_ip, ip: '10.123.231.21') }
    
    let!(:post1) { create(:post, user: user1, user_ip: user_ip1) }
    let!(:post2) { create(:post, user: user2, user_ip: user_ip1) }
    let!(:post3) { create(:post, user: user2, user_ip: user_ip2) }
    let!(:post4) { create(:post, user: user3, user_ip: user_ip2) }
    let!(:post5) { create(:post, user: user3, user_ip: user_ip3) }
    
    context '200' do
      let(:expected_data) do
        [
          {
            ip: '10.123.231.19',
            users: ['John', 'Bill'],
          },
          {
            ip: '10.123.231.20',
            users: ['Bill', 'Sam'],
          },
        ]
      end
      
      let(:parsed_response) { JSON.parse(response_body, symbolize_names: true) }
      
      example_request 'Shared IPs' do
        expect(status).to eq 200
        expect(parsed_response[:success]).to eq true
        expect(parsed_response[:data]).to contain_exactly(*expected_data)
        expect(parsed_response[:errors]).to be_empty
      end
    end
  end
end