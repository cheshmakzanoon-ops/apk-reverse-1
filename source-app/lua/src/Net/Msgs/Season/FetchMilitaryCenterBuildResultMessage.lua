local FetchMilitaryCenterBuildResultMessage = BaseClass("FetchMilitaryCenterBuildResultMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchMilitaryCenterBuildResultMessage:OnCreate(buildId)
  base.OnCreate(self)
  self.sfsObj:PutInt("buildId", toInt(buildId))
end

function FetchMilitaryCenterBuildResultMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  local data = DataCenter.AllianceMineManager.militaryCenterBuildInfos or {}
  if t.info then
    data.info = t.info
  end
  if t.buildInfo then
    data.buildInfo = t.buildInfo
  end
  DataCenter.AllianceMineManager.militaryCenterBuildInfos = data
  EventManager:GetInstance():Broadcast(EventId.AllianceStoveCenterUpdate)
end

return FetchMilitaryCenterBuildResultMessage
