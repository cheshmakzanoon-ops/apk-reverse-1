local base = UIBaseContainer
local UIBFDsbDuelActBattleScoreRuleContentItem = BaseClass("UIBFDsbDuelActBattleScoreRuleContentItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActBattleScoreRuleContentItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActBattleScoreRuleContentItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattleScoreRuleContentItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textScoreRuleTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textNumTxt1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textNumTxt2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textNumTxt3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textNumTxt4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textScoreTxt1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textScoreTxt2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textScoreTxt3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textScoreTxt4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compScoreRuleContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.textScoreRuleTips2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compEmpty1 = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.compEmpty2 = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.compEmpty3 = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.compEmpty4 = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compEmptys = {
    self.compEmpty1,
    self.compEmpty2,
    self.compEmpty3,
    self.compEmpty4
  }
  self.textNumTxt1:SetLocalText("dsb_duel_interface_1019")
  self.textNumTxt2:SetLocalText("dsb_duel_interface_1020")
  self.textNumTxt3:SetLocalText("dsb_duel_interface_1021")
  self.textNumTxt4:SetLocalText("dsb_duel_interface_1022")
  self.textScoreRuleTips:SetLocalText("dsb_duel_interface_1018")
  self.textScoreRuleTips2:SetLocalText("dsb_duel_interface_1045")
end

function UIBFDsbDuelActBattleScoreRuleContentItem:ComponentDestroy()
  self.compEmptys = nil
  self.viewSkin = nil
  self.textScoreRuleTips = nil
  self.textNumTxt1 = nil
  self.textNumTxt2 = nil
  self.textNumTxt3 = nil
  self.textNumTxt4 = nil
  self.textScoreTxt1 = nil
  self.textScoreTxt2 = nil
  self.textScoreTxt3 = nil
  self.textScoreTxt4 = nil
  self.compScoreRuleContent = nil
  self.textScoreRuleTips2 = nil
  self.compEmpty1 = nil
  self.compEmpty2 = nil
  self.compEmpty3 = nil
  self.compEmpty4 = nil
  self.btnInfo = nil
end

function UIBFDsbDuelActBattleScoreRuleContentItem:DataDefine()
end

function UIBFDsbDuelActBattleScoreRuleContentItem:DataDestroy()
end

function UIBFDsbDuelActBattleScoreRuleContentItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  self:AddUIListener(EventId.DsbDuelActBattleInfoUpdate, self.OnDsbDuelActBattleInfoUpdate)
end

function UIBFDsbDuelActBattleScoreRuleContentItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  self:RemoveUIListener(EventId.DsbDuelActBattleInfoUpdate, self.OnDsbDuelActBattleInfoUpdate)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActBattleScoreRuleContentItem:OnBtnInfoClick()
  local strTip = Localization:GetString("dsb_duel_tips_1022")
  UIUtil.ShowBubbleTips(strTip, self.btnInfo.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

function UIBFDsbDuelActBattleScoreRuleContentItem:RefreshActive()
  local isRegisteredAct = BattlefieldDsbDuelUtils.ActInfo:IsRegistered()
  local isInTeamSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamSignUpPhase()
  local isInTeamMatchPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamMatchPhase()
  local isInTeamWaitBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamWaitBattlePhase()
  local isInTeamBattleReadyPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattleReadyPhase()
  local isInTeamBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattlePhase()
  local isInTeamResultShowPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamResultShowPhase()
  self:SetActive(isRegisteredAct and (isInTeamSignUpPhase or isInTeamMatchPhase or isInTeamWaitBattlePhase or isInTeamBattleReadyPhase or isInTeamBattlePhase or isInTeamResultShowPhase))
  local emptyCont = 0
  if isInTeamWaitBattlePhase or isInTeamBattleReadyPhase then
    for i, v in ipairs(self.compEmptys) do
      local info = BattlefieldDsbDuelUtils.ActInfo:GetTeamMatchAllianceInfoByRole(self.teamId, i)
      if info == BattlefieldDsbConst.EmptyRole then
        emptyCont = emptyCont + 1
      end
    end
  elseif isInTeamBattlePhase or isInTeamResultShowPhase then
    emptyCont = BattlefieldDsbDuelUtils.GetEmptyRoles(self.teamId)
  end
  local roleCount = BattlefieldDsbConst.RoleType.MAX - emptyCont
  for i, v in ipairs(self.compEmptys) do
    v:SetActive(i > roleCount)
  end
  return emptyCont
end

function UIBFDsbDuelActBattleScoreRuleContentItem:OnEnable()
  base.OnEnable(self)
  self:RefreshActive()
end

function UIBFDsbDuelActBattleScoreRuleContentItem:OnDsbDuelActTimePhaseChange()
end

function UIBFDsbDuelActBattleScoreRuleContentItem:OnDsbDuelActBattleInfoUpdate()
  self:RefreshActive()
end

function UIBFDsbDuelActBattleScoreRuleContentItem:SetData(teamId)
  self.teamId = teamId
  self.compScoreRuleContent:SetActive(teamId == BattlefieldDsbConst.TeamType.A)
  self.textScoreRuleTips:SetActive(teamId == BattlefieldDsbConst.TeamType.A)
  self.textScoreRuleTips2:SetActive(teamId == BattlefieldDsbConst.TeamType.B)
  local scoreStr = LuaEntry.DataConfig:TryGetStr("dsb_duel_league", "k5")
  local numList = string.string2array_num_oneSep(scoreStr, ",")
  local emptyCount = self:RefreshActive()
  if 0 < emptyCount and emptyCount < BattlefieldDsbConst.RoleType.MAX then
    local newList = {}
    for i = emptyCount + 1, BattlefieldDsbConst.RoleType.MAX do
      table.insert(newList, numList[i] or "-")
    end
    numList = newList
    newList = nil
  end
  self.textScoreTxt1:SetText(numList[1] or "-")
  self.textScoreTxt2:SetText(numList[2] or "-")
  self.textScoreTxt3:SetText(numList[3] or "-")
  self.textScoreTxt4:SetText(numList[4] or "-")
end

return UIBFDsbDuelActBattleScoreRuleContentItem
