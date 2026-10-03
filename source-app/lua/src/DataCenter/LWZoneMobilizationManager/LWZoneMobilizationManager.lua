local LWZoneMobilizationManager = BaseClass("LWZoneMobilizationManager", CEventable)
local LWZoneMobilizationDonatedInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationDonatedInfo")
local LWZoneMobilizationAttackInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationAttackInfo")
local LWZoneMobilizationDefendInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationDefendInfo")
local LWZoneMobilizationResourcePointsInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationResourcePointsInfo")
local LWZoneMobilizationSuppliesPointsInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationSuppliesPointsInfo")
local LWZoneMobilizationDailyTaskInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationDailyTaskInfo")
local LWZoneMobilizationRankInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationRankInfo")
local LWZoneMobilizationRankRewardPreviewInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationRankRewardPreviewInfo")

function LWZoneMobilizationManager:__init()
  self.isActivityOpen = nil
  self.stage = 0
  self.nextStageTime = 0
  self.serverId = 0
  self.pointId = 0
  self.bossId = 0
  self.oldBossId = 0
  self.beginTime = 0
  self.endTime = 0
  self.isBossPlace = false
  self.zoneMobilizationDonateInfo = nil
  self.zoneMobilizationAttackInfo = nil
  self.zoneMobilizationDefendInfo = nil
  self.zoneMobilizationDailyTaskDict = {}
  self.zoneMobilizationResourcePointsList = {}
  self.zoneMobilizationSuppliesPointsList = {}
  self.suppliesRewardTimes = 0
  self.playerSuppliesRewardTimes = 0
  self.dailyTaskRedPoint = false
  self.rankDict = {}
  self.rankRewardPreviewDict = {}
  self.localCacheBeginTime, self.localCacheStageId = self:SplitLocalCacheStagePlotData()
  self.limitLevel = nil
  self.redPointInfos = {}
  self.suppliesIconArr = nil
  self.resourceIconArr = nil
  self.jump = nil
  self.posRedPoint = nil
  self.newFuncTimestamp = nil
  self:AddListeners()
end

function LWZoneMobilizationManager:__delete()
  self:RemoveListeners()
  DataCenter.ZoneMobilizationCtrlManager:Delete()
  self:Clear()
end

local function AddListeners(self)
  self:RegisterEvent(EventId.ShowTaskSuccessReward, self.UpdateDailyTaskInfoAfterReceiveReward)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.ExitWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.EnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDay)
  EventManager:GetInstance():AddListener(EventId.MainTaskUpdate, self.GetCanReceivedTaskReward)
end

local function RemoveListeners(self)
  self:UnregisterEvent(EventId.ShowTaskSuccessReward)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.ExitWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.EnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
  EventManager:GetInstance():RemoveListener(EventId.MainTaskUpdate, self.GetCanReceivedTaskReward)
end

local function Clear(self)
  self.isActivityOpen = nil
  self.stage = nil
  self.nextStageTime = nil
  self.serverId = nil
  self.pointId = nil
  self.bossId = nil
  self.oldBossId = nil
  self.beginTime = nil
  self.endTime = nil
  self.isBossPlace = nil
  self.zoneMobilizationDonateInfo = nil
  self.zoneMobilizationAttackInfo = nil
  self.zoneMobilizationDefendInfo = nil
  self.zoneMobilizationDailyTaskDict = nil
  self.zoneMobilizationResourcePointsList = nil
  self.zoneMobilizationSuppliesPointsList = nil
  self.suppliesRewardTimes = nil
  self.dailyTaskRedPoint = nil
  self.rankDict = nil
  self.rankRewardPreviewDict = nil
  self.localCacheBeginTime = nil
  self.localCacheStageId = nil
  self.limitLevel = nil
  self.redPointInfos = nil
  self.suppliesIconArr = nil
  self.resourceIconArr = nil
  self.jump = nil
  self.posRedPoint = nil
  self.newFuncTimestamp = nil
  self.playerSuppliesRewardTimes = nil
end

function LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(tabType)
  SFSNetwork.SendMessage(MsgDefines.GetZoneMobilizationInfo, tabType)
end

