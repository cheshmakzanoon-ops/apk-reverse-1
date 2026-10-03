local base = UIBaseContainer
local ActivityDecorationGachaRulesClassItemComponent = BaseClass("ActivityDecorationGachaRulesClassItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaRulesClassItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaRulesClassItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaRulesClassItemComponent:ComponentDefine()
  self.imgRarity = self:AddComponent(UIImage, "ImgRarity")
  self.textTitle = self:AddComponent(UIText, "TextTitle")
  self.textValue = self:AddComponent(UIText, "TextValue")
end

function ActivityDecorationGachaRulesClassItemComponent:ComponentDestroy()
  self.imgRarity = nil
  self.textTitle = nil
  self.textValue = nil
end

function ActivityDecorationGachaRulesClassItemComponent:DataDefine()
end

function ActivityDecorationGachaRulesClassItemComponent:DataDestroy()
end

function ActivityDecorationGachaRulesClassItemComponent:ReInit(activityId, quality)
  self.imgRarity:LoadSprite(DataCenter.ActivityDecorationGachaManager:GetDecorationQualityIconImagePath(quality))
  self.textTitle:SetText(DataCenter.ActivityDecorationGachaManager:GetDecorationQualityName(quality))
  local value = DataCenter.ActivityDecorationGachaManager:GetDecorationQualityTotalProbability(activityId, quality)
  local valueStr = string.formatDecimal(value / 100, 2) .. "%"
  self.textValue:SetText(valueStr)
end

function ActivityDecorationGachaRulesClassItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaRulesClassItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return ActivityDecorationGachaRulesClassItemComponent
