local PushGhostParkourTierRewardMessage = BaseClass("PushGhostParkourTierRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGhostParkourTierRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushGhostParkourTierRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SendGetGhostParkourTierInfoMessage()
  end
end

return PushGhostParkourTierRewardMessage
