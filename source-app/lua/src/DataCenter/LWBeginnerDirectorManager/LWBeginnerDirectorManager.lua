local LWBeginnerDirectorManager = BaseClass("LWBeginnerDirectorManager")
local LWBeginnerDirectorChapterZombieSeaFristStage = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterZombieSeaFristStage")
local LWBeginnerDirectorChapterZombieSeaSecondStage = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterZombieSeaSecondStage")
local LWBeginnerDirectorChapterBigWorldKillZombieStage = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBigWorldKillZombieStage")
local LWBeginnerDirectorChapterUAVRepair = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterUAVRepair")
local LWBeginnerDirectorChapterCityFight = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterCityFight")
local LWBeginnerDirectorChapterCityFight2 = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterCityFight2")
local LWBeginnerDirectorChapterCityFight3 = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterCityFight3")
local beginnerEvents = {}

function LWBeginnerDirectorManager:__init()
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.OnEnable)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.OnDisable)
  EventManager:GetInstance():AddListener(EventId.CityEventFakePVPBattleDataGet, self.OnGetBattleData)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
  self.cityEventId = -1
  self.cityEventEndTime = 0
  self.cityEventTaskArr = {}
  self.cityEventPageState = {}
  self.curEventPageTaskArr = {}
  self.bossKill = {}
  self.ArmyNPCs = {}
  self.curEventPageTasksIds = {}
  self.curEventPageRewards = {}
end

function LWBeginnerDirectorManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.OnEnable)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.OnDisable)
  EventManager:GetInstance():RemoveListener(EventId.CityEventFakePVPBattleDataGet, self.OnGetBattleData)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  self:OnDisable()
  for cId, beginnerEvent in pairs(beginnerEvents) do
    beginnerEvent:Delete()
  end
  self.cityEventId = nil
  self.cityEventEndTime = nil
  self.cityEventTaskArr = nil
  self.cityEventPageState = nil
  self.curEventPageTaskArr = nil
  self.cityEventName = nil
  self.cityEventDesc = nil
  self.cityEvent = nil
  self.ArmyNPCs = nil
  self.bossKill = nil
  self.bossKillRecent = nil
  self.curEventPageTaskArr = nil
  self.curEventPageRewards = nil
  self.init = nil
  self.curEventPageTasksIds = nil
end

function LWBeginnerDirectorManager:StartUp()
end

function LWBeginnerDirectorManager.OnEnable()
  local self = DataCenter.LWBeginnerDirectorManager
  if self.active then
    return
  end
  self.active = true
  if self.cityEvent and not self.cityEvent.start and not self.cityEvent.overTime then
    self.cityEvent:Start()
  end
end

function LWBeginnerDirectorManager.OnDisable()
  local self = DataCenter.LWBeginnerDirectorManager
  self.active = false
  if self.cityEvent and self.cityEvent.start then
    self.cityEvent:Stop()
  end
end

function LWBeginnerDirectorManager.OnUpdate()
  local self = DataCenter.LWBeginnerDirectorManager
  local dt = Time.deltaTime
  if self.active and self.cityEvent and self.cityEvent.start then
    local lastFrameOverTime = self.cityEvent.overTime
    local curFrameOverTime = self:IsCityEventOverTime()
    self.cityEvent.overTime = curFrameOverTime
    self.cityEvent:OnUpdate(dt)
    if not lastFrameOverTime and curFrameOverTime then
      self.cityEvent:Stop()
    end
  end
end

function LWBeginnerDirectorManager:ReqToGetCityEvent()
  SFSNetwork.SendMessage(MsgDefines.LWBeginnerGetCityEvent)
end

function LWBeginnerDirectorManager:InitMsg(msg)
  self.init = true
  self:HandleBeginnerCityEvent(msg)
end

