local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentTimeLineUpdateAuthMessage = BaseClass("MomentTimeLineUpdateAuthMessage", base)

function MomentTimeLineUpdateAuthMessage:OnCreate(seqId, authTable)
  self.tableData = {seqId = seqId, auth = authTable}
end

function MomentTimeLineUpdateAuthMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    elseif t.result then
      ChatInterface.getMoment():UpdateAuth(t.result)
    end
  end
end

return MomentTimeLineUpdateAuthMessage
