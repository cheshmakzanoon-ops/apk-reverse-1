local BattleFieldEntranceInfoMessage = BaseClass("BattleFieldEntranceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleFieldEntranceInfoMessage:OnCreate()
  base.OnCreate(self)
end

function BattleFieldEntranceInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  RaceEntranceUtil.HandleTimeInfo(t)
end

return BattleFieldEntranceInfoMessage
