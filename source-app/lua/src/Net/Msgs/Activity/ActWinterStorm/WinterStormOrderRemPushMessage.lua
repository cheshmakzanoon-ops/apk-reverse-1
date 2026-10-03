local WinterStormOrderRemPushMessage = BaseClass("WinterStormOrderRemPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormOrderRemPushMessage:OnCreate()
  base.OnCreate(self)
end

function WinterStormOrderRemPushMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  BattleFieldUtil.BFPingUtil().HandlePingOptPush(BattleFieldType.WinterStorm, t, false)
end

return WinterStormOrderRemPushMessage
