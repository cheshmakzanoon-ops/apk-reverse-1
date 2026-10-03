local base = UIBaseContainer
local LWUIMigration_TabBase = BaseClass("LWUIMigration_TabBase", UIBaseContainer)

function LWUIMigration_TabBase:OnCreate()
  base.OnCreate(self)
  self.mvHide = false
end

function LWUIMigration_TabBase:OnDestroy()
  base.OnDestroy(self)
  self.mvHide = false
end

function LWUIMigration_TabBase:DoHideSelf()
  self:SetAnchoredPositionXY(0, -99999)
  self.mvHide = true
end

function LWUIMigration_TabBase:SetData(param)
  self:SetAnchoredPositionXY(0, 0)
  self.mvHide = false
end

function LWUIMigration_TabBase:IsMvHide()
  return self.mvHide
end

return LWUIMigration_TabBase
