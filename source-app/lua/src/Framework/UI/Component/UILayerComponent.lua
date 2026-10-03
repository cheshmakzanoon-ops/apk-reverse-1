local UILayerComponent = BaseClass("UILayerComponent", UIBaseComponent)
local base = UIBaseComponent
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local LayerMask = CS.UnityEngine.LayerMask

local function OnCreate(self)
  base.OnCreate(self)
  self.__name = self.__var_arg
  self.gameObject.layer = LayerMask.NameToLayer("UI")
  local tfx = self.gameObject:GetComponent(RectTransform)
  tfx:Set_localScale(1, 1, 1)
  tfx:Set_offsetMin(0, 0)
  tfx:Set_offsetMax(0, 0)
  tfx:Set_anchorMin(0, 0)
  tfx:Set_anchorMax(1, 1)
end

local function GetActiveInHierarchy(self)
  return self.activeSelf
end

UILayerComponent.OnCreate = OnCreate
UILayerComponent.GetActiveInHierarchy = GetActiveInHierarchy
return UILayerComponent
