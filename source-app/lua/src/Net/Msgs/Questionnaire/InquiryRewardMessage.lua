local InquiryRewardMessage = BaseClass("InquiryRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function InquiryRewardMessage:OnCreate(targetUuid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", targetUuid)
end

function InquiryRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.uuid then
    local uuid = message.uuid
    local questionnaireInfo = DataCenter.LWQuestionnaireManager:GetQuestionnaireInfoByUuid(uuid)
    if questionnaireInfo ~= nil then
      local param = {}
      param.reward = questionnaireInfo.reward
      DataCenter.RewardManager:ShowCommonReward(param)
      DataCenter.RewardManager:AddRewardsAndRes(param)
    else
      Logger.LogInfo(tostring(uuid) .. "InquiryRewardMessage:HandleMessage, questionnaireInfo is nil")
    end
    DataCenter.LWQuestionnaireManager:RefreshQuestionnaireRewardStatus(uuid, QuestionnaireRewardStatus.AlreadyReceive)
    EventManager:GetInstance():Broadcast(EventId.ReceiveQuestionnaireRewardSuccess, uuid)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return InquiryRewardMessage
