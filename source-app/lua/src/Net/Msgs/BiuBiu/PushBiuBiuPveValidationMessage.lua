local PushBiuBiuPveValidationMessage = BaseClass("PushBiuBiuPveValidationMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWBiuBiuDataManager:ValidationMessage(t)
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes({
        reward = t.reward
      })
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPveValidationEnd, t)
  end
end

PushBiuBiuPveValidationMessage.HandleMessage = HandleMessage
return PushBiuBiuPveValidationMessage