function LWBeginnerDirectorManager:HandleBeginnerCityEvent(msg)
  local cityEvent = msg.cityEvent
  if not cityEvent then
    return
  end
  local newEventId = cityEvent.eventId
  if not newEventId then
    return
  end
  if newEventId ~= self.cityEventId then
    if self.cityEvent and self.cityEvent.start then
      self.cityEvent:Stop()
    end
    self.ArmyNPCs = {}
    self.cityEventId = newEventId
    self.cityEvent = self:GetEvent(newEventId)
    if not self.cityEvent then
      return
    end
    local cityEventCfgArmyIds = GetTableData(TableName.CityEvent, self.cityEventId, "army_id")
    local cityEventCfgArmyModels = GetTableData(TableName.CityEvent, self.cityEventId, "monster_model")
    local cityEventCfgArmyPos = GetTableData(TableName.CityEvent, self.cityEventId, "monster_position")
    if not string.IsNullOrEmpty(cityEventCfgArmyIds) then
      local armyIdStrs = string.split(cityEventCfgArmyIds, "|")
      local armyModelStrs = string.split(cityEventCfgArmyModels, "|")
      local armyPosStrs = string.split(cityEventCfgArmyPos, "|")
      for i, armyIdStr in ipairs(armyIdStrs) do
        local armyId = tonumber(armyIdStr)
        local model = armyModelStrs[i]
        local pos = string.split(armyPosStrs[i], ",")
        local posX = tonumber(pos[1])
        local posY = tonumber(pos[2])
        table.insert(self.ArmyNPCs, {
          armyId = armyId,
          model = model,
          pos = {x = posX, y = posY}
        })
      end
    end
    self.curEventPageTasksIds = {}
    local pageTasks = GetTableData(TableName.CityEvent, self.cityEventId, "stage_quest")
    if not string.IsNullOrEmpty(pageTasks) then
      local pageStr = string.split(pageTasks, ",")
      for i = 1, #pageStr do
        local tasks = {}
        local tasksStr = pageStr[i]
        if not string.IsNullOrEmpty(tasksStr) then
          local taskStrs = string.split(tasksStr, "|")
          for j = 1, #taskStrs do
            local taskStr = taskStrs[j]
            table.insert(tasks, tonumber(taskStr))
          end
        end
        table.insert(self.curEventPageTasksIds, tasks)
      end
    end
    self.cityEventName = GetTableData(TableName.CityEvent, self.cityEventId, "event_name") or ""
    self.cityEventDesc = GetTableData(TableName.CityEvent, self.cityEventId, "event_desc") or ""
    self.cityEventUIPopSound = GetTableData(TableName.CityEvent, self.cityEventId, "sound_ui_popup") or 0
    self.cityEventUIWarningSound = GetTableData(TableName.CityEvent, self.cityEventId, "sound_ui_progress") or 0
    self.cityEventEndTime = cityEvent.endTime or 0
    self.cityEvent.overTime = self:IsCityEventOverTime()
    if self.active and not self.cityEvent.overTime then
      self.cityEvent:Start()
    end
  end
  self.cityEventTaskArr = cityEvent.taskArr or {}
  self.curEventPageTaskArr = {}
  for i, pageTasks in ipairs(self.curEventPageTasksIds) do
    local pageTaskArry = {}
    for j, pageTaskId in ipairs(pageTasks) do
      for k, taskData in ipairs(self.cityEventTaskArr) do
        if taskData.taskId == pageTaskId then
          table.insert(pageTaskArry, taskData)
          break
        end
      end
    end
    table.insert(self.curEventPageTaskArr, pageTaskArry)
  end
  self.cityEventPageState = {}
  if cityEvent.pageState then
    for i, state in pairs(cityEvent.pageState) do
      self.cityEventPageState[tonumber(i) + 1] = state
    end
  end
  self.bossKill = {}
  if cityEvent.bossKill then
    for i, state in pairs(cityEvent.bossKill) do
      self.bossKill[tonumber(i) + 1] = state
    end
  end
  self.bossKillRecent = {}
  self.curEventPageRewards = {}
  if cityEvent.pageReward then
    for i, reward in ipairs(cityEvent.pageReward) do
      local rewardItems = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
      table.insert(self.curEventPageRewards, rewardItems)
    end
  end
  if self.cityEvent then
    self.cityEvent.taskAllReceived = self:CheckAllTaskReceived()
    self.cityEvent:UpdateArmyNpcState(self.bossKill)
  end
  EventManager:GetInstance():Broadcast(EventId.CityEventRefresh)
