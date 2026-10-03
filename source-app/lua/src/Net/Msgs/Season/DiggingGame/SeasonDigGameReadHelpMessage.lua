local SeasonDigGameReadHelpMessage = BaseClass("SeasonDigGameReadHelpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
end

local function GetTestData(self, uuid)
  local mapData = DataCenter.DiggingDataManager.__Cache[uuid]
  if mapData == nil then
    return
  end
  mapData.helpInfo = nil
  return {}
end

SeasonDigGameReadHelpMessage.GetTestData = GetTestData
SeasonDigGameReadHelpMessage.OnCreate = OnCreate
SeasonDigGameReadHelpMessage.HandleMessage = HandleMessage
return SeasonDigGameReadHelpMessage
