local EpidemicZoneCommanderOptMessage = BaseClass("EpidemicZoneCommanderOptMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneCommanderOptMessage:OnCreate(group, opt, uid)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("opt", opt)
  self.sfsObj:PutUtfString("uid", uid)
end

function EpidemicZoneCommanderOptMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.ActEpidemicZoneManager:RequestActivityPlayerList()
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleCommanderOpt(t)
end

return EpidemicZoneCommanderOptMessage
