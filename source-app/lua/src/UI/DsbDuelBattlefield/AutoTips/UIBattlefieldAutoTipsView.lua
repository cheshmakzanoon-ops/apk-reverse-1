local UIBattlefieldAutoTipsView = BaseClass("UIBattlefieldAutoTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBattlefieldAutoTipsView:OnCreate()
  base.OnCreate(self)
  self:InitBase()
  local param = self:GetUserData()
  if not param then
    return
  end
  self.pos = param.pos
  self.offset = param.offset or Vector2.zero
  self.vertical = param.vertical or BattlefieldTipsVertical.Auto
end

function UIBattlefieldAutoTipsView:InitBase()
  self.mainContent = self:AddComponent(UIBaseContainer, "Content")
  self.btnBg = self:AddComponent(UIButton, "Panel")
  self.btnBg:SetOnClick(function()
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end)
  self.topArrow = self:AddComponent(UIBaseContainer, "Content/ImgTopArrow")
  self.bottomArrow = self:AddComponent(UIBaseContainer, "Content/ImgBottomArrow")
  self.topArrow:SetActive(false)
  self.bottomArrow:SetActive(false)
end

function UIBattlefieldAutoTipsView:OnDestroy()
  base.OnDestroy(self)
end

function UIBattlefieldAutoTipsView:OnEnable()
  base.OnEnable(self)
end

function UIBattlefieldAutoTipsView:OnDisable()
  base.OnDisable(self)
end

function UIBattlefieldAutoTipsView:SetDirty()
  if not self.mainContent then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mainContent.rectTransform)
  local width, height = self.mainContent:GetSizeDeltaXY()
  local halfContentWidth = width * 0.5
  local halfContentHeight = height * 0.5
  local halfWidth = self.rectTransform.rect.width * 0.5
  local halfHeight = self.rectTransform.rect.height * 0.5
  self.mainContent:SetPositionXYZ(self.pos.x, self.pos.y, 0)
  local anchoredPosition = self.mainContent:GetAnchoredPosition()
  anchoredPosition = anchoredPosition + self.offset
  local contentPosX = anchoredPosition.x
  local contentPosY = anchoredPosition.y
  local safeGap = 10
  if anchoredPosition.x > 0 then
    if anchoredPosition.x + halfContentWidth > halfWidth - safeGap then
      contentPosX = halfWidth - safeGap - halfContentWidth
    else
      contentPosX = anchoredPosition.x
    end
  elseif anchoredPosition.x - halfContentWidth < -(halfWidth - safeGap) then
    contentPosX = -(halfWidth - safeGap) + halfContentWidth
  else
    contentPosX = anchoredPosition.x
  end
  local showArrowUp = false
  if (anchoredPosition.y > 0 or self.vertical == BattlefieldTipsVertical.Down) and self.vertical ~= BattlefieldTipsVertical.Up then
    contentPosY = anchoredPosition.y - halfContentHeight
    showArrowUp = true
  else
    contentPosY = anchoredPosition.y + halfContentHeight
  end
  local arrowOffset = anchoredPosition.x - contentPosX
  arrowOffset = Mathf.Clamp(arrowOffset, -halfContentWidth * 0.9, halfContentWidth * 0.9)
  if showArrowUp then
    self.topArrow:SetActive(true)
    self.bottomArrow:SetActive(false)
    self.topArrow:SetAnchoredPositionXY(arrowOffset, 0)
  else
    self.topArrow:SetActive(false)
    self.bottomArrow:SetActive(true)
    self.bottomArrow:SetAnchoredPositionXY(arrowOffset, 0)
  end
  self.mainContent:SetAnchoredPositionXY(contentPosX, contentPosY)
end

return UIBattlefieldAutoTipsView
