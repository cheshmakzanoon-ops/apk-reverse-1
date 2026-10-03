local AllianceTrainVIPInviteListMessage = BaseClass("AllianceTrainVIPInviteListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainVIPInviteListMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceTrainVIPInviteListMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:SetVipMemberListData(message)
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainVipInviteList, message.list)
end

return AllianceTrainVIPInviteListMessage
