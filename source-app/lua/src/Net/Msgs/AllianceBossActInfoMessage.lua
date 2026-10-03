local AllianceBossActInfoMessage = BaseClass("AllianceBossActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossActInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function AllianceBossActInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    if message.errorCode ~= "E100172" then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgAllianceBossActInfo(message)
end

return AllianceBossActInfoMessage
