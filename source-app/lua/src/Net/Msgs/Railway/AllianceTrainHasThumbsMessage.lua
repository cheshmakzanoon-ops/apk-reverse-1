local AllianceTrainHasThumbsMessage = BaseClass("AllianceTrainHasThumbsMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainHasThumbsMessage:OnCreate(platformId)
  base.OnCreate(self)
  self.sfsObj:PutInt("platformId", platformId)
end

function AllianceTrainHasThumbsMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:OnAllianceTrainHasThumbs(message)
end

return AllianceTrainHasThumbsMessage
