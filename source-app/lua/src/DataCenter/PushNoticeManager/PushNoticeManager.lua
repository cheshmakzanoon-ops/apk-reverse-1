local Localization = CS.GameEntry.Localization
local PushNoticeManager = BaseClass("PushNoticeManager")
local PushId = {
  ResBuildingFull = 4100001,
  TruckFull = 4100002,
  StaminaFull = 4100029,
  BuildingUpgradeDone = 4100033,
  ResearchDone = 4100034,
  MilitaryCampFull = 4100040,
  PersonalArmyRace = 4101100,
  CollectEnd = 4100041,
  ActLotteryOpenReward = 4100043
}
local PushStatus = {
  None = 0,
  WaitSet = 1,
  WaitCancel = 2
}
local SEND_INTERVAL_SEC = 10
local MIN_ALARM_TIME = 600
local PERSON_AMY_DELAYTIME = 14400
local ResBuildingSet = {
  BuildingTypes.LW_BUILD_FARMLAND,
  BuildingTypes.LW_BUILD_QUARRY,
  BuildingTypes.LW_BUILD_GOLD_MILL,
  BuildingTypes.LW_BUILD_SMELTERY,
  BuildingTypes.LW_BUILD_TRAINING_CENTER,
  BuildingTypes.LW_BUILD_MATERIALS_WORKERSHOP,
  BuildingTypes.LW_BUILD_PETROLEUM,
  BuildingTypes.LW_BUILD_DOMINATOR_TRAIN
}

function PushNoticeManager:__init()
  self.pushDefines = {
    [PushId.ResBuildingFull] = {
      pushId = PushId.ResBuildingFull,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcResBuildingFullTimeSec()
      end
    },
    [PushId.TruckFull] = {
      pushId = PushId.TruckFull,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcTruckFullTimeSec()
      end
    },
    [PushId.StaminaFull] = {
      pushId = PushId.StaminaFull,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcStaminaFullTimeSec()
      end
    },
    [PushId.BuildingUpgradeDone] = {
      pushId = PushId.BuildingUpgradeDone,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcBuildingUpgradeTimeSec()
      end
    },
    [PushId.ResearchDone] = {
      pushId = PushId.ResearchDone,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcResearchDoneTimeSec()
      end
    },
    [PushId.MilitaryCampFull] = {
      pushId = PushId.MilitaryCampFull,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcMilitaryCampFullTimeSec()
      end
    },
    [PushId.CollectEnd] = {
      pushId = PushId.CollectEnd,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcCollectEndTimeSec()
      end
    },
    [PushId.ActLotteryOpenReward] = {
      pushId = PushId.ActLotteryOpenReward,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcActLotteryOpenBigRewardTimeSec()
      end
    },
    [PushId.PersonalArmyRace] = {
      pushId = PushId.PersonalArmyRace,
      pushStatus = PushStatus.None,
      timeStamp = nil,
      alreadySet = false,
      calcTimeFunc = function()
        self:CalcPersonalArmyTimeSec()
      end
    }
  }
  self.__event_handlers = {}
  self:AddListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:AddListener(EventId.PlayerStaminaUpdate, self.OnPlayerStaminaUpdate)
  self:AddListener(EventId.HangRewardRefreshed, self.OnHangRewardRefreshed)
  self:AddListener(EventId.ProductLineCollect, self.OnProductLineCollect)
  self:AddListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildingData)
  self:AddListener(EventId.UPDATE_QUEUE_DATA, self.OnUpdateQueueData)
  self:AddListener(EventId.MarchItemUpdateSelf, self.OnMarchItemUpdateSelf)
  self:AddListener(EventId.ActLotteryTryOpenTip, self.OnActLotteryOpenTipGet)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  self.nextSendTimeStamp = serverTime + SEND_INTERVAL_SEC * 1000
  self.trySendTimer = TimerManager:GetInstance():GetTimer(SEND_INTERVAL_SEC, BindCallback(self, self.TrySendAllNotice), self, false, false, false)
  self.trySendTimer:Start()
end

