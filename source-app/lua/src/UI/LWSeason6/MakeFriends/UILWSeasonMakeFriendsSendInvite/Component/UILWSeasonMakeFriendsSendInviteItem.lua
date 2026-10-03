local UILWSeasonMakeFriendsSendInviteItem = BaseClass("UILWSeasonMakeFriendsSendInviteItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UILWSeasonMakeFriendsSendInviteItem:OnCreate()
  base.OnCreate(self)
end

function UILWSeasonMakeFriendsSendInviteItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsSendInviteItem:OnEnable()
  base.OnEnable(self)
end

function UILWSeasonMakeFriendsSendInviteItem:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonMakeFriendsSendInviteItem:ReInit(index, dataConfig, dataServer)
end

function UILWSeasonMakeFriendsSendInviteItem:Update1000MS()
end

return UILWSeasonMakeFriendsSendInviteItem
