local BloodyNightDataManager = BaseClass("BloodyNightDataManager")
local BloodyNightTemplate = require("DataCenter.BloodyNight.BloodyNightTemplate")
local BloodyNightStageTemplate = require("DataCenter.BloodyNight.BloodyNightStageTemplate")
local BloodyNightData = require("DataCenter.BloodyNight.BloodyNightData")

function BloodyNightDataManager:__init()
  self.achievementList = {}
  self.dailyTaskList = {}
  self.rankData = {}
  self.templateDic = {}
  self.flag2stageTemplateList = {}
  self.dataDic = {}
  self:InitSourceAndSelfServerData()
  self.loginServerInit = false
  self:AddListener()
end

function BloodyNightDataManager:__delete()
  self:Destroy()
end

function BloodyNightDataManager:Destroy()
  self:RemoveListener()
  self.achievementList = nil
  self.dailyTaskList = nil
  self.templateDic = nil
  self.flag2stageTemplateList = nil
  for k, v in pairs(self.dataDic) do
    v:Delete()
  end
  self.dataDic = nil
  self.loginServerInit = nil
end

function BloodyNightDataManager:InitSourceAndSelfServerData()
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  if sourceServerId == -1 or sourceServerId == nil then
    return
  end
  if self.dataDic[sourceServerId] then
    self.dataDic[sourceServerId]:FetchActivityData()
  else
    self.dataDic[sourceServerId] = BloodyNightData.New(sourceServerId)
  end
  self:AddOrPullBloodyData(LuaEntry.Player:GetSelfServerId())
end

function BloodyNightDataManager:AddListener()
  if not self.setEventListener then
    self.setEventListener = true
    EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
  end
end

function BloodyNightDataManager:RemoveListener()
  if self.setEventListener then
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    self.setEventListener = false
  end
end

function BloodyNightDataManager:OnEnterCrossServer()
  DataCenter.BloodyNightDataManager:AddOrPullBloodyData(LuaEntry.Player:GetCurServerId(), true)
end

function BloodyNightDataManager:AddBloodyData(serverId)
  if serverId == nil or serverId <= 0 then
    return
  end
  if not self.dataDic[serverId] then
    if SeasonUtil.IsInSameGroup(serverId) then
      local sourceServerId = LuaEntry.Player:GetSourceServerId()
      if not self.dataDic[sourceServerId] then
        self.dataDic[sourceServerId] = BloodyNightData.New(sourceServerId)
      end
      self.dataDic[serverId] = self.dataDic[sourceServerId]
      self.dataDic[serverId]:AddServer(serverId)
    else
      self.dataDic[serverId] = BloodyNightData.New(serverId)
    end
    return self.dataDic[serverId]
  end
end

function BloodyNightDataManager:AddOrPullBloodyData(serverId, force)
  if serverId == nil or serverId <= 0 then
    return
  end
  if self.dataDic[serverId] then
    self.dataDic[serverId]:FetchActivityData(force)
  else
    self:AddBloodyData(serverId)
  end
end

function BloodyNightDataManager:GetStageTemplateListByFlag(flag)
  if not self.flag2stageTemplateList[flag] then
    self.flag2stageTemplateList[flag] = {}
    LocalController:instance():visitTable(TableName.LW_Season_Blood_Night_Plan, function(id, lineData)
      if lineData and flag == lineData:getValue("flag") then
        local template = BloodyNightStageTemplate.New()
        template:InitConfig(lineData)
        table.insert(self.flag2stageTemplateList[flag], template)
      end
    end)
    table.sort(self.flag2stageTemplateList[flag], function(a, b)
      return a.stage < b.stage
    end)
  end
  return self.flag2stageTemplateList[flag]
end

function BloodyNightDataManager:GetTemplate(id)
  if self.templateDic[id] then
    return self.templateDic[id]
  end
  local line = LocalController:instance():getLine(TableName.LW_Season_Blood_Night, id)
  if line then
    local template = BloodyNightTemplate.New()
    template:InitConfig(line)
    self.templateDic[id] = template
    return template
  end
end

function BloodyNightDataManager:InitActivityData()
  self:InitSourceAndSelfServerData()
end

function BloodyNightDataManager:HandleActivityData(msg)
  local serverId = msg.serverId
  if self.dataDic[serverId] then
    self.dataDic[serverId]:HandleActivityData(msg)
  else
    local data = DataCenter.BloodyNightDataManager:AddBloodyData(serverId)
    if data then
      data:HandleActivityData(msg)
    else
      Logger.LogError("BloodyNightDataManager:HandleActivityData() is nil" .. serverId)
    end
  end
  if serverId == LuaEntry.Player:GetSourceServerId() then
    self:FetchTaskList()
  end
