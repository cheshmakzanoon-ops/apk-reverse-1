local StageFeatureChapterPushTimes = BaseClass("StageFeatureChapterPushTimes", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureChapterPushTimes:OnCreate()
  base.OnCreate(self)
end

function StageFeatureChapterPushTimes:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWStageFeatureChapterManager:UpdateDataFromPushTimes(message)
end

return StageFeatureChapterPushTimes
