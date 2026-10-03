local UIActSlotMachineRecordView = BaseClass("UIActSlotMachineRecordView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActSlotMachineRecordDayItem = require("UI.UIActSlotMachine.UIActSlotMachineRecord.Component.UIActSlotMachineRecordDayItem")
local UIActSlotMachineRecordLogItem = require("UI.UIActSlotMachine.UIActSlotMachineRecord.Component.UIActSlotMachineRecordLogItem")
local panel_path = "UICommonPopUpTitle/panel"
local btn_close_path = "UICommonPopUpTitle/safearea/BtnClose"
local day_item_content_path = "UICommonPopUpTitle/safearea/RecordObj/dayItemScrollView/Viewport/DayItemContent"
local loop_scroll_view_path = "UICommonPopUpTitle/safearea/RecordObj/dayItemScrollView/Viewport/DayItemContent/LoopScrollView"
local day_item_path = "UICommonPopUpTitle/safearea/RecordObj/templates/dayItem"
local empty_tip_path = "UICommonPopUpTitle/safearea/RecordObj/emptyTip"
local loop_content_path = "UICommonPopUpTitle/safearea/RecordObj/dayItemScrollView/Viewport/DayItemContent/LoopScrollView/Viewport/LoopContent"
local trigger_obj_path = "UICommonPopUpTitle/safearea/RecordObj/dayItemScrollView/Viewport/DayItemContent/LoopScrollView/triggerObj"
local day_item_scroll_view_path = "UICommonPopUpTitle/safearea/RecordObj/dayItemScrollView"
local recordItemH = 173
local recordItemPadding = 10
local ContentH = 1010
local dayItemH = 60
local datItemSpace = 10
local loopScrollMaxH = ContentH - dayItemH - datItemSpace * 3

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshActData()
  self:RefreshView(true)
  self:JumpToNewItem()
  self:TrySendInitMsg()
end

local function OnDestroy(self)
  self:ClearAllItem()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.dayItemShowData = {}
  self.daySelectListIndex = 0
  self.dayDetailShowData = {}
  self.waitInitMsgTime = 0
  self.waitNewItemDayNum = 0
  self.waitNewItemIndex = 0
  self.getMoreMsgWaiteTime = 0
end

local function DataDestroy(self)
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.dayItemShowData = nil
  self.daySelectListIndex = nil
  self.dayDetailShowData = nil
  self.waitInitMsgTime = nil
  self.waitNewItemDayNum = nil
  self.waitNewItemIndex = nil
  self.getMoreMsgWaiteTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetSlotsHistoryLogData, self.GetHistoryLogDataMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnGetSlotsHistoryLogData, self.GetHistoryLogDataMsg)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dayDetailShowData then
    return nil
  end
  local packData = self.dayDetailShowData[index]
  local item = loopScroll:NewListViewItem("recordItem")
  local script = self.loop_content:GetComponent(item.gameObject.name, UIActSlotMachineRecordLogItem)
  if script == nil then
    NameCount = NameCount + 1
    local objectName = tostring(NameCount)
    item.gameObject.name = objectName
    script = self.loop_content:AddComponent(UIActSlotMachineRecordLogItem, objectName)
  end
  script:SetActive(true)
  script:SetData(self.activityId, packData, self.lottery_reward_player_scroll, index - 1)
  if index == 1 then
    local curCount = #self.dayDetailShowData
    local totalCount = self.dayItemShowData[self.daySelectListIndex].recordCount
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curCount < totalCount and curTime > self.getMoreMsgWaiteTime then
      local curDayNum = self.dayItemShowData[self.daySelectListIndex].dayNum
      local onePageNum = DataCenter.ActSlotMachineDataManager:GetHistroyLogOnePageNum()
      local startNum = curCount + 1
      local endNum = curCount + onePageNum
      SFSNetwork.SendMessage(MsgDefines.SlotsHistoryLog, self.activityId, curDayNum, startNum, endNum)
      self.waitNewItemDayNum = self.daySelectListIndex
      self.waitNewItemIndex = curCount
      self.getMoreMsgWaiteTime = curTime + 1000
    end
  end
  if index == 1 then
    local curCount = #self.dayDetailShowData
    local totalCount = self.dayItemShowData[self.daySelectListIndex].recordCount
    if curCount == totalCount then
      self.loop_scroll_item_first = item
    end
  end
  if index == #self.dayDetailShowData then
    self.loop_scroll_item_last = item
  end
  return item
