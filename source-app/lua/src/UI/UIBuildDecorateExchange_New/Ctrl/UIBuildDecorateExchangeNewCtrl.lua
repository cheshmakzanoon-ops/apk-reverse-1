local UIBuildDecorateExchangeNewCtrl = BaseClass("UIBuildDecorateExchangeNewCtrl", UIBaseCtrl)

function UIBuildDecorateExchangeNewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildDecorateExchangeNew)
end

function UIBuildDecorateExchangeNewCtrl:GetNeedDecorationItemCountToMaxLevel(baseBuildingId)
  local baseBuildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
  if baseBuildTemplate == nil then
    return 0
  end
  local curLevel = 0
  local totalNeedCount = 0
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
  if buildData then
    if buildData.level >= baseBuildTemplate.max_level then
      return 0
    else
      curLevel = buildData.level
    end
  end
  local levelTmp = curLevel
  while levelTmp < baseBuildTemplate.max_level do
    if levelTmp == 0 then
      totalNeedCount = totalNeedCount + 1
    else
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, levelTmp)
      if levelTemplate then
        local needCount = tonumber(levelTemplate.para2) or 0
        totalNeedCount = totalNeedCount + needCount
      end
    end
    levelTmp = levelTmp + 1
  end
  local haveNum = 0
  local curBuildItemCount = BuildingUtils.GetDecorateCountByLevel(baseBuildingId, 1)
  if buildData then
    local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, curLevel)
    if curLevelTemplate then
      if curLevelTemplate.decorationUpgradeType == DecorationUpgradeType.AdvanceUpgrade then
        local prodStatus = buildData.prodStatus or 0
        haveNum = curBuildItemCount + prodStatus
      else
        haveNum = curBuildItemCount
      end
    end
  end
  return math.max(totalNeedCount - haveNum, 0)
end

function UIBuildDecorateExchangeNewCtrl:IsOverMaxFunctionOn()
  return LuaEntry.DataConfig:CheckSwitch("decoration_limit_up")
end

return UIBuildDecorateExchangeNewCtrl
