local UIGetDuelScoreTipSlider = BaseClass("UIGetDuelScoreTipSlider", UIBaseContainer)
local base = UIBaseContainer
local UIGetDuelScoreTipScoreItem = require("UI.UIGetDuelScoreTip.Component.UIGetDuelScoreTipScoreItem")
local slider_path = ""
local scoreList_path = "ScoreList"
local progress_effect_path = "Eff_ui_wurenji_shengji_big"
local ProgressAddSpeed = 0.2
local ChangePageTime = 1.5
local State = {
  NoAnim = 1,
  ProgressAnim = 2,
  ChangePage = 3
}

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
  self.state = State.NoAnim
end

local function ComponentDefine(self)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.scoreList = self:AddComponent(UIBaseContainer, scoreList_path)
  self.sliderFullLen = self.slider:GetSizeDelta().x
  self.sliderNodeProgress = {}
  self.scoreItemList = {}
  for i = 0, self.scoreList.transform.childCount - 1 do
    local trans = self.scoreList.transform:GetChild(i)
    local comp = self.scoreList:AddComponent(UIGetDuelScoreTipScoreItem, trans.name)
    table.insert(self.scoreItemList, comp)
    table.insert(self.sliderNodeProgress, comp:GetAnchoredPositionX() / self.sliderFullLen)
  end
  self.progressEffect = self:AddComponent(UIBaseContainer, progress_effect_path)
  self.progressEffect:SetActive(false)
end

local function ComponentDestroy(self)
  self.slider = nil
  self.scoreList = nil
  self.scoreItemList = nil
  self.progressEffect = nil
end

local function DataDefine(self)
  self.state = State.NoAnim
  self.nowProgress = 0
  self.targetProgress = 0
  self.nowScore = 0
  self.targetScore = 0
  self.newScore = 0
  self.deltaTime = 0
end

local function DataDestroy(self)
  self.sliderFullLen = nil
  self.sliderNodeProgress = nil
  self.state = nil
  self.nowProgress = 0
  self.targetProgress = 0
  self.nowScore = 0
  self.targetScore = 0
  self.newScore = 0
  self.deltaTime = 0
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function Refresh(self, oldScore, newScore, targetScoreList, isDiff, scoreType)
  self.scoreType = scoreType
  local forceUpdate = isDiff
  if self.targetScoreList and targetScoreList ~= self.targetScoreList then
    forceUpdate = true
  end
  self.targetScoreList = targetScoreList
  self.newScore = newScore
  if self.state == State.NoAnim then
    self.nowScore = oldScore
  end
  if forceUpdate then
    self:RefreshPage(oldScore, newScore)
  end
  self.progressEffect:SetActive(false)
  self.progressEffect:SetActive(true)
end

local function RefreshPage(self, oldScore, newScore)
  local zeroScore = 0
  local pageItemNum = #self.scoreItemList
  self.curTargetScores = {}
  local isFind = false
  local index = 1
  while index < #self.targetScoreList do
    local group = {}
    for i = 1, pageItemNum do
      local score = self.targetScoreList[index]
      table.insert(group, score)
      index = index + 1
      if oldScore < score then
        isFind = true
      end
    end
    if isFind then
      if index > pageItemNum + 1 then
        zeroScore = self.targetScoreList[index - pageItemNum - 1]
      end
      self.curTargetScores = group
      break
    end
  end
  if isFind then
    for index, value in ipairs(self.scoreItemList) do
      value:SetData(self.curTargetScores[index], oldScore, self.scoreType)
    end
    self.nowScore = oldScore
    self.nowProgress = self:GetScoreProgress(oldScore, zeroScore)
    self.slider:SetValue(self.nowProgress)
    self.targetScore = math.min(newScore, self.curTargetScores[#self.curTargetScores])
    self.targetProgress = self:GetScoreProgress(self.targetScore, zeroScore)
    self.state = State.ProgressAnim
    self.deltaTime = 0
  end
end

local function GetScoreProgress(self, checkScore, zeroScore)
  local nowIndex = 0
  local score = checkScore - zeroScore
  for i = 1, #self.curTargetScores do
    local needScore = self.curTargetScores[i]
    if checkScore >= needScore then
      nowIndex = i
    else
      if 1 < i then
        score = checkScore - self.curTargetScores[i - 1]
      end
      break
    end
  end
  local value = 0
  if nowIndex == #self.curTargetScores then
    value = self.sliderNodeProgress[#self.sliderNodeProgress]
  else
    local preScore = zeroScore
    if 0 < nowIndex then
      preScore = self.curTargetScores[nowIndex]
    end
    local nodeRatio = score / (self.curTargetScores[nowIndex + 1] - preScore)
    local preProgress = 0
    if 0 < nowIndex then
      preProgress = self.sliderNodeProgress[nowIndex]
    end
    value = preProgress + nodeRatio * (self.sliderNodeProgress[nowIndex + 1] - preProgress)
  end
  return value
end

local function Update(self)
  if self.state then
    if self.state == State.NoAnim then
      if self.newScore > self.nowScore then
        self:RefreshPage(self.nowScore, self.newScore)
      end
    elseif self.state == State.ProgressAnim then
      local diff = self.targetProgress - self.nowProgress
      if 0 < diff then
        self.nowProgress = math.min(self.nowProgress + self.deltaTime * ProgressAddSpeed, self.targetProgress)
        self.slider:SetValue(self.nowProgress)
        self.deltaTime = self.deltaTime + Time.deltaTime
      else
        for index, value in ipairs(self.scoreItemList) do
          value:CheckShowReachAnim(self.targetScore)
        end
        self.nowScore = self.targetScore
        if self.newScore > self.nowScore then
          self.state = State.ChangePage
          self.deltaTime = 0
        else
          self.state = State.NoAnim
        end
      end
    elseif self.state == State.ChangePage then
      if self.deltaTime < ChangePageTime then
        self.deltaTime = self.deltaTime + Time.deltaTime
      else
        self.deltaTime = 0
        self.state = State.NoAnim
      end
    end
  end
end

UIGetDuelScoreTipSlider.OnCreate = OnCreate
UIGetDuelScoreTipSlider.OnDestroy = OnDestroy
UIGetDuelScoreTipSlider.OnEnable = OnEnable
UIGetDuelScoreTipSlider.OnDisable = OnDisable
UIGetDuelScoreTipSlider.ComponentDefine = ComponentDefine
UIGetDuelScoreTipSlider.ComponentDestroy = ComponentDestroy
UIGetDuelScoreTipSlider.DataDefine = DataDefine
UIGetDuelScoreTipSlider.DataDestroy = DataDestroy
UIGetDuelScoreTipSlider.OnAddListener = OnAddListener
UIGetDuelScoreTipSlider.OnRemoveListener = OnRemoveListener
UIGetDuelScoreTipSlider.Refresh = Refresh
UIGetDuelScoreTipSlider.RefreshPage = RefreshPage
UIGetDuelScoreTipSlider.GetScoreProgress = GetScoreProgress
UIGetDuelScoreTipSlider.Update = Update
return UIGetDuelScoreTipSlider
