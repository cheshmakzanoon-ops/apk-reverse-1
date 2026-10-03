local AllianceBossTopListMessage = BaseClass("AllianceBossTopListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossTopListMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function AllianceBossTopListMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgAllianceBossTopList(message)
end

return AllianceBossTopListMessage
