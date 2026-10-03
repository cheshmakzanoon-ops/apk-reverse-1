local UILoopGridView = BaseClass("UILoopGridView", UIBaseContainer)
local base = UIBaseContainer
local UnityUILoopGridView = typeof(CS.SuperScrollView.LoopGridView)

local function OnCreate(self, relative_path)
  base.OnCreate(self)
  self.unity_loopgridview = self.gameObject:GetComponent(UnityUILoopGridView)
end

local function OnDestroy(self)
  local listview = self.unity_loopgridview
  if listview then
    pcall(function()
      listview:SetOnBeginDragAction(nil)
      listview:SetOnDragingAction(nil)
      listview:SetOnEndDragAction(nil)
      listView:SetOnSnapItemFinished(nil)
      listView:SetOnSnapNearestChanged(nil)
      listview.OnGetItemByRowColumn = nil
    end)
  end
  self.unity_loopgridview = nil
end

local function InitGridView(self, itemTotalCount, onGetItemByRowColumn)
  if self.unity_loopgridview == nil then
    return
  end
  self.unity_loopgridview:InitGridView(itemTotalCount, onGetItemByRowColumn)
end

local function InitGridViewParam(self, itemTotalCount, mOnGetItemByRowColumn, settingParam, initParam, onRecycleItemFunc)
  if self.unity_loopgridview == nil then
    return
  end
  self.unity_loopgridview:InitGridView(itemTotalCount, mOnGetItemByRowColumn, settingParam, initParam, onRecycleItemFunc)
end

local function SetOnBeginDragAction(self, callback)
  if self.unity_loopgridview == nil then
    return
  end
  self.unity_loopgridview:SetOnBeginDragAction(callback)
end

local function SetOnDragingAction(self, onDragingAction)
  if self.unity_loopgridview == nil then
    return
  end
  self.unity_loopgridview:SetOnDragingAction(onDragingAction)
end

local function SetOnEndDragAction(self, onEndDragAction)
  if self.unity_loopgridview == nil then
    return
  end
  self.unity_loopgridview:SetOnEndDragAction(onEndDragAction)
end

local function SetOnListClickAction(self, callback)
  if self.unity_loopgridview == nil then
    return
  end
  self.unity_loopgridview:SetOnListClickAction(callback)
end

local function GetShownItemByItemIndex(self, itemidx)
  if self.unity_loopgridview == nil then
    return nil
  end
  return self.unity_loopgridview:GetShownItemByItemIndex(itemidx)
end

local function SetListItemCount(self, itemTotalCount, resetPos)
  if self.unity_loopgridview == nil then
    return
  end
  if resetPos == nil then
    resetPos = false
  end
  self.unity_loopgridview:SetListItemCount(itemTotalCount, resetPos)
end

local function RefreshAllShownItem(self)
  if self.unity_loopgridview == nil then
    return
  end
  self.unity_loopgridview:RefreshAllShownItem()
end

local function SetInteractable(self, value)
  self.unity_loopgridview.interactable = value
end

local function MovePanelToItemByIndex(self, index, offset)
  self.unity_loopgridview:MovePanelToItemByIndex(index, offset)
end

local function StopMovement(self)
  if self.unity_loopgridview then
    self.unity_loopgridview.ScrollRect:StopMovement()
  end
end

local function GetViewPortWidth(self)
  return self.unity_loopgridview.ViewPortWidth
end

local function ClearAllItems(self)
  self.unity_loopgridview:ClearAllItems()
end

local function SetOnSnapItemFinished(self, callback)
  self.unity_loopgridview:SetOnSnapItemFinished(callback)
end

local function SetOnSnapNearestChanged(self, callback)
  self.unity_loopgridview:SetOnSnapNearestChanged(callback)
end

local function OnDrag(self, eventData)
  if self.unity_loopgridview then
    self.unity_loopgridview.ScrollRect:OnDrag(eventData)
    self.unity_loopgridview:OnDrag(eventData)
  end
