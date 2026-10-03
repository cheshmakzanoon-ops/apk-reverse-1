local UIBrazilAgeVerifyView = BaseClass("UIBrazilAgeVerifyView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBrazilAgeVerifyView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Update1000MS()
  CS.PrivacyBrazil.Instance:Brazil_UpdateAccountInfo()
end

function UIBrazilAgeVerifyView:OnDestroy()
  CS.PrivacyBrazil.Instance:StopAgeVerificationPolling()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBrazilAgeVerifyView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLWClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.btnResend = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnResend:SetOnClick(function()
    self:OnBtnLWCommonNewClick()
  end)
  self.titleText = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/TextTitle")
  self.titleText:SetLocalText("kid_verification_title")
  self.parentText = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/TextParent")
  if CoppaUtil.IsUncertifiedCoppaState() then
    self.parentText:SetLocalText("kid_verification_desc2")
  else
    self.parentText:SetLocalText("kid_verification_desc")
  end
  self.textResend = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/GoBtn1/LW_Btn_Common_New/LW_Btn_Common_New_Base/BtnText")
  self.textResend:SetLocalText("kid_verification_btn01")
end

function UIBrazilAgeVerifyView:ComponentDestroy()
  self.viewSkin = nil
  self.btnLWClose = nil
  self.btnResend = nil
end

function UIBrazilAgeVerifyView:DataDefine()
end

function UIBrazilAgeVerifyView:DataDestroy()
end

function UIBrazilAgeVerifyView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIPrivacy_Confirm, self.UpdateBrazilPrivacy)
end

function UIBrazilAgeVerifyView:OnRemoveListener()
  self:RemoveUIListener(EventId.UIPrivacy_Confirm, self.UpdateBrazilPrivacy)
  base.OnRemoveListener(self)
end

function UIBrazilAgeVerifyView:UpdateBrazilPrivacy()
  if CS.PrivacyBrazil.Instance:IsAgeVerified() then
    UIUtil.ShowTipsId("kid_verification_success")
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end
end

function UIBrazilAgeVerifyView:OnBtnLWCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIBrazilAgeVerifyView:Update1000MS()
  local expireTime = Setting:GetPrivateString("BrazilAgeVerifyExpireTime", "")
  if string.IsNullOrEmpty(expireTime) then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local eTime = tonumber(expireTime)
  if now > eTime then
    CS.UIGray.SetGray(self.btnResend.transform, false, true)
    self.textResend:SetLocalText("kid_verification_btn01")
    return
  end
  local leftTime = eTime - now
  leftTime = math.floor(leftTime / 1000)
  CS.UIGray.SetGray(self.btnResend.transform, true, false)
  local secTime = Localization:GetString("120952") .. string.format("(%ds)", leftTime)
  self.textResend:SetText(secTime)
end

function UIBrazilAgeVerifyView:OnBtnLWCommonNewClick()
  if CoppaUtil.IsUncertifiedCoppaState() then
    CoppaUtil.OpenVerifyDialog()
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  else
    local now = UITimeManager:GetInstance():GetServerTime()
    local cooldown = 70000
    local newExpireTime = now + cooldown
    Setting:SetPrivateString("BrazilAgeVerifyExpireTime", tostring(newExpireTime))
    CS.UIGray.SetGray(self.btnResend.transform, true, false)
    CS.PrivacyBrazil.Instance:Brazil_DoAgeVerification()
  end
end

return UIBrazilAgeVerifyView
