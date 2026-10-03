local TCBaseSkillData = require("DataCenter.TacticalCardManager.Skill.TCBaseSkillData")
local TCActiveSkillData = BaseClass("TCActiveSkillData", TCBaseSkillData)
local TCSkillChargeData = require("DataCenter.TacticalCardManager.Skill.TCSkillChargeData")
local base = TCBaseSkillData

local function __init(self)
  base.__init(self)
  self.usePosDic = nil
end

local function __delete(self)
  base.__delete(self)
  self.usePosDic = nil
end

function TCActiveSkillData:UpdateData(skillId, serverData)
  base.UpdateData(self, skillId, serverData)
  self:UpdateChargeInfo(serverData)
end

function TCActiveSkillData:UpdateChargeInfo(serverData)
  local params = {}
  params.num = serverData and serverData.remainTimes or self.template.cd_max_times
  params.max = self.template.cd_max_times or -1
  params.cdValue = self.template.cd_time
  params.type = self.template.cd_type
  params.lastTime = serverData and serverData.lastUpdateTime or 0
  params.recoverFullTime = serverData and serverData.cdTime
  if not self.chargeData then
    self.chargeData = TCSkillChargeData.New()
  end
  self.chargeData:UpdateData(params)
end

function TCActiveSkillData:GetChargeData()
  return self.chargeData
end

function TCActiveSkillData:CheckIsCanCastInCurBattleField()
  local isInAnyBattleField = BattleFieldUtil.InBattleField()
  if not isInAnyBattleField then
    return true
  end
  if not self.template then
    return false
  end
  local isCanCastInBF = self.template.battlefield == 2
  return isCanCastInBF
end

function TCActiveSkillData:CheckUsePosition(castSkillParams)
  if castSkillParams and type(castSkillParams) ~= "table" then
    Logger.LogError("castSkillParams type is error!")
    local tmpUsePos = castSkillParams
    castSkillParams = {}
    castSkillParams.usePos = tmpUsePos
  end
  if not castSkillParams or not castSkillParams.usePos then
    return true
  end
  if not self.template then
    return false
  end
  local usePosCfgDic = self.template.use_positionDic
  if not usePosCfgDic then
    return false
  end
  local usePos = castSkillParams.usePos
  return usePosCfgDic[usePos]
end

function TCActiveSkillData:CheckMarchType(marchType)
  if not self.template then
    return true
  end
  if self.template.march_place and #self.template.march_place > 0 then
    for i, v in ipairs(self.template.march_place) do
      if marchType == v then
        return true
      end
    end
    return false
  end
  return true
end

function TCActiveSkillData:GetCastSkillState(castSkillParams)
  if not self:CheckIsCanCastInCurBattleField() then
    return TCCardSkillState.NotUseInBattleField
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local cdOverTime = self.chargeData:GetAvailableTime()
  if curTime < cdOverTime then
    return TCCardSkillState.CD
  end
  if not self:CheckUsePosition(castSkillParams) then
    return TCCardSkillState.NotUseInCurPos
  end
  if not self.skillId or self.skillId <= 0 then
    Logger.LogError("TCActiveSkillData:GetCastSkillState \230\138\128\232\131\189id\233\148\153\232\175\175")
    return TCCardSkillState.None
  end
  if not self.template then
    Logger.LogError("TCActiveSkillData:GetCastSkillState \230\138\128\232\131\189\230\168\161\230\157\191\233\148\153\232\175\175")
    return TCCardSkillState.None
  end
  if self.chargeData == nil then
    Logger.LogError("TCActiveSkillData:GetCastSkillState \230\138\128\232\131\189\229\133\133\232\131\189\230\149\176\230\141\174\233\148\153\232\175\175")
    return TCCardSkillState.None
  end
  return TCCardSkillState.Normal
end

function TCActiveSkillData:GetSkillCdOverTime()
  if not self.chargeData then
    return 0
  end
  return self.chargeData:GetAvailableTime()
end

function TCActiveSkillData:GetSkillCdTime()
  if not self.chargeData then
    return 1
  end
  return self.chargeData:GetOnceCD()
end

function TCActiveSkillData:GetSkillResidueCount()
  if not self.chargeData then
    return 0
  end
  return self.chargeData:GetCurChargeCount()
end

TCActiveSkillData.__init = __init
TCActiveSkillData.__delete = __delete
return TCActiveSkillData
