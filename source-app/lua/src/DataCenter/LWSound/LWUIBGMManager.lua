local LWUIBGMManager = BaseClass("LWUIBGMManager")

function LWUIBGMManager:__init()
  self.allNeedPlayUIBgmList = {}
  self.bgmRefCount = {}
  self.currentBgmKey = nil
  self.ambRefCount = {}
  self.currentAmbKey = nil
  self.currentAmbSoundInstanceId = nil
end

function LWUIBGMManager:__delete()
  self.allNeedPlayUIBgmList = nil
  self.bgmRefCount = nil
  self.currentBgmKey = nil
  self.ambRefCount = nil
  self.currentAmbKey = nil
  self.currentAmbSoundInstanceId = nil
end

function LWUIBGMManager:RegisterUIBGMPlay(bgmType)
  for _, v in ipairs(self.allNeedPlayUIBgmList) do
    if v == bgmType then
      return
    end
  end
  table.insert(self.allNeedPlayUIBgmList, bgmType)
end

function LWUIBGMManager:RemoveUIBGMPlay(bgmType)
  table.removebyvalue(self.allNeedPlayUIBgmList, bgmType)
end

function LWUIBGMManager:IsExistUIBGMPlay()
  return self.allNeedPlayUIBgmList and #self.allNeedPlayUIBgmList > 0
end

function LWUIBGMManager:PlayActivityBGM(activityId, soundId)
  if not (activityId and soundId) or tonumber(soundId) == nil or tonumber(soundId) <= 0 then
    return
  end
  local sid = tonumber(soundId)
  local newKey = tostring(sid)
  local idKey = tostring(activityId)
  if self.currentBgmKey ~= nil and self.currentBgmKey ~= newKey then
    self.bgmRefCount = {}
    self.currentBgmKey = nil
  end
  self.bgmRefCount[idKey] = (self.bgmRefCount[idKey] or 0) + 1
  if self.currentBgmKey == newKey then
    return
  end
  self.currentBgmKey = newKey
  DataCenter.LWSoundManager:PlaySound(sid, true)
end

function LWUIBGMManager:StopActivityBGM(activityId)
  if not activityId then
    return
  end
  local idKey = tostring(activityId)
  if self.currentBgmKey == nil then
    return
  end
  if not self.bgmRefCount[idKey] then
    return
  end
  self.bgmRefCount[idKey] = self.bgmRefCount[idKey] - 1
  if self.bgmRefCount[idKey] <= 0 then
    self.bgmRefCount[idKey] = nil
  end
  for _ in pairs(self.bgmRefCount) do
    return
  end
  self.currentBgmKey = nil
  DataCenter.LWSoundManager:StopBGMusic()
  CommonUtil.PlayGameBgMusic()
end

function LWUIBGMManager:GetCurrentBgmKey()
  return self.currentBgmKey
end

function LWUIBGMManager:PlayActivityAmb(activityId, soundId)
  if not (activityId and soundId) or tonumber(soundId) == nil or tonumber(soundId) <= 0 then
    return
  end
  local sid = tonumber(soundId)
  local newKey = tostring(sid)
  local idKey = tostring(activityId)
  if self.currentAmbKey ~= nil and self.currentAmbKey ~= newKey then
    if self.currentAmbSoundInstanceId and 0 < self.currentAmbSoundInstanceId then
      DataCenter.LWSoundManager:StopSound(self.currentAmbSoundInstanceId)
    end
    self.ambRefCount = {}
    self.currentAmbKey = nil
    self.currentAmbSoundInstanceId = nil
  end
  self.ambRefCount[idKey] = (self.ambRefCount[idKey] or 0) + 1
  if self.currentAmbKey == newKey then
    return
  end
  self.currentAmbKey = newKey
  DataCenter.LWSoundManager:StopAMBSound()
  local instanceId = DataCenter.LWSoundManager:PlayAMBSound(sid)
  if instanceId and 0 < instanceId then
    self.currentAmbSoundInstanceId = instanceId
  end
end

function LWUIBGMManager:StopActivityAmb(activityId)
  if not activityId then
    return
  end
  local idKey = tostring(activityId)
  if self.currentAmbKey == nil then
    return
  end
  if not self.ambRefCount[idKey] then
    return
  end
  self.ambRefCount[idKey] = self.ambRefCount[idKey] - 1
  if self.ambRefCount[idKey] <= 0 then
    self.ambRefCount[idKey] = nil
  end
  for _ in pairs(self.ambRefCount) do
    return
  end
  self.currentAmbKey = nil
  if self.currentAmbSoundInstanceId and 0 < self.currentAmbSoundInstanceId then
    DataCenter.LWSoundManager:StopSound(self.currentAmbSoundInstanceId)
    self.currentAmbSoundInstanceId = nil
    CommonUtil.PlayGameBgMusic()
  end
end

function LWUIBGMManager:GetCurrentAmbKey()
  return self.currentAmbKey
end

return LWUIBGMManager
