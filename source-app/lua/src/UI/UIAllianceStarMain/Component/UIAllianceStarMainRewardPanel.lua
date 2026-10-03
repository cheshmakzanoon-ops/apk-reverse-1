local UIAllianceStarMainRewardPanel = BaseClass("UIAllianceStarMainRewardPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rewardBtn = self:AddComponent(UIButton, "RewardBtn")
  self.rewardOpenImg = self:AddComponent(UIImage, "RewardBtn/reward_open")
  self.redPoint = self:AddComponent(UIBaseContainer, "RewardBtn/RedPoint")
  self.rewardBtn:SetOnClick(function()
    if self.canReward then
      self.rewardAnim:Play("V_ui_aliiancestar_icon_open")
      self.rewardAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:StopRewardAnimTimer()
        SFSNetwork.SendMessage(MsgDefines.AllianceStarCeremonyQuestEmojiRewardNew)
      end, 0.9)
    else
      self.view:OpenRewardTipPanel()
    end
  end)
  self.rewardAnim = self:AddComponent(UIAnimator, "RewardBtn")
  self.effect = self:AddComponent(UIBaseContainer, "Effect")
  self.effect:SetActive(false)
  self.progressBar = self:AddComponent(UIImage, "ProgressBgImg/ProgressBar")
  self.progressText = self:AddComponent(UIText, "ProgressText")
  self.thumbsUpTip = self:AddComponent(UIBaseComponent, "ThumbsUpTip")
  self.thumbsUpTipText = self:AddComponent(UIText, "ThumbsUpTip/TipText")
  self.thumbsUpTipText:SetLocalText("alliance_weeklyStar_reward_tips")
  self.thumbsUpTipGoBtn = self:AddComponent(UIButton, "ThumbsUpTip/GoBtn")
  self.thumbsUpTipGoBtn:SetOnClick(function()
    self:OnThumbsUpTipGoBtnClick()
  end)
  self.thumbsUpTipGoBtnText = self:AddComponent(UIText, "ThumbsUpTip/GoBtn/LW_Btn_Common_New_Base/GoBtnText")
  self.thumbsUpTipGoBtnText:SetLocalText("110003")
  self:Refresh()
end

local function ComponentDestroy(self)
  self.rewardBtn = nil
  self.redPoint = nil
  self.redPointNumText = nil
  self.rewardAnim = nil
  self.effect = nil
  self.progressBar = nil
  self.progressText = nil
  self.thumbsUpTip = nil
  self.thumbsUpTipText = nil
  self.thumbsUpTipGoBtn = nil
  self.thumbsUpTipGoBtnText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:StopTimer()
  self:StopRewardAnimTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self)
  local rewardInfo = DataCenter.AllianceStarManager:GetEmojiThumbsRewardInfo()
  self.canReward = false
  local claimedIndex = 0
  local count = 0
  if rewardInfo then
    self.canReward = rewardInfo.canReward
    if rewardInfo.canReward then
      self.redPoint:SetActive(true)
      self:SetBoxCanOpenAnim(true)
      self.effect:SetActive(false)
      self.effect:SetActive(true)
    else
      self.redPoint:SetActive(false)
      self:SetBoxCanOpenAnim(false)
      self.effect:SetActive(false)
    end
    claimedIndex = rewardInfo.claimedIndex
    count = rewardInfo.count
  else
    self.redPoint:SetActive(false)
    self:SetBoxCanOpenAnim(false)
    self.effect:SetActive(false)
  end
  local rewardSetting = DataCenter.AllianceStarManager:GetRewardSetting()
  local nextStage = math.min(#rewardSetting, claimedIndex + 1)
  local nextSetting = rewardSetting[nextStage]
  local nextCount = nextSetting[1]
  self.progressText:SetText(count .. "/" .. nextCount)
  self.progressBar:SetFillAmount(count / nextCount)
  self.rewardOpenImg:LoadSprite(string.format(LoadPath.UIPersonalArms, AlStarRewardBoxImg[nextStage].openImg))
  self.rewardBtn:LoadSprite(string.format(LoadPath.UIPersonalArms, AlStarRewardBoxImg[nextStage].closeImg))
  if not self.canReward and nextStage == #rewardSetting and count >= nextCount then
    self.rewardBtn:LoadSprite(string.format(LoadPath.UIPersonalArms, AlStarRewardBoxImg[nextStage].openImg))
  end
  self:RefreshThumbsUpTipShow(false)
end

local function SetBoxCanOpenAnim(self, isShowAnim)
  if isShowAnim then
    self.rewardAnim:Enable(true)
    self.rewardAnim:Play("V_ui_icon_rewards")
  else
    self.rewardAnim:Enable(true)
    self.rewardAnim:Play("V_ui_aliiancestar_icon_idle")
  end
end

local function DoBoxScaleVX(self)
  self.rewardAnim:Enable(true)
  self.rewardAnim:Play("V_ui_icon_scale")
  self:StopTimer()
  self.boxVxTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:Refresh()
  end, 0.3)
end

local function StopTimer(self)
  if self.boxVxTimer ~= nil then
    self.boxVxTimer:Stop()
    self.boxVxTimer = nil
  end
end

local function OnAllianceStarCeremonyQuestEmojiReward(self)
  self:Refresh()
end

local function StopRewardAnimTimer(self)
  if self.rewardAnimTimer then
    self.rewardAnimTimer:Stop()
    self.rewardAnimTimer = nil
  end
end

function UIAllianceStarMainRewardPanel:RefreshThumbsUpTipShow(needCheckShow)
  self.thumbsUpTip:SetActive(false)
  if needCheckShow then
    local rewardInfo = DataCenter.AllianceStarManager:GetEmojiThumbsRewardInfo()
    if rewardInfo and rewardInfo.count == 0 then
      self.thumbsUpTip:SetActive(true)
    end
  end
end

function UIAllianceStarMainRewardPanel:OnThumbsUpTipGoBtnClick()
  local jumpIndex = DataCenter.AllianceStarManager.thumbsUpJumpIndex or 1
  DataCenter.AllianceStarManager:ChangeProgressCtrlStageById(jumpIndex)
  DataCenter.AllianceStarManager:ChangeCurStageInnerStage(AlStarCeremonyInnerState[AlStarCeremonyState.ReadPersonReward].State5)
end

UIAllianceStarMainRewardPanel.OnCreate = OnCreate
UIAllianceStarMainRewardPanel.OnDestroy = OnDestroy
UIAllianceStarMainRewardPanel.OnEnable = OnEnable
UIAllianceStarMainRewardPanel.OnDisable = OnDisable
UIAllianceStarMainRewardPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainRewardPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainRewardPanel.DataDefine = DataDefine
UIAllianceStarMainRewardPanel.DataDestroy = DataDestroy
UIAllianceStarMainRewardPanel.OnAddListener = OnAddListener
UIAllianceStarMainRewardPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainRewardPanel.Refresh = Refresh
UIAllianceStarMainRewardPanel.SetBoxCanOpenAnim = SetBoxCanOpenAnim
UIAllianceStarMainRewardPanel.DoBoxScaleVX = DoBoxScaleVX
UIAllianceStarMainRewardPanel.StopTimer = StopTimer
UIAllianceStarMainRewardPanel.OnAllianceStarCeremonyQuestEmojiReward = OnAllianceStarCeremonyQuestEmojiReward
UIAllianceStarMainRewardPanel.StopRewardAnimTimer = StopRewardAnimTimer
return UIAllianceStarMainRewardPanel
