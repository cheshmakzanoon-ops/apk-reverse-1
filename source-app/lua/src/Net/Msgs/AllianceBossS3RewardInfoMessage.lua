local AllianceBossS3RewardInfoMessage = BaseClass("AllianceBossS3RewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossS3RewardInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function AllianceBossS3RewardInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgAllianceBossRewardInfo(message)
end

return AllianceBossS3RewardInfoMessage
