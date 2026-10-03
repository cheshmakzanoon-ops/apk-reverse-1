local UIAllianceStarMainView = BaseClass("UIAllianceStarMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIAllianceStarMainTipPanel = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainTipPanel")
local UIAllianceStarMainPersonAwardPanel = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainPersonAwardPanel")
local UIAllianceStarMainScenePanel = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainScenePanel")
local UIAllianceStarMainBubblePanel = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainBubblePanel")
local UIAllianceStarMainLeavePanel = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainLeavePanel")
local UIAllianceStarMainPersonListPanel = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainPersonListPanel")
local UIAllianceStarMainRewardPanel = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainRewardPanel")
local UIAllianceStarMainBottomPanel = require("UI.UIAllianceStarMain.Component.Bottom.UIAllianceStarMainBottomPanel")
local UIAllianceStarMainThumbPanel = require("UI.UIAllianceStarMain.Component.Thumb.UIAllianceStarMainThumbPanel")
local UIAllianceStarBottomEmojiPanel = require("UI.UIAllianceStarMain.Component.Bottom.UIAllianceStarBottomEmojiPanel")
local UIAllianceStarMainRewardTipPanel = require("UI.UIAllianceStarMain.Component.RewardTip.UIAllianceStarMainRewardTipPanel")
local UIAllianceStarMainRewardTipPanelPath = "Assets/Main/Prefabs/UI/UIAllianceStar/UIAllianceStarMainRewardTipPanel.prefab"
local UIAllianceStarMainJumpPanel = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainJumpPanel")

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl.view = self
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
  self.compEmojiListPanel:SetActive(false)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compBottomPanel = self:AddComponent(UIAllianceStarMainBottomPanel, "Root/BottomPanel")
  self.anim = self:AddComponent(UIAnimator, "")
  self.textTitle = self:AddComponent(UIText, "Root/TitleText")
  self.compTipPanel = self:AddComponent(UIAllianceStarMainTipPanel, "Root/TipPanel")
  self.compPersonAwardPanel = self:AddComponent(UIAllianceStarMainPersonAwardPanel, "Root/PersonAwardPanel")
  self.compScenePanel = self:AddComponent(UIAllianceStarMainScenePanel, "Root/SceneRT")
  self.compBubblePanel = self:AddComponent(UIAllianceStarMainBubblePanel, "Root/BubblePanel")
  self.compLeavePanel = self:AddComponent(UIAllianceStarMainLeavePanel, "Root/LeavePanel")
  self.compPersonListPanel = self:AddComponent(UIAllianceStarMainPersonListPanel, "Root/PersonListPanel")
  self.compRewardPanel = self:AddComponent(UIAllianceStarMainRewardPanel, "Root/RewardPanel")
  self.compThumbPanel = self:AddComponent(UIAllianceStarMainThumbPanel, "Root/ThumbPanel")
  self.compEmojiListPanel = self:AddComponent(UIAllianceStarBottomEmojiPanel, "Root/EmojiListPanel")
  self.compJumpPanel = self:AddComponent(UIAllianceStarMainJumpPanel, "Root/JumpPanel")
  self.effectCaidai = self:AddComponent(UIBaseContainer, "Eff_ui_alliance_caidai")
  self.effectCaidai:SetActive(false)
  self.compTipPanel:SetActive(false)
  self.compPersonAwardPanel:SetActive(false)
  self.compScenePanel:SetActive(false)
  self.compLeavePanel:SetActive(false)
  self.compPersonListPanel:SetActive(false)
  self.compThumbPanel:SetActive(false)
  self.compEmojiListPanel:SetActive(false)
  self.compJumpPanel:SetActive(false)
  self.compBottomPanel:SetActive(true)
  self.compBubblePanel:SetActive(true)
  self.compRewardPanel:SetActive(true)
  self:SyncCompRect(self.compScenePanel, self.compBubblePanel)
end

local function ComponentDestroy(self)
  self.compAnim = nil
  self.textTitle = nil
  self.compTipPanel = nil
  self.compPersonAwardPanel = nil
  self.compScenePanel = nil
  self.compBubblePanel = nil
  self.compLeavePanel = nil
  self.compPersonListPanel = nil
  self.compRewardPanel = nil
  self.effectCaidai = nil
  self.compBottomPanel = nil
  self.compThumbPanel = nil
  self.compEmojiListPanel = nil
end

