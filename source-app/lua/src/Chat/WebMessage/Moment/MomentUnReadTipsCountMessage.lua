local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentUnReadTipsCountMessage = BaseClass("MomentUnReadTipsCountMessage", base)

function MomentUnReadTipsCountMessage:OnCreate(getType)
  self.tableData = {type = getType}
end

function MomentUnReadTipsCountMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():SetMomentMsgRedDot(t.result.type, t.result.unread)
    end
  end
end

return MomentUnReadTipsCountMessage
