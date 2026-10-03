local UISlider = BaseClass("UISlider", UIBaseComponent)
local base = UIBaseComponent
local UnitySlider = typeof(CS.UnityEngine.UI.Slider)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_uislider = self.gameObject:GetComponent(UnitySlider)
end

local function GetValue(self)
  return self.unity_uislider.value
end

local function SetValue(self, value)
  self.unity_uislider.value = value
end

local function SetValueWithoutNotify(self, value)
  self.unity_uislider:SetValueWithoutNotify(value)
end

local function SetOnValueChanged(self, action)
  if action then
    if self.__onvaluechanged then
      self.unity_uislider.onValueChanged:RemoveListener(self.__onvaluechanged)
    end
    self.__onvaluechanged = action
    self.unity_uislider.onValueChanged:AddListener(self.__onvaluechanged)
  elseif self.__onvaluechanged then
    self.unity_uislider.onValueChanged:RemoveListener(self.__onvaluechanged)
    self.__onvaluechanged = nil
  end
end

local function OnDestroy(self)
  if self.__onvaluechanged ~= nil then
    self.unity_uislider.onValueChanged:RemoveListener(self.__onvaluechanged)
  end
  pcall(function()
    self.unity_uislider.onValueChanged:Invoke()
  end)
  self.unity_uislider = nil
  self.__onvaluechanged = nil
  base.OnDestroy(self)
end

local function SetInteractable(self, value)
  self.unity_uislider.interactable = value
end

local function DOValue(self, endValue, duration, callBack)
  if callBack then
    return self.unity_uislider:DOValue(endValue, duration):OnComplete(function()
      callBack()
    end)
  else
    return self.unity_uislider:DOValue(endValue, duration)
  end
end

local function IsWholeNumbers(self)
  return self.unity_uislider.wholeNumbers
end

local function SetMax(self, max)
  self.unity_uislider.maxValue = max
end

local function SetMin(self, min)
  self.unity_uislider.minValue = min
end

local function GetMax(self)
  return self.unity_uislider.maxValue
end

local function GetMin(self)
  return self.unity_uislider.minValue
end

UISlider.OnCreate = OnCreate
UISlider.GetValue = GetValue
UISlider.SetValue = SetValue
UISlider.SetOnValueChanged = SetOnValueChanged
UISlider.OnDestroy = OnDestroy
UISlider.SetInteractable = SetInteractable
UISlider.DOValue = DOValue
UISlider.SetValueWithoutNotify = SetValueWithoutNotify
UISlider.IsWholeNumbers = IsWholeNumbers
UISlider.SetMax = SetMax
UISlider.SetMin = SetMin
UISlider.GetMax = GetMax
UISlider.GetMin = GetMin
return UISlider
