local base = UIBaseContainer
local ActivityDecorationGachaRulesDecorationItemComponent = BaseClass("ActivityDecorationGachaRulesDecorationItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaRulesDecorationItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaRulesDecorationItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaRulesDecorationItemComponent:ComponentDefine()
  self.imgBG = self:AddComponent(UIImage, "BG")
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.textLevel = self:AddComponent(UIText, "LevelText")
  self.textLv = self:AddComponent(UIText, "HaveContent/Lv")
  self.textProbability = self:AddComponent(UIText, "HaveContent/ProbabilityText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function ActivityDecorationGachaRulesDecorationItemComponent:ComponentDestroy()
  self.imgBG = nil
  self.imgIcon = nil
  self.textLv = nil
  self.textProbability = nil
  self.btn = nil
  self.textLevel = nil
end

function ActivityDecorationGachaRulesDecorationItemComponent:DataDefine()
end

function ActivityDecorationGachaRulesDecorationItemComponent:DataDestroy()
end

function ActivityDecorationGachaRulesDecorationItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaRulesDecorationItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaRulesDecorationItemComponent:ReInit(activityId, template)
  if template == nil then
    return
  end
  self.template = template
  local baseImage = template:GetDecorationBaseImage()
  if baseImage ~= nil then
    self.imgBG:LoadSprite(baseImage)
  end
  local image = template:GetDecorationImage()
  self.imgIcon:LoadSprite(image)
  self.textLv:SetText(tostring(template.num))
  local probabilityStr = string.formatDecimal(template.dropShow / 100, 2) .. "%"
  self.textProbability:SetText(probabilityStr)
  if self.template.decorationBuildingTemplate ~= nil then
    self.textLevel:SetText("Lv." .. tostring(self.template.decorationBuildingTemplate.level))
  end
end

function ActivityDecorationGachaRulesDecorationItemComponent:OnBtnClick()
  if self.template == nil then
    return
  end
  if self.template.decorationBuildingBaseId <= 0 then
    return
  end
  local param = {}
  param.baseBuildingId = self.template.decorationBuildingBaseId
  param.alignObject = self.btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
end

return ActivityDecorationGachaRulesDecorationItemComponent
