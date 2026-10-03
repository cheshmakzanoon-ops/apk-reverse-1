local DsbBattleHospitalUpdateMessage = BaseClass("DsbBattleHospitalUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleHospitalUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function DsbBattleHospitalUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local _ = BattlefieldDsbDuelUtils.BattleInfo
  if _ then
    _:OnBattleHospitalUpdate(t)
  end
end

return DsbBattleHospitalUpdateMessage
