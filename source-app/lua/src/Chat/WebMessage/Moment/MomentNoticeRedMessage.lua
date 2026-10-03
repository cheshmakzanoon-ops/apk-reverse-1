local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PuhMomentFollowMsg = BaseClass("PuhMomentFollowMsg", base)

function PuhMomentFollowMsg:OnCreate(getType)
  self.tableData = {type = getType}
end

function PuhMomentFollowMsg:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    end
  end
end

return PuhMomentFollowMsg
