local FishingSceneCtrl = BaseClass("FishingSceneCtrl")
local LoopVideoPath = "Assets/Main/Video/s6_fishing_loop.mp4"
local StartVideoPath = "Assets/Main/Video/s6_fishing_start.mp4"
local StartVideoLength = 3000
local UnityAnimator = typeof(CS.UnityEngine.Animator)
local UnitySimpleAnimation = typeof(CS.SimpleAnimation)
local FishSpineAnimLength = 6

function FishingSceneCtrl:__init()
end

function FishingSceneCtrl:__delete()
  self:Destroy()
end

function FishingSceneCtrl:AddListeners()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnQuadVideoPlayStarted, self.OnQuadVideoPlayStarted, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnLoadFishingVideoTimeout, self.OnLoadFishingVideoTimeout, self)
end

function FishingSceneCtrl:RemoveListeners()
  EventManager:GetInstance():RemoveListener(EventId.OnQuadVideoPlayStarted, self.OnQuadVideoPlayStarted)
  EventManager:GetInstance():RemoveListener(EventId.OnLoadFishingVideoTimeout, self.OnLoadFishingVideoTimeout)
end

function FishingSceneCtrl:Init(rtCtrl)
  self.rtCtrl = rtCtrl
  self:DataDefine()
  self:ComponentDefine()
  self:EnterState(FishingState.NotStart)
  self:AddListeners()
end

function FishingSceneCtrl:Destroy()
  if self.timerPlayLoopVideo then
    self.timerPlayLoopVideo:Stop()
    self.timerPlayLoopVideo = nil
  end
  if self.bgmSerialId then
    DataCenter.LWSoundManager:StopSound(self.bgmSerialId)
    self.bgmSerialId = nil
  end
  if self.ambSerialId then
    DataCenter.LWSoundManager:StopSound(self.ambSerialId)
    self.ambSerialId = nil
  end
  self:RemoveListeners()
  self:ComponentDestroy()
  self:DataDestroy()
  self.rtCtrl = nil
end

function FishingSceneCtrl:ComponentDefine()
  self.allFishRoot = self.rtCtrl:GetSceneNode("Dynamic/fishRoot")
  self.allFishRoot:SetActive(false)
  self.bgAnimator = self.rtCtrl:GetSceneNodeComponent(UnityAnimator, "Static/beijing_skin")
  self.manAnimator1 = self.rtCtrl:GetSceneNodeComponent(UnityAnimator, "Static/A_npc_diaoyu_milin/A_NPC_diaoyu_skin")
  self.manAnimator2 = self.rtCtrl:GetSceneNodeComponent(UnityAnimator, "Static/A_npc_diaoyu_shidi/A_NPC_shidi_skin")
  if DataCenter.SeasonFactionWarDataManager.myCampId == 1 then
    self.manAnimator = self.manAnimator1
    self.manAnimator1.gameObject:SetActive(false)
    self.manAnimator2.gameObject:SetActive(false)
  else
    self.manAnimator = self.manAnimator2
    self.manAnimator1.gameObject:SetActive(false)
    self.manAnimator2.gameObject:SetActive(false)
  end
  self.cameraAnimator = self.rtCtrl:GetSceneNodeComponent(UnityAnimator, "Static/diaoyu_camera_skin")
  self.fishRootAnimation = {}
  self.fishAnimator = {}
  self.fishRootAnimation[1] = self.rtCtrl:GetSceneNodeComponent(UnitySimpleAnimation, "Dynamic/fishRoot/xiao_skin")
  self.fishAnimator[1] = self.rtCtrl:GetSceneNodeComponent(UnityAnimator, "Dynamic/fishRoot/xiao_skin/guadian_xiao/A_yu_skin")
  self.fishRootAnimation[2] = self.rtCtrl:GetSceneNodeComponent(UnitySimpleAnimation, "Dynamic/fishRoot/zhong_skin")
  self.fishAnimator[2] = self.rtCtrl:GetSceneNodeComponent(UnityAnimator, "Dynamic/fishRoot/zhong_skin/guadian_zhong/A_yu_skin")
  self.fishRootAnimation[3] = self.rtCtrl:GetSceneNodeComponent(UnitySimpleAnimation, "Dynamic/fishRoot/da_skin")
  self.fishAnimator[3] = self.rtCtrl:GetSceneNodeComponent(UnityAnimator, "Dynamic/fishRoot/da_skin/guadian_da/A_yu_skin")
  self.defaultQuad = self.rtCtrl:GetSceneNode("Static/beijing_skin/beijing_guadian/DefaultQuad").transform
  self.fishSpine = self.rtCtrl:GetSceneNodeComponent(typeof(CS.Spine.Unity.SkeletonAnimation), "Static/beijing_skin/beijing_guadian/DefaultQuad/LoopQuad/diaoyu_item_yuqun_world")
  self.fishSpine.gameObject:SetActive(false)
  self.vineSpine = self.rtCtrl:GetSceneNodeComponent(typeof(CS.Spine.Unity.SkeletonAnimation), "Static/beijing_skin/beijing_guadian/DefaultQuad/LoopQuad/diaoyu_item_tengwan_world")
  self.vineSpine.gameObject:SetActive(false)
  self.startQuad = self.rtCtrl:GetSceneNode("Static/beijing_skin/beijing_guadian/DefaultQuad/StartQuad")
  self:ShowStartVideoQuad(false)
  self.startVideoCreator = self.startQuad:GetComponent(typeof(CS.QuadVideoPlayerCreator))
  self.loopQuad = self.rtCtrl:GetSceneNode("Static/beijing_skin/beijing_guadian/DefaultQuad/LoopQuad")
  self:ShowLoopVideoQuad(false)
  self.loopVideoCreator = self.loopQuad:GetComponent(typeof(CS.QuadVideoPlayerCreator))
  if DataCenter.FishingDataManager:GetIsLoadVideoTimeout() then
    self:OnLoadFishingVideoTimeout()
  else
    local lastPlayStartTime = CommonUtil.PlayerPrefsGetLong("FishingStartVideoStartTime", 0)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if UITimeManager:GetInstance():IsSameDayForServer(lastPlayStartTime * 0.001, now) then
      self.startVideoStartTime = 0
      self.loopVideoCreator:LoadVideo()
    else
      self.startVideoCreator:LoadVideo()
    end
  end
