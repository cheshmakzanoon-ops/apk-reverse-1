local UIRocketFailedLandingView = BaseClass("UIRocketFailedLandingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local chapter_text_path = "ChapterText"
local title_text_path = "TitleBg/Text_num"
local des_text_path = "DesText"
local bg_img_path = "BgImg"
local AutoCloseTime = 4.0
local SpecialTitle = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.chapter_text = self:AddComponent(UIText, chapter_text_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.bg_img = self:AddComponent(UIImage, bg_img_path)
end

local function ComponentDestroy(self)
  self.chapter_text = nil
  self.title_text = nil
  self.des_text = nil
  self.bg_img = nil
end

local function DataDefine(self)
  self.param = nil
  self.skip_timer = nil
  
  function self.skip_timer_action(temp)
    self:SkipTimerCallBack()
  end
  
  self.auto_next_timer = nil
  
  function self.auto_next_timer_action(temp)
    self:AutoTimerCallBack()
  end
end

local function DataDestroy(self)
  self.param = nil
  self:DeleteTimer()
  self.skip_timer_action = nil
  self:DeleteAutoNextTimer()
  self.auto_next_timer_action = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.param = self:GetUserData()
  self.bg_img:LoadSprite("Assets/Main/TextureEx/UIChapter/" .. self.param.bgName)
  self.chapter_text:SetActive(false)
  self.title_text:SetText(self.param.titleDes)
  self.des_text:SetText(self.param.des)
  self:AddTimer()
  if self.param.autoDoNext ~= nil then
    self:AddAutoNextTimer(self.param.autoDoNext)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function DeleteTimer(self)
  if self.skip_timer ~= nil then
    self.skip_timer:Stop()
    self.skip_timer = nil
  end
end

local function AddTimer(self)
  self:DeleteTimer()
  if self.skip_timer == nil then
    self.skip_timer = TimerManager:GetInstance():GetTimer(AutoCloseTime, self.skip_timer_action, self, true, false, false)
    self.skip_timer:Start()
  end
end

local function SkipTimerCallBack(self)
  self:DeleteTimer()
  self.ctrl:CloseSelf()
  TimerManager:GetInstance():DelayInvoke(function()
    if DataCenter.GuideManager:GetGuideType() == GuideType.ShowChapterAnim then
      DataCenter.GuideManager:DoNext()
    end
  end, 1)
end

local function CheckGuide(self)
  if DataCenter.GuideManager:GetGuideType() == GuideType.ShowChapterAnim then
    DataCenter.GuideManager:DoNext()
  end
end

local function DeleteAutoNextTimer(self)
  if self.auto_next_timer ~= nil then
    self.auto_next_timer:Stop()
    self.auto_next_timer = nil
  end
end

local function AddAutoNextTimer(self, time)
  self:DeleteAutoNextTimer()
  if self.auto_next_timer == nil then
    self.auto_next_timer = TimerManager:GetInstance():GetTimer(time, self.auto_next_timer_action, self, true, false, false)
    self.auto_next_timer:Start()
  end
end

local function AutoTimerCallBack(self)
  self:DeleteAutoNextTimer()
  self:CheckGuide()
end

UIRocketFailedLandingView.OnCreate = OnCreate
UIRocketFailedLandingView.OnDestroy = OnDestroy
UIRocketFailedLandingView.OnEnable = OnEnable
UIRocketFailedLandingView.OnDisable = OnDisable
UIRocketFailedLandingView.OnAddListener = OnAddListener
UIRocketFailedLandingView.OnRemoveListener = OnRemoveListener
UIRocketFailedLandingView.ComponentDefine = ComponentDefine
UIRocketFailedLandingView.ComponentDestroy = ComponentDestroy
UIRocketFailedLandingView.DataDefine = DataDefine
UIRocketFailedLandingView.DataDestroy = DataDestroy
UIRocketFailedLandingView.DeleteTimer = DeleteTimer
UIRocketFailedLandingView.ReInit = ReInit
UIRocketFailedLandingView.SkipTimerCallBack = SkipTimerCallBack
UIRocketFailedLandingView.AddTimer = AddTimer
UIRocketFailedLandingView.CheckGuide = CheckGuide
UIRocketFailedLandingView.DeleteAutoNextTimer = DeleteAutoNextTimer
UIRocketFailedLandingView.AddAutoNextTimer = AddAutoNextTimer
UIRocketFailedLandingView.AutoTimerCallBack = AutoTimerCallBack
return UIRocketFailedLandingView
