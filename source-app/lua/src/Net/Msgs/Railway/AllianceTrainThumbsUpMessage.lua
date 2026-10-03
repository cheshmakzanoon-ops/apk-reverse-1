local AllianceTrainThumbsUpMessage = BaseClass("AllianceTrainThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainThumbsUpMessage:OnCreate(platformId, num, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("platformId", platformId)
  self.sfsObj:PutInt("num", num)
  self.sfsObj:PutInt("index", index)
end

function AllianceTrainThumbsUpMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:OnAllianceTrainThumbsUp(message)
end

return AllianceTrainThumbsUpMessage