end

local function OnRecycleItemFunc(self, loopListViewItem)
  if self.loop_scroll_item_first == loopListViewItem then
    self.loop_scroll_item_first = nil
  end
  if self.loop_scroll_item_last == loopListViewItem then
    self.loop_scroll_item_last = nil
  end
end

local function ComponentDefine(self)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panel_close = self:AddComponent(UIButton, panel_path)
  self.panel_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.day_item_content = self:AddComponent(UIBaseContainer, day_item_content_path)
  self.loop_scroll_view = self:AddComponent(UILoopListView2, loop_scroll_view_path)
  self.loop_scroll_view_layout = self:AddComponent(UILayoutElement, loop_scroll_view_path)
  self.day_item = self:AddComponent(UIBaseContainer, day_item_path)
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.loop_content = self:AddComponent(UIBaseContainer, loop_content_path)
  self.day_item_scroll_view = self:AddComponent(UIScrollRect, day_item_scroll_view_path)
  self.day_item_list = {}
  self.day_item:SetActive(false)
  self.day_item.gameObject:GameObjectCreatePool()
  self.loop_scroll_view:InitListViewParam2(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end, nil, nil, function(loopListViewItem)
    OnRecycleItemFunc(self, loopListViewItem)
  end)
  self.trigger_obj = self:AddComponent(UIEventTrigger, trigger_obj_path)
  self.trigger_obj:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.trigger_obj:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.trigger_obj:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
end

local function ComponentDestroy(self)
  self.btn_close = nil
  self.day_item_content = nil
  self.loop_scroll_view = nil
  self.day_item = nil
  self.empty_tip = nil
  self.loop_content = nil
  self.day_item_scroll_view = nil
  self.trigger_obj = nil
end

local function RefreshView(self, isFirst)
  if self.activityInfo == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  self:RefreshShowData(isFirst)
  self:RefreshItemListContent()
end

local function RefreshActData(self)
  self.activityId = self:GetUserData()
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActSlotMachineDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
end

