local BloodyNightTaskPage = BaseClass("BloodyNightTaskPage", UIBaseContainer)
local base = UIBaseContainer
local BloodyNightTaskItem = require("UI.UIBloodyNight.UIBloodyNightReward.Component.BloodyNightTaskItem")

function BloodyNightTaskPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BloodyNightTaskPage:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function BloodyNightTaskPage:ComponentDefine()
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "ViewPort/Content")
  self.loopListView = self:AddComponent(UILoopListView2, "")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "BtnAll/AllText")
  self.btn_text:SetLocalText("310104")
end

function BloodyNightTaskPage:ComponentDestroy()
  self:RemoveItems()
  self.loopListView = nil
end

function BloodyNightTaskPage:DataDefine()
end

function BloodyNightTaskPage:DataDestroy()
  self.taskDataList = nil
end

function BloodyNightTaskPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BloodyNightTaskRefresh, self.Refresh)
  self:AddUIListener(EventId.BloodyNightClaimReward, self.Refresh)
end

function BloodyNightTaskPage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.BloodyNightTaskRefresh, self.Refresh)
  self:RemoveUIListener(EventId.BloodyNightClaimReward, self.Refresh)
end

function BloodyNightTaskPage:Init(type)
  self.tabType = type
end

function BloodyNightTaskPage:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function BloodyNightTaskPage:RefreshData()
  self.taskDataList = DataCenter.BloodyNightDataManager:GetTaskList(self.tabType)
  local statePoint = {
    [TaskState.CanReceive] = 1,
    [TaskState.NoComplete] = 2,
    [TaskState.Received] = 3
  }
  table.sort(self.taskDataList, function(a, b)
    local stateA = statePoint[a.state]
    local stateB = statePoint[b.state]
    if stateA ~= stateB then
      return stateA < stateB
    end
    local taskA = DataCenter.ActivityTaskTemplateManager:GetBNTaskTemplate(a.taskId)
    local taskB = DataCenter.ActivityTaskTemplateManager:GetBNTaskTemplate(b.taskId)
    local orderA = taskA.order
    local orderB = taskB.order
    return orderA > orderB
  end)
end

function BloodyNightTaskPage:RefreshView()
  self:RemoveItems()
  if self.taskDataList and #self.taskDataList > 0 then
    self.loopListView:SetListItemCount(#self.taskDataList, false, false)
    self.loopListView:RefreshAllShownItem()
  end
end

function BloodyNightTaskPage:GetScrollItem(listview, index)
  local dataList = self.taskDataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("TaskCell")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "TaskCell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(BloodyNightTaskItem, nameStr)
  end
  self.items[csItem]:ReInit(dataList[index])
  return csItem
end

function BloodyNightTaskPage:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(BloodyNightTaskItem)
  self.loopListView:ClearAllItems()
end

return BloodyNightTaskPage
