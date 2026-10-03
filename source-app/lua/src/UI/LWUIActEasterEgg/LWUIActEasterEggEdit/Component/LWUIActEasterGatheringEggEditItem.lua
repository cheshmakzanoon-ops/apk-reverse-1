local LWUIActEasterGatheringEggEditItem = BaseClass("LWUIActEasterGatheringEggEditItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local M = LWUIActEasterGatheringEggEditItem

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function M:OnDestroy()
  self:StopTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
  self.isThrowing = false
  self:SetKeyboardClickpanelBtnState(true)
end

function M:OnDisable()
  base.OnDisable(self)
  self:SetKeyboardClickpanelBtnState(false)
end

function M:ComponentDefine()
  self.textTipsTxt = self:AddComponent(UITextMeshProUGUIEx, "TipsNode/Bg/TipsTxt")
  self.btnRobot = self:AddComponent(UIButton, "Robot")
  self.btnRobot:SetOnClick(function()
    self:OnBtnRobotClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Title")
  self.textWorldNumLimit = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/WorldNumLimit")
  self.btnThrow = self:AddComponent(UIButton, "BtnThrow")
  self.btnThrow:SetOnClick(function()
    self:OnBtnThrowClick()
  end)
  self.btnThrowText = self:AddComponent(UITextMeshProUGUIEx, "BtnThrow/LW_Btn_Common_New_Base/BtnText")
  self.inputHolder = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/InputFieldEx/TextArea/Placeholder")
  self.textTitle:SetLocalText("activity_99144_ui_15")
  self.btnThrowText:SetLocalText("activity_99144_ui_16")
  self.compBg = self:AddComponent(UIBaseContainer, "AnswerNode/Content/InputFieldEx/Bg")
  self.inputFieldText = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/InputFieldEx/TextArea/Text")
  self.compInputFieldEx = self:AddComponent(UIInput, "AnswerNode/Content/InputFieldEx")
  self.compInputFieldEx:SetOnValueChange(function(value)
    if not self:IsOnAndroidOrIOS() then
      self:OnInputChange(value)
    end
  end)
  if self:IsOnAndroidOrIOS() then
    self.compBg.rectTransform:SetAsLastSibling()
    self.mobileInputField = self.compInputFieldEx.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    self.mobilId = self.mobileInputField:GetMobilId()
    
    function self.OnTextChangeFromPlatform(str)
      self:OnInputChange(str)
    end
    
    function self.OnShowKeyboard(mobilId, isShow, height)
      if ChatInterface.GetMobilSupportMultiple() and mobilId ~= self.mobilId then
        return
      end
      if self.view then
        self.view:ChangeContentCloseKeyboardBtnState(isShow)
      else
        Logger.LogError("LWUIActEasterGatheringEggEditItem\239\188\154\229\133\179\233\151\173\233\148\174\231\155\152\230\151\182\239\188\140view\228\184\141\229\173\152\229\156\168")
      end
    end
    
    if ChatInterface.GetMobilSupportMultiple() then
      self.mobileInputField.OnShowKeyboard = self.OnShowKeyboard
      self.mobileInputField.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = self.OnShowKeyboard
      CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
    end
    if CS.SDKManager.IS_UNITY_ANDROID() then
      self.mobileInputField:SetMaxLine(500)
    elseif CS.SDKManager.IS_UNITY_IOS() then
      self.mobileInputField:SetMaxLine(1)
    end
  else
    self.compBg.rectTransform:SetAsFirstSibling()
    ChatInterface.SetEmojiTextProperty(self.inputFieldText)
  end
end

function M:ComponentDestroy()
  self.textTipsTxt = nil
  self.btnRobot = nil
  self.compInputFieldEx = nil
  self.textTitle = nil
  self.textWorldNumLimit = nil
  self.btnThrow = nil
  self.btnThrowText = nil
  self.inputHolder = nil
  self.inputFieldText = nil
end

function M:DataDefine()
  self.questionWordMin = 0
  self.questionWordMax = 0
  self.alreadyShowTips = false
  self.isThrowing = false
end

function M:DataDestroy()
  self.questionWordMin = nil
  self.questionWordMax = nil
  self.alreadyShowTips = nil
  self.isThrowing = nil
  if self:IsOnAndroidOrIOS() then
    if ChatInterface.GetMobilSupportMultiple() then
      self.mobileInputField.OnShowKeyboard = nil
      self.mobileInputField.OnTextChangeFromPlatform = nil
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
      CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = nil
    end
    self.OnShowKeyboard = nil
  end
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggPostOrVoteCloseKeyboard, self.CloseKeyboardBtn)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.EasterEggPostOrVoteCloseKeyboard, self.CloseKeyboardBtn)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
  base.OnRemoveListener(self)
