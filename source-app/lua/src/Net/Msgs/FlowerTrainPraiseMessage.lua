local FlowerTrainPraiseMessage = BaseClass("FlowerTrainPraiseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FlowerTrainPraiseMessage:OnCreate(playerUid, carUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("trainUuid", carUuid)
  self.sfsObj:PutLong("otherUid", playerUid)
end

function FlowerTrainPraiseMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    if t.reward ~= nil and table.count(t.reward) > 0 then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    if t.addExp then
      local addExp = t.addExp or 0
      local info = Localization:GetString("2025halloween_treasure_like_alert", addExp)
      UIUtil.ShowTips(info)
    end
    EventManager:GetInstance():Broadcast(EventId.FlowerTrainSuccessLike)
  end
end

return FlowerTrainPraiseMessage
