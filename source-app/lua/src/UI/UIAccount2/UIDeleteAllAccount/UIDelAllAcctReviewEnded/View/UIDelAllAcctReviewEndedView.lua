local UIDelAllAcctReviewEndedView = BaseClass("UIDelAllAcctReviewEndedView", UIBaseView)
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
  self.textTitle:SetLocalText("delete_account_title_05")
  self.des:SetLocalText("delete_account_content_08")
  self.btnOK = self:AddComponent(UIButton, "Root/BtnOk")
  self.btnOK:SetOnClick(BindCallback(self, self.OnBtnOKClick))
  self.btnRole = self:AddComponent(UIButton, "Root/BtnRole")
  self.btnRole:SetOnClick(BindCallback(self, self.OnBtnRoleClick))
  self.btnCall = self:AddComponent(UIButton, "Root/BtnCall")
  self.btnCall:SetOnClick(BindCallback(self, self.OnBtnCallClick))
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.textTitle = nil
  self.btnOK = nil
end

local function RefreshView(self)
end

local function OnBtnOKClick(self)
  local selfCtrl = self.ctrl
  UIUtil.ShowMessage(Localization:GetString("delete_account_content_10"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    selfCtrl:CloseSelf()
    CS.LoginMessage.Instance:SendDelAccountMsg()
  end, nil, function()
  end, 100378)
end

local function OnBtnRoleClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoleListShow)
end

local function OnBtnCallClick(self)
  self.ctrl:CloseSelf()
  UIUtil.SendDelAllAcctApplyCancelMsg()
end

UIDelAllAcctReviewEndedView.OnCreate = OnCreate
UIDelAllAcctReviewEndedView.OnDestroy = OnDestroy
UIDelAllAcctReviewEndedView.ComponentDefine = ComponentDefine
UIDelAllAcctReviewEndedView.ComponentDestroy = ComponentDestroy
UIDelAllAcctReviewEndedView.RefreshView = RefreshView
UIDelAllAcctReviewEndedView.OnBtnRoleClick = OnBtnRoleClick
UIDelAllAcctReviewEndedView.OnBtnOKClick = OnBtnOKClick
UIDelAllAcctReviewEndedView.OnBtnCallClick = OnBtnCallClick
return UIDelAllAcctReviewEndedView
