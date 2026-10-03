local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentTimeLineClickMessage = BaseClass("MomentTimeLineClickMessage", base)

function MomentTimeLineClickMessage:OnCreate(msgId)
  self.tableData = {msgId = msgId}
end

function MomentTimeLineClickMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    end
  end
end

return MomentTimeLineClickMessage