local function RefreshShowData(self, isFirst)
  if self.activityInfo == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  local dataNeedRefresh = false
  local dataRecordTime = 0
  if isFirst == true then
    self.dayItemShowData = self.activityDetailData.historyDayArr
    self.daySelectListIndex = 0
    self.dayDetailShowData = {}
    if 0 < #self.dayItemShowData then
      self.daySelectListIndex = #self.dayItemShowData
      local dayNum = self.dayItemShowData[self.daySelectListIndex].dayNum
      local data = self.activityDetailData.historyData[dayNum]
      if data and data.serverData then
        local len = #data.serverData
        for i = 1, len do
          table.insert(self.dayDetailShowData, data.serverData[len - i + 1])
        end
        dataRecordTime = data.updateTime
      end
    end
  elseif 0 < #self.dayItemShowData and 0 < self.daySelectListIndex then
    local dayNum = self.dayItemShowData[self.daySelectListIndex].dayNum
    local data = self.activityDetailData.historyData[dayNum]
    self.dayDetailShowData = {}
    if data and data.serverData then
      local len = #data.serverData
      for i = 1, len do
        table.insert(self.dayDetailShowData, data.serverData[len - i + 1])
      end
      dataRecordTime = data.updateTime
    end
  end
  if 0 < dataRecordTime and 0 < self.daySelectListIndex then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local dayStartTime = self.activityInfo.startTime
    local dayNum = self.dayItemShowData[self.daySelectListIndex].dayNum
    local needLastTime = dayStartTime + dayNum * 86400 * 1000
    if curTime > needLastTime and dataRecordTime < needLastTime then
      dataNeedRefresh = true
    end
  end
  if 0 < self.daySelectListIndex and (#self.dayDetailShowData == 0 or dataNeedRefresh) then
    local curDayNum = self.dayItemShowData[self.daySelectListIndex].dayNum
    local onePageNum = DataCenter.ActSlotMachineDataManager:GetHistroyLogOnePageNum()
    SFSNetwork.SendMessage(MsgDefines.SlotsHistoryLog, self.activityId, curDayNum, 1, onePageNum)
  end
  if isFirst == true and 0 < #self.dayDetailShowData then
    self.waitInitMsgTime = 0
  end
end

local function RefreshItemListContent(self)
  self:RefreshDayItemListContent()
  self:RefreshLoopItemListContent()
end

local function RefreshDayItemListContent(self)
  local showData = self.dayItemShowData
  for index = 1, #showData do
    if self.day_item_list[index] == nil then
      local showIndex = index
      local item = self.day_item.gameObject:GameObjectSpawn(self.day_item_content.transform)
      item.name = showIndex
      local obj = self.day_item_content:AddComponent(UIActSlotMachineRecordDayItem, item.name)
      obj:SetActive(true)
      self.day_item_list[index] = obj
      obj:SetSelectFunc(function(index, open)
        self:SetDayItemOpend(index, open)
      end)
    end
    local item = self.day_item_list[index]
    item:SetData(self.activityInfo, showData[index], index, index == self.daySelectListIndex)
  end
  if #self.day_item_list > #showData then
    for i = #showData + 1, #self.day_item_list do
      self.day_item_list[i]:SetActive(false)
    end
  end
  self.empty_tip:SetActive(#showData == 0)
end

local function RefreshLoopItemListContent(self)
  self.loop_scroll_item_first = nil
  self.loop_scroll_item_last = nil
  if self.daySelectListIndex <= 0 then
    self.loop_scroll_view:SetActive(false)
  else
    self.loop_scroll_view:SetActive(false)
    self.loop_scroll_view.transform:SetSiblingIndex(self.daySelectListIndex)
    self.loop_scroll_view:SetActive(true)
    local showData = self.dayDetailShowData
    if not table.IsNullOrEmpty(showData) then
      local itemNum = #showData
      local scrollItemH = itemNum * recordItemH + (itemNum - 1) * recordItemPadding
      if scrollItemH > loopScrollMaxH then
        scrollItemH = loopScrollMaxH
      end
      self.loop_scroll_view_layout:SetMinHeight(scrollItemH)
      self.loop_scroll_view_layout:SetPreferredHeight(scrollItemH)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.day_item_content.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.loop_content.transform)
      self.loop_scroll_view:SetListItemCount(#showData, false, false)
      self.loop_scroll_view:StopMovement()
      self.loop_scroll_view:ForceUpdate()
      if 0 < self.waitNewItemDayNum and self.waitNewItemDayNum == self.daySelectListIndex then
        local curCount = #showData
        self.loop_scroll_view:MovePanelToItemIndex(curCount - self.waitNewItemIndex)
        self.waitNewItemDayNum = 0
        self.waitNewItemIndex = 0
      else
        self.loop_scroll_view:MovePanelToItemIndex(#showData)
        self.waitNewItemDayNum = 0
        self.waitNewItemIndex = 0
      end
    end
  end
end

local function JumpToNewItem(self)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.day_item_content.transform)
  self.day_item_scroll_view:SetVerticalNormalizedPosition(0)
end

local function ClearAllItem(self)
  self.day_item_content:RemoveComponents(UIActSlotMachineRecordDayItem)
  self.day_item.gameObject:GameObjectRecycleAll()
  self.day_item_list = {}
  self.loop_content:RemoveComponents(UIActSlotMachineRecordLogItem)
  self.loop_scroll_view:ClearAllItems()
end

local function TrySendInitMsg(self)
  if self.activityInfo == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local dayStartTime = self.activityInfo.startTime
  local curDayNum = math.floor((curTime - dayStartTime) / 86400000) + 1
  local needRefresh = self.activityDetailData:GetHistoryLogDataNeedRefresh()
  if needRefresh then
    local onePageNum = DataCenter.ActSlotMachineDataManager:GetHistroyLogOnePageNum()
    SFSNetwork.SendMessage(MsgDefines.SlotsHistoryLog, self.activityId, curDayNum, 1, onePageNum)
    self.waitInitMsgTime = curTime + 5000
  end
end

local function GetHistoryLogDataMsg(self, activityId)
  if activityId ~= self.activityId then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.waitInitMsgTime then
    self:RefreshView(true)
    self:JumpToNewItem()
  else
    self:RefreshView()
  end
end

local function SetDayItemOpend(self, index, open)
  if open then
    self.daySelectListIndex = index
  else
    self.daySelectListIndex = 0
  end
  self:RefreshView()
end

local function OnBeginDrag(self, eventData)
  self.triggerEventData = eventData
  self.loop_scroll_view:OnBeginDrag(eventData)
  self.day_item_scroll_view:OnBeginDrag(eventData)
end

local function OnDrag(self, eventData)
  local oldTriggerEventData = self.triggerEventData
  self.triggerEventData = eventData
  if oldTriggerEventData then
    if self.triggerEventData.delta.y > 0 then
      if self.loop_scroll_item_last then
        local contentPosY = self.loop_content:GetAnchoredPositionY()
        local contentX, contentY = self.loop_content:GetSizeDeltaXY()
        local scrollX, scrollY = self.loop_scroll_view:GetSizeDeltaXY()
        local needPosY = contentY - scrollY
        if contentPosY > needPosY - 10 then
          self.day_item_scroll_view:OnDrag(eventData)
        else
          self.loop_scroll_view:OnDrag(eventData)
        end
      else
        self.loop_scroll_view:OnDrag(eventData)
      end
    elseif self.triggerEventData.delta.y < 0 then
      if self.loop_scroll_item_first then
        local contentPosY = self.loop_content:GetAnchoredPositionY()
        local needPosY = 0
        if contentPosY < needPosY + 10 then
          self.day_item_scroll_view:OnDrag(eventData)
        else
          self.loop_scroll_view:OnDrag(eventData)
        end
      else
        self.loop_scroll_view:OnDrag(eventData)
      end
    end
  end
end

local function OnEndDrag(self, eventData)
  self.triggerEventData = nil
  self.loop_scroll_view:OnEndDrag(eventData)
  self.day_item_scroll_view:OnEndDrag(eventData)
end

UIActSlotMachineRecordView.OnCreate = OnCreate
UIActSlotMachineRecordView.OnDestroy = OnDestroy
UIActSlotMachineRecordView.DataDefine = DataDefine
UIActSlotMachineRecordView.DataDestroy = DataDestroy
UIActSlotMachineRecordView.ComponentDefine = ComponentDefine
UIActSlotMachineRecordView.ComponentDestroy = ComponentDestroy
UIActSlotMachineRecordView.OnAddListener = OnAddListener
UIActSlotMachineRecordView.OnRemoveListener = OnRemoveListener
UIActSlotMachineRecordView.RefreshView = RefreshView
UIActSlotMachineRecordView.ClearAllItem = ClearAllItem
UIActSlotMachineRecordView.RefreshActData = RefreshActData
UIActSlotMachineRecordView.RefreshShowData = RefreshShowData
UIActSlotMachineRecordView.JumpToNewItem = JumpToNewItem
UIActSlotMachineRecordView.RefreshItemListContent = RefreshItemListContent
UIActSlotMachineRecordView.RefreshDayItemListContent = RefreshDayItemListContent
UIActSlotMachineRecordView.RefreshLoopItemListContent = RefreshLoopItemListContent
UIActSlotMachineRecordView.TrySendInitMsg = TrySendInitMsg
UIActSlotMachineRecordView.GetHistoryLogDataMsg = GetHistoryLogDataMsg
UIActSlotMachineRecordView.SetDayItemOpend = SetDayItemOpend
UIActSlotMachineRecordView.OnBeginDrag = OnBeginDrag
UIActSlotMachineRecordView.OnDrag = OnDrag
UIActSlotMachineRecordView.OnEndDrag = OnEndDrag
return UIActSlotMachineRecordView
