local SeasonDigGameShareTimeUpdatePushMessage = BaseClass("SeasonDigGameShareTimeUpdatePushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.DiggingDataManager:SetShareTime(t.shardTime)
end

local function GetTestData(self)
end

SeasonDigGameShareTimeUpdatePushMessage.GetTestData = GetTestData
SeasonDigGameShareTimeUpdatePushMessage.OnCreate = OnCreate
SeasonDigGameShareTimeUpdatePushMessage.HandleMessage = HandleMessage
return SeasonDigGameShareTimeUpdatePushMessage
