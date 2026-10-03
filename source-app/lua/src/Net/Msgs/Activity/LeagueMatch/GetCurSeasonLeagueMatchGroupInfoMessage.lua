local GetCurSeasonLeagueMatchGroupInfoMessage = BaseClass("GetCurSeasonLeagueMatchGroupInfoMessage", SFSBaseMessage)
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
    DataCenter.LeagueMatchManager:OnRecvMatchGroupResp(t)
  end
end

GetCurSeasonLeagueMatchGroupInfoMessage.OnCreate = OnCreate
GetCurSeasonLeagueMatchGroupInfoMessage.HandleMessage = HandleMessage
return GetCurSeasonLeagueMatchGroupInfoMessage
