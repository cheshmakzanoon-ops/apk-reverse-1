local FetchAllianceAllyApplyDetailMessage = BaseClass("FetchAllianceAllyApplyDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceAllyApplyDetailMessage:OnCreate(applyId)
  base.OnCreate(self)
  self.sfsObj:PutLong("applyId", applyId)
end

function FetchAllianceAllyApplyDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonAllyFriendManager:UpdateRequestDetail(t)
  EventManager:GetInstance():Broadcast(EventId.MFAllyRequestDetailUpdate, t.applyId)
end

return FetchAllianceAllyApplyDetailMessage
