local AllianceTrainRefuseVipMessage = BaseClass("AllianceTrainRefuseVipMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainRefuseVipMessage:OnCreate(platform)
  base.OnCreate(self)
  self.sfsObj:PutInt("platform", platform)
end

function AllianceTrainRefuseVipMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
end

return AllianceTrainRefuseVipMessage
