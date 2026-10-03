local ChampionDuelAuditionInfoPushMessage = BaseClass("ChampionDuelAuditionInfoPushMessage", SFSBaseMessage)
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
  DataCenter.ChampionDuelManager:HandleAuditionInfo(t)
end

ChampionDuelAuditionInfoPushMessage.OnCreate = OnCreate
ChampionDuelAuditionInfoPushMessage.HandleMessage = HandleMessage
return ChampionDuelAuditionInfoPushMessage