function LWZoneMobilizationManager:InitZoneMobilizationInfoData(message)
  if message.endTime == nil or message.endTime < UITimeManager:GetInstance():GetServerTime() then
    if self.isActivityOpen then
      self:Clear()
    end
    self.isActivityOpen = false
    EventManager:GetInstance():Broadcast(EventId.GetZoneMobilizationInfoData)
    return
  end
  DataCenter.WorldPointProtectionManager:StartUp()
  self.isActivityOpen = true
  self.stage = message.stage or 0
  self.nextStageTime = message.nextStageTime or 0
  self.serverId = message.serverId or 0
  self.pointId = message.pointId or 0
  self.bossId = message.bossId or 0
  if self.oldBossId == nil or self.oldBossId == 0 then
    self.oldBossId = self.bossId
  end
  self.beginTime = message.beginTime or 0
  self.endTime = message.endTime or 0
  self.isBossPlace = message.isBossPlace or false
  if message.donateInfo then
    if self.zoneMobilizationDonateInfo == nil then
      self.zoneMobilizationDonateInfo = LWZoneMobilizationDonatedInfo.New()
    end
    self.zoneMobilizationDonateInfo:RefreshData(message.donateInfo)
    self.dailyTaskRedPoint = message.donateInfo.taskRedPoint or false
  end
  if message.attackInfo then
    if self.zoneMobilizationAttackInfo == nil then
      self.zoneMobilizationAttackInfo = LWZoneMobilizationAttackInfo.New()
    end
    self.zoneMobilizationAttackInfo:RefreshData(message.attackInfo)
  end
  if message.defendInfo then
    if self.zoneMobilizationDefendInfo == nil then
      self.zoneMobilizationDefendInfo = LWZoneMobilizationDefendInfo.New()
    end
    self.zoneMobilizationDefendInfo:RefreshData(message.defendInfo)
  end
  if message.showRedPoint then
    local info = message.showRedPoint
    self.redPointInfos[ZoneMobilizationTabType.Donated] = info.donate
    self.redPointInfos[ZoneMobilizationTabType.Attack] = info.attack
    self.redPointInfos[ZoneMobilizationTabType.Defend] = info.defend
  end
  EventManager:GetInstance():Broadcast(EventId.OnZoneMobilizationRedPointChanged)
  EventManager:GetInstance():Broadcast(EventId.GetZoneMobilizationInfoData)
end

function LWZoneMobilizationManager:IsPlaced()
  return self.pointId > 0
end

function LWZoneMobilizationManager:GetCurStageType()
  if self.stage and self.stage > 0 then
    local stageTemplate = DataCenter.LWZoneMobilizationStageTemplateManager:GetTemplate(self.stage)
    if stageTemplate then
      return stageTemplate.stage_type
    end
  end
  return ZoneMobilizationStageType.None
end

local function GetPointId(self)
  return self.pointId
end

function LWZoneMobilizationManager:GetOwnBossMaxHp()
  local maxHp = 0
  if 0 < self.bossId then
    maxHp = GetTableData(TableName.ZoneMobilizationBoss, self.bossId, "rallyboss_hp")
  end
  return maxHp
end

function LWZoneMobilizationManager:GetOppositeBossMaxHp()
  local maxHp = 0
  if self.zoneMobilizationDefendInfo and 0 < self.zoneMobilizationDefendInfo.bossId then
    maxHp = GetTableData(TableName.ZoneMobilizationBoss, self.zoneMobilizationDefendInfo.bossId, "rallyboss_hp")
  end
  return maxHp
end

function LWZoneMobilizationManager:UpdateZoneMobilizationDonatedBoxData(message)
  if message.boxType then
    local boxType = message.boxType
    if self.zoneMobilizationDonateInfo then
      self.zoneMobilizationDonateInfo:HandleUpdateDonatedBoxNumData(boxType, 0)
      EventManager:GetInstance():Broadcast(EventId.UpdateZoneMobilizationDonatedBoxNumData, boxType)
    end
    DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
  end
end

function LWZoneMobilizationManager:InitTaskAndResourcePointsData(message)
  self.zoneMobilizationDailyTaskDict = {}
  if message.suppliesRewardTimes then
    self.suppliesRewardTimes = message.suppliesRewardTimes or 0
  end
  if message.playerSuppliesRewardTimes then
    self.playerSuppliesRewardTimes = message.playerSuppliesRewardTimes or 0
  end
  local broadGetZoneMobilizationDailyTaskData = false
  if message.taskArr then
    local taskArr = message.taskArr
    for i, v in ipairs(taskArr) do
      local dailyTaskInfo = LWZoneMobilizationDailyTaskInfo.New()
      dailyTaskInfo:InitData(v)
      self.zoneMobilizationDailyTaskDict[dailyTaskInfo.taskId] = dailyTaskInfo
    end
    broadGetZoneMobilizationDailyTaskData = true
  end
  local broadGetZoneMobilizationResourcePointsData = false
  self.zoneMobilizationResourcePointsList = {}
  if message.resourceArr then
    local resourceArr = message.resourceArr
    for i, v in ipairs(resourceArr) do
      local resourcePointsInfo = LWZoneMobilizationResourcePointsInfo.New()
      resourcePointsInfo:InitData(v)
      table.insert(self.zoneMobilizationResourcePointsList, resourcePointsInfo)
    end
    broadGetZoneMobilizationResourcePointsData = true
  end
  local broadGetZoneMobilizationSuppliesPointsData = false
  self.zoneMobilizationSuppliesPointsList = {}
  if message.suppliesArr then
    local suppliesArr = message.suppliesArr
    for i, v in ipairs(suppliesArr) do
      local suppliesPointsInfo = LWZoneMobilizationSuppliesPointsInfo.New()
      suppliesPointsInfo:InitData(v)
      table.insert(self.zoneMobilizationSuppliesPointsList, suppliesPointsInfo)
    end
    broadGetZoneMobilizationSuppliesPointsData = true
  end
  if broadGetZoneMobilizationDailyTaskData then
    EventManager:GetInstance():Broadcast(EventId.GetZoneMobilizationDailyTaskData)
  end
  if broadGetZoneMobilizationDailyTaskData then
    EventManager:GetInstance():Broadcast(EventId.GetZoneMobilizationResourcePointsData)
  end
  if broadGetZoneMobilizationDailyTaskData then
    EventManager:GetInstance():Broadcast(EventId.GetZoneMobilizationSuppliesPointsData)
  end
