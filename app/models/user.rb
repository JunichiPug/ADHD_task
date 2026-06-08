class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :routines
  has_many :memos

  # Google認証情報から既存ユーザーを探す／無ければ作成する。
  # 同じメールの既存（パスワード）ユーザーがいればそのアカウントに紐付ける。
  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid) ||
           find_by(email: auth.info.email)

    user ||= new(email: auth.info.email, password: Devise.friendly_token[0, 20])
    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name if user.name.blank?
    user.save
    user
  end
end
