local AllianceBossSetAutoRallyMessage = BaseClass("AllianceBossSetAutoRallyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossSetAutoRallyMessage:OnCreate(isAutoRally)
  base.OnCreate(self)
  self.sfsObj:PutInt("isAutoRally", isAutoRally)
end

function AllianceBossSetAutoRallyMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.S0AllianceBossDataManager:ParseAutoRallyData(message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgChangeAutoRally(message)
end

return AllianceBossSetAutoRallyMessage
