local LWCityPerformNpcUtil = BaseClass("LWCityPerformNpcUtil")
local PerformData = require("Scene.LWCityPerformNpc.DataBase.PerformData")
local Const = require("Scene.LWCityPerformNpc.Const")
local entryArmyPath = "ModelGo/point/p_entry_army"
local effectNodeName = "/VFX_animal_grow"
local Localization = CS.GameEntry.Localization

function LWCityPerformNpcUtil:GetBulidEntryArmyPos(buildData)
  if not buildData then
    return Vector3.New(0, 0, 0)
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  if cityObj then
    return cityObj.gameObject.transform:Find(entryArmyPath).position
  end
  return Vector3.New(0, 0, 0)
end

function LWCityPerformNpcUtil:MilitaryCampCollectSolder(buildUid, soldierId, count)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUid)
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  local armyYard = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ARMY_YARD)
  if not armyYard or buildUid == armyYard.uuid then
    return
  end
  UIUtil.ShowTips(Localization:GetString("barrack_training_complete", count, soldierTemplate.lv))
  local data = PerformData:New()
  local model = soldierTemplate.model
  if T11Util.CheckSuperSoldierByTmp(soldierTemplate) then
    model = T11Util.GetPlayerSelfT11SoldierPerformModelPath(soldierTemplate) or soldierTemplate.model
  end
  data:InitData(self:GetBulidEntryArmyPos(buildData), self:GetBulidEntryArmyPos(armyYard), model)
  
  function data.arriveCallBack()
    self:DrillGroundPlayeEffect()
  end
  
  local showCount = 0
  count = math.ceil(count / 10)
  showCount = count < Const.militaryCampMaxCount and count or Const.militaryCampMaxCount
  DataCenter.LWCityPerformNpcManager:CreateTeamModel(data, showCount, Const.createTime)
end

function LWCityPerformNpcUtil:HospitalCollectSolder(buildUid, resetSoldierInfos)
  if #resetSoldierInfos < 1 then
    return
  end
  if 1 < #resetSoldierInfos then
    table.sort(resetSoldierInfos, function(a, b)
      return a.id > b.id
    end)
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUid)
  local armyYard = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ARMY_YARD)
  local maxCount = Const.hospitalMaxCount
  local performDataList = {}
  local number = 0
  local tempCount = 0
  for i = 1, #resetSoldierInfos do
    if 0 < maxCount then
      number = maxCount
      tempCount = math.ceil(resetSoldierInfos[i].count / 10)
      maxCount = maxCount - tempCount
      if maxCount < 0 then
        resetSoldierInfos[i].count = number
      else
        number = tempCount
      end
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(resetSoldierInfos[i].id)
      local model = soldierTemplate.model
      if T11Util.CheckSuperSoldierByTmp(soldierTemplate) then
        model = T11Util.GetPlayerSelfT11SoldierPerformModelPath(soldierTemplate) or soldierTemplate.model
      end
      for i = 1, number do
        local data = PerformData:New()
        data:InitData(self:GetBulidEntryArmyPos(buildData), self:GetBulidEntryArmyPos(armyYard), model)
        
        function data.arriveCallBack()
          self:DrillGroundPlayeEffect()
        end
        
        table.insert(performDataList, data)
      end
    end
  end
  DataCenter.LWCityPerformNpcManager:CreateQueueNpc(Const.createTime, performDataList)
end

function LWCityPerformNpcUtil:DrillGroundPlayeEffect()
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ARMY_YARD)
  if buildData and not IsNull(CS.SceneManager.World) then
    local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
    if IsNull(cityObj) then
      return
    end
    local effectObj = cityObj.gameObject.transform:Find(entryArmyPath .. effectNodeName)
    if not IsNull(effectObj) then
      effectObj.gameObject:SetActive(true)
      TimerManager:GetInstance():DelayInvoke(function()
        if IsNotNull(effectObj) then
          effectObj.gameObject:SetActive(false)
        end
      end, 0.3)
    else
      Logger.LogError("effectObj is nil objName : " .. cityObj.gameObject.name)
    end
    local modelObj = cityObj.gameObject.transform:Find("ModelGo")
    if IsNull(modelObj) then
      Logger.LogError("modelObj is nil objName : " .. cityObj.gameObject.name)
    end
    local simAnim = modelObj:GetComponent(typeof(CS.SimpleAnimation))
    if simAnim then
      if simAnim:IsPlaying("joggle") then
        simAnim:Rewind("joggle")
      else
        simAnim:Play("joggle")
      end
    end
  end
end

return LWCityPerformNpcUtil
