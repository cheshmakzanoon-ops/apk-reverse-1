local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentFollowListMessage = BaseClass("MomentFollowListMessage", base)

function MomentFollowListMessage:OnCreate(queryId)
  self.tableData = {queryId = queryId}
end

function MomentFollowListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():AddMomentFollowList(t.result.followingList)
    end
  end
end

return MomentFollowListMessage
