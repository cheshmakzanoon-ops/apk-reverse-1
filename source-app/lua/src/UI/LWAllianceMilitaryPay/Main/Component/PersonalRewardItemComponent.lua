local base = UIBaseContainer
local PersonalRewardItemComponent = BaseClass("PersonalRewardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function PersonalRewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PersonalRewardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PersonalRewardItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.UICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
end

function PersonalRewardItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.UICommonResItem = nil
end

function PersonalRewardItemComponent:DataDefine()
end

function PersonalRewardItemComponent:DataDestroy()
end

function PersonalRewardItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function PersonalRewardItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return PersonalRewardItemComponent
