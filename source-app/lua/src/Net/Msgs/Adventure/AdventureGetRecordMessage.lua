local AdventureGetRecordMessage = BaseClass("AdventureGetRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.AdventureManager:HandleGetRecord(t)
end

AdventureGetRecordMessage.OnCreate = OnCreate
AdventureGetRecordMessage.HandleMessage = HandleMessage
return AdventureGetRecordMessage
