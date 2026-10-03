local ActivityTorchRelayRankRewardInfoMessage = BaseClass("ActivityTorchRelayRankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("activityId", tonumber(param.aid))
    self.sfsObj:PutInt("type", param.type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:OnGetRankRewardInfoCallback(t)
  end
end

ActivityTorchRelayRankRewardInfoMessage.OnCreate = OnCreate
ActivityTorchRelayRankRewardInfoMessage.HandleMessage = HandleMessage
return ActivityTorchRelayRankRewardInfoMessage
