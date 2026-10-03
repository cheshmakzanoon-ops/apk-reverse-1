local UIWorldMarchDetailCtrl = BaseClass("UIWorldMarchDetailCtrl", UIBaseCtrl)
local Data = CS.GameEntry.Data
local Localization = CS.GameEntry.Localization

function UIWorldMarchDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldMarchDetail)
end

function UIWorldMarchDetailCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIWorldMarchDetailCtrl:GetFormationPowerByUuid(formationUuid)
  local totalPower = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalPower = MarchUtil.GetFormationPower(formation.heroes, formation.soldiers, formation.index, MarchUtil.GetCampAddParam(formation.heroes))
  end
  return totalPower
end

function UIWorldMarchDetailCtrl:GetCurSoldierNum(formationUuid)
  local totalNum = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    table.walk(formation.soldiers, function(k, v)
      if 0 < v then
        totalNum = totalNum + v
      end
    end)
  end
  return totalNum
end

function UIWorldMarchDetailCtrl:GetMarchData(marchUuid, formationUuid)
  local oneData = {}
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  local Player = LuaEntry.Player
  if formation ~= nil then
    oneData.formationUuid = formation.uuid
    oneData.index = formation.index
    oneData.power = self:GetFormationPowerByUuid(formation.uuid)
    oneData.curSoldierNum = self:GetCurSoldierNum(formation.uuid)
    oneData.heroDataList = {}
    local heroData = formation.heroes
    if heroData ~= nil and table.count(heroData) > 0 then
      table.walksort(heroData, function(leftKey, rightKey)
        return heroData[leftKey] < heroData[rightKey]
      end, function(k, v)
        if k ~= nil then
          local heroOneData = {}
          heroOneData.heroUuid = k
          table.insert(oneData.heroDataList, heroOneData)
        end
      end)
    end
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, formation.uuid, Player.allianceId)
    if march ~= nil then
      oneData.status = march:GetMarchStatus()
      oneData.targetType = march:GetMarchTargetType()
      oneData.marchUuid = march.uuid
      oneData.targetUuid = march.targetUuid
      oneData.startTime = march.startTime
      oneData.endTime = march.endTime
      return oneData
    end
  end
end

function UIWorldMarchDetailCtrl:GetInWormHoleMarch()
  local list = {}
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
  for _, march in pairs(selfMarch) do
    if march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.CROSS_SERVER or march:GetMarchTargetType() == MarchTargetType.CROSS_SERVER_WORM or march:GetMarchTargetType() == MarchTargetType.GO_WORM_HOLE then
      table.insert(list, march)
    end
  end
  return list
end

return UIWorldMarchDetailCtrl