end

function FishingSceneCtrl:ShowStartVideoQuad(bool)
  Logger.LogCustom("ShowStartVideoQuad " .. (bool and "true" or "false") .. UITimeManager:GetInstance():GetServerTime())
  if self.startQuad then
    if bool then
      self.startQuad.transform:Set_localPosition(0, 0, -0.01)
    else
      self.startQuad.transform:Set_localPosition(0, 0, 0.01)
    end
  end
end

function FishingSceneCtrl:ShowLoopVideoQuad(bool)
  Logger.LogCustom("ShowLoopVideoQuad " .. (bool and "true" or "false") .. UITimeManager:GetInstance():GetServerTime())
  if self.loopQuad then
    if bool then
      self.loopQuad.transform:Set_localPosition(0, 0, -0.01)
    else
      self.loopQuad.transform:Set_localPosition(0, 0, 0.01)
    end
  end
end

function FishingSceneCtrl:ComponentDestroy()
  if self.timerUpdate then
    self.timerUpdate:Stop()
    self.timerUpdate = nil
  end
  self.allFishRoot = nil
  self.bgAnimator = nil
  self.manAnimator = nil
  self.manAnimator1 = nil
  self.manAnimator2 = nil
  self.cameraAnimator = nil
  self.fishRootAnimation = {}
  self.fishAnimator = {}
  self.startQuad = nil
  self.startVideoCreator = nil
  self.loopVideoCreator = nil
  self.loopQuad = nil
  self.fishSpine = nil
  self.vineSpine = nil
  self.defaultQuad = nil
end

function FishingSceneCtrl:DataDefine()
  self.curSize = 2
end

function FishingSceneCtrl:DataDestroy()
end

function FishingSceneCtrl:ResumeBGVideo()
  if self.isPause and self.loopVideoCreator then
    self.isPause = false
    self.loopVideoCreator:LoadVideo()
  end
end

function FishingSceneCtrl:PauseBGVideo()
  self.isPause = true
  self:ShowStartVideoQuad(false)
  self:ShowLoopVideoQuad(false)
  if self.loopVideoCreator then
    self.loopVideoCreator:PauseVideo()
  end
  if self.startVideoCreator then
    self.startVideoCreator:PauseVideo()
  end
  if self.timerPlayLoopVideo then
    self.timerPlayLoopVideo:Stop()
    self.timerPlayLoopVideo = nil
  end
