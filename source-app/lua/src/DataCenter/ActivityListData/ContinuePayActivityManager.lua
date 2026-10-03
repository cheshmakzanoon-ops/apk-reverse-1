local ContinuePayActivityManager = BaseClass("ContinuePayActivityManager")
local ActContinuePayBoxData = require("DataCenter.ActivityListData.ActContinuePayBoxData")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.taskDic = {}
  self.boxList = {}
  self.activityId = 0
  self.resItemId = 0
  self.isAllBoxOpen = false
  self:AddListener()
end

local function __delete(self)
  self.taskDic = nil
  self.boxList = nil
  self.activityId = nil
  self.resItemId = nil
  self.isAllBoxOpen = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function UpdateActDetailInfo(self, msg)
  if not msg or not msg.id then
    return
  end
  self.activityId = msg.id
  if msg.tasks then
    self.taskDic = {}
    table.walk(msg.tasks, function(k, v)
      local newTask = TaskInfo.New()
      newTask:UpdateInfo(v)
      self.taskDic[v.id] = newTask
    end)
  end
  if msg.boxList then
    self.boxList = {}
    table.walk(msg.boxList, function(k, v)
      local newBox = ActContinuePayBoxData.New()
      newBox:UpdateInfo(v)
      if newBox.state == ActContinuePayBoxData.ActContinuePayBoxState.CLOSE then
      end
      self.boxList[v.index] = newBox
    end)
  end
  if msg.resourceItemId then
    self.resItemId = msg.resourceItemId
  end
  EventManager:GetInstance():Broadcast(EventId.OnPayActivityInfoUpdated)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function UpdateOneBoxInfo(self, msg)
  if msg.activityId and msg.activityId == tonumber(self.activityId) and self.boxList and self.boxList[msg.index] then
    self.boxList[msg.index].state = ActContinuePayBoxData.ActContinuePayBoxState.OPEN
    local tempReward = {}
    tempReward.type = msg.reward[1].type
    tempReward.value = {
      id = msg.reward[1].value.itemId,
      num = msg.reward[1].value.addNum or msg.reward[1].value.rewardAdd
    }
    self.boxList[msg.index].reward = {tempReward}
  end
  EventManager:GetInstance():Broadcast(EventId.OnPayActivitySingleBoxUpdated, {
    index = msg.index,
    reward = msg.reward
  })
end

local function UpdateOneTaskInfo(self, msg)
  if msg.aid and msg.aid == tonumber(self.activityId) then
    table.walk(msg.a_task, function(k, v)
      local temp = self.taskDic[v.id]
      if temp then
        temp:UpdateInfo(v)
      else
        temp = TaskInfo.New()
        temp:UpdateInfo(v)
        self.taskDic[v.id] = temp
      end
    end)
    EventManager:GetInstance():Broadcast(EventId.OnPayActivityTaskUpdated)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

local function GetOneTaskReward(self, msg)
  if msg.activityId and msg.activityId == tonumber(self.activityId) then
    local temp = self.taskDic[msg.taskId]
    if temp then
      temp.state = TaskState.Received
    end
    EventManager:GetInstance():Broadcast(EventId.OnPayActivityTaskUpdated)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

local function RequestOpenOneBox(self, activityId, index)
  SFSNetwork.SendMessage(MsgDefines.ActivityPayOpen, activityId, index)
end

local function RequestGetTaskReward(self, activityId, taskId)
  SFSNetwork.SendMessage(MsgDefines.ActivityTaskReward, tonumber(activityId), tostring(taskId))
end

local function RequestRewardPreview(self)
  SFSNetwork.SendMessage(MsgDefines.ActivityPayRewardPreview, self.activityId)
end

local function RequestManualReset(self)
  SFSNetwork.SendMessage(MsgDefines.ActivityPayReset, self.activityId)
end

local function GetDigActivityRed(self)
  return 0
end

local function IsActDetailDataExist(self)
  return not table.IsNullOrEmpty(self.boxList)
end

local function GetRedPointCount(self)
  local count = 0
  if not table.IsNullOrEmpty(self.taskDic) then
    for k, v in pairs(self.taskDic) do
      if v.state == TaskState.CanReceive then
        count = count + 1
      end
    end
  end
  return count
end

local function GetOpenBoxResItem(self)
  return self.resItemId
end

local function GetBigReward(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActContinuePayRewardNoticePanel, {anim = true})
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
  EventManager:GetInstance():Broadcast(EventId.OnPayActivityGetBigReward)
end

local function GetRewardByIndex(self, index)
  if not table.IsNullOrEmpty(self.boxList) then
    return self.boxList[index]
  end
end

local function GetTaskList(self)
  local ret = {}
  if not table.IsNullOrEmpty(self.taskDic) then
    table.walk(self.taskDic, function(k, v)
      table.insert(ret, v)
    end)
    table.sort(ret, function(a, b)
      return a.id < b.id
    end)
  end
  return ret
end

local function GetActivityId(self)
  return self.activityId
end

local function CheckIsAllBoxOpen(self)
  if not table.IsNullOrEmpty(self.boxList) then
    self.isAllBoxOpen = true
    table.walk(self.boxList, function(k, v)
      if v.state == ActContinuePayBoxData.ActContinuePayBoxState.CLOSE then
        self.isAllBoxOpen = false
      end
    end)
  end
end

local function GetIsAllBoxOpen(self)
  CheckIsAllBoxOpen(self)
  return self.isAllBoxOpen
end

local function GetTaskDataByTaskId(self, taskId)
  if not table.IsNullOrEmpty(self.taskDic) then
    local ret = self.taskDic[tostring(taskId)]
    return ret
  end
end

local function OnGetManualResetInfo(self, msg)
  if msg.flag == 1 then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, self.activityId)
  end
end

ContinuePayActivityManager.__init = __init
ContinuePayActivityManager.__delete = __delete
ContinuePayActivityManager.AddListener = AddListener
ContinuePayActivityManager.RemoveListener = RemoveListener
ContinuePayActivityManager.UpdateActDetailInfo = UpdateActDetailInfo
ContinuePayActivityManager.UpdateOneBoxInfo = UpdateOneBoxInfo
ContinuePayActivityManager.RequestOpenOneBox = RequestOpenOneBox
ContinuePayActivityManager.UpdateOneTaskInfo = UpdateOneTaskInfo
ContinuePayActivityManager.RequestGetTaskReward = RequestGetTaskReward
ContinuePayActivityManager.GetOneTaskReward = GetOneTaskReward
ContinuePayActivityManager.GetDigActivityRed = GetDigActivityRed
ContinuePayActivityManager.RequestRewardPreview = RequestRewardPreview
ContinuePayActivityManager.IsActDetailDataExist = IsActDetailDataExist
ContinuePayActivityManager.GetRedPointCount = GetRedPointCount
ContinuePayActivityManager.GetOpenBoxResItem = GetOpenBoxResItem
ContinuePayActivityManager.GetBigReward = GetBigReward
ContinuePayActivityManager.GetRewardByIndex = GetRewardByIndex
ContinuePayActivityManager.GetTaskList = GetTaskList
ContinuePayActivityManager.GetActivityId = GetActivityId
ContinuePayActivityManager.GetTaskDataByTaskId = GetTaskDataByTaskId
ContinuePayActivityManager.OnGetManualResetInfo = OnGetManualResetInfo
ContinuePayActivityManager.RequestManualReset = RequestManualReset
ContinuePayActivityManager.GetIsAllBoxOpen = GetIsAllBoxOpen
return ContinuePayActivityManager
