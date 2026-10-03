local ExpiredItemConvertMessage = BaseClass("ExpiredItemConvertMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:AddRewards(t.reward)
    end
    EventManager:GetInstance():Broadcast(EventId.ExpiredItemsConvert, t)
  end
end

ExpiredItemConvertMessage.OnCreate = OnCreate
ExpiredItemConvertMessage.HandleMessage = HandleMessage
return ExpiredItemConvertMessage
