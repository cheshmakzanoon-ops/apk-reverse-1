local FullScreenVideoViewView = BaseClass("FullScreenVideoViewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DOTween = CS.DG.Tweening.DOTween
local VIDEO_FIRST_SHOW_KEY = "VIDEO_FIRST_SHOW_KEY"
local LOAD_TIME_OUT_TIME = 10

function FullScreenVideoViewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local params = self:GetUserData()
  self.path = params.path
  self.audioId = params.audioId
  self.callbackAdvanceTime = params.callbackAdvanceTime or 0
  self.onVideoCloseCallback = params.onVideoCloseCallback
  self.subtitles = params.subtitles
  self.subtitleBgAlpha = params.subtitleBgAlpha
  self.defaultShowSkip = params.defaultShowSkip == true
  if params.fadeInTime and 0 < params.fadeInTime then
    self:VideoFadeIn(params.fadeInTime)
  else
    self.imgUIBackground:SetAlpha(1)
    self.compCircleloading:SetActive(true)
  end
  self:RefreshView()
end

function FullScreenVideoViewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FullScreenVideoViewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.canvasGroupSkipBtn = self.viewSkin:AddComponent(self, UICanvasGroup, 1)
  self.btnSkip = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.btnUIBackground = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnUIBackground:SetOnClick(function()
    self:OnBtnUIBackgroundClick()
  end)
  self.imgUIBackground = self.viewSkin:AddComponent(self, UIImage, 4)
  self.compCircleloading = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.subtitleText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgSubtitleBg = self.viewSkin:AddComponent(self, UIImage, 7)
  if self.imgSubtitleBg then
    self.imgSubtitleBg:SetActive(false)
    self.imgSubtitleBg:SetAlpha(0.78)
  end
  self.btnSkip.gameObject:SetActive(false)
  self.imgUIBackground:SetAlpha(0)
  self.compCircleloading:SetActive(false)
end

function FullScreenVideoViewView:ComponentDestroy()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  if self.advanceTimer then
    self.advanceTimer:Stop()
    self.advanceTimer = nil
  end
  if self.btnSkip and self.transform then
    self.btnSkip.transform:SetParent(self.transform)
    self.btnSkip.rectTransform:Set_anchorMin(self.skipBtnCacheAnchorMinX, self.skipBtnCacheAnchorMinY)
    self.btnSkip.rectTransform:Set_anchorMax(self.skipBtnCacheAnchorMaxX, self.skipBtnCacheAnchorMaxY)
    self.btnSkip.rectTransform.anchoredPosition = Vector3.New(self.skipBtnCachePos.x, self.skipBtnCachePos.y, 0)
    self.btnSkip.transform:Set_localScale(1, 1, 1)
  end
  if self.imgSubtitleBg and self.transform and self.subtitleCachePos then
    self.imgSubtitleBg.transform:SetParent(self.transform)
    self.imgSubtitleBg.rectTransform:Set_anchorMin(self.subtitleCacheAnchorMinX, self.subtitleCacheAnchorMinY)
    self.imgSubtitleBg.rectTransform:Set_anchorMax(self.subtitleCacheAnchorMaxX, self.subtitleCacheAnchorMaxY)
    self.imgSubtitleBg.rectTransform.anchoredPosition = Vector3.New(self.subtitleCachePos.x, self.subtitleCachePos.y, 0)
    self.imgSubtitleBg.transform:Set_localScale(1, 1, 1)
  end
  self.viewSkin = nil
  self.canvasGroupSkipBtn = nil
  self.btnSkip = nil
  self.btnUIBackground = nil
  self.imgUIBackground = nil
  self.compCircleloading = nil
  self.subtitleText = nil
  self.imgSubtitleBg = nil
  if self.skipBtnAniTween then
    self.skipBtnAniTween:Kill()
  end
  self:StopExternalAudio()
  CS.FullScreenVideoManager.Instance:StopAndReleaseVideo()
  CS.GameEntry.Sound:ResetMusicVolume()
  CS.GameEntry.Sound:ResetAMBSoundVolume()
end

function FullScreenVideoViewView:DataDefine()
  self.videoFirstShowInfo = CommonUtil.PlayerPrefsGetTable(VIDEO_FIRST_SHOW_KEY) or {}
  self.startTime = nil
  self.loadTimeOutTimer = nil
  self.subtitleTimers = {}
end

function FullScreenVideoViewView:DataDestroy()
  self.videoFirstShowInfo = nil
  self.startTime = nil
  if self.loadTimeOutTimer then
    self.loadTimeOutTimer:Stop()
  end
  self:StopSubtitleTimers()
end

function FullScreenVideoViewView:OnAddListener()
  base.OnAddListener(self)
end

function FullScreenVideoViewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FullScreenVideoViewView:OnBtnUIBackgroundClick()
  if self.defaultShowSkip then
    return
  end
  self.btnSkip.gameObject:SetActive(true)
  if self.skipBtnDisappearTimer then
    self.skipBtnDisappearTimer:Stop()
    self.skipBtnDisappearTimer = nil
  end
  if self.skipBtnAniTween then
    self.skipBtnAniTween:Kill()
    self.skipBtnAniTween = nil
  end
  if not IsNull(self.canvasGroupSkipBtn) and self.skipBtnAniTween == nil and self.skipBtnDisappearTimer == nil then
    self.canvasGroupSkipBtn.alpha = 0
    self.skipBtnAniTween = self.canvasGroupSkipBtn:FadeIn(0.5)
    self.skipBtnAniTween:OnComplete(function()
      self.skipBtnAniTween = nil
    end)
  end
  self.skipBtnDisappearTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.skipBtnAniTween then
      self.skipBtnAniTween:Kill()
    end
    if not IsNull(self.canvasGroupSkipBtn) and self.skipBtnAniTween == nil then
      self.skipBtnAniTween = self.canvasGroupSkipBtn:FadeOut(0.5)
      self.skipBtnAniTween:OnComplete(function()
        self.btnSkip.gameObject:SetActive(false)
        self.skipBtnAniTween = nil
      end)
    end
    self.skipBtnDisappearTimer = nil
  end, 2)
