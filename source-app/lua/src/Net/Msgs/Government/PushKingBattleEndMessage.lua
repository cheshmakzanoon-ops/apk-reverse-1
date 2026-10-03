local PushKingBattleEndMessage = BaseClass("PushKingBattleEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:OnHandleKingBattleEnd(t)
  DataCenter.ZoneWarManager:OnHandleBattleEnd()
end

PushKingBattleEndMessage.OnCreate = OnCreate
PushKingBattleEndMessage.HandleMessage = HandleMessage
return PushKingBattleEndMessage
