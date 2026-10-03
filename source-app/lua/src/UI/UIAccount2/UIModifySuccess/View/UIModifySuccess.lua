local UIModifySuccess = BaseClass("UIModifySuccess", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "UICommonMiniPopUpTitle/titleText")
  self.btnClose = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.textTips = self:AddComponent(UIText, "Root/TextTips")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTips = nil
  self.btnClose = nil
end

local function OnOpen(self)
  self.textTitle:SetLocalText(280039)
  self.textTips:SetLocalText(208204)
end

UIModifySuccess.OnCreate = OnCreate
UIModifySuccess.OnDestroy = OnDestroy
UIModifySuccess.ComponentDefine = ComponentDefine
UIModifySuccess.ComponentDestroy = ComponentDestroy
UIModifySuccess.OnOpen = OnOpen
return UIModifySuccess
