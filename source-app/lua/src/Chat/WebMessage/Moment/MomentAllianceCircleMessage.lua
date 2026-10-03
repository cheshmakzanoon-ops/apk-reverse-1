local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local MomentAllianceCircleMessage = BaseClass("MomentAllianceCircleMessage", base)

function MomentAllianceCircleMessage:OnCreate(roomId, fristId)
  self.tableData = {
    roomId = roomId,
    lastMsgId = fristId,
    desc = true
  }
end

function MomentAllianceCircleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowErrorCodeTips(errCode)
      return
    else
      ChatInterface.getMoment():AddMomentDatas(ChatGroupType.GROUP_ALLIANCE_MOMENT, t.result.circlesMessage)
    end
  end
end

return MomentAllianceCircleMessage
