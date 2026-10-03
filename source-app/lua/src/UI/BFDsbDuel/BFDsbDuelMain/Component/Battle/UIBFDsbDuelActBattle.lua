local base = UIBaseContainer
local UIBFDsbDuelActBattle = BaseClass("UIBFDsbDuelActBattle", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelActBattleToggle = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Battle.UIBFDsbDuelActBattleToggle")
local UIBFDsbDuelActBattleScoreRuleContentItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Battle.UIBFDsbDuelActBattleScoreRuleContentItem")
local UIBFDsbDuelActBattleAllianceContentItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Battle.UIBFDsbDuelActBattleAllianceContentItem")
local UIBFDsbDuelActBattleRuleContentItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Battle.UIBFDsbDuelActBattleRuleContentItem")
local UIBFDsbDuelActBattleTimeItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Battle.UIBFDsbDuelActBattleTimeItem")
local TeamToggle = {A = 1, B = 2}

function UIBFDsbDuelActBattle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActBattle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgImageWaitBattle = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.rawImgImageWaitBattle2 = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnRule = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnRule:SetOnClick(function()
    self:OnBtnRuleClick()
  end)
  self.textBtnRule = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnShop = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnShop:SetOnClick(function()
    self:OnBtnShopClick()
  end)
  self.textBtnShop = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnBattleResult = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnBattleResult:SetOnClick(function()
    self:OnBtnBattleResultClick()
  end)
  self.textBtnBattleResult = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnLog = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnLog:SetOnClick(function()
    self:OnBtnLogClick()
  end)
  self.textBtnLog = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textBtnReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textTimeTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.compToggleGroup = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleToggle, 17)
  self.textRuleTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compScoreRuleContent = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleScoreRuleContentItem, 19)
  self.compAlliancesContent = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleAllianceContentItem, 20)
  self.compRuleContent = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleRuleContentItem, 21)
  self.compBattleTime = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleTimeItem, 22)
  self.btnEnroll = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnEnroll:SetOnClick(function()
    self:OnBtnEnrollClick()
  end)
  self.compCountDown = self.viewSkin:AddComponent(self, UIBaseContainer, 24)
  self.btnWaiverB = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnWaiverB:SetOnClick(function()
    self:OnBtnWaiverBClick()
  end)
  self.btnDeployment = self.viewSkin:AddComponent(self, UIButton, 26)
  self.btnDeployment:SetOnClick(function()
    self:OnBtnDeploymentClick()
  end)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 27)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btnWatch = self.viewSkin:AddComponent(self, UIButton, 28)
  self.btnWatch:SetOnClick(function()
    self:OnBtnWatchClick()
  end)
  self.textBtnWaiverBTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 29)
  self.btnBattlePlayer = self.viewSkin:AddComponent(self, UIButton, 30)
  self.btnBattlePlayer:SetOnClick(function()
    self:OnBtnBattlePlayerClick()
  end)
  self.compNotRegisterIcon = self.viewSkin:AddComponent(self, UIBaseContainer, 31)
  self.compWinningStreak = self.viewSkin:AddComponent(self, UIBaseContainer, 32)
  self.textWinningStreakTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 33)
  self.imgWinningStreakNum = self.viewSkin:AddComponent(self, UIImage, 34)
  self.btnWinningStreak = self.viewSkin:AddComponent(self, UIButton, 35)
  self.btnWinningStreak:SetOnClick(function()
    self:OnBtnWinningStreakClick()
  end)
  self.compTipGo = self.viewSkin:AddComponent(self, UIBaseComponent, 36)
  self.textWinningStreakTxt:SetLocalText("dsb_duel_tips_1007")
  self.compToggleGroup:SetData({
    clickCallback = function(index)
      self:OnClickToggle(index)
    end
  })
  self.compRuleContent:SetData(BattlefieldDsbDuelUtils.ActTemplateInfo:GetLWDsbLeagueGuideTemplatesByType(BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.Reward))
end

