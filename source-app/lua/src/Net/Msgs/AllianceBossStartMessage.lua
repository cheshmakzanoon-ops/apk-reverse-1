local AllianceBossStartMessage = BaseClass("AllianceBossStartMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossStartMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceBossStartMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgAllianceBossStart(message)
end

return AllianceBossStartMessage
