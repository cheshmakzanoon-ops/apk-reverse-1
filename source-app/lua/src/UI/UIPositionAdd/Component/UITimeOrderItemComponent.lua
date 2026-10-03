local base = UIBaseContainer
local UITimeOrderItemComponent = BaseClass("UITimeOrderItemComponent", UIBaseContainer)
local SelectTimeItemComponent = require("UI.UIPositionAdd.Component.UISelectTimeItemComponent")
local Localization = CS.GameEntry.Localization

function UITimeOrderItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITimeOrderItemComponent:OnDestroy()
  self:ClearTimeOrderItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITimeOrderItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compTimeItem = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.selectScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compSelectScrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.selectItems = {}
  self.selectScrollView:InitListView(0, function(listView, index)
    return self:TryGetScrollItem(listView, index)
  end)
  self.selectScrollView:SetOnSnapNearestChanged(function(listView, item)
    self:OnItemSnapNearestChanged(listView, item)
  end)
end

function UITimeOrderItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.compTimeItem = nil
  self.selectScrollView = nil
  self.compSelectScrollContent = nil
end

function UITimeOrderItemComponent:DataDefine()
  self.itemIndex = 1
  self.timeOrderData = {}
  self.curSelectOrderIndex = 0
  self.onChangedUpdate = nil
end

function UITimeOrderItemComponent:DataDestroy()
  self.itemIndex = nil
  self.timeOrderData = nil
  self.curSelectOrderIndex = nil
  self.onChangedUpdate = nil
end

function UITimeOrderItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UITimeOrderItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITimeOrderItemComponent:ClearTimeOrderItem()
  self.compSelectScrollContent:RemoveComponents(SelectTimeItemComponent)
  self.selectScrollView:ClearAllItems()
  self.selectItems = {}
end

function UITimeOrderItemComponent:SetTitle(title_text)
  self.textTitle:SetText(title_text or "")
end

function UITimeOrderItemComponent:RefreshItems(order_data, target_index)
  if not order_data or table.count(order_data) == 0 then
    return
  end
  local count = table.count(order_data)
  self.timeOrderData = order_data
  self.curSelectOrderIndex = target_index or 1
  self.selectScrollView:SetListItemCount(count, false, false)
  self.selectScrollView:RefreshAllShownItem()
  self.selectScrollView:MovePanelToItemIndex(self.curSelectOrderIndex - 1, 0)
end

function UITimeOrderItemComponent:TryGetScrollItem(listView, index)
  local order_data_list = self.timeOrderData
  if order_data_list == nil or table.count(order_data_list) == 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > table.count(order_data_list) then
    return nil
  end
  local timeItem = listView:NewListViewItem("TimeItem")
  local cellItem = self.selectItems[timeItem]
  if cellItem == nil then
    self.itemIndex = self.itemIndex + 1
    local objectName = string.format("TimeItem_%d", self.itemIndex)
    timeItem.gameObject.name = objectName
    cellItem = self.compSelectScrollContent:AddComponent(SelectTimeItemComponent, objectName)
    self.selectItems[timeItem] = cellItem
  end
  if cellItem ~= nil then
    cellItem:SetActive(true)
    cellItem:SetTimeData(order_data_list[index], index, self.curSelectOrderIndex)
  end
  return timeItem
end

function UITimeOrderItemComponent:OnItemSnapNearestChanged(listView, item)
  self.curSelectOrderIndex = item.ItemIndex + 1
  for _, cellItem in pairs(self.selectItems) do
    cellItem:SetTimeSelect(self.curSelectOrderIndex)
  end
  if self.onChangedUpdate then
    self.onChangedUpdate(self.curSelectOrderIndex)
  end
end

function UITimeOrderItemComponent:MoveToTargetIndex(target_index)
  if not target_index or target_index < 1 or target_index > table.count(self.timeOrderData) then
    return
  end
  self.curSelectOrderIndex = target_index
  self.selectScrollView:MovePanelToItemIndex(target_index - 1, 0)
  for _, cellItem in pairs(self.selectItems) do
    cellItem:SetTimeSelect(self.curSelectOrderIndex)
  end
end

function UITimeOrderItemComponent:RefreshSelectItem()
  for _, cellItem in pairs(self.selectItems) do
    cellItem:SetTimeSelect(self.curSelectOrderIndex)
  end
end

function UITimeOrderItemComponent:GetCurSelectOrderIndex()
  return self.curSelectOrderIndex or 0
end

function UITimeOrderItemComponent:SetOnChangedUpdate(onChangedUpdate)
  if not onChangedUpdate then
    return
  end
  self.onChangedUpdate = onChangedUpdate
end

return UITimeOrderItemComponent
