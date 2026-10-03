local EffectBGMManager = BaseClass("EffectBGMManager")

function EffectBGMManager:__init()
  self.effectId = 0
  self.curPlayingMusicEndTime = 0
  self.totalPlayingTime = 0
  self:AddListener()
  self:InitData()
end

function EffectBGMManager:__delete()
  self.effectId = nil
  self.curPlayingMusicEndTime = nil
  self.totalPlayingTime = nil
  self:RemoveListener()
end

function EffectBGMManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.LuaEntryEffectRefreshStatus, self.OnStatusChange)
end

function EffectBGMManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.LuaEntryEffectRefreshStatus, self.OnStatusChange)
end

function EffectBGMManager.OnStatusChange(statusId)
  DataCenter.EffectBGMManager:TrySetMusicData(statusId)
end

function EffectBGMManager:TrySetMusicData(statusId)
  if statusId == nil then
    return
  end
  local isMusicStatus = DataCenter.StatusManager:CheckStatusType2(tostring(statusId), StatusType2.MusicFestivalSkill)
  if not isMusicStatus then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local list = LuaEntry.Effect:GetStatusMap()
  local endTime = list[statusId]
  endTime = endTime and endTime / 1000
  if endTime and curTime < endTime then
    local soundName = DataCenter.StatusManager:GetStatusSoundName(statusId)
    if not string.IsNullOrEmpty(soundName) then
      local fullPath = "Assets/Main/Sound/Music/" .. soundName .. ".ogg"
      DataCenter.LWSoundManager:GetAudioLength(fullPath, function(length)
        self.effectId = statusId
        self.curPlayingMusicEndTime = endTime
        self.totalPlayingTime = length
        local curScene = CS.SceneManager.CurrSceneID
        if self:CheckMusicEffectRange(self.effectId) then
          CommonUtil.PlayGameBgMusic()
        end
      end)
    end
  end
end

function EffectBGMManager:InitData()
  local list = LuaEntry.Effect:GetStatusMap()
  if list then
    for k, v in pairs(list) do
      self:TrySetMusicData(k)
    end
  end
end

function EffectBGMManager:TryGetVal()
  if self.effectId and self.effectId > 0 and self:CheckMusicEffectRange(self.effectId) then
    local totalPlayingTime = self.totalPlayingTime
    local diffTime = self:GetBGMDiffTime()
    totalPlayingTime = totalPlayingTime + diffTime
    return self.effectId, self.curPlayingMusicEndTime, totalPlayingTime
  else
    return 0, 0, 0
  end
end

function EffectBGMManager:GetBGMName()
  local soundName = ""
  local temp = DataCenter.StatusManager:GetTemplate(tostring(self.effectId))
  local soundName = ""
  if temp and temp.music_sound then
    soundName = temp.music_sound
  end
  return soundName
end

function EffectBGMManager:GetBGMId()
  local soundId = 0
  if self.effectId and 0 < self.effectId then
    soundId = DataCenter.StatusManager:GetStatusSoundId(self.effectId)
  end
  return soundId
end

function EffectBGMManager:GetBGMDiffTime()
  local diffTime = 0
  local temp
  if self.effectId and 0 < self.effectId then
    temp = DataCenter.StatusManager:GetTemplate(tostring(self.effectId))
  end
  if temp then
    diffTime = tonumber(temp.para1) or 0
  end
  return diffTime
end

function EffectBGMManager:CheckMusicEffectRange(effectId)
  local isInRange = true
  local curScene = CS.SceneManager.CurrSceneID
  if curScene == SceneManagerSceneID.City then
  elseif curScene == SceneManagerSceneID.World then
    local effectRangeData = LuaEntry.Effect:GetStatusRange(effectId)
    if effectRangeData and effectRangeData.worldId then
      local targetWorldId = effectRangeData.worldId
      local curWorldId = LuaEntry.Player:GetCurWorldId()
      if curWorldId ~= targetWorldId then
        isInRange = false
      end
    end
  end
  return isInRange
end

return EffectBGMManager