end

function FishingSceneCtrl:OnLoadFishingVideoTimeout()
  self.startVideoShowed = true
  self:StopStartVideoAndPlayLoopVideo()
  self:ShowLoopVideoQuad(false)
end

function FishingSceneCtrl:OnQuadVideoPlayStarted(videoPath)
  if DataCenter.FishingDataManager:GetIsLoadVideoTimeout() then
    return
  end
  if videoPath == StartVideoPath then
    DataCenter.FishingDataManager:SetEnterPondFinished()
    if self.startVideoShowed then
      if self.startVideoCreator then
        self.startVideoCreator:PauseVideo()
      end
      return
    end
    self.startVideoShowed = true
    self:ShowStartVideoQuad(true)
    self:ShowLoopVideoQuad(false)
    self.startSerialId = DataCenter.LWSoundManager:PlaySound(6100040, false)
    self.startVideoStartTime = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetLong("FishingStartVideoStartTime", self.startVideoStartTime)
    self.loopVideoCreator:LoadVideo()
  elseif videoPath == LoopVideoPath then
    DataCenter.FishingDataManager:SetEnterPondFinished()
    if self.startVideoStartTime == nil then
      return
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    if now >= self.startVideoStartTime + StartVideoLength then
      self:StopStartVideoAndPlayLoopVideo()
    else
      if self.timerPlayLoopVideo then
        self.timerPlayLoopVideo:Stop()
      end
      self.timerPlayLoopVideo = TimerManager:GetInstance():DelayInvoke(function()
        self:StopStartVideoAndPlayLoopVideo()
      end, (self.startVideoStartTime + StartVideoLength - now) * 0.001)
    end
  end
end

function FishingSceneCtrl:StopStartVideoAndPlayLoopVideo()
  Logger.LogCustom("StopStartVideoAndPlayLoopVideo")
  self:ShowStartVideoQuad(false)
  self:ShowLoopVideoQuad(true)
  if self.startVideoCreator then
    self.startVideoCreator:PauseVideo()
  end
  if not self.loopVideoShowed then
    EventManager:GetInstance():Broadcast(EventId.FishingLoopVideoFirstStart)
    self.manAnimator.gameObject:SetActive(true)
    self.manAnimator:Play("diaoyu_ruchang")
    self.allFishRoot:SetActive(true)
    if not self.bgmSerialId then
      self.bgmSerialId = DataCenter.LWSoundManager:PlaySound(6100002, true)
    end
    if not self.ambSerialId then
      self.ambSerialId = DataCenter.LWSoundManager:PlaySound(6100003, true)
    end
    self.fishSpine.AnimationState:ClearTrack(0)
    self.fishSpine.gameObject:SetActive(true)
    self.fishSpine.AnimationState:SetAnimation(0, "fish" .. math.random(1, 3), false)
    self.fishSpineAnimCD = FishSpineAnimLength
    self.timerUpdate = TimerManager:GetInstance():GetTimer(1, self.Update1000MS, self, false, false, false)
    self.timerUpdate:Start()
  end
  self.vineSpine.AnimationState:ClearTrack(0)
  self.vineSpine.gameObject:SetActive(true)
  self.vineSpine.AnimationState:SetAnimation(0, "in", false)
  self.loopVideoShowed = true
end

function FishingSceneCtrl:Update1000MS()
  if self.fishSpineAnimCD then
    self.fishSpineAnimCD = self.fishSpineAnimCD - 1
    if self.fishSpineAnimCD <= 0 then
      self.fishSpineAnimCD = FishSpineAnimLength
      self.fishSpine.AnimationState:ClearTrack(0)
      self.fishSpine.AnimationState:SetAnimation(0, "fish" .. math.random(1, 3), false)
    end
  end
end