function PushNoticeManager:__delete()
  self:RemoveListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:RemoveListener(EventId.PlayerStaminaUpdate, self.OnPlayerStaminaUpdate)
  self:RemoveListener(EventId.HangRewardRefreshed, self.OnHangRewardRefreshed)
  self:RemoveListener(EventId.ProductLineCollect, self.OnProductLineCollect)
  self:RemoveListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildingData)
  self:RemoveListener(EventId.UPDATE_QUEUE_DATA, self.OnUpdateQueueData)
  self:RemoveListener(EventId.MarchItemUpdateSelf, self.OnMarchItemUpdateSelf)
  self:RemoveListener(EventId.ActLotteryTryOpenTip, self.OnActLotteryOpenTipGet)
  self.nextSendTimeStamp = nil
  if self.trySendTimer then
    self.trySendTimer:Stop()
  end
  self.trySendTimer = nil
  if self.personalArmyTimer then
    self.personalArmyTimer:Stop()
  end
  self.personalArmyTimer = nil
  self.pushDefines = nil
  self.__event_handlers = nil
end

function PushNoticeManager:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function PushNoticeManager:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    Logger.LogError(msg_name, " not register")
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function PushNoticeManager:OnEnterGame()
  self:CancelAllNotice()
  for pushId, _ in pairs(self.pushDefines) do
    self:TryPushNotice(pushId)
  end
end

function PushNoticeManager:OnApplicationPause(isPaused)
  if not isPaused then
    DataCenter.PushNoticeManager:OnEnterGame()
  end
end

function PushNoticeManager:OnPlayerStaminaUpdate()
  self:TryPushNotice(PushId.StaminaFull)
end

function PushNoticeManager:OnHangRewardRefreshed()
  self:TryPushNotice(PushId.TruckFull)
end

function PushNoticeManager:OnProductLineCollect(buildingUuid)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(buildingUuid)
  if buildingData and table.indexof(ResBuildingSet, buildingData.itemId) then
    self:TryPushNotice(PushId.ResBuildingFull)
  end
end

function PushNoticeManager:OnUpdateBuildingData(buildingUuid)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(buildingUuid)
  if buildingData and buildingData.itemId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
    self:TryPushNotice(PushId.MilitaryCampFull)
  end
  self:TryPushNotice(PushId.BuildingUpgradeDone)
end

function PushNoticeManager:OnUpdateQueueData(queueData)
  if queueData.type == NewQueueType.Science then
    self:TryPushNotice(PushId.ResearchDone)
  end
end

function PushNoticeManager:OnMarchItemUpdateSelf(marchUuid)
  self:TryPushNotice(PushId.CollectEnd)
end

function PushNoticeManager:OnActLotteryOpenTipGet(actLotteryId)
  self:TryPushNotice(PushId.ActLotteryOpenReward)
end

function PushNoticeManager:TryPushNotice(pushId)
  local isSettingsOn = DataCenter.PushSettingsManager:IsPushOn(pushId)
  if not isSettingsOn then
    return
  end
  local define = self.pushDefines[pushId]
  if not define then
    return
  end
  define.calcTimeFunc()
end

function PushNoticeManager:TrySendAllNotice()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  for pushId, data in pairs(self.pushDefines) do
    if data.pushStatus == PushStatus.WaitSet then
      local sec = (data.timeStamp - serverTime) / 1000
      data.pushStatus = PushStatus.None
      data.alreadySet = true
      self:PushNotice(pushId, sec)
    elseif data.pushStatus == PushStatus.WaitCancel then
      data.pushStatus = PushStatus.None
      data.alreadySet = false
      self:CancelNotice(pushId)
    end
  end
  self.nextSendTimeStamp = serverTime + SEND_INTERVAL_SEC * 1000
end

function PushNoticeManager:PushNotice(pushId, timeSec)
  local pushType = LocalController:instance():getValue(TableName.APS_PUSH, pushId, "push_type")
  local pushBody = Localization:GetString(LocalController:instance():getValue(TableName.APS_PUSH, pushId, "dialogId"))
  local param = {}
  param.type = tostring(pushType)
  param.time = math.ceil(timeSec)
  param.body = pushBody
  param.soundKey = ""
  param.pushType = tostring(pushType)
  param.playerMark = LuaEntry.Player.pushMark
  param.gameUid = LuaEntry.Player.uid
  param.pushId = tostring(pushId)
  local strJson = require("rapidjson").encode(param)
  CS.PushNoticeManager.PushNotice(strJson)
  Logger.LogInfo("[PushNotice]PushNotice : " .. strJson)
end

