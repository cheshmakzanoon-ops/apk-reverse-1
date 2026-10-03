local StartLandLockPVEMessage = BaseClass("StartLandLockPVEMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("landId", id)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BattleLevel:OnStartLevelMessage(message)
end

StartLandLockPVEMessage.OnCreate = OnCreate
StartLandLockPVEMessage.HandleMessage = HandleMessage
return StartLandLockPVEMessage
