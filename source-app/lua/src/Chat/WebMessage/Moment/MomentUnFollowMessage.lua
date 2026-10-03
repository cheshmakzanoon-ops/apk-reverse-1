local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentUnFollowMessage = BaseClass("MomentUnFollowMessage", base)

function MomentUnFollowMessage:OnCreate(unFolloweeIds)
  self.tableData = {followeeIds = unFolloweeIds}
end

function MomentUnFollowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():RemoveFollowList(t.result.followeeIds)
      UIUtil.ShowTipsId("moment_unfollow_tips")
    end
  end
end

return MomentUnFollowMessage
