local PushAllianceStarRewardInfoMessage = BaseClass("PushAllianceStarRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStarRewardInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStarRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:UploadServerLog("PushAllianceStarRewardInfoMessage")
    DataCenter.AllianceStarManager:OnPushAllianceStarRewardInfoMessage(t)
  end
end

return PushAllianceStarRewardInfoMessage
