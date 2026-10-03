local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentTimeLineExposureMessage = BaseClass("MomentTimeLineExposureMessage", base)

function MomentTimeLineExposureMessage:OnCreate(msgIdList)
  self.tableData = {exposureSet = msgIdList}
end

function MomentTimeLineExposureMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    end
  end
end

return MomentTimeLineExposureMessage
