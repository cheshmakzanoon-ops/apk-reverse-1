local PlayerDownloadCenterManager = BaseClass("PlayerDownloadCenterManager")
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")
local DownloadCenterTemplate = require("DataCenter.PlayerDownloadCenter.Template.DownloadCenterTemplate")
local DownloadPacksTemplate = require("DataCenter/PlayerDownloadCenter/Template/DownloadPacksTemplate")
local Localization = CS.GameEntry.Localization
local Device = CS.GameEntry.Device
local NetworkReachability = CS.UnityEngine.NetworkReachability
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance

function PlayerDownloadCenterManager:__init()
  self.autoDownloadSettingState = false
  self.normalPackageStr = ""
  self.canDelPackageStr = ""
  self.downloadTabCfgList = {}
  self.downloadPackageCfgDic = {}
  self.downloadPackageTotalCfgDic = {}
  self.deletePackageIdList_auto = {}
  self.deletePackageIdList_manual = {}
  self.connectionState = -1
  self.downloadPackageStateDic = {}
  self.packageManualOperateDic = {}
  self.toggleDeletePackageDic = {}
  self.restartDownloadDelay = 5
  self.restartDownloadTimerDic = {}
  self.isResourceDownloaded = false
  self.waitStartDownloadPackageCfgIdList = {}
  self.maxStartDownloadCountEachFrame = 1
  self.hasUpdate = false
  self.maxManualDeleteTimes = 3
  self.isLoadComplete = false
  self.isDeleingThreadComplete = false
  self:AddListeners()
end

function PlayerDownloadCenterManager:__delete()
  self.autoDownloadSettingState = false
  self.normalPackageStr = ""
  self.canDelPackageStr = ""
  self.downloadTabCfgList = nil
  self.downloadPackageCfgDic = nil
  self.downloadPackageTotalCfgDic = nil
  self.deletePackageIdList_auto = nil
  self.deletePackageIdList_manual = nil
  self.connectionState = -1
  self.downloadPackageStateDic = nil
  self.packageManualOperateDic = nil
  self.toggleDeletePackageDic = nil
  self.isLoadComplete = false
  self.isDeleingThreadComplete = false
  self.isResourceDownloaded = false
  if self.restartDownloadTimerDic then
    for k, v in pairs(self.restartDownloadTimerDic) do
      self.restartDownloadTimerDic[k]:Stop()
      self.restartDownloadTimerDic[k] = nil
    end
    self.restartDownloadTimerDic = {}
  end
  self.waitStartDownloadPackageCfgIdList = {}
  self.hasUpdate = false
  self:RemoveListeners()
  UpdateManager:GetInstance():RemoveSecondUpdate(self.SecondOnUpdate)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
end

function PlayerDownloadCenterManager:AddListeners()
  EventManager:GetInstance():AddListenerWithSelf(EventId.LOAD_COMPLETE, self.OnLoadComplete, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.EnterGameDeleingThreadComplete, self.OnDeleingThreadComplete, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.ChangeAutoDownloadSettingState, self.CheckResourceAutoDownload, self)
end

function PlayerDownloadCenterManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener2(EventId.LOAD_COMPLETE, self.OnLoadComplete, self)
  EventManager:GetInstance():RemoveListener2(EventId.EnterGameDeleingThreadComplete, self.OnDeleingThreadComplete, self)
  EventManager:GetInstance():RemoveListener2(EventId.ChangeAutoDownloadSettingState, self.CheckResourceAutoDownload, self)
end

function PlayerDownloadCenterManager:PlayerDownloadCenterLogError(content)
end

function PlayerDownloadCenterManager:InitData(t)
  if t == nil then
    return
  end
  self.normalPackageStr = t.normalPackageStr or ""
  self.canDelPackageStr = t.canDelPackageStr or ""
end

function PlayerDownloadCenterManager:GetNormalPackageStrFromServer()
  return self.normalPackageStr
end

function PlayerDownloadCenterManager:GetCanDelPackageStrFromServer()
  return self.canDelPackageStr
end

function PlayerDownloadCenterManager:SetIsResourceDownloaded(state)
  self.isResourceDownloaded = state
end

function PlayerDownloadCenterManager.SecondOnUpdate()
  local self = DataCenter.PlayerDownloadCenterManager
  local networkType = self:GetNetworkType()
  if self.connectionState ~= networkType then
    self.connectionState = networkType
    self:CheckResourceAutoDownload()
  end
end