end

function LWBeginnerDirectorManager:IsCityEventOverTime()
  if not self.cityEvent then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.cityEventEndTime - curTime
  local overTime = remainTime <= 0
  return overTime
end

function LWBeginnerDirectorManager:UpdateCityEventTasks(msg)
  local updatedEventId = msg.eventId
  if not updatedEventId or updatedEventId ~= self.cityEventId then
    return
  end
  self.cityEventTaskArr = msg.taskArr or {}
  self.curEventPageTaskArr = {}
  for i, pageTasks in ipairs(self.curEventPageTasksIds) do
    local pageTaskArry = {}
    for j, pageTaskId in ipairs(pageTasks) do
      for k, taskData in ipairs(self.cityEventTaskArr) do
        if taskData.taskId == pageTaskId then
          table.insert(pageTaskArry, taskData)
          break
        end
      end
    end
    table.insert(self.curEventPageTaskArr, pageTaskArry)
  end
  if self.cityEvent then
    self.cityEvent.taskAllReceived = self:CheckAllTaskReceived()
  end
  EventManager:GetInstance():Broadcast(EventId.CityEventTaskUpdate)
end

function LWBeginnerDirectorManager:UpdateRewardedTask(msg)
  local updatedEventId = msg.eventId
  if not updatedEventId or updatedEventId ~= self.cityEventId then
    return
  end
  local t = msg.reward
  if t then
    DataCenter.RewardManager:ShowCommonReward(msg)
    DataCenter.RewardManager:AddRewardsAndRes(msg)
  end
  for i, task in pairs(self.cityEventTaskArr) do
    if task.taskId == msg.taskId then
      task.state = TaskState.Received
      break
    end
  end
  if self.cityEvent then
    self.cityEvent.taskAllReceived = self:CheckAllTaskReceived()
  end
  EventManager:GetInstance():Broadcast(EventId.CityEventTaskUpdate)
end

function LWBeginnerDirectorManager:UpdateRewardedPage(msg)
  local updatedEventId = msg.eventId
  if not updatedEventId or updatedEventId ~= self.cityEventId then
    return
  end
  local t = msg.reward
  if t then
    DataCenter.RewardManager:ShowCommonReward(msg)
    DataCenter.RewardManager:AddRewardsAndRes(msg)
  end
  self.cityEventPageState[msg.page + 1] = 1
  EventManager:GetInstance():Broadcast(EventId.CityEventPageUpdate)
end

function LWBeginnerDirectorManager:CheckAllTaskReceived()
  for i, task in pairs(self.cityEventTaskArr) do
    if task.state ~= TaskState.Received then
      return false
    end
  end
  return true
end

function LWBeginnerDirectorManager:CityEventIsOpen()
  local server = LuaEntry.Player:GetSourceServerId()
  local serverArray = ""
  if CS.CommonUtils.IsDebug() then
    serverArray = LuaEntry.DataConfig:TryGetStr("city_event_server", "k1")
  else
    serverArray = LuaEntry.DataConfig:TryGetStr("city_event_server", "k2")
  end
  if not string.IsNullOrEmpty(serverArray) then
    local array = string.split(serverArray, "|")
    for _, arr in ipairs(array) do
      local list = string.split(arr, "-")
      if #list == 2 then
        local startServer = tonumber(list[1])
        local endServer = tonumber(list[2])
        if startServer <= endServer and server >= startServer and server <= endServer then
          return true
        end
      elseif #list == 1 then
        local se = tonumber(list[1]) or 0
        if 0 < se and se == server then
          return true
        end
      end
    end
  end
  return false
