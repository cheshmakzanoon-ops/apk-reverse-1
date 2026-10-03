local UIInputCommonType = BaseClass("UIInputCommonType", UIBaseComponent)
local base = UIBaseComponent
local UnityInputField = typeof(CS.UnityEngine.UI.InputField)
local UnityTMPInputField = typeof(CS.TMPro.TMP_InputField)
local UnityTMPInputFieldEx = typeof(CS.TMPro.TMP_InputFieldEx)
local MobileInputField = typeof(CS.Mopsicus.Plugins.MobileInputField)

local function OnCreate(self)
  base.OnCreate(self)
  self.isMobile = false
  self.inputMsgPCObj = self.transform:Find("inputMsgPC").gameObject
  self.inputMsgMobileObj = self.transform:Find("inputMsgMobile").gameObject
  self.inputMsgPC = self.inputMsgPCObj:GetComponent(UnityTMPInputFieldEx)
  self.inputMsgMobile = self.inputMsgMobileObj:GetComponent(MobileInputField)
  self.mobilId = self.inputMsgMobile:GetMobilId()
  self.inputMsgMobileInputField = self.inputMsgMobileObj:GetComponent(UnityInputField)
  self.inputMsgUse = nil
  self.isMobile = self:IsOnAndroidOrIOS()
  self.inputMsgPCObj:SetActive(not self.isMobile)
  self.inputMsgMobileObj:SetActive(self.isMobile)
  self.inputMsgUse = self.isMobile and self.inputMsgMobile or self.inputMsgPC
end

local function OnDestroy(self)
  if self.__onEndEdit ~= nil then
    local useObj
    if self.isMobile then
      useObj = self.inputMsgMobileInputField
    else
      useObj = self.inputMsgPC
    end
    if useObj then
      useObj.onEndEdit:RemoveListener(self.__onEndEdit)
    end
  end
  if self.__onValueChange ~= nil then
    self.inputMsgUse.onValueChanged:RemoveListener(self.__onValueChange)
  end
  if self.inputMsgPC then
    self.inputMsgPC.OnPaste = nil
  end
  self.isMobile = nil
  self.inputMsgPCObj = nil
  self.inputMsgMobileObj = nil
  self.inputMsgPC = nil
  self.inputMsgMobile = nil
  self.mobilId = nil
  self.inputMsgUse = nil
  self.__onEndEdit = nil
  self.__onValueChange = nil
  base.OnDestroy(self)
end

local function GetText(self)
  local text = ""
  if self.isMobile then
    text = self.inputMsgMobile.Text
  else
    text = self.inputMsgPC.text
  end
  return text
end

local function SetText(self, text)
  if self.isMobile then
    self.inputMsgMobile.Text = text
  else
    self.inputMsgPC.text = text
  end
end

local function SetOnValueChange(self, action)
  if not IsNull(self.inputMsgUse) then
    if action then
      if self.__onValueChange then
        self.inputMsgUse.onValueChanged:RemoveListener(self.__onValueChange)
      end
      self.__onValueChange = action
      self.inputMsgUse.onValueChanged:AddListener(self.__onValueChange)
    elseif self.__onValueChange then
      self.inputMsgUse.onValueChanged:RemoveListener(self.__onValueChange)
      self.__onValueChange = nil
    end
  end
end

local function SetOnEndEdit(self, action)
  local useObj
  if self.isMobile then
    useObj = self.inputMsgMobileInputField
  else
    useObj = self.inputMsgPC
  end
  if useObj then
    if action then
      if self.__onEndEdit then
        useObj.onEndEdit:RemoveListener(self.__onEndEdit)
      end
      self.__onEndEdit = action
      useObj.onEndEdit:AddListener(self.__onEndEdit)
    elseif self.__onEndEdit then
      useObj.onEndEdit:RemoveListener(self.__onEndEdit)
      self.__onEndEdit = nil
    end
  end
end

local function SetCharacterLimit(self, limit)
  if self.isMobile then
    return
  end
  if not IsNull(self.inputMsgUse) then
    self.inputMsgUse.characterLimit = limit
  end
end

local function Select(self, state)
  if not self.isMobile then
    if state then
      self.inputMsgPC:OnSelect()
    else
      self.inputMsgPC:OnDeselect()
    end
  else
    self.inputMsgMobile:SetFocus(state)
  end
end

function UIInputCommonType:SetCaretPosition(index)
  if self.isMobile then
    local selection = self.inputMsgMobile:GetSelection()
    selection.start = index
    selection.length = 0
    self.inputMsgMobile:SetSelection(selection)
  elseif self.inputMsgPC then
    self.inputMsgPC.selectionStringAnchorPosition = index
    self.inputMsgPC.selectionStringFocusPosition = index
  end
end

function UIInputCommonType:GetCaretPosition()
  local start, finish = 0, 0
  if self.isMobile then
    local selection = self.inputMsgMobile:GetSelection()
    start = selection.start
    finish = selection.start + selection.length
  elseif self.inputMsgPC then
    start = self.inputMsgPC.selectionStringAnchorPosition
    finish = self.inputMsgPC.selectionStringFocusPosition
  end
  return start, finish
end

function UIInputCommonType:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function UIInputCommonType:SetHolderColor(holderColor, textColor, mobilBackGroundColor)
  if self.isMobile then
    self.inputMsgMobile:SetMobilPlaceholderColor(holderColor.r, holderColor.g, holderColor.b, holderColor.a)
    self.inputMsgMobile:SetMobilTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
  else
    self.inputMsgPC.placeholder.color = Color.New(holderColor.r, holderColor.g, holderColor.b, holderColor.a)
    self.inputMsgPC.textComponent.color = Color.New(textColor.r, textColor.g, textColor.b, textColor.a)
  end
end

function UIInputCommonType:TrySetPCTextPasteLister(onpasteAct)
  if not self.isMobile and self.inputMsgPC then
    self.inputMsgPC.OnPaste = onpasteAct
  end
end

UIInputCommonType.OnCreate = OnCreate
UIInputCommonType.GetText = GetText
UIInputCommonType.SetText = SetText
UIInputCommonType.OnDestroy = OnDestroy
UIInputCommonType.SetOnValueChange = SetOnValueChange
UIInputCommonType.SetOnEndEdit = SetOnEndEdit
UIInputCommonType.SetCharacterLimit = SetCharacterLimit
UIInputCommonType.Select = Select
return UIInputCommonType
