local UILWSeasonMakeFriendsPopupItem = BaseClass("UILWSeasonMakeFriendsPopupItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function UILWSeasonMakeFriendsPopupItem:OnCreate()
  base.OnCreate(self)
end

function UILWSeasonMakeFriendsPopupItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsPopupItem:OnEnable()
  base.OnEnable(self)
end

function UILWSeasonMakeFriendsPopupItem:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonMakeFriendsPopupItem:ReInit(index, dataConfig, dataServer)
end

function UILWSeasonMakeFriendsPopupItem:Update1000MS()
end

return UILWSeasonMakeFriendsPopupItem
