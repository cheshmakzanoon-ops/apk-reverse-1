local UIWorldRuinsPopUpView = BaseClass("UIWorldRuinsPopUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "UICommonMidPopUpTitle/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/CloseBtn"
local click_btn_path = "offset/joinBtn"
local click_txt_path = "offset/joinBtn/joinBtnTxt"
local des_txt_path = "offset/Goal"

local function OnCreate(self)
  base.OnCreate(self)
  local str, title, callback = self:GetUserData()
  self.title = self:AddComponent(UIText, title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.click_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    if callback and type(callback) == "function" then
      callback()
    end
  end)
  self.click_txt = self:AddComponent(UIText, click_txt_path)
  self.click_txt:SetText(Localization:GetString(GameDialogDefine.CONFIRM))
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    if callback and type(callback) == "function" then
      callback()
    end
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    if callback and type(callback) == "function" then
      callback()
    end
  end)
  if title then
    self.title:SetText(title)
  else
    self.title:SetText(Localization:GetString("100378"))
  end
  self.des_txt:SetText(str)
end

local function OnDestroy(self)
  self.close_btn = nil
  self.return_btn = nil
  self.enter_btn = nil
  self.cancel_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

UIWorldRuinsPopUpView.OnCreate = OnCreate
UIWorldRuinsPopUpView.OnDestroy = OnDestroy
UIWorldRuinsPopUpView.OnEnable = OnEnable
UIWorldRuinsPopUpView.OnDisable = OnDisable
return UIWorldRuinsPopUpView
