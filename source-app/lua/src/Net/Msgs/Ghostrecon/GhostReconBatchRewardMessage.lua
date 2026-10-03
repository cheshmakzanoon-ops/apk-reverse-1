local GhostReconBatchRewardMessage = BaseClass("GhostReconBatchRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuidList, ownerServer)
  base.OnCreate(self)
  self.sfsObj:PutLongArray("uuidList", uuidList)
  self.sfsObj:PutInt("ownerServer", ownerServer)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.ActGhostreconManager:GhostReconRewardHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostReconBatchRewardMessage.OnCreate = OnCreate
GhostReconBatchRewardMessage.HandleMessage = HandleMessage
return GhostReconBatchRewardMessage
