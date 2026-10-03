local UILWPlayerDetailPage = BaseClass("UILWPlayerDetailPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWPlayerDetailPage:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIPlayerHead, "HeadIcon")
  self.black_mask = self:AddComponent(UIImage, "blackMask")
  self.loadingImg = self:AddComponent(UIImage, "HeadIcon/imgLoading")
  self.icon:SetCustomLoadCallback(function()
    if self.loadingImg then
      self.loadingImg:SetActive(false)
    end
  end)
  self.loadingImg:SetActive(false)
end

function UILWPlayerDetailPage:OnDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.img_loading = nil
  self.icon = nil
  self.black_mask = nil
  base.OnDestroy(self)
end

function UILWPlayerDetailPage:ReInit(pageIndex, pageCount, uid, pic, picVer)
  self.uid = uid
  self.pic = pic or ""
  self.picVer = picVer or 0
  self.pageIndex = pageIndex
  self.pageCount = pageCount
  if (picVer == nil or picVer <= 0 or 1000000 < picVer) and not string.IsNullOrEmpty(pic) then
    self.loadingImg:SetActive(false)
  else
    self.loadingImg:SetActive(true)
  end
  self.icon:SetBigData(uid, pic or "", picVer or 0, true)
  self.rotationValue = Vector3.New(0, 0, (pageCount - pageIndex) * -2)
  self:SetEulerAngles(self.rotationValue)
  self.positionValue = Vector3.New((pageCount - pageIndex) * 4, 0, 0)
  self:SetLocalPosition(self.positionValue)
end

function UILWPlayerDetailPage:UpdateSiblingIndex(index)
  local pageIndex = index + 1
  self.rotationValue = Vector3.New(0, 0, (self.pageCount - pageIndex) * -2)
  self.positionValue = Vector3.New((self.pageCount - pageIndex) * 4, 0, 0)
  self:SetSiblingIndex(index)
  self.pageIndex = pageIndex
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  local curveTime = 0.25
  local seq = DOTween.Sequence()
  seq:Append(self.transform:DOLocalRotate(self.rotationValue, curveTime)):SetEase(CS.DG.Tweening.Ease.Linear)
  seq:Join(self.transform:DOLocalMove(self.positionValue, curveTime)):SetEase(CS.DG.Tweening.Ease.Linear)
  seq:OnComplete(function()
    self.sequence = nil
  end)
  self.sequence = seq
end

function UILWPlayerDetailPage:OnBtnIconClick()
  local isOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SHOW_OTHER_PLAYER_BIG_ICON)
  if 0 < isOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeadIconShow, {anim = true}, self.uid, self.pic, self.picVer)
  else
    UIUtil.ShowTips(Localization:GetString("2700007"))
  end
end

function UILWPlayerDetailPage:ShowBlackMask(duration)
  if duration == nil then
    self.black_mask:SetAlpha(0.5)
  else
    self.black_mask:DOFade(0.5, duration)
  end
end

function UILWPlayerDetailPage:HideBlackMask(duration)
  if duration == nil then
    self.black_mask:SetAlpha(0)
  else
    self.black_mask:DOFade(0, duration)
  end
end

return UILWPlayerDetailPage
