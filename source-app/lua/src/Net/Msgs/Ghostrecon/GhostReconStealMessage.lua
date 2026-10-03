local GhostReconStealMessage = BaseClass("GhostReconStealMessage", SFSBaseMessage)
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
      t.fromGhostreconStealMessage = true
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.ActGhostreconManager:GhostReconStealHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostReconStealMessage.OnCreate = OnCreate
GhostReconStealMessage.HandleMessage = HandleMessage
return GhostReconStealMessage
