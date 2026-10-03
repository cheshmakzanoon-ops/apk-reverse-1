local LWSoundManager = BaseClass("LWSoundManager")
local LWSoundTimer = require("DataCenter.LWSound.LWSoundTimer")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local VOLUME_RATIO_TRANSITION_DURATION = 0.3
local VOLUME_RATIO_TRANSITION_INTERVAL = 0.1
local VOLUME_RATIO_TRANSITION_TARGET = 0.5

function LWSoundManager:__init()
  self.busy = {}
  for i = 1, SoundLimitType.MAX do
    self.busy[i] = {}
  end
  self.limit = {
    [SoundLimitType.UnitDeath] = 2,
    [SoundLimitType.BulletHit] = 1,
    [SoundLimitType.BulletCreate] = 1,
    [SoundLimitType.TroopAttackCity] = 1,
    [SoundLimitType.TroopMarching] = 1,
    [SoundLimitType.BossWarning] = 1,
    [SoundLimitType.SkillFire] = 1
  }
  self.limitById = {
    [91001] = {num = 1, time = 0.5}
  }
  self.busyByName = {}
  self.busyById = nil
  self.busySoundIdToMetaId = {}
  self:AddUpdateTimer()
  self.isEffectOn = CS.GameEntry.Setting:GetBool(SettingKeys.EFFECT_MUSIC_ON, true)
  self.effectExtraGroup = {}
  self.loopTimerList = {}
  self.loopTimerIdList = {}
  self.envSoundGroupIndexList = {}
  self.isEnvSoundSwitchOn = nil
  self.volumeRatioTransitionTimer = nil
end

function LWSoundManager:SetAudioMixerUsable(usable, callback)
  self.audioMixerUsableGMCallback = callback
  CS.GameEntry.Sound:SyncAudioMixerUsing(usable)
end

function LWSoundManager:InitAudioMixerUsable(callback)
  self.inited = false
  self.audioMixerUsableCallback = callback
  self:SetAudioMixerUsableByTable()
  self:CheckAndSetDefaultLoadingBGM()
end

function LWSoundManager:SetAudioMixerUsableByTable()
  local usable = LuaEntry.DataConfig:CheckSwitch("audio_mixer_2")
  Logger.LogInfo("[AudioMixer]AudioMixer Option: " .. tostring(usable))
  CS.GameEntry.Sound:SyncAudioMixerUsing(usable)
end

function LWSoundManager:SyncUseAudioMixer(use)
  self.inited = true
  self.useAudioMixer = use
  if self.useAudioMixer then
    self:SetupSoundGroup()
    self:Setup3DAudioZoomRange()
    self:CheckSoundOutput()
  end
  if self.audioMixerUsableCallback ~= nil then
    self.audioMixerUsableCallback()
    self.audioMixerUsableCallback = nil
  end
  if self.audioMixerUsableGMCallback ~= nil then
    self.audioMixerUsableGMCallback()
    self.audioMixerUsableGMCallback = nil
  end
end

function LWSoundManager:__delete()
  self:RemoveUpdateTimer()
  self:StopVolumeRatioTransitionTimer()
  self.busy = nil
  self.limit = nil
  self.loopTimerList = nil
  self.loopTimerIdList = nil
  self.limitById = nil
  self.busyById = nil
  self.busyByName = nil
  self.effectExtraGroup = nil
  self.abTest = nil
  self.useAudioMixer = nil
  self.envSoundGroupIndexList = nil
  self.effectExtraGroup = nil
  self.busySoundIdToMetaId = nil
  self.audioMixerUsableCallback = nil
  self.audioMixerUsableGMCallback = nil
  self.isEnvSoundSwitchOn = nil
end

function LWSoundManager:SetupSoundGroup()
  local temps = DataCenter.LWSoundTemplateManager:GetGroupTemplates()
  for _, t in pairs(temps) do
    local lodEqCityMin = 0
    local lodEqCityMax = 0
    local lodVolumeCityMin = 0
    local lodVolumeCityMax = 0
    local lodEqWorldMin = 0
    local lodEqWorldMax = 0
    local lodVolumeWorldMin = 0
    local lodVolumeWorldMax = 0
    if t.lod_eq_city and #t.lod_eq_city > 1 then
      lodEqCityMin = tonumber(t.lod_eq_city[1])
      lodEqCityMax = tonumber(t.lod_eq_city[2])
    end
    if t.lod_volume_city and 1 < #t.lod_volume_city then
      lodVolumeCityMin = tonumber(t.lod_volume_city[1])
      lodVolumeCityMax = tonumber(t.lod_volume_city[2])
    end
    if t.lod_eq_world and 1 < #t.lod_eq_world then
      lodEqWorldMin = tonumber(t.lod_eq_world[1])
      lodEqWorldMax = tonumber(t.lod_eq_world[2])
    end
    if t.lod_volume_world and 1 < #t.lod_volume_world then
      lodVolumeWorldMin = tonumber(t.lod_volume_world[1])
      lodVolumeWorldMax = tonumber(t.lod_volume_world[2])
    end
    CS.GameEntry.Sound:SetupSoundGroup(t.group, t.menu_option, lodVolumeCityMin, lodVolumeCityMax, lodEqCityMin, lodEqCityMax, lodVolumeWorldMin, lodVolumeWorldMax, lodEqWorldMin, lodEqWorldMax)
  end
end

function LWSoundManager:Setup3DAudioZoomRange()
  if LuaEntry == nil then
    return
  end
  local cityMin = 0
  local cityMax = 0
  local worldMin = 0
  local worldMax = 0
  local cityStr = LuaEntry.DataConfig:TryGetStr("3d_audio_camera_range", "k1", "")
  if not string.IsNullOrEmpty(cityStr) then
    local city = string.split(cityStr, "|")
    if 1 < #city then
      cityMin = tonumber(city[1])
      cityMax = tonumber(city[2])
    end
  end
  local worldStr = LuaEntry.DataConfig:TryGetStr("3d_audio_camera_range", "k2", "")
  if not string.IsNullOrEmpty(worldStr) then
    local world = string.split(worldStr, "|")
    if 1 < #world then
      worldMin = tonumber(world[1])
      worldMax = tonumber(world[2])
    end
  end
  CS.GameEntry.Sound:Setup3DAudioZoomRange(cityMin, cityMax, worldMin, worldMax)
