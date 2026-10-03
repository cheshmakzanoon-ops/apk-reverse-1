local UIDropdown = BaseClass("UIDropdown", UIBaseContainer)
local base = UIBaseContainer
local UnityDropdown = typeof(CS.UnityEngine.UI.Dropdown)
local TMP_Dropdown = typeof(CS.TMPro.TMP_Dropdown)

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.unity_dropdown = self.gameObject:GetComponent(UnityDropdown)
  self.tmp_dropdown = self.gameObject:GetComponent(TMP_Dropdown)
end

local function OnDestroy(self)
  if self.__onvaluechanged ~= nil then
    if not IsNull(self.unity_dropdown) then
      self.unity_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
    end
    if not IsNull(self.tmp_dropdown) then
      self.tmp_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
    end
  end
  if not IsNull(self.unity_dropdown) then
    pcall(function()
      self.unity_dropdown.onValueChanged:Clear()
    end)
  end
  if not IsNull(self.tmp_dropdown) then
    pcall(function()
      self.tmp_dropdown.onValueChanged:Clear()
      self.tmp_dropdown.isInvokeCbOnValueUnchanged = false
    end)
    pcall(function()
      self.tmp_dropdown:UnregisterCreateDropdownListCallBack()
    end)
  end
  self.unity_dropdown = nil
  self.tmp_dropdown = nil
  self.__onvaluechanged = nil
  base.OnDestroy(self)
end

local function SetText(self, value)
  if not IsNull(self.unity_dropdown) then
    self.unity_dropdown.captionText.text = value
  end
  if not IsNull(self.tmp_dropdown) then
    self.tmp_dropdown.captionText.text = value
  end
end

local function GetText(self)
  if not IsNull(self.unity_dropdown) then
    return self.unity_dropdown.captionText.text
  end
  if not IsNull(self.tmp_dropdown) then
    return self.tmp_dropdown.captionText.text
  end
end

local function Clear(self)
  if not IsNull(self.unity_dropdown) then
    self.unity_dropdown.options:Clear()
  end
  if not IsNull(self.tmp_dropdown) then
    self.tmp_dropdown.options:Clear()
  end
end

local function Add(self, value)
  if not IsNull(self.unity_dropdown) then
    self.unity_dropdown.options:Add(value)
  end
  if not IsNull(self.tmp_dropdown) then
    self.tmp_dropdown.options:Add(value)
  end
end

local function SetOnValueChanged(self, action)
  if not IsNull(self.unity_dropdown) then
    if action then
      if self.__onvaluechanged then
        self.unity_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
      end
      self.__onvaluechanged = action
      self.unity_dropdown.onValueChanged:AddListener(self.__onvaluechanged)
    elseif self.__onvaluechanged then
      self.unity_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
      self.__onvaluechanged = nil
    end
  end
  if not IsNull(self.tmp_dropdown) then
    if action then
      if self.__onvaluechanged then
        self.tmp_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
      end
      self.__onvaluechanged = action
      self.tmp_dropdown.onValueChanged:AddListener(self.__onvaluechanged)
    elseif self.__onvaluechanged then
      self.tmp_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
      self.__onvaluechanged = nil
    end
  end
end

local function SetValue(self, value)
  if not IsNull(self.unity_dropdown) then
    self.unity_dropdown.value = value
  end
  if not IsNull(self.tmp_dropdown) then
    self.tmp_dropdown.value = value
  end
end

local function GetValue(self)
  if not IsNull(self.unity_dropdown) then
    return self.unity_dropdown.value
  end
  if not IsNull(self.tmp_dropdown) then
    return self.tmp_dropdown.value
  end
end

local function SetInteractable(self, value)
  if not IsNull(self.unity_dropdown) then
    self.unity_dropdown.interactable = value
  end
  if not IsNull(self.tmp_dropdown) then
    self.tmp_dropdown.interactable = value
  end
end

local function RegisterCreateDropdownListCallBack(self, callBack)
  if not IsNull(self.tmp_dropdown) then
    self.tmp_dropdown:RegisterCreateDropdownListCallBack(callBack)
  end
end

local function SetValueWithoutNotify(self, value)
  if not IsNull(self.tmp_dropdown) then
    self.tmp_dropdown:SetValueWithoutNotify(value)
  end
end

local function SetIsInvokeCbOnValueUnchanged(self, bool)
  if not IsNull(self.tmp_dropdown) then
    self.tmp_dropdown.isInvokeCbOnValueUnchanged = bool
  end
end

UIDropdown.OnCreate = OnCreate
UIDropdown.OnDestroy = OnDestroy
UIDropdown.SetText = SetText
UIDropdown.GetText = GetText
UIDropdown.Clear = Clear
UIDropdown.Add = Add
UIDropdown.SetOnValueChanged = SetOnValueChanged
UIDropdown.SetValue = SetValue
UIDropdown.GetValue = GetValue
UIDropdown.SetInteractable = SetInteractable
UIDropdown.RegisterCreateDropdownListCallBack = RegisterCreateDropdownListCallBack
UIDropdown.SetValueWithoutNotify = SetValueWithoutNotify
UIDropdown.SetIsInvokeCbOnValueUnchanged = SetIsInvokeCbOnValueUnchanged
return UIDropdown
