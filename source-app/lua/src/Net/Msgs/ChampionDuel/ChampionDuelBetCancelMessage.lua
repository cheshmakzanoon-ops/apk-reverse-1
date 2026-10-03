local ChampionDuelBetCancelMessage = BaseClass("ChampionDuelBetCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, cancelBetMatchId)
  base.OnCreate(self)
  self.sfsObj:PutLong("cancelBetMatchId", cancelBetMatchId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleBetOperate(t, false)
end

ChampionDuelBetCancelMessage.OnCreate = OnCreate
ChampionDuelBetCancelMessage.HandleMessage = HandleMessage
return ChampionDuelBetCancelMessage