end

function LWSoundManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function LWSoundManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function LWSoundManager:OnUpdate()
  local deltaTime = Time.deltaTime
  for i = 1, SoundLimitType.MAX do
    for j = 1, self.limit[i] do
      if self.busy[i][j] then
        self.busy[i][j] = self.busy[i][j] - deltaTime
        if self.busy[i][j] < 0 then
          self.busy[i][j] = nil
        end
      end
    end
  end
  for key, value in pairs(self.busyByName) do
    for i = #value, 1, -1 do
      value[i] = value[i] - deltaTime
      if value[i] <= 0 then
        table.remove(value, i)
      end
    end
  end
  if self.busyById then
    local busyCount = 0
    for id, value in pairs(self.busyById) do
      local count = 0
      for soundId, time in pairs(value) do
        local newValue = time - deltaTime
        if newValue < 0 then
          value[soundId] = nil
          self.busySoundIdToMetaId[soundId] = nil
        else
          value[soundId] = newValue
          count = count + 1
        end
      end
      if count == 0 then
        self.busyById[id] = nil
      else
        busyCount = busyCount + 1
      end
    end
    if busyCount == 0 then
      self.busyById = nil
    end
  end
end

function LWSoundManager:GetSound(id)
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return nil
  end
  local assetName
  if self.useAudioMixer then
    assetName = meta.sound:GetRandom()
    if not assetName then
      assetName = meta.audioSource
      if not assetName then
        Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140audiosource\228\184\186\231\169\186", id))
        return nil
      end
    end
  else
    assetName = meta.sound:GetRandom()
    if not assetName then
      assetName = meta.soundPath2:GetRandom()
      if not assetName then
        Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\229\146\140sound2\229\136\151\233\131\189\228\184\186\231\169\186", id))
        return nil
      end
    end
  end
  return assetName
end

function LWSoundManager:GetAudioLength(path, callback)
  CS.GameEntry.Sound:GetAudioLength(path, callback)
end

function LWSoundManager:GetDspBufferSize()
  return CS.GameEntry.Sound:GetDspBufferSize()
end

function LWSoundManager:SetDspBufferSize(value)
  CS.GameEntry.Sound:SetDspBufferSize(value)
end

function LWSoundManager:GetDSPTime()
  return CS.GameEntry.Sound:GetDSPTime()
end

function LWSoundManager:StopSound(id, ignorePlayBgm)
  if id and 0 < id then
    CS.GameEntry.Sound:StopSound(id)
    local busyMetaId = self.busySoundIdToMetaId[id]
    if busyMetaId then
      if self.busyById then
        local limitData = self.busyById[busyMetaId]
        if limitData then
          limitData[id] = nil
        end
      end
      self.busySoundIdToMetaId[id] = nil
    end
    if self.envSoundGroupIndexList then
      for index, soundId in ipairs(self.envSoundGroupIndexList) do
        if soundId == id then
          self.envSoundGroupIndexList[index] = 0
          break
        end
      end
    end
  end
  if id == self:GetBGMusic() and not ignorePlayBgm then
    CommonUtil.PlayGameBgMusic()
  end
end

function LWSoundManager:GetBGMusic()
  return CS.GameEntry.Sound:GetBGMusic()
end

function LWSoundManager:StopAllSounds()
  CS.GameEntry.Sound:StopAllSounds()
  if self.busyById then
    self.busyById = nil
    self.busySoundIdToMetaId = {}
  end
  self.envSoundGroupIndexList = {}
end

function LWSoundManager:IsEnvSwitchOn()
  if self.isEnvSoundSwitchOn == nil then
    self.isEnvSoundSwitchOn = LuaEntry.DataConfig:CheckSwitch("amb_sound_settings")
  end
  return self.isEnvSoundSwitchOn
end

function LWSoundManager:PlayAMBSound(id)
  if not self:IsEnvSwitchOn() then
    return 0
  end
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return 0
  end
  if self.useAudioMixer then
    return self:PlaySound(id)
  else
    local assetName
    if meta.usePath2 then
      assetName = meta.soundPath2:GetRandom()
    else
      assetName = meta.sound:GetRandom()
    end
    return CS.GameEntry.Sound:PlayAMBSound(assetName, meta.usePath2, meta.soundPathTable, meta.sound_volume, meta.reactive, meta.loop_gap, meta.pre_time, meta.speed)
  end
end

function LWSoundManager:PlaySound(id, loop, independent)
  return self:GetPlayAudioParamsFromTemplate(id)
end

function LWSoundManager:GetPlayAudioParamsFromTemplate(id)
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return nil
  end
  local instanceTemp = DataCenter.LWSoundTemplateManager:GetSoundMaxInstancesTemp(meta.instanceGroupId)
  local param = CS.SoundComponent.PlayAudioParams()
  param.id = id
  param.path = meta.audioSource
  param.delayMin = meta.soundDelayMin
  param.delayMax = meta.soundDelayMax
  param.loop = meta.loop
  param.reactive = meta.reactive
  param.fadeIn = meta.fadeIn
  param.fadeOut = meta.fadeOut
  param.loopGap = meta.loopEndGap
  param.limit = meta.instanceLimit
  param.whenEqual = meta.whenPriorityEqual
  param.randomType = meta.randomType
  param.randomPitchMin = meta.randomPitchMin
  param.randomPitchMax = meta.randomPitchMax
  param.randomVolumeMin = meta.randomVolumeMin
  param.randomVolumeMax = meta.randomVolumeMax
  param.instanceGroupLimit = 1
  if instanceTemp then
    param.instanceGroupId = meta.instanceGroupId
    param.instanceGroupLimit = instanceTemp.instanceLimit
    param.instanceGroupWhenEqual = instanceTemp.whenPriorityEqual
  end
  return param
