local base = UIBaseContainer
local UIBFDsbDuelActBattleAllianceContentItem = BaseClass("UIBFDsbDuelActBattleAllianceContentItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelActBattleAllianceItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Battle.UIBFDsbDuelActBattleAllianceItem")

function UIBFDsbDuelActBattleAllianceContentItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActBattleAllianceContentItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattleAllianceContentItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textAlliancesTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compAllianceItem = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleAllianceItem, 2)
  self.compAllianceItem2 = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleAllianceItem, 3)
  self.compAllianceItem3 = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleAllianceItem, 4)
  self.compAllianceItem4 = self.viewSkin:AddComponent(self, UIBFDsbDuelActBattleAllianceItem, 5)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compEmptyContent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textEmptyTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compAlItems = {
    self.compAllianceItem,
    self.compAllianceItem2,
    self.compAllianceItem3,
    self.compAllianceItem4
  }
end

function UIBFDsbDuelActBattleAllianceContentItem:ComponentDestroy()
  self.compAlItems = nil
  self.viewSkin = nil
  self.textAlliancesTitle = nil
  self.compAllianceItem = nil
  self.compAllianceItem2 = nil
  self.compAllianceItem3 = nil
  self.compAllianceItem4 = nil
  self.compContent = nil
  self.compEmptyContent = nil
  self.textEmptyTitle = nil
end

function UIBFDsbDuelActBattleAllianceContentItem:DataDefine()
  self.isCanGetBattleData = false
end

function UIBFDsbDuelActBattleAllianceContentItem:DataDestroy()
  self:ClearTimer()
  self.isCanGetBattleData = nil
end

function UIBFDsbDuelActBattleAllianceContentItem:OnEnable()
  base.OnEnable(self)
  BattlefieldDsbDuelUtils.ActInfo:SendActInfoMsg()
end

function UIBFDsbDuelActBattleAllianceContentItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActBattleInfoUpdate, self.OnDsbDuelActBattleInfoUpdate)
  self:AddUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  self:AddUIListener(EventId.DsbDuelActInfoUpdate, self.OnDsbDuelActInfoUpdate)
end

function UIBFDsbDuelActBattleAllianceContentItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActBattleInfoUpdate, self.OnDsbDuelActBattleInfoUpdate)
  self:RemoveUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  self:RemoveUIListener(EventId.DsbDuelActInfoUpdate, self.OnDsbDuelActInfoUpdate)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActBattleAllianceContentItem:RefreshActive()
  local isRegisteredAct = BattlefieldDsbDuelUtils.ActInfo:IsRegistered()
  local isInTeamMatchPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamMatchPhase()
  local IsInTeamWaitBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamWaitBattlePhase()
  local isInTeamBattleReadyPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattleReadyPhase()
  local isInTeamBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattlePhase()
  local isInTeamResultShowPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamResultShowPhase()
  self:SetActive(isRegisteredAct and (isInTeamMatchPhase or IsInTeamWaitBattlePhase or isInTeamBattleReadyPhase or isInTeamBattlePhase or isInTeamResultShowPhase))
end

function UIBFDsbDuelActBattleAllianceContentItem:OnDsbDuelActTimePhaseChange(phaseIndex)
  if phaseIndex == BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamWaitBattle then
    TimerManager:GetInstance():DelayInvoke(function()
      BattlefieldDsbDuelUtils.ActInfo:SendActInfoMsg()
    end, 3)
  end
end

function UIBFDsbDuelActBattleAllianceContentItem:OnDsbDuelActBattleInfoUpdate()
  if not self.data then
    return
  end
  if self.data.isInBattle then
    self:RefreshBattleView()
  end
end

function UIBFDsbDuelActBattleAllianceContentItem:OnDsbDuelActInfoUpdate()
  self:RefreshView()
end

local UPDATE_TIME = 10

function UIBFDsbDuelActBattleAllianceContentItem:UpdateTimer()
  if not self.data then
    return
  end
  if self.data.isInBattle and BattlefieldDsbDuelUtils.ActInfo:IsTeamMatched(self.data.isTeamA and BattlefieldDsbConst.TeamType.A or BattlefieldDsbConst.TeamType.B) then
    BattlefieldDsbDuelUtils.ActInfo:SendBattleInfoMsg(self.data.isTeamA and BattlefieldDsbConst.TeamType.A or BattlefieldDsbConst.TeamType.B)
    if BattlefieldDsbDuelUtils.ActInfo:IsInTeamResultShowPhase() and self.isCanGetBattleData then
      self:ClearTimer()
    end
  end
end

