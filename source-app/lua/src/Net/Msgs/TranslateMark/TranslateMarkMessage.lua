local TranslateMarkMessage = BaseClass("TranslateMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function TranslateMarkMessage:OnCreate(mailUid, score)
  base.OnCreate(self)
  self.sfsObj:PutInt("score", score)
  self.sfsObj:PutUtfString("mailUid", mailUid)
  DataCenter.LWTranslationRatingManager:UpdateData(mailUid, score)
end

function TranslateMarkMessage:HandleMessage(message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
end

return TranslateMarkMessage
