local ActivityTorchRelayRankInfoMessage = BaseClass("ActivityTorchRelayRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("activityId", param.aid)
    self.sfsObj:PutInt("type", param.type)
    self.sfsObj:PutInt("start", param.startN)
    self.sfsObj:PutInt("end", param.endN)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:OnGetRankInfoCallback(t)
  end
end

ActivityTorchRelayRankInfoMessage.OnCreate = OnCreate
ActivityTorchRelayRankInfoMessage.HandleMessage = HandleMessage
return ActivityTorchRelayRankInfoMessage
