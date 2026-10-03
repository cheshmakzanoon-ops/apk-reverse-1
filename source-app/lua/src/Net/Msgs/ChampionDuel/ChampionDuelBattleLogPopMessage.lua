local ChampionDuelBattleLogPopMessage = BaseClass("ChampionDuelBattleLogPopMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, time)
  base.OnCreate(self)
  self.sfsObj:PutInt("time", time)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleBattleLogPop(t)
end

ChampionDuelBattleLogPopMessage.OnCreate = OnCreate
ChampionDuelBattleLogPopMessage.HandleMessage = HandleMessage
return ChampionDuelBattleLogPopMessage