end

function FullScreenVideoViewView:OnBtnSkipClick()
  self:ExecuteSkipVideo()
end

function FullScreenVideoViewView:ExecuteSkipVideo()
  self.ctrl:CloseSelf()
  if self.onVideoCloseCallback then
    self.onVideoCloseCallback(true)
    self.onVideoCloseCallback = nil
  end
end

function FullScreenVideoViewView:RefreshView()
  if string.IsNullOrEmpty(self.path) then
    self.ctrl:CloseSelf()
    return
  end
  CS.GameEntry.Sound:SetBGMVolumeTo0()
  CS.GameEntry.Sound:SetAMBSoundVolumeTo0()
  local isLoop = false
  self.skipBtnCachePos = self.btnSkip.rectTransform.anchoredPosition
  self.skipBtnCacheAnchorMinX, self.skipBtnCacheAnchorMinY = self.btnSkip.rectTransform:Get_anchorMin()
  self.skipBtnCacheAnchorMaxX, self.skipBtnCacheAnchorMaxY = self.btnSkip.rectTransform:Get_anchorMax()
  
  local function firstFrameReadyFunc(canvasTrans, vp)
    self:OnFirstFrameReady(canvasTrans, vp)
  end
  
  local function videoStartedFunc()
    self:OnVideoStarted()
  end
  
  local function videoFinishFunc()
    self.ctrl:CloseSelf()
    if self.onVideoCloseCallback then
      self.onVideoCloseCallback(false)
      self.onVideoCloseCallback = nil
    end
  end
  
  self.startTime = UITimeManager:GetInstance():GetServerTime()
  if self.audioId and self.audioId > 0 then
    DataCenter.LWSoundManager:PreloadSound(self.audioId)
    CS.FullScreenVideoManager.Instance:LoadVideo(self.path, isLoop, firstFrameReadyFunc, videoFinishFunc, true, videoStartedFunc)
  else
    CS.FullScreenVideoManager.Instance:LoadVideo(self.path, isLoop, firstFrameReadyFunc, videoFinishFunc, false, videoStartedFunc)
  end
  self.loadTimeOutTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ExecuteSkipVideo()
  end, LOAD_TIME_OUT_TIME)
end

