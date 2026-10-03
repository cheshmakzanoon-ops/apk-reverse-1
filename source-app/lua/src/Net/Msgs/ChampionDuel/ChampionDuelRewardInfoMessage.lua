local ChampionDuelRewardInfoMessage = BaseClass("ChampionDuelRewardInfoMessage", SFSBaseMessage)
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
  DataCenter.ChampionDuelManager:HandleRewardInfo(t)
end

ChampionDuelRewardInfoMessage.OnCreate = OnCreate
ChampionDuelRewardInfoMessage.HandleMessage = HandleMessage
return ChampionDuelRewardInfoMessage