function UIBFDsbDuelActBattle:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgImageWaitBattle = nil
  self.rawImgImageWaitBattle2 = nil
  self.textTitle = nil
  self.btnInfo = nil
  self.btnRule = nil
  self.textBtnRule = nil
  self.btnShop = nil
  self.textBtnShop = nil
  self.btnBattleResult = nil
  self.textBtnBattleResult = nil
  self.btnLog = nil
  self.textBtnLog = nil
  self.btnReward = nil
  self.textBtnReward = nil
  self.textTimeTitle = nil
  self.textRemainTime = nil
  self.compToggleGroup = nil
  self.textRuleTips = nil
  self.compScoreRuleContent = nil
  self.compAlliancesContent = nil
  self.compRuleContent = nil
  self.compBattleTime = nil
  self.btnEnroll = nil
  self.compCountDown = nil
  self.btnWaiverB = nil
  self.btnDeployment = nil
  self.btnGo = nil
  self.btnWatch = nil
  self.textBtnWaiverBTxt = nil
  self.btnBattlePlayer = nil
  self.compNotRegisterIcon = nil
  self.compWinningStreak = nil
  self.textWinningStreakTxt = nil
  self.imgWinningStreakNum = nil
  self.btnWinningStreak = nil
  self.compTipGo = nil
end

function UIBFDsbDuelActBattle:DataDefine()
  self.curToggleIndex = 1
  BattlefieldDsbDuelUtils.ActInfo:SendActPlayerListMsg()
end

function UIBFDsbDuelActBattle:DataDestroy()
  self.curToggleIndex = nil
end

function UIBFDsbDuelActBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  self:AddUIListener(EventId.DsbDuelActPlayerListUpdate, self.ReInit)
  self:AddUIListener(EventId.DsbDuelActTeamSignUpSuccess, self.ReInit)
  self:AddUIListener(EventId.DsbDuelActTeamModifySuccess, self.ReInit)
  self:AddUIListener(EventId.DsbDuelActTeamAssignSuccess, self.ReInit)
  self:AddUIListener(EventId.DsbDuelActInfoUpdate, self.ReInit)
  self:AddUIListener(EventId.BattleFieldCanEnterPush, self.OnBattleFieldCanEnterPush)
end

function UIBFDsbDuelActBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  self:RemoveUIListener(EventId.DsbDuelActPlayerListUpdate, self.ReInit)
  self:RemoveUIListener(EventId.DsbDuelActTeamSignUpSuccess, self.ReInit)
  self:RemoveUIListener(EventId.DsbDuelActTeamModifySuccess, self.ReInit)
  self:RemoveUIListener(EventId.DsbDuelActTeamAssignSuccess, self.ReInit)
  self:RemoveUIListener(EventId.DsbDuelActInfoUpdate, self.ReInit)
  self:RemoveUIListener(EventId.BattleFieldCanEnterPush, self.OnBattleFieldCanEnterPush)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActBattle:OnEnable()
  base.OnEnable(self)
  self:RefreshItemActive()
end

function UIBFDsbDuelActBattle:OnDsbDuelActTimePhaseChange(timePhaseIndex)
  self:ReInit()
  self:RefreshItemActive()
end

function UIBFDsbDuelActBattle:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleDetail, BattleFieldType.DsbDuel)
end

function UIBFDsbDuelActBattle:OnBtnRuleClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertRules, {anim = true}, BattleFieldType.DsbDuel)
end

function UIBFDsbDuelActBattle:OnBtnShopClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.HonorShop)
end

function UIBFDsbDuelActBattle:OnBtnBattleResultClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActHistoryPanel)
end

function UIBFDsbDuelActBattle:OnBtnLogClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActLogView)
end

function UIBFDsbDuelActBattle:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRewardView, {anim = true}, 1, BattleFieldType.DsbDuel)
end

function UIBFDsbDuelActBattle:OnBtnEnrollClick()
  BattlefieldDsbDuelUtils.ActInfo:SendActTeamSignUpMsg({
    team = self.curToggleIndex
  })
end

function UIBFDsbDuelActBattle:OnBtnDeploymentClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActSelectUserV2, {anim = true}, {
    group = self.curToggleIndex
  })
end

