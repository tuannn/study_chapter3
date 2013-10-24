# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
#StudyChapter3::Application.config.secret_token = '77902746420d50872d7e5d1470ba0bd0a363a2040bc0f27826f8b1f66bb1f775ce8a49a576352538e33e71f078a5da46261be4174848365f1fb98663fdcfb7be'
def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

StudyChapter3::Application.config.secret_key_base = secure_token