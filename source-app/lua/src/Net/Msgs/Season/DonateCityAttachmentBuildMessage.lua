local DonateCityAttachmentBuildMessage = BaseClass("DonateCityAttachmentBuildMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DonateCityAttachmentBuildMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function DonateCityAttachmentBuildMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

return DonateCityAttachmentBuildMessage
