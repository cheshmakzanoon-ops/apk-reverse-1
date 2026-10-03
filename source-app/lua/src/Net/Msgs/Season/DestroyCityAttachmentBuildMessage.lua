local DestroyCityAttachmentBuildMessage = BaseClass("DestroyCityAttachmentBuildMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DestroyCityAttachmentBuildMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function DestroyCityAttachmentBuildMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

return DestroyCityAttachmentBuildMessage
