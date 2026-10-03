local AllianceTrainVipHasThumbsUpMessage = BaseClass("AllianceTrainVipHasThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainVipHasThumbsUpMessage:OnCreate(platform)
  base.OnCreate(self)
  self.sfsObj:PutInt("platform", platform)
end

function AllianceTrainVipHasThumbsUpMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:OnAllianceTrainVipHasThumbs(message)
end

return AllianceTrainVipHasThumbsUpMessage
