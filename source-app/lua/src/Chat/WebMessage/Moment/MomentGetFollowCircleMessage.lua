local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentGetFollowCircleMessage = BaseClass("MomentFollowMessage", base)

function MomentGetFollowCircleMessage:OnCreate(param)
  self.tableData = param
end

function MomentGetFollowCircleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():AddMomentDatas(t.result.groupType, t.result)
    end
  end
end

return MomentGetFollowCircleMessage
