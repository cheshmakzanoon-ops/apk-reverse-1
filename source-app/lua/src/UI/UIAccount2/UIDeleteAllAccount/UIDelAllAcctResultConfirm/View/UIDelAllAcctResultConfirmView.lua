local UIDelAllAcctResultConfirmView = BaseClass("UIDelAllAcctResultConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local waitTime = 60

local function OnCreate(self)
  base.OnCreate(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.closeTime = curTime + waitTime
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
  self.des:SetLocalText("delete_account_content_06")
  self.btnOK = self:AddComponent(UIButton, "Root/BtnOk")
  self.btnOK:SetOnClick(BindCallback(self, self.OnBtnOKClick))
end

local function ComponentDestroy(self)
end

local function RefreshView(self)
end

local function OnBtnOKClick(self)
  self.ctrl:CloseSelf()
end

local function OnCustomKeyCodeEscape(self)
  self:CloseSelf()
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local leftTime = self.closeTime - curTime
  if leftTime < 0 then
    self.ctrl:CloseSelf()
  end
end

UIDelAllAcctResultConfirmView.OnCreate = OnCreate
UIDelAllAcctResultConfirmView.OnDestroy = OnDestroy
UIDelAllAcctResultConfirmView.ComponentDefine = ComponentDefine
UIDelAllAcctResultConfirmView.ComponentDestroy = ComponentDestroy
UIDelAllAcctResultConfirmView.RefreshView = RefreshView
UIDelAllAcctResultConfirmView.Update1000MS = Update1000MS
UIDelAllAcctResultConfirmView.OnBtnOKClick = OnBtnOKClick
UIDelAllAcctResultConfirmView.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIDelAllAcctResultConfirmView
