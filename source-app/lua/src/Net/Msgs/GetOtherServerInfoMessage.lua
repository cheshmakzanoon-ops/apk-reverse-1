local GetOtherServerInfoMessage = BaseClass("GetOtherServerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local __targetServerId

local function OnCreate(self, targetServerId)
  base.OnCreate(self)
  self.sfsObj:PutInt("server", targetServerId)
  __targetServerId = targetServerId
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      if t.openTime then
        local serverId = t.server or __targetServerId
        LuaEntry.Player:SetCheckServerOpenTime(t.openTime, serverId)
      end
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GetOtherServerInfoMessage.OnCreate = OnCreate
GetOtherServerInfoMessage.HandleMessage = HandleMessage
return GetOtherServerInfoMessage
