local UIGradient = BaseClass("UIGradient", UIBaseComponent)
local base = UIBaseComponent
local UnityGradient = typeof(CS.UnityEngine.UI.Gradient)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_gradient = self.gameObject:GetComponent(UnityGradient)
end

local function OnDestroy(self)
  self.unity_gradient = nil
  base.OnDestroy(self)
end

local function SetOffset(self, offset)
  if not IsNull(self.unity_gradient) then
    self.unity_gradient.Offset = offset
  end
end

local function Enable(self, value)
  if not IsNull(self.unity_gradient) then
    self.unity_gradient.enabled = value
  end
end

UIGradient.OnCreate = OnCreate
UIGradient.OnDestroy = OnDestroy
UIGradient.SetOffset = SetOffset
UIGradient.Enable = Enable
return UIGradient