function PushNoticeManager:CancelNotice(pushId)
  local pushType = LocalController:instance():getValue(TableName.APS_PUSH, pushId, "push_type")
  local param = {}
  param.type = tostring(pushType)
  param.pushType = tostring(pushType)
  param.pushId = tostring(pushId)
  local strJson = require("rapidjson").encode(param)
  CS.PushNoticeManager.CancelNotice(strJson)
  Logger.LogInfo("[PushNotice]CancelNotice : " .. strJson)
end

function PushNoticeManager:CancelAllNotice()
  for pushId, _ in pairs(self.pushDefines) do
    local pushDefine = self.pushDefines[pushId]
    pushDefine.pushStatus = PushStatus.None
    pushDefine.alreadySet = false
    pushDefine.timeStamp = nil
  end
  CS.PushNoticeManager.ClearAllNotice()
end

function PushNoticeManager:CheckNoticeBySettings(pushSettingsId)
  local pushIds = LocalController:instance():getValue(TableName.APS_PUSH_SETTINGS, pushSettingsId, "push_ids")
  for _, pushId in ipairs(pushIds) do
    self:TryPushNotice(pushId)
  end
end

function PushNoticeManager:CancelNoticeBySettings(pushSettingsId)
  local pushIds = LocalController:instance():getValue(TableName.APS_PUSH_SETTINGS, pushSettingsId, "push_ids")
  for _, pushId in ipairs(pushIds) do
    local pushDefine = self.pushDefines[pushId]
    if pushDefine then
      pushDefine.pushStatus = PushStatus.None
      pushDefine.alreadySet = false
      pushDefine.timeStamp = nil
      self:CancelNotice(pushId)
    end
  end
end

function PushNoticeManager:SetPushToWaitCall(pushId, minStamp)
  local pushDefine = self.pushDefines[pushId]
  if pushDefine then
    if pushDefine.timeStamp == minStamp then
      return
    end
    if minStamp == nil then
      if pushDefine.alreadySet then
        pushDefine.pushStatus = PushStatus.WaitCancel
        Logger.LogInfo("[PushNotice]PushToWaitCancel : " .. pushId)
      else
        pushDefine.pushStatus = PushStatus.None
      end
    elseif pushDefine.timeStamp ~= minStamp then
      pushDefine.pushStatus = PushStatus.WaitSet
      pushDefine.timeStamp = minStamp
      Logger.LogInfo("[PushNotice]PushToWaitSet : " .. pushId)
    end
  end
end

function PushNoticeManager:CalcStaminaFullTimeSec()
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config == nil then
    return
  end
  local stamina = LuaEntry.Player:GetCurStamina()
  local minStamp
  if stamina < config.FormationStaminaMax then
    local deltaNum = config.FormationStaminaMax - stamina
    local endTime = deltaNum * config.FormationStaminaUpdateTime
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local stamp = serverTime + endTime * 1000
    if stamp > self.nextSendTimeStamp then
      minStamp = stamp
    end
  end
  self:SetPushToWaitCall(PushId.StaminaFull, minStamp)
end

function PushNoticeManager:CalcResBuildingFullTimeSec()
  local minStamp
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  for _, buildingId in ipairs(ResBuildingSet) do
    local buildingDatas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildingId)
    for _, buildingData in ipairs(buildingDatas) do
      local prodState = DataCenter.ProductLineManager:GetState(buildingData.uuid)
      if prodState == ProductLineState.Normal and buildingData.productEndTime then
        local stamp = buildingData.productEndTime
        local restSec = (buildingData.productEndTime - serverTime) / 1000
        if restSec > MIN_ALARM_TIME and stamp > self.nextSendTimeStamp and (not minStamp or minStamp > stamp) then
          minStamp = stamp
        end
      end
    end
  end
  self:SetPushToWaitCall(PushId.ResBuildingFull, minStamp)
end

function PushNoticeManager:CalcTruckFullTimeSec()
  local minStamp
  if DataCenter.StageManager.lastIdleRewardTimeStamp then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local stamp = DataCenter.StageManager.lastIdleRewardTimeStamp + DataCenter.StageManager.hangUpMaxTime
    if serverTime < stamp then
      local restTime = serverTime - DataCenter.StageManager.lastIdleRewardTimeStamp
      local restSec = (DataCenter.StageManager.hangUpMaxTime - restTime) / 1000
      if restSec >= MIN_ALARM_TIME and stamp > self.nextSendTimeStamp then
        minStamp = stamp
      end
    end
  end
  self:SetPushToWaitCall(PushId.TruckFull, minStamp)
