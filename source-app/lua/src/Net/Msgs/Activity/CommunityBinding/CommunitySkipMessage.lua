local CommunitySkipMessage = BaseClass("CommunitySkipMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, actId)
  base.OnCreate(self)
  if actId ~= nil then
    self.sfsObj:PutInt("activityId", actId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil or t.errorCode == nil then
  else
    UIUtil.ShowTipsId(t.errorCode)
  end
end

CommunitySkipMessage.OnCreate = OnCreate
CommunitySkipMessage.HandleMessage = HandleMessage
return CommunitySkipMessage
