local PushAllianceBossCreateMessage = BaseClass("PushAllianceBossCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushAllianceBossCreateMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceBossCreateMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgPushAllianceBossCreate(message)
end

return PushAllianceBossCreateMessage
