class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Build list of available OAuth providers based on environment variables
  oauth_providers = []
  oauth_providers << :google_oauth2 if ENV["GOOGLE_CLIENT_ID"].present? && ENV["GOOGLE_CLIENT_SECRET"].present?
  oauth_providers << :github if ENV["GITHUB_CLIENT_ID"].present? && ENV["GITHUB_CLIENT_SECRET"].present?

  if oauth_providers.any?
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable, :omniauthable,
           omniauth_providers: oauth_providers
  else
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable
  end

  validates :name, presence: true, if: -> { provider.present? }

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  def display_name
    name.presence || email.split("@").first
  end

  # Always return available omniauth providers, even when :omniauthable is not included
  def self.omniauth_providers
    oauth_providers = []
    oauth_providers << :google_oauth2 if ENV["GOOGLE_CLIENT_ID"].present? && ENV["GOOGLE_CLIENT_SECRET"].present?
    oauth_providers << :github if ENV["GITHUB_CLIENT_ID"].present? && ENV["GITHUB_CLIENT_SECRET"].present?
    oauth_providers
  end
end