end

function LWBeginnerDirectorManager:GetCurCityEventID()
  return self.cityEventId
end

function LWBeginnerDirectorManager:GetCurCityEvent()
  return self.cityEvent
end

function LWBeginnerDirectorManager:GetCurCityEventName()
  return self.cityEventName
end

function LWBeginnerDirectorManager:GetCurCityEventUIPopSound()
  return self.cityEventUIPopSound
end

function LWBeginnerDirectorManager:GetCurCityEventUIWarningSound()
  return self.cityEventUIWarningSound
end

function LWBeginnerDirectorManager:GetCurCityEventDesc()
  return self.cityEventDesc
end

function LWBeginnerDirectorManager:GetCurCityEventEndTime()
  return self.cityEventEndTime
end

function LWBeginnerDirectorManager:GetCurCityEventTaskArr()
  return self.cityEventTaskArr
end

function LWBeginnerDirectorManager:GetCurCityEventPages()
  return self.cityEventPageState
end

function LWBeginnerDirectorManager:GetCurCityEventPageRewards()
  return self.curEventPageRewards
end

function LWBeginnerDirectorManager:GetCurCityEventPageTasks()
  return self.curEventPageTaskArr
end

function LWBeginnerDirectorManager:GetCurCityEventPageTaskIds()
  return self.curEventPageTasksIds
end

function LWBeginnerDirectorManager:IsCurCityEventAllTaskReceived()
  if not self.cityEvent then
    return true
  end
  return self.cityEvent.taskAllReceived
end

function LWBeginnerDirectorManager.OnGetBattleData(msg)
  if not msg then
    return
  end
  local self = DataCenter.LWBeginnerDirectorManager
  if self.bossKill and msg.bossIndex and msg.isWin then
    local reIndex = msg.bossIndex + 1
    self.bossKill[reIndex] = 1
    self.bossKillRecent[reIndex] = 1
  end
  self.cityEvent:UpdateArmyNpcState(self.bossKill)
end

function LWBeginnerDirectorManager:GetEvent(eventId)
  local beginnerEvent = beginnerEvents[eventId]
  if beginnerEvent then
    return beginnerEvent
  end
  if eventId == BeginnerDirectorEvent.UAV_Repaire then
    beginnerEvent = LWBeginnerDirectorChapterUAVRepair.New()
  elseif eventId == BeginnerDirectorEvent.ZombieSeaFirstStage then
    beginnerEvent = LWBeginnerDirectorChapterZombieSeaFristStage.New()
  elseif eventId == BeginnerDirectorEvent.ZombieSeaSecondStage then
    beginnerEvent = LWBeginnerDirectorChapterZombieSeaSecondStage.New()
  elseif eventId == BeginnerDirectorEvent.BigWorldKillZombie then
    beginnerEvent = LWBeginnerDirectorChapterBigWorldKillZombieStage.New()
  elseif eventId == BeginnerDirectorEvent.BigWorldKillZombie then
    beginnerEvent = LWBeginnerDirectorChapterBigWorldKillZombieStage.New()
  elseif eventId == BeginnerDirectorEvent.CityFight then
    beginnerEvent = LWBeginnerDirectorChapterCityFight.New()
  elseif eventId == BeginnerDirectorEvent.CityFight2 then
    beginnerEvent = LWBeginnerDirectorChapterCityFight2.New()
  elseif eventId == BeginnerDirectorEvent.CityFight3 then
    beginnerEvent = LWBeginnerDirectorChapterCityFight3.New()
  end
  if beginnerEvent then
    beginnerEvents[eventId] = beginnerEvent
  end
  return beginnerEvent
end

return LWBeginnerDirectorManager
