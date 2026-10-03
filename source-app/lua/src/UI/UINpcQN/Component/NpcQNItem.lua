local NpcQAItem = BaseClass("NpcQAItem", UIBaseContainer)
local base = UIBaseContainer
local selectBtn_path = ""
local bgImg_path = "bg"
local answerIndex_path = "index"
local answerTxt_path = "content"
local resultContainer_path = "result"
local resultImg_path = "result/resultImg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.selectBtnN = self:AddComponent(UIButton, selectBtn_path)
  self.selectBtnN:SetOnClick(function()
    if self.onSelectCallBack then
      self.onSelectCallBack()
    end
  end)
  self.bgImgN = self:AddComponent(UIImage, bgImg_path)
  self.answerIndexN = self:AddComponent(UIText, answerIndex_path)
  self.answerTxtN = self:AddComponent(UIText, answerTxt_path)
  self.resultContainerN = self:AddComponent(UIBaseContainer, resultContainer_path)
  self.resultImgN = self:AddComponent(UIImage, resultImg_path)
end

local function ComponentDestroy(self)
  self.selectBtnN = nil
  self.bgImgN = nil
  self.answerIndexN = nil
  self.answerTxtN = nil
  self.resultContainerN = nil
  self.resultImgN = nil
end

local function DataDefine(self)
  self.questionInfo = nil
  self.answerIndex = 0
  self.onSelectCallBack = nil
end

local function DataDestroy(self)
  self.questionInfo = nil
  self.answerIndex = nil
  self.onSelectCallBack = nil
end

local function SetData(self, question, tempIndex, callBack)
  if not question then
    self.gameObject:SetActive(false)
  else
    self.gameObject:SetActive(true)
    self.questionInfo = question
    self.answerIndex = tempIndex
    self.onSelectCallBack = callBack
    self.answerIndexN:SetText(self.answerIndex)
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/OA/UIAllianceElection_bg_cell4.png")
    self.answerTxtN:SetActive(true)
    self.answerTxtN:SetLocalText(self.questionInfo.answers[self.answerIndex])
    self.resultContainerN:SetActive(false)
  end
end

local function SetResult(self, state)
  self.resultContainerN:SetActive(state)
end

NpcQAItem.OnCreate = OnCreate
NpcQAItem.OnDestroy = OnDestroy
NpcQAItem.OnEnable = OnEnable
NpcQAItem.OnDisable = OnDisable
NpcQAItem.ComponentDefine = ComponentDefine
NpcQAItem.ComponentDestroy = ComponentDestroy
NpcQAItem.DataDefine = DataDefine
NpcQAItem.DataDestroy = DataDestroy
NpcQAItem.SetData = SetData
NpcQAItem.SetResult = SetResult
return NpcQAItem
