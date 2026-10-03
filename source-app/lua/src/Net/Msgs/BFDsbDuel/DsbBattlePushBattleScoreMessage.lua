local DsbBattlePushBattleScoreMessage = BaseClass("DsbBattlePushBattleScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattlePushBattleScoreMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbBattlePushBattleScoreMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.BattlefieldDsbDuelManager:OnPushBattleScore(t)
end

return DsbBattlePushBattleScoreMessage
