local StartPveMonsterMessage = BaseClass("StartPveMonsterMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("pveMonsterId", id)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BattleLevel:OnStartLevelMessage(message)
end

StartPveMonsterMessage.OnCreate = OnCreate
StartPveMonsterMessage.HandleMessage = HandleMessage
return StartPveMonsterMessage
