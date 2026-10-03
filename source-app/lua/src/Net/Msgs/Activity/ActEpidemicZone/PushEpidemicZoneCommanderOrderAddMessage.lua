local PushEpidemicZoneCommanderOrderAddMessage = BaseClass("PushEpidemicZoneCommanderOrderAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneCommanderOrderAddMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneCommanderOrderAddMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  BattleFieldUtil.BFPingUtil().HandlePingOptPush(BattleFieldType.EpidemicZone, t, true)
end

return PushEpidemicZoneCommanderOrderAddMessage
