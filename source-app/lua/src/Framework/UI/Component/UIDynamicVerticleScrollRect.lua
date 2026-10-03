local UIDynamicVerticleScrollRect = BaseClass("UIDynamicVerticleScrollRect", UIBaseContainer)
local base = UIBaseContainer
local UnityScrollRect = typeof(CS.DynamicVerticalScrollRect)

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.unity_UIDynamicVerticleScrollRect = self.gameObject:GetComponent(UnityScrollRect)
  self.__onInstantiateItemCallbacks = {}
  self.__onDisplayItemCallbacks = {}
  self.__onClearItemCallbacks = {}
end

local function GetScrollRect(self)
  return self.unity_UIDynamicVerticleScrollRect
end

local function OnDestroy(self)
  for _, callback in ipairs(self.__onInstantiateItemCallbacks) do
    self.unity_UIDynamicVerticleScrollRect:onInstantiateItem("-", callback)
  end
  self.__onInstantiateItemCallbacks = nil
  for _, callback in ipairs(self.__onDisplayItemCallbacks) do
    self.unity_UIDynamicVerticleScrollRect:onDisplayItem("-", callback)
  end
  self.__onDisplayItemCallbacks = nil
  for _, callback in ipairs(self.__onClearItemCallbacks) do
    self.unity_UIDynamicVerticleScrollRect:onClearItem("-", callback)
  end
  self.__onClearItemCallbacks = nil
  self.unity_UIDynamicVerticleScrollRect:Clear()
  self.unity_UIDynamicVerticleScrollRect = nil
  base.OnDestroy(self)
end

local function SetEnable(self, value)
  self.unity_UIDynamicVerticleScrollRect.enabled = value
end

local function SetDatas(self, prefabIdxs)
  self.unity_UIDynamicVerticleScrollRect:SetDatas(prefabIdxs)
end

local function SetPaddingXY(self, paddingX, paddingY)
  self.unity_UIDynamicVerticleScrollRect.padding = Vector2(paddingX, paddingY)
end

local function SetMarginXY(self, marginX, marginY)
  self.unity_UIDynamicVerticleScrollRect.margin = Vector2(marginX, marginY)
end

local function SetItemSizeXY(self, itemSizeX, itemSizeY)
  self.unity_UIDynamicVerticleScrollRect.itemSize = Vector2(itemSizeX, itemSizeY)
end

local function Clear(self)
  self.unity_UIDynamicVerticleScrollRect:Clear()
end

local function FindItemByDataIdx(self, dataIdx)
  return self.unity_UIDynamicVerticleScrollRect:FindItemByDataIdx(dataIdx)
end

local function GetScrollOffsetOfDataIdx(self, dataIdx, additionOffset)
  return self.unity_UIDynamicVerticleScrollRect:GetScrollOffsetOfDataIdx(dataIdx, additionOffset)
end

local function SetScrollOffset(self, offset)
  self.unity_UIDynamicVerticleScrollRect:SetScrollOffset(offset)
end

local function AddInstantiateItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRect:onInstantiateItem("+", callback)
  table.insert(self.__onInstantiateItemCallbacks, callback)
end

local function AddDisplayItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRect:onDisplayItem("+", callback)
  table.insert(self.__onDisplayItemCallbacks, callback)
end

local function AddClearItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRect:onClearItem("+", callback)
  table.insert(self.__onClearItemCallbacks, callback)
end

local function RemoveInstantiateItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRect:onInstantiateItem("-", callback)
  table.removebyvalue(self.__onInstantiateItemCallbacks, callback)
end

local function RemoveDisplayItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRect:onDisplayItem("-", callback)
  table.removebyvalue(self.__onDisplayItemCallbacks, callback)
end

local function RemoveClearItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRect:onClearItem("-", callback)
  table.removebyvalue(self.__onClearItemCallbacks, callback)
end

local function SetMovementType(self, movementType)
  self.unity_UIDynamicVerticleScrollRect.movementType = movementType
end

local function UpdateItems(self)
  self.unity_UIDynamicVerticleScrollRect:UpdateItems()
end

UIDynamicVerticleScrollRect.OnCreate = OnCreate
UIDynamicVerticleScrollRect.OnDestroy = OnDestroy
UIDynamicVerticleScrollRect.SetEnable = SetEnable
UIDynamicVerticleScrollRect.SetDatas = SetDatas
UIDynamicVerticleScrollRect.SetPaddingXY = SetPaddingXY
UIDynamicVerticleScrollRect.SetMarginXY = SetMarginXY
UIDynamicVerticleScrollRect.SetItemSizeXY = SetItemSizeXY
UIDynamicVerticleScrollRect.Clear = Clear
UIDynamicVerticleScrollRect.FindItemByDataIdx = FindItemByDataIdx
UIDynamicVerticleScrollRect.GetScrollOffsetOfDataIdx = GetScrollOffsetOfDataIdx
UIDynamicVerticleScrollRect.SetScrollOffset = SetScrollOffset
UIDynamicVerticleScrollRect.AddInstantiateItemListener = AddInstantiateItemListener
UIDynamicVerticleScrollRect.AddDisplayItemListener = AddDisplayItemListener
UIDynamicVerticleScrollRect.AddClearItemListener = AddClearItemListener
UIDynamicVerticleScrollRect.RemoveInstantiateItemListener = RemoveInstantiateItemListener
UIDynamicVerticleScrollRect.RemoveDisplayItemListener = RemoveDisplayItemListener
UIDynamicVerticleScrollRect.RemoveClearItemListener = RemoveClearItemListener
UIDynamicVerticleScrollRect.GetScrollRect = GetScrollRect
UIDynamicVerticleScrollRect.SetMovementType = SetMovementType
UIDynamicVerticleScrollRect.UpdateItems = UpdateItems
return UIDynamicVerticleScrollRect
