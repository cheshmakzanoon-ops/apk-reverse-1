local StageFeatureIntegratedRecordMessage = BaseClass("StageFeatureIntegratedRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureIntegratedRecordMessage:OnCreate(stageId, restSoilders, difficulty)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", stageId)
  self.sfsObj:PutInt("soldier", restSoilders)
  self.sfsObj:PutInt("stageType", difficulty)
end

function StageFeatureIntegratedRecordMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  local difficulty = message.stageType
  if not difficulty or difficulty <= StageFeatureIntegratedDifficulty.Normal then
    return
  end
  local id = message.id
  local totalCount = message.totalSoldier
  if id then
    EventManager:GetInstance():Broadcast(EventId.StageFeatureIntegratedWinCheckUploadGameCenterData, {stageId = id, remainMemberCount = totalCount})
  end
end

return StageFeatureIntegratedRecordMessage