end

function LWSoundManager:PlayAudio(playAudioParams)
  return CS.GameEntry.Sound:PlayAudio(playAudioParams)
end

function LWSoundManager:PreloadSound(id)
  if id == nil or id == 0 then
    return
  end
  if not self.useAudioMixer then
    return
  end
  CS.GameEntry.Sound:PreloadAudioById(id)
end

function LWSoundManager:ReleasePreloadedSound(id)
  if id == nil or id == 0 then
    return
  end
  if not self.useAudioMixer then
    return
  end
  CS.GameEntry.Sound:ReleasePreloadedAudioById(id)
end

function LWSoundManager:PlaySound(id, loop, independent)
  if id == nil or id == 0 then
    return 0
  end
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return 0
  end
  if self.useAudioMixer then
    local param = self:GetPlayAudioParamsFromTemplate(id)
    return self:PlayAudio(param)
  else
    if meta.sound_type ~= LWSoundType.Normal then
      return self:PlaySoundWithType(meta, 0, loop, nil, independent)
    end
    local assetName
    if meta.usePath2 then
      assetName = meta.soundPath2:GetRandom()
    else
      local name = meta.sound:GetRandom()
      assetName = string.format(LoadPath.SoundEffect, name)
    end
    if not assetName then
      Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\228\184\186\231\169\186", id))
      return 0
    end
    if loop then
      if self.isEffectOn then
        local param = CS.SoundComponent.PlaySoundParams()
        param.Loop = true
        local soundGroupName = independent and assetName or "LoopEffect"
        self.effectExtraGroup[soundGroupName] = true
        return CS.GameEntry.Sound:PlaySound(assetName, soundGroupName, param, nil)
      end
    else
      return CS.GameEntry.Sound:PlayEffectFullPath(assetName)
    end
  end
end

function LWSoundManager:PlaySoundWithStartTime(id, startTime, loop, fadeTime)
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return 0
  end
  if self.useAudioMixer then
    local param = self:GetPlayAudioParamsFromTemplate(id)
    param.startTime = startTime
    return self:PlayAudio(param)
  elseif meta.sound_type ~= LWSoundType.Normal then
    return self:PlaySoundWithType(meta, startTime, loop, fadeTime)
  end
  return 0
end

function LWSoundManager:StopAMBSound()
  CS.GameEntry.Sound:StopAMBSound()
end

function LWSoundManager:StopPlayLoopSoundWithLimit(limitType, timer)
  if timer and timer.timerId then
    local timerId = timer.timerId
    if self.loopTimerList[limitType] and self.loopTimerIdList[timerId] then
      table.removebyvalue(self.loopTimerList[limitType], timerId)
    end
    local timer = self.loopTimerIdList[timerId]
    self.loopTimerIdList[timerId] = nil
    timer:Stop()
  end
end

function LWSoundManager:PlaySoundWithLimit(id, limitType)
  if self.useAudioMixer then
    return self:PlaySound(id)
  else
    for i = 1, self.limit[limitType] do
      if self.busy[limitType][i] == nil then
        self.busy[limitType][i] = 0.5
        return self:PlayEffect(id)
      end
    end
  end
end

function LWSoundManager:PlayEffect(id)
  if self.useAudioMixer then
    return self:PlaySound(id)
  elseif self.isEffectOn then
    local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
    if not meta then
      return 0
    end
    local assetName
    if meta.usePath2 then
      assetName = meta.soundPath2:GetRandom()
    else
      local name = meta.sound:GetRandom()
      assetName = string.format(LoadPath.SoundEffect, name)
    end
    if not assetName then
      Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\228\184\186\231\169\186", id))
      return 0
    end
    self.effectExtraGroup.Effect = true
    return CS.GameEntry.Sound:PlayEffectFullPath(assetName)
  end
end

function LWSoundManager:PlaySoundByCache(id)
  if self.useAudioMixer then
    return self:PlaySound(id)
  end
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return 0
  end
  if meta.sound_type ~= LWSoundType.Eff then
    return self:PlaySound(id, false)
  end
  local max = meta.sound_num
  local soundTime = meta.sound_time
  local limitData
  if 0 < max and 0 < soundTime then
    soundTime = soundTime / 1000
    if self.busyById == nil then
      self.busyById = {}
    end
    limitData = self.busyById[id]
    if limitData == nil then
      limitData = {}
      self.busyById[id] = limitData
    elseif max <= table.count(limitData) then
      return 0
    end
  end
  local assetName
  if meta.usePath2 then
    assetName = meta.soundPath2:GetRandom()
  else
    local name = meta.sound:GetRandom()
    assetName = string.format(LoadPath.SoundEffect, name)
  end
  if not assetName then
    Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\228\184\186\231\169\186", id))
    return 0
  end
  local soundId = CS.GameEntry.Sound:PlayEffectCache(assetName, meta.sound_volume, meta.sound_set)
  if limitData then
    limitData[soundId] = soundTime
    self.busySoundIdToMetaId[soundId] = id
  end
  return soundId
end

function LWSoundManager:ReleaseEffectCache(id)
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return false
  end
  if meta.sound_type ~= LWSoundType.Eff then
    return false
  end
  local assetName
  if meta.usePath2 then
    assetName = meta.soundPath2:GetRandom()
  else
    assetName = meta.sound:GetRandom()
    assetName = string.format(LoadPath.SoundEffect, assetName)
  end
  if not assetName then
    Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\228\184\186\231\169\186", id))
    return false
  end
  return CS.GameEntry.Sound:ReleaseEffect(assetName)
end

function LWSoundManager:PlayLoopSoundWithLimit(id, limitType, soundLength)
  local timerIdList = {}
  if self.loopTimerList[limitType] then
    timerIdList = self.loopTimerList[limitType]
  else
    self.loopTimerList[limitType] = timerIdList
  end
  if table.count(timerIdList) < self.limit[limitType] then
    local soundTimer = LWSoundTimer.New(id, soundLength)
    table.insert(timerIdList, soundTimer.timerId)
    self.loopTimerIdList[soundTimer.timerId] = soundTimer
    return soundTimer
  end
