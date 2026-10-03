local GetOneServerInfoMessage = BaseClass("GetOneServerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local __targetServerId

local function OnCreate(self, targetServerId)
  base.OnCreate(self)
  self.sfsObj:PutInt("server", targetServerId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ServerStatusManager:OnHandleOneServerInfo(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GetOneServerInfoMessage.OnCreate = OnCreate
GetOneServerInfoMessage.HandleMessage = HandleMessage
return GetOneServerInfoMessage
