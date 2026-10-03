local PushSeasonAllianceBuilderChangeMessage = BaseClass("PushSeasonAllianceBuilderChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil then
    return
  end
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if not LuaEntry.Player.allianceId or t.allianceId ~= LuaEntry.Player.allianceId then
    return
  end
  DataCenter.SeasonFarmerManager:OnBuilderStateChange(t)
end

PushSeasonAllianceBuilderChangeMessage.OnCreate = OnCreate
PushSeasonAllianceBuilderChangeMessage.HandleMessage = HandleMessage
PushSeasonAllianceBuilderChangeMessage.GetTestData = GetTestData
return PushSeasonAllianceBuilderChangeMessage
