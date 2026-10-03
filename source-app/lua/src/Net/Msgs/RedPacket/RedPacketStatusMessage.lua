local RedPacketStatusMessage = BaseClass("RedPacketStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", tostring(param.redPacketId))
  self.sfsObj:PutLong("serverId", tonumber(param.serverId))
  self.sfsObj:PutSFSObject("extra", param.extra)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
  elseif message.status == RedPacketState.TIMEOUT then
    UIUtil.ShowTipsId(390901)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRedenvelopeReceive, {anim = true}, message)
  end
end

RedPacketStatusMessage.OnCreate = OnCreate
RedPacketStatusMessage.HandleMessage = HandleMessage
return RedPacketStatusMessage
