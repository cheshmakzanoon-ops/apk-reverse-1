local ApplyAllianceAllyRequestMessage = BaseClass("ApplyAllianceAllyRequestMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ApplyAllianceAllyRequestMessage:OnCreate(applyId, action)
  base.OnCreate(self)
  self.sfsObj:PutInt("action", action)
  self.sfsObj:PutLong("applyId", applyId)
end

function ApplyAllianceAllyRequestMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.applyId and t.success then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyCombinedList)
  end
end

return ApplyAllianceAllyRequestMessage
