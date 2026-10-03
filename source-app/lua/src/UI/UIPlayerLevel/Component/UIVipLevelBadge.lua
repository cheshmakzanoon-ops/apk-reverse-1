local UIVipLevelBadge = BaseClass("UIVipLevelBadge", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "imgBg/txtLevel",
    name = "txtLevel",
    type = UIText
  },
  {
    path = "imgBg/imgGlow",
    name = "imgGlow",
    type = UIBaseContainer
  }
}
local posX = 100

local function __KillGlowAnimTween(self)
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

local function __StartGlowAnimTween(self)
  if self.sequence then
    return
  end
  self.imgGlow:SetAnchoredPositionXY(-posX, 0)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:AppendInterval(3)
  local endPosX = posX * CommonUtil.ArabicAutoMirrorFactor()
  sequence:Append(self.imgGlow.transform:DOAnchorPosX(endPosX, 1):SetEase(CS.DG.Tweening.Ease.Linear))
  sequence:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  self.sequence = sequence
end

function UIVipLevelBadge:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIVipLevelBadge:OnDestroy()
  __KillGlowAnimTween(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVipLevelBadge:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIVipLevelBadge:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIVipLevelBadge:SetVipLevel(vipLevel)
  vipLevel = vipLevel or 0
  self.txtLevel:SetText("VIP " .. vipLevel)
end

function UIVipLevelBadge:SetGlowEnable(enable)
  if enable then
    self.imgGlow:SetActive(true)
    __StartGlowAnimTween(self)
  else
    __KillGlowAnimTween(self)
    self.imgGlow:SetActive(false)
  end
end

return UIVipLevelBadge
