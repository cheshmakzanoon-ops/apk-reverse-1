local DominatorUtils = BaseClass("DominatorUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local Localization = CS.GameEntry.Localization
local EventManagerIns = EventManager:GetInstance()

function DominatorUtils.GetUsingDominatorSquad(dataType, dominatorUuid)
  if dataType == nil or dominatorUuid == nil then
    return nil
  end
  local squads = ArmyFormationUtils.GetAllArmyFormationData(dataType)
  for i, squadData in pairs(squads) do
    if squadData:GetLocalDominatorUuid() == dominatorUuid then
      return squadData, ArmyFormationUtils.GetArmyFormationOrderByIndex(dataType, squadData.index, squadData)
    end
  end
  return nil
end

function DominatorUtils.SetSquadUseDominator(source, idx, dominatorUuid, squadData)
  if source == nil or idx == nil or dominatorUuid == nil then
    return
  end
  local _squadData, dataType = ArmyFormationUtils.GetArmyFormationDataByEnterWay(source, idx)
  if _squadData == nil then
    if squadData == nil then
      return
    end
    _squadData = squadData
  end
  if ArmyFormationUtils.ExclusiveFormationTypes[dataType] then
    local otherSquadData, otherIdx = DominatorUtils.GetUsingDominatorSquad(dataType, dominatorUuid)
    if otherSquadData ~= nil and otherIdx ~= idx then
      if not otherSquadData:IsFree() then
        UIUtil.ShowTipsId("dominator_change_desc_5")
        return
      end
      if dataType == FormationDataType.TruckDeparture then
        local busyFormationList = DataCenter.LWMyStationDataManager:GetBusyDefenceFormationIndexList()
        if busyFormationList and busyFormationList[otherIdx] then
          UIUtil.ShowTipsId("120211")
          return
        end
      end
      do
        local usingFormation = otherIdx
        local prevUsingDominatorUuid = _squadData:GetLocalDominatorUuid()
        UIUtil.ShowMessage(Localization:GetString("dominator_squad_switch_warning", usingFormation), 1, "110006", nil, function()
          _squadData:SetLocalDominator(dominatorUuid)
          if prevUsingDominatorUuid then
            otherSquadData:SetLocalDominator(prevUsingDominatorUuid)
          else
            otherSquadData:UnsetLocalDominator()
          end
          if dataType == FormationDataType.ArmyFormation then
            local curHeroes = otherSquadData:GenerateServerHeroArray()
            local usingChipSetId = otherSquadData:GetLocalTWSkillChipSetId()
            SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, otherSquadData.uuid, curHeroes, 0, usingChipSetId)
          elseif dataType == FormationDataType.TruckDeparture then
            DataCenter.LWMyStationDataManager:TrySaveTruckFormation(otherSquadData)
          end
          EventManagerIns:Broadcast(EventId.DominatorFormationUpdate, _squadData.uuid)
        end, nil, nil)
        return
      end
    end
  end
  _squadData:SetLocalDominator(dominatorUuid)
  EventManagerIns:Broadcast(EventId.DominatorFormationUpdate, _squadData.uuid)
end

function DominatorUtils.UnsetSquadUseDominator(source, idx, squadData)
  if source == nil or idx == nil then
    return
  end
  local _squadData = ArmyFormationUtils.GetArmyFormationDataByEnterWay(source, idx)
  if _squadData == nil then
    if squadData == nil then
      return
    end
    _squadData = squadData
  end
  _squadData:UnsetLocalDominator()
  EventManagerIns:Broadcast(EventId.DominatorFormationUpdate, _squadData.uuid)
end

function DominatorUtils.GetSquadUseDominator(source, idx, squadData)
  if source == nil or idx == nil then
    return nil
  end
  local _squadData = ArmyFormationUtils.GetArmyFormationDataByEnterWay(source, idx)
  if _squadData == nil then
    if squadData == nil then
      return nil
    end
    _squadData = squadData
  end
  return _squadData:GetLocalDominatorUuid()
end

function DominatorUtils.DominatorIdToHeroInfo(dominatorId, rankLv)
  local heroInfo
  local dominatorId = dominatorId
  local dominatorTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateById(dominatorId)
  if dominatorTemplate then
    local heroTemplate = dominatorTemplate:GetHeroTemplate()
    if heroTemplate then
      heroInfo = {}
      heroInfo.heroId = heroTemplate.id
      heroInfo.meta = heroTemplate
      heroInfo.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(DataCenter.DominatorTemplateManager:GetAppearanceId(dominatorId, rankLv))
    end
  end
  return heroInfo
end

function DominatorUtils.GetBattleDominatorInfos(source, squadData)
  local dataType = ArmyFormationUtils.GetDataTypeByEnterWay(source)
  local dominatorList
  if source == EnterHeroSquadPanelWay.DetectEventPVE or source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    dominatorList = DataCenter.DominatorManager:GetUnlockBattleDominatorsForTrial()
  else
    dominatorList = DataCenter.DominatorManager:GetUnlockBattleDominators()
  end
  local dominatorInfos = {}
  for i, dominatorInfo in ipairs(dominatorList) do
    local uuid = dominatorInfo.uuid
    local usingSquadIdx
    if ArmyFormationUtils.ExclusiveFormationTypes[dataType] then
      local usingSquadData, usingIdx = DominatorUtils.GetUsingDominatorSquad(dataType, uuid)
      if usingSquadData then
        usingSquadIdx = usingIdx
      end
    elseif squadData and squadData:GetLocalDominatorUuid() == uuid then
      usingSquadIdx = squadData.index
    end
    table.insert(dominatorInfos, {
      uuid = uuid,
      usingSquadIdx = usingSquadIdx,
      dominatorInfo = dominatorInfo
    })
  end
  return dominatorInfos
end

function DominatorUtils.CheckFunctionOnLimitData(limitData)
  if not limitData then
    return false
  end
  local mainLv = DataCenter.BuildManager.MainLv or 0
  if mainLv >= limitData.mainLv then
    local seasonNum = SeasonUtil.GetSeason()
    if seasonNum > limitData.seasonNum then
      return true
    elseif seasonNum < limitData.seasonNum then
      return false
    end
    return limitData.seasonDay <= SeasonUtil.GetSeasonDayByOpenServerZero()
  end
  return false
end

return DominatorUtils
