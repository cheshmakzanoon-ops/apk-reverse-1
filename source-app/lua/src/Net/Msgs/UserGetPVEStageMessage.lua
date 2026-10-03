local UserGetPVEStageMessage = BaseClass("UserGetPVEStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, level)
  base.OnCreate(self)
  self.sfsObj:PutInt("level", level)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BattleLevel:OnGetStageMessage(message)
end

UserGetPVEStageMessage.OnCreate = OnCreate
UserGetPVEStageMessage.HandleMessage = HandleMessage
return UserGetPVEStageMessage
