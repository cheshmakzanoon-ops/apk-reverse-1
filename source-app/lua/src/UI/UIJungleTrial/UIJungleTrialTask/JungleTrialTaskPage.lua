local JungleTrialTaskPage = BaseClass("JungleTrialTaskPage", UIBaseContainer)
local base = UIBaseContainer
local JungleTrialTaskItem = require("UI.UIJungleTrial.UIJungleTrialTask.JungleTrialTaskItem")

function JungleTrialTaskPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function JungleTrialTaskPage:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function JungleTrialTaskPage:ComponentDefine()
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "ViewPort/Content")
  self.loopListView = self:AddComponent(UILoopListView2, "")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "BtnAll/AllText")
  self.btn_text:SetLocalText("310104")
end

function JungleTrialTaskPage:ComponentDestroy()
  self:RemoveItems()
  self.loopListView = nil
end

function JungleTrialTaskPage:DataDefine()
end

function JungleTrialTaskPage:DataDestroy()
  self.taskDataList = nil
end

function JungleTrialTaskPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.JungleTrialTaskRefresh, self.Refresh)
end

function JungleTrialTaskPage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.JungleTrialTaskRefresh, self.Refresh)
end

function JungleTrialTaskPage:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function JungleTrialTaskPage:RefreshData()
  self.taskDataList = DataCenter.JungleTrialDataManager:GetTaskList()
  table.sort(self.taskDataList, function(a, b)
    if a.state ~= b.state then
      if a.state == 1 then
        return true
      elseif b.state == 1 then
        return false
      end
      return a.state < b.state
    end
    return a.taskId < b.taskId
  end)
end

function JungleTrialTaskPage:RefreshView()
  self:RemoveItems()
  if self.taskDataList and #self.taskDataList > 0 then
    self.loopListView:SetListItemCount(#self.taskDataList, false, false)
    self.loopListView:RefreshAllShownItem()
  end
end

function JungleTrialTaskPage:GetScrollItem(listview, index)
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
    self.items[csItem] = self.content:AddComponent(JungleTrialTaskItem, nameStr)
  end
  self.items[csItem]:ReInit(dataList[index])
  return csItem
end

function JungleTrialTaskPage:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(JungleTrialTaskItem)
  self.loopListView:ClearAllItems()
end

return JungleTrialTaskPage
