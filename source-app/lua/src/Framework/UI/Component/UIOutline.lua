local UIOutline = BaseClass("UIOutline", UIBaseComponent)
local base = UIBaseComponent
local UnityOutline = typeof(CS.UnityEngine.UI.Outline)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_outline = self.gameObject:GetComponent(UnityOutline)
end

local function OnDestroy(self)
  self.unity_outline = nil
  base.OnDestroy(self)
end

local function SetColor(self, value)
  if not IsNull(self.unity_outline) then
    self.unity_outline.effectColor = value
  end
end

local function Enable(self, value)
  if not IsNull(self.unity_outline) then
    self.unity_outline.enabled = value
  end
end

local function SetColorRGBA(self, r, g, b, a)
  if not IsNull(self.unity_outline) then
    self.unity_outline:Set_color(r, g, b, a)
  end
end

local function SetColorRGBA255(self, r, g, b, a)
  if not IsNull(self.unity_outline) then
    local input_r = r / 255
    local input_g = g / 255
    local input_b = b / 255
    local input_a = a / 255
    self.unity_outline:Set_color(input_r, input_g, input_b, input_a)
  end
end

local function SetColor(self, value)
  if not IsNull(self.unity_outline) then
    self.unity_outline.effectColor = value
  end
end

UIOutline.OnCreate = OnCreate
UIOutline.OnDestroy = OnDestroy
UIOutline.SetColor = SetColor
UIOutline.Enable = Enable
UIOutline.SetColorRGBA = SetColorRGBA
UIOutline.SetColorRGBA255 = SetColorRGBA255
UIOutline.SetColor = SetColor
return UIOutline