end

function LWZoneMobilizationManager:UpdateDailyTaskInfoAfterReceiveReward(message)
  if not DataCenter.LWZoneMobilizationManager.isActivityOpen then
    return
  end
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message.taskId then
    local taskId = message.taskId
    local taskState = TaskState.Received
    if self.zoneMobilizationDailyTaskDict[taskId] then
      DataCenter.RewardManager:ShowCommonReward(message)
      self.zoneMobilizationDailyTaskDict[taskId]:UpdateTaskState(taskState)
      self:UpdateDailyTaskRedPoint()
      EventManager:GetInstance():Broadcast(EventId.UpdateZoneMobilizationDailyTaskData, taskId)
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
    end
  end
end

function LWZoneMobilizationManager:UpdateDailyTaskRedPoint()
  local hasRedPoint = false
  if table.IsNullOrEmpty(self.zoneMobilizationDailyTaskDict) then
    return
  end
  for _, dailyTaskInfo in pairs(self.zoneMobilizationDailyTaskDict) do
    if dailyTaskInfo.state == TaskState.CanReceive then
      hasRedPoint = true
      break
    end
  end
  if hasRedPoint ~= self.dailyTaskRedPoint then
    self.dailyTaskRedPoint = hasRedPoint
    EventManager:GetInstance():Broadcast(EventId.UpdateZoneMobilizationDailyTaskRedPointData)
  end
end

function LWZoneMobilizationManager:HandleUpdateDonatedProgressRewardData(message)
  if message.stageReward and self.zoneMobilizationDonateInfo then
    self:UpdateDailyTaskRedPoint()
    self.zoneMobilizationDonateInfo:HandleUpdateDonatedProgressRewardData(message.stageReward)
    EventManager:GetInstance():Broadcast(EventId.UpdateDonatedProgressRewardData)
    DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
  end
end

function LWZoneMobilizationManager:GetZoneMobilizationDonatedInfoData()
  return self.zoneMobilizationDonateInfo
end

function LWZoneMobilizationManager:GetZoneMobilizationDailyTaskRedPointData()
  return self.dailyTaskRedPoint
end

function LWZoneMobilizationManager:GetZoneMobilizationDailyTaskData()
  return self.zoneMobilizationDailyTaskDict
end

function LWZoneMobilizationManager:GetZoneMobilizationSuppliesPointsData()
  local realResourcePointsList = {}
  for i = 1, table.count(self.zoneMobilizationResourcePointsList) do
    local data = self.zoneMobilizationResourcePointsList[i]
    if not data:IsExpired() then
      table.insert(realResourcePointsList, data)
    end
  end
  table.sort(realResourcePointsList, function(a, b)
    return a.expireTime < b.expireTime
  end)
  return realResourcePointsList
end

function LWZoneMobilizationManager:GetZoneMobilizationResourcePointsData()
  local realSuppliesPointsList = {}
  for i = 1, table.count(self.zoneMobilizationSuppliesPointsList) do
    local data = self.zoneMobilizationSuppliesPointsList[i]
    if not data:IsExpired() then
      table.insert(realSuppliesPointsList, data)
    end
  end
  return realSuppliesPointsList
end

function LWZoneMobilizationManager:GetZoneMobilizationSuppliesSelfGetCount()
  return self.suppliesRewardTimes
end

function LWZoneMobilizationManager:GetZoneMobilizationSmallSuppliesSelfGetCount()
  return self.playerSuppliesRewardTimes
end

function LWZoneMobilizationManager:HasAlreadyReceiveDonatedStageReward(stageId)
  if self.zoneMobilizationDonateInfo then
    return self.zoneMobilizationDonateInfo:HasAlreadyReceiveDonatedStageReward(stageId)
  end
  return false
end

function LWZoneMobilizationManager:IsReceiveAllDonatedStageReward()
  if self.zoneMobilizationDonateInfo then
    return self.zoneMobilizationDonateInfo:IsReceiveAllDonatedStageReward()
  end
  return false
end

function LWZoneMobilizationManager:TryReceiveDonatedProgressReward()
  local canReceiveDonatedStageReward = false
  if self.zoneMobilizationDonateInfo then
    canReceiveDonatedStageReward = self.zoneMobilizationDonateInfo:IsCanReceiveDonatedStageReward()
  end
  if canReceiveDonatedStageReward then
    SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationDonateProgressReward)
  end
  return canReceiveDonatedStageReward
end

local function GetDonateCostItemData(self)
  return LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k7", 0)
end

local function GetDonateLimitHoursItemData(self)
  return LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k20", 0)
end

