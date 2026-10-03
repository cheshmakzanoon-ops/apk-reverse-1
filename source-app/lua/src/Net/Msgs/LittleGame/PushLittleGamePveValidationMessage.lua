local PushLittleGamePveValidationMessage = BaseClass("PushLittleGamePveValidationMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGGGoDataManager:ValidationMessage(t)
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes({
        reward = t.reward
      })
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoPveValidationEnd, t)
  end
end

PushLittleGamePveValidationMessage.HandleMessage = HandleMessage
return PushLittleGamePveValidationMessage
