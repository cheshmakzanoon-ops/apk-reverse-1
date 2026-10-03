local AllianceStarCeremonyProgressCtrl = BaseClass("AllianceStarCeremonyProgressCtrl")

function AllianceStarCeremonyProgressCtrl:__init(scene)
  self.scene = scene
  self.fullData = {}
  self.stageId = 0
end

function AllianceStarCeremonyProgressCtrl:__delete()
  self.scene = nil
  self.fullData = nil
  self.startInfo = nil
  self.endInfo = nil
  self.stageId = nil
  self.enterTime = nil
end

function AllianceStarCeremonyProgressCtrl:OnEnter()
  local allyDict = {}
  allyDict.participants_info = {}
  for i = 1, 20 do
    local playerInfo = {}
    playerInfo.uid = tostring(i)
    table.insert(allyDict.participants_info, playerInfo)
  end
  self.scene.manager:CreateAllyDict(allyDict)
  self.fullData = self.scene.manager:GetCeremonyFullData()
  if self.enterTime == nil then
    self.enterTime = tonumber(CommonUtil.PlayerPrefsGetString(SettingKeys.AL_STAR_ENTER_CEREMONY, "0"))
  end
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local todayFirst = UITimeManager:GetInstance():IsSameDayForServer(self.enterTime, now)
  local stageId = 1
  if todayFirst then
    CommonUtil.PlayerPrefsSetString(SettingKeys.AL_STAR_ENTER_CEREMONY, now)
    stageId = 0
  end
  self:ChangeStage(1)
end

function AllianceStarCeremonyProgressCtrl:GetEndInfo()
  if self.startInfo == nil then
    self.startInfo = {}
    self.startInfo.ceremonyEdition = self.fullData.ceremonyEdition
    self.startInfo.stateId = AlStarCeremonyState.Finish
  end
  self.startInfo.targetStageId = 1
  return self.startInfo
end

function AllianceStarCeremonyProgressCtrl:GetRewardStageInfo(stageId)
  local info = self.fullData.ceremonyInfo[stageId]
  info.ceremonyEdition = self.fullData.ceremonyEdition
  info.stateId = AlStarCeremonyState.ReadPersonReward
  info.roleInfoMap = self.fullData.roleInfoMap
  info.targetStageId = 1
  return info
end

function AllianceStarCeremonyProgressCtrl:ChangeStage(stageId)
  stageId = Mathf.Clamp(stageId, 1, #self.fullData.ceremonyInfo + 1)
  local stageInfo
  if stageId > #self.fullData.ceremonyInfo then
    stageInfo = self:GetEndInfo()
  else
    stageInfo = self:GetRewardStageInfo(stageId)
  end
  if self.stageId ~= stageId then
    self.stageId = stageId
    self.scene.manager:RefreshCeremonyInfo(stageInfo)
  end
end

function AllianceStarCeremonyProgressCtrl:ChangeCtrlStage(isNext)
  if isNext then
    self:ChangeStage(self.stageId + 1)
  else
    self:ChangeStage(self.stageId - 1)
  end
end

function AllianceStarCeremonyProgressCtrl:GetStageId()
  return self.stageId
end

function AllianceStarCeremonyProgressCtrl:ChangeCurStageInnerStage(innerStageId)
  local stageId = self.stageId
  local stageInfo
  if stageId > #self.fullData.ceremonyInfo then
    stageInfo = self:GetEndInfo()
  else
    stageInfo = self:GetRewardStageInfo(stageId)
  end
  stageInfo.targetStageId = innerStageId
  self.scene.manager:RefreshCeremonyInfo(stageInfo)
end

return AllianceStarCeremonyProgressCtrl