end

function LWSoundManager:PlaySoundWithLimitById(id)
  if self.busyById == nil then
    self.busyById = {}
  end
  if self.busyById[id] == nil then
    self.busyById[id] = {}
  end
  local template = self.limitById[id]
  if template and #self.busyById[id] < template.num then
    table.insert(self.busyById[id], template.time)
    if CommonUtil.IsDebug() then
      Logger.Log("PlaySoundWithLimit:" .. id)
    end
    return self:PlayEffect(id)
  end
end

function LWSoundManager:CheckSoundOutput()
  self:StopCheckSoundOutput()
  local wrong = 0
  local totoal = 0
  self.delayCheckOutput = TimerManager:GetInstance():GetTimer(0.1, function()
    totoal = totoal + 1
    if 20 < totoal and CS.GameEntry.Sound:CheckSoundWrongOutput() then
      wrong = wrong + 1
    end
    if 10 <= wrong then
      self:StopCheckSoundOutput()
      Logger.LogError("[AudioMixer]Sound Shouldn't output")
    elseif 40 <= totoal then
      self:StopCheckSoundOutput()
    end
  end, self, false, false, false)
  self.delayCheckOutput:Start()
end

function LWSoundManager:StopCheckSoundOutput()
  if self.delayCheckOutput ~= nil then
    self.delayCheckOutput:Stop()
    self.delayCheckOutput = nil
  end
end

function LWSoundManager:SetSoundEffectOnOff(isOn)
  self.isEffectOn = isOn
  for name, _ in pairs(self.effectExtraGroup) do
    CS.GameEntry.Sound:SetSoundGroupMute(name, not isOn)
  end
  if not isOn then
    self:CheckSoundOutput()
  else
    self:StopCheckSoundOutput()
  end
end

function LWSoundManager:GetLangName()
  local lang = self:GetVoiceLang()
  local langName
  if lang == 20 then
    langName = "de2"
  elseif lang == 3 then
    langName = "ar2"
  else
    langName = Localization:GetLanguageNameByInt(lang)
  end
  return langName
end

function LWSoundManager:GetLangNameByLangId(langId)
  local lang = langId or self:GetVoiceLang()
  local langName
  if lang == 20 then
    langName = "de2"
  elseif lang == 3 then
    langName = "ar2"
  else
    langName = Localization:GetLanguageNameByInt(lang)
  end
  return langName
end

function LWSoundManager:PlayHeroSound(name)
  local langName = self:GetLangName()
  local assetPath = string.format(LoadPath.SoundHero, langName, name)
  if not CS.GameEntry.Resource:HasAsset(assetPath) then
    return nil
  end
  if self.useAudioMixer then
    local param = CS.SoundComponent.PlayAudioParams()
    param.path = assetPath
    param.limit = 1
    param.instanceGroupId = 21
    param.instanceGroupLimit = 1
    return self:PlayAudio(param)
  else
    local param = CS.SoundComponent.PlaySoundParams()
    param.Loop = false
    return CS.GameEntry.Sound:PlaySound(assetPath, SoundGround.Hero, param, nil)
  end
end

function LWSoundManager:PlayDub(name)
  local langName = self:GetLangName()
  local assetPath = string.format(LoadPath.SoundDub, langName, name)
  DataCenter.EventCollectManager.OnDubCheckAssetDownloaded()
  if not CS.GameEntry.Resource:HasAsset(assetPath) then
    return nil
  end
  local canPlayDub = DataCenter.LWArmedUpgradeManager:IsCanPlayDubByLanguageName(langName)
  if not canPlayDub then
    return nil
  end
  if self.useAudioMixer then
    local param = CS.SoundComponent.PlayAudioParams()
    param.path = assetPath
    param.limit = 1
    param.instanceGroupId = 21
    param.instanceGroupLimit = 1
    return self:PlayAudio(param)
  else
    local param = CS.SoundComponent.PlaySoundParams()
    param.Loop = false
    return CS.GameEntry.Sound:PlaySound(assetPath, SoundGround.Dub, param, nil)
  end
end

function LWSoundManager:GetVoiceLang()
  if not self.voiceLang then
    self.voiceLang = Setting:GetInt("SETTING_VOICE", -1)
    if self.voiceLang == -1 then
      self.voiceLang = Localization:GetLanguage()
    end
    local allSupportedLangs = self:GetSupportedVoiceLangs()
    local isSupported
    for _, v in ipairs(allSupportedLangs) do
      if self.voiceLang == v then
        isSupported = true
        break
      end
    end
    if not isSupported then
      self.voiceLang = Language.English
    end
  end
  return self.voiceLang
end

function LWSoundManager:SetVoiceLang(langInt)
  self.voiceLang = langInt
  Setting:SetInt("SETTING_VOICE", langInt)
  DataCenter.LWSoundManager:CheckLangResourceAutoDownload()
end

function LWSoundManager:GetSupportedVoiceLangs()
  if not self.supportedVoiceLangs then
    self.supportedVoiceLangs = {}
    local cfg = LuaEntry.DataConfig:TryGetStr("voice_selection", "k1", "14;27;28")
    cfg = string.split(cfg, ";")
    for i, v in ipairs(cfg) do
      self.supportedVoiceLangs[i] = tonumber(v)
    end
  end
  return self.supportedVoiceLangs
end

function LWSoundManager:PauseSound(serialId)
  CS.GameEntry.Sound:PauseSound(serialId)
end

function LWSoundManager:ResumeSound(serialId)
  CS.GameEntry.Sound:ResumeSound(serialId)
end

