local DsbBattleLeaveMessage = BaseClass("DsbBattleLeaveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleLeaveMessage:OnCreate(team)
  base.OnCreate(self)
  self.sfsObj:PutInt("team", team)
end

function DsbBattleLeaveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.BattlefieldDsbDuelManager:OnLeaveBattle(t)
end

return DsbBattleLeaveMessage
