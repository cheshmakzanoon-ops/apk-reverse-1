local AssistanceOwnerReceivinghistoryMessage = BaseClass("AssistanceOwnerReceivinghistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AssistanceOwnerReceivinghistoryMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("start", param.startIndex or 1)
  self.sfsObj:PutInt("end", param.endIndex or 50)
end

function AssistanceOwnerReceivinghistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.AssistanceOwnerReceivinghistory, t.historyArr)
  end
end

return AssistanceOwnerReceivinghistoryMessage