function UIBFDsbDuelActBattleAllianceContentItem:ClearTimer()
  if self.updateBattleTimer then
    self.updateBattleTimer:Stop()
    self.updateBattleTimer = nil
  end
end

function UIBFDsbDuelActBattleAllianceContentItem:SetData(data)
  self:RefreshActive()
  self.data = data
  self:RefreshView()
end

function UIBFDsbDuelActBattleAllianceContentItem:RefreshView()
  if not self.data then
    return
  end
  if not self.data.isTeamSignUpOrMatched then
    self.compContent:SetActive(false)
    self.compEmptyContent:SetActive(true)
    if self.data.isTeamBye then
      self.textEmptyTitle:SetLocalText("dsb_duel_interface_1041")
    else
      self.textEmptyTitle:SetLocalText("dsb_duel_interface_1040")
    end
  elseif self.data.isBattleReady then
    self.compContent:SetActive(true)
    self.compEmptyContent:SetActive(false)
    self.textAlliancesTitle:SetLocalText("dsb_duel_interface_1038")
    local teamId = self.data.isTeamA and BattlefieldDsbConst.TeamType.A or BattlefieldDsbConst.TeamType.B
    local emptyData = {isEmpty = true}
    local emptyCount = 0
    local nonEmptyInfos = {}
    for i, _ in ipairs(self.compAlItems) do
      local info = BattlefieldDsbDuelUtils.ActInfo:GetTeamMatchAllianceInfoByRole(teamId, i)
      if info == BattlefieldDsbConst.EmptyRole then
        emptyCount = emptyCount + 1
      else
        table.insert(nonEmptyInfos, info)
      end
    end
    local roleCount = BattlefieldDsbConst.RoleType.MAX - emptyCount
    for i, v in ipairs(self.compAlItems) do
      if i > roleCount then
        v:SetData(emptyData)
      else
        v:SetData(nonEmptyInfos[i] or emptyData)
      end
    end
  elseif self.data.isInBattle then
    self:RefreshBattleView()
    self:ClearTimer()
    self.updateBattleTimer = TimerManager:GetInstance():GetTimer(UPDATE_TIME, self.UpdateTimer, self, false, false, false)
    self.updateBattleTimer:Start()
    self:UpdateTimer()
  elseif self.data.isMatching then
    self.compContent:SetActive(true)
    self.compEmptyContent:SetActive(false)
    self.textAlliancesTitle:SetLocalText("dsb_duel_interface_1031")
    local selfData = DeepCopy(DataCenter.AllianceBaseDataManager:GetAllianceBaseData())
    selfData.group = BattlefieldDsbDuelUtils.ActInfo:GetTeamGroup(self.data.isTeamA and BattlefieldDsbConst.TeamType.A or BattlefieldDsbConst.TeamType.B)
    selfData.serverId = selfData.ownerServerId
    selfData.rank = BattlefieldDsbDuelUtils.ActInfo:GetTeamGroupRank(self.data.isTeamA and BattlefieldDsbConst.TeamType.A or BattlefieldDsbConst.TeamType.B)
    selfData.state = BattlefieldDsbDuelUtils.ActInfo:GetTeamState(self.data.isTeamA and BattlefieldDsbConst.TeamType.A or BattlefieldDsbConst.TeamType.B)
    
    function selfData.GetRole()
      return selfData.group
    end
    
    selfData.isMatching = true
    local matchingData = {isMatching = true, isEmpty = true}
    for i, v in ipairs(self.compAlItems) do
      v:SetData(i == 1 and selfData or matchingData)
    end
  end
end

function UIBFDsbDuelActBattleAllianceContentItem:RefreshBattleView()
  self.compContent:SetActive(true)
  self.compEmptyContent:SetActive(false)
  local count = 0
  local teamId = self.data.isTeamA and BattlefieldDsbConst.TeamType.A or BattlefieldDsbConst.TeamType.B
  local alList = BattlefieldDsbDuelUtils.ActInfo:GetTeamBattleAllianceInfo(teamId)
  local emptyData = {isEmpty = true}
  for i, v in ipairs(self.compAlItems) do
    local info = alList[i]
    if info == nil or info == BattlefieldDsbConst.EmptyRole then
      v:SetData(emptyData, i, true)
    else
      v:SetData(info, i, true)
      count = count + 1
    end
  end
  self.isCanGetBattleData = 0 < count
  self.textAlliancesTitle:SetLocalText(self.isCanGetBattleData and "dsb_duel_interface_1038" or "dsb_duel_interface_1039")
end

return UIBFDsbDuelActBattleAllianceContentItem