local function GetProbWhenOpenBoxItemData(self)
  local param = LuaEntry.DataConfig:TryGetStr("zone_mobilization", "k5", "")
  local paramArray = string.split(param, "|")
  if 2 < #paramArray then
    return paramArray[1], paramArray[2], paramArray[3]
  end
  return 0, 0, 0
end

local function IsDonateLimited(self)
  if self.zoneMobilizationDonateInfo then
    return self.zoneMobilizationDonateInfo:IsDonateLimited()
  end
  return false
end

local function GetDonateUnlockCountDown(self)
  if self.zoneMobilizationDonateInfo and self.zoneMobilizationDonateInfo.allianceDonateInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local resTime = self.zoneMobilizationDonateInfo.allianceDonateInfo.limitEndTime - curTime
    if 0 < resTime then
      return UITimeManager:GetInstance():MilliSecondToFmtString(resTime)
    end
  end
  return ""
end

function LWZoneMobilizationManager:UpdateZoneMobilizationAttackRewardData(message)
  if message.index then
    local index = message.index
    if self.zoneMobilizationAttackInfo then
      self.zoneMobilizationAttackInfo:UpdateRewardReceiveState(index)
      EventManager:GetInstance():Broadcast(EventId.ReceiveChallengeRewardSuccess, index)
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
    end
  end
end

function LWZoneMobilizationManager:GetZoneMobilizationAttackInfoData()
  return self.zoneMobilizationAttackInfo
end

function LWZoneMobilizationManager:GoToBossPosition(bossPointId, serverId)
  local worldPosition = SceneUtils.TileIndexToWorld(bossPointId, ForceChangeScene.World, serverId)
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
  end, serverId)
end

function LWZoneMobilizationManager:UpdateZoneMobilizationDefendRewardData(message)
  if message.index then
    local index = message.index
    if self.zoneMobilizationDefendInfo then
      self.zoneMobilizationDefendInfo:UpdateRewardReceiveState(index)
      EventManager:GetInstance():Broadcast(EventId.ReceiveDefendRewardSuccess, index)
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
    end
  end
end

function LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
  return self.zoneMobilizationDefendInfo
end

function LWZoneMobilizationManager:HandleRankListData(message)
  if message.type then
    local type = message.type
    local rankInfo
    if not self.rankDict[type] then
      rankInfo = LWZoneMobilizationRankInfo.New()
      self.rankDict[type] = rankInfo
    else
      rankInfo = self.rankDict[type]
    end
    if rankInfo then
      rankInfo:RefreshData(message)
    end
    EventManager:GetInstance():Broadcast(EventId.GetZoneMobilizationRankData, type)
  end
end

function LWZoneMobilizationManager:HandleRankRewardPreviewData(message)
  if message.donateRewardArr then
    local donatedRewardInfoList = {}
    for i, v in ipairs(message.donateRewardArr) do
      local rewardPreviewInfo = LWZoneMobilizationRankRewardPreviewInfo.New()
      rewardPreviewInfo:RefreshData(v)
      table.insert(donatedRewardInfoList, rewardPreviewInfo)
    end
    self.rankRewardPreviewDict[ZoneMobilizationRankType.Donated] = donatedRewardInfoList
  end
  if message.damageRewardArr then
    local damageRewardInfoList = {}
    for i, v in ipairs(message.damageRewardArr) do
      local rewardPreviewInfo = LWZoneMobilizationRankRewardPreviewInfo.New()
      rewardPreviewInfo:RefreshData(v)
      table.insert(damageRewardInfoList, rewardPreviewInfo)
    end
    self.rankRewardPreviewDict[ZoneMobilizationRankType.Damage] = damageRewardInfoList
  end
  EventManager:GetInstance():Broadcast(EventId.GetZoneMobilizationRankRewardPreviewData)
end

function LWZoneMobilizationManager:GetRankInfoDataByType(type)
  if self.rankDict[type] then
    return self.rankDict[type]
  end
end

function LWZoneMobilizationManager:GetRankRewardPreviewDataByType(type)
  if self.rankRewardPreviewDict[type] then
    return self.rankRewardPreviewDict[type]
  end
end

function LWZoneMobilizationManager:SplitLocalCacheStagePlotData()
  local localCacheBeginTime = 0
  local localCacheStageId = 0
  local localCachePlotDataStr = CommonUtil.PlayerPrefsGetString(SettingKeys.ZONE_MOBILIZATION_AUTO_FILL_PROGRESS_PLOT, "")
  local localCachePlotDataArr = string.split(localCachePlotDataStr, "|")
  if table.count(localCachePlotDataArr) == 2 then
    localCacheBeginTime = tonumber(localCachePlotDataArr[1])
    localCacheStageId = tonumber(localCachePlotDataArr[2])
  end
  return localCacheBeginTime, localCacheStageId
end

function LWZoneMobilizationManager:RecordLocalCacheStagePlotData()
  self.localCacheBeginTime = self.beginTime
  self.localCacheStageId = self.stage
  local recordStr = tostring(self.beginTime) .. "|" .. tostring(self.stage)
  CommonUtil.PlayerPrefsSetString(SettingKeys.ZONE_MOBILIZATION_AUTO_FILL_PROGRESS_PLOT, recordStr)
end