local function DataDefine(self)
  DataCenter.AllianceStarManager:EnterCeremonyScene(function(sceneObj)
    self:OnScreenCreate(sceneObj)
  end)
  self.textTitle:SetLocalText("alliance_weeklyStar_ceremony_title", LuaEntry.Player:GetAllianceAbbr(), DataCenter.AllianceStarManager:GetCeremonyEdition())
  self:OnAllianceStarCeremonyRewardInfoPush()
  if self.enterTime == nil then
    self.enterTime = tonumber(CommonUtil.PlayerPrefsGetString(SettingKeys.AL_STAR_ENTER_CEREMONY, "0"))
  end
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local todayFirst = not UITimeManager:GetInstance():IsSameDayForServer(self.enterTime, now)
  if todayFirst then
    CommonUtil.PlayerPrefsSetString(SettingKeys.AL_STAR_ENTER_CEREMONY, now)
    self:OnAllianceStarMainPlayAnim(AlStarMainUIAnimName.In)
  else
    self.anim:Enable(false)
  end
end

local function DataDestroy(self)
  DataCenter.AllianceStarManager:ExitCeremonyScene()
  self.enterTime = nil
  self.inThumb = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarCeremonyRefreshMainPanel, self.OnAllianceStarCeremonyRefreshMainPanel)
  self:AddUIListener(EventId.AllianceStarCeremonyRewardInfoPush, self.OnAllianceStarCeremonyRewardInfoPush)
  self:AddUIListener(EventId.AllianceStarMainPlayAnim, self.OnAllianceStarMainPlayAnim)
  self:AddUIListener(EventId.AllianceStarCeremonyQuestReward, self.OnAllianceStarCeremonyQuestReward)
  self:AddUIListener(EventId.AllianceStarCeremonyQuestEmojiReward, self.OnAllianceStarCeremonyQuestEmojiReward)
  self:AddUIListener(EventId.AllianceStarGainActivityInfoNewRefresh, self.OnAllianceStarGainActivityInfoNewRefresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceStarCeremonyRefreshMainPanel, self.OnAllianceStarCeremonyRefreshMainPanel)
  self:RemoveUIListener(EventId.AllianceStarCeremonyRewardInfoPush, self.OnAllianceStarCeremonyRewardInfoPush)
  self:RemoveUIListener(EventId.AllianceStarMainPlayAnim, self.OnAllianceStarMainPlayAnim)
  self:RemoveUIListener(EventId.AllianceStarCeremonyQuestReward, self.OnAllianceStarCeremonyQuestReward)
  self:RemoveUIListener(EventId.AllianceStarCeremonyQuestEmojiReward, self.OnAllianceStarCeremonyQuestEmojiReward)
  self:RemoveUIListener(EventId.AllianceStarGainActivityInfoNewRefresh, self.OnAllianceStarGainActivityInfoNewRefresh)
  base.OnRemoveListener(self)
end

local function OnScreenCreate(self, sceneObj)
  self.compScenePanel:OnScreenCreate(sceneObj)
end

local function OnClickBack(self)
  self.ctrl:CloseSelf()
end

local function CheckAddAllyBubble(self, chatData)
  self.compBubblePanel:CheckAddAllyBubble(chatData)
end

local function OnAllianceStarCeremonyRefreshMainPanel(self, panelParamList)
  self:OnAllianceStarCeremonyRewardInfoPush()
  self.compTipPanel:SetActive(false)
  self.compPersonAwardPanel:SetActive(false)
  self.compLeavePanel:SetActive(false)
  self.compPersonListPanel:SetActive(false)
  self.compThumbPanel:SetActive(false)
  self.compEmojiListPanel:SetActive(false)
  self.compJumpPanel:SetActive(false)
  self.compRewardPanel:RefreshThumbsUpTipShow(false)
  self.inInteraction = false
  self.inThumb = false
  if panelParamList then
    for i, v in ipairs(panelParamList) do
      local panelParam = v
      if panelParam.panelType == AlStarCeremonyPanelType.Tip then
        DataCenter.AllianceStarManager:PlaySfx(70008)
        self.compTipPanel:SetActive(true)
        self.compTipPanel:Refresh(panelParam.param)
      elseif panelParam.panelType == AlStarCeremonyPanelType.PersonAward then
        self.compPersonAwardPanel:SetActive(true)
        self.compPersonAwardPanel:Refresh(panelParam.param)
      elseif panelParam.panelType == AlStarCeremonyPanelType.Leave then
        self.compLeavePanel:SetActive(true)
        self.compLeavePanel:Refresh(panelParam.param)
        self.compRewardPanel:RefreshThumbsUpTipShow(true)
      elseif panelParam.panelType == AlStarCeremonyPanelType.PersonList then
        self.compPersonListPanel:SetActive(true)
        self.compPersonListPanel:Refresh(panelParam.param)
      elseif panelParam.panelType == AlStarCeremonyPanelType.Thumb then
        self.inThumb = true
        self.compThumbPanel:SetActive(true)
        self.compThumbPanel:Refresh(panelParam.param)
      elseif panelParam.panelType == AlStarCeremonyPanelType.EmojiList then
        self.compEmojiListPanel:SetActive(true)
        self.compEmojiListPanel:Refresh(panelParam.param)
      end
    end
  end
