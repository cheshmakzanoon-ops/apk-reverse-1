local UIBindMailTipsView = BaseClass("UIBindMailTipsView", UIBaseView)
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
  self.textText1 = self:AddComponent(UITextMeshProUGUIEx, "Content/1/Text1")
  self.textText2 = self:AddComponent(UITextMeshProUGUIEx, "Content/2/Text2")
  self.textText3 = self:AddComponent(UITextMeshProUGUIEx, "Content/3/Text3")
  self.textText4 = self:AddComponent(UITextMeshProUGUIEx, "Content/4/Text4")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textText5 = self:AddComponent(UITextMeshProUGUIEx, "Content/4/Text5")
  self.textText6 = self:AddComponent(UITextMeshProUGUIEx, "Content/4/Text6")
  self.textTitle:SetLocalText("170001")
  self.textText1:SetLocalText("pc_account_tips_02")
  self.textText2:SetLocalText("pc_account_tips_03")
  self.textText3:SetLocalText("pc_account_tips_04")
  self.textText4:SetLocalText("pc_account_tips_05")
  self.textText5:SetLocalText("pc_account_tips_06")
  self.textText6:SetLocalText("2700011")
end

local function ComponentDestroy(self)
  self.textText1 = nil
  self.textText2 = nil
  self.textText3 = nil
  self.textText4 = nil
  self.btnClose = nil
  self.textTitle = nil
  self.textText5 = nil
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

local function OnBtnCloseClick(self)
  self.ctrl.CloseSelf()
end

UIBindMailTipsView.OnCreate = OnCreate
UIBindMailTipsView.OnDestroy = OnDestroy
UIBindMailTipsView.OnEnable = OnEnable
UIBindMailTipsView.OnDisable = OnDisable
UIBindMailTipsView.ComponentDefine = ComponentDefine
UIBindMailTipsView.ComponentDestroy = ComponentDestroy
UIBindMailTipsView.DataDefine = DataDefine
UIBindMailTipsView.DataDestroy = DataDestroy
UIBindMailTipsView.OnAddListener = OnAddListener
UIBindMailTipsView.OnRemoveListener = OnRemoveListener
UIBindMailTipsView.OnBtnCloseClick = OnBtnCloseClick
return UIBindMailTipsView
