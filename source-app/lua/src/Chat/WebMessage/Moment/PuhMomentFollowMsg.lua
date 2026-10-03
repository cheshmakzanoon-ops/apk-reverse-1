local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PuhMomentFollowMsg = BaseClass("PuhMomentFollowMsg", base)

function PuhMomentFollowMsg:OnCreate(queryId)
  self.tableData = {queryId = queryId}
end

function PuhMomentFollowMsg:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():OnPushMsg(t.result.notifyType, t.result.senderUid)
    end
  end
end

return PuhMomentFollowMsg
