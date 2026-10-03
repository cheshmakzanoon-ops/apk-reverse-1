local AllianceStarAllyInfo = BaseClass("AllianceStarAllyInfo")

function AllianceStarAllyInfo:__init()
  self.ally = nil
  self.uid = nil
  self.playerInfo = nil
end

function AllianceStarAllyInfo:__delete()
  self.ally = nil
  self.uid = nil
  self.playerInfo = nil
end

function AllianceStarAllyInfo:ParseData(playerInfo)
  self.uid = playerInfo.uid
  self.playerInfo = playerInfo
end

function AllianceStarAllyInfo:SetAlly(ally)
  self.ally = ally
end

function AllianceStarAllyInfo:GetAlly()
  return self.ally
end

return AllianceStarAllyInfo
