local UserQueryFollowMessage = BaseClass("UerAddFollowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserQueryFollowMessage:OnCreate(follwId)
  base.OnCreate(self)
  if follwId then
    self.sfsObj:PutUtfString("queryId", follwId)
  end
end

function UserQueryFollowMessage:HandleMessage(t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    ChatInterface.getMoment():SetFirstFollow(t.queryId, t.result)
  end
end

return UserQueryFollowMessage
