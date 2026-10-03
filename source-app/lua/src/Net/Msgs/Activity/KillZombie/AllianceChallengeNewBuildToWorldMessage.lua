local AllianceChallengeNewBuildToWorldMessage = BaseClass("AllianceChallengeNewBuildToWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceChallengeNewBuildToWorldMessage:OnCreate(configId, pointId, planTime)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", configId)
  self.sfsObj:PutInt("pointId", pointId)
  if planTime then
    self.sfsObj:PutLong("planTime", planTime)
  end
end

function AllianceChallengeNewBuildToWorldMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= nil then
      UIUtil.ShowTipsId(errorCode)
    end
  end
end

return AllianceChallengeNewBuildToWorldMessage
