local UICommonPropertyCanFoldItemRow = BaseClass("UICommonPropertyCanFoldItemRow", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UICommonPropertyCanFoldItemRow:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICommonPropertyCanFoldItemRow:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICommonPropertyCanFoldItemRow:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
end

function UICommonPropertyCanFoldItemRow:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
end

function UICommonPropertyCanFoldItemRow:DataDefine()
end

function UICommonPropertyCanFoldItemRow:DataDestroy()
end

function UICommonPropertyCanFoldItemRow:OnBtnClick()
end

function UICommonPropertyCanFoldItemRow:Refresh(data, type)
  self.data = data
  self.name:SetText(data.name)
  self.value:SetText(data.value)
end

return UICommonPropertyCanFoldItemRow
