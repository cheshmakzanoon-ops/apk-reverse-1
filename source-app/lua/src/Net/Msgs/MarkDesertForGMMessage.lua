local MarkDesertForGMMessage = BaseClass("MarkDesertForGMMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MarkDesertForGMMessage:OnCreate(pointId)
  base.OnCreate(self)
  self.sfsObj:PutInt("pointId", pointId)
end

function MarkDesertForGMMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

return MarkDesertForGMMessage
