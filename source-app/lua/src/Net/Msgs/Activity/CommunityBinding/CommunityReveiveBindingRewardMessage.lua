local CommunityReveiveBindingRewardMessage = BaseClass("CommunityReveiveBindingRewardMessage", SFSBaseMessage)
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
        DataCenter.ActCommunityLinkManager:OnGetBindingReward(t)
      end
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

CommunityReveiveBindingRewardMessage.OnCreate = OnCreate
CommunityReveiveBindingRewardMessage.HandleMessage = HandleMessage
return CommunityReveiveBindingRewardMessage
