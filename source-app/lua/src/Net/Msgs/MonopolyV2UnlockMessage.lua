local MonopolyV2UnlockMessage = BaseClass("MonopolyV2UnlockMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate()
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.MonopolyManager:SetV2UnlockData(t)
end

MonopolyV2UnlockMessage.OnCreate = OnCreate
MonopolyV2UnlockMessage.HandleMessage = HandleMessage
return MonopolyV2UnlockMessage
