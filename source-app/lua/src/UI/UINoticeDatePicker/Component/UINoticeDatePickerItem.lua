local UINoticeDatePickerItem = BaseClass("UINoticeDatePickerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local txt_path = "txt"

function UINoticeDatePickerItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UINoticeDatePickerItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UINoticeDatePickerItem:ComponentDefine()
  self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
end

function UINoticeDatePickerItem:ComponentDestroy()
  self.txt = nil
end

function UINoticeDatePickerItem:DataDefine()
end

function UINoticeDatePickerItem:DataDestroy()
end

function UINoticeDatePickerItem:SetData(str)
  self.txt:SetText(str)
end

return UINoticeDatePickerItem