function LWSoundManager:PlaySoundWithType(meta, startTime, loop, fadeTime, independent)
  local soundType = meta.sound_type
  local assetName
  if meta.usePath2 then
    assetName = meta.soundPath2:GetRandom()
  else
    assetName = meta.sound:GetRandom()
  end
  if string.IsNullOrEmpty(assetName) then
    return 0
  end
  local isLoop = loop
  if isLoop == nil then
    isLoop = true
  end
  if soundType == LWSoundType.BGM then
    local isExistUISpecialBGm = DataCenter.LWUIBGMManager:IsExistUIBGMPlay()
    if isExistUISpecialBGm then
      return 0
    end
    local time = startTime or 0
    local fade = fadeTime or 0.5
    CS.GameEntry.Sound:PlayBGMusicByNameWithStartTime(assetName, time, isLoop, meta.sound_volume, meta.sound_set, fade, meta.speed, meta.usePath2, meta.reactive, meta.loop_gap, meta.pre_time)
    return self:GetBGMusic()
  elseif soundType == LWSoundType.Eff then
    local max = meta.sound_num
    local soundTime = meta.sound_time
    local id = meta.id
    local limitData
    if 0 < max and 0 < soundTime then
      soundTime = soundTime / 1000
      if self.busyById == nil then
        self.busyById = {}
      end
      limitData = self.busyById[id]
      if limitData == nil then
        limitData = {}
        self.busyById[id] = limitData
      elseif max > table.count(limitData) then
      else
        return 0
      end
    end
    local sound_change = meta.sound_change
    if isLoop and self.isEffectOn then
      local param = CS.SoundComponent.PlaySoundParams()
      param.Loop = true
      param.VolumeInSoundGroup = meta.sound_volume
      param.SoundVolumeSet = meta.sound_set
      if sound_change then
        param.FadeInSeconds = 0.5
        param.FadeOutSeconds = 0.5
      end
      local soundGroupName = independent and assetName or "LoopEffect"
      self.effectExtraGroup[soundGroupName] = true
      local path = meta.usePath2 and assetName or string.format(LoadPath.SoundEffect, assetName)
      local soundId = CS.GameEntry.Sound:PlaySound(path, soundGroupName, param, nil)
      if limitData then
        limitData[soundId] = soundTime
        self.busySoundIdToMetaId[soundId] = id
      end
      return soundId
    end
    if sound_change then
      if self.isEffectOn then
        local soundGroupName = independent and assetName or "EffectFade"
        local param = CS.SoundComponent.PlaySoundParams()
        param.FadeInSeconds = 0.5
        param.FadeOutSeconds = 0.5
        param.VolumeInSoundGroup = meta.sound_volume
        param.SoundVolumeSet = meta.sound_set
        self.effectExtraGroup[soundGroupName] = true
        local path = meta.usePath2 and assetName or string.format(LoadPath.SoundEffect, assetName)
        local soundId = CS.GameEntry.Sound:PlaySound(path, soundGroupName, param, nil)
        if limitData then
          limitData[soundId] = soundTime
          self.busySoundIdToMetaId[soundId] = id
        end
        return soundId
      else
        return 0
      end
    elseif self.isEffectOn then
      local path = meta.usePath2 and assetName or string.format(LoadPath.SoundEffect, assetName)
      local soundId = CS.GameEntry.Sound:PlayEffectFullPath(path, meta.sound_volume, meta.sound_set)
      if limitData then
        limitData[soundId] = soundTime
        self.busySoundIdToMetaId[soundId] = id
      end
      return soundId
    else
      return 0
    end
  elseif soundType == LWSoundType.AMB then
    return self:PlayAMBSound(meta.id)
  elseif soundType == LWSoundType.Env then
    if self.isEffectOn then
      if loop == false then
        Logger.LogError("PlaySoundWithType Env sound must be loop : " .. meta.id)
      elseif self.envSoundGroupIndexList then
        local soundGroupIndex
        for index, soundId in ipairs(self.envSoundGroupIndexList) do
          if soundId == 0 then
            soundGroupIndex = index
            break
          end
        end
        if soundGroupIndex == nil then
          soundGroupIndex = #self.envSoundGroupIndexList + 1
        end
        local param = CS.SoundComponent.PlaySoundParams()
        param.Loop = true
        param.VolumeInSoundGroup = meta.sound_volume
        param.SoundVolumeSet = meta.sound_set
        if meta.sound_change then
          param.FadeInSeconds = 0.5
          param.FadeOutSeconds = 0.5
        end
        local soundGroupName = "Env_" .. soundGroupIndex
        self.effectExtraGroup[soundGroupName] = true
        local path = meta.usePath2 and assetName or string.format(LoadPath.SoundEffect, assetName)
        local soundId = CS.GameEntry.Sound:PlaySound(path, soundGroupName, param, nil)
        self.envSoundGroupIndexList[soundGroupIndex] = soundId
        return soundId
      end
    end
  else
    Logger.LogError("PlaySoundWithType invalid type : " .. soundType)
  end
  return 0
end

function LWSoundManager:PlayTimeline(id)
  if self.useAudioMixer then
    return self:PlaySound(id)
  elseif self.isEffectOn then
    local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
    if not meta then
      return false
    end
    local assetName
    if meta.usePath2 then
      assetName = meta.soundPath2:GetRandom()
    else
      assetName = meta.sound:GetRandom()
      assetName = string.format("Assets/Main/Sound/Timeline/%s.ogg", assetName)
    end
    if not assetName then
      Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\228\184\186\231\169\186", id))
      return 0
    end
    self.effectExtraGroup.Timeline = true
    local param = CS.SoundComponent.PlaySoundParams()
    param.Loop = false
    return CS.GameEntry.Sound:PlaySound(assetName, "Timeline", param, nil)
  end
end

function LWSoundManager:PlayBubbleEffect(itemId)
  local id = DataCenter.ProductLineManager:GetCollectAudioName(itemId)
  if id == 0 then
    return
  end
  self:PlaySound(id, false)
end

function LWSoundManager:NewCommonSoundTest()
  return true
end

