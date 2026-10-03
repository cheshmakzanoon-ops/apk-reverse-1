local SendRecord = BaseClass("SendRecord", UIBaseContainer)
local TruckSendRecordItem = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.Component.TruckSendRecordItem")
local base = UIBaseContainer
local REQ_COUNT_EVERY_TIME = 100

function SendRecord:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SendRecord:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SendRecord:ComponentDefine()
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

function SendRecord:ComponentDestroy()
  self:ClearContent()
  self.content = nil
  self.scroll = nil
  self.loopListView = nil
  self.emptyTip = nil
end

function SendRecord:DataDefine()
  self.startIndex = 0
  self.recordList = nil
end

function SendRecord:DataDestroy()
  self.startIndex = nil
  self.recordList = nil
end

function SendRecord:OnEnable()
  base.OnEnable(self)
end

function SendRecord:OnDisable()
  base.OnDisable(self)
end

function SendRecord:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TruckRecordListArrive, self.RefreshContentByMsg)
end

function SendRecord:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TruckRecordListArrive, self.RefreshContentByMsg)
end

function SendRecord:ClearContent()
  self.items = {}
  self.content:RemoveComponents(TruckSendRecordItem)
  self.loopListView:ClearAllItems()
end

function SendRecord:RefreshContent()
  if self.recordList == nil then
    self:SendGetListMessage()
    self.emptyTip:SetActive(true)
  else
    self:RefreshContentByMsg()
  end
end

function SendRecord:RefreshContentByMsg(truckRecordType)
  if truckRecordType ~= TruckRecordType.TruckSend then
    return
  end
  self.recordList = DataCenter.LWTruckRecordDataManager:GetTruckRecordList(TruckRecordType.TruckSend) or {}
  self.loopListView:SetListItemCount(#self.recordList, false, false)
  self.loopListView:RefreshAllShownItem()
  self.emptyTip:SetActive(table.IsNullOrEmpty(self.recordList))
end

function SendRecord:GetScrollItem(listview, index)
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

function SendRecord:OnDraggingAction()
  if self.recordList == nil then
    return
  end
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

function SendRecord:OnEndDragAction()
  if self.recordList == nil then
    return
  end
  if self._toLoadMore == true then
    self._loading = false
    self._toLoadMore = false
    if #self.recordList >= self.startIndex + REQ_COUNT_EVERY_TIME then
      self:GetMoreRecord()
    end
  end
end

function SendRecord:GetMoreRecord()
  self.startIndex = self.startIndex + REQ_COUNT_EVERY_TIME
  self:SendGetListMessage()
end

function SendRecord:SendGetListMessage()
  SFSNetwork.SendMessage(MsgDefines.TrainRecordList, TruckRecordType.TruckSend, self.startIndex, self.startIndex + REQ_COUNT_EVERY_TIME)
end

return SendRecord
