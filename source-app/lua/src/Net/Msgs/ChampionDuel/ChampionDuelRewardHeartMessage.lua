local ChampionDuelRewardHeartMessage = BaseClass("ChampionDuelRewardHeartMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, rewardId)
  base.OnCreate(self)
  self.sfsObj:PutInt("rewardId", rewardId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelRewardHeartFinish)
end

ChampionDuelRewardHeartMessage.OnCreate = OnCreate
ChampionDuelRewardHeartMessage.HandleMessage = HandleMessage
return ChampionDuelRewardHeartMessage
