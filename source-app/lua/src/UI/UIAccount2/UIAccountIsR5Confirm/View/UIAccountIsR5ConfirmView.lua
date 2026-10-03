local UIAccountIsR5ConfirmView = BaseClass("UIAccountIsR5ConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "UIAccountPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UIAccountPopUpTitle/titleText")
  self.des = self:AddComponent(UIText, "Root/ContentTxt")
  self.btnConfirm = self:AddComponent(UIButton, "Root/BtnConfirm")
  self.btnConfirm:SetOnClick(BindCallback(self, self.OnBtnConfirmClick))
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.textTitle = nil
  self.des = nil
  self.btnConfirm = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnConfirmClick(self)
  self.ctrl:CloseSelf()
end

UIAccountIsR5ConfirmView.OnCreate = OnCreate
UIAccountIsR5ConfirmView.OnDestroy = OnDestroy
UIAccountIsR5ConfirmView.OnEnable = OnEnable
UIAccountIsR5ConfirmView.OnDisable = OnDisable
UIAccountIsR5ConfirmView.ComponentDefine = ComponentDefine
UIAccountIsR5ConfirmView.ComponentDestroy = ComponentDestroy
UIAccountIsR5ConfirmView.DataDefine = DataDefine
UIAccountIsR5ConfirmView.DataDestroy = DataDestroy
UIAccountIsR5ConfirmView.OnAddListener = OnAddListener
UIAccountIsR5ConfirmView.OnRemoveListener = OnRemoveListener
UIAccountIsR5ConfirmView.OnBtnConfirmClick = OnBtnConfirmClick
return UIAccountIsR5ConfirmView
