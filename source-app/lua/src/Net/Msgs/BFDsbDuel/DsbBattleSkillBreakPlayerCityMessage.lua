local DsbBattleSkillBreakPlayerCityMessage = BaseClass("DsbBattleSkillBreakPlayerCityMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleSkillBreakPlayerCityMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbBattleSkillBreakPlayerCityMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if battleInfo then
    battleInfo:OnSkillBreakPlayerCity(t)
  end
end

return DsbBattleSkillBreakPlayerCityMessage
