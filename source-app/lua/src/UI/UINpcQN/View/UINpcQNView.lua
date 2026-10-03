local base = UIBaseView
local UINpcQNView = BaseClass("UINpcQNView", base)
local Localization = CS.GameEntry.Localization
local NpcQAItem = require("UI.UINpcQN.Component.NpcQNItem")
local title_path = "ImgBg/desBg/desText"
local closeBtn_path = "CloseBtn"
local question_path = "ImgBg/question"
local next_btn_path = "ImgBg/RightBtn"
local next_txt_path = "ImgBg/RightBtn/RightBtnName"
local pro_txt_path = "ImgBg/prog"
local bgBtn_path = "UICommonPanel"
local content_path = "ImgBg/ScrollView/Content"

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
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.questionN = self:AddComponent(UIText, question_path)
  self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
  self.bgBtnN:SetOnClick(function()
    self:OnClickBgBtn()
  end)
  self._next_btn = self:AddComponent(UIButton, next_btn_path)
  self._next_txt = self:AddComponent(UIText, next_txt_path)
  self._next_txt:SetLocalText(110074)
  self._next_btn:SetOnClick(function()
    self:OnClickNext()
  end)
  self._pro_txt = self:AddComponent(UIText, pro_txt_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  self.titleN = nil
  self.subTitleN = nil
  self.closeBtnN = nil
  self.questionN = nil
  self.scroll_view = nil
  self._next_btn = nil
  self._next_txt = nil
  self._pro_txt = nil
end

local function DataDefine(self)
  self.rewardList = {}
  self.cell = {}
  self.model = {}
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

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(NpcQAItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.cell = {}
end

local function RefreshQuestion(self)
  self._next_btn:SetActive(false)
  self.list = DataCenter.QNManager:GetQuestionList()
  self.curIndex = DataCenter.QNManager:GetCurIndex()
  self._pro_txt:SetLocalText(150033, self.curIndex, #self.list.questions)
  if self.curIndex <= #self.list.questions then
    local questionTemp = DataCenter.NpcQATemplateManager:GetQuestionnaireTemplate(self.list.questions[self.curIndex])
    if questionTemp then
      self.questionN:SetLocalText(questionTemp.question)
      for i = 1, table.length(questionTemp.answers) do
        if self.cell[i] then
          self.cell[i]:SetActive(true)
          self.cell[i]:SetData(questionTemp, i, function()
            self:OnSelectAnswer(i)
          end)
        else
          self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UINpcQNCell, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.content:AddComponent(NpcQAItem, nameStr)
            cell:SetData(questionTemp, i, function()
              self:OnSelectAnswer(i)
            end)
            self.cell[i] = cell
            self.cell[i]:SetActive(true)
          end)
        end
      end
    end
  end
end

local function OnSelectAnswer(self, selectIndex)
  local questionTemp = DataCenter.NpcQATemplateManager:GetQuestionnaireTemplate(self.list.questions[self.curIndex])
  DataCenter.QNManager:SetQuestion(self.list.questions[self.curIndex], toInt(questionTemp.answers[selectIndex]))
  if self.curIndex == #self.list.questions then
    local QuestionObj = DataCenter.QNManager:GetQuestion()
    SFSNetwork.SendMessage(MsgDefines.UserNpcQuestionnaire, self.list.id, QuestionObj)
    self.ctrl:CloseSelf()
    return
  end
  for i = 1, #self.cell do
    if i == selectIndex then
      self.cell[i]:SetResult(true)
    else
      self.cell[i]:SetResult(false)
    end
  end
  self._next_btn:SetActive(true)
end

local function OnClickNext(self)
  self.curIndex = self.curIndex + 1
  DataCenter.QNManager:SetCurIndex(self.curIndex)
  for i = 1, #self.cell do
    self.cell[i]:SetActive(false)
  end
  self:RefreshQuestion()
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickBgBtn(self)
  self.ctrl:CloseSelf()
end

UINpcQNView.OnCreate = OnCreate
UINpcQNView.OnDestroy = OnDestroy
UINpcQNView.OnAddListener = OnAddListener
UINpcQNView.OnRemoveListener = OnRemoveListener
UINpcQNView.ComponentDefine = ComponentDefine
UINpcQNView.ComponentDestroy = ComponentDestroy
UINpcQNView.DataDefine = DataDefine
UINpcQNView.DataDestroy = DataDestroy
UINpcQNView.RefreshQuestion = RefreshQuestion
UINpcQNView.OnClickCloseBtn = OnClickCloseBtn
UINpcQNView.OnSelectAnswer = OnSelectAnswer
UINpcQNView.OnClickBgBtn = OnClickBgBtn
UINpcQNView.OnClickNext = OnClickNext
UINpcQNView.SetAllCellDestroy = SetAllCellDestroy
return UINpcQNView
