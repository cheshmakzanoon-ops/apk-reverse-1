local SingleFlowerTrainEffControl = BaseClass("SingleFlowerTrainEffControl")
local GameObject = CS.UnityEngine.GameObject
local ResourceManager = CS.GameEntry.Resource
local GameQualitySettings = require("Util.GameQualitySettings")
local FlowerTrainConstant = require("DataCenter.FlowerTrain.FlowerTrainConstant")
local FlowerTrainEffType = {
  RewardBox = 101,
  WaitRewardStatusEff = 201,
  WaitRewardDoneStatusEff = 202,
  BoxAppearEff = 301,
  BoxIdleEff = 302,
  BoomEff = 401
}
local EffHangUpPointCfg = {
  [FlowerTrainEffType.RewardBox] = "Eff_daliwu",
  [FlowerTrainEffType.WaitRewardStatusEff] = "Eff_Root",
  [FlowerTrainEffType.WaitRewardDoneStatusEff] = "Eff_Root",
  [FlowerTrainEffType.BoxAppearEff] = "Eff_daliwu",
  [FlowerTrainEffType.BoxIdleEff] = "Eff_daliwu",
  [FlowerTrainEffType.BoomEff] = "Eff_daliwu"
}
local EffGenPosOffsetCfg = {
  [FlowerTrainEffType.WaitRewardStatusEff] = Vector3.New(0, 1.5, 0),
  [FlowerTrainEffType.WaitRewardDoneStatusEff] = Vector3.New(0, 1.5, 0)
}
local EffDurationCfg = {
  [FlowerTrainEffType.RewardBox] = -1,
  [FlowerTrainEffType.WaitRewardStatusEff] = -1,
  [FlowerTrainEffType.WaitRewardDoneStatusEff] = 1,
  [FlowerTrainEffType.BoxAppearEff] = 2,
  [FlowerTrainEffType.BoxIdleEff] = -1,
  [FlowerTrainEffType.BoomEff] = 3
}
local EffLodShowConfig = {
  [FlowerTrainEffType.RewardBox] = 999,
  [FlowerTrainEffType.WaitRewardStatusEff] = 1,
  [FlowerTrainEffType.WaitRewardDoneStatusEff] = 1,
  [FlowerTrainEffType.BoxAppearEff] = 1,
  [FlowerTrainEffType.BoxIdleEff] = 1,
  [FlowerTrainEffType.BoomEff] = 1
}
local EffDisplayLvConfig = {
  [FlowerTrainEffType.RewardBox] = true,
  [FlowerTrainEffType.WaitRewardStatusEff] = true,
  [FlowerTrainEffType.WaitRewardDoneStatusEff] = true,
  [FlowerTrainEffType.BoxAppearEff] = false,
  [FlowerTrainEffType.BoxIdleEff] = false,
  [FlowerTrainEffType.BoomEff] = true
}
local EffHideInLowQuality = {
  [FlowerTrainEffType.RewardBox] = false,
  [FlowerTrainEffType.WaitRewardStatusEff] = false,
  [FlowerTrainEffType.WaitRewardDoneStatusEff] = false,
  [FlowerTrainEffType.BoxAppearEff] = true,
  [FlowerTrainEffType.BoxIdleEff] = true,
  [FlowerTrainEffType.BoomEff] = true
}

function SingleFlowerTrainEffControl:__init()
end

function SingleFlowerTrainEffControl:__delete()
  self:Destroy()
end

function SingleFlowerTrainEffControl:Init(singleTrainData, carTrans)
  self.singleTrainData = singleTrainData
  self.carTrans = carTrans
  self.allEffReqDic = nil
  self.prefabPathDic = nil
  self.effDurationDic = nil
  self.effTimerDic = nil
  self.allAniCacheDic = nil
  self.isSimple = DisplaySettings.GetCurrentDisplayLevel() < 0
  self.lod = CS.SceneManager.World:GetLodLevel()
end

function SingleFlowerTrainEffControl:OnStateChange(fromState, toState)
  self.fromState = fromState
  self.toState = toState
  if not self.carTrans then
    Logger.LogError("SingleFlowerTrainEffControl:OnEnterTargetState carTrans is nil")
    return
  end
  self:RefreshRewardBoxState(fromState, toState)
  self:RefreshRewardBoxStateIconEff(fromState, toState)
end

function SingleFlowerTrainEffControl:RefreshStateWithoutAni()
  if not self.toState then
    self:DestroyAllEff()
    return
  end
  self:RefreshRewardBoxStateWithoutAni()
  self:RefreshRewardBoxStateIconEffWithoutAni()
end