function PlayerDownloadCenterManager.OnUpdate()
  local self = DataCenter.PlayerDownloadCenterManager
  if table.IsNullOrEmpty(self.waitStartDownloadPackageCfgIdList) then
    self.hasUpdate = false
    UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
    return
  end
  local startOrigin = math.max(1, #self.waitStartDownloadPackageCfgIdList - self.maxStartDownloadCountEachFrame + 1)
  for i = #self.waitStartDownloadPackageCfgIdList, startOrigin, -1 do
    local packageCfgId = self.waitStartDownloadPackageCfgIdList[i]
    self:_TryStartDownloadPackage(packageCfgId)
    table.remove(self.waitStartDownloadPackageCfgIdList, i)
  end
end

function PlayerDownloadCenterManager:AddWaitStartDownloadPackageCfgIdList(packageCfgId)
  table.insert(self.waitStartDownloadPackageCfgIdList, 1, packageCfgId)
end

function PlayerDownloadCenterManager:IsInWaitStartDownloadPackageCfgIdList(packageCfgId)
  self.waitStartDownloadPackageCfgIdList = self.waitStartDownloadPackageCfgIdList or {}
  for i = 1, #self.waitStartDownloadPackageCfgIdList do
    if self.waitStartDownloadPackageCfgIdList[i] == packageCfgId then
      return true
    end
  end
  return false
end

function PlayerDownloadCenterManager:RemoveWaitStartDownloadPackageCfgIdList(packageCfgId)
  for i = 1, #self.waitStartDownloadPackageCfgIdList do
    if self.waitStartDownloadPackageCfgIdList[i] == packageCfgId then
      table.remove(self.waitStartDownloadPackageCfgIdList, i)
      return
    end
  end
end

function PlayerDownloadCenterManager:GetDownloadPackageCfgDic()
  return self.downloadPackageCfgDic
end

function PlayerDownloadCenterManager:GetDownloadPackageTotalCfgDic()
  return self.downloadPackageTotalCfgDic
end

function PlayerDownloadCenterManager:OnLoadComplete()
  self.isLoadComplete = true
  if self.isLoadComplete and self.isDeleingThreadComplete then
    self:EnterGameStartDeletingTask()
  end
end

function PlayerDownloadCenterManager:OnDeleingThreadComplete()
  self.isDeleingThreadComplete = true
  if self.isLoadComplete and self.isDeleingThreadComplete then
    self:EnterGameStartDeletingTask()
  end
end

function PlayerDownloadCenterManager:EnterGameStartDeletingTask()
  self:InitDownloadPacksTemplates()
  self:InitPrefData()
  self.isResourceDownloaded = true
  self:CheckResourceDelete()
end

function PlayerDownloadCenterManager:AfterDeleteTaskThenStartUpdate()
  if not self.isResourceDownloaded then
    return
  end
  UpdateManager:GetInstance():RemoveSecondUpdate(self.SecondOnUpdate)
  UpdateManager:GetInstance():AddSecondUpdate(self.SecondOnUpdate)
end

function PlayerDownloadCenterManager:IsDownloadCenterFunctionOn()
  local function_on_state = LuaEntry.DataConfig:CheckSwitch("download_center")
  local function_unlock_state = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_PlayerDownloadCenter)
  local firstLaunchSkipUpdate_state = CS.GameEntry.Setting:CheckFirstLaunchSkipUpdate()
  return function_on_state and function_unlock_state and not firstLaunchSkipUpdate_state
end

function PlayerDownloadCenterManager:InitPrefData()
  self.packageManualOperateDic = self.packageManualOperateDic or {}
  local packageCfgDic = self:GetDownloadPackageCfgDic()
  for tabCfgId, packageCfgList in pairs(packageCfgDic) do
    for i = 1, #packageCfgList do
      local packageCfgId = packageCfgList[i].id
      local manualOperateType = self:GetPackageManualOperateTypeFromPref(packageCfgId)
      self.packageManualOperateDic[packageCfgId] = manualOperateType
    end
  end
  self.autoDownloadSettingState = self:GetAutoDownloadSettingStateFromPref()
  self:RefreshShowTrulyDownloadProgressFlag()
end

