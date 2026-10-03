local base = UIBaseContainer
local UIAccountIdBindInputEmailComponent = BaseClass("UIAccountIdBindInputEmailComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAccountIdBindInputEmailComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccountIdBindInputEmailComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountIdBindInputEmailComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.inputFieldEmailInput = self.viewSkin:AddComponent(self, UIInput, 3)
  self.btnCancel = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.textCancelBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnSendMail = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnSendMail:SetOnClick(function()
    self:OnBtnSendMailClick()
  end)
  self.textSendMailBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textMailInvalidTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.placeholder = self:AddComponent(UIText, "EmailInput/Text Area/Placeholder")
end

function UIAccountIdBindInputEmailComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textContent = nil
  self.inputFieldEmailInput = nil
  self.btnCancel = nil
  self.textCancelBtn = nil
  self.btnSendMail = nil
  self.textSendMailBtn = nil
  self.textMailInvalidTip = nil
  self.placeholder = nil
end

function UIAccountIdBindInputEmailComponent:DataDefine()
end

function UIAccountIdBindInputEmailComponent:DataDestroy()
end

function UIAccountIdBindInputEmailComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountIdBindInputEmailComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountIdBindInputEmailComponent:OnBtnCancelClick()
  if self.curState then
    self.curState:JumpToPreState()
  end
end

function UIAccountIdBindInputEmailComponent:OnBtnSendMailClick()
  local checkAddress = self:CheckMailAddress()
  self.textMailInvalidTip:SetActive(not checkAddress)
  if not checkAddress then
    return
  end
  if self.curState then
    self.curState:OnClickRight(self.inputFieldEmailInput:GetText())
  end
end

function UIAccountIdBindInputEmailComponent:Init(state)
  self.textMailInvalidTip:SetActive(false)
  self.textMailInvalidTip:SetLocalText(280112)
  self.placeholder:SetLocalText("id_account_ID3_desc_3")
  self.curState = state
  self:Refresh()
end

function UIAccountIdBindInputEmailComponent:Refresh()
  if self.curState then
    local stateLocalization = self.curState.GetStateLocalization and self.curState:GetStateLocalization() or {}
    self.textTitle:SetText(Localization:GetString(stateLocalization.titleStr))
    self.textContent:SetText(Localization:GetString(stateLocalization.contentStr))
    self.textCancelBtn:SetText(Localization:GetString(stateLocalization.cancelBtnStr))
    self.textSendMailBtn:SetText(Localization:GetString(stateLocalization.sendMailBtnStr))
    local param = self.curState.GetComponentParam and self.curState:GetComponentParam() or {}
    local isEdit = param.isEdit
    local defaultMail = param.defaultMail
    if not isEdit then
      self.inputFieldEmailInput:SetText(defaultMail or "")
      self.inputFieldEmailInput:SetInteractable(false)
    else
      self.inputFieldEmailInput:SetText("")
      self.inputFieldEmailInput:SetInteractable(true)
    end
  end
end

function UIAccountIdBindInputEmailComponent:CheckMailAddress()
  local mailAddress = self.inputFieldEmailInput:GetText()
  if mailAddress == nil or mailAddress == "" then
    return false
  end
  local pattern = "^[%w%._%-%+]+@[%w%._%-%+]+%a$"
  if not string.match(mailAddress, pattern) then
    Logger.LogError("[UIAccountIdBindInputEmailComponent] CheckMailAddress fail: mail=" .. tostring(mailAddress))
    return false
  end
  return true
end

return UIAccountIdBindInputEmailComponent
