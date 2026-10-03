local ChampionDuelRewardGetMessage = BaseClass("ChampionDuelRewardGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  if type then
    self.sfsObj:PutInt("type", type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleRewardGet(t)
end

ChampionDuelRewardGetMessage.OnCreate = OnCreate
ChampionDuelRewardGetMessage.HandleMessage = HandleMessage
return ChampionDuelRewardGetMessage
