local UILWSeasonMakeFriendsDetailCDItem = BaseClass("UILWSeasonMakeFriendsDetailCDItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function UILWSeasonMakeFriendsDetailCDItem:OnCreate()
  base.OnCreate(self)
end

function UILWSeasonMakeFriendsDetailCDItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsDetailCDItem:OnEnable()
  base.OnEnable(self)
end

function UILWSeasonMakeFriendsDetailCDItem:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonMakeFriendsDetailCDItem:ReInit(index, dataConfig, dataServer)
end

function UILWSeasonMakeFriendsDetailCDItem:Update1000MS()
end

return UILWSeasonMakeFriendsDetailCDItem
