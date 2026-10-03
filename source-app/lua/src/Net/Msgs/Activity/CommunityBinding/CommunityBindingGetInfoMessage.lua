local CommunityBindingGetInfoMessage = BaseClass("CommunityBindingGetInfoMessage", SFSBaseMessage)
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
      DataCenter.ActCommunityLinkManager:ParseData(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

CommunityBindingGetInfoMessage.OnCreate = OnCreate
CommunityBindingGetInfoMessage.HandleMessage = HandleMessage
return CommunityBindingGetInfoMessage
