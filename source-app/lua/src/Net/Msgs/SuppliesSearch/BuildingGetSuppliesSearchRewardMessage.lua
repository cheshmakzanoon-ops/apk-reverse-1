local BuildingGetSuppliesSearchRewardMessage = BaseClass("BuildingGetSuppliesSearchRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BuildingGetSuppliesSearchRewardMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("buildingUuid", uuid)
end

function BuildingGetSuppliesSearchRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

return BuildingGetSuppliesSearchRewardMessage
