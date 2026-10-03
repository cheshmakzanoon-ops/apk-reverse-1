local CancelAllianceAllyApplyMessage = BaseClass("CancelAllianceAllyApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CancelAllianceAllyApplyMessage:OnCreate(applyId)
  base.OnCreate(self)
  self.sfsObj:PutLong("applyId", applyId)
end

function CancelAllianceAllyApplyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.applyId then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyCombinedList)
  end
end

return CancelAllianceAllyApplyMessage