end

function BloodyNightDataManager:HandleNightStalkerUltimate(msg)
  local selfServer = LuaEntry.Player:GetSelfServerId()
  if self.dataDic[selfServer] then
    self.dataDic[selfServer]:HandleNightStalkerUltimate(msg)
  else
    Logger.LogError("BloodyNightDataManager:HandleNightStalkerUltimate() is nil" .. selfServer)
  end
end

function BloodyNightDataManager:HandlePushBloodNightClose(serverId)
  if self.dataDic[serverId] then
    self.dataDic[serverId]:HandlePushBloodNightClose()
  else
    Logger.LogError("BloodyNightDataManager:HandlePushBloodNightClose() is nil" .. serverId)
  end
end

function BloodyNightDataManager:HandleSaintMountainProgress(msg)
  local serverId = msg.serverId
  if self.dataDic[serverId] then
    self.dataDic[serverId]:HandleSaintMountainProgress(msg.closeNightScore)
  else
    Logger.LogError("BloodyNightDataManager:HandleActivityData() is nil" .. serverId)
  end
end

function BloodyNightDataManager:GetSaintMountainProgress(serverId)
  if self.dataDic[serverId] then
    return self.dataDic[serverId]:GetSaintMountainProgress()
  else
    Logger.LogError("BloodyNightDataManager:GetSaintMountainProgress() is nil" .. serverId)
    return 0, 1
  end
end

function BloodyNightDataManager:GetStageTemplate(serverId)
  if self.dataDic[serverId] then
    return self.dataDic[serverId]:GetStageTemplate()
  else
    Logger.LogError("BloodyNightDataManager:GetStageTemplate() is nil" .. serverId)
  end
end

function BloodyNightDataManager:GetStageRankCfgIdList()
  local stageCfg = self:GetStageTemplate(LuaEntry.Player:GetSourceServerId())
  return stageCfg and stageCfg.rank_id
end

function BloodyNightDataManager:GetStageEndTime()
  local serverId = LuaEntry.Player:GetSelfServerId()
  if self.dataDic[serverId] then
    return self.dataDic[serverId]:GetStageEndTime()
  else
    Logger.LogError("BloodyNightDataManager:GetStageEndTime() is nil" .. serverId)
  end
end

function BloodyNightDataManager:IsSunrise(serverId)
  return self:IsDawn(serverId)
end

function BloodyNightDataManager:GetBloodyNightState()
  local serverId = LuaEntry.Player:GetSelfServerId()
  if self.dataDic[serverId] then
    return self.dataDic[serverId]:GetBloodyNightState()
  else
    self:InitSourceAndSelfServerData()
  end
end

function BloodyNightDataManager:IsBloodyNight(serverId)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType ~= SeasonMapType.Darkness then
    return false
  end
  if self.dataDic == nil then
    return false
  end
  serverId = serverId or LuaEntry.Player:GetSelfServerId()
  if self.dataDic[serverId] then
    return self.dataDic[serverId]:IsBloodyNight()
  else
    local data = DataCenter.BloodyNightDataManager:AddBloodyData(serverId)
    return data and data:IsBloodyNight()
  end
end

function BloodyNightDataManager:IsDawn(serverId)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType ~= SeasonMapType.Darkness then
    return true
  end
  if self.dataDic == nil then
    return true
  end
  serverId = serverId or LuaEntry.Player:GetSelfServerId()
  if self.dataDic[serverId] then
    return self.dataDic[serverId]:GetBloodyNightState() == BloodyNightState.None
  else
    local data = DataCenter.BloodyNightDataManager:AddBloodyData(serverId)
    return data ~= nil and data:GetBloodyNightState() == BloodyNightState.None
  end
end

function BloodyNightDataManager:FetchTaskList()
  local stageTemp = self:GetStageTemplate(LuaEntry.Player:GetSourceServerId())
  if stageTemp then
    SFSNetwork.SendMessage(MsgDefines.ViewBloodNightTask, stageTemp.id)
  end
end

function BloodyNightDataManager:HandleTaskList(msg)
  self.achievementList = {}
  self.dailyTaskList = {}
  if msg.userBloodNightTaskArr then
    for _, v in ipairs(msg.userBloodNightTaskArr) do
      if v.dayTime > 0 then
        table.insert(self.dailyTaskList, v)
      else
        table.insert(self.achievementList, v)
      end
    end
  end
  if msg.allianceBloodNightTaskArr then
    for _, v in ipairs(msg.allianceBloodNightTaskArr) do
      if v.dayTime > 0 then
        table.insert(self.dailyTaskList, v)
      else
        table.insert(self.achievementList, v)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.BloodyNightTaskRefresh)
  EventManager:GetInstance():Broadcast(EventId.OnBloodyNightTaskRedRefresh)
