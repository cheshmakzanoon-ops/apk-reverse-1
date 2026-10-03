local PushAllianceLeaderTransMessage = BaseClass("PushAllianceLeaderTransMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.alliance ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t)
  end
end

PushAllianceLeaderTransMessage.OnCreate = OnCreate
PushAllianceLeaderTransMessage.HandleMessage = HandleMessage
return PushAllianceLeaderTransMessage