function LWSoundManager:PlayMusicById(id, loop)
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return 0
  end
  if self.useAudioMixer then
    local param = self:GetPlayAudioParamsFromTemplate(id)
    return self:PlayAudio(param)
  else
    local assetName
    if meta.usePath2 then
      assetName = meta.soundPath2:GetRandom()
    else
      assetName = meta.sound:GetRandom()
    end
    if not assetName then
      Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\229\146\140sound2\229\136\151\233\131\189\228\184\186\231\169\186", id))
      return 0
    end
    return CS.GameEntry.Sound:PlayMusic(assetName, not not loop, 0.5, 0, 1, -1, 1, meta.usePath2)
  end
end

function LWSoundManager:PlayBloodyNightTransitionBGM(startTime)
  local id = 70030
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return
  end
  if self.useAudioMixer then
    local param = self:GetPlayAudioParamsFromTemplate(id)
    local startTimeFloat = startTime / 1000
    param.startTime = startTimeFloat
    return self:PlayAudio(param)
  else
    local startTimeFloat = startTime / 1000
    self:PlaySoundWithType(meta, startTimeFloat, false)
  end
end

function LWSoundManager:PlayParkourBattleBGMusic()
  self:PlayMusicById(SoundAssetId.BGM_bgm_pve_30034, true)
end

function LWSoundManager:PlayPveSceneBGMusic()
  self:PlayMusicById(SoundAssetId.BGM_Bgm_Movie_Battle1, true)
end

function LWSoundManager:PlayPveSceneBGMusicLW()
  self:PlayMusicById(SoundAssetId.BGM_Bgm_Movie_Battle1, true)
end

function LWSoundManager:PlayWorldSceneBGMusic()
  return self:PlayMusicById(SoundAssetId.BGM_bgm_base_day, true)
end

function LWSoundManager:PlayCityDayBGMusic()
  return self:PlayMusicById(SoundAssetId.BGM_bgm_base_day_01, true)
end

function LWSoundManager:PlayGuideSceneBgMusic()
  return self:PlayMusicById(SoundAssetId.BGM_bgm_base_day_02, true)
end

function LWSoundManager:FadeOutAndPlayMusic(id, time)
  CS.GameEntry.Sound:FadeOutAndPlayMusic(id, time)
end

function LWSoundManager:PlayBGMusicByName(path, volume, soundVolumeSet)
  CS.GameEntry.Sound:PlayBGMusicByName(path, volume or 1, soundVolumeSet or -1)
end

function LWSoundManager:PlayBGMWithDspTime(id, loop, fadeIn, getMusicStartDspTimeFunc, musicLoadFinishFunc)
  local meta = DataCenter.LWSoundTemplateManager:GetTemplate(id)
  if not meta then
    return 0
  end
  if self.useAudioMixer then
    local param = self:GetPlayAudioParamsFromTemplate(id)
    param.onMusicLoadFinish = musicLoadFinishFunc
    param.getDspTimeFunc = getMusicStartDspTimeFunc
    return self:PlayAudio(param)
  else
    local assetName = meta.sound:GetRandom()
    if not assetName then
      assetName = meta.soundPath2:GetRandom()
      if not assetName then
        Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\229\146\140sound2\229\136\151\233\131\189\228\184\186\231\169\186", id))
        return
      end
    else
      assetName = meta.usePath2 and assetName or string.format("Assets/Main/Sound/Music/%s.ogg", assetName)
    end
    if not assetName then
      Logger.LogError(string.format("lw_sound\232\161\168%s\232\161\140sound\229\136\151\228\184\186\231\169\186", id))
      return 0
    end
    CS.GameEntry.Sound:PlayBGMWithDspTime(assetName, loop, fadeIn, getMusicStartDspTimeFunc, musicLoadFinishFunc)
  end
end

function LWSoundManager:StopBGMusic()
  CS.GameEntry.Sound:StopBGMusic()
end

function LWSoundManager:SetEffectMute(mute)
  local temps = DataCenter.LWSoundTemplateManager:GetGroupTemplates()
  if temps then
    for _, t in pairs(temps) do
      if t and t.menu_option == 1 then
        CS.GameEntry.Sound:SetSoundGroupMute(t.group, mute, true)
      end
    end
  else
    Logger.LogError("[AudioMixer]DataCenter.LWSoundTemplateManager:GetGroupTemplates Is Nil")
  end
  CS.GameEntry.Sound:SetSoundGroupMute(SoundGround.Effect, mute)
  CS.GameEntry.Sound:SetSoundGroupMute(SoundGround.Dub, mute)
  CS.GameEntry.Sound:SetSoundGroupMute(SoundGround.Hero, mute)
  if mute then
    self:CheckSoundOutput()
  else
    self:StopCheckSoundOutput()
  end
end

function LWSoundManager:SetMusicMute(mute)
  local temps = DataCenter.LWSoundTemplateManager:GetGroupTemplates()
  if temps then
    for _, t in pairs(temps) do
      if t and t.menu_option == 0 then
        CS.GameEntry.Sound:SetSoundGroupMute(t.group, mute, true)
      end
    end
  else
    Logger.LogError("[AudioMixer]DataCenter.LWSoundTemplateManager:GetGroupTemplates Is Nil")
  end
  CS.GameEntry.Sound:SetSoundGroupMute(SoundGround.Music, mute)
  if mute then
    self:CheckSoundOutput()
  else
    self:StopCheckSoundOutput()
  end
end

function LWSoundManager:SetEnvSoundMute(mute)
  local temps = DataCenter.LWSoundTemplateManager:GetGroupTemplates()
  if temps then
    for _, t in pairs(temps) do
      if t and t.menu_option == 2 then
        CS.GameEntry.Sound:SetSoundGroupMute(t.group, mute, true)
      end
    end
  else
    Logger.LogError("[AudioMixer]DataCenter.LWSoundTemplateManager:GetGroupTemplates Is Nil")
  end
  CS.GameEntry.Sound:SetSoundGroupMute(SoundGround.AMBSound, mute)
  if mute then
    self:CheckSoundOutput()
  else
    self:StopCheckSoundOutput()
  end
end

function LWSoundManager:IsSoundEffectGroup(name)
  local temp = DataCenter.LWSoundTemplateManager:GetGroupTempByName(name)
  if not temp then
    return false
  end
  return temp.menu_option == 1