function FishingSceneCtrl:EnterState(state)
  if state == FishingState.NotStart then
    self.bgAnimator:Play("idle")
    self.cameraAnimator:Play("camera_idle")
    self.manAnimator:Play("diaoyu_kanggan_daiji")
    for i = 1, 3 do
      self.fishRootAnimation[i]:Play("Default")
      self.fishAnimator[i]:Play("yu_idle")
    end
  elseif state == FishingState.Charge then
    self.bgAnimator:Play("idle")
    self.cameraAnimator:Play("camera_idle")
    self.manAnimator:Play("diaoyu_shuaigan_qianyao")
    for i = 1, 3 do
      self.fishRootAnimation[i]:Play("Default")
      self.fishAnimator[i]:Play("yu_idle")
    end
  elseif state == FishingState.Wait then
    self.bgAnimator:Play("idle")
    self.cameraAnimator:Play("camera_idle")
    self.manAnimator:Play("diaoyu_shuaigan_houyao")
    for i = 1, 3 do
      self.fishRootAnimation[i]:Play("Default")
      self.fishAnimator[i]:Play("yu_idle")
    end
  elseif state == FishingState.Early then
    self.bgAnimator:Play("tuogou")
    self.cameraAnimator:Play("camera_tuogou")
    self.manAnimator:Play("diaoyu_tuogou")
    for i = 1, 3 do
      self.fishRootAnimation[i]:Play("Default")
      self.fishAnimator[i]:Play("yu_idle")
    end
    self.vineSpine.AnimationState:ClearTrack(0)
    self.vineSpine.AnimationState:SetAnimation(0, "advance", false)
  elseif state == FishingState.Hook then
    self.bgAnimator:Play("yaogou")
    self.cameraAnimator:Play("camera_yaogou")
    self.manAnimator:Play("diaoyu_yaogou_yaogou")
    self.fishRootAnimation[self.curSize]:Play("Fix")
    self.fishAnimator[self.curSize]:Play("yu_yaogou_01")
  elseif state == FishingState.Unhook then
    self.bgAnimator:Play("tuogou")
    self.cameraAnimator:Play("camera_tuogou")
    self.manAnimator:Play("diaoyu_tuogou")
    self.fishRootAnimation[self.curSize]:Play("Fix")
    self.fishAnimator[self.curSize]:Play("yu_tuogou")
    self.vineSpine.AnimationState:ClearTrack(0)
    self.vineSpine.AnimationState:SetAnimation(0, "advance", false)
  elseif state == FishingState.Reap then
    self.bgAnimator:Play("shangyu")
    self.cameraAnimator:Play("camera_shangyu")
    self.manAnimator:Play("diaoyu_shangyu")
    self.fishRootAnimation[self.curSize]:Play("Fix")
    self.fishAnimator[self.curSize]:Play("yu_shangyu")
    self.vineSpine.AnimationState:ClearTrack(0)
    self.vineSpine.AnimationState:SetAnimation(0, "advance", false)
  elseif state == FishingState.Confiscate then
    self.bgAnimator:Play("shangyu")
    self.cameraAnimator:Play("camera_shangyu_shibai")
    self.manAnimator:Play("diaoyu_shangyu_shibai")
    self.fishRootAnimation[self.curSize]:Play("Fix")
    self.fishAnimator[self.curSize]:CrossFade("yu_shangyu_shibai", 0.2)
    self.vineSpine.AnimationState:ClearTrack(0)
    self.vineSpine.AnimationState:SetAnimation(0, "advance", false)
  elseif state == FishingState.Reward then
    self.bgAnimator:Play("shangyu")
    self.cameraAnimator:Play("camera_shangyu")
    self.manAnimator:Play("diaoyu_shangyu")
    self.fishRootAnimation[self.curSize]:Play("Fix")
    self.fishAnimator[self.curSize]:Play("yu_shangyu")
    self.vineSpine.AnimationState:ClearTrack(0)
    self.vineSpine.AnimationState:SetAnimation(0, "advance", false)
  end
end

function FishingSceneCtrl:FishSwimToBait()
  self.fishRootAnimation[self.curSize]:Play("Default")
  self.fishAnimator[self.curSize]:Play("yu_yaogou")
end

function FishingSceneCtrl:OnFishAppear(fishId)
  local fishMeta = DataCenter.FishMetaManager:GetMeta(fishId)
  if fishMeta and fishMeta.size and fishMeta.size > 0 then
    self.curSize = fishMeta.size
  else
    self.curSize = 2
  end
end

return FishingSceneCtrl
