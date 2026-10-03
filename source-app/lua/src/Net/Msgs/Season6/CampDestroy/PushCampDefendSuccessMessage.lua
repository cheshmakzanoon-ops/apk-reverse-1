local PushCampDefendSuccessMessage = BaseClass("PushCampDefendSuccessMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCampDefendSuccessMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.SeasonCampDestroyManager:OnDefendSuccess(t)
end

return PushCampDefendSuccessMessage
