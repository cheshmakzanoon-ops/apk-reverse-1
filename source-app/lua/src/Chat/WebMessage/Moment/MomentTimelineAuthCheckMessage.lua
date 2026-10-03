local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentTimelineAuthCheckMessage = BaseClass("MomentTimelineAuthCheckMessage", base)

function MomentTimelineAuthCheckMessage:OnCreate(msgId, msgBody)
  self.tableData = {msgId = msgId, msgBody = msgBody}
end

function MomentTimelineAuthCheckMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errorCode = t.result.errorCode
    if errorCode and errorCode ~= 1 then
      UIUtil.ShowErrorCodeTips(t.result)
      return
    else
      ChatInterface.getMoment():MomentAuthCheck(t.result)
    end
  end
end

return MomentTimelineAuthCheckMessage
