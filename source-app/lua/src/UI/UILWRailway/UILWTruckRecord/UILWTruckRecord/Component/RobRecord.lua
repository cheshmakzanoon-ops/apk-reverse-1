local RobRecord = BaseClass("RobRecord", UIBaseContainer)
local TruckRobRecordItem = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.Component.TruckRobRecordItem")
local base = UIBaseContainer
local REQ_COUNT_EVERY_TIME = 20
local types = {
  MailType.TRUCK_BATTLE_REPORT,
  MailType.TRAIN_KOF
}

function RobRecord:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RobRecord:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RobRecord:ComponentDefine()
  self.emptyTip = self:AddComponent(UIBaseContainer, "EmptyTip")
  self.content = self:AddComponent(UIBaseContainer, "MScroll/MViewport/MContent")
  self.scroll = self:AddComponent(UIBaseComponent, "MScroll")
  self.items = {}
  self.loopListView = self:AddComponent(UILoopListView2, "MScroll")
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

function RobRecord:ComponentDestroy()
  self:ClearContent()
  self.content = nil
  self.scroll = nil
  self.loopListView = nil
  self.emptyTip = nil
end

function RobRecord:DataDefine()
  self.startIndex = 0
  self.recordList = {}
end

function RobRecord:DataDestroy()
  self.startIndex = nil
  self.recordList = nil
end

function RobRecord:OnEnable()
  base.OnEnable(self)
end

function RobRecord:OnDisable()
  base.OnDisable(self)
end

function RobRecord:OnAddListener()
  base.OnAddListener(self)
end

function RobRecord:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RobRecord:ClearContent()
  self.items = {}
  self.content:RemoveComponents(TruckRobRecordItem)
  self.loopListView:ClearAllItems()
end

function RobRecord:RefreshContent()
  self:GetListData()
end

function RobRecord:RefreshView()
  self.emptyTip:SetActive(table.IsNullOrEmpty(self.recordList))
  self.loopListView:SetListItemCount(#self.recordList, false, false)
  self.loopListView:RefreshAllShownItem()
end

local NameCount = 0

function RobRecord:GetScrollItem(listview, index)
  local dataList = self.recordList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("UILWMailListItemWar")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "UILWMailListItemWar" .. NameCount
    csItem.gameObject.name = nameStr
    local mailItem = self.content:AddComponent(TruckRobRecordItem, nameStr)
    self.items[csItem] = mailItem
  end
  self.items[csItem]:SetData(dataList[index])
  return csItem
end

function RobRecord:OnDraggingAction()
  local _totalCnt = #self.recordList
  if self._loadingMail == true then
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

function RobRecord:OnEndDragAction()
  if self._toLoadMore == true then
    self._loadingMail = false
    self._toLoadMore = false
    if #self.recordList >= self.startIndex + REQ_COUNT_EVERY_TIME then
      self:GetMoreRecord()
    end
  end
end

function RobRecord:GetMoreRecord()
  self.startIndex = self.startIndex + REQ_COUNT_EVERY_TIME
  self:GetListData()
end

function RobRecord:GetListData()
  return DataCenter.MailDataManager:ReqMailByTypes(types, self.startIndex, REQ_COUNT_EVERY_TIME, function(mailDatas)
    if self.startIndex then
      local uids = {}
      for k, v in ipairs(mailDatas) do
        self.recordList[self.startIndex + k] = v
        table.insert(uids, v.uid)
      end
      Logger.LogInfo("RobRecord ReqMailByTypes " .. #uids .. " " .. table.concat(uids, ","))
      self:RefreshView()
    end
  end)
end

return RobRecord