end

function PushNoticeManager:CalcBuildingUpgradeTimeSec()
  local minStamp
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local buildingDatas = DataCenter.BuildManager:GetAllBuildData()
  for _, buildingData in pairs(buildingDatas) do
    if buildingData:IsUpgrading() then
      local stamp = buildingData.updateTime
      local restSec = (buildingData.updateTime - serverTime) / 1000
      if restSec >= MIN_ALARM_TIME and stamp > self.nextSendTimeStamp and (not minStamp or minStamp > stamp) then
        minStamp = stamp
      end
    end
  end
  self:SetPushToWaitCall(PushId.BuildingUpgradeDone, minStamp)
end

function PushNoticeManager:CalcResearchDoneTimeSec()
  local minStamp
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local queueDatas = DataCenter.QueueDataManager:GetQueueDatasByType(NewQueueType.Science)
  for _, queueData in ipairs(queueDatas) do
    if queueData:GetQueueState() == NewQueueState.Work then
      local stamp = queueData.endTime
      local restSec = (queueData.endTime - serverTime) / 1000
      if restSec >= MIN_ALARM_TIME and stamp > self.nextSendTimeStamp and (not minStamp or minStamp > stamp) then
        minStamp = stamp
      end
    end
  end
  self:SetPushToWaitCall(PushId.ResearchDone, minStamp)
end

function PushNoticeManager:CalcMilitaryCampFullTimeSec()
  local minStamp
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local buildingDatas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  for _, buildingData in ipairs(buildingDatas) do
    local prodState = DataCenter.ProductLineManager:GetState(buildingData.uuid)
    if prodState == ProductLineState.Normal and buildingData.productEndTime then
      local stamp = buildingData.productEndTime
      local restSec = (buildingData.productEndTime - serverTime) / 1000
      if restSec >= MIN_ALARM_TIME and stamp > self.nextSendTimeStamp and (not minStamp or minStamp > stamp) then
        minStamp = stamp
      end
    end
  end
  self:SetPushToWaitCall(PushId.MilitaryCampFull, minStamp)
end

function PushNoticeManager:CalcCollectEndTimeSec()
  local minStamp
  local marchList = CS.SceneManager.MarchDataMgr:GetOwnerMarches()
  if marchList ~= nil then
    for _, march in pairs(marchList) do
      if march:GetMarchTargetType() == MarchTargetType.COLLECT and march:GetMarchStatus() == MarchStatus.COLLECTING then
        local stamp = march.endTime
        if stamp > self.nextSendTimeStamp and (not minStamp or minStamp > stamp) then
          minStamp = stamp
        end
      end
    end
  end
  self:SetPushToWaitCall(PushId.CollectEnd, minStamp)
end

function PushNoticeManager:CalcActLotteryOpenBigRewardTimeSec()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local minStamp
  local stamp = DataCenter.ActLotteryDataManager.pushNoticActIdTime
  if stamp and serverTime < stamp and stamp > self.nextSendTimeStamp then
    minStamp = stamp
  end
  self:SetPushToWaitCall(PushId.ActLotteryOpenReward, minStamp)
end

function PushNoticeManager:CalcPersonalArmyTimeSec()
  local minSeconds = LuaEntry.DataConfig:TryGetNum("person_arms_race", "k4", 1)
  if not minSeconds then
    return nil
  end
  local data = DataCenter.ActivityPersonalArmsDataManager:GetDataByType(125)
  if not data then
    return
  end
  if data.stage_end_time == nil then
    return
  end
  local serverSecTime = UITimeManager:GetInstance():GetServerSeconds()
  local stamp = data.stage_end_time * 1000
  local leftTime = data.stage_end_time - serverSecTime
  if leftTime < 0 then
    return nil
  end
  if minSeconds >= leftTime then
    leftTime = leftTime + PERSON_AMY_DELAYTIME
    stamp = stamp + PERSON_AMY_DELAYTIME * 1000
  end
  self:SetPushToWaitCall(PushId.PersonalArmyRace, stamp)
  if self.personalArmyTimer ~= nil then
    self.personalArmyTimer:Stop()
  end
  self.personalArmyTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.personalArmyTimer = nil
    self:TryPushNotice(PushId.PersonalArmyRace)
  end, leftTime)
end

return PushNoticeManager
