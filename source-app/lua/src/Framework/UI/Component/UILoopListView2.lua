local UILoopListView2 = BaseClass("UILoopListView2", UIBaseContainer)
local base = UIBaseContainer
local UnityUILoopListView2 = typeof(CS.SuperScrollView.LoopListView2)

local function OnCreate(self, relative_path)
  base.OnCreate(self)
  self.unity_looplistview2 = self.gameObject:GetComponent(UnityUILoopListView2)
end

local function OnDestroy(self)
  local listview = self.unity_looplistview2
  if listview then
    pcall(function()
      listview:SetOnBeginDragAction(nil)
      listview:SetOnDragingAction(nil)
      listview:SetOnEndDragAction(nil)
      listview:SetOnListClickAction(nil)
      listview:SetOnSnapItemFinished(nil)
      listview:SetOnSnapNearestChanged(nil)
      listview.OnGetItemByIndex = nil
      listview.OnGetItemNameByIndex = nil
    end)
  end
  self.unity_looplistview2 = nil
end

local function arabicMirrorCallback(item, isProcessRootPivotAndAnchor)
  if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() then
    CS.ArabicMirror.MirrorEntry(true, isProcessRootPivotAndAnchor, item.gameObject)
  end
end

local function InitListView(self, itemTotalCount, onGetItemByIndex)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:InitListView(itemTotalCount, onGetItemByIndex, nil, nil, arabicMirrorCallback, nil)
end

local function InitListViewParam(self, itemTotalCount, onGetItemByIndex, initParam)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:InitListView(itemTotalCount, onGetItemByIndex, initParam, nil, arabicMirrorCallback, nil)
end

local function InitListViewParam2(self, itemTotalCount, onGetItemByIndex, initParam, onGetItemNameByIndex, onRecycleItemFunc)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:InitListView(itemTotalCount, onGetItemByIndex, initParam, onGetItemNameByIndex, arabicMirrorCallback, onRecycleItemFunc)
end

local function SetOnBeginDragAction(self, callback)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:SetOnBeginDragAction(callback)
end

local function SetOnDragingAction(self, onDragingAction)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:SetOnDragingAction(onDragingAction)
end

local function SetOnEndDragAction(self, onEndDragAction)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:SetOnEndDragAction(onEndDragAction)
end

local function SetOnListClickAction(self, callback)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:SetOnListClickAction(callback)
end

local function GetShownItemByItemIndex(self, itemidx)
  if self.unity_looplistview2 == nil then
    return nil
  end
  return self.unity_looplistview2:GetShownItemByItemIndex(itemidx)
end

local function GetShownItemByIndex(self, idx)
  if self.unity_looplistview2 == nil then
    return nil
  end
  return self.unity_looplistview2:GetShownItemByIndex(idx)
end

local function GetItemCornerPosInViewPort(self, item, corner)
  if self.unity_looplistview2 == nil then
    return nil
  end
  return self.unity_looplistview2:GetItemCornerPosInViewPort(item, corner or CS.SuperScrollView.ItemCornerEnum.LeftBottom)
end

local function SetListItemCount(self, itemTotalCount, moveToMinPos, moveToMaxPos)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:SetListItemCount(itemTotalCount, moveToMinPos, moveToMaxPos)
end

local function SetListItemCount_Mod(self, itemTotalCount, moveToMinPos, moveToMaxPos, refresh)
  if self.unity_looplistview2 == nil then
    return
  end
  local refreshShownItems = false
  if refresh ~= nil then
    refreshShownItems = refresh
  end
  self.unity_looplistview2:SetListItemCount_Mod(itemTotalCount, moveToMinPos, moveToMaxPos, refreshShownItems)
end

local function SetListItemCount_ClearDirtyData(self, itemTotalCount, needCheckNextMaxItem, needCheckNextMinItem)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:SetListItemCount_ClearDirtyData(itemTotalCount, needCheckNextMaxItem, needCheckNextMinItem)
end

local function RefreshAllShownItem(self)
  if self.unity_looplistview2 == nil then
    return
  end
  self.unity_looplistview2:RefreshAllShownItem()
end

local function SetInteractable(self, value)
  self.unity_looplistview2.interactable = value
end

local function MovePanelToItemIndex(self, index, offset, reverse)
  self.unity_looplistview2:MovePanelToItemIndex(index, offset or 0, reverse == true)
end

local function MovePanelToItemIndex_Mod(self, index, offset, reverse)
  self.unity_looplistview2:MovePanelToItemIndex(index, offset or 0, reverse == true)
end

local function StopMovement(self)
  if self.unity_looplistview2 then
    self.unity_looplistview2.ScrollRect:StopMovement()
  end
end

local function GetViewPortWidth(self)
  return self.unity_looplistview2.ViewPortWidth
