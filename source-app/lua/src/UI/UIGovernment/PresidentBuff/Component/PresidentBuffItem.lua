local PresidentBuffItem = BaseClass("PresidentBuffItem", UIBaseContainer)
local base = UIBaseContainer
local eff_path = "Content/eff"
local value_path = "Content/value"
local line_path = "line"

function PresidentBuffItem:OnCreate()
  base.OnCreate(self)
  self.eff = self:AddComponent(UIText, eff_path)
  self.value = self:AddComponent(UIText, value_path)
  self.line = self:AddComponent(UIImage, line_path)
end

function PresidentBuffItem:OnDestroy()
  base.OnDestroy(self)
end

function PresidentBuffItem:ReInit(effectName, buffAddNum)
  self.eff:SetLocalText(effectName)
  self.value:SetText(buffAddNum)
  self.line:SetActive(true)
end

function PresidentBuffItem:HideLine()
  self.line:SetActive(false)
end

return PresidentBuffItem
