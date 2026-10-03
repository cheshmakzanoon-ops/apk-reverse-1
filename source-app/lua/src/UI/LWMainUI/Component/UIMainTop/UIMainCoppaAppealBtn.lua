local UIMainCoppaAppealBtn = BaseClass("UIMainCoppaAppealBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local verify_image_go_path = "ImageVerify"
local limit_image_go_path = "ImageLimit"
local time_bg_go_path = "TimeBg"
local name_text_path = "NameText"

function UIMainCoppaAppealBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainCoppaAppealBtn:OnDestroy()
  self:ComponentDestroy()
  self:RemoveTimer()
  base.OnDestroy(self)
end

function UIMainCoppaAppealBtn:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.verify_image = self:AddComponent(UIBaseContainer, verify_image_go_path)
  self.limit_image = self:AddComponent(UIBaseContainer, limit_image_go_path)
  self.time_bg = self:AddComponent(UIBaseContainer, time_bg_go_path)
  self.time_bg:SetActive(false)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIMainCoppaAppealBtn:ComponentDestroy()
  self.btn = nil
  self.name_text = nil
end

function UIMainCoppaAppealBtn:ReInit()
end

function UIMainCoppaAppealBtn:Refresh()
  if CS.PrivacyBrazil.Instance:IsBrazil() and CS.PrivacyBrazil.Instance:IsAgeVerifiedSwitchOn() and not CS.PrivacyBrazil.Instance:IsAgeVerified() then
    self.verify_image:SetActive(false)
    self.limit_image:SetActive(true)
    self.name_text:SetLocalText("kid_verification_title")
    self:RemoveTimer()
    return
  end
  if CoppaUtil.CanAppeal() then
    self.verify_image:SetActive(false)
    self.limit_image:SetActive(true)
    self.name_text:SetLocalText("coppa_appeal_btn")
    self:RemoveTimer()
  elseif CoppaUtil.NeedVerify() then
    self.verify_image:SetActive(true)
    self.limit_image:SetActive(false)
    self:AddTimer()
  else
    Logger.Log("UIMainCoppaAppealBtn State Error")
  end
end

function UIMainCoppaAppealBtn:OnBtnClick()
  if CS.PrivacyBrazil.Instance:IsBrazil() and CS.PrivacyBrazil.Instance:IsAgeVerifiedSwitchOn() and not CS.PrivacyBrazil.Instance:IsAgeVerified() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBrazilAgeVerify)
    return
  end
  if CoppaUtil.CanAppeal() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICoppaAppeal)
  elseif CoppaUtil.NeedVerify() then
    CoppaUtil.OpenVerifyDialog()
  else
    Logger.Log("UIMainCoppaAppealBtn State Error")
  end
end

function UIMainCoppaAppealBtn:AddTimer()
  if self.timer then
    return
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.RefreshTime, self, false, false, false)
  self.timer:Start()
end

function UIMainCoppaAppealBtn:RemoveTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainCoppaAppealBtn:RefreshTime()
  local endTime = CoppaUtil.GetFinalConfirmTime()
  if endTime == 0 then
    self.name_text:SetText("00:00:00")
    self:RemoveTimer()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = endTime - curTime
  if 0 < time then
    self.name_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
  else
    self.name_text:SetText("00:00:00")
    self:PopUpVerifyDialog()
    self:RemoveTimer()
  end
end

function UIMainCoppaAppealBtn:PopUpVerifyDialog()
  if CS.SceneManager:IsInCity() or CS.SceneManager:IsInWorld() then
    CoppaUtil.PopupVerifyDialog()
  end
end

return UIMainCoppaAppealBtn
