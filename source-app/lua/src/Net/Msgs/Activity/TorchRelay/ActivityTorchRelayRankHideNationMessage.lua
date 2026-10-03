local ActivityTorchRelayRankHideNationMessage = BaseClass("ActivityTorchRelayRankHideNationMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutBool("hide", param.hide)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:OnSetHideNationCallback(t)
  end
end

ActivityTorchRelayRankHideNationMessage.OnCreate = OnCreate
ActivityTorchRelayRankHideNationMessage.HandleMessage = HandleMessage
return ActivityTorchRelayRankHideNationMessage
