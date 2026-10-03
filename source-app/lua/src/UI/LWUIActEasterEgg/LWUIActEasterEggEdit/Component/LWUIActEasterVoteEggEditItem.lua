local LWUIActEasterVoteEggEditItem = BaseClass("LWUIActEasterVoteEggEditItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local M = LWUIActEasterVoteEggEditItem

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  self:StopQuestionTimer()
  self:StopAnswerATimer()
  self:StopAnswerBTimer()
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
  self.btnRobot = self:AddComponent(UIButton, "Robot")
  self.btnRobot:SetOnClick(function()
    self:OnBtnRobotClick()
  end)
  self.textTipsTxt = self:AddComponent(UITextMeshProUGUIEx, "TipsNode/Bg/TipsTxt")
  self.btnThrow = self:AddComponent(UIButton, "ThrowBtn")
  self.btnThrow:SetOnClick(function()
    self:OnBtnThrowClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Title")
  self.textWorldNumLimit = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/WorldNumLimit")
  self.textATitle = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/ATitle")
  self.textBTitle = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/BTitle")
  self.textWordLimitA = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/AnswerAPart/WordLimitA")
  self.textWordLimitB = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/AnswerBPart/WordLimitB")
  self.btnThrowText = self:AddComponent(UITextMeshProUGUIEx, "ThrowBtn/LW_Btn_Common_New_Base/BtnText")
  self.questionPlaceholder = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/QuestionNode/TextArea/Placeholder")
  self.answerAPlaceholder = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/AnswerAPart/AnswerANode/TextArea/PlaceholderA")
  self.answerBPlaceholder = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/AnswerBPart/AnswerBNode/TextArea/PlaceholderB")
  self.btnThrowText:SetLocalText("activity_99144_ui_16")
  self.textATitle:SetLocalText("activity_99144_ui_17")
  self.textBTitle:SetLocalText("activity_99144_ui_18")
  self.textTitle:SetLocalText("activity_99144_ui_15")
  self.inputTextQuestion = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/QuestionNode/TextArea/TextQuestion")
  self.inputTextAnswerA = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/AnswerAPart/AnswerANode/TextArea/TextAnswerA")
  self.inputTextAnswerB = self:AddComponent(UITextMeshProUGUIEx, "AnswerNode/Content/AnswerBPart/AnswerBNode/TextArea/TextAnswerB")
  self.questionInput = self:AddComponent(UIInput, "AnswerNode/Content/QuestionNode")
  self.questionInput:SetOnValueChange(function(value)
    if not self:IsOnAndroidOrIOS() then
      self:OnQuestionInputChange(value)
    end
  end)
  self.answerAInput = self:AddComponent(UIInput, "AnswerNode/Content/AnswerAPart/AnswerANode")
  self.answerAInput:SetOnValueChange(function(value)
    if not self:IsOnAndroidOrIOS() then
      self:OnAnswerAInputChange(value)
    end
  end)
  self.answerBInput = self:AddComponent(UIInput, "AnswerNode/Content/AnswerBPart/AnswerBNode")
  self.answerBInput:SetOnValueChange(function(value)
    if not self:IsOnAndroidOrIOS() then
      self:OnAnswerBInputChange(value)
    end
  end)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField_question = self.questionInput.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    self.mobilId_question = self.mobileInputField_question:GetMobilId()
    self.mobileInputField_answerA = self.answerAInput.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    self.mobilId_answerA = self.mobileInputField_answerA:GetMobilId()
    self.mobileInputField_answerB = self.answerBInput.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    self.mobilId_answerB = self.mobileInputField_answerB:GetMobilId()
    
    function self.OnTextChangeFromPlatform_question(str)
      self:OnQuestionInputChange(str)
    end
    
    function self.OnTextChangeFromPlatform_answerA(str)
      self:OnAnswerAInputChange(str)
    end
    
    function self.OnTextChangeFromPlatform_answerB(str)
      self:OnAnswerBInputChange(str)
    end
    
    function self.OnShowKeyboard(mobilId, isShow, height)
      if ChatInterface.GetMobilSupportMultiple() and mobilId ~= self.mobilId_question and mobilId ~= self.mobilId_answerA and mobilId ~= self.mobilId_answerB then
        return
      end
      if self.view then
        self.view:ChangeContentCloseKeyboardBtnState(isShow)
      else
        Logger.LogError("LWUIActEasterVoteEggEditItem\239\188\154\229\133\179\233\151\173\233\148\174\231\155\152\230\151\182\239\188\140view\228\184\141\229\173\152\229\156\168")
      end
    end
    
    if ChatInterface.GetMobilSupportMultiple() then
      self.mobileInputField_question.OnShowKeyboard = self.OnShowKeyboard
      self.mobileInputField_answerA.OnShowKeyboard = self.OnShowKeyboard
      self.mobileInputField_answerB.OnShowKeyboard = self.OnShowKeyboard
      self.mobileInputField_question.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform_question
      self.mobileInputField_answerA.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform_answerA
      self.mobileInputField_answerB.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform_answerB
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = self.OnShowKeyboard
    end
    if CS.SDKManager.IS_UNITY_ANDROID() then
      self.mobileInputField_question:SetMaxLine(500)
      self.mobileInputField_answerA:SetMaxLine(500)
      self.mobileInputField_answerB:SetMaxLine(500)
    elseif CS.SDKManager.IS_UNITY_IOS() then
      self.mobileInputField_question:SetMaxLine(1)
      self.mobileInputField_answerA:SetMaxLine(1)
      self.mobileInputField_answerB:SetMaxLine(1)
    end
  else
    ChatInterface.SetEmojiTextProperty(self.inputTextQuestion)
    ChatInterface.SetEmojiTextProperty(self.inputTextAnswerA)
    ChatInterface.SetEmojiTextProperty(self.inputTextAnswerB)
  end
end

function M:ComponentDestroy()
  self.btnRobot = nil
  self.textTipsTxt = nil
  self.btnThrow = nil
  self.textTitle = nil
  self.textWorldNumLimit = nil
  self.textATitle = nil
  self.textBTitle = nil
  self.textWordLimitA = nil
  self.textWordLimitB = nil
  self.btnThrowText = nil
  self.questionInput = nil
  self.answerAInput = nil
  self.answerBInput = nil
  self.questionPlaceholder = nil
  self.answerAPlaceholder = nil
  self.answerBPlaceholder = nil
  self.inputTextQuestion = nil
  self.inputTextAnswerA = nil
  self.inputTextAnswerB = nil
end

function M:DataDefine()
  self.questionWordMin = 0
  self.questionWordMax = 0
  self.answerAWordMin = 0
  self.answerAWordMax = 0
  self.answerBWordMin = 0
  self.answerBWordMax = 0
  self.alreadyShowQuestionTips = false
  self.alreadyShowAnswerATips = false
  self.alreadyShowAnswerBTips = false
  self.isThrowing = false
end

function M:DataDestroy()
  self.questionWordMin = nil
  self.questionWordMax = nil
  self.answerAWordMin = nil
  self.answerAWordMax = nil
  self.answerBWordMin = nil
  self.answerBWordMax = nil
  self.alreadyShowQuestionTips = nil
  self.alreadyShowAnswerATips = nil
  self.alreadyShowAnswerBTips = nil
  self.isThrowing = nil
  if self:IsOnAndroidOrIOS() then
    if ChatInterface.GetMobilSupportMultiple() then
      self.mobileInputField_question.OnShowKeyboard = nil
      self.mobileInputField_answerA.OnShowKeyboard = nil
      self.mobileInputField_answerB.OnShowKeyboard = nil
      self.mobileInputField_question.OnTextChangeFromPlatform = nil
      self.mobileInputField_answerA.OnTextChangeFromPlatform = nil
      self.mobileInputField_answerB.OnTextChangeFromPlatform = nil
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
    end
    self.OnShowKeyboard = nil
  end
end

function M:Init()
  local configData = DataCenter.ActEasterEggManager:GetEggConfigData()
  if not configData then
    Logger.LogError("configData is nil")
    return
  end
  self.questionWordMin, self.questionWordMax = configData:GetWordLimit(ActEasterEggEditType.VoteQuestion)
  self.answerAWordMin, self.answerAWordMax = configData:GetWordLimit(ActEasterEggEditType.VoteAnswerA)
  self.answerBWordMin, self.answerBWordMax = configData:GetWordLimit(ActEasterEggEditType.VoteAnswerB)
  self.questionPlaceholder:SetLocalText(configData:GetTipsInput(ActEasterEggEditType.VoteQuestion))
  self.answerAPlaceholder:SetLocalText(configData:GetTipsInput(ActEasterEggEditType.VoteAnswerA))
  self.answerBPlaceholder:SetLocalText(configData:GetTipsInput(ActEasterEggEditType.VoteAnswerB))
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

function M:OnBtnRobotClick()
  local question = DataCenter.ActEasterEggManager:GetRandomQuestion(ActEasterEggType.Vote)
  if not string.IsNullOrEmpty(question) then
    self.textTipsTxt:SetLocalText(question)
  end
end

function M:OnBtnThrowClick()
  if self.isThrowing then
    return
  end
  local questionInputText = self.questionInput:GetText()
  local questionInputCount = string.word_count(questionInputText)
  if questionInputCount < self.questionWordMin then
    UIUtil.ShowTips(Localization:GetString("activity_99144_18", self.questionWordMin), nil, nil, nil, nil, 445)
    return
  end
  local answerAInputText = self.answerAInput:GetText()
  local answerAInputCount = string.word_count(answerAInputText)
  if answerAInputCount < self.answerAWordMin then
    UIUtil.ShowTips(Localization:GetString("activity_99144_19", self.answerAWordMin), nil, nil, nil, nil, 445)
    return
  end
  local answerBInputText = self.answerBInput:GetText()
  local answerBInputCount = string.word_count(answerBInputText)
  if answerBInputCount < self.answerBWordMin then
    UIUtil.ShowTips(Localization:GetString("activity_99144_20", self.answerBWordMin), nil, nil, nil, nil, 445)
    return
  end
  if not self.ctrl then
    Logger.LogError("self.ctrl is nil")
    return
  end
  local context = self.questionInput:GetText()
  local optionA = self.answerAInput:GetText()
  local optionB = self.answerBInput:GetText()
  self.ctrl:RequestThrowEgg(ActEasterEggType.Vote, context, optionA, optionB)
  self.isThrowing = true
end

function M:UpdateItem(ctrl)
  self.ctrl = ctrl
  self:SetQuestion()
  self:InitInputField()
end

function M:SetQuestion()
  local question = DataCenter.ActEasterEggManager:GetDefaultQuestion(ActEasterEggType.Vote)
  if not string.IsNullOrEmpty(question) then
    self.textTipsTxt:SetLocalText(question)
  end
end

function M:OnQuestionInputChange(str)
  local text = str
  local count = string.word_count(text)
  if count > self.questionWordMax then
    local temp = string.SubStr(str, 1, self.questionWordMax)
    count = self.questionWordMax
    self.questionInput:SetText(temp)
    if self:IsOnAndroidOrIOS() then
      self.mobileInputField_question.Text = temp
      local rangeInt = self.mobileInputField_question:GetSelection()
      self.mobileInputField_question:SetSelection(rangeInt)
    end
    self:ShowQuestionMaxTips()
  end
  self.textWorldNumLimit:SetText(count .. "/" .. self.questionWordMax)
end

function M:OnAnswerAInputChange(str)
  local text = str
  local count = string.word_count(text)
  if count > self.answerAWordMax then
    local temp = string.SubStr(str, 1, self.answerAWordMax)
    count = self.answerAWordMax
    self.answerAInput:SetText(temp)
    if self:IsOnAndroidOrIOS() then
      self.mobileInputField_answerA.Text = temp
      local rangeInt = self.mobileInputField_answerA:GetSelection()
      self.mobileInputField_answerA:SetSelection(rangeInt)
    end
    self:ShowAnswerAMaxTips()
  end
  self.textWordLimitA:SetText(count .. "/" .. self.answerAWordMax)
end

function M:OnAnswerBInputChange(str)
  local text = str
  local count = string.word_count(text)
  if count > self.answerBWordMax then
    local temp = string.SubStr(str, 1, self.answerBWordMax)
    count = self.answerBWordMax
    self.answerBInput:SetText(temp)
    if self:IsOnAndroidOrIOS() then
      self.mobileInputField_answerB.Text = temp
      local rangeInt = self.mobileInputField_answerB:GetSelection()
      self.mobileInputField_answerB:SetSelection(rangeInt)
    end
    self:ShowAnswerBMaxTips()
  end
  self.textWordLimitB:SetText(count .. "/" .. self.answerBWordMax)
end

function M:InitInputField()
  self.questionInput:SetText("")
  self.textWorldNumLimit:SetText("0/" .. self.questionWordMax)
  self.answerAInput:SetText("")
  self.textWordLimitA:SetText("0/" .. self.answerAWordMax)
  self.answerBInput:SetText("")
  self.textWordLimitB:SetText("0/" .. self.answerBWordMax)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField_question.Text = ""
    self.mobileInputField_answerA.Text = ""
    self.mobileInputField_answerB.Text = ""
  end
end

function M:ShowQuestionMaxTips()
  if not self.alreadyShowQuestionTips then
    self.alreadyShowQuestionTips = true
    UIUtil.ShowTips(Localization:GetString("activity_99144_2", self.questionWordMax), nil, nil, nil, nil, 445)
    self:StopQuestionTimer()
    self.questionTimer = TimerManager:GetInstance():GetTimer(5, function()
      self.alreadyShowQuestionTips = false
      self.questionTimer:Stop()
      self.questionTimer = nil
    end, self, false, false, false)
    self.questionTimer:Start()
  end
end

function M:ShowAnswerAMaxTips()
  if not self.alreadyShowAnswerATips then
    self.alreadyShowAnswerATips = true
    UIUtil.ShowTips(Localization:GetString("activity_99144_2", self.answerAWordMax), nil, nil, nil, nil, 445)
    self:StopAnswerATimer()
    self.showAnswerATimer = TimerManager:GetInstance():GetTimer(5, function()
      self.alreadyShowAnswerATips = false
      self.showAnswerATimer:Stop()
      self.showAnswerATimer = nil
    end, self, false, false, false)
    self.showAnswerATimer:Start()
  end
end

function M:ShowAnswerBMaxTips()
  if not self.alreadyShowAnswerBTips then
    self.alreadyShowAnswerBTips = true
    UIUtil.ShowTips(Localization:GetString("activity_99144_2", self.answerBWordMax), nil, nil, nil, nil, 445)
    self:StopAnswerBTimer()
    self.showAnswerBTimer = TimerManager:GetInstance():GetTimer(5, function()
      self.alreadyShowAnswerBTips = false
      self.showAnswerBTimer:Stop()
      self.showAnswerBTimer = nil
    end, self, false, false, false)
    self.showAnswerBTimer:Start()
  end
end

function M:SetContentText(text)
  self.questionInput:SetText(text)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField_question.Text = text
    local rangeInt = self.mobileInputField_question:GetSelection()
    self.mobileInputField_question:SetSelection(rangeInt)
  end
end

function M:SetAnswerAText(text)
  self.answerAInput:SetText(text)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField_answerA.Text = text
    local rangeInt = self.mobileInputField_answerA:GetSelection()
    self.mobileInputField_answerA:SetSelection(rangeInt)
  end
end

function M:SetAnswerBText(text)
  self.answerBInput:SetText(text)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField_answerB.Text = text
    local rangeInt = self.mobileInputField_answerB:GetSelection()
    self.mobileInputField_answerB:SetSelection(rangeInt)
  end
end

function M:StopQuestionTimer()
  if self.questionTimer then
    self.questionTimer:Stop()
    self.questionTimer = nil
  end
end

function M:StopAnswerATimer()
  if self.showAnswerATimer then
    self.showAnswerATimer:Stop()
    self.showAnswerATimer = nil
  end
end

function M:StopAnswerBTimer()
  if self.showAnswerBTimer then
    self.showAnswerBTimer:Stop()
    self.showAnswerBTimer = nil
  end
end

function M:SetThrowFalse()
  self.isThrowing = false
end

function M:CloseKeyboardBtn()
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField_question:SetFocus(false)
    self.mobileInputField_answerA:SetFocus(false)
    self.mobileInputField_answerB:SetFocus(false)
  end
end

function M:SetKeyboardClickpanelBtnState(state)
  if self:IsOnAndroidOrIOS() then
    self.mobileInputField_question:SetVisible(state)
    self.mobileInputField_answerA:SetVisible(state)
    self.mobileInputField_answerB:SetVisible(state)
  end
end

function M:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function M:OnFinishHandleInitMsg()
  self:SetThrowFalse()
end

return LWUIActEasterVoteEggEditItem
