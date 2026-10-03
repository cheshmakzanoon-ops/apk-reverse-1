local StageFeatureChapterSkipMessage = BaseClass("StageFeatureChapterSkipMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureChapterSkipMessage:OnCreate(stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", stageId)
end

function StageFeatureChapterSkipMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.skipIds then
    DataCenter.LWStageFeatureChapterManager:OnReceiveSkip(message)
  end
  if message.newBieSkipIds then
    DataCenter.LWEasyStageFeatureChapterManager:OnReceiveSkip(message)
  end
end

return StageFeatureChapterSkipMessage
