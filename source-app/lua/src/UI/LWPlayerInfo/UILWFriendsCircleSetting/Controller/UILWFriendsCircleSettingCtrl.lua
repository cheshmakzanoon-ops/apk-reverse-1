local UILWFriendsCircleSettingCtrl = BaseClass("UILWFriendsCircleSettingCtrl", UIBaseCtrl)
local SettingConfig = {
  {
    name = "",
    text = "moment_set_item1_title",
    des = "moment_set_item1_des",
    type = FriendsCirleSettingType.Comment
  },
  {
    name = "",
    text = "moment_set_item3_title",
    des = "moment_set_item3_des",
    type = FriendsCirleSettingType.AllianceMoment
  }
}

function UILWFriendsCircleSettingCtrl:GetFriendsCircleSetting(playerUid)
  local data = UIUtil.GetPlayerInfoShowByUid(playerUid)
  local config = DeepCopy(SettingConfig)
  for i = 1, #config do
    if config[i].type == FriendsCirleSettingType.Comment then
      config[i].isOn = data.friendsCircleCommentIsOn
    elseif config[i].type == FriendsCirleSettingType.AllianceMoment then
      config[i].isOn = data.friendsCircleAllianceMomentIsOn
    end
  end
  return config
end

function UILWFriendsCircleSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIFriendsCircleSetting)
end

return UILWFriendsCircleSettingCtrl
