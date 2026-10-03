local WinterStormOrderAddPushMessage = BaseClass("WinterStormOrderAddPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormOrderAddPushMessage:OnCreate()
  base.OnCreate(self)
end

function WinterStormOrderAddPushMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  BattleFieldUtil.BFPingUtil().HandlePingOptPush(BattleFieldType.WinterStorm, t, true)
end

return WinterStormOrderAddPushMessage
