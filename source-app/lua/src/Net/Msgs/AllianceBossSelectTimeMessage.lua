local AllianceBossSelectTimeMessage = BaseClass("AllianceBossSelectTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossSelectTimeMessage:OnCreate(readyTime, difficulty)
  base.OnCreate(self)
  self.sfsObj:PutLong("readyTime", readyTime)
  self.sfsObj:PutInt("difficulty", difficulty)
end

function AllianceBossSelectTimeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgAllianceBossSelectTime(message)
end

return AllianceBossSelectTimeMessage
