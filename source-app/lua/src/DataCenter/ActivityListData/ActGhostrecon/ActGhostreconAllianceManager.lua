local ActGhostreconAllianceManager = BaseClass("ActGhostreconAllianceManager", CEventable)
local ActGhostreconAllianceTaskInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconAllianceTaskInfo")

local function __init(self)
  self.allianceTaskList = nil
  self:AddListener()
end

local function __delete(self)
  self.allianceTaskList = nil
end

local function AddListener(self)
  self:RegisterEvent(EventId.AllianceBaseDataUpdated, self.OnAllianceChange)
end

local function GhostReconGetAllianceTaskList(self, msg)
  if msg == nil then
    return
  end
  if msg.taskList then
    self.allianceTaskList = {}
    for index, value in ipairs(msg.taskList) do
      if value.uuid then
        local taskInfo = ActGhostreconAllianceTaskInfo.New()
        taskInfo:ParseData(value)
        table.insert(self.allianceTaskList, taskInfo)
      end
    end
  else
    self.allianceTaskList = nil
  end
  self:SortTaskList()
  EventManager:GetInstance():Broadcast(EventId.GhostreconAllianceTaskRefresh)
  EventManager:GetInstance():Broadcast(EventId.GhostreconAllianceTaskRefreshRed)
end

local function GetAllianceTaskInfoByUUid(self, uuid)
  local taskInfo
  if self.allianceTaskList then
    for index, value in ipairs(self.allianceTaskList) do
      if value.uuid == uuid then
        taskInfo = value
        break
      end
    end
  end
  return taskInfo
end

local function GetAllianceTaskIndexByUUid(self, uuid)
  local taskIndex
  if self.allianceTaskList then
    for index, value in ipairs(self.allianceTaskList) do
      if value.uuid == uuid then
        taskIndex = index
        break
      end
    end
  end
  return taskIndex
end

local function PushGhostReconAllianceSingleHandler(self, msg)
  if msg == nil or msg.info and msg.info.ownerId == LuaEntry.Player.uid or DataCenter.ActivityListDataManager:GetGhostreconData() == nil then
    return
  end
  if self.allianceTaskList == nil then
    self.allianceTaskList = {}
  end
  local type = msg.type
  local needBroad = true
  if msg.info and msg.info.uuid then
    local uuid = msg.info.uuid
    if type == "add" and self:GetAllianceTaskIndexByUUid(uuid) == nil then
      local taskInfo = ActGhostreconAllianceTaskInfo.New()
      taskInfo:ParseData(msg.info)
      table.insert(self.allianceTaskList, taskInfo)
    elseif type == "change" then
      local taskInfo = self:GetAllianceTaskInfoByUUid(uuid)
      if taskInfo then
        taskInfo:ParseData(msg.info)
      end
    end
  elseif type == "remove" then
    local index = self:GetAllianceTaskIndexByUUid(msg.uuid)
    if index then
      table.remove(self.allianceTaskList, index)
    end
  end
  self:SortTaskList()
  if needBroad then
    EventManager:GetInstance():Broadcast(EventId.GhostreconAllianceTaskRefresh)
  end
  EventManager:GetInstance():Broadcast(EventId.GhostreconAllianceTaskRefreshRed)
end

local function PushGhostReconBeKickedHandler(self, msg)
  if msg == nil then
    return
  end
  local index = self:GetAllianceTaskIndexByUUid(msg.uuid)
  if index then
    table.remove(self.allianceTaskList, index)
  end
  self:SortTaskList()
  EventManager:GetInstance():Broadcast(EventId.GhostreconAllianceTaskRefresh)
  EventManager:GetInstance():Broadcast(EventId.GhostreconAllianceTaskRefreshRed)
end

local function SortTaskList(self)
  if self.allianceTaskList and #self.allianceTaskList > 0 then
    table.sort(self.allianceTaskList, function(a, b)
      if a:OwnIsJoined() ~= b:OwnIsJoined() then
        return a:OwnIsJoined()
      end
      local cfgA = DataCenter.ActGhostreconManager:GetTaskTemplate(a.cfgId)
      local cfgB = DataCenter.ActGhostreconManager:GetTaskTemplate(b.cfgId)
      if cfgA.color ~= cfgB.color then
        return cfgA.color > cfgB.color
      end
      return a.teamStartTime > b.teamStartTime
    end)
  end
end

local function OnAllianceChange(self)
  local actData = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
  if actData and 0 < #actData then
    SFSNetwork.SendMessage(MsgDefines.GhostReconGetAllianceTaskList)
  end
end

ActGhostreconAllianceManager.__init = __init
ActGhostreconAllianceManager.__delete = __delete
ActGhostreconAllianceManager.AddListener = AddListener
ActGhostreconAllianceManager.GhostReconGetAllianceTaskList = GhostReconGetAllianceTaskList
ActGhostreconAllianceManager.GetAllianceTaskInfoByUUid = GetAllianceTaskInfoByUUid
ActGhostreconAllianceManager.GetAllianceTaskIndexByUUid = GetAllianceTaskIndexByUUid
ActGhostreconAllianceManager.PushGhostReconAllianceSingleHandler = PushGhostReconAllianceSingleHandler
ActGhostreconAllianceManager.PushGhostReconBeKickedHandler = PushGhostReconBeKickedHandler
ActGhostreconAllianceManager.SortTaskList = SortTaskList
ActGhostreconAllianceManager.OnAllianceChange = OnAllianceChange
return ActGhostreconAllianceManager
