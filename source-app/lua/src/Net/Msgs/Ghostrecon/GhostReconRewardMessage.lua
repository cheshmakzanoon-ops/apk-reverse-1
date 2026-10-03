local GhostReconRewardMessage = BaseClass("GhostReconRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, ownerServer)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
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

GhostReconRewardMessage.OnCreate = OnCreate
GhostReconRewardMessage.HandleMessage = HandleMessage
return GhostReconRewardMessage
