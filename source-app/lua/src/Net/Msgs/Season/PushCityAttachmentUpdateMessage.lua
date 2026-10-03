local PushCityAttachmentUpdateMessage = BaseClass("PushCityAttachmentUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCityAttachmentUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushCityAttachmentUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentEffectInfo)
  SFSNetwork.SendMessage(MsgDefines.FetchCityAttachmentList)
end

return PushCityAttachmentUpdateMessage
