local AllianceTrainAcceptVipMessage = BaseClass("AllianceTrainAcceptVipMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainAcceptVipMessage:OnCreate(platform)
  base.OnCreate(self)
  self.sfsObj:PutInt("platform", platform)
end

function AllianceTrainAcceptVipMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWTrainPrepareSceneManager:SetAcceptVipValue(true)
end

return AllianceTrainAcceptVipMessage
