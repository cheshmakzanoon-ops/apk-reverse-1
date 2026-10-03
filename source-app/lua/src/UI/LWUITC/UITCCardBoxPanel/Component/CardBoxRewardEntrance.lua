local CardBoxRewardEntrance = BaseClass("CardBoxRewardEntrance", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetActive(false)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, "")
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.progress = self:AddComponent(UIImage, "stageState/progress")
  self.pointNumber_txt = self:AddComponent(UIText, "stageState/pointNumber_txt")
  self.rewardIcon = self:AddComponent(UIImage, "stageState/reward_icon")
  self.redDot = self:AddComponent(UIImage, "stageState/red")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.anim = nil
  self.progress = nil
  self.pointNumber_txt = nil
end

local function DataDefine(self)
  self.currentScore = 0
  self.scoreRewardStages = {}
  self.nextRewardStage = nil
end

local function DataDestroy(self)
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function CardBoxRewardEntrance:RefreshData()
  self.currentScore = DataCenter.TacticalCardDataManager:GetScoreInfo() or 0
  local season = DataCenter.SeasonDataManager:GetSeason()
  self.scoreRewardStages = DataCenter.TacticalCardDataManager:GetPointRewardStages(season)
  self.nextRewardStage = self:GetNextRewardStage()
  self:RefreshUI()
end

function CardBoxRewardEntrance:GetNextRewardStage()
  for i, stageData in ipairs(self.scoreRewardStages) do
    if stageData.claimState ~= 1 then
      return stageData
    end
  end
  return nil
end

function CardBoxRewardEntrance:RefreshUI()
  if not self.nextRewardStage then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self:UpdateRewardIcon()
  self:UpdateScoreDisplay()
  self:UpdateProgress()
  self:UpdateRedDotAndEffect()
end

function CardBoxRewardEntrance:UpdateRewardIcon()
  if self.nextRewardStage then
    local iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.nextRewardStage.goodsId)
    self.rewardIcon:LoadSprite(iconPath)
  end
end

function CardBoxRewardEntrance:UpdateScoreDisplay()
  local needScore = self.nextRewardStage.point
  local displayText = string.format("%d/%d", self.currentScore, needScore)
  self.pointNumber_txt:SetText(displayText)
end

function CardBoxRewardEntrance:UpdateProgress()
  local needScore = self.nextRewardStage.point
  local progressValue = math.min(self.currentScore / needScore, 1)
  self.progress:SetFillAmount(progressValue)
end

function CardBoxRewardEntrance:UpdateRedDotAndEffect()
  local hasClaimableReward = self:HasClaimableReward()
  self.redDot:SetActive(hasClaimableReward)
  if hasClaimableReward then
    self.anim:Play("full")
  else
    self.anim:Play("idle")
  end
end

function CardBoxRewardEntrance:HasClaimableReward()
  for i, stageData in ipairs(self.scoreRewardStages) do
    if self.currentScore >= stageData.point and stageData.claimState ~= 1 then
      return true
    end
  end
  return false
end

function CardBoxRewardEntrance:OnClick()
  if self:HasClaimableReward() then
    self:ClaimAllAvailableRewards()
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITCBoxPointReward, {anim = true})
  end
end

function CardBoxRewardEntrance:ClaimAllAvailableRewards()
  local canClaim = false
  for i, stageData in ipairs(self.scoreRewardStages) do
    if self.currentScore >= stageData.point and stageData.claimState ~= 1 then
      canClaim = true
      break
    end
  end
  if canClaim then
    SFSNetwork.SendMessage(MsgDefines.BattleCardScoreReward)
  end
end

function CardBoxRewardEntrance:OnScoreInfoChanged()
  self:RefreshData()
end

CardBoxRewardEntrance.OnCreate = OnCreate
CardBoxRewardEntrance.OnDestroy = OnDestroy
CardBoxRewardEntrance.ComponentDefine = ComponentDefine
CardBoxRewardEntrance.ComponentDestroy = ComponentDestroy
CardBoxRewardEntrance.DataDefine = DataDefine
CardBoxRewardEntrance.DataDestroy = DataDestroy
CardBoxRewardEntrance.OnAddListener = OnAddListener
CardBoxRewardEntrance.OnRemoveListener = OnRemoveListener
return CardBoxRewardEntrance
