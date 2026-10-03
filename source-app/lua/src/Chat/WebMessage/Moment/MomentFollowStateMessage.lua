local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentFollowStateMessage = BaseClass("MomentFollowStateMessage", base)

function MomentFollowStateMessage:OnCreate(followeeId)
  self.tableData = {followeeId = followeeId}
end

function MomentFollowStateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():AddFollow(t.result)
    end
  end
end

return MomentFollowStateMessage
