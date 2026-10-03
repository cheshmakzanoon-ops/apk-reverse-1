local AllianceTrainRewardReplaceMessage = BaseClass("AllianceTrainRewardReplaceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceTrainRewardReplaceMessage:OnCreate(trainPlatformId)
  base.OnCreate(self)
  self.sfsObj:PutInt("trainPlatformId", trainPlatformId)
end

function AllianceTrainRewardReplaceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return AllianceTrainRewardReplaceMessage