function FullScreenVideoViewView:OnFirstFrameReady(canvasTrans, vp)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.startTime then
    local isFirst = self.videoFirstShowInfo[self.path] ~= 1
    if isFirst then
      self.videoFirstShowInfo[self.path] = 1
      CommonUtil.PlayerPrefsSetTable(VIDEO_FIRST_SHOW_KEY, self.videoFirstShowInfo)
    end
    PostEventLog.Track(PostEventLog.Defines.c_show_full_screen_video, {
      time = now - self.startTime,
      event_type = self.path,
      is_first = isFirst
    })
    Logger.Log(string.format("%s load time: %s ms", self.path, now - self.startTime))
  end
  self.btnSkip.transform:SetParent(canvasTrans.transform)
  self.btnSkip.rectTransform:Set_anchorMin(self.skipBtnCacheAnchorMinX, self.skipBtnCacheAnchorMinY)
  self.btnSkip.rectTransform:Set_anchorMax(self.skipBtnCacheAnchorMaxX, self.skipBtnCacheAnchorMaxY)
  local skipBtnX = self.skipBtnCachePos.x
  if vp.width > 0 and 0 < vp.height then
    local screenW = CS.UnityEngine.Screen.width
    local screenH = CS.UnityEngine.Screen.height
    local videoPixelW = math.min(screenH * vp.width / vp.height, screenW)
    local scaleFactor = math.min(screenW / 810, screenH / 1440)
    local videoCanvasW = videoPixelW / scaleFactor
    local btnWidth = self.btnSkip.rectTransform.rect.width
    skipBtnX = videoCanvasW / 2 - btnWidth / 2
  end
  self.btnSkip.rectTransform.anchoredPosition3D = Vector3.New(skipBtnX * CommonUtil.ArabicAutoMirrorFactor(), self.skipBtnCachePos.y, 0)
  self.btnSkip.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("UI"))
  self.btnSkip.transform:Set_localScale(1, 1, 1)
  self.btnSkip.gameObject:SetActive(self.defaultShowSkip)
  if self.imgSubtitleBg and not table.IsNullOrEmpty(self.subtitles) then
    self.subtitleCachePos = self.imgSubtitleBg.rectTransform.anchoredPosition
    self.subtitleCacheAnchorMinX, self.subtitleCacheAnchorMinY = self.imgSubtitleBg.rectTransform:Get_anchorMin()
    self.subtitleCacheAnchorMaxX, self.subtitleCacheAnchorMaxY = self.imgSubtitleBg.rectTransform:Get_anchorMax()
    self.imgSubtitleBg.transform:SetParent(canvasTrans.transform)
    self.imgSubtitleBg.rectTransform:Set_anchorMin(self.subtitleCacheAnchorMinX, self.subtitleCacheAnchorMinY)
    self.imgSubtitleBg.rectTransform:Set_anchorMax(self.subtitleCacheAnchorMaxX, self.subtitleCacheAnchorMaxY)
    self.imgSubtitleBg.rectTransform.anchoredPosition3D = Vector3.New(self.subtitleCachePos.x, self.subtitleCachePos.y, 0)
    self.imgSubtitleBg.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("UI"))
    self.imgSubtitleBg.transform:Set_localScale(1, 1, 1)
    if vp.width > 0 and 0 < vp.height then
      local screenW = CS.UnityEngine.Screen.width
      local screenH = CS.UnityEngine.Screen.height
      local videoPixelW = math.min(screenH * vp.width / vp.height, screenW)
      local scaleFactor = math.min(screenW / 810, screenH / 1440)
      local videoCanvasW = videoPixelW / scaleFactor - 80
      local subtitleH = self.imgSubtitleBg.rectTransform.rect.height
      self.imgSubtitleBg.rectTransform:Set_sizeDelta(videoCanvasW, subtitleH)
    end
  end
  self.imgUIBackground:SetAlpha(1)
  if 0 < self.callbackAdvanceTime and 0 < vp.frameCount then
    if self.advanceTimer then
      self.advanceTimer:Stop()
      self.advanceTimer = nil
    end
    self.advanceTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.onVideoCloseCallback then
        self.onVideoCloseCallback(false)
        self.onVideoCloseCallback = nil
      end
    end, vp.length - self.callbackAdvanceTime)
  end
  if self.loadTimeOutTimer then
    self.loadTimeOutTimer:Stop()
    self.loadTimeOutTimer = nil
  end
end

function FullScreenVideoViewView:OnVideoStarted()
  if self.audioId and self.audioId > 0 then
    self.externalAudioSoundId = DataCenter.LWSoundManager:PlaySound(self.audioId, false)
  end
  self:StartSubtitles()
end

function FullScreenVideoViewView:StopExternalAudio()
  if self.externalAudioSoundId and self.externalAudioSoundId > 0 then
    DataCenter.LWSoundManager:StopSound(self.externalAudioSoundId, true)
    self.externalAudioSoundId = nil
  end
  if self.audioId and 0 < self.audioId then
    DataCenter.LWSoundManager:ReleasePreloadedSound(self.audioId)
  end
end

function FullScreenVideoViewView:VideoFadeIn(time)
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self.tween = DOTween.Sequence()
  self.tween:Append(DOTween.To(function()
    return 0
  end, function(value)
    CS.FullScreenVideoManager.Instance:SetVideoAlpha(value)
    self.imgUIBackground:SetAlpha(value)
  end, 1, time)):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  self.tween:AppendCallback(function()
    self.compCircleloading:SetActive(true)
  end)
end

function FullScreenVideoViewView:StartSubtitles()
  if table.IsNullOrEmpty(self.subtitles) or not self.subtitleText then
    return
  end
  self:StopSubtitleTimers()
  self.curSubtitleIndex = 0
  if self.subtitleBgAlpha and self.imgSubtitleBg then
    self.imgSubtitleBg:SetAlpha(self.subtitleBgAlpha)
  end
  for i, subtitle in ipairs(self.subtitles) do
    if subtitle.startTime and subtitle.endTime and subtitle.textId then
      local index = i
      local showTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.subtitleText then
          self.curSubtitleIndex = index
          self.subtitleText:SetLocalText(subtitle.textId)
          self.imgSubtitleBg:SetActive(true)
        end
      end, subtitle.startTime)
      table.insert(self.subtitleTimers, showTimer)
      local hideTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.imgSubtitleBg and self.curSubtitleIndex == index then
          self.imgSubtitleBg:SetActive(false)
        end
      end, subtitle.endTime)
      table.insert(self.subtitleTimers, hideTimer)
    end
  end
end

function FullScreenVideoViewView:StopSubtitleTimers()
  if self.subtitleTimers then
    for _, timer in ipairs(self.subtitleTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.subtitleTimers = {}
  end
end

return FullScreenVideoViewView
