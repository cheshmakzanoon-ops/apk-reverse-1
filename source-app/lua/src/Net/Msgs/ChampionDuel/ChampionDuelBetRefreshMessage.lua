local ChampionDuelBetRefreshMessage = BaseClass("ChampionDuelBetRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleBetMain(t)
end

ChampionDuelBetRefreshMessage.OnCreate = OnCreate
ChampionDuelBetRefreshMessage.HandleMessage = HandleMessage
return ChampionDuelBetRefreshMessage
