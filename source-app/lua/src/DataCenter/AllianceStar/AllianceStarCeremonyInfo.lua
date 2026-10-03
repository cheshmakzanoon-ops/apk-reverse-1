local AllianceStarCeremonyInfo = BaseClass("AllianceStarCeremonyInfo")

function AllianceStarCeremonyInfo:__init()
  self.ceremonyEdition = 0
  self.stateId = nil
  self.startTimeStamp = nil
  self.configId = nil
  self.ceremonyInfoList = {}
  self.roleInfoMap = {}
  self.templateInfo = nil
  self.nominatePlayerInfoList = {}
  self.targetStageId = nil
end

function AllianceStarCeremonyInfo:__delete()
  self.ceremonyEdition = nil
  self.stateId = nil
  self.startTimeStamp = nil
  self.configId = nil
  self.ceremonyInfoList = nil
  self.roleInfoMap = nil
  self.templateInfo = nil
  self.nominatePlayerInfoList = nil
  self.targetStageId = nil
end

function AllianceStarCeremonyInfo:ParseData(msg)
  self.ceremonyEdition = msg.ceremonyEdition
  self.stateId = msg.stateId
  self.startTimeStamp = msg.startTimeStamp
  self.configId = msg.configId
  self.ceremonyInfoList = msg.ceremonyInfoList
  self.roleInfoMap = msg.roleInfoMap
  self.nominatePlayerInfoList = self:InitNominatePlayerInfoList()
  self.targetStageId = msg.targetStageId
end

function AllianceStarCeremonyInfo:GetTemplateInfo()
  if self.configId then
    self.templateInfo = DataCenter.AllianceStarManager:GetAlStarTemplateInfo(self.configId)
  else
    self.templateInfo = nil
  end
  return self.templateInfo
end

function AllianceStarCeremonyInfo:GetStarPlayerInfo()
  local playerInfo
  if self.ceremonyInfoList and #self.ceremonyInfoList > 0 and self.roleInfoMap then
    for i, v in ipairs(self.ceremonyInfoList) do
      if v.isStar then
        playerInfo = self.roleInfoMap[v.uid]
        break
      end
    end
  end
  return playerInfo
end

function AllianceStarCeremonyInfo:GetStarPlayerScore()
  local score = 0
  if self.ceremonyInfoList and 0 < #self.ceremonyInfoList then
    for i, v in ipairs(self.ceremonyInfoList) do
      if v.isStar then
        score = v.score
        break
      end
    end
  end
  return score
end

function AllianceStarCeremonyInfo:InitNominatePlayerInfoList()
  local nominatePlayerInfoList = {}
  if self.ceremonyInfoList and #self.ceremonyInfoList > 0 then
    for i, v in ipairs(self.ceremonyInfoList) do
      table.insert(nominatePlayerInfoList, self.roleInfoMap[v.uid])
    end
    for i = 1, #nominatePlayerInfoList do
      local j = math.random(1, #nominatePlayerInfoList)
      nominatePlayerInfoList[i], nominatePlayerInfoList[j] = nominatePlayerInfoList[j], nominatePlayerInfoList[i]
    end
  end
  return nominatePlayerInfoList
end

function AllianceStarCeremonyInfo:GetNominatePlayerInfoList()
  return self.nominatePlayerInfoList
end

return AllianceStarCeremonyInfo
