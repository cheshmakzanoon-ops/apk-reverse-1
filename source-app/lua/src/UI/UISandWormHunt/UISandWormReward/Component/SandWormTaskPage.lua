local SandWormTaskPage = BaseClass("SandWormTaskPage", UIBaseContainer)
local base = UIBaseContainer
local SandWormTaskItem = require("UI.UISandWormHunt.UISandWormReward.Component.SandWormTaskItem")

function SandWormTaskPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SandWormTaskPage:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function SandWormTaskPage:ComponentDefine()
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "ViewPort/Content")
  self.loopListView = self:AddComponent(UILoopListView2, "")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "BtnAll/AllText")
  self.btn_text:SetLocalText("310104")
end

function SandWormTaskPage:ComponentDestroy()
  self:RemoveItems()
  self.loopListView = nil
end

function SandWormTaskPage:DataDefine()
end

function SandWormTaskPage:DataDestroy()
  self.taskDataList = nil
end

function SandWormTaskPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SandWormTaskRefresh, self.Refresh)
end

function SandWormTaskPage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SandWormTaskRefresh, self.Refresh)
end

function SandWormTaskPage:Init(type)
  self.tabType = type
end

function SandWormTaskPage:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function SandWormTaskPage:RefreshData()
  self.taskDataList = DataCenter.SandWormHuntDataManager:GetTaskList(self.tabType)
end

function SandWormTaskPage:RefreshView()
  self:RemoveItems()
  if self.taskDataList and #self.taskDataList > 0 then
    self.loopListView:SetListItemCount(#self.taskDataList, false, false)
    self.loopListView:RefreshAllShownItem()
  end
end

function SandWormTaskPage:GetScrollItem(listview, index)
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
    self.items[csItem] = self.content:AddComponent(SandWormTaskItem, nameStr)
  end
  self.items[csItem]:ReInit(dataList[index])
  return csItem
end

function SandWormTaskPage:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(SandWormTaskItem)
  self.loopListView:ClearAllItems()
end

return SandWormTaskPage