function SingleFlowerTrainEffControl:RefreshRewardBoxState(fromState, toState)
  if not self.singleTrainData then
    return
  end
  if fromState == FlowerTrainState.WaitingReward and toState == FlowerTrainState.Normal then
    self:PlayRewardBoxBoomAniAndEff()
  elseif toState == FlowerTrainState.Normal then
    self:DestroyAllEff()
  elseif toState == FlowerTrainState.WaitingReward then
    local now = UITimeManager:GetInstance():GetServerTime()
    local prevUpgradeTime = self.singleTrainData:GetPrevUpgradeTime()
    local passUpgradeTime = now - prevUpgradeTime
    local isNeedPlayAppearAni = passUpgradeTime <= 2000
    if isNeedPlayAppearAni then
      self:PlayRewardBoxAppearAniAndEff()
    else
      self:PlayRewardBoxIdleAniAndEff()
    end
  end
end

function SingleFlowerTrainEffControl:RefreshRewardBoxStateWithoutAni()
  if not self.singleTrainData then
    return
  end
  if self.toState == FlowerTrainState.Normal then
    self:DestroyAllEff()
  elseif self.toState == FlowerTrainState.WaitingReward then
    self:PlayRewardBoxIdleAniAndEff()
  end
end

function SingleFlowerTrainEffControl:RefreshRewardBoxStateIconEff(fromState, toState)
  if toState == FlowerTrainState.WaitingReward then
    self:DestroyWaitRewardDoneStatusEff()
    self:GenWaitRewardStatusEff()
  elseif fromState == FlowerTrainState.WaitingReward and toState == FlowerTrainState.Normal then
    self:DestroyWaitRewardStatusEff()
    self:GenWaitRewardDoneStatusEff()
  else
    self:DestroyWaitRewardDoneStatusEff()
    self:DestroyWaitRewardStatusEff()
  end
end

function SingleFlowerTrainEffControl:RefreshRewardBoxStateIconEffWithoutAni()
  if not self.toState then
    self:DestroyWaitRewardDoneStatusEff()
    self:DestroyWaitRewardStatusEff()
    return
  end
  if self.toState == FlowerTrainState.WaitingReward then
    self:DestroyWaitRewardDoneStatusEff()
    self:GenWaitRewardStatusEff()
  else
    self:DestroyWaitRewardDoneStatusEff()
    self:DestroyWaitRewardStatusEff()
  end
end

function SingleFlowerTrainEffControl:LoadEff(effType, aniName, callback)
  local isCanShow = self:GetEffCurShowHideState(effType)
  if not isCanShow then
    return
  end
  if self.allEffReqDic and self.allEffReqDic[effType] then
    if self.allEffReqDic[effType].gameObject then
      local req = self.allEffReqDic[effType]
      local obj = req.gameObject
      if obj and not obj.activeSelf then
        obj:SetActive(true)
      end
      local boxAni = self:GetAniCptFromCacheByType(effType)
      if boxAni then
        boxAni:Play(aniName)
        if callback and req.gameObject then
          callback(req.gameObject)
        end
      end
      self:StartEffDestroyTimer(effType, req)
    end
    return
  end
  local prefabPath = self:GetPrefabPathByEffType(effType)
  if not prefabPath or prefabPath == "" then
    Logger.LogError("SingleFlowerTrainEffControl:LoadEff prefabPath is nil or empty")
    return
  end
  local parent = self:GetHangUpPointByEffType(effType)
  if not parent then
    Logger.LogError("SingleFlowerTrainEffControl:LoadEff parent is nil")
    return
  end
  local req = ResourceManager:InstantiateAsync(prefabPath)
  req:completed("+", function(request)
    if request.isError then
      return
    end
    local obj = request.gameObject
    local trans = obj.transform
    if trans and parent then
      trans:SetParent(parent)
      trans:Set_localScale(1, 1, 1)
      trans:Set_localEulerAngles(0, 0, 0)
      if EffGenPosOffsetCfg[effType] then
        trans:Set_localPosition(EffGenPosOffsetCfg[effType].x, EffGenPosOffsetCfg[effType].y, EffGenPosOffsetCfg[effType].z)
      else
        trans:Set_localPosition(0, 0, 0)
      end
      if aniName then
        local animator = trans:GetComponentInChildren(typeof(CS.SimpleAnimation))
        if animator then
          animator:Rewind(aniName)
          animator:Play(aniName)
          self.allAniCacheDic = self.allAniCacheDic or {}
          self.allAniCacheDic[effType] = animator
        end
      end
    end
    if callback and request.gameObject then
      callback(request.gameObject)
    end
    local isShow = self:GetEffCurShowHideState(effType)
    if not isShow and request.gameObject then
      request.gameObject:SetActive(false)
    end
  end)
  if not self.allEffReqDic then
    self.allEffReqDic = {}
  end
  self.allEffReqDic[effType] = req
  self:StartEffDestroyTimer(effType, req)
