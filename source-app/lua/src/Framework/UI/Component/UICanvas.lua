local UICanvas = BaseClass("UICanvas", UIBaseComponent)
local base = UIBaseComponent
local UnityCanvas = typeof(CS.UnityEngine.Canvas)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_canvas = self.gameObject:GetComponent(UnityCanvas)
end

local function OnDestroy(self)
  self.unity_canvas = nil
  base.OnDestroy(self)
end

local function SetOverrideSorting(self, value)
  self.unity_canvas.overrideSorting = value
end

local function SetSortingOrder(self, value)
  self.unity_canvas.sortingOrder = value
end

local function SetSortingLayerName(self, value)
  self.unity_canvas.sortingLayerName = value
end

UICanvas.OnCreate = OnCreate
UICanvas.OnDestroy = OnDestroy
UICanvas.SetOverrideSorting = SetOverrideSorting
UICanvas.SetSortingOrder = SetSortingOrder
UICanvas.SetSortingLayerName = SetSortingLayerName
return UICanvas
