local DsbBattleTeamEffectMessage = BaseClass("DsbBattleTeamEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleTeamEffectMessage:OnCreate()
  base.OnCreate(self)
end

function DsbBattleTeamEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  BattleFieldUtil.HandleEffects(t, BattleFieldType.DsbDuel)
end

return DsbBattleTeamEffectMessage