end

function SingleFlowerTrainEffControl:StartEffDestroyTimer(type, req)
  if not self.effTimerDic then
    self.effTimerDic = {}
  end
  if self.effTimerDic[req] then
    self.effTimerDic[req]:Stop()
    self.effTimerDic[req] = nil
  end
  local delay = self:GetEffDurationByEffType(type) or 1
  if delay < 0 then
    return
  end
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    self:DestroyEff(type)
  end, delay)
  self.effTimerDic[req] = timer
end

function SingleFlowerTrainEffControl:StopAllTimer()
  if not self.effTimerDic then
    return
  end
  for _, v in pairs(self.effTimerDic) do
    v:Stop()
  end
  self.effTimerDic = nil
  if self.rewardBoxAppearTimer then
    self.rewardBoxAppearTimer:Stop()
    self.rewardBoxAppearTimer = nil
  end
end

function SingleFlowerTrainEffControl:DestroyEff(effType)
  if not self.allEffReqDic then
    return
  end
  local req = self.allEffReqDic[effType]
  if not req then
    return
  end
  local timer = self.effTimerDic[req]
  if timer then
    timer:Stop()
    self.effTimerDic[req] = nil
  end
  req:Destroy()
  self.allEffReqDic[effType] = nil
  if self.allAniCacheDic and self.allAniCacheDic[effType] then
    self.allAniCacheDic[effType] = nil
  end
end

function SingleFlowerTrainEffControl:PlayRewardBoxAppearAniAndEff()
  self:PlayRewardBoxAni("born")
  self:GenRewardBoxAppearEff()
  if self.rewardBoxAppearTimer then
    self.rewardBoxAppearTimer:Stop()
    self.rewardBoxAppearTimer = nil
  end
  local delay = FlowerTrainConstant.FlowerTrainRewardBoxLoopEffDelayTime
  if 0 < delay then
    self.rewardBoxAppearTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:PlayRewardBoxIdleAniAndEff()
      self.rewardBoxAppearTimer = nil
    end, delay)
  else
    self:PlayRewardBoxIdleAniAndEff()
  end
end

function SingleFlowerTrainEffControl:PlayRewardBoxIdleAniAndEff()
  self:PlayRewardBoxAni("idle")
  self:GenRewardBoxIdleEff()
end

function SingleFlowerTrainEffControl:PlayRewardBoxBoomAniAndEff()
  self:PlayRewardBoxAni("open")
  self:GenBoomEff()
  self:DestroyRewardBoxIdleEff()
end

function SingleFlowerTrainEffControl:PlayRewardBoxAni(aniName)
  self:LoadEff(FlowerTrainEffType.RewardBox, aniName)
end

function SingleFlowerTrainEffControl:GenWaitRewardStatusEff()
  self:LoadEff(FlowerTrainEffType.WaitRewardStatusEff)
end

function SingleFlowerTrainEffControl:DestroyWaitRewardStatusEff()
  self:DestroyEff(FlowerTrainEffType.WaitRewardStatusEff)
end

function SingleFlowerTrainEffControl:GenWaitRewardDoneStatusEff()
  self:LoadEff(FlowerTrainEffType.WaitRewardDoneStatusEff)
end

function SingleFlowerTrainEffControl:DestroyWaitRewardDoneStatusEff()
  self:DestroyEff(FlowerTrainEffType.WaitRewardDoneStatusEff)
end

function SingleFlowerTrainEffControl:GenRewardBox(aniName)
  self:LoadEff(FlowerTrainEffType.RewardBox)
end

function SingleFlowerTrainEffControl:DestoryRewadBox()
  self:DestroyEff(FlowerTrainEffType.RewardBox)
end

function SingleFlowerTrainEffControl:GenRewardBoxAppearEff()
  self:LoadEff(FlowerTrainEffType.BoxAppearEff)
end

function SingleFlowerTrainEffControl:DestroyRewardBoxAppearEff()
  self:DestroyEff(FlowerTrainEffType.BoxAppearEff)
end

function SingleFlowerTrainEffControl:GenRewardBoxIdleEff()
  self:LoadEff(FlowerTrainEffType.BoxIdleEff)
end

function SingleFlowerTrainEffControl:DestroyRewardBoxIdleEff()
  self:DestroyEff(FlowerTrainEffType.BoxIdleEff)
end

function SingleFlowerTrainEffControl:PlayDropRewardEff()
  self:LoadEff(FlowerTrainEffType.DropRewardEff)
end

