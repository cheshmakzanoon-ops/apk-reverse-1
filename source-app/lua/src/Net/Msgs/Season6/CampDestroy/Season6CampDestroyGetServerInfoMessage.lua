local Season6CampDestroyGetServerInfoMessage = BaseClass("Season6CampDestroyGetServerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Season6CampDestroyGetServerInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetServerId", serverId)
end

function Season6CampDestroyGetServerInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  DataCenter.SeasonCampDestroyManager:OnGetServerInfoCallback(t)
end

return Season6CampDestroyGetServerInfoMessage
