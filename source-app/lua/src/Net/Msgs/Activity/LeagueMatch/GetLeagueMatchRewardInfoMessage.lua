local GetLeagueMatchRewardInfoMessage = BaseClass("GetLeagueMatchRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LeagueMatchManager:OnRecvLeagueMatchRewardInfoResp(t)
  end
end

GetLeagueMatchRewardInfoMessage.OnCreate = OnCreate
GetLeagueMatchRewardInfoMessage.HandleMessage = HandleMessage
return GetLeagueMatchRewardInfoMessage