function PlayerDownloadCenterManager:InitDownloadPacksTemplates()
  self.downloadPackageCfgDic = {}
  self.downloadPackageTotalCfgDic = {}
  local normalPackageIdList = string.split(self.normalPackageStr, "|")
  LocalController:instance():visitTable(TableName.Download_Packs, function(_, row)
    local downloadPacksTemplate = DownloadPacksTemplate.New()
    downloadPacksTemplate:UpdateData(row)
    local tabCfgId = downloadPacksTemplate.type
    self.downloadPackageTotalCfgDic[tabCfgId] = self.downloadPackageTotalCfgDic[tabCfgId] or {}
    table.insert(self.downloadPackageTotalCfgDic[tabCfgId], downloadPacksTemplate)
    for i = 1, #normalPackageIdList do
      if tonumber(normalPackageIdList[i]) == downloadPacksTemplate.pack_id then
        local tabCfgId = downloadPacksTemplate.type
        self.downloadPackageCfgDic[tabCfgId] = self.downloadPackageCfgDic[tabCfgId] or {}
        table.insert(self.downloadPackageCfgDic[tabCfgId], downloadPacksTemplate)
        return false
      end
    end
  end)
  for k, v in pairs(self.downloadPackageCfgDic) do
    table.sort(v, function(a, b)
      return a.order < b.order
    end)
  end
  for k, v in pairs(self.downloadPackageTotalCfgDic) do
    table.sort(v, function(a, b)
      return a.order < b.order
    end)
  end
end

function PlayerDownloadCenterManager:CheckResourceAutoDownload()
  if not self:IsDownloadCenterFunctionOn() then
    return
  end
  local networkType = self:GetNetworkType()
  local packageCfgDic = self:GetDownloadPackageCfgDic()
  for tabCfgId, packageCfgList in pairs(packageCfgDic) do
    for i = 1, #packageCfgList do
      local packageCfgId = packageCfgList[i].id
      local manualOperateType = self:GetPackageManualOperateType(packageCfgId)
      if manualOperateType == Const.ManualOperateType.Downloading then
        self:TryStartDownloadPackage(packageCfgId)
      elseif manualOperateType == Const.ManualOperateType.Paused then
        self:TryStopDownloadPackage(packageCfgId)
      else
        local autoDownloadSettingState = self:GetAutoDownloadSettingState()
        if autoDownloadSettingState and networkType == NetworkReachability.ReachableViaLocalAreaNetwork and CS.GameEntry.Network.IsConnected then
          self:TryStartDownloadPackage(packageCfgId)
        else
          self:TryStopDownloadPackage(packageCfgId)
        end
      end
    end
  end
end

function PlayerDownloadCenterManager:CheckResourceDelete()
  self.deletePackageIdList_auto = {}
  self.deletePackageIdList_manual = {}
  if self:GetAutoClearSettingState() and self:IsDownloadCenterFunctionOn() then
    local deletePackageIdListFromServer = string.split(self.canDelPackageStr, "|")
    for i = #deletePackageIdListFromServer, 1, -1 do
      if not string.IsNullOrEmpty(deletePackageIdListFromServer[i]) then
        table.insert(self.deletePackageIdList_auto, deletePackageIdListFromServer[i])
      end
    end
    self:FilterRequiredPackage(self.deletePackageIdList_auto)
  end
  local waitDeletePackageIds = CS.DownloadResGroupCommonManager.GetWaitDeletePackageIds()
  local waitDeletePackageIdList = {}
  if not string.IsNullOrEmpty(waitDeletePackageIds) then
    waitDeletePackageIdList = string.split(waitDeletePackageIds, "|")
  end
  for i = 1, #waitDeletePackageIdList do
    table.insert(self.deletePackageIdList_manual, waitDeletePackageIdList[i])
  end
  self:FilterRequiredPackage(self.deletePackageIdList_manual)
  local setManualDelete = {}
  for _, v in pairs(self.deletePackageIdList_manual) do
    setManualDelete[v] = true
  end
  for i = #self.deletePackageIdList_auto, 1, -1 do
    if setManualDelete[self.deletePackageIdList_auto[i]] then
      table.remove(self.deletePackageIdList_auto, i)
    end
  end
  local packageCfgIdList_manual = self:GetPackageCfgIdListByPackageIdList(self.deletePackageIdList_manual)
  for i = #self.deletePackageIdList_manual, 1, -1 do
    local deleteTimes = CS.DownloadResGroupCommonManager.GetPackageDeleteTimes(toInt(self.deletePackageIdList_manual[i]))
    if deleteTimes <= 0 then
      CS.DownloadResGroupCommonManager.RemoveWaitDeletePackageId(self.deletePackageIdList_manual[i])
      table.remove(packageCfgIdList_manual, i)
      table.remove(self.deletePackageIdList_manual, i)
    end
  end
  local packageCfgIdList_auto = self:GetPackageCfgIdListByPackageIdList(self.deletePackageIdList_auto)
  for i = #self.deletePackageIdList_auto, 1, -1 do
    if ResGroupManager:IsPackageDeleteTotallyCompleted(self.deletePackageIdList_auto, packageCfgIdList_auto[i]) then
      table.remove(packageCfgIdList_auto, i)
      table.remove(self.deletePackageIdList_auto, i)
    end
  end
  if table.IsNullOrEmpty(self.deletePackageIdList_auto) and table.IsNullOrEmpty(self.deletePackageIdList_manual) then
    self:AfterDeleteTaskThenStartUpdate()
  else
    self.deleteFinishedFlag = {}
    self:TryDeleteDownloadPackageList_PackageDeleteTimes(packageCfgIdList_manual)
    self:TryDeleteDownloadPackageList_AutoDelete(packageCfgIdList_auto)
  end
