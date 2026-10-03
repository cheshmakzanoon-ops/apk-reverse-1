local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentTimeLineRecommendMessage = BaseClass("MomentTimeLineRecommendMessage", base)

function MomentTimeLineRecommendMessage:OnCreate()
  self.tableData = {}
end

function MomentTimeLineRecommendMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    end
  end
end

return MomentTimeLineRecommendMessage
