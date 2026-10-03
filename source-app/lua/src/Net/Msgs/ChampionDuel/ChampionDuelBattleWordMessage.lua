local ChampionDuelBattleWordMessage = BaseClass("ChampionDuelBattleWordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, msg)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("msg", msg)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleBattleWorld(t)
end

ChampionDuelBattleWordMessage.OnCreate = OnCreate
ChampionDuelBattleWordMessage.HandleMessage = HandleMessage
return ChampionDuelBattleWordMessage