function LWZoneMobilizationManager:CheckLocalCacheDataIsValid()
  if self.localCacheBeginTime ~= self.beginTime or self.localCacheStageId ~= self.stage then
    return false
  end
  return true
end

local function OpenDonateWindow(self, point)
  local itemId = DataCenter.LWZoneMobilizationManager:GetDonateCostItemData()
  if itemId then
    local getNum = LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k16", 1)
    local have = DataCenter.ItemData:GetItemCount(itemId) or 0
    if getNum > have then
      UIUtil.ShowTipsId("zone_mobilization_donated_nothing")
      if self:GetIsNewFunc() then
        self.jump = true
        if self.isActivityOpen then
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationMain)
        end
      end
      return
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMobilizationDonate, {anim = true}, point)
end

local function GetWorldPointData(self, uuid)
  if uuid then
    local info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if info and info.zoneMobilizationPointInfo then
      local oneData = {}
      oneData.uuid = uuid
      local curStageType = self:GetStageType(info.zoneMobilizationPointInfo.stage)
      if (curStageType == ZoneMobilizationStageType.Donated or curStageType == ZoneMobilizationStageType.Sprint) and info.serverId == LuaEntry.Player:GetSourceServerId() then
        oneData.canAttack = true
      end
      local bossId = info.zoneMobilizationPointInfo and info.zoneMobilizationPointInfo.bossId
      local name = self:GetWorldBuildingDetailNameTitle(info.serverId, bossId)
      oneData.name = name
      oneData.shareName = self:GetWorldBuildingName(bossId)
      return oneData
    end
  end
end

local function TryGetReward(self)
  if self.pointId ~= 0 then
    local needGetReward = self:TryReceiveDonatedProgressReward()
    if needGetReward then
      return true
    end
  end
  return false
end

local function DonateTabGotoPointHandler(self)
  if self.pointId == 0 then
    if LuaEntry.Player:IsPresident() then
      self:GotoWorldPointPut(self.serverId, function(point)
        DataCenter.LWZoneMobilizationManager:PutAirshipBuildModel(point)
      end)
    else
      UIUtil.ShowTipsId("zone_mobilization_tips_unbuilt")
    end
  else
    self:GotoWorldPointOpen(self.pointId, self.serverId)
  end
end

local function GotoWorldPointOpen(self, point, serverId)
  if point and 0 < point then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPointAndOpen(point, nil, nil, serverId)
  else
    Logger.LogError("the point is invalid : " .. point)
  end
end

local function GotoPutBoss(self, point)
  if LuaEntry.Player:IsPresident() then
    local serverId = self.zoneMobilizationAttackInfo and self.zoneMobilizationAttackInfo.bossServerId
    if serverId and 0 < serverId then
      self:GotoWorldPointPut(serverId, function(pointId)
        self:PutBossModel(pointId)
      end)
    end
  else
    local serverId = LuaEntry.Player:GetSourceServerId()
    if serverId and 0 < serverId then
      self:GotoWorldPoint(point, serverId)
    end
  end
end

local function GotoWorldPoint(self, point, serverId, callback)
  if point and 0 < point then
    GoToUtil.CloseAllWindows()
    local pos = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World, serverId)
    GoToUtil.GotoWorldPos(pos, nil, nil, callback, serverId)
  else
    Logger.LogError("the point is invalid : " .. point)
  end
end

local function GetPutDefaultPoint(self)
  local posStr = LuaEntry.DataConfig:TryGetStr("zone_mobilization", "k1", "")
  if not string.IsNullOrEmpty(posStr) then
    local posArr = string.split(posStr, ",")
    if posArr and #posArr == 2 then
      local pos = Vector3.New(tonumber(posArr[1]) * TileSize, 0, tonumber(posArr[2]) * TileSize)
      local point = SceneUtils.WorldToTileIndex(pos, ForceChangeScene.World)
      return point, pos
    end
  end
end

local function GotoWorldPointPut(self, serverId, callback)
  local point, pos = self:GetPutDefaultPoint()
  if point and 0 < point and pos then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(pos, nil, nil, function()
      if callback then
        callback(point)
      end
    end, serverId)
  end
end

local function PutAirshipBuildModel(self, point)
  if point and 0 < point then
    GoToUtil.CloseAllWindows()
    if self:GetCurStageType() == ZoneMobilizationStageType.Donated and self.pointId == 0 then
      local modelPath = GetTableData(TableName.ZoneMobilizationBoss, self.bossId, "building_put_model")
      if self.bossId and 0 < self.bossId then
        local size = GetTableData(TableName.ZoneMobilizationBoss, self.bossId, "building_size")
        if size and 0 < size then
          UIUtil.UICreateWorldMovingModel(modelPath, FakeMovingModelFlag.Airship, point, size)
        end
      end
    end
  end
end

