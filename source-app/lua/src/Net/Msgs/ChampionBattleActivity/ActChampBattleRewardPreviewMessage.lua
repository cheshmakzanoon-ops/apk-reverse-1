local ActChampBattleRewardPreviewMessage = BaseClass("ActChampBattleRewardPreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionBattleRewardPreviewBack, message)
end

ActChampBattleRewardPreviewMessage.OnCreate = OnCreate
ActChampBattleRewardPreviewMessage.HandleMessage = HandleMessage
return ActChampBattleRewardPreviewMessage
