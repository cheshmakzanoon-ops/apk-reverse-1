local AllianceTrainThumbsUpListMessage = BaseClass("AllianceTrainThumbsUpListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainThumbsUpListMessage:OnCreate(platformId, onlyList)
  base.OnCreate(self)
  self.sfsObj:PutInt("platformId", platformId)
  self.sfsObj:PutBool("onlyList", onlyList)
end

function AllianceTrainThumbsUpListMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:OnAllianceTrainThumbsUpList(message)
end

return AllianceTrainThumbsUpListMessage