end

function PlayerDownloadCenterManager:FilterRequiredPackage(deletePackageIdList)
  if table.IsNullOrEmpty(deletePackageIdList) then
    return
  end
  local requiredPackages = CS.ResourcePackageManager.GetRequiredPackagesWithoutLog()
  if requiredPackages ~= nil and requiredPackages.Length > 0 then
    for i = 0, requiredPackages.Length - 1 do
      for j = #deletePackageIdList, 1, -1 do
        if requiredPackages[i] == toInt(deletePackageIdList[j]) then
          table.remove(deletePackageIdList, j)
          CS.DownloadResGroupCommonManager.RemoveWaitDeletePackageId(requiredPackages[i])
          CS.DownloadResGroupCommonManager.SetPackageDeleteTimes(requiredPackages[i], 0)
        end
      end
    end
  end
end

function PlayerDownloadCenterManager:GetPackageCfgIdListByPackageIdList(packageIdList)
  local packageCfgIdList = {}
  if table.IsNullOrEmpty(packageIdList) then
    return packageCfgIdList
  end
  for i = 1, #packageIdList do
    local isFind = false
    for k, v in pairs(self.downloadPackageTotalCfgDic) do
      local tabPackageDataList = v
      for j = 1, #tabPackageDataList do
        if packageIdList[i] == tostring(tabPackageDataList[j].pack_id) then
          isFind = true
          table.insert(packageCfgIdList, tabPackageDataList[j].id)
          break
        end
      end
      if isFind then
        break
      end
    end
  end
  return packageCfgIdList
end

function PlayerDownloadCenterManager:GetResGroupData(packageCfgId)
  local resGroupData = ResGroupManager:GetLoadManifestData(packageCfgId)
  if IsNull(resGroupData) then
    resGroupData = ResGroupManager:CreateDownloadData(packageCfgId)
  end
  return resGroupData
end

function PlayerDownloadCenterManager:TryStartDownloadPackage(packageCfgId)
  if self:IsInWaitStartDownloadPackageCfgIdList(packageCfgId) then
    return
  end
  self:AddWaitStartDownloadPackageCfgIdList(packageCfgId)
  if not self.hasUpdate then
    UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
    self.hasUpdate = true
  end
  PostEventLog.Track(PostEventLog.Defines.c_pack_download_start, {packageid = packageCfgId})
end

function PlayerDownloadCenterManager:_TryStartDownloadPackage(packageCfgId)
  local downloadPackageState = self:GetDownloadPackageState(packageCfgId)
  if downloadPackageState == Const.DownloadState.Deleting then
    return
  end
  self:SetShowTrulyDownloadProgress(packageCfgId, true)
  if ResGroupManager:IsDownload(packageCfgId) then
    self:SetDownloadPackageState(packageCfgId, Const.DownloadState.Completed)
  else
    self:SetDownloadPackageState(packageCfgId, Const.DownloadState.Downloading)
    local resGroupData = ResGroupManager:StartDownload(packageCfgId, false)
    resGroupData:ClearCompleted()
    resGroupData:completed("+", function(resGroupData)
      if resGroupData.isDownloadSuccess and ResGroupManager:IsDownload(resGroupData.configId) then
        self:SetDownloadPackageState(resGroupData.configId, Const.DownloadState.Completed)
        PostEventLog.Track(PostEventLog.Defines.c_pack_download_complete, {
          packageid = resGroupData.configId
        })
      else
        local restartDownloadTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:RemoveRestartDownloadTimer(resGroupData.configId)
          self:_TryStartDownloadPackage(resGroupData.configId)
        end, self.restartDownloadDelay)
        self:AddRestartDownloadTimer(resGroupData.configId, restartDownloadTimer)
      end
      EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadProgressListItem, {
        packageCfgId = resGroupData.configId
      })
    end)
  end
