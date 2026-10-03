local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentTipsHistoryMessage = BaseClass("MomentTipsHistoryMessage", base)

function MomentTipsHistoryMessage:OnCreate(timestamp, type)
  self.tableData = {timestamp = timestamp, type = type}
end

function MomentTipsHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_TIPS_HISTORY, t)
    end
  end
end

return MomentTipsHistoryMessage
