local PushDefendFormationUpdateNewMessage = BaseClass("PushDefendFormationUpdateNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ArmyFormationDataManager:InitArmyFormationListData(t)
  EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
end

PushDefendFormationUpdateNewMessage.OnCreate = OnCreate
PushDefendFormationUpdateNewMessage.HandleMessage = HandleMessage
return PushDefendFormationUpdateNewMessage
