local PushAllianceTrainStartInfoMessage = BaseClass("PushAllianceTrainStartInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushAllianceTrainStartInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceTrainStartInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:OnPushAllianceTrainStartInfo(message)
end

return PushAllianceTrainStartInfoMessage
