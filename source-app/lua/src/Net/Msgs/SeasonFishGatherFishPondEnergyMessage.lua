local SeasonFishGatherFishPondEnergyMessage = BaseClass("SeasonFishGatherFishPondEnergyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishGatherFishPondEnergyMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonFishGatherFishPondEnergyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.OnSeasonFishGatherFishPondEnergy)
  end
end

return SeasonFishGatherFishPondEnergyMessage
