local PushFactoryStatusUpdate = BaseClass("PushFactoryStatusUpdate", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.factoryArr ~= nil then
    local arr = t.factoryArr
    table.walk(arr, function(_, v)
      DataCenter.FactoryDataManager:RefreshFactoryList(v)
    end)
  end
end

PushFactoryStatusUpdate.OnCreate = OnCreate
PushFactoryStatusUpdate.HandleMessage = HandleMessage
return PushFactoryStatusUpdate
