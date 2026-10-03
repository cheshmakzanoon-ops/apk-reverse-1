local SendRedPackMessage = BaseClass("SendRedPackMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param.type == 1 then
    self.sfsObj:PutInt("type", param.type)
    self.sfsObj:PutUtfString("uuid", param.uuid)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
  elseif message.redPacket then
    DataCenter.AllianceRedPacketManager:UpdateRedPacketByUUid(message.redPacket)
  end
end

SendRedPackMessage.OnCreate = OnCreate
SendRedPackMessage.HandleMessage = HandleMessage
return SendRedPackMessage