end

local function ClearAllItems(self)
  self.unity_looplistview2:ClearAllItems()
end

local function RecycleAllItem(self)
  self.unity_looplistview2:RecycleAllItem()
end

local function SetOnSnapItemFinished(self, callback)
  self.unity_looplistview2:SetOnSnapItemFinished(callback)
end

local function SetOnSnapNearestChanged(self, callback)
  self.unity_looplistview2:SetOnSnapNearestChanged(callback)
end

local function OnDrag(self, eventData)
  if self.unity_looplistview2 then
    self.unity_looplistview2.ScrollRect:OnDrag(eventData)
    self.unity_looplistview2:OnDrag(eventData)
  end
end

local function OnBeginDrag(self, eventData)
  if self.unity_looplistview2 then
    self.unity_looplistview2.ScrollRect:OnBeginDrag(eventData)
    self.unity_looplistview2:OnBeginDrag(eventData)
    self:StopMovement()
  end
end

local function OnEndDrag(self, eventData)
  if self.unity_looplistview2 then
    self.unity_looplistview2.ScrollRect:OnEndDrag(eventData)
    self.unity_looplistview2:OnEndDrag(eventData)
  end
end

local function SetSnapTargetItemIndex(self, index)
  self.unity_looplistview2:SetSnapTargetItemIndex(index)
end

local function DoActionForEachShownItem(self, action, param)
  if self.unity_looplistview2 then
    self.unity_looplistview2:DoActionForEachShownItem(action, param)
  end
end

local function ForceUpdate(self)
  if self.unity_looplistview2 then
    self.unity_looplistview2:ForceUpdate()
  end
end

local function ResetListView(self)
  if self.unity_looplistview2 then
    self.unity_looplistview2:ResetListView()
  end
end

local function OnItemSizeChanged(self, index)
  if self.unity_looplistview2 then
    self.unity_looplistview2:OnItemSizeChanged(index)
  end
end

local function RefreshItemByItemIndex(self, index)
  if self.unity_looplistview2 then
    self.unity_looplistview2:RefreshItemByItemIndex(index)
  end
end

local function ClearItemPosCache(self)
  if self.unity_looplistview2 then
    self.unity_looplistview2:ClearItemPosCache()
  end
end

UILoopListView2.OnCreate = OnCreate
UILoopListView2.OnDestroy = OnDestroy
UILoopListView2.InitListView = InitListView
UILoopListView2.InitListViewParam = InitListViewParam
UILoopListView2.InitListViewParam2 = InitListViewParam2
UILoopListView2.SetOnBeginDragAction = SetOnBeginDragAction
UILoopListView2.SetOnDragingAction = SetOnDragingAction
UILoopListView2.SetOnEndDragAction = SetOnEndDragAction
UILoopListView2.SetOnListClickAction = SetOnListClickAction
UILoopListView2.GetShownItemByIndex = GetShownItemByIndex
UILoopListView2.GetShownItemByItemIndex = GetShownItemByItemIndex
UILoopListView2.GetItemCornerPosInViewPort = GetItemCornerPosInViewPort
UILoopListView2.SetListItemCount = SetListItemCount
UILoopListView2.SetListItemCount_Mod = SetListItemCount_Mod
UILoopListView2.SetListItemCount_ClearDirtyData = SetListItemCount_ClearDirtyData
UILoopListView2.RefreshAllShownItem = RefreshAllShownItem
UILoopListView2.SetInteractable = SetInteractable
UILoopListView2.MovePanelToItemIndex = MovePanelToItemIndex
UILoopListView2.MovePanelToItemIndex_Mod = MovePanelToItemIndex_Mod
UILoopListView2.StopMovement = StopMovement
UILoopListView2.GetViewPortWidth = GetViewPortWidth
UILoopListView2.ClearAllItems = ClearAllItems
UILoopListView2.RecycleAllItem = RecycleAllItem
UILoopListView2.SetOnSnapItemFinished = SetOnSnapItemFinished
UILoopListView2.SetOnSnapNearestChanged = SetOnSnapNearestChanged
UILoopListView2.OnDrag = OnDrag
UILoopListView2.OnBeginDrag = OnBeginDrag
UILoopListView2.OnEndDrag = OnEndDrag
UILoopListView2.SetSnapTargetItemIndex = SetSnapTargetItemIndex
UILoopListView2.DoActionForEachShownItem = DoActionForEachShownItem
UILoopListView2.ResetListView = ResetListView
UILoopListView2.OnItemSizeChanged = OnItemSizeChanged
UILoopListView2.ForceUpdate = ForceUpdate
UILoopListView2.RefreshItemByItemIndex = RefreshItemByItemIndex
UILoopListView2.ClearItemPosCache = ClearItemPosCache
return UILoopListView2
