local UIInput = BaseClass("UIInput", UIBaseComponent)
local base = UIBaseComponent
local UnityInputField = typeof(CS.UnityEngine.UI.InputField)
local UnityTMPInputField = typeof(CS.TMPro.TMP_InputField)
local UnityTMPInputFieldEx = typeof(CS.TMPro.TMP_InputFieldEx)
local ContentType = CS.UnityEngine.UI.InputField.ContentType
local CT_Standard = ContentType.Standard
local CT_IntegerNumber = ContentType.IntegerNumber
local CT_DecimalNumber = ContentType.DecimalNumber

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_uiinput = self.gameObject:GetComponent(UnityInputField)
  local tmpInputField = self.gameObject:GetComponent(UnityTMPInputField)
  if IsNull(tmpInputField) then
    tmpInputField = self.gameObject:GetComponent(UnityTMPInputFieldEx)
  end
  self.unity_tmpinput = tmpInputField
end

local function IsEnabled(self, isToggle)
  if not IsNull(self.unity_uiinput) then
    self.unity_uiinput.enabled = isToggle
  elseif not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput.enabled = isToggle
  end
end

local function GetText(self)
  if not IsNull(self.unity_uiinput) then
    return self.unity_uiinput.text
  elseif not IsNull(self.unity_tmpinput) then
    return self.unity_tmpinput.text
  end
end

local function SetText(self, text)
  if not IsNull(self.unity_uiinput) then
    self.unity_uiinput.text = text
  elseif not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput.text = text
  end
end

local function SetLocalText(self, text)
  if not IsNull(self.unity_uiinput) then
    self.unity_uiinput:SetLocalText(text)
  elseif not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput:SetLocalText(text)
  end
end

local function OnDestroy(self)
  if self.__onEndEdit ~= nil then
    self.unity_uiinput.onEndEdit:RemoveListener(self.__onEndEdit)
  end
  if self.__onTMPEndEdit ~= nil then
    self.unity_tmpinput.onEndEdit:RemoveListener(self.__onTMPEndEdit)
  end
  if self.__onValueChange ~= nil then
    self.unity_uiinput.onValueChanged:RemoveListener(self.__onValueChange)
  end
  if self.__onTMPValueChange ~= nil then
    self.unity_tmpinput.onValueChanged:RemoveListener(self.__onTMPValueChange)
  end
  if self.__onTMPPressEnter ~= nil then
    self.unity_tmpinput.onPressEnter:RemoveListener(self.__onTMPPressEnter)
    self.unity_tmpinput.isOnPressEnterRegistered = false
  end
  pcall(function()
    self.unity_uiinput.onEndEdit:Clear()
    self.unity_uiinput.onValueChanged:Clear()
    self.unity_tmpinput.onEndEdit:Clear()
    self.unity_tmpinput.onValueChanged:Clear()
  end)
  self.unity_uiinput = nil
  self.unity_tmpinput = nil
  self.__onEndEdit = nil
  self.__onTMPEndEdit = nil
  self.__onValueChange = nil
  self.__onTMPValueChange = nil
  self.__onTMPPressEnter = nil
  base.OnDestroy(self)
end

local function SetOnEndEdit(self, action)
  if not IsNull(self.unity_uiinput) then
    if action then
      if self.__onEndEdit then
        self.unity_uiinput.onEndEdit:RemoveListener(self.__onEndEdit)
      end
      self.__onEndEdit = action
      self.unity_uiinput.onEndEdit:AddListener(self.__onEndEdit)
    elseif self.__onEndEdit then
      self.unity_uiinput.onEndEdit:RemoveListener(self.__onEndEdit)
      self.__onEndEdit = nil
    end
  elseif not IsNull(self.unity_tmpinput) then
    if action then
      if self.__onTMPEndEdit then
        self.unity_tmpinput.onEndEdit:RemoveListener(self.__onTMPEndEdit)
      end
      self.__onTMPEndEdit = action
      self.unity_tmpinput.onEndEdit:AddListener(self.__onTMPEndEdit)
    elseif self.__onTMPEndEdit then
      self.unity_tmpinput.onEndEdit:RemoveListener(self.__onTMPEndEdit)
      self.__onTMPEndEdit = nil
    end
  end
