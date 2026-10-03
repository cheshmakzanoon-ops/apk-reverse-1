local MeteoriteGetRewardMessage = BaseClass("MeteoriteGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteGetRewardMessage:OnCreate(rewardId)
  base.OnCreate(self)
  self.sfsObj:PutInt("rewardId", rewardId)
end

function MeteoriteGetRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnHandleGetReward(t)
end

return MeteoriteGetRewardMessage