function UIBFDsbDuelActBattle:OnBtnGoClick()
  BattleFieldUtil.ClearBattleFieldCanEnterFlag(BattleFieldType.DsbDuel)
  DataCenter.BattlefieldDsbDuelManager:TryEnterBattlefield()
end

function UIBFDsbDuelActBattle:OnBtnWatchClick()
  DataCenter.BattlefieldDsbDuelManager:TryEnterBattlefield(self.curToggleIndex)
end

function UIBFDsbDuelActBattle:OnBtnBattlePlayerClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActSelectUserV2, {anim = true}, {
    group = self.curToggleIndex
  })
end

function UIBFDsbDuelActBattle:OnBattleFieldCanEnterPush(worldType)
  if worldType ~= nil and toInt(worldType) ~= BattleFieldType.DsbDuel then
    return
  end
  self:RefreshTipGo()
end

function UIBFDsbDuelActBattle:OnBtnWinningStreakClick()
end

function UIBFDsbDuelActBattle:OnBtnWaiverBClick()
  if not DataCenter.AllianceBaseDataManager:IsR5() then
    UIUtil.ShowTipsId("dsb_duel_tips_1029")
    return
  end
  local isBClose = self.curToggleIndex == BattlefieldDsbConst.TeamType.B and BattlefieldDsbDuelUtils.ActInfo:GetTeamState(BattlefieldDsbConst.TeamType.B) == BattlefieldDsbConst.BF_DSB_TEAM_STATE.GiveUp
  if isBClose then
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("Desert_strom_tips1080"),
      btnNum = 2,
      showToggle = false,
      sureAction = function()
        BattlefieldDsbDuelUtils.ActInfo:SendActTeamModifyMsg({open = true})
      end
    })
  else
    local cdTime = BattlefieldDsbDuelUtils.ActInfo:GetTeamBCloseCDTime() or 0
    local remainTime = cdTime - UITimeManager:GetInstance():GetServerTime()
    if 0 < remainTime then
      UIUtil.ShowTipsId("Desert_strom_tips1081")
      return
    end
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("Desert_strom_tips1038"),
      btnNum = 2,
      showToggle = false,
      cdConfirm = 10,
      delayConfirm = {delayTime = 10},
      sureAction = function()
        BattlefieldDsbDuelUtils.ActInfo:SendActTeamModifyMsg({open = false})
      end
    })
  end
end

function UIBFDsbDuelActBattle:UpdateTime()
  if self.targetTime then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local timeFormat = UITimeManager:GetInstance():MilliSecondToFmtString(self.targetTime - serverTime)
    self.textRemainTime:SetText(timeFormat)
  end
  if BattlefieldDsbDuelUtils.ActInfo:IsInTeamSignUpPhase() then
    self:RefreshWaiverBtnTxt()
  end
end

function UIBFDsbDuelActBattle:Update1000MS()
  self:UpdateTime()
end

function UIBFDsbDuelActBattle:OnClickToggle(index)
  self.curToggleIndex = index
  self:ReInit()
end

function UIBFDsbDuelActBattle:RefreshWaiverBtnTxt()
  local cdTime = BattlefieldDsbDuelUtils.ActInfo:GetTeamBCloseCDTime() or 0
  local remainTime = cdTime - UITimeManager:GetInstance():GetServerTime()
  local isTeamBGiveUp = BattlefieldDsbDuelUtils.ActInfo:GetTeamState(BattlefieldDsbConst.TeamType.B) == BattlefieldDsbConst.BF_DSB_TEAM_STATE.GiveUp
  local str
  if not isTeamBGiveUp then
    if 0 < remainTime then
      str = Localization:GetString("Desert_strom_tips1039") .. "\n" .. UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTime / 1000)
    else
      str = Localization:GetString("Desert_strom_tips1039")
    end
  else
    str = Localization:GetString("390097")
  end
  self.textBtnWaiverBTxt:SetText(str)
end

function UIBFDsbDuelActBattle:RefreshItemActive()
  self.compAlliancesContent:RefreshActive()
  self.compRuleContent:RefreshActive()
  self.compScoreRuleContent:RefreshActive()
  self.compBattleTime:RefreshActive()
  self.compToggleGroup:RefreshActive()
end

