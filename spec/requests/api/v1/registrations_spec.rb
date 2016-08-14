require 'rails_helper'

describe 'User Registration' do
  let(:headers) { {HTTP_ACCEPT: 'application/json'} }

  describe 'POST /api/v1/auth/' do
    describe 'register a user' do
      it 'with valid sign up returns user & token' do
        post '/api/v1/auth', {params: {email: 'thomas@craftacademy.se',
                              password: 'password',
                              password_confirmation: 'password'},
                              headers: headers}
        expect(response_json['status']).to eq('success')
      end

      it 'with an invalid password confirmation returns error message' do
        post '/api/v1/auth', {params: {email: 'thomas@craftacademy.se',
                              password: 'password',
                              password_confirmation: 'wrong_password'},
                              headers: headers}
        expect(response_json['errors']['password_confirmation']).to eq(['doesn\'t match Password'])
      end

      it 'with an invalid email returns error message' do
        post '/api/v1/auth', {params: {email: 'thomas@craft',
                              password: 'password',
                              password_confirmation: 'password'},
                              headers: headers}
        expect(response_json['errors']['email']).to eq(['is not an email'])
      end

      it 'with an already registered email returns error message' do
        User.create(email: 'thomas@craftacademy.se',
                    password: 'password',
                    password_confirmation: 'password')
        post '/api/v1/auth', {params: {email: 'thomas@craftacademy.se',
                              password: 'password',
                              password_confirmation: 'password'},
                              headers: headers}
        expect(response_json['errors']['email']).to eq(['already in use'])
      end
    end
  end
end
