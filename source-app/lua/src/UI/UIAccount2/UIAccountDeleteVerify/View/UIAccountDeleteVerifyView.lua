local UIAccountDeleteVerifyView = BaseClass("UIAccountDeleteVerifyView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local delKey = "121072"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "UIAccountPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UIAccountPopUpTitle/titleText")
  self.des = self:AddComponent(UIText, "Root/contentTxt")
  self.btnConfirm = self:AddComponent(UIButton, "Root/BtnConfirm")
  self.btnConfirm:SetOnClick(BindCallback(self, self.OnBtnConfirmClick))
  self.btnCancel = self:AddComponent(UIButton, "Root/BtnCancel")
  self.btnCancel:SetOnClick(BindCallback(self, self.OnBtnCancelClick))
  self.inputAccount = self:AddComponent(UIInput, "Root/InputFieldMail")
  self.inputAccount:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.inputAccount:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  local defaultStr = ""
  self.inputAccount:SetText(defaultStr)
  self:IptOnValueChange(defaultStr)
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.textTitle = nil
  self.des = nil
  self.btnConfirm = nil
  self.btnCancel = nil
  self.inputAccount = nil
end

local function RefreshView(self)
  local keyStr = Localization:GetString(delKey)
  local descStr = Localization:GetString("121071", keyStr)
  self.des:SetText(descStr)
end

local function IptOnValueChange(self, value)
  local keyStr = Localization:GetString(delKey)
  local isGray = keyStr ~= value
  CS.UIGray.SetGray(self.btnConfirm.transform, isGray, true)
end

local function OnBtnConfirmClick(self)
  self.ctrl:CloseSelf()
  local keyStr = Localization:GetString(delKey)
  local verifyStr = self.inputAccount:GetText()
  if verifyStr ~= keyStr then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UserBindCancel, {type = 0}, 1)
end

local function OnBtnCancelClick(self)
  self.ctrl:CloseSelf()
end

UIAccountDeleteVerifyView.OnCreate = OnCreate
UIAccountDeleteVerifyView.OnDestroy = OnDestroy
UIAccountDeleteVerifyView.ComponentDefine = ComponentDefine
UIAccountDeleteVerifyView.ComponentDestroy = ComponentDestroy
UIAccountDeleteVerifyView.RefreshView = RefreshView
UIAccountDeleteVerifyView.OnBtnConfirmClick = OnBtnConfirmClick
UIAccountDeleteVerifyView.OnBtnCancelClick = OnBtnCancelClick
UIAccountDeleteVerifyView.IptOnValueChange = IptOnValueChange
return UIAccountDeleteVerifyView
