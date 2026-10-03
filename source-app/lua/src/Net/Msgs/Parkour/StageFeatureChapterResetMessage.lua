local StageFeatureChapterResetMessage = BaseClass("StageFeatureChapterResetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureChapterResetMessage:OnCreate(resetChapterId)
  base.OnCreate(self)
  local targetResetChapterCfgData = DataCenter.LWStageFeatureChapterManager:GetChapterCfgData(resetChapterId)
  local targetResetChapterStageIds = targetResetChapterCfgData and targetResetChapterCfgData.stageIds or {}
  local sfsStageIdsArray = SFSArray.New()
  for i, stageId in ipairs(targetResetChapterStageIds) do
    sfsStageIdsArray:AddInt(stageId)
  end
  self.sfsObj:PutSFSArray("ids", sfsStageIdsArray)
end

function StageFeatureChapterResetMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWStageFeatureChapterManager:UpdateDataFromReset(message)
end

return StageFeatureChapterResetMessage