function SingleFlowerTrainEffControl:DestroyDropRewardEff()
  self:DestroyEff(FlowerTrainEffType.DropRewardEff)
end

function SingleFlowerTrainEffControl:GenBoomEff()
  self:LoadEff(FlowerTrainEffType.BoomEff)
end

function SingleFlowerTrainEffControl:DestroyBoomEff()
  self:DestroyEff(FlowerTrainEffType.BoomEff)
end

function SingleFlowerTrainEffControl:GetPrefabPathByEffType(type)
  if not self.prefabPathDic then
    self.prefabPathDic = {}
  end
  if not self.singleTrainData then
    Logger.LogError("SingleFlowerTrainEffControl:GetPrefabPathByEffType singleTrainData is nil")
    return
  end
  if self.prefabPathDic[type] then
    return self.prefabPathDic[type]
  end
  local path
  if type == FlowerTrainEffType.RewardBox then
    path = self.singleTrainData:GetDropBoxPrefabPath()
  elseif type == FlowerTrainEffType.WaitRewardStatusEff then
    path = self.singleTrainData:GetWaitRewardStateEffPath()
  elseif type == FlowerTrainEffType.WaitRewardDoneStatusEff then
    path = self.singleTrainData:GetWaitRewardCompleteStateEffPath()
  elseif type == FlowerTrainEffType.BoxAppearEff then
    path = self.singleTrainData:GetDropBoxAppearEffPath()
  elseif type == FlowerTrainEffType.BoxIdleEff then
    path = self.singleTrainData:GetDropBoxIdleEffPath()
  elseif type == FlowerTrainEffType.BoomEff then
    path = self.singleTrainData:GetDropBoxBoomEffPath()
  end
  self.prefabPathDic[type] = path
  return path
end

function SingleFlowerTrainEffControl:GetEffDurationByEffType(type)
  return EffDurationCfg[type] or 1
end

function SingleFlowerTrainEffControl:GetHangUpPointByEffType(type)
  if not self.effHangUpPointDic then
    self.effHangUpPointDic = {}
  end
  if self.effHangUpPointDic[type] then
    return self.effHangUpPointDic[type]
  end
  if not self.carTrans then
    Logger.LogError("SingleFlowerTrainEffControl:BlindPoint carTrans is nil")
    return
  end
  local path = EffHangUpPointCfg[type]
  if not path then
    return nil
  end
  local node = self.carTrans:Find(path)
  if node then
    self.effHangUpPointDic[type] = node
  end
  return self.effHangUpPointDic[type]
end

function SingleFlowerTrainEffControl:GetAniCptFromCacheByType(type)
  if not self.allAniCacheDic then
    return nil
  end
  return self.allAniCacheDic[type]
end

function SingleFlowerTrainEffControl:OnChangeCameraLod(lod)
  if not lod then
    return
  end
  self.lod = lod
  self:CheckAllEffShowHideState()
  if self.lod == 1 then
    self:RefreshStateWithoutAni()
  end
end

function SingleFlowerTrainEffControl:OnDisplayModeUpdate(displayLv)
  if not displayLv then
    return
  end
  self.displayLv = displayLv
  self.isSimple = displayLv < 0
  self:CheckAllEffShowHideState()
end

function SingleFlowerTrainEffControl:CheckAllEffShowHideState()
  if self.allEffReqDic then
    for effType, req in pairs(self.allEffReqDic) do
      if req and req.gameObject then
        local isShow = self:GetEffCurShowHideState(effType)
        if not isShow then
          req.gameObject:SetActive(false)
        end
      end
    end
  end
end

function SingleFlowerTrainEffControl:GetEffCurShowHideState(effType)
  if self.lod then
    local showLod = EffLodShowConfig[effType]
    if showLod < self.lod then
      return false
    end
  end
  if self.isSimple then
    local isShowInSimpleMode = EffDisplayLvConfig[effType]
    if not isShowInSimpleMode then
      return false
    end
  end
  local isHideInLowQuality = EffHideInLowQuality[effType]
  if GameQualitySettings.IsLowGearQuality() and isHideInLowQuality then
    return false
  end
  return true
end

function SingleFlowerTrainEffControl:DestroyAllEff()
  if not self.allEffReqDic then
    return
  end
  for _, v in pairs(self.allEffReqDic) do
    v:Destroy()
  end
  self.allEffReqDic = nil
  self.allAniCacheDic = nil
end

function SingleFlowerTrainEffControl:Destroy()
  self:DestroyAllEff()
  self:StopAllTimer()
  self.effHangUpPointDic = nil
  self.singleTrainData = nil
  self.carTrans = nil
  self.allAniCacheDic = nil
end

return SingleFlowerTrainEffControl
