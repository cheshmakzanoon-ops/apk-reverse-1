local AdventureGetRecordDetailMessage = BaseClass("AdventureGetRecordDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.AdventureManager:HandleGetRecordDetail(t)
end

AdventureGetRecordDetailMessage.OnCreate = OnCreate
AdventureGetRecordDetailMessage.HandleMessage = HandleMessage
return AdventureGetRecordDetailMessage