local function PutBossModel(self, point)
  if point and 0 < point then
    GoToUtil.CloseAllWindows()
    if self:GetCurStageType() == ZoneMobilizationStageType.Battle_Place and self.bossId and 0 < self.bossId then
      local monsterId = GetTableData(TableName.ZoneMobilizationBoss, self.bossId, "world_monster")
      if monsterId then
        local modelPath = GetTableData(TableName.ZoneMobilizationBoss, self.bossId, "boss_put_model")
        local size = GetTableData(TableName.Monster, tonumber(monsterId), "size")
        if not string.IsNullOrEmpty(modelPath) and size and 0 < size then
          UIUtil.UICreateWorldMovingModel(modelPath, FakeMovingModelFlag.ZMBoss, point, size)
        end
      end
    end
  end
end

local function RequestPutAirshipBuild(self, point)
  if point and 0 < point then
    SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationBuildToWorld, point)
  end
end

local function GetWorldBuildingName(self, bossId)
  if bossId and 0 < bossId then
    local nameDigId = GetTableData(TableName.ZoneMobilizationBoss, bossId, "building_name")
    return nameDigId
  end
end

local function GetWorldBuildingDetailNameTitle(self, serverId, bossId)
  if serverId and 0 < serverId then
    local color = "2A2830"
    if serverId ~= self.serverId then
      color = "f53c3d"
    end
    local nameDigId = self:GetWorldBuildingName(bossId)
    if not string.IsNullOrEmpty(nameDigId) then
      local name = CS.GameEntry.Localization:GetString(nameDigId)
      return CS.GameEntry.Localization:GetString("zone_mobilization_boss_name_include", color, serverId, name)
    end
  end
  return ""
end

local function GetWorldBossDetailNameTitle(self, param)
  if param and param.zMBossInfo then
    local monsterId = param.monsterId
    if monsterId then
      local nameDigId = GetTableData(TableName.Monster, tonumber(monsterId), "name")
      if not string.IsNullOrEmpty(nameDigId) then
        local color = "2A2830"
        if param.zMBossInfo.bossSrcServer ~= LuaEntry.Player:GetSourceServerId() then
          color = "f53c3d"
        end
        local name = CS.GameEntry.Localization:GetString(nameDigId)
        return CS.GameEntry.Localization:GetString("zone_mobilization_boss_name_include", color, param.zMBossInfo.bossSrcServer, name)
      end
    end
  end
  return ""
end

local function RequestPutBoss(self, point)
  if point and 0 < point and self.zoneMobilizationAttackInfo and 0 < self.zoneMobilizationAttackInfo.bossServerId then
    SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationPlaceBoss, point, self.zoneMobilizationAttackInfo.bossServerId)
  end
end

local function GetStageType(self, stageId)
  if stageId and 0 < stageId then
    local stageTemplate = DataCenter.LWZoneMobilizationStageTemplateManager:GetTemplate(stageId)
    if stageTemplate then
      return stageTemplate.stage_type
    end
  end
  return ZoneMobilizationStageType.None
end

local function CheckShowPlaceRemind(self)
  local show = false
  if self.isActivityOpen and LuaEntry.Player:IsPresident() then
    local stageType = self:GetCurStageType()
    show = stageType == ZoneMobilizationStageType.Donated and self.pointId <= 0
  end
  return show
end

local function IsActivityOpen(self)
  return self.isActivityOpen
end

local function OnBossAttacked(self, message)
  if message and message.targetList then
    if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
      return
    end
    UIUtil.ShowAttackUnitsTips(AttackerBossType.ZoneMobilizationBoss, message.targetList)
  end
end

local function ShowRedPoint(self)
  local redPoint = self:GetDonateTabRedPoint()
  if redPoint then
    return redPoint
  end
  redPoint = self:GetAttackTabRedPoint()
  if redPoint then
    return redPoint
  end
  redPoint = self:GetDefendTabRedPoint()
  if redPoint then
    return redPoint
  end
end

local function GetDonateTabRedPoint(self)
  if self.zoneMobilizationDonateInfo then
    if self.zoneMobilizationDonateInfo.personalDonateInfo.boxNum > 0 or 0 < self.zoneMobilizationDonateInfo.allianceDonateInfo.boxNum then
      return true
    end
    if self:GetZoneMobilizationDailyTaskRedPointData() then
      return true
    end
    if self.zoneMobilizationDonateInfo:IsCanReceiveDonatedStageReward() then
      return true
    end
  end
  if self.redPointInfos and self.redPointInfos[ZoneMobilizationTabType.Donated] then
    return true
  end
  if self:GetBossLevelRedPoint() then
    return true
  end
  return self:GetPosRedPoint()
end

local function GetAttackTabRedPoint(self)
  if self.zoneMobilizationAttackInfo and self.zoneMobilizationAttackInfo:CanReceiveReward() then
    return true
  end
  if self.redPointInfos then
    return self.redPointInfos[ZoneMobilizationTabType.Attack]
  end
end

local function GetDefendTabRedPoint(self)
  if self.zoneMobilizationDefendInfo then
    local boxRewardList = self.zoneMobilizationDefendInfo.rewardList
    local totalHp = self:GetOppositeBossMaxHp()
    local bossCurHp = self.zoneMobilizationDefendInfo.curHp
    local surplusHpPercent = bossCurHp / totalHp * 100
    for _, v in ipairs(boxRewardList) do
      if surplusHpPercent <= v.targetValue and not v.rewarded then
        return true
      end
    end
  end
  if self.redPointInfos then
    return self.redPointInfos[ZoneMobilizationTabType.Defend]
  end
