local base = UIBaseView
local SeasonPhotoMessageView = BaseClass("SeasonPhotoMessageView", base)
local btnClose_path = "PopUpTitle/CloseBtn"
local btnPanel_path = "panel"
local btnSend_path = "PopUpTitle/BtnSend"
local input_path = "PopUpTitle/InputField"
local textLimit_path = "PopUpTitle/InputField/TextLimit"
local pop_up_title_path = "PopUpTitle"

local function CalcKeyboardHeight(height)
  local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
  if layer then
    local uiFullHeight = layer.rectTransform.rect.height
    local keyboardHeight = uiFullHeight * height / Screen.height
    return uiFullHeight, keyboardHeight
  end
  return uiFullHeight, 0
end

local function OnShowKeyboard(self, isShow, height)
  if not ComponentIsValid(self.root) then
    CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
    CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = nil
    return
  end
  if isShow ~= true or height == nil or height == 0 then
    self.root:SetLocalPositionXYZ(0, 0, 0)
    return
  end
  local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
  if layer then
    local uiFullHeight = layer.rectTransform.rect.height
    local keyboardHeight = uiFullHeight * height / Screen.height
    if CS.CommonUtils.IsDebug() then
      Logger.Log(string.format("uiFullHeight = %s, keyboardHeight = %s", uiFullHeight, keyboardHeight))
    end
    if 0 < keyboardHeight then
      local delta = 530 + keyboardHeight * 2 - uiFullHeight
      if 0 < delta then
        self.root:SetLocalPositionXYZ(0, delta / 2, 0)
        if CS.CommonUtils.IsDebug() then
          Logger.Log(string.format("delta = %s", delta))
        end
      end
    end
  end
end

function SeasonPhotoMessageView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonPhotoMessageView:OnDestroy()
  CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonPhotoMessageView:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, pop_up_title_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.btnPanel = self:AddComponent(UIButton, btnPanel_path)
  self.btnSend = self:AddComponent(UIButton, btnSend_path)
  self.input = self:AddComponent(UIInput, input_path)
  self.textLimit = self:AddComponent(UIText, textLimit_path)
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnSend:SetOnClick(BindCallback(self, self.Send))
  self.input:SetOnValueChange(function(str)
    if not self:IsOnAndroidOrIOS() then
      self:OnInputMsgChanged(str)
    end
  end)
  if self:IsOnAndroidOrIOS() and self.input then
    self.inputMsgMobile = self.input.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    if self.inputMsgMobile then
      self.inputMsgMobile.enabled = true
      self.mobilId = self.inputMsgMobile:GetMobilId()
      
      function self.inputMsgMobile.OnShowKeyboard(mobilId, isShow, height)
        if mobilId == nil or mobilId == 0 or mobilId == self.mobilId then
          OnShowKeyboard(self, isShow, height)
        end
      end
      
      function self.inputMsgMobile.OnTextChangeFromPlatform(str)
        self:OnInputMsgChanged(str)
      end
      
      if CS.SDKManager.IS_UNITY_ANDROID() then
        self.inputMsgMobile:SetMaxLine(500)
      elseif CS.SDKManager.IS_UNITY_IOS() then
        self.inputMsgMobile:SetMaxLine(1)
      end
    end
    
    function CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard(mobilId, isShow, height)
      OnShowKeyboard(self, isShow, height)
    end
  end
  self.season, self.allianceId = self:GetUserData()
  self:RefreshView()
  self.root:SetLocalPositionXYZ(0, 0, 0)
end

function SeasonPhotoMessageView:ComponentDestroy()
  self.btnClose = nil
  self.btnPanel = nil
  self.btnSend = nil
  self.input = nil
  self.textLimit = nil
  self.root = nil
end

function SeasonPhotoMessageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoCommentView, self.SeasonPhotoCommentView)
end

function SeasonPhotoMessageView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoCommentView, self.SeasonPhotoCommentView)
  base.OnRemoveListener(self)
end

function SeasonPhotoMessageView:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function SeasonPhotoMessageView:RefreshView()
  if self.textLimit == nil then
    return
  end
  local photoInfo, userRecord = DataCenter.SeasonPhotoManager:GetSeasonPhotoData(self.season, self.allianceId)
  local config = photoInfo and photoInfo:GetConfigData()
  self.limit = config and config.character_limit or 50
  self.input:SetCharacterLimit(self.limit)
  self.input:SetText("")
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile.Text = ""
  end
  self.textLimit:SetText(string.format("%d/%d", 0, self.limit))
end

function SeasonPhotoMessageView:Send()
  local text
  if self:IsOnAndroidOrIOS() then
    text = self.inputMsgMobile.Text
  else
    text = self.input:GetText()
  end
  if string.match(text, "^%s*$") then
    text = ""
  end
  if string.IsNullOrEmpty(text) then
    UIUtil.ShowTipsId("error_tips_empty_object")
    return
  end
  DataCenter.SeasonPhotoManager:SendComment(self.season, self.allianceId, text)
end

function SeasonPhotoMessageView:SeasonPhotoCommentView(id)
  if DataCenter.SeasonPhotoManager:GetPhotoId(self.season, self.allianceId) ~= id then
    return
  end
  self.ctrl:CloseSelf()
end

function SeasonPhotoMessageView:OnInputMsgChanged(str)
  if self.textLimit == nil then
    return
  end
  local text = str
  local count = string.word_count(text)
  if count > self.limit then
    local temp = string.SubStr(str, 1, self.limit)
    count = self.limit
    self.input:SetText(temp)
    if self:IsOnAndroidOrIOS() then
      self.inputMsgMobile.Text = temp
      local rangeInt = self.inputMsgMobile:GetSelection()
      self.inputMsgMobile:SetSelection(rangeInt)
    end
  end
  self.textLimit:SetText(string.format("%d/%d", count, self.limit))
end

return SeasonPhotoMessageView
