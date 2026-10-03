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
  self.bg = self:AddComponent(UIImage, "")
end

function UIHeroPropertyCell:ComponentDestroy()
end

function UIHeroPropertyCell:DataDefine()
end

function UIHeroPropertyCell:DataDestroy()
end

function UIHeroPropertyCell:Refresh(param, showBg)
  self.nameTxt:SetText(param.name)
  self.valueTxt:SetText(string.GetFormattedSeparatorNum(param.value))
  if showBg then
    self.bg:SetEnable(true)
  else
    self.bg:SetEnable(false)
  end
end

return UIHeroPropertyCell
