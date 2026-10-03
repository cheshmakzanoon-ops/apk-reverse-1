local base = UIBaseContainer
local UIActMonopolyEventItem = BaseClass("UIActMonopolyEventItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local event_icon_path = "eventIcon"
local name_path = "Name"
local rate_path = "Rate"

function UIActMonopolyEventItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActMonopolyEventItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyEventItem:ComponentDefine()
  self.event_icon = self:AddComponent(UIImage, event_icon_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.rate = self:AddComponent(UITextMeshProUGUIEx, rate_path)
end

function UIActMonopolyEventItem:ComponentDestroy()
  self.event_icon = nil
  self.name = nil
  self.rate = nil
end

function UIActMonopolyEventItem:DataDefine()
  self.eventId = nil
  self.template = nil
  self.rateNum = nil
end

function UIActMonopolyEventItem:DataDestroy()
  self.eventId = nil
  self.template = nil
  self.rateNum = nil
end

function UIActMonopolyEventItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActMonopolyEventItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActMonopolyEventItem:ReInit(eventId, rateNum)
  self.eventId = eventId
  self.rateNum = rateNum
  self.template = LocalController:instance():getLine(TableName.RichManEvent, self.eventId)
  local imgPath = string.format(UIAssets.UIActMonopolySpritePath, self.template.small_pic)
  self.event_icon:LoadSprite(imgPath)
  self.name:SetLocalText(self.template.name)
  local probabilityStr = string.formatDecimal(rateNum, 2) .. "%"
  self.rate:SetText(probabilityStr)
end

return UIActMonopolyEventItem
