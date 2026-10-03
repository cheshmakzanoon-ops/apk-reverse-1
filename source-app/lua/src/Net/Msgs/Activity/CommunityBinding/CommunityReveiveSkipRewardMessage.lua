local CommunityReveiveSkipRewardMessage = BaseClass("CommunityReveiveSkipRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, actId)
  base.OnCreate(self)
  if actId ~= nil then
    self.sfsObj:PutInt("activityId", actId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      if t.reward then
        DataCenter.ActCommunityLinkManager:OnGetSkipReward(t)
      end
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

CommunityReveiveSkipRewardMessage.OnCreate = OnCreate
CommunityReveiveSkipRewardMessage.HandleMessage = HandleMessage
return CommunityReveiveSkipRewardMessage
