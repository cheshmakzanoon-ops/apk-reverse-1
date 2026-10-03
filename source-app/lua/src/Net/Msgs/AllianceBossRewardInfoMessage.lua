local AllianceBossRewardInfoMessage = BaseClass("AllianceBossRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossRewardInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function AllianceBossRewardInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgAllianceBossRewardInfo(message)
end

return AllianceBossRewardInfoMessage
