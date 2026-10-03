local PushAllianceBossStartMessage = BaseClass("PushAllianceBossStartMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushAllianceBossStartMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceBossStartMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgPushAllianceBossStart(message)
end

return PushAllianceBossStartMessage
