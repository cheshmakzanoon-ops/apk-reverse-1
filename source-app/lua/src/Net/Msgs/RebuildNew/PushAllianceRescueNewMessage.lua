local PushAllianceRescueNewMessage = BaseClass("PushAllianceRescueNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceRescueNewMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceRescueNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CityRebuildDataManager:SetRebuildRewardInfo(t)
  end
end

return PushAllianceRescueNewMessage
