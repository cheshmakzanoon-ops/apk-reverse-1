local base = UIBaseContainer
local UIOffSeason1TaskScorePanel = BaseClass("UIOffSeason1TaskScorePanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIOffSeason1TaskGoalItem = require("UI.LWOffSeason1.Task.Component.UIOffSeason1TaskGoalItem")
local ProgressAddSpeed = 0.4

function UIOffSeason1TaskScorePanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1TaskScorePanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1TaskScorePanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.rawImgBannerImg = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 3)
  self.compGoals = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.imgPointIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textPointCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.goalItemPool = self.transform:Find("Progress/Slider/Goals/GoalItem").gameObject
  self.goalItemPool:SetActive(false)
  self.goalItemPool:GameObjectCreatePool()
end

function UIOffSeason1TaskScorePanel:ComponentDestroy()
  self:ClearGoals()
  self.viewSkin = nil
  self.imgBg = nil
  self.rawImgBannerImg = nil
  self.slider = nil
  self.compGoals = nil
  self.imgPointIcon = nil
  self.textPointCount = nil
end

function UIOffSeason1TaskScorePanel:DataDefine()
  self.goalItemList = nil
  self.sliderFullLen = nil
  self.sliderNodeProgress = nil
  self.nowProgress = 0
  self.targetProgress = 0
  self.nowScore = nil
end

function UIOffSeason1TaskScorePanel:DataDestroy()
  self.goalItemList = nil
  self.sliderFullLen = nil
  self.sliderNodeProgress = nil
  self.nowProgress = nil
  self.targetProgress = nil
  self.nowScore = nil
end

function UIOffSeason1TaskScorePanel:OnAddListener()
  base.OnAddListener(self)
end

function UIOffSeason1TaskScorePanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIOffSeason1TaskScorePanel:SetData(groupId, taskList, score)
  self.groupId = groupId
  self.taskList = taskList
  if self.goalItemList == nil then
    self.sliderFullLen = self.slider:GetSizeDelta().x
    self.goalItemList = {}
    self.sliderNodeProgress = {}
    self.curTargetScores = {}
    local startX = 90
    local anchorPosY = 27
    local fullX = 600
    local offsetX = (fullX - startX) / (#self.taskList - 1)
    for i, v in ipairs(self.taskList) do
      local name = "goalItem" .. i
      local go = self.goalItemPool:GameObjectSpawn(self.compGoals.transform)
      go.name = name
      local comp = self.compGoals:AddComponent(UIOffSeason1TaskGoalItem, name)
      comp:SetActive(true)
      local anchorPosX = startX + (i - 1) * offsetX
      comp:SetAnchoredPositionXY(anchorPosX, anchorPosY)
      table.insert(self.goalItemList, comp)
      table.insert(self.sliderNodeProgress, anchorPosX / self.sliderFullLen)
      table.insert(self.curTargetScores, v.totalNum)
    end
  end
  for i, v in ipairs(self.taskList) do
    local comp = self.goalItemList[i]
    if comp then
      comp:SetData(groupId, v, i)
    end
  end
  if self.nowScore then
    if self.nowScore ~= score then
      self.targetProgress = self:GetScoreProgress(score, 0)
      self.nowScore = score
    end
  else
    self.nowScore = score
    self.nowProgress = self:GetScoreProgress(self.nowScore, 0)
    self.targetProgress = self.nowProgress
    self.slider:SetValue(self.nowProgress)
  end
  self.textPointCount:SetText(self.nowScore)
  self.imgPointIcon:LoadSprite(OffSeason1TaskGroupIconPath[self.groupId])
end

function UIOffSeason1TaskScorePanel:ClearGoals()
  self.goalItemList = nil
  self.compGoals:RemoveComponents(UIOffSeason1TaskGoalItem)
  self.goalItemPool:GameObjectRecycleAll()
end

function UIOffSeason1TaskScorePanel:GetScoreProgress(checkScore, zeroScore)
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
  return value or 0
end

function UIOffSeason1TaskScorePanel:Update()
  if self.targetProgress and self.nowProgress and self.targetProgress > self.nowProgress then
    self.nowProgress = math.min(self.nowProgress + ProgressAddSpeed * Time.deltaTime, self.targetProgress)
    self.slider:SetValue(self.nowProgress)
  end
end

function UIOffSeason1TaskScorePanel:GetFlyTargetPos()
  return self.imgPointIcon.transform.position
end

return UIOffSeason1TaskScorePanel
