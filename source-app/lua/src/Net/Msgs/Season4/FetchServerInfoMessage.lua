local FetchServerInfoMessage = BaseClass("FetchServerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchServerInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("server", serverId)
end

function FetchServerInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager:UpdateServerDetail(t.server, t)
end

return FetchServerInfoMessage
