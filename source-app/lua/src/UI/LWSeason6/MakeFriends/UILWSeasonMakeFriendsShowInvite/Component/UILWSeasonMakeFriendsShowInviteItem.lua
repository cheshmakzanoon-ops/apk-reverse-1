local UILWSeasonMakeFriendsShowInviteItem = BaseClass("UILWSeasonMakeFriendsShowInviteItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UILWSeasonMakeFriendsShowInviteItem:OnCreate()
  base.OnCreate(self)
end

function UILWSeasonMakeFriendsShowInviteItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsShowInviteItem:OnEnable()
  base.OnEnable(self)
end

function UILWSeasonMakeFriendsShowInviteItem:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonMakeFriendsShowInviteItem:ReInit(index, dataConfig, dataServer)
end

function UILWSeasonMakeFriendsShowInviteItem:Update1000MS()
end

return UILWSeasonMakeFriendsShowInviteItem
