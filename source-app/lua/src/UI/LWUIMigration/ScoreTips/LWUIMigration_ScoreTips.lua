local LWUIMigration_ScoreTips = BaseClass("LWUIMigration_ScoreTips", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function LWUIMigration_ScoreTips:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUIMigration_ScoreTips:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_ScoreTips:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compImgTopArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compImgBottomArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compImgTopArrow:SetActive(false)
  self.compImgBottomArrow:SetActive(false)
  local tranContent = self.compContent.transform
  local pathLst = {
    "ItemMember",
    "ItemPower",
    "ItemGift",
    "ItemActivity"
  }
  local ids = {
    "alliance_invite_point_member",
    "alliance_invite_point_power",
    "alliance_invite_point_gift",
    "alliance_invite_point_activity"
  }
  for i = 1, 4 do
    local tmpName = string.format("%s/TmpName", pathLst[i])
    local tmpValue = string.format("%s/TmpScore", pathLst[i])
    local nameKey = ids[i] or ""
    UIUtil.SetTextLit(tranContent, tmpName, ids[i])
    local val = self.scores and self.scores[i] or 0
    local sVal = string.format("%.1f", val)
    UIUtil.SetTextRaw(tranContent, tmpValue, sVal)
  end
  self:RefreshLayout()
end

function LWUIMigration_ScoreTips:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.compImgTopArrow = nil
  self.compImgBottomArrow = nil
  self.compContent = nil
end

function LWUIMigration_ScoreTips:DataDefine()
  local param = self:GetUserData()
  self.pos = param.position
  self.offset = param.offset or {}
  self.scores = param.scores or {}
end

function LWUIMigration_ScoreTips:DataDestroy()
end

function LWUIMigration_ScoreTips:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigration_ScoreTips:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIMigration_ScoreTips:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIMigration_ScoreTips:RefreshLayout()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.rectTransform)
  local width, height = self.compContent:GetSizeDeltaXY()
  local halfContentWidth = width * 0.5
  local halfContentHeight = height * 0.5
  local halfWidth = self.rectTransform.rect.width * 0.5
  local halfHeight = self.rectTransform.rect.height * 0.5
  self.compContent:SetPositionXYZ(self.pos.x, self.pos.y, 0)
  local anchoredPosition = self.compContent:GetAnchoredPosition()
  local contentPosX = anchoredPosition.x
  local contentPosY = anchoredPosition.y
  local safeGap = 10
  local offsetLeft = self.offset[1] or 0
  local offsetRight = self.offset[2] or 0
  local offsetUp = self.offset[3] or 0
  local offsetDown = self.offset[4] or 0
  if anchoredPosition.x > 0 then
    if anchoredPosition.x + halfContentWidth > halfWidth - safeGap then
      contentPosX = halfWidth - safeGap - halfContentWidth
    else
      contentPosX = anchoredPosition.x
    end
    contentPosX = contentPosX + offsetRight
  else
    if anchoredPosition.x - halfContentWidth < -(halfWidth - safeGap) then
      contentPosX = -(halfWidth - safeGap) + halfContentWidth
    else
      contentPosX = anchoredPosition.x
    end
    contentPosX = contentPosX + offsetLeft
  end
  local showArrowUp = false
  if anchoredPosition.y > 0 then
    contentPosY = anchoredPosition.y - halfContentHeight
    showArrowUp = true
    contentPosY = contentPosY + offsetUp
  else
    contentPosY = anchoredPosition.y + halfContentHeight
    contentPosY = contentPosY + offsetDown
  end
  local arrowOffset = anchoredPosition.x - contentPosX
  arrowOffset = Mathf.Clamp(arrowOffset, -halfContentWidth * 0.9, halfContentWidth * 0.9)
  if showArrowUp then
    self.compImgTopArrow:SetActive(true)
    self.compImgBottomArrow:SetActive(false)
    self.compImgTopArrow:SetAnchoredPositionXY(arrowOffset, 0)
  else
    self.compImgTopArrow:SetActive(false)
    self.compImgBottomArrow:SetActive(true)
    self.compImgBottomArrow:SetAnchoredPositionXY(arrowOffset, 0)
  end
  self.compContent:SetAnchoredPositionXY(contentPosX, contentPosY)
end

return LWUIMigration_ScoreTips
