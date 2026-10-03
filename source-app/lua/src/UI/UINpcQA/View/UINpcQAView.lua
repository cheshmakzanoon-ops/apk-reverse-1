local base = UIBaseView
local UINpcQAView = BaseClass("UINpcQAView", base)
local Localization = CS.GameEntry.Localization
local NpcQAItem = require("UI.UINpcQA.Component.NpcQAItem")
local title_path = "ImgBg/desBg/desText"
local closeBtn_path = "CloseBtn"
local question_path = "ImgBg/question"
local answers_path = "ImgBg/answers/answer"
local reward_title_path = "ImgBg/reward_title"
local scroll_view_path = "ImgBg/reward_title/scroll_view"
local bgBtn_path = "UICommonPanel"
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshQuestion()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(121216)
  self.reward_title = self:AddComponent(UIText, reward_title_path)
  self.reward_title:SetLocalText(121217)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.questionN = self:AddComponent(UIText, question_path)
  self.answersTb = {}
  for i = 1, 4 do
    local answer = self:AddComponent(NpcQAItem, answers_path .. i)
    answer:SetActive(false)
    table.insert(self.answersTb, answer)
  end
  self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
  self.bgBtnN:SetOnClick(function()
    self:OnClickBgBtn()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, curIndex)
    self:OnItemMoveIn(itemObj, curIndex)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, curIndex)
    self:OnItemMoveOut(itemObj, curIndex)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.titleN = nil
  self.subTitleN = nil
  self.closeBtnN = nil
  self.questionN = nil
  self.answersTb = nil
  self.scroll_view = nil
  self.reward_title = nil
end

local function DataDefine(self)
  self.rewardList = {}
end

local function DataDestroy(self)
  self.rewardList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnItemMoveIn(self, itemObj, curIndex)
  itemObj.name = tostring(curIndex)
  local cellItem = self.scroll_view:AddComponent(MailRewardItem, itemObj)
  cellItem:RefreshData(self.rewardList[curIndex])
  cellItem:SetNameText("")
end

local function OnItemMoveOut(self, itemObj, curIndex)
  self.scroll_view:RemoveComponents(itemObj.name, MailRewardItem)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(MailRewardItem)
end

local function RefreshQuestion(self)
  self.currentQuest = DataCenter.NpcQAManager:GetCurrentQA()
  local questionTemp = DataCenter.NpcQATemplateManager:GetNpcQATemplate(self.currentQuest)
  if self.currentQuest == nil then
    return
  end
  self.questionN:SetLocalText(questionTemp.question)
  local answers = questionTemp.answers
  local totalAnswer = table.count(answers)
  for i, v in ipairs(self.answersTb) do
    if questionTemp.answers[i] == questionTemp.answer then
      self.curRightIndex = i
    end
    if i > totalAnswer then
      v:SetActive(false)
    else
      v:SetActive(true)
      v:SetData(questionTemp, i, function()
        self:OnSelectAnswer(i)
      end)
    end
  end
  self.rewardList = DataCenter.NpcQAManager:GetRewardData(self.currentQuest)
  self:ClearScroll()
  local total = table.count(self.rewardList)
  if 0 < total then
    self.scroll_view:SetTotalCount(total)
    self.scroll_view:RefillCells()
  end
end

local function OnSelectAnswer(self, selectIndex)
  if self.isShowingResult then
    return
  end
  local questionTemp = DataCenter.NpcQATemplateManager:GetNpcQATemplate(self.currentQuest)
  if questionTemp == nil then
    return
  end
  if questionTemp.answers[selectIndex] == questionTemp.answer then
    self.titleN:SetLocalText(121218)
  else
    self.titleN:SetLocalText(121266)
  end
  self.answersTb[selectIndex]:ShowAnswer()
  if selectIndex ~= self.curRightIndex and self.curRightIndex ~= nil and self.answersTb[self.curRightIndex] ~= nil then
    self.answersTb[self.curRightIndex]:ShowAnswer()
  end
  DataCenter.NpcQAManager:SendQAToServer(self.currentQuest, toInt(questionTemp.answers[selectIndex]))
  self.isShowingResult = true
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickBgBtn(self)
  self.ctrl:CloseSelf()
end

UINpcQAView.OnCreate = OnCreate
UINpcQAView.OnDestroy = OnDestroy
UINpcQAView.OnAddListener = OnAddListener
UINpcQAView.OnRemoveListener = OnRemoveListener
UINpcQAView.ComponentDefine = ComponentDefine
UINpcQAView.ComponentDestroy = ComponentDestroy
UINpcQAView.DataDefine = DataDefine
UINpcQAView.DataDestroy = DataDestroy
UINpcQAView.RefreshQuestion = RefreshQuestion
UINpcQAView.OnClickCloseBtn = OnClickCloseBtn
UINpcQAView.OnSelectAnswer = OnSelectAnswer
UINpcQAView.OnClickBgBtn = OnClickBgBtn
UINpcQAView.OnItemMoveIn = OnItemMoveIn
UINpcQAView.OnItemMoveOut = OnItemMoveOut
UINpcQAView.ClearScroll = ClearScroll
return UINpcQAView
