local AllianceTrainRewardSaveMessage = BaseClass("AllianceTrainRewardSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceTrainRewardSaveMessage:OnCreate(trainPlatformId)
  base.OnCreate(self)
  self.sfsObj:PutInt("trainPlatformId", trainPlatformId)
end

function AllianceTrainRewardSaveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return AllianceTrainRewardSaveMessage
