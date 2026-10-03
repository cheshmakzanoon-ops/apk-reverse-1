local WinterStormOrderListMessage = BaseClass("WinterStormOrderListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormOrderListMessage:OnCreate()
  base.OnCreate(self)
end

function WinterStormOrderListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  BattleFieldUtil.BFPingUtil().HandlePingList(BattleFieldType.WinterStorm, t)
end

return WinterStormOrderListMessage
