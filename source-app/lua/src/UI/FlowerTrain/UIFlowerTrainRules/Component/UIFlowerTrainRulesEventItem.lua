local base = UIBaseContainer
local UIFlowerTrainRulesEventItem = BaseClass("UIFlowerTrainRulesEventItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIFlowerTrainRulesEventItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFlowerTrainRulesEventItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainRulesEventItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "Icon")
  self.textProbability = self:AddComponent(UIText, "HaveContent/ProbabilityText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIFlowerTrainRulesEventItem:ComponentDestroy()
  self.icon = nil
  self.textProbability = nil
  self.btn = nil
end

function UIFlowerTrainRulesEventItem:DataDefine()
end

function UIFlowerTrainRulesEventItem:DataDestroy()
end

function UIFlowerTrainRulesEventItem:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainRulesEventItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainRulesEventItem:ReInit(activityId, template)
  if template == nil then
    return
  end
  self.template = template
  local eventTemp = LocalController:instance():getLine(TableName.RichManEvent, template.para1)
  if eventTemp then
    local imgPath = string.format(UIAssets.UIActMonopolySpritePath, eventTemp.small_pic)
    self.icon:LoadSpriteAsync(imgPath)
  end
  local probabilityStr = string.formatDecimal(template.drop_show / 100, 2) .. "%"
  self.textProbability:SetText(probabilityStr)
end

function UIFlowerTrainRulesEventItem:OnBtnClick()
  if self.template == nil then
    return
  end
  local eventTemp = LocalController:instance():getLine(TableName.RichManEvent, self.template.para1)
  local param = {}
  param.type = "nameDesc"
  param.title = eventTemp.name
  param.desc = eventTemp.desc
  param.alignObject = self.icon
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

return UIFlowerTrainRulesEventItem
