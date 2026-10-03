local AllianceTrainInviteVIPMessage = BaseClass("AllianceTrainInviteVIPMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainInviteVIPMessage:OnCreate(type, vipId, platform, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("vipId", vipId)
  self.sfsObj:PutInt("platform", platform)
  self.sfsObj:PutInt("index", index)
end

function AllianceTrainInviteVIPMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.index then
    SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.TRAIN_VIP_TIME_SELECT, tostring(message.index))
  else
    Logger.LogError("AllianceTrainInviteVIPMessage:\232\191\148\229\155\158\230\149\176\230\141\174\230\156\137\232\175\175")
  end
end

return AllianceTrainInviteVIPMessage
