local EpidemicZoneCommanderListMessage = BaseClass("EpidemicZoneCommanderListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneCommanderListMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneCommanderListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleCommanderList(t)
end

return EpidemicZoneCommanderListMessage
