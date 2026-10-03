local AlBattleAllWeekVsInfoMessage = BaseClass("AlBattleAllWeekVsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, week)
  base.OnCreate(self)
  self.sfsObj:PutInt("week", week)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LeagueMatchManager:OnRecvAlBattleAllWeekVsInfo(t)
  end
end

AlBattleAllWeekVsInfoMessage.OnCreate = OnCreate
AlBattleAllWeekVsInfoMessage.HandleMessage = HandleMessage
return AlBattleAllWeekVsInfoMessage
