local EpidemicZoneCommanderOrderListMessage = BaseClass("EpidemicZoneCommanderOrderListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneCommanderOrderListMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneCommanderOrderListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  BattleFieldUtil.BFPingUtil().HandlePingList(BattleFieldType.EpidemicZone, t)
end

return EpidemicZoneCommanderOrderListMessage
