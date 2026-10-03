local SeasonResourceDownloadManager = BaseClass("SeasonResourceDownloadManager")

function SeasonResourceDownloadManager:__init()
  self.seasonResourceServerData = {}
  self.curSeasonDownloadConfigId = nil
  self:AddListeners()
end

function SeasonResourceDownloadManager:__delete()
  self.curDownloadConfigId = nil
  self.curSeasonDownloadConfigId = nil
  self:RemoveListeners()
end

function SeasonResourceDownloadManager:AddListeners()
  EventManager:GetInstance():AddListenerWithSelf(EventId.LOAD_COMPLETE, self.OnLoadComplete, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.LWSeasonResourceDownloadFinish, self.DownloadFinish, self)
end

function SeasonResourceDownloadManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener2(EventId.LOAD_COMPLETE, self.OnLoadComplete, self)
  EventManager:GetInstance():RemoveListener2(EventId.LWSeasonResourceDownloadFinish, self.DownloadFinish, self)
end

function SeasonResourceDownloadManager:DownloadFinish(configId)
  local theConfigId, needInPreviewMode = SeasonUtil.GetSeasonResourcePackName(true)
  if configId ~= nil and configId ~= theConfigId then
    SeasonUtil.IsSeasonResDownloaded(configId, true)
  elseif theConfigId then
    SeasonUtil.IsSeasonResDownloaded(theConfigId, true)
  end
end

function SeasonResourceDownloadManager:PlayerSettingInit()
  local msg = LuaEntry.Player:GetUserSetting(UserSettingKey.SeasonResourceSetting)
  self:ParseMsg(msg)
end

function SeasonResourceDownloadManager:ParseMsg(msg)
  self.seasonResourceServerData = {}
  if not string.IsNullOrEmpty(msg) then
    local datas = string.split(msg, ";")
    for _, v in pairs(datas) do
      if v == nil or v == "" then
      elseif v == "Season_Mummy" or v == "4" then
        self.seasonResourceServerData["4"] = false
      else
        local packageId, paused = string.match(v, "([^,]+),?([^,]?)")
        if LuaEntry.Player:CheckUnpackResourceReward(packageId) then
          self.seasonResourceServerData[packageId] = false
        elseif packageId then
          self.seasonResourceServerData[packageId] = paused == "1"
        end
      end
    end
  end
end

function SeasonResourceDownloadManager:IsPaused(configId)
  if self.seasonResourceServerData then
    for thePackageId, paused in pairs(self.seasonResourceServerData) do
      if configId == toInt(thePackageId) then
        return paused
      end
    end
  end
  return false
end

function SeasonResourceDownloadManager:OnLoadComplete()
  self:CheckResourceAutoDownload()
end

function SeasonResourceDownloadManager:CheckResourceAutoDownload()
  if self.seasonResourceServerData and SeasonUtil.IsInSeasonPrepareMode() then
    local packageIdNow, needInPreviewMode = SeasonUtil.GetSeasonResourcePackName(false)
    if packageIdNow == nil or not needInPreviewMode then
      return
    end
    for thePackageId, paused in pairs(self.seasonResourceServerData) do
      local packageId = toInt(thePackageId)
      if packageIdNow == packageId and not paused and not SeasonUtil.IsSeasonResDownloaded(packageId) then
        CS.DownloadManifestManager.Instance:AddNewDownload(packageId, true)
      end
    end
  end
end

function SeasonResourceDownloadManager:GetNotRewardPackageId(full_down)
  if self.seasonResourceServerData then
    for thePackageId, paused in pairs(self.seasonResourceServerData) do
      local packageId = toInt(thePackageId)
      if paused or LuaEntry.Player:CheckUnpackResourceReward(packageId) then
      elseif full_down and SeasonUtil.IsSeasonResDownloaded(packageId) then
        return packageId
      else
        return packageId
      end
    end
  end
  return nil
end

function SeasonResourceDownloadManager:CheckServerSeasonData(packageName)
  return self.seasonResourceServerData and self.seasonResourceServerData[tostring(packageName)] ~= nil
end

function SeasonResourceDownloadManager:CanDownloadSeasonData(packageName)
  return self.seasonResourceServerData and self.seasonResourceServerData[tostring(packageName)] == false
end

function SeasonResourceDownloadManager:AddDataAndSync(packageName, _paused)
  local isDebugMode = CS.CommonUtils.IsDebug()
  if isDebugMode then
    Logger.LogInfo(string.format("SRD.AddDataAndSync, packageName = %s, paused = %s", packageName, _paused))
  end
  self.seasonResourceServerData[tostring(packageName)] = _paused
  local msg
  if self.seasonResourceServerData then
    for thePackageId, paused in pairs(self.seasonResourceServerData) do
      if msg == nil then
        msg = string.format("%s,%s", thePackageId, paused and "1" or "0")
      else
        msg = msg .. ";" .. string.format("%s,%s", thePackageId, paused and "1" or "0")
      end
    end
  end
  if isDebugMode then
    Logger.LogInfo("SRD.AddDataAndSync, msg = " .. msg)
  end
  SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.SeasonResourceSetting, msg)
end

return SeasonResourceDownloadManager
