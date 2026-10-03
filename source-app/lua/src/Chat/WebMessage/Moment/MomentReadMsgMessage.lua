local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentReadMsgMessage = BaseClass("MomentReadMsgMessage", base)

function MomentReadMsgMessage:OnCreate(unFolloweeIds)
  self.tableData = {followeeIds = unFolloweeIds}
end

function MomentReadMsgMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      Logger.LogError("MomentReadMsgMessage")
    end
  end
end

return MomentReadMsgMessage
