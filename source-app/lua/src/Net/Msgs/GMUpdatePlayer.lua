local GMUpdatePlayer = BaseClass("GMUpdatePlayer", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, stageId)
  base.OnCreate(self)
  printError("SEND GMUpdatePlayer")
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  CS.ApplicationLaunch.Instance:ReloadGame()
end

GMUpdatePlayer.OnCreate = OnCreate
GMUpdatePlayer.HandleMessage = HandleMessage
return GMUpdatePlayer
