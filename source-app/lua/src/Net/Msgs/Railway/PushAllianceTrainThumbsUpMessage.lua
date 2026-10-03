local PushAllianceTrainThumbsUpMessage = BaseClass("PushAllianceTrainThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushAllianceTrainThumbsUpMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceTrainThumbsUpMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:OnPushAllianceTrainThumbsUp(message)
end

return PushAllianceTrainThumbsUpMessage
