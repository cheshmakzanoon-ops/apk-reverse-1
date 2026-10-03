local ResGroupManager = CS.DownloadResGroupCommonManager.Instance
local LWDubResourceDownloadManager = BaseClass("LWDubResourceDownloadManager", CEventable)
local RemoteLogPlot = {"Remote1", "Remote2"}

function LWDubResourceDownloadManager:__init()
  self.downloadGroupDict = {}
  self.downloadTimeDict = {}
  self.remoteNeedPostDict = {}
  self:RegisterEvent(EventId.CommonResourceGroupDownloadFinish, self.DownloadFinish)
end

function LWDubResourceDownloadManager:__delete()
  self.downloadGroupDict = nil
  self.downloadTimeDict = nil
  self.remoteNeedPostDict = nil
end

function LWDubResourceDownloadManager:OnEnterGame()
  self.remoteNeedPostDict = {}
  self:CheckResourceAutoDownload()
end

function LWDubResourceDownloadManager:GetDunDownloadConfigIdList(voiceLang)
  if self.lang2CfgList == nil then
    self.lang2CfgList = {}
    local str = LuaEntry.DataConfig:TryGetStr("voice_selection", "k2")
    if not string.IsNullOrEmpty(str) then
      local split1 = string.split(str, "|")
      local langs = DataCenter.LWSoundManager:GetSupportedVoiceLangs()
      for i1, v1 in ipairs(split1) do
        local split2 = string.split(v1, ";")
        local langId = langs[i1]
        if langId then
          self.lang2CfgList[langId] = {}
          for i2, v2 in ipairs(split2) do
            table.insert(self.lang2CfgList[langId], tonumber(v2))
          end
        end
      end
    end
  end
  local configIdList
  if self.lang2CfgList then
    configIdList = self.lang2CfgList[voiceLang]
  end
  return configIdList
end

function LWDubResourceDownloadManager:CheckResourceAutoDownload()
  local voiceLang = DataCenter.LWSoundManager:GetVoiceLang()
  local configIdList = self:GetDunDownloadConfigIdList(voiceLang)
  if configIdList == nil then
    Logger.LogError("[LWDubResourceDownloadManager] not cfg " .. tostring(voiceLang))
    return
  end
  for id, v in pairs(self.downloadGroupDict) do
    if not table.hasvalue(configIdList, id) then
      Logger.LogInfo("[LWDubResourceDownloadManager] DownloadStop " .. id)
      ResGroupManager:StopDownload(id)
    end
  end
  for i, v in ipairs(configIdList) do
    if 0 < v and not ResGroupManager:IsDownload(v) then
      self.downloadGroupDict[v] = ResGroupManager:StartDownload(v)
      self.downloadTimeDict[v] = Time.realtimeSinceStartup
      if RemoteLogPlot[i] then
        self.remoteNeedPostDict[RemoteLogPlot[i]] = true
      end
      Logger.LogInfo("[LWDubResourceDownloadManager] DownloadStart " .. v)
    else
      Logger.LogInfo("[LWDubResourceDownloadManager] IsDownloaded " .. v)
    end
  end
end

function LWDubResourceDownloadManager:DownloadFinish(configId)
  if self.downloadGroupDict[configId] then
    self.downloadGroupDict[configId] = nil
    local diff = 0
    if self.downloadTimeDict[configId] then
      diff = tonumber(string.formatDecimal(Time.realtimeSinceStartup - self.downloadTimeDict[configId], 2))
    end
    Logger.LogInfo(string.format("[LWDubResourceDownloadManager] DownloadFinish %s Time:%s", configId, diff))
    self.downloadTimeDict[configId] = nil
  end
end

function LWDubResourceDownloadManager:PostRemoteFirstLog(name, isSuccess)
  for i, v in ipairs(RemoteLogPlot) do
    if self.remoteNeedPostDict[v] and string.find(name, v) == 1 then
      self.remoteNeedPostDict[v] = false
      PostEventLog.Track(PostEventLog.Defines.c_sound_dub_remote_success, {
        s_user_lang = DataCenter.LWSoundManager:GetLangName(),
        event_type = v,
        eventname = name,
        count = isSuccess and 1 or 0
      })
    end
  end
end

return LWDubResourceDownloadManager
