local GetRedPacketStatusCommand = BaseClass("GetRedPacketStatusCommand", SFSBaseMessage)

local function OnCreate(self, param)
  self.super.OnCreate(self)
  self.sfsObj:PutUtfString("uid", tostring(redPacketId))
  self.sfsObj:PutLong("serverId", tonumber(serverId))
end

local function HandleMessage(self, msg)
  self.super.HandleMessage(self)
  local params = msg.params
  if params and params.status then
    local status = params.status and params.status or ""
    local redPacketId = self.data.uid .. "_" .. self.data.serverId
    local redPacketAttachmentId = redPacketId .. "|" .. status
    local data = {status = status}
    ChatInterface.postNotification("kRefreshRedPackageStatus", data)
    EventManager:GetInstance():Broadcast(ChatEventEnum.REFRESH_RED_PACKAGE, status)
  end
end

GetRedPacketStatusCommand.OnCreate = OnCreate
GetRedPacketStatusCommand.HandleMessage = HandleMessage

local function OnSend(param)
  SFSNetwork.SendMessage(MsgDefines.GET_RED_PACKET_STATUS, param)
end

function GetRedPacketStatusCommand.create(redPacketId, serverId)
  if not redPacketId or not serverId then
    return nil
  end
  local ret = {}
  ret.send = OnSend
  ret.redPacketId = redPacketId
  ret.serverId = serverId
  return ret
end

return GetRedPacketStatusCommand
