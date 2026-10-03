local SkinPartyBaseRewardMessage = BaseClass("SkinPartyBaseRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SkinPartyBaseRewardMessage:OnCreate(statusId, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("statusId", statusId)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

function SkinPartyBaseRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

return SkinPartyBaseRewardMessage
