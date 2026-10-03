local DecorationBookPropertySubItem = BaseClass("DecorationBookPropertySubItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_path = "name"
local value_path = "value"

function DecorationBookPropertySubItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DecorationBookPropertySubItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DecorationBookPropertySubItem:ComponentDefine()
  self.nameText = self:AddComponent(UIText, name_path)
  self.valueText = self:AddComponent(UIText, value_path)
end

function DecorationBookPropertySubItem:ComponentDestroy()
  self.nameText = nil
  self.valueText = nil
end

function DecorationBookPropertySubItem:DataDefine()
end

function DecorationBookPropertySubItem:DataDestroy()
end

function DecorationBookPropertySubItem:SetData(data)
  self.data = data
  self.nameText:SetText(self.data.name)
  self.valueText:SetText(self.data.value)
  if data.isCurLevel then
    self.nameText:SetColorRGBA255(75, 116, 10, 255)
    self.valueText:SetColorRGBA255(75, 116, 10, 255)
  else
    self.nameText:SetColorRGBA255(115, 104, 99, 255)
    self.valueText:SetColorRGBA255(115, 104, 99, 255)
  end
end

return DecorationBookPropertySubItem
