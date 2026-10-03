local UIDelAllAcctUnderReviewView = BaseClass("UIDelAllAcctUnderReviewView", UIBaseView)
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
  self.btnOK = self:AddComponent(UIButton, "Root/BtnOk")
  self.btnOK:SetOnClick(BindCallback(self, self.OnBtnOKClick))
  self.btnCall = self:AddComponent(UIButton, "Root/BtnCall")
  self.btnCall:SetOnClick(BindCallback(self, self.OnBtnCallClick))
  self.btnApplyCancel = self:AddComponent(UIButton, "Root/BtnApplyCancel")
  self.btnApplyCancel:SetOnClick(BindCallback(self, self.OnBtnApplyCancelClick))
end

local function ComponentDestroy(self)
end

local function RefreshView(self)
  self.textTitle:SetLocalText("delete_account_title_04")
  self.des:SetLocalText("delete_account_content_07")
end

local function OnBtnOKClick(self)
  self.ctrl:CloseSelf()
  CS.ApplicationLaunch.Instance:Quit()
end

local function OnBtnCallClick(self)
  CS.AIHelp.AIHelpProxy.Show(AIHelpEntranceIdType.DelAllAcct, Localization:GetString("2700006"))
end

local function OnBtnApplyCancelClick(self)
  self.ctrl:CloseSelf()
  UIUtil.SendDelAllAcctApplyCancelMsg()
end

UIDelAllAcctUnderReviewView.OnCreate = OnCreate
UIDelAllAcctUnderReviewView.OnDestroy = OnDestroy
UIDelAllAcctUnderReviewView.ComponentDefine = ComponentDefine
UIDelAllAcctUnderReviewView.ComponentDestroy = ComponentDestroy
UIDelAllAcctUnderReviewView.RefreshView = RefreshView
UIDelAllAcctUnderReviewView.OnBtnCallClick = OnBtnCallClick
UIDelAllAcctUnderReviewView.OnBtnOKClick = OnBtnOKClick
UIDelAllAcctUnderReviewView.OnBtnApplyCancelClick = OnBtnApplyCancelClick
return UIDelAllAcctUnderReviewView
