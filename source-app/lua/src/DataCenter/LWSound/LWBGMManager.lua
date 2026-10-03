local LWBGMManager = BaseClass("LWBGMManager")

function LWBGMManager:__init()
  EventManager:GetInstance():AddListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
  EventManager:GetInstance():AddListener(EventId.OnSceneCameraDisableRender, self.OnSceneCameraDisableRender)
  EventManager:GetInstance():AddListener(EventId.QueenOfBloodChangeWorldBgm, self.OnQueenOfBloodChangeWorldBgm)
  self.sourceType = BGMPlayingSourceType.Defaul
  self.sourceParam = 0
  self.sourceEndTime = 0
end

function LWBGMManager:__delete()
  self:ClearStopTimer()
  EventManager:GetInstance():RemoveListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
  EventManager:GetInstance():RemoveListener(EventId.OnSceneCameraDisableRender, self.OnSceneCameraDisableRender)
  EventManager:GetInstance():RemoveListener(EventId.QueenOfBloodChangeWorldBgm, self.OnQueenOfBloodChangeWorldBgm)
  self.sourceType = nil
  self.sourceParam = nil
  self.sourceEndTime = nil
end

function LWBGMManager.OnBloodyNightActivityRefresh(serverId)
  if serverId == LuaEntry.Player:GetSelfServerId() and DataCenter.LWSoundManager.inited then
    SceneUtils.TryPlayDarkneesSeasonBloodyNightBGM()
  end
end

function LWBGMManager.OnSceneCameraDisableRender(isDisable)
  if isDisable then
    CS.GameEntry.Sound:SetAMBSoundVolumeTo0()
  else
    CS.GameEntry.Sound:ResetAMBSoundVolume()
  end
end

function LWBGMManager.OnQueenOfBloodChangeWorldBgm()
  SceneUtils.PlayWorldBGM()
end

function LWBGMManager:StopBGM()
  if self.sourceType == BGMPlayingSourceType.DecorationBGM then
    DataCenter.DecorationBGMManager:StopBGMData()
  end
  self:ClearStopTimer()
  self.sourceType = BGMPlayingSourceType.Defaul
  self.sourceParam = 0
  self.sourceEndTime = 0
  CommonUtil.PlayGameBgMusic()
end

function LWBGMManager:ClearData()
  self:ClearStopTimer()
  self.sourceType = BGMPlayingSourceType.Defaul
  self.sourceParam = 0
  self.sourceEndTime = 0
end

function LWBGMManager:CheckHaveCanPlayBGMInSource()
  local isHave = false
  local sourceType = BGMPlayingSourceType.Defaul
  local sourceParam = 0
  local sourceEndTime = 0
  local sourceTotalPlayingTime = 0
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  sourceParam, sourceEndTime, sourceTotalPlayingTime = DataCenter.DecorationBGMManager:TryGetVal()
  if 0 < sourceParam and sourceEndTime > curTime and 1 < sourceEndTime - curTime then
    isHave = true
    return isHave
  end
  sourceParam, sourceEndTime, sourceTotalPlayingTime = DataCenter.EffectBGMManager:TryGetVal()
  if 0 < sourceParam and sourceEndTime > curTime and 1 < sourceEndTime - curTime then
    isHave = true
    return isHave
  end
  return isHave
end

function LWBGMManager:TryPlayBGM()
  local isHave = false
  local sourceType = BGMPlayingSourceType.Defaul
  local sourceParam = 0
  local sourceEndTime = 0
  local sourceTotalPlayingTime = 0
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  local isExistUISpecialBGm = DataCenter.LWUIBGMManager:IsExistUIBGMPlay()
  if isExistUISpecialBGm then
    return
  end
  if isHave == false then
    sourceParam, sourceEndTime, sourceTotalPlayingTime = DataCenter.DecorationBGMManager:TryGetVal()
    if 0 < sourceParam and sourceEndTime > curTime then
      sourceType = BGMPlayingSourceType.DecorationBGM
      isHave = true
    end
  end
  if isHave == false then
    sourceParam, sourceEndTime, sourceTotalPlayingTime = DataCenter.EffectBGMManager:TryGetVal()
    if 0 < sourceParam and sourceEndTime > curTime then
      sourceType = BGMPlayingSourceType.EffectBGM
      isHave = true
    end
  end
  if isHave == true and (self.sourceType == BGMPlayingSourceType.Defaul or self.sourceType ~= sourceType or self.sourceParam ~= sourceParam or self.sourceEndTime ~= sourceEndTime) then
    self.sourceType = sourceType
    self.sourceParam = sourceParam
    self.sourceEndTime = sourceEndTime
    self:ClearStopTimer()
    local length = sourceEndTime - curTime + 0.2
    self.delayStopTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:StopBGM()
    end, length)
    if self.sourceType == BGMPlayingSourceType.DecorationBGM then
      local bgmId = DataCenter.DecorationBGMManager:GetBGMId()
      if 0 < bgmId then
        DataCenter.LWSoundManager:PlaySound(bgmId)
      end
    elseif self.sourceType == BGMPlayingSourceType.EffectBGM then
      local bgmId = DataCenter.EffectBGMManager:GetBGMId()
      if 0 < bgmId then
        local startTime = 0
        if 0 < sourceTotalPlayingTime and sourceEndTime > curTime then
          startTime = sourceTotalPlayingTime - (sourceEndTime - curTime) - 0.1
          startTime = startTime < 0 and 0 or startTime
        end
        DataCenter.LWSoundManager:PlaySoundWithStartTime(bgmId, startTime, false, 0.01)
      end
    end
  end
end

function LWBGMManager:ClearStopTimer()
  if self.delayStopTimer ~= nil then
    self.delayStopTimer:Stop()
    self.delayStopTimer = nil
  end
end

return LWBGMManager
