local CheckTrainRefreshMessage = BaseClass("CheckTrainRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function CheckTrainRefreshMessage:OnCreate(trainUuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", trainUuid)
  self.sfsObj:PutInt("serverId", serverId)
end

function CheckTrainRefreshMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  else
    DataCenter.LWTrainDataManager:OnCheckTrainRefreshReceived(message)
  end
end

return CheckTrainRefreshMessage
