local StageFeatureChapterResetTimes = BaseClass("StageFeatureChapterResetTimes", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureChapterResetTimes:OnCreate()
  base.OnCreate(self)
end

function StageFeatureChapterResetTimes:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWStageFeatureChapterManager:UpdateDataFromPushTimes(message)
end

return StageFeatureChapterResetTimes
