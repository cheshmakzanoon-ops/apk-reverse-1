local ChampionDuelBattleLogMessage = BaseClass("ChampionDuelBattleLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, time, num)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
  self.sfsObj:PutInt("time", time)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleBattleLog(t)
end

ChampionDuelBattleLogMessage.OnCreate = OnCreate
ChampionDuelBattleLogMessage.HandleMessage = HandleMessage
return ChampionDuelBattleLogMessage