end

function PlayerDownloadCenterManager:TryStopDownloadPackage(packageCfgId)
  local downloadPackageState = self:GetDownloadPackageState(packageCfgId)
  if downloadPackageState == Const.DownloadState.Deleting then
    return
  end
  self:RemoveRestartDownloadTimer(packageCfgId)
  PostEventLog.Track(PostEventLog.Defines.c_pack_download_pause, {packageid = packageCfgId})
  if self:IsInWaitStartDownloadPackageCfgIdList(packageCfgId) then
    self:RemoveWaitStartDownloadPackageCfgIdList(packageCfgId)
    return
  end
  if ResGroupManager:IsDownload(packageCfgId) then
    local downloadPackageState = self:GetDownloadPackageState(packageCfgId)
    if downloadPackageState ~= Const.DownloadState.Completed then
      local isShowTrulyDownloadProgress = self:GetShowTrulyDownloadProgress(packageCfgId)
      if not isShowTrulyDownloadProgress then
        self:SetDownloadPackageState(packageCfgId, Const.DownloadState.Paused)
      else
        self:SetDownloadPackageState(packageCfgId, Const.DownloadState.Completed)
      end
    end
  else
    ResGroupManager:StopDownload(packageCfgId)
    self:SetDownloadPackageState(packageCfgId, Const.DownloadState.Paused)
  end
end

function PlayerDownloadCenterManager:TryDeleteDownloadPackageList_Manual(packageCfgIdList)
  local resGroupDataList = ResGroupManager:DeleteDownloadPackageList(packageCfgIdList)
  for i = 0, resGroupDataList.Length - 1 do
    local packageCfgId = resGroupDataList[i].configId
    self:RemoveRestartDownloadTimer(packageCfgId)
    if self:IsInWaitStartDownloadPackageCfgIdList(packageCfgId) then
      self:RemoveWaitStartDownloadPackageCfgIdList(packageCfgId)
    end
    CS.DownloadResGroupCommonManager.AddWaitDeletePackageId(resGroupDataList[i].packageId)
    CS.DownloadResGroupCommonManager.SetPackageDeleteTimes(resGroupDataList[i].packageId, self.maxManualDeleteTimes)
    resGroupDataList[i]:ClearDeletedCompleted()
    resGroupDataList[i]:deletedCompleted("+", function(resGroupData)
      self:SetDownloadPackageState(resGroupData.configId, Const.DownloadState.Paused)
      DataCenter.PlayerDownloadCenterManager:SetToggleDeletePackageDic(resGroupData.configId, false)
      self:SetShowTrulyDownloadProgress(resGroupData.configId, false)
      EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadProgressListItem, {
        packageCfgId = resGroupData.configId
      })
      EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadDeleteList)
      if resGroupData:IsDeleteTotallyCompleted() then
        CS.DownloadResGroupCommonManager.RemoveWaitDeletePackageId(resGroupData.packageId)
        CS.DownloadResGroupCommonManager.SetPackageDeleteTimes(resGroupData.packageId, 0)
        PostEventLog.Track(PostEventLog.Defines.c_pack_del, {
          packageid = resGroupData.packageId,
          type = "manual"
        })
      else
      end
    end)
    self:SetDownloadPackageState(resGroupDataList[i].configId, Const.DownloadState.Deleting)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadProgressListItem, {packageCfgId = -1})
  EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadDeleteList)
  self:ClearToggleDeletePackageDic()
  EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadCenterProgress)
  UIUtil.ClearAssetDownloaded()
end

