local DsbBattleHospitalViewMessage = BaseClass("DsbBattleHospitalViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleHospitalViewMessage:OnCreate()
  base.OnCreate(self)
end

function DsbBattleHospitalViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local _ = BattlefieldDsbDuelUtils.BattleInfo
  if _ then
    _:OnBattleHospitalView(t)
  end
end

return DsbBattleHospitalViewMessage