end

function LWSoundManager:ChangeVolume(groupName, toValue, time, isAudioMixerGroup)
  CS.GameEntry.Sound:ChangeVolume(groupName, toValue, time, isAudioMixerGroup)
end

function LWSoundManager:IsEvnSoundEffectGroup(name)
  local temp = DataCenter.LWSoundTemplateManager:GetGroupTempByName(name)
  if temp == nil then
    Logger.LogWarning("[AudioMixer]IsSoundEffectGroup Temp Is Nil : " .. name)
    return false
  end
  if temp.menu_option == 2 then
    return true
  end
  return false
end

function LWSoundManager:StopVolumeRatioTransitionTimer()
  if self.volumeRatioTransitionTimer ~= nil then
    self.volumeRatioTransitionTimer:Stop()
    self.volumeRatioTransitionTimer = nil
  end
end

function LWSoundManager:StartVolumeRatioTransition(targetEffect, targetMusic, targetEnv, startEffect, startMusic, startEnv)
  self:StopVolumeRatioTransitionTimer()
  local beginEffect = startEffect
  local beginMusic = startMusic
  local beginEnv = startEnv
  local needEffect = math.abs(targetEffect - beginEffect) > 1.0E-4
  local needMusic = math.abs(targetMusic - beginMusic) > 1.0E-4
  local needEnv = math.abs(targetEnv - beginEnv) > 1.0E-4
  Logger.LogInfo(string.format("[AudioVolumeTransition] StartVolumeRatioTransition begin effect=%.3f music=%.3f env=%.3f target effect=%.3f music=%.3f env=%.3f need effect=%s music=%s env=%s", beginEffect, beginMusic, beginEnv, targetEffect, targetMusic, targetEnv, tostring(needEffect), tostring(needMusic), tostring(needEnv)))
  if not needEffect and not needMusic and not needEnv then
    Logger.LogInfo("[AudioVolumeTransition] StartVolumeRatioTransition skip, no volume changes required")
    return
  end
  local elapsed = 0
  self.volumeRatioTransitionTimer = TimerManager:GetInstance():GetTimer(VOLUME_RATIO_TRANSITION_INTERVAL, function()
    elapsed = elapsed + VOLUME_RATIO_TRANSITION_INTERVAL
    local progress = math.min(elapsed / VOLUME_RATIO_TRANSITION_DURATION, 1)
    if needEffect then
      local value = beginEffect + (targetEffect - beginEffect) * progress
      Logger.LogInfo(string.format("[AudioVolumeTransition] timer effect elapsed=%.2f progress=%.2f value=%.3f begin=%.3f target=%.3f", elapsed, progress, value, beginEffect, targetEffect))
      self:ChangeEffectVolumeRatio(value)
    end
    if needMusic then
      local value = beginMusic + (targetMusic - beginMusic) * progress
      Logger.LogInfo(string.format("[AudioVolumeTransition] timer music elapsed=%.2f progress=%.2f value=%.3f begin=%.3f target=%.3f", elapsed, progress, value, beginMusic, targetMusic))
      self:ChangeMusicVolumeRatio(value)
    end
    if needEnv then
      local value = beginEnv + (targetEnv - beginEnv) * progress
      Logger.LogInfo(string.format("[AudioVolumeTransition] timer env elapsed=%.2f progress=%.2f value=%.3f begin=%.3f target=%.3f", elapsed, progress, value, beginEnv, targetEnv))
      self:ChangeEvnSoundVolumeRatio(value)
    end
    if 1 <= progress then
      Logger.LogInfo(string.format("[AudioVolumeTransition] transition complete target effect=%.3f music=%.3f env=%.3f", targetEffect, targetMusic, targetEnv))
      self:StopVolumeRatioTransitionTimer()
    end
  end, self, false, false, false)
  self.volumeRatioTransitionTimer:Start()
end

function LWSoundManager:ChangeAllVolumeRatioToHalf()
  local effectSetting = Setting:GetFloat(SettingKeys.EFFECT_VOLUME, 1)
  local musicSetting = Setting:GetFloat(SettingKeys.MUSIC_VOLUME, 1)
  local envSetting = Setting:GetFloat(SettingKeys.ENV_SOUND_VOLUME, 1)
  Logger.LogInfo(string.format("[AudioVolumeTransition] ChangeAllVolumeRatioToHalf settings effect=%.3f music=%.3f env=%.3f", effectSetting, musicSetting, envSetting))
  local targetEffect = effectSetting > VOLUME_RATIO_TRANSITION_TARGET and VOLUME_RATIO_TRANSITION_TARGET or effectSetting
  local targetMusic = musicSetting > VOLUME_RATIO_TRANSITION_TARGET and VOLUME_RATIO_TRANSITION_TARGET or musicSetting
  local targetEnv = envSetting > VOLUME_RATIO_TRANSITION_TARGET and VOLUME_RATIO_TRANSITION_TARGET or envSetting
  Logger.LogInfo(string.format("[AudioVolumeTransition] ChangeAllVolumeRatioToHalf target effect=%.3f music=%.3f env=%.3f threshold=%.3f", targetEffect, targetMusic, targetEnv, VOLUME_RATIO_TRANSITION_TARGET))
  self.restore_effectSetting = targetEffect
  self.restore_musicSetting = targetMusic
  self.restore_envSetting = targetEnv
  Logger.LogInfo(string.format("[AudioVolumeTransition] ChangeAllVolumeRatioToHalf cache restore effect=%.3f music=%.3f env=%.3f", self.restore_effectSetting, self.restore_musicSetting, self.restore_envSetting))
  Logger.LogInfo(string.format("[AudioVolumeTransition] ChangeAllVolumeRatioToHalf transition start effect=%.3f music=%.3f env=%.3f -> target effect=%.3f music=%.3f env=%.3f", effectSetting, musicSetting, envSetting, targetEffect, targetMusic, targetEnv))
  self:StartVolumeRatioTransition(targetEffect, targetMusic, targetEnv, effectSetting, musicSetting, envSetting)
