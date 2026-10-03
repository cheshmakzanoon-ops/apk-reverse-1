local StageFeatureChapterRecordMessage = BaseClass("StageFeatureChapterRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureChapterRecordMessage:OnCreate(stageId, restSoilders)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", stageId)
  self.sfsObj:PutInt("soldier", restSoilders)
end

function StageFeatureChapterRecordMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  local id = message.id
  local totalCount = message.totalSoldier
  if id then
    EventManager:GetInstance():Broadcast(EventId.StageFeatureChapterWinCheckUploadGameCenterData, {stageId = id, remainMemberCount = totalCount})
  end
end

return StageFeatureChapterRecordMessage
