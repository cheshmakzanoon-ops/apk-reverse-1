local PushPveMonsterUpdateMessage = BaseClass("PushPveMonsterUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.MonsterLockDataManager:UpdateAllMonster(t)
end

PushPveMonsterUpdateMessage.OnCreate = OnCreate
PushPveMonsterUpdateMessage.HandleMessage = HandleMessage
return PushPveMonsterUpdateMessage
