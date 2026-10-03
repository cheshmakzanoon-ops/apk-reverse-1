local PushMailRewardBatchMessage = BaseClass("PushMailRewardBatchMessage", SFSBaseMessage)

function PushMailRewardBatchMessage:HandleMessage(message)
  DataCenter.MailDataManager:HandleMailRewardBatchMessage(message)
end

return PushMailRewardBatchMessage