end

local function EnterWorld(self)
  DataCenter.ZoneMobilizationCtrlManager:EnterWorld()
end

local function ExitWorld(self)
  DataCenter.ZoneMobilizationCtrlManager:ExitWorld()
end

local function OnPassDay(self)
  local curStageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
  local refresh = curStageType == ZoneMobilizationStageType.Donated or curStageType == ZoneMobilizationStageType.Sprint
  if refresh then
    DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
  end
end

local function UpdateOldBossId(self)
  self.oldBossId = self.bossId
end

local function GetBossLevelRedPoint(self)
  local show = self:GetCurStageType() == ZoneMobilizationStageType.Sprint
  return show and not CS.GameEntry.Setting:GetBool(SettingKeys.ZONE_MOBILIZATION_BOSS_LEVEL_DESC, false)
end

local function SetBossLevelRedPoint(self)
  CS.GameEntry.Setting:SetBool(SettingKeys.ZONE_MOBILIZATION_BOSS_LEVEL_DESC, true)
  EventManager:GetInstance():Broadcast(EventId.OnZoneMobilizationRedPointChanged)
end

local function GetLimitLevel(self)
  if self.limitLevel then
    return self.limitLevel
  end
  local level = LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k24", 0)
  self.limitLevel = level
  return level
end

local function GetTransferTotalTime(self)
  return LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k27", 0) * 1000
end

local function UpdateDonateRedPoint(self)
  DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
end

local function GetCanReceivedTaskReward(message)
  if message and message.task ~= nil then
    local task = message.task
    local self = DataCenter.LWZoneMobilizationManager
    for k, v in pairs(task) do
      if v.state == TaskState.CanReceive and self:ContainsValue(self.taskIds, v.id) then
        DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
        return
      end
    end
  end
end

local function GetTaskIds(self)
  local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization", "k16")
  self.taskIds = not string.IsNullOrEmpty(str) and string.split(str, ",") or nil
  return self.taskIds
end

local function ContainsValue(self, list, value)
  if list then
    for _, v in ipairs(list) do
      if v and v == value then
        return true
      end
    end
  end
  return false
end

local function GetSuppliesIcon(self, type)
  if self.suppliesIconArr and #self.suppliesIconArr >= 2 then
    local index = type == 0 and 1 or 2
    return self.suppliesIconArr[index]
  end
end

local function GetSuppliesIconData(self)
  local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization_donate", "k7")
  local arr
  if not string.IsNullOrEmpty(str) then
    arr = string.split(str, "|")
  end
  self.suppliesIconArr = arr
  return self.suppliesIconArr
end

local function GetResourceIcon(self, type)
  if self.resourceIconArr and #self.resourceIconArr >= 2 then
    local index = type == 0 and 1 or 2
    return self.resourceIconArr[index]
  end
end

local function GetResourceIconData(self)
  local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization_donate", "k13")
  local arr
  if not string.IsNullOrEmpty(str) then
    arr = string.split(str, "|")
  end
  self.resourceIconArr = arr
  return self.resourceIconArr
end

local function GetPosRedPoint(self)
  local showRedPoint = false
  local stageType = self:GetCurStageType()
  if (stageType == ZoneMobilizationStageType.Donated or stageType == ZoneMobilizationStageType.Sprint) and DataCenter.LWZoneMobilizationManager.pointId > 0 and DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ZoneMobilizationDonatePosRedPoint) then
    showRedPoint = true
  end
  self.posRedPoint = showRedPoint
  return self.posRedPoint
end

local function SetPosRedPoint(self)
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.ZoneMobilizationDonatePosRedPoint, false)
  EventManager:GetInstance():Broadcast(EventId.OnZoneMobilizationRedPointChanged)
end

local function GetIsNewFunc(self)
  if self.newFuncTimestamp == nil or self.newFuncTimestamp == 0 then
    local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization_donate", "k1")
    self.newFuncTimestamp = UIUtil.GetAbsoluteTimeByStr(str)
  end
  local now = UITimeManager:GetInstance():GetServerSeconds()
  return now >= self.newFuncTimestamp
end

local function GetPersonalMax(self)
  local max = 0
  if self:GetIsNewFunc() then
    max = LuaEntry.DataConfig:TryGetNum("zone_mobilization_donate", "k5")
  end
  self.personalMax = max
  return self.personalMax
end

local function GetAllianceMax(self)
  local max = 0
  if self:GetIsNewFunc() then
    max = LuaEntry.DataConfig:TryGetNum("zone_mobilization_donate", "k6")
  else
    max = LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k21")
  end
  self.allianceMax = max
  return self.allianceMax
end

