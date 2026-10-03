local base = UIBaseContainer
local MilitaryPreviewReward = BaseClass("MilitaryPreviewReward", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function MilitaryPreviewReward:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MilitaryPreviewReward:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MilitaryPreviewReward:ComponentDefine()
  self.UICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
end

function MilitaryPreviewReward:ComponentDestroy()
  self.UICommonResItem = nil
end

function MilitaryPreviewReward:DataDefine()
end

function MilitaryPreviewReward:DataDestroy()
end

function MilitaryPreviewReward:OnAddListener()
  base.OnAddListener(self)
end

function MilitaryPreviewReward:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MilitaryPreviewReward:ReInit(param)
  self.UICommonResItem:ReInit(param)
end

return MilitaryPreviewReward
