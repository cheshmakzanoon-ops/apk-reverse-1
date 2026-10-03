local ChampionDuelStageInfoMessage = BaseClass("ChampionDuelStageInfoMessage", SFSBaseMessage)
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
end

ChampionDuelStageInfoMessage.OnCreate = OnCreate
ChampionDuelStageInfoMessage.HandleMessage = HandleMessage
return ChampionDuelStageInfoMessage
