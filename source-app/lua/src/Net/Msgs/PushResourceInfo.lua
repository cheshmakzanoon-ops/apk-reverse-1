local PushResourceInfo = BaseClass("PushResourceInfo", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if LuaEntry.Resource ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
  if t.gold ~= nil then
    LuaEntry.Player.gold = t.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  if t.accPoint ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
  end
end

PushResourceInfo.OnCreate = OnCreate
PushResourceInfo.HandleMessage = HandleMessage
return PushResourceInfo
