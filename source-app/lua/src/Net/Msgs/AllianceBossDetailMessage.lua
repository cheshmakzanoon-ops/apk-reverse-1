local AllianceBossDetailMessage = BaseClass("AllianceBossDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossDetailMessage:OnCreate(uuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("serverId", serverId)
end

function AllianceBossDetailMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgAllianceBossDetail(message)
end

return AllianceBossDetailMessage