local function GetSuppliesRedPoint(self)
  if self.zoneMobilizationDonateInfo then
    local checkSupplies, checkPersonSupplies = false, false
    if self.suppliesRewardTimes == 0 or self.suppliesRewardTimes > 0 and self.suppliesRewardTimes < self.allianceMax then
      checkSupplies = true
    end
    if self.playerSuppliesRewardTimes == 0 or 0 < self.playerSuppliesRewardTimes and self.playerSuppliesRewardTimes < self.personalMax then
      checkPersonSupplies = true
    end
    return self.zoneMobilizationDonateInfo:GetSuppliesRedPoint(checkSupplies, checkPersonSupplies)
  end
  return false
end

LWZoneMobilizationManager.AddListeners = AddListeners
LWZoneMobilizationManager.RemoveListeners = RemoveListeners
LWZoneMobilizationManager.Clear = Clear
LWZoneMobilizationManager.GetDonateCostItemData = GetDonateCostItemData
LWZoneMobilizationManager.GetDonateLimitHoursItemData = GetDonateLimitHoursItemData
LWZoneMobilizationManager.GetProbWhenOpenBoxItemData = GetProbWhenOpenBoxItemData
LWZoneMobilizationManager.OpenDonateWindow = OpenDonateWindow
LWZoneMobilizationManager.GetWorldPointData = GetWorldPointData
LWZoneMobilizationManager.GotoPutBoss = GotoPutBoss
LWZoneMobilizationManager.GetPointId = GetPointId
LWZoneMobilizationManager.GotoWorldPointOpen = GotoWorldPointOpen
LWZoneMobilizationManager.GotoWorldPoint = GotoWorldPoint
LWZoneMobilizationManager.GetPutDefaultPoint = GetPutDefaultPoint
LWZoneMobilizationManager.GotoWorldPointPut = GotoWorldPointPut
LWZoneMobilizationManager.PutAirshipBuildModel = PutAirshipBuildModel
LWZoneMobilizationManager.PutBossModel = PutBossModel
LWZoneMobilizationManager.RequestPutAirshipBuild = RequestPutAirshipBuild
LWZoneMobilizationManager.TryGetReward = TryGetReward
LWZoneMobilizationManager.DonateTabGotoPointHandler = DonateTabGotoPointHandler
LWZoneMobilizationManager.GetWorldBuildingName = GetWorldBuildingName
LWZoneMobilizationManager.GetWorldBuildingDetailNameTitle = GetWorldBuildingDetailNameTitle
LWZoneMobilizationManager.GetWorldBossDetailNameTitle = GetWorldBossDetailNameTitle
LWZoneMobilizationManager.RequestPutBoss = RequestPutBoss
LWZoneMobilizationManager.GetStageType = GetStageType
LWZoneMobilizationManager.CheckShowPlaceRemind = CheckShowPlaceRemind
LWZoneMobilizationManager.IsActivityOpen = IsActivityOpen
LWZoneMobilizationManager.IsDonateLimited = IsDonateLimited
LWZoneMobilizationManager.GetDonateUnlockCountDown = GetDonateUnlockCountDown
LWZoneMobilizationManager.OnBossAttacked = OnBossAttacked
LWZoneMobilizationManager.ShowRedPoint = ShowRedPoint
LWZoneMobilizationManager.EnterWorld = EnterWorld
LWZoneMobilizationManager.ExitWorld = ExitWorld
LWZoneMobilizationManager.OnPassDay = OnPassDay
LWZoneMobilizationManager.UpdateOldBossId = UpdateOldBossId
LWZoneMobilizationManager.GetBossLevelRedPoint = GetBossLevelRedPoint
LWZoneMobilizationManager.SetBossLevelRedPoint = SetBossLevelRedPoint
LWZoneMobilizationManager.GetLimitLevel = GetLimitLevel
LWZoneMobilizationManager.GetTransferTotalTime = GetTransferTotalTime
LWZoneMobilizationManager.GetDonateTabRedPoint = GetDonateTabRedPoint
LWZoneMobilizationManager.GetAttackTabRedPoint = GetAttackTabRedPoint
LWZoneMobilizationManager.GetDefendTabRedPoint = GetDefendTabRedPoint
LWZoneMobilizationManager.UpdateDonateRedPoint = UpdateDonateRedPoint
LWZoneMobilizationManager.getters.taskIds = GetTaskIds
LWZoneMobilizationManager.ContainsValue = ContainsValue
LWZoneMobilizationManager.GetCanReceivedTaskReward = GetCanReceivedTaskReward
LWZoneMobilizationManager.GetSuppliesIcon = GetSuppliesIcon
LWZoneMobilizationManager.getters.suppliesIconArr = GetSuppliesIconData
LWZoneMobilizationManager.GetResourceIcon = GetResourceIcon
LWZoneMobilizationManager.getters.resourceIconArr = GetResourceIconData
LWZoneMobilizationManager.GetPosRedPoint = GetPosRedPoint
LWZoneMobilizationManager.SetPosRedPoint = SetPosRedPoint
LWZoneMobilizationManager.GetIsNewFunc = GetIsNewFunc
LWZoneMobilizationManager.getters.personalMax = GetPersonalMax
LWZoneMobilizationManager.getters.allianceMax = GetAllianceMax
LWZoneMobilizationManager.GetSuppliesRedPoint = GetSuppliesRedPoint
return LWZoneMobilizationManager
