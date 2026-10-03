local base = UIAsyncContainer
local UIGray = CS.UIGray
local UIRaceEntranceDsbTopItemComponent = BaseClass("UIRaceEntranceDsbTopItemComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function UIRaceEntranceDsbTopItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRaceEntranceDsbTopItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRaceEntranceDsbTopItemComponent:OnEnable()
  base.OnEnable(self)
  self:UpdateData()
end

function UIRaceEntranceDsbTopItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compInBattle = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compOutBattle = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textRankTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compIconBg = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.imgUpIcon = self.viewSkin:AddComponent(self, UIImage, 14)
  self.btnUIRaceEntranceDsbTopItem = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnUIRaceEntranceDsbTopItem:SetOnClick(function()
    self:OnBtnUIRaceEntranceDsbTopItemClick()
  end)
  self.textTxtName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.btnBubbleJump = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnBubbleJump:SetOnClick(function()
    self:OnBtnBubbleJumpClick()
  end)
  self.textGo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compNew = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.btnBubbleTip = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnBubbleTip:SetOnClick(function()
    self:OnBtnBubbleTipClick()
  end)
  self.textTitle2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compRedAward = self.viewSkin:AddComponent(self, UIBaseContainer, 22)
  self.compRedAward:SetActive(false)
end

function UIRaceEntranceDsbTopItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textName = nil
  self.imgIcon = nil
  self.textTitle = nil
  self.compInBattle = nil
  self.compOutBattle = nil
  self.textRankTxt = nil
  self.textText1 = nil
  self.textText2 = nil
  self.textText3 = nil
  self.textDesc = nil
  self.btnJump = nil
  self.textBtn = nil
  self.compIconBg = nil
  self.imgUpIcon = nil
  self.btnUIRaceEntranceDsbTopItem = nil
  self.textTxtName = nil
  self.btnBubbleJump = nil
  self.textGo = nil
  self.compNew = nil
  self.btnBubbleTip = nil
  self.textTitle2 = nil
  self.compRedAward = nil
end

function UIRaceEntranceDsbTopItemComponent:DataDefine()
  if BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase() then
    BattlefieldDsbDuelUtils.ActInfo:SendActGroupListMsg(BattlefieldDsbConst.BF_DSB_GROUP_TYPE.ALL)
  elseif BattlefieldDsbDuelUtils.ActInfo:IsInResultShowPhase() then
    BattlefieldDsbDuelUtils.ActInfo:SendActRewardInfoMsg()
  end
end

function UIRaceEntranceDsbTopItemComponent:DataDestroy()
  self:ClearTimer()
  BattlefieldDsbDuelUtils.ActInfo:SetIsOpenEntranceInThisTeamSignUpPhase(true)
end

function UIRaceEntranceDsbTopItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActRankInfoUpdate, self.OnDsbDuelActRankInfoUpdate)
  self:AddUIListener(EventId.DsbDuelActOnGetRewardList, self.OnDsbDuelActRewardReceived)
end

function UIRaceEntranceDsbTopItemComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActRankInfoUpdate, self.OnDsbDuelActRankInfoUpdate)
  self:RemoveUIListener(EventId.DsbDuelActOnGetRewardList, self.OnDsbDuelActRewardReceived)
  base.OnRemoveListener(self)
end

