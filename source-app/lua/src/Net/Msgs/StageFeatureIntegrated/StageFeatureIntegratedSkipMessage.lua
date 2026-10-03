local StageFeatureIntegratedSkipMessage = BaseClass("StageFeatureIntegratedSkipMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureIntegratedSkipMessage:OnCreate(diff, stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageType", diff)
  self.sfsObj:PutInt("id", stageId)
end

function StageFeatureIntegratedSkipMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.skipIds then
    DataCenter.LWIntegratedStageFeatureChapterManager:OnReceiveSkip(message)
  end
end

return StageFeatureIntegratedSkipMessage
