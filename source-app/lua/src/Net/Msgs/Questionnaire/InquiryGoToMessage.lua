local InquiryGoToMessage = BaseClass("InquiryGoToMessage", SFSBaseMessage)
local base = SFSBaseMessage

function InquiryGoToMessage:OnCreate(targetUuid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", targetUuid)
end

function InquiryGoToMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.uuid then
    local uuid = message.uuid
    DataCenter.LWQuestionnaireManager:RefreshQuestionnaireFirstEnterTime(uuid)
    DataCenter.LWQuestionnaireManager:RefreshQuestionnaireRewardStatus(uuid, QuestionnaireRewardStatus.CanReceive)
    EventManager:GetInstance():Broadcast(EventId.GoToQuestionnaireSuccess, uuid)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.QuestionnaireDataMainUIRefresh)
  end
end

return InquiryGoToMessage
