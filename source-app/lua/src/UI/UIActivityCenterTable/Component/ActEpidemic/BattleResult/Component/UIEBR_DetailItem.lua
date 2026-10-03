local UIEBR_DetailItem = BaseClass("UIEBR_DetailItem", UIBaseContainer)
local base = UIBaseContainer

function UIEBR_DetailItem:OnCreate()
  base.OnCreate(self)
  self.selfDataText = self:AddComponent(UITextMeshProUGUIEx, "SelfData")
  self.dataNameText = self:AddComponent(UITextMeshProUGUIEx, "DataName")
  self.otherDataText = self:AddComponent(UITextMeshProUGUIEx, "OtherData")
end

function UIEBR_DetailItem:OnDestroy()
  self.selfDataText = nil
  self.dataNameText = nil
  self.otherDataText = nil
  base.OnDestroy(self)
end

function UIEBR_DetailItem:SetData(data)
  self.selfDataText:SetText(data[1])
  self.dataNameText:SetText(data[2])
  self.otherDataText:SetText(data[3])
end

return UIEBR_DetailItem
