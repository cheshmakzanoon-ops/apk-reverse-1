local AllianceGovernmentCommonSkill = BaseClass("AllianceGovernmentCommonSkill")
local FactoryAllianceGovernmentCommonSkill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.FactoryAllianceGovernmentCommonSkill")

function AllianceGovernmentCommonSkill:__init()
  self.skillId = 0
  self.state = 0
  self.coolOverTime = 0
  self.leftUseTime = -1
  self.lock = true
  self.logic = nil
  self.config = nil
  self.scoreConfig = nil
  self.user = nil
end

function AllianceGovernmentCommonSkill:__delete()
  self.skillId = nil
  self.state = nil
  self.coolOverTime = nil
  self.leftUseTime = nil
  self.lock = nil
  self.logic = nil
  self.config = nil
  self.scoreConfig = nil
  self.user = nil
end

function AllianceGovernmentCommonSkill:ParseServer(message)
  self.state = message.state
  self.coolOverTime = message.coolOverTime
  self.leftUseTime = message.leftUseTime
  self.lock = false
end

function AllianceGovernmentCommonSkill:BindOfficial(user)
  local newUser = user[self.config.type]
  if newUser ~= nil and self.user ~= newUser.user then
    self.user = newUser.user
    return true
  end
  return false
end

function AllianceGovernmentCommonSkill:BindSkillId(skillId)
  self.skillId = skillId
  self.config = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(self.skillId)
  if self.logic == nil then
    self.logic = FactoryAllianceGovernmentCommonSkill.GetSkillLogic(self)
  end
  if self.config ~= nil then
    local skillScore = self.config.skill_score
    LocalController:instance():visitTable(TableName.AllianceGovernmentSkillScore, function(id, lineData)
      if lineData.type == skillScore then
        self.scoreConfig = lineData
        return true
      end
    end)
  end
end

function AllianceGovernmentCommonSkill:Clear()
  self.state = 0
  self.coolOverTime = 0
  self.leftUseTime = -1
  self.lock = true
end

function AllianceGovernmentCommonSkill:InCd()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return self.state == 1 and serverTime < self.coolOverTime
end

function AllianceGovernmentCommonSkill:GetCD()
  if self.coolOverTime > 0 then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    return self.coolOverTime - serverTime
  end
  return 0
end

function AllianceGovernmentCommonSkill:IsEnoughEnergy()
  local cost = self.config.consume_energy
  local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  return cost <= energy.currentEnergy
end

function AllianceGovernmentCommonSkill:ToUse()
  if self.logic ~= nil then
    self.logic:DoPreUse()
  end
end

function AllianceGovernmentCommonSkill:UseSkill(pointId, worldId, targetUuid)
  if self.logic ~= nil then
    self.logic:BindParam(pointId, worldId, targetUuid)
    self.logic:Use()
  end
end

function AllianceGovernmentCommonSkill:IsLock()
  return self.lock
end

function AllianceGovernmentCommonSkill:GetUser()
  return self.user
end

function AllianceGovernmentCommonSkill:GetLogic()
  return self.logic
end

return AllianceGovernmentCommonSkill