function PlayerDownloadCenterManager:TryDeleteDownloadPackageList_PackageDeleteTimes(packageCfgIdList)
  if table.IsNullOrEmpty(packageCfgIdList) then
    return
  end
  local resGroupDataList = ResGroupManager:DeleteDownloadPackageList(packageCfgIdList)
  for i = 0, resGroupDataList.Length - 1 do
    resGroupDataList[i]:ClearDeletedCompleted()
    resGroupDataList[i]:deletedCompleted("+", function(resGroupData)
      if resGroupData:IsDeleteTotallyCompleted() then
        CS.DownloadResGroupCommonManager.RemoveWaitDeletePackageId(resGroupData.packageId)
        CS.DownloadResGroupCommonManager.SetPackageDeleteTimes(resGroupData.packageId, 0)
        PostEventLog.Track(PostEventLog.Defines.c_pack_del, {
          packageid = resGroupData.packageId,
          type = "manual"
        })
      else
        local deleteTimes = CS.DownloadResGroupCommonManager.GetPackageDeleteTimes(resGroupData.packageId)
        local remainTimes = math.max(0, deleteTimes - 1)
        CS.DownloadResGroupCommonManager.SetPackageDeleteTimes(resGroupData.packageId, remainTimes)
        if remainTimes == 0 then
          CS.DownloadResGroupCommonManager.RemoveWaitDeletePackageId(resGroupData.packageId)
          PostEventLog.Track(PostEventLog.Defines.c_pack_del, {
            packageid = resGroupData.packageId,
            type = "manual"
          })
        end
      end
      self.deleteFinishedFlag[resGroupData.configId] = true
      local isAllFinished = true
      for k, v in pairs(self.deleteFinishedFlag) do
        isAllFinished = isAllFinished and v
        if not isAllFinished then
          break
        end
      end
      if isAllFinished then
        self:AfterDeleteTaskThenStartUpdate()
      end
    end)
    self.deleteFinishedFlag[resGroupDataList[i].configId] = false
  end
  UIUtil.ClearAssetDownloaded()
end

function PlayerDownloadCenterManager:TryDeleteDownloadPackageList_AutoDelete(packageCfgIdList)
  if table.IsNullOrEmpty(packageCfgIdList) then
    return
  end
  local resGroupDataList = ResGroupManager:DeleteDownloadPackageList(packageCfgIdList)
  for i = 0, resGroupDataList.Length - 1 do
    resGroupDataList[i]:ClearDeletedCompleted()
    resGroupDataList[i]:deletedCompleted("+", function(resGroupData)
      if resGroupData:IsDeleteTotallyCompleted() then
        PostEventLog.Track(PostEventLog.Defines.c_pack_del, {
          packageid = resGroupData.packageId,
          type = "auto"
        })
      else
      end
      self.deleteFinishedFlag[resGroupData.configId] = true
      local isAllFinished = true
      for k, v in pairs(self.deleteFinishedFlag) do
        isAllFinished = isAllFinished and v
        if not isAllFinished then
          break
        end
      end
      if isAllFinished then
        self:AfterDeleteTaskThenStartUpdate()
      end
    end)
    self.deleteFinishedFlag[resGroupDataList[i].configId] = false
  end
end

function PlayerDownloadCenterManager:GetPackageProcessMbStr(resGroupData)
  local curResGroupSize = self:GetShowDownloadProgress(resGroupData)
  local curDownloadValue = self:ByteToMegaByte(curResGroupSize)
  local totalSize = self:ByteToMegaByte(resGroupData.totalSize)
  return string.format("%s/%s", curDownloadValue, totalSize)
end

function PlayerDownloadCenterManager:ByteToMegaByte(byteData)
  if byteData then
    if byteData < 1048576.0 then
      return string.format("%.2f", byteData / 1024.0) .. "Kb"
    else
      return string.format("%.2f", byteData / 1048576.0) .. "Mb"
    end
  else
    return "???Mb"
  end
end

function PlayerDownloadCenterManager:GetDownloadTabCfgList()
  self.downloadTabCfgList = self.downloadTabCfgList or {}
  if #self.downloadTabCfgList > 0 then
    return self.downloadTabCfgList
  end
  LocalController:instance():visitTable(TableName.DOWNLOAD_CENTER, function(_, row)
    local downloadCenterTemplate = DownloadCenterTemplate.New()
    downloadCenterTemplate:UpdateData(row)
    table.insert(self.downloadTabCfgList, downloadCenterTemplate)
  end)
  table.sort(self.downloadTabCfgList, function(a, b)
    return a.position < b.position
  end)
  for i = #self.downloadTabCfgList, 1, -1 do
    if self.downloadTabCfgList[i].show == 0 then
      table.remove(self.downloadTabCfgList, i)
    end
  end
  return self.downloadTabCfgList
end

function PlayerDownloadCenterManager:GetDownloadPackageCfgListByTabId(tabCfgId)
  local packageCfgDic = self:GetDownloadPackageCfgDic()
  return packageCfgDic[tabCfgId] or {}
end

function PlayerDownloadCenterManager:GetDownloadPackageTotalCfgListByTabId(tabCfgId)
  local packageCfgDic = self:GetDownloadPackageTotalCfgDic()
  return packageCfgDic[tabCfgId] or {}
end

