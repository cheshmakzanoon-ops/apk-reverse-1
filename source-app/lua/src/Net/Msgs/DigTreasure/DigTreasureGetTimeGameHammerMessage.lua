local DigTreasureGetTimeGameHammerMessage = BaseClass("DigTreasureGetTimeGameHammerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DigTreasureGetTimeGameHammerMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function DigTreasureGetTimeGameHammerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = t.reward
    local str
    if reward and reward[1].value and reward[1].value.rewardAdd then
      str = Localization:GetString("treasure_map_special_level_08", reward[1].value.rewardAdd)
    end
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, nil, str)
    if t.gameMap then
      DataCenter.DigTreasureManager:UpdateTimeLimitMap(t.gameMap)
      EventManager:GetInstance():Broadcast(EventId.DigTreasureBeginTimeLimitMap)
    end
  end
end

return DigTreasureGetTimeGameHammerMessage
