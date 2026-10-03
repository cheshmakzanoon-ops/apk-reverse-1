local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentReadMessage = BaseClass("ChatDeleteMessage", base)

function MomentReadMessage:OnCreate(timelineId, type, msgId)
  self.tableData = {
    timelineId = timelineId,
    type = type,
    msgId = msgId
  }
end

function MomentReadMessage:HandleMessage(t)
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

return MomentReadMessage
