local DsbBattlePushBattleResultMessage = BaseClass("DsbBattlePushBattleResultMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattlePushBattleResultMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbBattlePushBattleResultMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if battleInfo then
    battleInfo:UpdateFromBattleResult(t)
  end
end

return DsbBattlePushBattleResultMessage