end

function BloodyNightDataManager:OnPushTask(msg)
  if table.IsNullOrEmpty(msg) then
    return
  end
  for _, newData in pairs(msg) do
    local taskId = newData.taskId
    local found = false
    for _, v in pairs(self.achievementList) do
      if v.taskId == taskId then
        v.num = newData.num
        v.state = newData.state
        EventManager:GetInstance():Broadcast(EventId.BloodyNightClaimReward, taskId)
        EventManager:GetInstance():Broadcast(EventId.OnBloodyNightTaskRedRefresh)
        found = true
        break
      end
    end
    if not found then
      for _, v in pairs(self.dailyTaskList) do
        if v.taskId == taskId then
          v.num = newData.num
          v.state = newData.state
          EventManager:GetInstance():Broadcast(EventId.BloodyNightClaimReward, taskId)
          EventManager:GetInstance():Broadcast(EventId.OnBloodyNightTaskRedRefresh)
          break
        end
      end
    end
  end
end

function BloodyNightDataManager:ClaimReward(taskId)
  local stageTemp = self:GetStageTemplate(LuaEntry.Player:GetSourceServerId())
  if stageTemp then
    SFSNetwork.SendMessage(MsgDefines.BloodNightTaskGetReward, stageTemp.id, taskId)
  end
end

function BloodyNightDataManager:HandleTaskClaimReward(msg)
  local taskId
  if msg.userBloodNightTaskInfo then
    taskId = msg.userBloodNightTaskInfo.taskId
  elseif msg.allianceBloodNightTaskInfo then
    taskId = msg.allianceBloodNightTaskInfo.taskId
  end
  if not taskId then
    return
  end
  DataCenter.RewardManager:AddRewards(msg.reward)
  DataCenter.RewardManager:ShowCommonReward(msg)
  for _, v in pairs(self.achievementList) do
    if v.taskId == taskId then
      v.state = 2
      EventManager:GetInstance():Broadcast(EventId.BloodyNightClaimReward, taskId)
      EventManager:GetInstance():Broadcast(EventId.OnBloodyNightTaskRedRefresh)
      return
    end
  end
  for _, v in pairs(self.dailyTaskList) do
    if v.taskId == taskId then
      v.state = 2
      EventManager:GetInstance():Broadcast(EventId.BloodyNightClaimReward, taskId)
      EventManager:GetInstance():Broadcast(EventId.OnBloodyNightTaskRedRefresh)
      return
    end
  end
end

function BloodyNightDataManager:GetTaskList(taskType)
  if taskType == BloodyNightTaskType.Achievement then
    return self.achievementList
  else
    return self.dailyTaskList
  end
end

function BloodyNightDataManager:GetCanReceive(taskType)
  if taskType == nil then
    for _, v in pairs(self.achievementList) do
      if v.state == 1 then
        return true
      end
    end
    for _, v in pairs(self.dailyTaskList) do
      if v.state == 1 then
        return true
      end
    end
  elseif taskType == BloodyNightTaskType.Achievement then
    for _, v in pairs(self.achievementList) do
      if v.state == 1 then
        return true
      end
    end
  elseif taskType == BloodyNightTaskType.DailyTask then
    for _, v in pairs(self.dailyTaskList) do
      if v.state == 1 then
        return true
      end
    end
  end
  return false
end

function BloodyNightDataManager:GetFirstSeenRedPoint()
  return false
end

function BloodyNightDataManager:IsTodayTaskClear()
  for _, v in pairs(self.dailyTaskList) do
    if v.state ~= 2 then
      return false
    end
  end
  return true
end

function BloodyNightDataManager:FetchRankData(rankId)
  local stageTemp = self:GetStageTemplate(LuaEntry.Player:GetSourceServerId())
  if stageTemp then
    SFSNetwork.SendMessage(MsgDefines.BloodNightRankView, stageTemp.id, rankId)
  end
end

function BloodyNightDataManager:HandleRankMessage(msg)
  if msg.rankId then
    self.rankData[msg.rankId] = msg
    EventManager:GetInstance():Broadcast(EventId.BloodyNightRankRefresh, msg.rankId)
  end
end

function BloodyNightDataManager:GetRankData(rankId)
  return self.rankData[rankId]
end

function BloodyNightDataManager:GetLoginServerInitMark()
  return self.loginServerInit
end

function BloodyNightDataManager:SetLoginSeverInitMark(value)
  self.loginServerInit = value
end

return BloodyNightDataManager
