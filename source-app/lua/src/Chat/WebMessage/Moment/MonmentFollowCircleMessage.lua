local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MonmentFollowCircleMessage = BaseClass("MonmentFollowCircleMessage", base)

function MonmentFollowCircleMessage:OnCreate(fristId)
  self.tableData = {lastMsgId = fristId, desc = true}
end

function MonmentFollowCircleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():AddMomentDatas(ChatGroupType.GROUP_FOLLOW_MOMENT, t.result.circlesMessage)
    end
  end
end

return MonmentFollowCircleMessage