function UIRaceEntranceDsbTopItemComponent:UpdateData()
  local isInBattle = BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase() and LuaEntry.Player:IsInAlliance()
  local isRegister = BattlefieldDsbDuelUtils.ActInfo:IsRegistered() and LuaEntry.Player:IsInAlliance()
  self.compInBattle:SetActive(isInBattle and isRegister)
  self.compOutBattle:SetActive(not isInBattle or not isRegister)
  self.compRedAward:SetActive(false)
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if LuaEntry.Player:IsInAlliance() and alData then
    self.imgIcon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, alData.icon))
    self.textName:SetText(string.format("[%s]", alData.abbr))
  else
    self.textName:SetText("")
  end
  local teamA = BattlefieldDsbDuelUtils.ActInfo:GetTeamInfo(BattlefieldDsbConst.TeamType.A)
  if teamA then
    self.imgUpIcon:SetActive(teamA.lastRank ~= 0 and teamA.lastRank ~= teamA.rank2)
    self.imgUpIcon:LoadSprite(teamA.lastRank > teamA.rank2 and string.format(LoadPath.LWBattleFieldDsbDuelPath, "FX_xiangqing_common_jiantou1_icon.png") or string.format(LoadPath.LWBattleFieldDsbDuelPath, "FX_xiangqing_common_jiantou2_icon.png"))
  end
  self:RefreshTitle()
  self.textDesc:SetActive(false)
  if not BattlefieldDsbDuelUtils.ActInfo:IsRegistered() or not LuaEntry.Player:IsInAlliance() then
    self.textDesc:SetLocalText("dsb_duel_interface_1059")
    self.textDesc:SetActive(not BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase() and not BattlefieldDsbDuelUtils.ActInfo:IsInResultShowPhase())
    self.compIconBg:SetActive(not BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase())
    self.imgIcon:SetActive(BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase())
    self.textName:SetActive(BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase())
    self.btnJump:SetActive(BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase() or BattlefieldDsbDuelUtils.ActInfo:IsInResultShowPhase())
    if BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase() then
      self.textBtn:SetLocalText("390924")
    elseif BattlefieldDsbDuelUtils.ActInfo:IsInResultShowPhase() then
      self.textBtn:SetLocalText("2000157")
      local hasReward = 0 < BattlefieldDsbDuelUtils.ActInfo:GetCanReceiveRewardNum()
      self.compRedAward:SetActive(hasReward)
    end
  else
    self.compIconBg:SetActive(false)
    self.imgIcon:SetActive(true)
    self.textName:SetActive(true)
    if BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase() then
      self.textBtn:SetLocalText("390924")
      self.btnJump:SetActive(true)
    elseif BattlefieldDsbDuelUtils.ActInfo:IsInGroupPhase() then
      self.textBtn:SetLocalText("dsb_duel_guide_tips_1018")
      self.btnJump:SetActive(true)
    elseif BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase() then
      self.btnJump:SetActive(false)
      if teamA then
        self.textText1:SetText(string.GetFormattedStr(teamA.score or 0))
        self.textText2:SetText(string.GetFormattedStr(teamA.smallScore or 0))
        self.textText3:SetText(string.GetFormattedStr(teamA.power or 0))
        self.textRankTxt:SetText(Localization:GetString("city_war_main_UI_09") .. (teamA.rank2 or ""))
      end
    elseif BattlefieldDsbDuelUtils.ActInfo:IsInResultShowPhase() then
      local hasReward = 0 < BattlefieldDsbDuelUtils.ActInfo:GetCanReceiveRewardNum()
      self.compRedAward:SetActive(hasReward)
      self.btnJump:SetActive(true)
      self.textBtn:SetLocalText("2000157")
    end
  end
  self:ClearTimer()
  self:CheckShowTeamSignUpTips()
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:CheckFingerGuide()
  end, 0.5)
end

function UIRaceEntranceDsbTopItemComponent:RefreshTitle()
  self.textTitle:SetActive(BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase() or BattlefieldDsbDuelUtils.ActInfo:IsInGroupPhase() or BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase())
  self.textTitle2:SetActive(BattlefieldDsbDuelUtils.ActInfo:IsInResultShowPhase())
  if BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase() then
    self.textTitle:SetLocalText("dsb_duel_interface_1057")
  elseif BattlefieldDsbDuelUtils.ActInfo:IsInGroupPhase() then
    self.textTitle:SetLocalText("dsb_duel_interface_1061")
  elseif BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase() then
    self.textTitle:SetLocalText("dsb_duel_interface_1058")
  elseif BattlefieldDsbDuelUtils.ActInfo:IsInResultShowPhase() then
    self.textTitle2:SetLocalText("dsb_duel_interface_1062")
  end
end

