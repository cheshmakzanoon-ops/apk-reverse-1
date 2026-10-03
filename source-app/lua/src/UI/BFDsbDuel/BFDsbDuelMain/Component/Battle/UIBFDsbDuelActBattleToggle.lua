local base = UIBaseContainer
local UIBFDsbDuelActBattleToggle = BaseClass("UIBFDsbDuelActBattleToggle", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActBattleToggle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActBattleToggle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattleToggle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggleType1 = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.toggleType2 = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.textTabTypeText12 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTabTypeText22 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTabTypeText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTabTypeText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgFlag1 = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgFlag2 = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgAbandon = self.viewSkin:AddComponent(self, UIImage, 9)
  self.textAbandon = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.toggleType1:SetIsOn(true)
  self.toggleType1:SetOnValueChanged(function(isOn)
    if isOn and self.data and self.data.clickCallback then
      self.data.clickCallback(1)
    end
  end)
  self.toggleType2:SetOnValueChanged(function(isOn)
    if isOn and self.data and self.data.clickCallback then
      self.data.clickCallback(2)
    end
  end)
end

function UIBFDsbDuelActBattleToggle:ComponentDestroy()
  self.viewSkin = nil
  self.toggleType1 = nil
  self.toggleType2 = nil
  self.textTabTypeText12 = nil
  self.textTabTypeText22 = nil
  self.textTabTypeText1 = nil
  self.textTabTypeText2 = nil
  self.imgFlag1 = nil
  self.imgFlag2 = nil
  self.imgAbandon = nil
  self.textAbandon = nil
end

function UIBFDsbDuelActBattleToggle:DataDefine()
end

function UIBFDsbDuelActBattleToggle:DataDestroy()
end

function UIBFDsbDuelActBattleToggle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActTeamAssignSuccess, self.OnDsbDuelActTeamAssignSuccess)
  self:AddUIListener(EventId.DsbDuelActPlayerListUpdate, self.OnDsbDuelActTeamAssignSuccess)
  self:AddUIListener(EventId.DsbDuelActTeamModifySuccess, self.OnDsbDuelActTeamModifySuccess)
  self:AddUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
end

function UIBFDsbDuelActBattleToggle:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActPlayerListUpdate, self.OnDsbDuelActTeamAssignSuccess)
  self:RemoveUIListener(EventId.DsbDuelActTeamAssignSuccess, self.OnDsbDuelActTeamAssignSuccess)
  self:RemoveUIListener(EventId.DsbDuelActTeamModifySuccess, self.OnDsbDuelActTeamModifySuccess)
  self:RemoveUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  base.OnRemoveListener(self)
end

local function RefreshImgFlag(self)
  self.imgFlag1:SetActive(not BattlefieldDsbDuelUtils.ActInfo:IsSelfInTeam(BattlefieldDsbConst.TeamType.A) or BattlefieldDsbDuelUtils.ActInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.A) or BattlefieldDsbDuelUtils.ActInfo:IsTeamMatched(BattlefieldDsbConst.TeamType.A))
  self.imgFlag2:SetActive(not BattlefieldDsbDuelUtils.ActInfo:IsSelfInTeam(BattlefieldDsbConst.TeamType.B) or BattlefieldDsbDuelUtils.ActInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.B) or BattlefieldDsbDuelUtils.ActInfo:IsTeamMatched(BattlefieldDsbConst.TeamType.B))
end

local function RefreshAbandonActive(self)
  self.textTabTypeText2:SetActive(BattlefieldDsbDuelUtils.ActInfo:GetTeamState(BattlefieldDsbConst.TeamType.B) ~= BattlefieldDsbConst.BF_DSB_TEAM_STATE.GiveUp)
  self.textTabTypeText22:SetActive(BattlefieldDsbDuelUtils.ActInfo:GetTeamState(BattlefieldDsbConst.TeamType.B) ~= BattlefieldDsbConst.BF_DSB_TEAM_STATE.GiveUp)
  self.imgAbandon:SetActive(BattlefieldDsbDuelUtils.ActInfo:GetTeamState(BattlefieldDsbConst.TeamType.B) == BattlefieldDsbConst.BF_DSB_TEAM_STATE.GiveUp)
end

function UIBFDsbDuelActBattleToggle:RefreshActive()
  local isRegisteredAct = BattlefieldDsbDuelUtils.ActInfo:IsRegistered()
  local isInTeamWaitSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamWaitSignUpPhase()
  local isInTeamSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamSignUpPhase()
  local isInTeamMatchPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamMatchPhase()
  local isInTeamWaitBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamWaitBattlePhase()
  local isInTeamBattleReadyPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattleReadyPhase()
  local isInTeamBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattlePhase()
  local isInTeamResultShowPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamResultShowPhase()
  self:SetActive(isRegisteredAct and (isInTeamWaitSignUpPhase or isInTeamSignUpPhase or isInTeamMatchPhase or isInTeamWaitBattlePhase or isInTeamBattleReadyPhase or isInTeamBattlePhase or isInTeamResultShowPhase))
end

function UIBFDsbDuelActBattleToggle:OnEnable()
  base.OnEnable(self)
  self:RefreshActive()
end

function UIBFDsbDuelActBattleToggle:OnDsbDuelActTimePhaseChange()
end

function UIBFDsbDuelActBattleToggle:OnDsbDuelActTeamAssignSuccess()
  RefreshImgFlag(self)
end

function UIBFDsbDuelActBattleToggle:OnDsbDuelActTeamModifySuccess()
  RefreshAbandonActive(self)
  RefreshImgFlag(self)
end

function UIBFDsbDuelActBattleToggle:SetData(data)
  self.data = data
  RefreshImgFlag(self)
  RefreshAbandonActive(self)
  self:RefreshActive()
end

return UIBFDsbDuelActBattleToggle