function UIBFDsbDuelActBattle:ReInit()
  local isRegisteredAct = BattlefieldDsbDuelUtils.ActInfo:IsRegistered()
  local isTeamSignUp = BattlefieldDsbDuelUtils.ActInfo:IsTeamSignUp(self.curToggleIndex)
  local isTeamMatched = BattlefieldDsbDuelUtils.ActInfo:IsTeamMatched(self.curToggleIndex)
  local isTeamBye = BattlefieldDsbDuelUtils.ActInfo:IsTeamBye(self.curToggleIndex)
  local isInSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase()
  local isInGroupPhase = BattlefieldDsbDuelUtils.ActInfo:IsInGroupPhase()
  local IsInTeamWaitSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamWaitSignUpPhase()
  local isInTeamSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamSignUpPhase()
  local isInTeamMatchPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamMatchPhase()
  local isInTeamWaitBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamWaitBattlePhase()
  local isInTeamBattleReadyPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattleReadyPhase()
  local isInTeamBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattlePhase()
  local isInTeamResultShowPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamResultShowPhase()
  self.compAlliancesContent:SetData({
    isTeamA = self.curToggleIndex == TeamToggle.A,
    isMatching = isInTeamMatchPhase,
    isBattleReady = isInTeamWaitBattlePhase or isInTeamBattleReadyPhase,
    isInBattle = isInTeamBattlePhase or isInTeamResultShowPhase,
    isTeamSignUpOrMatched = isTeamSignUp or isTeamMatched,
    isTeamBye = isTeamBye
  })
  self.compBattleTime:SetData({
    team = self.curToggleIndex
  })
  self.compScoreRuleContent:SetData(self.curToggleIndex)
  self.btnGo:SetActive(false)
  self.btnDeployment:SetActive(false)
  self.btnWaiverB:SetActive(false)
  self.btnEnroll:SetActive(false)
  self.btnWatch:SetActive(false)
  self.btnBattlePlayer:SetActive(false)
  self.btnLog:SetActive(isRegisteredAct)
  self.btnShop:SetActive(isRegisteredAct)
  self.btnBattleResult:SetActive(isRegisteredAct)
  self.textTitle:SetLocalText("dsb_duel_interface_1023")
  self.textRuleTips:SetActive(not isRegisteredAct or isInSignUpPhase or isInGroupPhase or IsInTeamWaitSignUpPhase)
  self.compNotRegisterIcon:SetActive(not isRegisteredAct and not isInSignUpPhase)
  if not isRegisteredAct then
    self.textRuleTips:SetLocalText(isInSignUpPhase and "dsb_duel_interface_1030" or "dsb_duel_interface_1036")
  else
    self.textRuleTips:SetLocalText("dsb_duel_interface_1030")
  end
  if not isRegisteredAct or isInSignUpPhase or isInGroupPhase then
    self:RefreshBg(false, true)
    local signUpEndTime = BattlefieldDsbDuelUtils.ActInfo:GetSignUpEndTime()
    self:RefreshCountDown(isRegisteredAct or signUpEndTime > UITimeManager:GetInstance():GetServerTime())
    self.textTimeTitle:SetLocalText(isInSignUpPhase and "dsb_duel_interface_1026" or "dsb_duel_interface_1025")
  else
    self:RefreshWinningStreak()
    self:RefreshBg(isInTeamSignUpPhase, IsInTeamWaitSignUpPhase or isInTeamMatchPhase or isInTeamWaitBattlePhase or isInTeamBattleReadyPhase or isInTeamBattlePhase or isInTeamResultShowPhase)
    if IsInTeamWaitSignUpPhase then
      self.textTimeTitle:SetLocalText("dsb_duel_interface_1025")
      self:RefreshCountDown(true)
    elseif isInTeamSignUpPhase then
      self.textTimeTitle:SetLocalText("dsb_duel_interface_1026")
      local isGiveUp = BattlefieldDsbDuelUtils.ActInfo:IsTeamGiveUp(self.curToggleIndex)
      self.btnEnroll:SetActive(not isTeamSignUp and not isGiveUp)
      self.btnWaiverB:SetActive(self.curToggleIndex == TeamToggle.B)
      self.btnDeployment:SetActive(isTeamSignUp)
      self.btnBattlePlayer:SetActive(true)
      self:RefreshCountDown(true)
    elseif isInTeamMatchPhase or isInTeamWaitBattlePhase or isInTeamBattleReadyPhase or isInTeamBattlePhase or isInTeamResultShowPhase then
      if isInTeamMatchPhase then
        self.textTimeTitle:SetLocalText("dsb_duel_interface_1027")
      elseif isInTeamWaitBattlePhase or isInTeamBattleReadyPhase then
        self.textTimeTitle:SetLocalText("dsb_duel_interface_1028")
      elseif isInTeamBattlePhase then
        self.textTimeTitle:SetLocalText("dsb_duel_interface_1029")
      elseif isInTeamResultShowPhase then
        self.textTimeTitle:SetLocalText("dsb_duel_interface_1037")
      end
      local isSelfInTeam = BattlefieldDsbDuelUtils.ActInfo:IsSelfInTeam(self.curToggleIndex)
      if isInTeamBattleReadyPhase then
        local selfTeamState = BattlefieldDsbDuelUtils.ActInfo:GetSelfAssigned()
        self.btnGo:SetActive(isTeamMatched and selfTeamState == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Main and isSelfInTeam and BattlefieldDsbDuelUtils.GetEnterBattleState() ~= BattlefieldDsbConst.EnterBattleState.LeaveBattle)
      else
        self.btnGo:SetActive(isTeamMatched and (isInTeamWaitBattlePhase or isInTeamBattlePhase) and isSelfInTeam and BattlefieldDsbDuelUtils.GetEnterBattleState() ~= BattlefieldDsbConst.EnterBattleState.LeaveBattle)
      end
      CS.UIGray.SetGray(self.btnGo.transform, isInTeamWaitBattlePhase, not isInTeamWaitBattlePhase)
      self.btnWatch:SetActive(isTeamMatched and (isInTeamWaitBattlePhase or isInTeamBattleReadyPhase or isInTeamBattlePhase) and BattlefieldDsbDuelUtils.GetEnterBattleState() ~= BattlefieldDsbConst.EnterBattleState.InBattle)
      CS.UIGray.SetGray(self.btnWatch.transform, isInTeamWaitBattlePhase, not isInTeamWaitBattlePhase)
      self.btnBattlePlayer:SetActive(true)
      self:RefreshCountDown(true)
    end
  end
  self:RefreshTipGo()
  self:UpdateTime()
