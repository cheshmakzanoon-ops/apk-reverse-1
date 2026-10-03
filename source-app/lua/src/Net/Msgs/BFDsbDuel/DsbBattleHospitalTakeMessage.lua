local DsbBattleHospitalTakeMessage = BaseClass("DsbBattleHospitalTakeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleHospitalTakeMessage:OnCreate()
  base.OnCreate(self)
end

function DsbBattleHospitalTakeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local _ = BattlefieldDsbDuelUtils.BattleInfo
  if _ then
    _:OnBattleHospitalTake(t)
  end
end

return DsbBattleHospitalTakeMessage
