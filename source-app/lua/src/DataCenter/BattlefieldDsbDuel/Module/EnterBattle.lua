local _CLASS = {}

function _CLASS:CanShowEnter()
  if not self.actInfo then
    return
  end
  if not self.actInfo:IsInTeamBattlePhase() and not self.actInfo:IsInTeamBattleReadyPhase() then
    return
  end
  local lastTime = self.actInfo.lastEnterBattleTime or 0
  return 0 < lastTime
end

function _CLASS:CanGotoMap(group)
  local ec = self:BaseCheckActivityOpen(EnumActivity.ActDsbDuel.Type)
  if ec then
    return ec
  end
  if self.actInfo then
    return self.actInfo:CanEnterBattlefield(group)
  end
end

function _CLASS:LocalCheckCanEnterBattlefield(group)
  if not self.actInfo then
    return false, nil
  end
  local ok = self:BaseLocalCheckCanEnterBattlefield(group)
  if not ok then
    return false, nil
  end
  return true, nil
end

function _CLASS:SendEnterBattleMessage(group, pointId)
  local teamIdx = self:BaseBeforeSendEnter(group, pointId)
  if teamIdx == 0 then
    local actInfo = BattlefieldDsbDuelUtils.ActInfo
    if not actInfo then
      return
    end
    teamIdx = actInfo:GetSelfTeam()
    if teamIdx ~= 0 then
      SFSNetwork.SendMessage(MsgDefines.DsbBattleEnter, teamIdx)
    end
  else
    SFSNetwork.SendMessage(MsgDefines.DsbBattleWatch, teamIdx)
  end
end

function _CLASS:BeforeEnterBattlefield(msg, bWatch)
  self:GetBattleInfo(true)
  self.battleInfo:UpdateFromEnterMsg(msg, bWatch)
  self.myInfo:UpdateFromEnterMsg(self.battleInfo)
  self.battleInfo:Enter()
end

function _CLASS:AfterEnterBattlefield(bWatch)
  if self.actInfo then
    self.actInfo:OnEnterBattlefield(bWatch)
  end
end

return _CLASS
