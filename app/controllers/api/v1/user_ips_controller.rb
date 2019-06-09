class Api::UserIpsController < Api::V1::BaseController
  def groups
    groups = UserIp.groups.preload(:users)
    render_success(groups.to_a)
  end
end