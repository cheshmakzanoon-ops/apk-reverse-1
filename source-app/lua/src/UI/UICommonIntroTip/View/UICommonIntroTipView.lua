local UICommonIntroTipView = BaseClass("UICommonIntroTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local subtitle_path = "Subtitle"
local intro_path = "Scroll View/Viewport/Content/Intro"
local close_path = "UICommonPopUpTitle/CloseBtn"
local return_path = "UICommonPopUpTitle/panel"

local function OnCreate(self)
  base.OnCreate(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.subtitle_text = self:AddComponent(UIText, subtitle_path)
  self.intro_text = self:AddComponent(UIText, intro_path)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self:OnClose()
  end)
  self.return_btn = self:AddComponent(UIButton, return_path)
  self.return_btn:SetOnClick(function()
    self:OnClose()
  end)
end

local function OnDestroy(self)
  self.title_text = nil
  self.subtitle_text = nil
  self.intro_text = nil
  self.close_btn = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, title, subtitle, intro, closeAction)
  self.title = title
  self.subtitle = subtitle
  self.intro = intro
  self.closeAction = closeAction
end

local function RefreshData(self)
  self.title_text:SetText(self.title)
  self.subtitle_text:SetText(self.subtitle)
  self.intro_text:SetText(self.intro)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.intro_text.rectTransform)
end

local function OnClose(self)
  if self.closeAction then
    self:OnCloseInTimer()
    self.closeAction()
  else
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end
end

local function OnCloseInTimer(self)
  self.onCloseClick = true
  local closeTimer = TimerManager:GetInstance():GetTimer(0.1, function()
    if self.onCloseClick and self.ctrl then
      self.ctrl:CloseSelf()
    end
  end, nil, true, false, false)
  closeTimer:Start()
end

UICommonIntroTipView.OnCreate = OnCreate
UICommonIntroTipView.OnDestroy = OnDestroy
UICommonIntroTipView.OnEnable = OnEnable
UICommonIntroTipView.OnDisable = OnDisable
UICommonIntroTipView.SetData = SetData
UICommonIntroTipView.RefreshData = RefreshData
UICommonIntroTipView.OnClose = OnClose
UICommonIntroTipView.OnCloseInTimer = OnCloseInTimer
return UICommonIntroTipView
