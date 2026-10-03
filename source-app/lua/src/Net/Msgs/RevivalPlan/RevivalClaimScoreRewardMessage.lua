local RevivalClaimScoreRewardMessage = BaseClass("RevivalClaimScoreRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RevivalClaimScoreRewardMessage:OnCreate(index, stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
  self.sfsObj:PutInt("stageId", stageId)
end

function RevivalClaimScoreRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RevivalPlanManager:OnClaimReward(t)
  end
end

return RevivalClaimScoreRewardMessage
