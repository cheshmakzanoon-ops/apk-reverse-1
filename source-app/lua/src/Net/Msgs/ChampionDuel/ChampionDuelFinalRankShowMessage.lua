local ChampionDuelFinalRankShowMessage = BaseClass("ChampionDuelFinalRankShowMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, num, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("num", num)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleFinalRankList(t)
end

ChampionDuelFinalRankShowMessage.OnCreate = OnCreate
ChampionDuelFinalRankShowMessage.HandleMessage = HandleMessage
return ChampionDuelFinalRankShowMessage