function PlayerDownloadCenterManager:GetAllTabProgressData()
  local downloadedSizeDic = {}
  local tabTotalSizeDic = {}
  local packageCfgDic = self:GetDownloadPackageCfgDic()
  for tabCfgId, packageCfgList in pairs(packageCfgDic) do
    downloadedSizeDic[tabCfgId] = 0
    tabTotalSizeDic[tabCfgId] = 0
    for i = 1, #packageCfgList do
      local packageCfgId = packageCfgList[i].id
      local resGroupData = self:GetResGroupData(packageCfgId)
      local curResGroupSize = self:GetShowDownloadProgress(resGroupData)
      downloadedSizeDic[tabCfgId] = downloadedSizeDic[tabCfgId] + curResGroupSize
      tabTotalSizeDic[tabCfgId] = tabTotalSizeDic[tabCfgId] + resGroupData.totalSize
    end
  end
  return downloadedSizeDic, tabTotalSizeDic
end

function PlayerDownloadCenterManager:GetAllTabDownloadedSumSize()
  local downloadedTabSumSize = 0
  local downloadedSizeDic, tabTotalSizeDic = self:GetAllTabProgressData()
  for k, v in pairs(downloadedSizeDic) do
    downloadedTabSumSize = downloadedTabSumSize + v
  end
  return self:ByteToMegaByte(downloadedTabSumSize)
end

function PlayerDownloadCenterManager:PauseAllTabPackageDownload(tabCfgId)
  local packageCfgList = self:GetDownloadPackageCfgListByTabId(tabCfgId)
  for i = 1, #packageCfgList do
    local packageCfg = packageCfgList[i]
    local downloadPackageState = self:GetDownloadPackageState(packageCfg.id)
    if downloadPackageState == Const.DownloadState.Downloading then
      self:SetPackageManualOperateType(packageCfg.id, Const.ManualOperateType.Paused)
      self:TryStopDownloadPackage(packageCfg.id)
    end
  end
end

function PlayerDownloadCenterManager:StartAllTabPackageDownload(tabCfgId)
  local packageCfgList = self:GetDownloadPackageCfgListByTabId(tabCfgId)
  for i = 1, #packageCfgList do
    local packageCfg = packageCfgList[i]
    local downloadPackageState = self:GetDownloadPackageState(packageCfg.id)
    if downloadPackageState == Const.DownloadState.Paused then
      self:SetPackageManualOperateType(packageCfg.id, Const.ManualOperateType.Downloading)
      self:TryStartDownloadPackage(packageCfg.id)
    end
  end
end

function PlayerDownloadCenterManager:GetTabDownloadState(tabCfgId)
  local tabDownloadState = Const.DownloadState.Paused
  local isAllComplete = true
  local isExistDownloading = false
  local packageCfgList = self:GetDownloadPackageCfgListByTabId(tabCfgId)
  for i = 1, #packageCfgList do
    local packageCfg = packageCfgList[i]
    local downloadPackageState = self:GetDownloadPackageState(packageCfg.id)
    isAllComplete = isAllComplete and downloadPackageState == Const.DownloadState.Completed
    isExistDownloading = isExistDownloading or downloadPackageState == Const.DownloadState.Downloading
  end
  if isAllComplete then
    tabDownloadState = Const.DownloadState.Completed
  elseif isExistDownloading then
    tabDownloadState = Const.DownloadState.Downloading
  else
    tabDownloadState = Const.DownloadState.Paused
  end
  return tabDownloadState
end

function PlayerDownloadCenterManager:GetNetworkType()
  return Device:GetNetworkType()
end

function PlayerDownloadCenterManager:GetDownloadPackageState(packageCfgId)
  return self.downloadPackageStateDic[packageCfgId]
end

function PlayerDownloadCenterManager:SetDownloadPackageState(packageCfgId, state)
  self.downloadPackageStateDic[packageCfgId] = state
end

function PlayerDownloadCenterManager:GetToggleDeletePackageDic()
  return self.toggleDeletePackageDic
end

function PlayerDownloadCenterManager:SetToggleDeletePackageDic(packageCfgId, isOn)
  self.toggleDeletePackageDic = self.toggleDeletePackageDic or {}
  self.toggleDeletePackageDic[packageCfgId] = isOn
end

function PlayerDownloadCenterManager:ClearToggleDeletePackageDic()
  self.toggleDeletePackageDic = {}
end

function PlayerDownloadCenterManager:GetPackageManualOperateType(packageCfgId)
  return self.packageManualOperateDic[packageCfgId]
end

function PlayerDownloadCenterManager:GetPackageManualOperateTypeFromPref(packageCfgId)
  return CommonUtil.PlayerPrefsGetInt(string.format("%s_%d", Const.SettingKey_PackageManualOperateType, packageCfgId), Const.ManualOperateType.NeverDownload)
