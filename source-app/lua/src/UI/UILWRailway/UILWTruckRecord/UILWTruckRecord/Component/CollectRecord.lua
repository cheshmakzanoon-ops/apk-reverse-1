local CollectRecord = BaseClass("CollectRecord", UIBaseContainer)
local TruckSendRecordItem = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.Component.TruckSendRecordItem")
local base = UIBaseContainer
local REQ_COUNT_EVERY_TIME = 100

function CollectRecord:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CollectRecord:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CollectRecord:ComponentDefine()
  self.emptyTip = self:AddComponent(UIBaseContainer, "EmptyTip")
  self.content = self:AddComponent(UIBaseContainer, "Scroll View/Viewport/Content")
  self.scroll = self:AddComponent(UIBaseComponent, "Scroll View")
  self.items = {}
  self.loopListView = self:AddComponent(UILoopListView2, "Scroll View")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.loopListView:SetOnDragingAction(function()
    self:OnDraggingAction()
  end)
  self.loopListView:SetOnEndDragAction(function(...)
    self:OnEndDragAction()
  end)
end

function CollectRecord:ComponentDestroy()
  self:ClearContent()
  self.content = nil
  self.scroll = nil
  self.loopListView = nil
  self.emptyTip = nil
end

function CollectRecord:DataDefine()
  self.startIndex = 0
  self:SendGetListMessage()
end

function CollectRecord:DataDestroy()
  self.startIndex = nil
end

function CollectRecord:OnEnable()
  base.OnEnable(self)
  self:SendGetListMessage()
end

function CollectRecord:OnDisable()
  base.OnDisable(self)
end

function CollectRecord:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TruckRecordListArrive, self.RefreshContent)
  self:AddUIListener(EventId.TruckRecordFavoriteAdd, self.OnCollectAddOrRemove)
  self:AddUIListener(EventId.TruckRecordFavoriteRemove, self.OnCollectAddOrRemove)
end

function CollectRecord:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TruckRecordListArrive, self.RefreshContent)
  self:RemoveUIListener(EventId.TruckRecordFavoriteAdd, self.OnCollectAddOrRemove)
  self:RemoveUIListener(EventId.TruckRecordFavoriteRemove, self.OnCollectAddOrRemove)
end

function CollectRecord:ClearContent()
  self.items = {}
  self.content:RemoveComponents(TruckSendRecordItem)
  self.loopListView:ClearAllItems()
end

function CollectRecord:RefreshContent()
  self.recordList = DataCenter.LWTruckRecordDataManager:GetTruckRecordList(TruckRecordType.TruckCollect)
  self.emptyTip:SetActive(table.IsNullOrEmpty(self.recordList))
  self.loopListView:SetListItemCount(#self.recordList, false, false)
  self.loopListView:RefreshAllShownItem()
end

function CollectRecord:OnCollectAddOrRemove()
  self:SendGetListMessage()
end

function CollectRecord:GetScrollItem(listview, index)
  local dataList = self.recordList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("TruckSendRecordItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "TruckSendRecordItem" .. NameCount
    csItem.gameObject.name = nameStr
    local recordItem = self.content:AddComponent(TruckSendRecordItem, nameStr)
    self.items[csItem] = recordItem
  end
  self.items[csItem]:SetData(dataList[index])
  return csItem
end

function CollectRecord:OnDraggingAction()
  local _totalCnt = #self.recordList
  if self._loading == true then
    return
  end
  local _lastItem = self.loopListView:GetShownItemByItemIndex(_totalCnt - 1)
  if _lastItem == nil then
    return
  end
  local _lastItemY = self.loopListView:GetItemCornerPosInViewPort(_lastItem).y
  local _viewPortSize = self.loopListView.unity_looplistview2.ViewPortSize
  if 50 <= _lastItemY + _viewPortSize then
    self._toLoadMore = true
  end
end

function CollectRecord:OnEndDragAction()
  if self._toLoadMore == true then
    self._loading = false
    self._toLoadMore = false
    if #self.recordList >= self.startIndex + REQ_COUNT_EVERY_TIME then
      self:GetMoreRecord()
    end
  end
end

function CollectRecord:GetMoreRecord()
  self.startIndex = self.startIndex + REQ_COUNT_EVERY_TIME
  self:SendGetListMessage()
end

function CollectRecord:SendGetListMessage()
  SFSNetwork.SendMessage(MsgDefines.TrainRecordList, TruckRecordType.TruckCollect, self.startIndex, self.startIndex + REQ_COUNT_EVERY_TIME)
end

return CollectRecord