end

local function SetOnValueChange(self, action)
  if not IsNull(self.unity_uiinput) then
    if action then
      if self.__onValueChange then
        self.unity_uiinput.onValueChanged:RemoveListener(self.__onValueChange)
      end
      self.__onValueChange = action
      self.unity_uiinput.onValueChanged:AddListener(self.__onValueChange)
    elseif self.__onValueChange then
      self.unity_uiinput.onValueChanged:RemoveListener(self.__onValueChange)
      self.__onValueChange = nil
    end
  elseif not IsNull(self.unity_tmpinput) then
    if action then
      if self.__onTMPValueChange then
        self.unity_tmpinput.onValueChanged:RemoveListener(self.__onTMPValueChange)
      end
      self.__onTMPValueChange = action
      self.unity_tmpinput.onValueChanged:AddListener(self.__onTMPValueChange)
    elseif self.__onTMPValueChange then
      self.unity_tmpinput.onValueChanged:RemoveListener(self.__onTMPValueChange)
      self.__onTMPValueChange = nil
    end
  end
end

local function SetOnPressEnter(self, action)
  if not IsNull(self.unity_tmpinput) then
    if action then
      if self.__onTMPPressEnter then
        self.unity_tmpinput.onPressEnter:RemoveListener(self.__onTMPPressEnter)
      end
      self.__onTMPPressEnter = action
      self.unity_tmpinput.onPressEnter:AddListener(self.__onTMPPressEnter)
      self.unity_tmpinput.isOnPressEnterRegistered = true
    elseif self.__onTMPPressEnter then
      self.unity_tmpinput.onPressEnter:RemoveListener(self.__onTMPPressEnter)
      self.unity_tmpinput.isOnPressEnterRegistered = false
      self.__onTMPPressEnter = nil
    end
  end
end

local function SetInteractable(self, value)
  if not IsNull(self.unity_uiinput) then
    self.unity_uiinput.interactable = value
  elseif not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput.interactable = value
  end
end

local function SetEnable(self, value)
  if not IsNull(self.unity_uiinput) then
    self.unity_uiinput.enabled = value
  elseif not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput.enabled = value
  end
end

local function Select(self)
  if not IsNull(self.unity_uiinput) then
    self.unity_uiinput:Select()
    self.unity_uiinput:ActivateInputField()
  elseif not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput:Select()
    self.unity_tmpinput:ActivateInputField()
  end
end

local function SetCharacterLimit(self, limit)
  if not IsNull(self.unity_uiinput) then
    self.unity_uiinput.characterLimit = limit
  elseif not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput.characterLimit = limit
  end
end

function UIInput:SetContentType(contentType)
  if not IsNull(self.unity_uiinput) then
    if contentType == 0 then
      self.unity_uiinput.contentType = CT_Standard
    elseif contentType == 2 then
      self.unity_uiinput.contentType = CT_IntegerNumber
    elseif contentType == 3 then
      self.unity_uiinput.contentType = CT_DecimalNumber
    end
  end
end

local function InsertStrInCaretPos(self, insertStr)
  if not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput:InsertStrInCaretPos(insertStr)
  end
end

local function ForceAdjustRectTransformRelativeToViewport(self)
  if not IsNull(self.unity_tmpinput) then
    self.unity_tmpinput:ForceAdjustRectTransformRelativeToViewport()
  end
end

UIInput.OnCreate = OnCreate
UIInput.GetText = GetText
UIInput.SetText = SetText
UIInput.SetOnEndEdit = SetOnEndEdit
UIInput.SetOnValueChange = SetOnValueChange
UIInput.SetOnPressEnter = SetOnPressEnter
UIInput.OnDestroy = OnDestroy
UIInput.SetInteractable = SetInteractable
UIInput.SetEnable = SetEnable
UIInput.IsEnabled = IsEnabled
UIInput.Select = Select
UIInput.SetLocalText = SetLocalText
UIInput.SetCharacterLimit = SetCharacterLimit
UIInput.InsertStrInCaretPos = InsertStrInCaretPos
UIInput.ForceAdjustRectTransformRelativeToViewport = ForceAdjustRectTransformRelativeToViewport
return UIInput