end

local function OnAllianceStarCeremonyRewardInfoPush(self)
  if DataCenter.AllianceStarManager:ShowReward() then
    self.compRewardPanel:SetActive(true)
    self.compRewardPanel:Refresh()
  else
    self.compRewardPanel:SetActive(false)
  end
end

local function GetPersonAwardPlayerHead(self)
  return self.compPersonAwardPanel.compUIPlayerHead
end

local function OnAllianceStarMainPlayAnim(self, animName)
  self.anim:Enable(true)
  self.anim:Play(animName)
  if animName == AlStarMainUIAnimName.Reward then
    DataCenter.AllianceStarManager:PlaySfx(70008)
  end
end

local function PlayCaidaiEffect(self)
  DataCenter.AllianceStarManager:PlaySfx(70007)
  self.effectCaidai:SetActive(false)
  self.effectCaidai:SetActive(true)
end

local function GetRewardIconPos(self)
  return self.compRewardPanel.rewardBtn:GetPosition()
end

local function DoRewardBoxScaleVX(self)
  self.compRewardPanel:DoBoxScaleVX()
end

local function SyncCompRect(self, source, target)
  target:SetAnchoredPosition(source:GetAnchoredPosition())
  target:SetSizeDelta(source:GetSizeDelta())
  target:SetOffsetMax(source:GetOffsetMax())
  target:SetOffsetMin(source:GetOffsetMin())
end

function UIAllianceStarMainView:OnAllianceStarCeremonyQuestReward()
  self.compLeavePanel:RefreshRewardBox()
  self.compBottomPanel:OnAllianceStarCeremonyQuestReward()
end

function UIAllianceStarMainView:OnAllianceStarCeremonyQuestEmojiReward()
  self.compRewardPanel:OnAllianceStarCeremonyQuestEmojiReward()
end

function UIAllianceStarMainView:OpenRewardTipPanel()
  if self.compRewardTipPanel == nil then
    self.compRewardTipPanel = self:LoadComponentAsync(UIAllianceStarMainRewardTipPanel, UIAllianceStarMainRewardTipPanelPath, self.transform:Find("Root"))
  end
  self.compRewardTipPanel:SetActive(true)
end

function UIAllianceStarMainView:CloseRewardTipPanel()
  self.compRewardTipPanel:SetActive(false)
end

function UIAllianceStarMainView:ShowEmojiBubbleByEmojiId(emojiId, isSelf)
  self.compBubblePanel:ShowEmojiBubbleByEmojiId(emojiId, isSelf)
end

function UIAllianceStarMainView:OnAllianceStarGainActivityInfoNewRefresh()
  if not DataCenter.AllianceStarManager:IsShowAlStarTipBar() then
    self.ctrl:CloseSelf()
  end
end

UIAllianceStarMainView.OnCreate = OnCreate
UIAllianceStarMainView.OnDestroy = OnDestroy
UIAllianceStarMainView.OnEnable = OnEnable
UIAllianceStarMainView.OnDisable = OnDisable
UIAllianceStarMainView.ComponentDefine = ComponentDefine
UIAllianceStarMainView.ComponentDestroy = ComponentDestroy
UIAllianceStarMainView.DataDefine = DataDefine
UIAllianceStarMainView.DataDestroy = DataDestroy
UIAllianceStarMainView.OnAddListener = OnAddListener
UIAllianceStarMainView.OnRemoveListener = OnRemoveListener
UIAllianceStarMainView.OnScreenCreate = OnScreenCreate
UIAllianceStarMainView.OnClickBack = OnClickBack
UIAllianceStarMainView.CheckAddAllyBubble = CheckAddAllyBubble
UIAllianceStarMainView.OnAllianceStarCeremonyRefreshMainPanel = OnAllianceStarCeremonyRefreshMainPanel
UIAllianceStarMainView.OnAllianceStarCeremonyRewardInfoPush = OnAllianceStarCeremonyRewardInfoPush
UIAllianceStarMainView.GetPersonAwardPlayerHead = GetPersonAwardPlayerHead
UIAllianceStarMainView.OnAllianceStarMainPlayAnim = OnAllianceStarMainPlayAnim
UIAllianceStarMainView.PlayCaidaiEffect = PlayCaidaiEffect
UIAllianceStarMainView.GetRewardIconPos = GetRewardIconPos
UIAllianceStarMainView.DoRewardBoxScaleVX = DoRewardBoxScaleVX
UIAllianceStarMainView.SyncCompRect = SyncCompRect
return UIAllianceStarMainView
