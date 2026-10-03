local AlJoinmsgMessage = BaseClass("AlJoinmsgMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AlJoinmsgMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("msg", param.msg)
  self.sfsObj:PutUtfString("allianceId", param.allianceId)
end

function AlJoinmsgMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return AlJoinmsgMessage
