local UIHeroPropertyCell = BaseClass("UIHeroPropertyCell", UIBaseContainer)
local base = UIBaseContainer

function UIHeroPropertyCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroPropertyCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIHeroPropertyCell:OnEnable()
  base.OnEnable(self)
end

function UIHeroPropertyCell:OnDisable()
  base.OnDisable(self)
end

function UIHeroPropertyCell:ComponentDefine()
  self.nameTxt = self:AddComponent(UIText, "Name")
  self.valueTxt = self:AddComponent(UIText, "Value")
end

function UIHeroPropertyCell:ComponentDestroy()
end

function UIHeroPropertyCell:DataDefine()
end

function UIHeroPropertyCell:DataDestroy()
end

function UIHeroPropertyCell:Refresh(param)
  self.nameTxt:SetText(param.name)
  self.valueTxt:SetText(string.GetFormattedSeparatorNum(param.value))
  local height = param.height or 33
  local size = self.nameTxt:GetSizeDelta()
  self.nameTxt:SetSizeDeltaXY(size.x, height)
  size = self.valueTxt:GetSizeDelta()
  self.valueTxt:SetSizeDeltaXY(size.x, height)
end

return UIHeroPropertyCell