end

function PlayerDownloadCenterManager:SetPackageManualOperateType(packageCfgId, state)
  self.packageManualOperateDic[packageCfgId] = state
  CommonUtil.PlayerPrefsSetInt(string.format("%s_%d", Const.SettingKey_PackageManualOperateType, packageCfgId), state)
end

function PlayerDownloadCenterManager:GetAutoDownloadSettingState()
  if CommonUtil.IsDebug() then
    return CommonUtil.GlobalPrefsGetBool(GMConst.PlayerDownloadCenter_Setting_AutoDownload, true)
  else
    return self.autoDownloadSettingState
  end
end

function PlayerDownloadCenterManager:GetAutoDownloadSettingStateFromPref()
  if CommonUtil.IsDebug() then
    return CommonUtil.GlobalPrefsGetBool(GMConst.PlayerDownloadCenter_Setting_AutoDownload, true)
  else
    return CommonUtil.PlayerPrefsGetBool(Const.SettingKey_AutoDownload, true)
  end
end

function PlayerDownloadCenterManager:SetAutoDownloadSettingState(state)
  self.autoDownloadSettingState = state
  if CommonUtil.IsDebug() then
    CommonUtil.GlobalPrefsSetBool(GMConst.PlayerDownloadCenter_Setting_AutoDownload, state)
  else
    CommonUtil.PlayerPrefsSetBool(Const.SettingKey_AutoDownload, state)
  end
end

function PlayerDownloadCenterManager:GetAutoClearSettingState()
  return CommonUtil.PlayerPrefsGetBool(Const.SettingKey_AutoClear, false)
end

function PlayerDownloadCenterManager:SetAutoClearSettingState(state)
  CommonUtil.PlayerPrefsSetBool(Const.SettingKey_AutoClear, state)
end

function PlayerDownloadCenterManager:GetShowDownloadProgress(resGroupData)
  local packageCfgId = resGroupData.configId
  local curShowResGroupSize = resGroupData.alreadyDownloadSize + resGroupData.downloadSize
  if curShowResGroupSize > resGroupData.totalSize then
    curShowResGroupSize = resGroupData.totalSize
  end
  local isShowTrulyDownloadProgress = self:GetShowTrulyDownloadProgress(packageCfgId)
  local downloadPackageState = self:GetDownloadPackageState(packageCfgId)
  if not isShowTrulyDownloadProgress and downloadPackageState ~= Const.DownloadState.Completed then
    curShowResGroupSize = 0
  end
  return curShowResGroupSize
end

function PlayerDownloadCenterManager:SetShowTrulyDownloadProgress(packageCfgId, state)
  CommonUtil.PlayerPrefsSetBool(string.format("%s_%d", Const.PlayerDownloadCenter_ShowTrulyDownloadProgress, packageCfgId), state)
end

function PlayerDownloadCenterManager:GetShowTrulyDownloadProgress(packageCfgId)
  return CommonUtil.PlayerPrefsGetBool(string.format("%s_%d", Const.PlayerDownloadCenter_ShowTrulyDownloadProgress, packageCfgId), false)
end

function PlayerDownloadCenterManager:RefreshShowTrulyDownloadProgressFlag()
  local hasClearedAllBundleCache = CS.DownloadResGroupCommonManager.GetClearedAllBundleCacheFlag()
  if hasClearedAllBundleCache then
    local packageTotalCfgDic = self:GetDownloadPackageTotalCfgDic()
    for tabCfgId, packageCfgList in pairs(packageTotalCfgDic) do
      for i = 1, #packageCfgList do
        local packageCfgId = packageCfgList[i].id
        self:SetShowTrulyDownloadProgress(packageCfgId, false)
      end
    end
    CS.DownloadResGroupCommonManager.ResetClearedAllBundleCacheFlag()
  end
end

function PlayerDownloadCenterManager:AddRestartDownloadTimer(packageCfgId, timer)
  self.restartDownloadTimerDic = self.restartDownloadTimerDic or {}
  self.restartDownloadTimerDic[packageCfgId] = timer
end

function PlayerDownloadCenterManager:RemoveRestartDownloadTimer(packageCfgId)
  if self.restartDownloadTimerDic and self.restartDownloadTimerDic[packageCfgId] then
    self.restartDownloadTimerDic[packageCfgId]:Stop()
    self.restartDownloadTimerDic[packageCfgId] = nil
  end
end

return PlayerDownloadCenterManager
