local base = UIBaseContainer
local UIAccountIdBindVerifyCodeComponent = BaseClass("UIAccountIdBindVerifyCodeComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local VerifyCodeLength = 6
local empty_path = "Assets/Main/Sprites/UI/UIAccountIdBind/lrb_ID_input.png"
local fill_path = "Assets/Main/Sprites/UI/UIAccountIdBind/lrb_ID_input_on.png"

function UIAccountIdBindVerifyCodeComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccountIdBindVerifyCodeComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountIdBindVerifyCodeComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnCancel = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.textCancelBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnSubmit = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnSubmit:SetOnClick(function()
    self:OnBtnSubmitClick()
  end)
  self.textSubmitBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgBox1 = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgBox2 = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgBox3 = self.viewSkin:AddComponent(self, UIImage, 9)
  self.imgBox4 = self.viewSkin:AddComponent(self, UIImage, 10)
  self.imgBox5 = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgBox6 = self.viewSkin:AddComponent(self, UIImage, 12)
  self.textText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textText4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textText5 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textText6 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.btnResend = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnResend:SetOnClick(function()
    self:OnBtnResendClick()
  end)
  self.textResendBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.btnDidNotReceive = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnDidNotReceive:SetOnClick(function()
    self:OnBtnDidNotReceiveClick()
  end)
  self.textDidNotReceiveBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.compInputField = self.viewSkin:AddComponent(self, UIInput, 23)
  self.compInputField:SetOnValueChange(BindCallback(self, self.OnValueChange))
end

function UIAccountIdBindVerifyCodeComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textContent = nil
  self.btnCancel = nil
  self.textCancelBtn = nil
  self.btnSubmit = nil
  self.textSubmitBtn = nil
  self.imgBox1 = nil
  self.imgBox2 = nil
  self.imgBox3 = nil
  self.imgBox4 = nil
  self.imgBox5 = nil
  self.imgBox6 = nil
  self.textText1 = nil
  self.textText2 = nil
  self.textText3 = nil
  self.textText4 = nil
  self.textText5 = nil
  self.textText6 = nil
  self.btnResend = nil
  self.textResendBtn = nil
  self.btnDidNotReceive = nil
  self.textDidNotReceiveBtn = nil
  self.compInputField = nil
end

function UIAccountIdBindVerifyCodeComponent:DataDefine()
  self.curState = nil
  self.textList = nil
  self.boxList = nil
  self.HaveResend = false
  self.openTime = 0
end

function UIAccountIdBindVerifyCodeComponent:DataDestroy()
  self.curState = nil
  self.textList = nil
  self.boxList = nil
  self.HaveResend = nil
  self.openTime = nil
end

function UIAccountIdBindVerifyCodeComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountIdBindVerifyCodeComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountIdBindVerifyCodeComponent:OnBtnCancelClick()
  if self.curState then
    self.curState:JumpToPreState()
  end
end

function UIAccountIdBindVerifyCodeComponent:OnBtnSubmitClick()
  if self.curState == nil then
    return
  end
  local code = self.compInputField:GetText()
  if string.IsNullOrEmpty(code) or string.len(code) < VerifyCodeLength then
    return
  end
  self:SubmitVerifyCode(code)
end

function UIAccountIdBindVerifyCodeComponent:OnBtnResendClick()
  if self.curState == nil then
    return
  end
  if self.HaveResend then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.openTime == nil or self.openTime <= 0 then
    self.openTime = now
  end
  if now - self.openTime < 1200000 then
    UIUtil.ShowMessage(Localization:GetString("verify_resend_content"), 2, "280117", GameDialogDefine.CANCEL, function()
      self:TriggerResendRequest()
    end, nil, nil)
  else
    self:TriggerResendRequest()
  end
end

function UIAccountIdBindVerifyCodeComponent:OnBtnDidNotReceiveClick()
  local param = {}
  local mailAddress = self.curState.config.mailAddress
  if string.IsNullOrEmpty(mailAddress) then
    Logger.LogError("mailAddress is empty")
    mailAddress = ""
  end
  param.activityRulesStr = Localization:GetString("account_lastwarid_nomail_desc", mailAddress)
  param.title = "account_lastwarid_nomail_title"
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UIAccountIdBindVerifyCodeComponent:Init(state)
  self.curState = state
  self.openTime = UITimeManager:GetInstance():GetServerTime()
  self.HaveResend = self:HasClickedResend()
  self.textList = {}
  self.boxList = {}
  for i = 1, VerifyCodeLength do
    self["textText" .. i]:SetText("")
    table.insert(self.textList, self["textText" .. i])
    table.insert(self.boxList, self["imgBox" .. i])
    self["imgBox" .. i]:LoadSpriteAsync(empty_path)
  end
  self.compInputField:SetText("")
  self:SetLocalizeText()
  self:Update1000MS()
end

function UIAccountIdBindVerifyCodeComponent:SetLocalizeText()
  if self.curState then
    local stateLocalization = self.curState.GetStateLocalization and self.curState:GetStateLocalization() or {}
    self.textTitle:SetLocalText(stateLocalization.titleStr)
    local mailAddress = self.curState.config.mailAddress
    if string.IsNullOrEmpty(mailAddress) then
      Logger.LogError("mailAddress is empty")
      mailAddress = ""
    end
    self.textContent:SetLocalText(stateLocalization.contentStr, mailAddress)
    self.textCancelBtn:SetLocalText(stateLocalization.cancelBtnStr)
    self.textSubmitBtn:SetLocalText(stateLocalization.sendMailBtnStr)
    self.textResendBtn:SetLocalText(stateLocalization.resendBtnStr)
    self.textDidNotReceiveBtn:SetLocalText(stateLocalization.didNotReceiveBtnStr)
  end
end

function UIAccountIdBindVerifyCodeComponent:OnValueChange(value)
  if self.textList == nil or self.boxList == nil then
    return
  end
  local len = string.len(value)
  for k, v in ipairs(self.textList) do
    v:SetText(k <= len and value:sub(k, k) or "")
  end
  for k, v in ipairs(self.boxList) do
    v:LoadSpriteAsync(k == len and fill_path or empty_path)
  end
end

function UIAccountIdBindVerifyCodeComponent:SubmitVerifyCode(code)
  if self.curState then
    self.curState:OnClickRight(code)
  end
end

function UIAccountIdBindVerifyCodeComponent:TriggerResendRequest()
  local now = UITimeManager:GetInstance():GetServerTime()
  local cooldown = 300000
  Setting:SetPrivateString("LW_EmailResendExpireTime", tostring(now + cooldown))
  self.HaveResend = true
  self:Update1000MS()
  if self.curState then
    self.curState:OnClickResend()
  end
end

function UIAccountIdBindVerifyCodeComponent:HasClickedResend()
  local expireTime = Setting:GetPrivateString("LW_EmailResendExpireTime", "")
  if string.IsNullOrEmpty(expireTime) then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local eTime = tonumber(expireTime)
  if eTime == nil then
    return false
  end
  return now < eTime
end

function UIAccountIdBindVerifyCodeComponent:Update1000MS()
  local expireTime = Setting:GetPrivateString("LW_EmailResendExpireTime", "")
  local isCooldown = false
  if not string.IsNullOrEmpty(expireTime) then
    local eTime = tonumber(expireTime)
    if eTime ~= nil then
      local now = UITimeManager:GetInstance():GetServerTime()
      isCooldown = eTime > now
    end
  end
  self.HaveResend = isCooldown
  local stateLocalization = self.curState.GetStateLocalization and self.curState:GetStateLocalization() or {}
  self.btnResend:SetInteractable(not isCooldown)
  if isCooldown then
    local leftTime = expireTime - UITimeManager:GetInstance():GetServerTime()
    self.textResendBtn:SetText(Localization:GetString(stateLocalization.resendBtnStr) .. math.ceil(leftTime / 1000) .. "s")
    self.textResendBtn:SetColor(Color.New(0.5529411764705883, 0.5411764705882353, 0.5450980392156862, 1))
  else
    self.textResendBtn:SetColor(Color.New(0.2627450980392157, 0.36470588235294116, 0.9019607843137255, 1))
    self.textResendBtn:SetText(Localization:GetString(stateLocalization.resendBtnStr))
  end
end

return UIAccountIdBindVerifyCodeComponent