end

local function OnBeginDrag(self, eventData)
  if self.unity_loopgridview then
    self.unity_loopgridview.ScrollRect:OnBeginDrag(eventData)
    self.unity_loopgridview:OnBeginDrag(eventData)
    self:StopMovement()
  end
end

local function OnEndDrag(self, eventData)
  if self.unity_loopgridview then
    self.unity_loopgridview.ScrollRect:OnEndDrag(eventData)
    self.unity_loopgridview:OnEndDrag(eventData)
  end
end

local function SetSnapTargetItemRowColumn(self, index)
  self.unity_loopgridview:SetSnapTargetItemRowColumn(index)
end

local function SetGridFixedGroupCount(self, type, count)
  if self.unity_loopgridview then
    self.unity_loopgridview:SetGridFixedGroupCount(type, count)
  end
end

local function GetRowColumnByItemIndex(self, index)
  if self.unity_loopgridview then
    return self.unity_loopgridview:GetRowColumnByItemIndex(index)
  end
end

local function GetItemIndexByRowColumn(self, row, column)
  if self.unity_loopgridview then
    return self.unity_loopgridview:GetItemIndexByRowColumn(row, column)
  end
end

local function RefreshItemByIndex(self, index)
  if self.unity_loopgridview then
    self.unity_loopgridview:RefreshItemByItemIndex(index)
  end
end

local function OnBeginDrag(self, eventData)
  if self.unity_loopgridview then
    self.unity_loopgridview:OnBeginDrag(eventData)
  end
end

local function OnEndDrag(self, eventData)
  if self.unity_loopgridview then
    self.unity_loopgridview:OnEndDrag(eventData)
  end
end

local function OnDrag(self, eventData)
  if self.unity_loopgridview then
    self.unity_loopgridview:OnDrag(eventData)
  end
end

UILoopGridView.OnCreate = OnCreate
UILoopGridView.OnDestroy = OnDestroy
UILoopGridView.InitGridView = InitGridView
UILoopGridView.InitGridViewParam = InitGridViewParam
UILoopGridView.SetOnBeginDragAction = SetOnBeginDragAction
UILoopGridView.SetOnDragingAction = SetOnDragingAction
UILoopGridView.SetOnEndDragAction = SetOnEndDragAction
UILoopGridView.SetOnListClickAction = SetOnListClickAction
UILoopGridView.GetShownItemByItemIndex = GetShownItemByItemIndex
UILoopGridView.SetListItemCount = SetListItemCount
UILoopGridView.RefreshAllShownItem = RefreshAllShownItem
UILoopGridView.SetInteractable = SetInteractable
UILoopGridView.MovePanelToItemByIndex = MovePanelToItemByIndex
UILoopGridView.StopMovement = StopMovement
UILoopGridView.GetViewPortWidth = GetViewPortWidth
UILoopGridView.ClearAllItems = ClearAllItems
UILoopGridView.SetOnSnapItemFinished = SetOnSnapItemFinished
UILoopGridView.SetOnSnapNearestChanged = SetOnSnapNearestChanged
UILoopGridView.OnDrag = OnDrag
UILoopGridView.OnBeginDrag = OnBeginDrag
UILoopGridView.OnEndDrag = OnEndDrag
UILoopGridView.SetSnapTargetItemRowColumn = SetSnapTargetItemRowColumn
UILoopGridView.SetGridFixedGroupCount = SetGridFixedGroupCount
UILoopGridView.GetRowColumnByItemIndex = GetRowColumnByItemIndex
UILoopGridView.GetItemIndexByRowColumn = GetItemIndexByRowColumn
UILoopGridView.RefreshItemByIndex = RefreshItemByIndex
UILoopGridView.OnBeginDrag = OnBeginDrag
UILoopGridView.OnEndDrag = OnEndDrag
UILoopGridView.OnDrag = OnDrag
return UILoopGridView
