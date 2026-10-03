local UICD_ScheduleFinalBg = BaseClass("UICD_ScheduleFinalBg", UIBaseContainer)
local base = UIBaseContainer
local img_bg_path = "ImgBg"
local img_down_path = "ImgDown"

function UICD_ScheduleFinalBg:OnCreate()
  base.OnCreate(self)
  self.bInit = false
  self.img_bg = self:AddComponent(UIRawImage, img_bg_path)
  self.img_down = self:AddComponent(UIImage, img_down_path)
end

function UICD_ScheduleFinalBg:OnDestroy()
  self.bInit = false
  self.img_bg = nil
  self.img_down = nil
  base.OnDestroy(self)
end

function UICD_ScheduleFinalBg:SetFixSize(fixX)
  if self.bInit then
    return
  end
  self.bInit = true
  local bgSize = self.img_bg:GetSizeDelta()
  local bgX = bgSize.x
  local bgY = bgSize.y
  local scale = fixX / bgX
  self.img_bg:SetLocalScaleXYZ(scale, scale, scale)
  local right, top = self.img_down:GetOffsetMaxXY()
  top = -(scale - 0.1) * bgY
  self.img_down:SetOffsetMaxXY(right, top)
end

return UICD_ScheduleFinalBg
