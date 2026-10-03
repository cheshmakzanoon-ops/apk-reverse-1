local AllianceTrainVipThumbsUpMessage = BaseClass("AllianceTrainVipThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainVipThumbsUpMessage:OnCreate(platform)
  base.OnCreate(self)
  self.sfsObj:PutInt("platform", platform)
end

function AllianceTrainVipThumbsUpMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  UIUtil.ShowTips(Localization:GetString("alliance_train_vip033"))
  DataCenter.LWAllyStationDataManager:OnAllianceTrainVipHasThumbs(message)
end

return AllianceTrainVipThumbsUpMessage
