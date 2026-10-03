local AllianceTaskManager = BaseClass("AllianceTaskManager")

local function __init(self)
  self.taskConfList = nil
  self.curTaskList = nil
  self.taskInfoDic = {}
  self:AddListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function __delete(self)
  self.taskConfList = nil
  self.taskInfoDic = nil
  self.curTaskList = nil
  self:RemoveListener()
end

local function RequestTaskInfo(self)
  if LuaEntry.DataConfig:CheckSwitch("alliance_task") then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceTaskInfo, false)
  end
end

local function InitTaskConfList(self)
  self.taskConfList = {}
  LocalController:instance():visitTable(TableName.AllianceTask, function(id, lineData)
    local newOne = AllianceTaskTemplate.New()
    newOne:InitData(lineData)
    if newOne.season_group == nil or newOne.season_group == 0 then
      table.insert(self.taskConfList, newOne)
    end
  end)
end

local function GetTaskList(self)
  if not self.taskConfList or #self.taskConfList == 0 then
    self:InitTaskConfList()
  end
  if not self.curTaskList or #self.curTaskList == 0 then
    self.curTaskList = {}
    for i, v in ipairs(self.taskConfList) do
      if self.taskInfoDic[v.id] then
        table.insert(self.curTaskList, v)
      end
    end
  end
  local targetTb = {}
  for i, v in ipairs(self.curTaskList) do
    local taskInfo = self.taskInfoDic[v.id]
    if taskInfo then
      if taskInfo:CheckIfCanClaim() and not targetTb[1] then
        targetTb[1] = v
      else
        local status = taskInfo:GetTaskStatus()
        if status == 2 then
          if not targetTb[2] then
            targetTb[2] = v
          end
        elseif status == 1 then
          if targetTb[3] then
            if taskInfo.startTime < self.taskInfoDic[targetTb[3].id].startTime then
              targetTb[3] = v
            end
          else
            targetTb[3] = v
          end
        end
      end
    end
  end
  table.sort(self.curTaskList, function(a, b)
    local timeA = self.taskInfoDic[a.id].startTime
    local timeB = self.taskInfoDic[b.id].startTime
    if timeA ~= timeB then
      return timeA < timeB
    else
      return a.id < b.id
    end
  end)
  local targetIndex = 1
  if 0 < #self.curTaskList then
    local targetId = self.curTaskList[1].id
    for i = 1, 3 do
      if targetTb[i] then
        targetId = targetTb[i].id
        break
      end
    end
    for i, v in ipairs(self.curTaskList) do
      if v.id == targetId then
        targetIndex = i
        break
      end
    end
  end
  targetIndex = math.min(#self.curTaskList - 2, targetIndex)
  targetIndex = math.max(targetIndex, 1)
  return self.curTaskList, targetIndex
end

local function GetTaskIndex(self, taskId)
  if not self.taskConfList or #self.taskConfList == 0 then
    self:InitTaskConfList()
  end
  if not self.curTaskList or #self.curTaskList == 0 then
    self.curTaskList = {}
    for i, v in ipairs(self.taskConfList) do
      if self.taskInfoDic[v.id] then
        table.insert(self.curTaskList, v)
      end
    end
  end
  for i, v in ipairs(self.curTaskList) do
    if v.id == taskId then
      return i
    end
  end
end

local function GetTaskInfo(self, taskId)
  return self.taskInfoDic[taskId]
end

local function UpdateOneAllianceTask(self, t)
  if self.taskInfoDic[t.taskId] then
    self.taskInfoDic:ParseData(t)
  else
    local newOne = AllianceTaskData.New()
    newOne:ParseData(t)
    self.taskInfoDic[newOne.taskId] = newOne
  end
  EventManager:GetInstance():Broadcast(EventId.OnUpdateAllianceTask, t.taskId)
end

local function UpdateAllianceTaskInfoDic(self, t)
  if t.taskList then
    self.taskInfoDic = {}
    for i, v in ipairs(t.taskList) do
      local newOne = AllianceTaskData.New()
      newOne:ParseData(v)
      self.taskInfoDic[newOne.taskId] = newOne
    end
    EventManager:GetInstance():Broadcast(EventId.OnUpdateAllianceTask)
  end
  self:UpdateNextUnlockTime()
end

local function SetTaskClaimed(self, taskId)
  if not self.taskInfoDic[taskId] then
    return
  end
  self.taskInfoDic[taskId]:SetTaskClaimed()
end

local function CheckIfAllianceTaskOpen(self)
  if not LuaEntry.DataConfig:CheckSwitch("alliance_task") then
    return false
  end
  local alliance = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if alliance and alliance.allianceTaskEndTime > 0 and serverTime < alliance.allianceTaskEndTime then
    local taskEndTs = 0
    for i, v in pairs(self.taskInfoDic) do
      if taskEndTs < v.endTime then
        taskEndTs = v.endTime
      end
    end
    if serverTime >= taskEndTs then
      return true, alliance.allianceTaskEndTime, true
    else
      return true, taskEndTs, false
    end
  else
    return false
  end
end

local function GetTaskRedCount(self)
  local unclaimedNum = 0
  local unlockedNum = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i, v in pairs(self.taskInfoDic) do
    if v:CheckIfCanClaim() then
      unclaimedNum = unclaimedNum + 1
    end
    if curTime > v.startTime then
      unlockedNum = unlockedNum + 1
    end
  end
  local strKey = "AllianceTaskCheckedNum_" .. LuaEntry.Player.uid
  local oldUnlockNum = CS.GameEntry.Setting:GetInt(strKey, 0)
  local newTaskNum = 0 < unlockedNum - oldUnlockNum and 1 or 0
  return unclaimedNum + newTaskNum
end

local function ResetOldTaskNum(self)
  local strKey = "AllianceTaskCheckedNum_" .. LuaEntry.Player.uid
  local unlockedNum = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i, v in pairs(self.taskInfoDic) do
    if curTime > v.startTime then
      unlockedNum = unlockedNum + 1
    end
  end
  CS.GameEntry.Setting:SetInt(strKey, unlockedNum)
  EventManager:GetInstance():Broadcast(EventId.OnAllianceTaskRedChange)
  self:UpdateNextUnlockTime()
end

local function UpdateNextUnlockTime(self)
  if self.redTimer then
    self.redTimer:Stop()
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local taskList = self:GetTaskList()
  local nextUnlock = 0
  for i, v in ipairs(taskList) do
    local tInfo = self:GetTaskInfo(v.id)
    if curTime < tInfo.startTime then
      nextUnlock = tInfo.startTime
      break
    end
  end
  if 0 < nextUnlock then
    local delayT = math.modf((nextUnlock - curTime) / 1000) + 10
    self.redTimer = TimerManager:GetInstance():DelayInvoke(function()
      EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
      self:UpdateNextUnlockTime()
    end, delayT)
  end
end

local function GetTaskConfByFuncType(self, tempType)
  local taskList = self:GetTaskList()
  local conf, tempIndex
  for i, v in ipairs(taskList) do
    if v.func == tempType then
      conf = v
      tempIndex = i
      break
    end
  end
  if not conf then
    for i, v in ipairs(self.taskConfList) do
      if v.func == tempType then
        conf = v
      end
    end
  end
  return conf, tempIndex
end

local function OnLeaveAlliance(self)
  self.curTaskList = nil
  self.taskInfoDic = {}
end

AllianceTaskManager.__init = __init
AllianceTaskManager.AddListener = AddListener
AllianceTaskManager.RemoveListener = RemoveListener
AllianceTaskManager.__delete = __delete
AllianceTaskManager.RequestTaskInfo = RequestTaskInfo
AllianceTaskManager.InitTaskConfList = InitTaskConfList
AllianceTaskManager.SetTaskClaimed = SetTaskClaimed
AllianceTaskManager.GetTaskList = GetTaskList
AllianceTaskManager.UpdateAllianceTaskInfoDic = UpdateAllianceTaskInfoDic
AllianceTaskManager.UpdateOneAllianceTask = UpdateOneAllianceTask
AllianceTaskManager.GetTaskInfo = GetTaskInfo
AllianceTaskManager.CheckIfAllianceTaskOpen = CheckIfAllianceTaskOpen
AllianceTaskManager.GetTaskRedCount = GetTaskRedCount
AllianceTaskManager.ResetOldTaskNum = ResetOldTaskNum
AllianceTaskManager.GetTaskConfByFuncType = GetTaskConfByFuncType
AllianceTaskManager.GetTaskIndex = GetTaskIndex
AllianceTaskManager.UpdateNextUnlockTime = UpdateNextUnlockTime
AllianceTaskManager.OnLeaveAlliance = OnLeaveAlliance
return AllianceTaskManager
