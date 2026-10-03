local AttackCityTaskContent = BaseClass("AttackCityTaskContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWTaskItem = require("UI.UIActivityAttackCity.AttackCityTargetInfo.Component.AttackCityTaskContentItem")
local TaskListPath = "TaskListScroll"
local TaskListContentPath = "TaskListScroll/Viewport/Content"

function AttackCityTaskContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AttackCityTaskContent:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AttackCityTaskContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityAttackCityTaskDataUpdate, self.RefreshView)
end

function AttackCityTaskContent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityAttackCityTaskDataUpdate, self.RefreshView)
  base.OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.TaskDataList then
    return nil
  end
  local TaskInfo = self.TaskDataList[index]
  local item = loopScroll:NewListViewItem("AttackCityTaskItem")
  local script = self.TaskListContent:GetComponent(item.gameObject.name, UILWTaskItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.TaskListContent:AddComponent(UILWTaskItem, objectName)
  end
  script:SetActive(true)
  script:SetData(TaskInfo)
  return item
end

function AttackCityTaskContent:ComponentDefine()
  self.TaskList = self:AddComponent(UILoopListView2, TaskListPath)
  self.TaskList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.TaskListContent = self:AddComponent(UIBaseContainer, TaskListContentPath)
end

function AttackCityTaskContent:ComponentDestroy()
  self.TaskList = nil
  self.TaskListContent = nil
end

function AttackCityTaskContent:DataDefine()
  self.itemIndex = 0
end

function AttackCityTaskContent:DataDestroy()
end

function AttackCityTaskContent:SetData(activityId)
  self.activityId = activityId
  if self.activityId == nil then
    return
  end
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo == nil then
    return
  end
  local fightStartTime = cityWarInfo.fightStartTime
  local fightEndTime = cityWarInfo.fightEndTime
  self.TaskData = DataCenter.ActivityAttackCityDataManager:GetTaskData(self.activityId)
  local isNeedSend = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.TaskData == nil then
    isNeedSend = true
  elseif fightEndTime + self.TaskData.refreshTime * 60 > self.TaskData.getTime and fightStartTime - self.TaskData.refreshTime * 60 < self.TaskData.getTime and curTime > self.TaskData.getTime + self.TaskData.refreshTime then
    isNeedSend = true
  end
  if isNeedSend then
    SFSNetwork.SendMessage(MsgDefines.GetCityWarTarget, self.activityId)
  end
  self:RefreshView()
end

function AttackCityTaskContent:RefreshView()
  if self.activityId == nil then
    return
  end
  self.TaskData = DataCenter.ActivityAttackCityDataManager:GetTaskData(self.activityId)
  self.TaskDataList = {}
  if self.TaskData ~= nil then
    self.TaskDataList = self.TaskData.data
  end
  if #self.TaskDataList == 0 then
    self.TaskList:SetActive(false)
  else
    self.TaskList:SetActive(true)
    self.TaskList:SetListItemCount(#self.TaskDataList, false, false)
    self.TaskList:RefreshAllShownItem()
  end
end

function AttackCityTaskContent:ClearScroll()
  self.TaskListContent:RemoveComponents(UILWTaskItem)
  self.TaskList:ClearAllItems()
end

return AttackCityTaskContent
