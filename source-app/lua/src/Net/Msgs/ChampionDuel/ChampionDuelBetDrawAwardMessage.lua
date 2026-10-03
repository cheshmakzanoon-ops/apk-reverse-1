local ChampionDuelBetDrawAwardMessage = BaseClass("ChampionDuelBetDrawAwardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, betMatchId)
  base.OnCreate(self)
  self.sfsObj:PutLong("betMatchId", betMatchId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleDrawReward(t)
end

ChampionDuelBetDrawAwardMessage.OnCreate = OnCreate
ChampionDuelBetDrawAwardMessage.HandleMessage = HandleMessage
return ChampionDuelBetDrawAwardMessage
