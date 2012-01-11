class Ability
  include CanCan::Ability

  def initialize(user)
    
    
      can :read, :all
      can :create, IosApplication
      can :manage, IosApplication do |ios_application| 
        ios_application.user.nil? || ios_application.user == user
      end

  end
end
