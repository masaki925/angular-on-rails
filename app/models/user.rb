class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications


  def fetch_fb_info( access_token )
    provider = 'facebook'

    fbuser = FbGraph::User.fetch(self.username, :access_token => access_token.token)

    # save fb usename, token, birthday, work, education...
    # default mapping: username = fbid (because user may not have username)
    if fbuser.username && !fbuser.username.empty?
      self.username = fbuser.username
    end

    refresh_token!( provider, access_token )
    refresh_permissions!( provider, fbuser.permissions.join(",") )

    self.introduction = fbuser.bio
    self.birthday     = fbuser.birthday

    if fbuser.education.length > 0
      self.education = fbuser.education[0].school.name
    end

    if fbuser.work.length > 0
      self.work = fbuser.work[0].employer.name
    end

    if fbuser.location
      locs = fbuser.location.name.split(', ')
      if locs.length >= 2
        country_name = locs[locs.length-1]
        country = Country.where( "name LIKE ?", "%#{country_name}%" ).first
        if country
          self.country_code = country.country_code
        end
      end
    end

    ## update list invitation
    #ListInvitation.where(provider_user_id: fbuser.identifier).each do |invitation|
    #  invitation.update(invited_user_id: self.id)
    #end
  end

  def active?
    self.deleted_at.nil?
  end

  def refresh_token!( provider, access_token )
    if auth = provider_auth( provider )
      auth.update_attributes( access_token: access_token.token )
    end
  end

  def refresh_permissions!( provider, permissions )
    if auth = provider_auth( provider )
      auth.update_attributes( permissions: permissions )
    end
  end

  def provider_auth( provider )
    self.authentications.where( provider: provider ).first
  end

end

