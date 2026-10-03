local PushEpidemicZoneCommanderOrderRemMessage = BaseClass("PushEpidemicZoneCommanderOrderRemMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneCommanderOrderRemMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneCommanderOrderRemMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  BattleFieldUtil.BFPingUtil().HandlePingOptPush(BattleFieldType.EpidemicZone, t, false)
end

return PushEpidemicZoneCommanderOrderRemMessage
