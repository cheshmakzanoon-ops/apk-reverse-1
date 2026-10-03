local TCActiveSkillData = require("DataCenter.TacticalCardManager.Skill.TCActiveSkillData")
local TCActiveFastCollectSkillData = BaseClass("TCActiveFastCollectSkillData", TCActiveSkillData)
local base = TCActiveSkillData

local function __init(self)
  base.__init(self)
  self.canCollectResourceTypeDic = nil
end

local function __delete(self)
  base.__delete(self)
  self.canCollectResourceTypeDic = nil
end

function TCActiveFastCollectSkillData:CheckUsePosition(castSkillParams)
  if not castSkillParams then
    return false
  end
  local isBasePass = base.CheckUsePosition(self, castSkillParams)
  if not isBasePass then
    return false
  end
  local pointId = castSkillParams.pointId
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if not pointInfo then
    return false
  end
  if not self.canCollectResourceTypeDic and self.template then
    local canCollectInfo = self.template.effect_para1
    if canCollectInfo then
      self.canCollectResourceTypeDic = {}
      for _, v in pairs(canCollectInfo) do
        local resourceType = tonumber(v)
        self.canCollectResourceTypeDic[resourceType] = true
      end
    end
  end
  local pointType = pointInfo.PointType
  local targetPointResType
  if pointType == WorldPointType.WorldResource then
    local cfgId = pointInfo.id
    targetPointResType = GetTableData(TableName.GatherResource, cfgId, "resource_type")
  elseif pointType == WorldPointType.WorldAllianceCollectResource then
    local cfgId = pointInfo.configId
    targetPointResType = GetTableData(TableName.AllianceMine, cfgId, "resource_type")
  end
  targetPointResType = targetPointResType and tonumber(targetPointResType)
  if not targetPointResType then
    Logger.LogError(string.format("TCActiveFastCollectSkillData:CheckUsePosition targetPointResType is nil, pointType: %s, pointId: %s", tostring(pointType), tostring(pointId)))
    return false
  end
  local isContainTargetResType = self.canCollectResourceTypeDic[targetPointResType]
  return isContainTargetResType
end

TCActiveFastCollectSkillData.__init = __init
TCActiveFastCollectSkillData.__delete = __delete
return TCActiveFastCollectSkillData
