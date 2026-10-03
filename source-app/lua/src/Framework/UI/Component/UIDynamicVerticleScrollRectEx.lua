local UIDynamicVerticleScrollRectEx = BaseClass("UIDynamicVerticleScrollRectEx", UIBaseContainer)
local base = UIBaseContainer
local UnityScrollRect = typeof(CS.DynamicVerticalScrollRectEx)

local function arabicMirrorCallback(go)
  if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() then
    CS.ArabicMirror.MirrorEntry(true, false, go)
  end
end

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.unity_UIDynamicVerticleScrollRectEx = self.gameObject:GetComponent(UnityScrollRect)
  if self.unity_UIDynamicVerticleScrollRectEx then
    self.unity_UIDynamicVerticleScrollRectEx:onArabicMirrorItemInstantiated("+", arabicMirrorCallback)
  end
  self.__onInstantiateItemCallbacks = {}
  self.__onDisplayItemCallbacks = {}
  self.__onClearItemCallbacks = {}
end

local function GetScrollRect(self)
  return self.unity_UIDynamicVerticleScrollRectEx
end

local function OnDestroy(self)
  for _, callback in ipairs(self.__onInstantiateItemCallbacks) do
    self.unity_UIDynamicVerticleScrollRectEx:onInstantiateItem("-", callback)
  end
  self.__onInstantiateItemCallbacks = nil
  for _, callback in ipairs(self.__onDisplayItemCallbacks) do
    self.unity_UIDynamicVerticleScrollRectEx:onDisplayItem("-", callback)
  end
  self.__onDisplayItemCallbacks = nil
  for _, callback in ipairs(self.__onClearItemCallbacks) do
    self.unity_UIDynamicVerticleScrollRectEx:onClearItem("-", callback)
  end
  self.__onClearItemCallbacks = nil
  self.unity_UIDynamicVerticleScrollRectEx:onArabicMirrorItemInstantiated("-", arabicMirrorCallback)
  self.unity_UIDynamicVerticleScrollRectEx:Clear()
  self.unity_UIDynamicVerticleScrollRectEx = nil
  base.OnDestroy(self)
end

local function SetEnable(self, value)
  self.unity_UIDynamicVerticleScrollRectEx.enabled = value
end

local function SetDatas(self, prefabIdxs)
  self.unity_UIDynamicVerticleScrollRectEx:SetDatas(prefabIdxs)
end

local function Clear(self)
  self.unity_UIDynamicVerticleScrollRectEx:Clear()
end

local function SetOverrideItemHeight(self, dataIdx, height)
  self.unity_UIDynamicVerticleScrollRectEx:SetOverrideItemHeight(dataIdx, height)
end

local function FindItemByDataIdx(self, dataIdx)
  return self.unity_UIDynamicVerticleScrollRectEx:FindItemByDataIdx(dataIdx)
end

local function GetScrollOffsetOfDataIdx(self, dataIdx, additionOffset)
  return self.unity_UIDynamicVerticleScrollRectEx:GetScrollOffsetOfDataIdx(dataIdx, additionOffset)
end

local function SetScrollOffset(self, offset)
  self.unity_UIDynamicVerticleScrollRectEx:SetScrollOffset(offset)
end

local function AddInstantiateItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRectEx:onInstantiateItem("+", callback)
  table.insert(self.__onInstantiateItemCallbacks, callback)
end

local function AddDisplayItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRectEx:onDisplayItem("+", callback)
  table.insert(self.__onDisplayItemCallbacks, callback)
end

local function AddClearItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRectEx:onClearItem("+", callback)
  table.insert(self.__onClearItemCallbacks, callback)
end

local function RemoveInstantiateItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRectEx:onInstantiateItem("-", callback)
  table.removebyvalue(self.__onInstantiateItemCallbacks, callback)
end

local function RemoveDisplayItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRectEx:onDisplayItem("-", callback)
  table.removebyvalue(self.__onDisplayItemCallbacks, callback)
end

local function RemoveClearItemListener(self, callback)
  self.unity_UIDynamicVerticleScrollRectEx:onClearItem("-", callback)
  table.removebyvalue(self.__onClearItemCallbacks, callback)
end

local function SetMovementType(self, movementType)
  self.unity_UIDynamicVerticleScrollRectEx.movementType = movementType
end

local function UpdateItems(self)
  self.unity_UIDynamicVerticleScrollRectEx:UpdateItems()
end

UIDynamicVerticleScrollRectEx.OnCreate = OnCreate
UIDynamicVerticleScrollRectEx.OnDestroy = OnDestroy
UIDynamicVerticleScrollRectEx.SetEnable = SetEnable
UIDynamicVerticleScrollRectEx.SetDatas = SetDatas
UIDynamicVerticleScrollRectEx.Clear = Clear
UIDynamicVerticleScrollRectEx.SetOverrideItemHeight = SetOverrideItemHeight
UIDynamicVerticleScrollRectEx.FindItemByDataIdx = FindItemByDataIdx
UIDynamicVerticleScrollRectEx.GetScrollOffsetOfDataIdx = GetScrollOffsetOfDataIdx
UIDynamicVerticleScrollRectEx.SetScrollOffset = SetScrollOffset
UIDynamicVerticleScrollRectEx.AddInstantiateItemListener = AddInstantiateItemListener
UIDynamicVerticleScrollRectEx.AddDisplayItemListener = AddDisplayItemListener
UIDynamicVerticleScrollRectEx.AddClearItemListener = AddClearItemListener
UIDynamicVerticleScrollRectEx.RemoveInstantiateItemListener = RemoveInstantiateItemListener
UIDynamicVerticleScrollRectEx.RemoveDisplayItemListener = RemoveDisplayItemListener
UIDynamicVerticleScrollRectEx.RemoveClearItemListener = RemoveClearItemListener
UIDynamicVerticleScrollRectEx.GetScrollRect = GetScrollRect
UIDynamicVerticleScrollRectEx.SetMovementType = SetMovementType
UIDynamicVerticleScrollRectEx.UpdateItems = UpdateItems
return UIDynamicVerticleScrollRectEx