end

function UIBFDsbDuelActBattle:RefreshTipGo()
  local bMyGroup = BattlefieldDsbDuelUtils.ActInfo:IsSelfInTeam(self.curToggleIndex)
  local show = bMyGroup and self.btnGo:GetActive() and BattleFieldUtil.GetBattleFieldCanEnterFlag(BattleFieldType.DsbDuel)
  self.compTipGo:SetActive(show)
  if not show then
    return
  end
  local x = self.btnGo:GetLocalPositionXYZ()
  local _, y, z = self.compTipGo:GetLocalPositionXYZ()
  self.compTipGo:SetLocalPositionXYZ(x, y, z)
end

function UIBFDsbDuelActBattle:RefreshBg(bigBgActive, smallBgActive)
  self.rawImgImageWaitBattle:SetActive(bigBgActive)
  self.rawImgImageWaitBattle2:SetActive(smallBgActive)
end

function UIBFDsbDuelActBattle:RefreshCountDown(active)
  self.compCountDown:SetActive(active)
  local sTime, eTime = BattlefieldDsbDuelUtils.ActInfo:GetCurrentPhaseStartEndTime()
  self.targetTime = active and eTime or nil
end

local numImgPrefix = "Assets/Main/Sprites/UI/UIMultiKill/number_%d.png"

function UIBFDsbDuelActBattle:RefreshWinningStreak()
  local winStreakNum = BattlefieldDsbDuelUtils.ActInfo:GetWinStreakNum()
  if 9 < winStreakNum or winStreakNum < 0 then
    return
  end
  self.imgWinningStreakNum:LoadSpriteAuto(string.format(numImgPrefix, winStreakNum))
end

return UIBFDsbDuelActBattle
