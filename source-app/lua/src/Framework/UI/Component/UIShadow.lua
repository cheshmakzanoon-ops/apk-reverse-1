local UIShadow = BaseClass("UIShadow", UIBaseContainer)
local base = UIBaseContainer
local UnityShadow = typeof(CS.UnityEngine.UI.Shadow)

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.unity_shadows = self.gameObject:GetComponents(UnityShadow)
end

local function OnDestroy(self)
  self.unity_shadows = nil
  base.OnDestroy(self)
end

local function Enable(self, value)
  if not IsNull(self.unity_shadows) and self.unity_shadows.Length > 0 then
    self.unity_shadows[0].enabled = value
  end
end

local function AllEnable(self, value)
  if not IsNull(self.unity_shadows) then
    for i = 0, self.unity_shadows.Length - 1 do
      self.unity_shadows[i].enabled = value
    end
  end
end

local function SetAllColor(self, value)
  if not IsNull(self.unity_shadows) then
    for i = 0, self.unity_shadows.Length - 1 do
      self.unity_shadows[i].effectColor = value
    end
  end
end

local function SetColorRGBA(self, r, g, b, a)
  if not IsNull(self.unity_shadows) then
    for i = 0, self.unity_shadows.Length - 1 do
      self.unity_shadows[i]:Set_color(r, g, b, a)
    end
  end
end

local function SetColorRGBA255(self, r, g, b, a)
  local input_r = r / 255
  local input_g = g / 255
  local input_b = b / 255
  local input_a = a / 255
  self:SetColorRGBA(input_r, input_g, input_b, input_a)
end

UIShadow.OnCreate = OnCreate
UIShadow.OnDestroy = OnDestroy
UIShadow.Enable = Enable
UIShadow.AllEnable = AllEnable
UIShadow.SetAllColor = SetAllColor
UIShadow.SetColorRGBA = SetColorRGBA
UIShadow.SetColorRGBA255 = SetColorRGBA255
return UIShadow
