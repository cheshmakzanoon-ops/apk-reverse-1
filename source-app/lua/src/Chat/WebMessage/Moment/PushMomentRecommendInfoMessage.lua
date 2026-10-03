local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushMomentRecommendInfoMessage = BaseClass("PushMomentRecommendInfoMessage", base)

function PushMomentRecommendInfoMessage:OnCreate(msg)
end

function PushMomentRecommendInfoMessage:HandleMessage(t)
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

return PushMomentRecommendInfoMessage