end

function M:Init()
  local configData = DataCenter.ActEasterEggManager:GetEggConfigData()
  if not configData then
    Logger.LogError("configData is nil")
    return
  end
  self.questionWordMin, self.questionWordMax = configData:GetWordLimit(ActEasterEggEditType.GatheringQuestion)
  self.inputHolder:SetLocalText(configData:GetTipsInput(ActEasterEggEditType.GatheringQuestion))
end

function M:OnBtnRobotClick()
  local question = DataCenter.ActEasterEggManager:GetRandomQuestion(ActEasterEggType.Gathering)
  if not string.IsNullOrEmpty(question) then
    self.textTipsTxt:SetLocalText(question)
  end
end

function M:OnBtnThrowClick()
  if self.isThrowing then
    return
  end
  local text = self.compInputFieldEx:GetText()
  local count = string.word_count(text)
  if count < self.questionWordMin then
    UIUtil.ShowTips(Localization:GetString("activity_99144_1", self.questionWordMin), nil, nil, nil, nil, 445)
    return
  end
  if not self.ctrl then
    Logger.LogError("self.ctrl is nil")
    return
  end
  local context = self.compInputFieldEx:GetText()
  self.ctrl:RequestThrowEgg(ActEasterEggType.Gathering, context, "", "")
  self.isThrowing = true
end

function M:UpdateItem(ctrl)
  self.ctrl = ctrl
  self:SetQuestion()
  self:InitInputField()
end

function M:SetQuestion()
  local question = DataCenter.ActEasterEggManager:GetDefaultQuestion(ActEasterEggType.Gathering)
  if not string.IsNullOrEmpty(question) then
    self.textTipsTxt:SetLocalText(question)
  end
end

function M:OnInputChange(str)
  local text = str
  local count = string.word_count(text)
  if count > self.questionWordMax then
    local temp = string.SubStr(str, 1, self.questionWordMax)
    count = self.questionWordMax
    self.compInputFieldEx:SetText(temp)
    if self:IsOnAndroidOrIOS() then
      self.mobileInputField.Text = temp
      local rangeInt = self.mobileInputField:GetSelection()
      self.mobileInputField:SetSelection(rangeInt)
    end
    self:ShowMaxTips()
  end
  self.textWorldNumLimit:SetText(count .. "/" .. self.questionWordMax)
end

function M:InitInputField()
  self.compInputFieldEx:SetText("")
  self.textWorldNumLimit:SetText("0/" .. self.questionWordMax)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField.Text = ""
  end
end

function M:ShowMaxTips()
  if not self.alreadyShowTips then
    self.alreadyShowTips = true
    UIUtil.ShowTips(Localization:GetString("activity_99144_2", self.questionWordMax), nil, nil, nil, nil, 445)
    self:StopTimer()
    self.timer = TimerManager:GetInstance():GetTimer(5, function()
      self.alreadyShowTips = false
      self.timer:Stop()
      self.timer = nil
    end, self, false, false, false)
    self.timer:Start()
  end
end

function M:StopTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function M:SetContentText(text)
  self.compInputFieldEx:SetText(text)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField.Text = text
    local rangeInt = self.mobileInputField:GetSelection()
    self.mobileInputField:SetSelection(rangeInt)
  end
end

function M:SetThrowFalse()
  self.isThrowing = false
end

function M:CloseKeyboardBtn()
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField:SetFocus(false)
  end
end

function M:SetKeyboardClickpanelBtnState(state)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField:SetVisible(state)
  end
end

function M:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function M:OnFinishHandleInitMsg()
  self:SetThrowFalse()
end

return LWUIActEasterGatheringEggEditItem
