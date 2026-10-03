local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentUnreadMsgMessage = BaseClass("MomentUnreadMsgMessage", base)

function MomentUnreadMsgMessage:OnCreate(fristId)
  self.tableData = {lastMsgId = fristId, desc = true}
end

function MomentUnreadMsgMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
    end
  end
end

return MomentUnreadMsgMessage
