local StageFeatureIntegratedResetMessage = BaseClass("StageFeatureIntegratedResetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function StageFeatureIntegratedResetMessage:OnCreate(diff, configId)
  base.OnCreate(self)
  local mgr = DataCenter.LWIntegratedStageFeatureChapterManager
  local chapterCfg = mgr.configIdToChapterCfg[configId]
  if not chapterCfg then
    Logger.LogError(string.format("\233\135\141\231\189\174\229\164\177\232\180\165\239\188\154\230\137\190\228\184\141\229\136\176 configId %d \229\175\185\229\186\148\231\154\132\231\171\160\232\138\130\233\133\141\231\189\174", configId))
    return
  end
  local targetResetChapterStageIds = chapterCfg.stageIds or {}
  local sfsStageIdsArray = SFSArray.New()
  for i, stageId in ipairs(targetResetChapterStageIds) do
    sfsStageIdsArray:AddInt(stageId)
  end
  self.sfsObj:PutSFSArray("ids", sfsStageIdsArray)
  self.sfsObj:PutInt("stageType", diff)
end

function StageFeatureIntegratedResetMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWIntegratedStageFeatureChapterManager:UpdateDataFromReset(message)
end

return StageFeatureIntegratedResetMessage
