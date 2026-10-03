local PushLeagueMatchBaseInfoMessage = BaseClass("PushLeagueMatchBaseInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LeagueMatchManager:OnRecvSeasonChangePush(t)
  end
end

PushLeagueMatchBaseInfoMessage.OnCreate = OnCreate
PushLeagueMatchBaseInfoMessage.HandleMessage = HandleMessage
return PushLeagueMatchBaseInfoMessage
