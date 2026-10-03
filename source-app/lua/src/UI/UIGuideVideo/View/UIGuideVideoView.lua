local UIGuideVideoView = BaseClass("UIGuideVideoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local video_player_path = "RawImage"
local skip_btn_path = "SafeArea/SkipBtn"
local show_skip_btn_path = "ShowSkipBtn"
local skip_btn_name_path = "SafeArea/SkipBtn/Text_uityjc20"
local ShowSkipTime = 1.0
local SkipHideTime = 2.0
local _url = CS.UnityEngine.Application.streamingAssetsPath .. "/" .. "LastWar_810_1886_0525_RF24.mp4"

local function OnCreate(self)
  base.OnCreate(self)
  PostEventLog.Track(PostEventLog.Defines.cg_start, {})
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
  self.video_player = self.transform:Find(video_player_path):GetComponent(typeof(CS.UnityEngine.Video.VideoPlayer))
  self.rag_image = self:AddComponent(UIRawImage, video_player_path)
  self.skip_btn = self:AddComponent(UIButton, skip_btn_path)
  self.skip_btn_name = self:AddComponent(UIText, skip_btn_name_path)
  self.skip_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSkipBtnClick()
  end)
  self.show_skip_btn = self:AddComponent(UIButton, show_skip_btn_path)
  self.show_skip_btn:SetOnClick(function()
    self:OnShowSkipBtnClick()
  end)
end

local function ComponentDestroy(self)
  if self.video_player then
    self.video_player:loopPointReached("-", self.loopPointReached)
    self.video_player:prepareCompleted("-", self.prepareCompleted)
    self.video_player = nil
    self.loopPointReached = nil
    self.prepareCompleted = nil
  end
  self.skip_btn = nil
  self.rag_image = nil
  self.show_skip_btn = nil
  self.skip_btn_name = nil
end

local function DataDefine(self)
  self.param = nil
  self.skip_timer = nil
  
  function self.skip_timer_action(temp)
    self:SkipTimerCallBack()
  end
  
  self.record_timer = nil
  self.hide_timer = nil
  
  function self.hide_timer_action(temp)
    self:HideTimerCallBack()
  end
  
  self.onComplete = self:GetUserData()
  self.startTime = UITimeManager:GetInstance():GetServerSeconds()
end

local function DataDestroy(self)
  self:DeleteTimer()
  self:DeleteHideTimer()
  self.param = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.transform:SetAsFirstSibling()
  DataCenter.LWSoundManager:StopAllSounds()
  EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.Close)
  self.skip_btn:SetActive(false)
  self.show_skip_btn:SetActive(false)
  self.skip_btn_name:SetText(Localization:GetString(GameDialogDefine.SKIP))
  self.rag_image:SetColor(Color.New(1, 1, 1, 0))
  self.video_player.playOnAwake = false
  self.video_player.source = CS.UnityEngine.Video.VideoSource.Url
  self.video_player.url = _url
  self.video_player:Prepare()
  
  function self.loopPointReached(vp)
    self:PlayComplete()
  end
  
  function self.prepareCompleted(vp)
    self.rag_image:SetColor(Color.New(1, 1, 1, 1))
    if not CS.ApplicationLaunch.Instance.Loading.IsLoading then
      CS.ApplicationLaunch.Instance.Loading:CloseUILoading()
    else
      CS.ApplicationLaunch.Instance.Loading.isCanCloseLoading = true
    end
  end
  
  self.video_player:loopPointReached("+", self.loopPointReached)
  self.video_player:prepareCompleted("+", self.prepareCompleted)
  self.video_player:Pause()
  if not CS.ApplicationLaunch.Instance.Loading.IsLoading then
    self:StartPlay()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.Guide_video_Play, self.StartPlaySignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.Guide_video_Play, self.StartPlaySignal)
end

local function StartPlay(self)
  DataCenter.LWSoundManager:StopAllSounds()
  self:AddTimer()
  self.video_player:Play()
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
    self.skip_timer = TimerManager:GetInstance():GetTimer(ShowSkipTime, self.skip_timer_action, self, true, false, false)
    self.skip_timer:Start()
  end
end

local function SkipTimerCallBack(self)
  self:DeleteTimer()
  self.show_skip_btn:SetActive(true)
end

local function StartPlaySignal(self)
  self:StartPlay()
end

local function OnSkipBtnClick(self)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  PostEventLog.Track(PostEventLog.Defines.cg_skip, {
    playtime = now - self.startTime
  })
  self:DoCGFinish()
end

local function PlayComplete(self)
  PostEventLog.Track(PostEventLog.Defines.cg_finish, {})
  self:DoCGFinish()
end

local function DoCGFinish(self)
  if self.onComplete then
    self.onComplete()
  end
  self.ctrl:CloseSelf()
end

local function DeleteHideTimer(self)
  if self.hide_timer ~= nil then
    self.hide_timer:Stop()
    self.hide_timer = nil
  end
end

local function AddHideTimer(self)
  self:DeleteHideTimer()
  if self.hide_timer == nil then
    self.hide_timer = TimerManager:GetInstance():GetTimer(SkipHideTime, self.hide_timer_action, self, true, false, false)
    self.hide_timer:Start()
  end
end

local function HideTimerCallBack(self)
  self:DeleteHideTimer()
  self.skip_btn:SetActive(false)
end

local function OnShowSkipBtnClick(self)
  self.skip_btn:SetActive(true)
  self:AddHideTimer()
end

UIGuideVideoView.OnCreate = OnCreate
UIGuideVideoView.OnDestroy = OnDestroy
UIGuideVideoView.OnEnable = OnEnable
UIGuideVideoView.OnDisable = OnDisable
UIGuideVideoView.OnAddListener = OnAddListener
UIGuideVideoView.OnRemoveListener = OnRemoveListener
UIGuideVideoView.ComponentDefine = ComponentDefine
UIGuideVideoView.ComponentDestroy = ComponentDestroy
UIGuideVideoView.DataDefine = DataDefine
UIGuideVideoView.DataDestroy = DataDestroy
UIGuideVideoView.StartPlay = StartPlay
UIGuideVideoView.DeleteTimer = DeleteTimer
UIGuideVideoView.ReInit = ReInit
UIGuideVideoView.SkipTimerCallBack = SkipTimerCallBack
UIGuideVideoView.AddTimer = AddTimer
UIGuideVideoView.StartPlaySignal = StartPlaySignal
UIGuideVideoView.OnSkipBtnClick = OnSkipBtnClick
UIGuideVideoView.PlayComplete = PlayComplete
UIGuideVideoView.DeleteHideTimer = DeleteHideTimer
UIGuideVideoView.AddHideTimer = AddHideTimer
UIGuideVideoView.HideTimerCallBack = HideTimerCallBack
UIGuideVideoView.OnShowSkipBtnClick = OnShowSkipBtnClick
UIGuideVideoView.DoCGFinish = DoCGFinish
return UIGuideVideoView
