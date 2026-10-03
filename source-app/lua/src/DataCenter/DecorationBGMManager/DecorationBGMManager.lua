local DecorationBGMManager = BaseClass("DecorationBGMManager")

function DecorationBGMManager:__init()
  self.curPlayingBuildId = 0
  self.curPlayingMusicEndTime = 0
  self.totalPlayingTime = 0
  self:AddListener()
end

function DecorationBGMManager:__delete()
  self.curPlayingBuildId = nil
  self.curPlayingMusicEndTime = nil
  self.totalPlayingTime = nil
  self:RemoveListener()
end

function DecorationBGMManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.CheckScene)
end

function DecorationBGMManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.CheckScene)
end

function DecorationBGMManager:GetSoundNameByBuildId(buildId)
  local soundId = self:GetSoundIdByBuildId(buildId)
  if soundId <= 0 then
    return ""
  end
  return DataCenter.LWSoundManager:GetSound(soundId)
end

function DecorationBGMManager:GetSoundIdByBuildId(buildId)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    return buildTemplate.play_music_para
  end
  return 0
end

function DecorationBGMManager:PlayDecorationBGM(buildId)
  local soundName = self:GetSoundNameByBuildId(checknumber(buildId))
  if not string.IsNullOrEmpty(soundName) then
    local fullPath = "Assets/Main/Sound/Music/" .. soundName .. ".ogg"
    DataCenter.LWSoundManager:GetAudioLength(fullPath, function(length)
      local curScene = CS.SceneManager.CurrSceneID
      if curScene == SceneManagerSceneID.City then
        length = checknumber(length)
        self.curPlayingBuildId = buildId
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        self.curPlayingMusicEndTime = curTime + length
        self.totalPlayingTime = length
        CommonUtil.PlayGameBgMusic()
        EventManager:GetInstance():Broadcast(EventId.DecorationPlaySoundStart, buildId)
        PostEventLog.Track(PostEventLog.Defines.DecorationBGMOpen, {
          buildId = tostring(buildId)
        })
      end
    end)
  end
end

function DecorationBGMManager:StopBGMByBuildId(buildId)
  if self.curPlayingBuildId == buildId then
    self.curPlayingBuildId = 0
    self.curPlayingMusicEndTime = 0
    self.totalPlayingTime = 0
    CommonUtil.PlayGameBgMusic()
    EventManager:GetInstance():Broadcast(EventId.DecorationPlaySoundStop, buildId)
  end
end

function DecorationBGMManager:GetMusicLeftTimeByBuildId(buildId)
  local leftTime = -1
  if self.curPlayingBuildId == buildId then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    leftTime = self.curPlayingMusicEndTime - curTime
  end
  return leftTime
end

function DecorationBGMManager:IsPlayingBGMByBuildId(buildId)
  return self.curPlayingBuildId == buildId
end

function DecorationBGMManager.CheckScene()
  local curScene = CS.SceneManager.CurrSceneID
  if curScene ~= SceneManagerSceneID.City then
    DataCenter.DecorationBGMManager.curPlayingBuildId = 0
    DataCenter.DecorationBGMManager.curPlayingMusicEndTime = 0
  end
end

function DecorationBGMManager:TryGetVal()
  self.CheckScene()
  return self.curPlayingBuildId, self.curPlayingMusicEndTime, self.totalPlayingTime
end

function DecorationBGMManager:StopBGM()
  if self.curPlayingBuildId and self.curPlayingBuildId > 0 then
    self:StopBGMByBuildId(self.curPlayingBuildId)
  end
end

function DecorationBGMManager:StopBGMData()
  if self.curPlayingBuildId and self.curPlayingBuildId > 0 then
    local buildId = self.curPlayingBuildId
    self.curPlayingBuildId = 0
    self.curPlayingMusicEndTime = 0
    self.totalPlayingTime = 0
    EventManager:GetInstance():Broadcast(EventId.DecorationPlaySoundStop, buildId)
  end
end

function DecorationBGMManager:GetBGMId()
  local soundId = 0
  if self.curPlayingBuildId and 0 < self.curPlayingBuildId then
    soundId = self:GetSoundIdByBuildId(self.curPlayingBuildId)
  end
  return soundId
end

return DecorationBGMManager
