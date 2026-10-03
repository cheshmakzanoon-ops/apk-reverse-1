local ChampionDuelBetStartMessage = BaseClass("ChampionDuelBetStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, betMatchId, betUid, betCountId)
  base.OnCreate(self)
  self.sfsObj:PutLong("betMatchId", betMatchId)
  self.sfsObj:PutUtfString("betUid", betUid)
  self.sfsObj:PutInt("betCountId", betCountId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleBetOperate(t, true)
end

ChampionDuelBetStartMessage.OnCreate = OnCreate
ChampionDuelBetStartMessage.HandleMessage = HandleMessage
return ChampionDuelBetStartMessage
