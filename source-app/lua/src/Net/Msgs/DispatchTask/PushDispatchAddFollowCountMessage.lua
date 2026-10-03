local PushDispatchAddFollowCountMessage = BaseClass("PushDispatchAddFollowCountMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDispatchAddFollowCountMessage:OnCreate()
  base.OnCreate(self)
end

function PushDispatchAddFollowCountMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDispatchTaskDataManager:UpdateFollowCount(message)
  end
end

return PushDispatchAddFollowCountMessage
