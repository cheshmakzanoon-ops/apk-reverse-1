local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentFollowMessage = BaseClass("MomentFollowMessage", base)

function MomentFollowMessage:OnCreate(followeeId)
  self.tableData = {followeeId = followeeId}
end

function MomentFollowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():AddFollow({
        followeeId = t.result.followeeId,
        isFollow = true
      })
      UIUtil.ShowTipsId("moment_follow_tips")
    end
  end
end

return MomentFollowMessage
