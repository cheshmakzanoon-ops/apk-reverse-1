local StageFeatureIntegratedPushTimes = BaseClass("StageFeatureIntegratedPushTimes", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureIntegratedPushTimes:OnCreate()
  base.OnCreate(self)
end

function StageFeatureIntegratedPushTimes:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWIntegratedStageFeatureChapterManager:UpdateDataFromPushTimes(message)
end

return StageFeatureIntegratedPushTimes
