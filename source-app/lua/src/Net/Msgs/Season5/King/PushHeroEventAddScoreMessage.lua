local RewardUtil = require("Util.RewardUtil")
local PushHeroEventAddScoreMessage = BaseClass("PushHeroEventAddScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushHeroEventAddScoreMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushHeroEventAddScoreMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  RewardUtil.UpdateHeroEventDataSingle(t)
end

return PushHeroEventAddScoreMessage
