local UIGotoAllowTrackingView = BaseClass("UIGotoAllowTrackingView", UIBaseView)
local base = UIBaseView
local goto_btn_path = "ImgBg/Goto"
local close_btn_path = "UICommonPanel"
local text_desc = "Text"
local setting_img_path = "Image"
local goto_text_path = "ImgBg/Goto/useText"

local function OnCreate(self)
  base.OnCreate(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.use_btn = self:AddComponent(UIButton, goto_btn_path)
  self.use_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.goto_text = self:AddComponent(UIText, goto_text_path)
  self.goto_text:SetLocalText(208223)
  self.text_desc = self:AddComponent(UIText, text_desc)
  self.text_desc:SetLocalText(208224)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnBtnClick(self)
  self.ctrl:CloseSelf()
  CS.GameEntry.Setting:SetBool(SettingKeys.ALLOW_TRACKING_CLICK, true)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetting)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
  EventManager:GetInstance():Broadcast(EventId.UpdateTrackingStatus)
  pcall(function()
    CS.GameEntry.Sdk:OpenSettings()
  end)
end

UIGotoAllowTrackingView.OnCreate = OnCreate
UIGotoAllowTrackingView.OnDestroy = OnDestroy
UIGotoAllowTrackingView.OnEnable = OnEnable
UIGotoAllowTrackingView.OnDisable = OnDisable
UIGotoAllowTrackingView.OnBtnClick = OnBtnClick
return UIGotoAllowTrackingView
