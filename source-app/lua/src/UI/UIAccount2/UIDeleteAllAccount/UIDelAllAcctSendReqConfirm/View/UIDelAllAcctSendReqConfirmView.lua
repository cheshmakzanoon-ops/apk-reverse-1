local UIDelAllAcctSendReqConfirmView = BaseClass("UIDelAllAcctSendReqConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local waitTime = 3
local viewState = {Prepare = 1, SendReq = 2}

local function OnCreate(self)
  base.OnCreate(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.state = viewState.Prepare
  self.prepareEndtime = curTime + waitTime
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
  self.des:SetLocalText("delete_account_content_05")
  self.prepareContent = self:AddComponent(UIBaseContainer, "Root/prepareContent")
  self.timetext = self:AddComponent(UIText, "Root/prepareContent/timetext")
  self.sendReqContent = self:AddComponent(UIBaseContainer, "Root/sendReqContent")
  self.btnOK = self:AddComponent(UIButton, "Root/sendReqContent/BtnOk")
  self.btnOK:SetOnClick(BindCallback(self, self.OnBtnOKClick))
  self.btnCancel = self:AddComponent(UIButton, "Root/sendReqContent/BtnCancel")
  self.btnCancel:SetOnClick(BindCallback(self, self.OnBtnCancelClick))
end

local function ComponentDestroy(self)
end

local function RefreshView(self)
  self:RefreshContentView()
  self:Update1000MS()
end

local function RefreshContentView(self)
  if self.state == viewState.Prepare then
    self.prepareContent:SetActive(true)
    self.sendReqContent:SetActive(false)
  elseif self.state == viewState.SendReq then
    self.prepareContent:SetActive(false)
    self.sendReqContent:SetActive(true)
  end
end

local function Update1000MS(self)
  if self.state ~= viewState.Prepare then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local leftTime = self.prepareEndtime - curTime
  if leftTime < 0 then
    self.state = viewState.SendReq
    self:RefreshContentView()
  else
    self.timetext:SetText(leftTime)
  end
end

local function OnBtnOKClick(self)
  SFSNetwork.SendMessage(MsgDefines.UserDelAccount)
  self.ctrl:CloseSelf()
end

local function OnBtnCancelClick(self)
  self.ctrl:CloseSelf()
end

UIDelAllAcctSendReqConfirmView.OnCreate = OnCreate
UIDelAllAcctSendReqConfirmView.OnDestroy = OnDestroy
UIDelAllAcctSendReqConfirmView.ComponentDefine = ComponentDefine
UIDelAllAcctSendReqConfirmView.ComponentDestroy = ComponentDestroy
UIDelAllAcctSendReqConfirmView.RefreshView = RefreshView
UIDelAllAcctSendReqConfirmView.RefreshContentView = RefreshContentView
UIDelAllAcctSendReqConfirmView.Update1000MS = Update1000MS
UIDelAllAcctSendReqConfirmView.OnBtnCancelClick = OnBtnCancelClick
UIDelAllAcctSendReqConfirmView.OnBtnOKClick = OnBtnOKClick
return UIDelAllAcctSendReqConfirmView