end

function LWSoundManager:RestoreAllVolumeRatioFromSetting()
  local effectSetting = Setting:GetFloat(SettingKeys.EFFECT_VOLUME, 1)
  local musicSetting = Setting:GetFloat(SettingKeys.MUSIC_VOLUME, 1)
  local envSetting = Setting:GetFloat(SettingKeys.ENV_SOUND_VOLUME, 1)
  Logger.LogInfo(string.format("[AudioVolumeTransition] RestoreAllVolumeRatioFromSetting settings effect=%.3f music=%.3f env=%.3f", effectSetting, musicSetting, envSetting))
  local currentEffect = self.restore_effectSetting or 0
  local currentMusic = self.restore_musicSetting or 0
  local currentEnv = self.restore_envSetting or 0
  Logger.LogInfo(string.format("[AudioVolumeTransition] RestoreAllVolumeRatioFromSetting current effect=%.3f music=%.3f env=%.3f", currentEffect, currentMusic, currentEnv))
  Logger.LogInfo(string.format("[AudioVolumeTransition] RestoreAllVolumeRatioFromSetting transition current effect=%.3f music=%.3f env=%.3f -> setting effect=%.3f music=%.3f env=%.3f", currentEffect, currentMusic, currentEnv, effectSetting, musicSetting, envSetting))
  self:StartVolumeRatioTransition(effectSetting, musicSetting, envSetting, currentEffect, currentMusic, currentEnv)
end

function LWSoundManager:ChangeEvnSoundVolumeRatio(val)
  CS.GameEntry.Sound:ChangeGlobalSettingVolumeRatio(SoundGround.AMBSound, val, false)
  local temps = DataCenter.LWSoundTemplateManager:GetGroupTemplates()
  if temps then
    for _, t in pairs(temps) do
      if t and t.menu_option == 2 then
        CS.GameEntry.Sound:ChangeGlobalSettingVolumeRatio(t.group, val, true)
      end
    end
  else
    Logger.LogError("[AudioMixer]DataCenter.LWSoundTemplateManager:GetGroupTemplates Is Nil")
  end
end

function LWSoundManager:ChangeEffectVolumeRatio(val)
  CS.GameEntry.Sound:ChangeGlobalSettingVolumeRatio(SoundGround.Effect, val, false)
  CS.GameEntry.Sound:ChangeGlobalSettingVolumeRatio(SoundGround.Dub, val, false)
  CS.GameEntry.Sound:ChangeGlobalSettingVolumeRatio(SoundGround.Hero, val, false)
  local temps = DataCenter.LWSoundTemplateManager:GetGroupTemplates()
  if temps then
    for _, t in pairs(temps) do
      if t and t.menu_option == 1 then
        CS.GameEntry.Sound:ChangeGlobalSettingVolumeRatio(t.group, val, true)
      end
    end
  else
    Logger.LogError("[AudioMixer]DataCenter.LWSoundTemplateManager:GetGroupTemplates Is Nil")
  end
end

function LWSoundManager:ChangeMusicVolumeRatio(val)
  CS.GameEntry.Sound:ChangeGlobalSettingVolumeRatio(SoundGround.Music, val, false)
  local temps = DataCenter.LWSoundTemplateManager:GetGroupTemplates()
  if temps then
    for _, t in pairs(temps) do
      if t and t.menu_option == 0 then
        CS.GameEntry.Sound:ChangeGlobalSettingVolumeRatio(t.group, val, true)
      end
    end
  else
    Logger.LogError("[AudioMixer]DataCenter.LWSoundTemplateManager:GetGroupTemplates Is Nil")
  end
end

function LWSoundManager:GetLangIndex(voiceLang)
  local langs = DataCenter.LWSoundManager:GetSupportedVoiceLangs()
  for i, v in ipairs(langs) do
    if v == voiceLang then
      return i
    end
  end
  return 0
end

function LWSoundManager:CheckLangResourceAutoDownload()
  if CS.SoundResourceDownloadManager then
    local voiceLang = DataCenter.LWSoundManager:GetVoiceLang()
    local langIndex = self:GetLangIndex(voiceLang)
    if 0 < langIndex then
      CS.SoundResourceDownloadManager.Instance:CheckLangResourceAutoDownload(langIndex - 1, self:GetLangName())
    end
  end
end

function LWSoundManager:DebugCheckAllLangDub()
  local logTab = {}
  LocalController:instance():visitTable(TableName.LW_Plot, function(id, lineData)
    local dub = lineData:getValue("dub")
    if not string.IsNullOrEmpty(dub) then
      for i, v in pairs(self:GetSupportedVoiceLangs()) do
        local langName = self:GetLangNameByLangId(v)
        local assetPath = string.format(LoadPath.SoundDub, langName, dub)
        if not CS.GameEntry.Resource:HasAsset(assetPath) then
          if logTab[langName] == nil then
            logTab[langName] = {}
          end
          table.insert(logTab[langName], assetPath)
        end
      end
    end
  end)
  local path = CS.UnityEngine.Application.dataPath .. "/../../SoundLogs/sound_dump.txt"
  local file = io.open(path, "w")
  if file then
    file:write(table.dump(logTab))
    file:close()
    Logger.LogError("sound check exported to: " .. path)
  end
end

function LWSoundManager:CheckAndSetDefaultLoadingBGM()
  local line = LocalController:instance():getLine(TableName.World_Skin, 1)
  if line then
    local soundId = line.loading_bgm
    local template = DataCenter.LWSoundTemplateManager:GetTemplate(soundId)
    if template then
      local assetName
      if template.usePath2 then
        assetName = template.soundPath2:GetRandom()
      else
        assetName = string.format("Assets/Main/Sound/Music/%s.ogg", template.sound:GetRandom())
      end
      if not string.IsNullOrEmpty(assetName) then
        Setting:SetString(SettingKeys.LOADING_DEFAULT_BGM, assetName)
      end
    end
  end
end

return LWSoundManager