function UIRaceEntranceDsbTopItemComponent:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIRaceEntranceDsbTopItemComponent:OnBtnJumpClick()
  if BattlefieldDsbDuelUtils.ActInfo:IsInGroupPhase() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, BattlefieldDsbConst.BF_DSB_MAIN_VIEW_TOGGLE_INDEX.ScoreRank)
  else
    BattlefieldDsbDuelUtils.ActInfo:OpenActWindow()
  end
  self.bubbleJumped = true
  self:CheckShowTeamSignUpTips()
end

function UIRaceEntranceDsbTopItemComponent:OnDsbDuelActRankInfoUpdate()
  self:UpdateData()
end

function UIRaceEntranceDsbTopItemComponent:OnDsbDuelActRewardReceived()
  self:UpdateData()
end

function UIRaceEntranceDsbTopItemComponent:CheckFingerGuide()
  if not BattlefieldDsbDuelUtils.ActInfo:GetIsShownTopItemFinger() and BattlefieldDsbDuelUtils.ActInfo:GetIsShownPopUp() then
    local param = {}
    param.position = self.transform.position
    param.position.y = param.position.y - 80
    param.arrowType = ArrowType.Normal
    param.positionType = PositionType.Screen
    param.isAutoClose = 2
    DataCenter.ArrowManager:ShowArrow(param)
    BattlefieldDsbDuelUtils.ActInfo:SetIsShownTopItemFinger(true)
  end
end

function UIRaceEntranceDsbTopItemComponent:CheckShowTeamSignUpTips()
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  local isFirstShowInThisTeamSignUpPeriod = not actInfo:GetIsOpenEntranceInThisTeamSignUpPhase() and not self.bubbleJumped and actInfo:IsInTeamSignUpPhase() and actInfo:IsRegistered()
  self.tipsState = BattlefieldDsbConst.ENTRANCE_TIPS.None
  if isFirstShowInThisTeamSignUpPeriod then
    if not actInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.A) then
      self.tipsState = BattlefieldDsbConst.ENTRANCE_TIPS.GoToTeamSignUp
      self.textTxtName:SetLocalText("dsb_duel_tips_1008")
      self.textGo:SetLocalText("110003")
    elseif actInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.A) or actInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.B) then
      if actInfo:GetSelfTeam() ~= BattlefieldDsbConst.TeamType.None then
        self.tipsState = BattlefieldDsbConst.ENTRANCE_TIPS.GoToSeeInTeam
        self.textTxtName:SetLocalText("dsb_duel_tips_1009", actInfo:GetSelfTeam() == BattlefieldDsbConst.TeamType.A and "A" or "B")
        self.textGo:SetLocalText("110036")
      else
        self.tipsState = BattlefieldDsbConst.ENTRANCE_TIPS.GoToSeeOutTeam
        local strParam = ""
        if actInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.A) and actInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.B) then
          strParam = "AB"
        elseif actInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.A) then
          strParam = "A"
        elseif actInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.B) then
          strParam = "B"
        end
        self.textTxtName:SetLocalText("dsb_duel_tips_1010", strParam)
        self.textGo:SetLocalText("110036")
      end
    end
  end
  local showFlag = self.tipsState ~= BattlefieldDsbConst.ENTRANCE_TIPS.None
  self.compNew:SetActive(showFlag)
  self.btnBubbleTip:SetActive(showFlag)
end

function UIRaceEntranceDsbTopItemComponent:OnBtnUIRaceEntranceDsbTopItemClick()
  self:OnBtnJumpClick()
end

function UIRaceEntranceDsbTopItemComponent:OnBtnBubbleJumpClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActMain, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, BattlefieldDsbConst.BF_DSB_MAIN_VIEW_TOGGLE_INDEX.EditBattle)
  self.bubbleJumped = true
  self:CheckShowTeamSignUpTips()
end

function UIRaceEntranceDsbTopItemComponent:OnBtnBubbleTipClick()
  self:OnBtnBubbleJumpClick()
end

return UIRaceEntranceDsbTopItemComponent
