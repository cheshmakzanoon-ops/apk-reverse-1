local base = UIBaseView
local UIAllianceQaView = BaseClass("UIAllianceQaView", base)
local Localization = CS.GameEntry.Localization
local AllianceQaItem = require("UI.UIAlliance.UIAllianceQa.Component.AllianceQaItem")
local title_path = "ImgBg/desBg/desText"
local closeBtn_path = "CloseBtn"
local quitBtn_path = "ImgBg/quitBtn"
local quitTxt_path = "ImgBg/quitBtn/quitTxt"
local progressTxt_path = "ImgBg/prog"
local question_path = "ImgBg/question"
local answers_path = "ImgBg/answers/answer"
local scoreTxt_path = "ImgBg/scoreTxt"
local score_path = "ImgBg/score"
local bgBtn_path = "UICommonPanel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ShowNextQ()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(141106)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.questionN = self:AddComponent(UIText, question_path)
  self.quitBtnN = self:AddComponent(UIButton, quitBtn_path)
  self.quitBtnN:SetOnClick(function()
    self:OnClickQuitBtn()
  end)
  self.quitTxtN = self:AddComponent(UIText, quitTxt_path)
  self.quitTxtN:SetLocalText(110075)
  self.progTxtN = self:AddComponent(UIText, progressTxt_path)
  self.answersTb = {}
  for i = 1, 4 do
    local answer = self:AddComponent(AllianceQaItem, answers_path .. i)
    table.insert(self.answersTb, answer)
  end
  self.scoreTxtN = self:AddComponent(UIText, scoreTxt_path)
  self.scoreTxtN:SetText("")
  self.scoreN = self:AddComponent(UIText, score_path)
  self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
  self.bgBtnN:SetOnClick(function()
    self:OnClickBgBtn()
  end)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.closeBtnN = nil
  self.questionN = nil
  self.quitBtnN = nil
  self.answersTb = nil
end

local function DataDefine(self)
  self.curQuestionIndex = 0
  self.curScore = 0
  self.isShowingResult = false
  self.curRightIndex = 0
end

local function DataDestroy(self)
  self.curQuestionIndex = nil
  self.curScore = nil
  self.isShowingResult = nil
  self.curRightIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowNextQ(self)
  self.isShowingResult = false
  if not self.questionList or #self.questionList == 0 then
    self.questionList = DataCenter.AllianceLeaderManager:GetAllQuestions()
  end
  self.curQuestionIndex = self.curQuestionIndex + 1
  if self.curQuestionIndex > #self.questionList then
    self:OnQaFinish()
  else
    self.questionInfo = self.questionList[self.curQuestionIndex]
    self.scoreN:SetLocalText(141108)
    self.progTxtN:SetText(self.curQuestionIndex .. "/" .. #self.questionList)
    self:MessUpAnswers()
    self:RefreshQuestion()
  end
end

local function MessUpAnswers(self)
  if self.questionInfo then
    local answersCount = #self.questionInfo.answers
    for i = 1, answersCount do
      local temp = math.random(1, answersCount)
      self.questionInfo.answers[i], self.questionInfo.answers[temp] = self.questionInfo.answers[temp], self.questionInfo.answers[i]
    end
  end
end

local function RefreshQuestion(self)
  self.questionN:SetLocalText(self.questionInfo.question)
  for i, v in ipairs(self.answersTb) do
    if i <= #self.questionInfo.answers then
      if self.questionInfo.answers[i] == self.questionInfo.answer then
        self.curRightIndex = i
      end
      v:SetData(self.questionInfo, i, function()
        self:OnSelectAnswer(i)
      end)
    else
      v:SetData(nil)
    end
  end
end

local function OnSelectAnswer(self, selectIndex)
  if self.isShowingResult then
    return
  end
  self.answersTb[selectIndex]:ShowAnswer()
  if selectIndex ~= self.curRightIndex then
    self.answersTb[self.curRightIndex]:ShowAnswer()
  else
    self.curScore = self.curScore + self.questionInfo.fraction
    self.scoreN:SetText(Localization:GetString("141108", self.curScore))
  end
  self.isShowingResult = true
  self.showAnswerTime = TimerManager:GetInstance():DelayInvoke(function()
    self.isShowingResult = false
    self:ShowNextQ()
  end, 1.5)
end

local function StopTimer(self)
  if self.showAnswerTime then
    self.showAnswerTime:Stop()
    self.showAnswerTime = nil
  end
end

local function OnQaFinish(self)
  local needScore = LuaEntry.DataConfig:TryGetNum("union_control", "k5")
  if needScore <= self.curScore then
    DataCenter.AllianceLeaderManager:FinishQaGuide(1, 2)
  else
    DataCenter.AllianceLeaderManager:FinishQaGuide(0, 3)
  end
  self.ctrl:CloseSelf()
end

local function OnClickCloseBtn(self)
  DataCenter.AllianceLeaderManager:FinishQaGuide(0, 4)
  self.ctrl:CloseSelf()
end

local function OnClickQuitBtn(self)
  DataCenter.AllianceLeaderManager:FinishQaGuide(0, 4)
  self.ctrl:CloseSelf()
end

local function OnClickBgBtn(self)
  if self.isShowingResult then
    self:ShowNextQ()
  end
end

UIAllianceQaView.OnCreate = OnCreate
UIAllianceQaView.OnDestroy = OnDestroy
UIAllianceQaView.OnAddListener = OnAddListener
UIAllianceQaView.OnRemoveListener = OnRemoveListener
UIAllianceQaView.ComponentDefine = ComponentDefine
UIAllianceQaView.ComponentDestroy = ComponentDestroy
UIAllianceQaView.DataDefine = DataDefine
UIAllianceQaView.DataDestroy = DataDestroy
UIAllianceQaView.ShowNextQ = ShowNextQ
UIAllianceQaView.OnQaFinish = OnQaFinish
UIAllianceQaView.RefreshQuestion = RefreshQuestion
UIAllianceQaView.MessUpAnswers = MessUpAnswers
UIAllianceQaView.StopTimer = StopTimer
UIAllianceQaView.OnClickCloseBtn = OnClickCloseBtn
UIAllianceQaView.OnClickQuitBtn = OnClickQuitBtn
UIAllianceQaView.OnSelectAnswer = OnSelectAnswer
UIAllianceQaView.OnClickBgBtn = OnClickBgBtn
return UIAllianceQaView
