local base = UIBaseContainer
local MilitaryPayRewardItem = BaseClass("MilitaryPayRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function MilitaryPayRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MilitaryPayRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MilitaryPayRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.UICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
end

function MilitaryPayRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.UICommonResItem = nil
end

function MilitaryPayRewardItem:DataDefine()
end

function MilitaryPayRewardItem:DataDestroy()
end

function MilitaryPayRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function MilitaryPayRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MilitaryPayRewardItem:ReInit(param)
  self.UICommonResItem:ReInit(param)
end

return MilitaryPayRewardItem
