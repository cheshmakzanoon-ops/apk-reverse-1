local base = UIBaseContainer
local UIActMonopolyRulesEventItem = BaseClass("UIActMonopolyRulesEventItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIActMonopolyRulesEventItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActMonopolyRulesEventItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyRulesEventItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "Icon")
  self.textProbability = self:AddComponent(UIText, "HaveContent/ProbabilityText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIActMonopolyRulesEventItem:ComponentDestroy()
  self.icon = nil
  self.textProbability = nil
  self.btn = nil
end

function UIActMonopolyRulesEventItem:DataDefine()
end

function UIActMonopolyRulesEventItem:DataDestroy()
end

function UIActMonopolyRulesEventItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActMonopolyRulesEventItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActMonopolyRulesEventItem:ReInit(activityId, template)
  if template == nil then
    return
  end
  self.template = template
  local eventTemp = LocalController:instance():getLine(TableName.RichManEvent, template.para1)
  if eventTemp then
    local imgPath = string.format(UIAssets.UIActMonopolySpritePath, eventTemp.small_pic)
    self.icon:LoadSprite(imgPath)
  end
  local probabilityStr = string.formatDecimal(template.drop_show / 100, 2) .. "%"
  self.textProbability:SetText(probabilityStr)
end

function UIActMonopolyRulesEventItem:OnBtnClick()
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

return UIActMonopolyRulesEventItem
