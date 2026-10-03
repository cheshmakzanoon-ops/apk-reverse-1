local UIDelAllAcctInfoConfirmView = BaseClass("UIDelAllAcctInfoConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

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
  self.btnClose = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UICommonMiniPopUpTitle/titleText")
  self.des = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content")
  self.textTitle:SetLocalText("delete_account_title_01")
  self.des:SetLocalText("delete_account_content_04")
  self.btnOK = self:AddComponent(UIButton, "Root/BtnOk")
  self.btnOK:SetOnClick(BindCallback(self, self.OnBtnOKClick))
  self.btnRole = self:AddComponent(UIButton, "Root/BtnRole")
  self.btnRole:SetOnClick(BindCallback(self, self.OnBtnRoleClick))
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.textTitle = nil
  self.btnOK = nil
end

local function RefreshView(self)
end

local function OnBtnOKClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDelAllAcctSendReqConfirm)
  self.ctrl:CloseSelf()
end

local function OnBtnRoleClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoleListShow)
end

UIDelAllAcctInfoConfirmView.OnCreate = OnCreate
UIDelAllAcctInfoConfirmView.OnDestroy = OnDestroy
UIDelAllAcctInfoConfirmView.ComponentDefine = ComponentDefine
UIDelAllAcctInfoConfirmView.ComponentDestroy = ComponentDestroy
UIDelAllAcctInfoConfirmView.RefreshView = RefreshView
UIDelAllAcctInfoConfirmView.OnBtnRoleClick = OnBtnRoleClick
UIDelAllAcctInfoConfirmView.OnBtnOKClick = OnBtnOKClick
return UIDelAllAcctInfoConfirmView
