local AllianceBossDonateMessage = BaseClass("AllianceBossDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceBossDonateMessage:OnCreate(num)
  base.OnCreate(self)
  self.sfsObj:PutInt("num", num)
end

function AllianceBossDonateMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgAllianceBossDonate(message)
end

return AllianceBossDonateMessage
