local UIBuildListCtrl = BaseClass("UIBuildListCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, isDoAnim)
  if isDoAnim then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildList)
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildList, {})
  end
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetShowData(self, robotQueueIndex)
  self.robotQueueIndex = robotQueueIndex
  local robotId = DataCenter.BuildQueueTemplateManager:GetBuildQueueIdByIndex(robotQueueIndex)
  if robotId == nil or robotId <= 0 then
    return nil
  end
  local param = {}
  param.buildFlag = true
  param.scienceFlag = true
  param.farmFlag = self:GetShowFarm()
  param.factoryFlat = self:GetShowFactory()
  local nameStr = Localization:GetString(GetTableData(TableName.Robot, robotId, "name"))
  param.desc = Localization:GetString("121200", nameStr)
  return param
end

local function DoWhenClickBuild(self, robotQueueIndex)
  local main = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if main == nil or main.View == nil then
    return false
  end
  local isSeason = DataCenter.BuildQueueTemplateManager:IsSeasonRobotByIndex(robotQueueIndex or 0)
  local canBuildList = main.View:GetMainFastBuildListData()
  if canBuildList == nil or table.count(canBuildList) == 0 then
    canBuildList = DataCenter.BuildManager:GetFastBuildDataList(isSeason)
  end
  local lackResourceBuildId
  if canBuildList ~= nil and 0 < table.count(canBuildList) then
    for k, v in ipairs(canBuildList) do
      local state = DataCenter.BuildManager:GetBuildState(v.id)
      if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_RECEIVED then
        GoToUtil.GotoFastBuildList(v.id)
        self:CloseSelf()
        return true
      end
      if lackResourceBuildId == nil and state == BuildState.BUILD_LIST_LACK_PEOPLE then
        lackResourceBuildId = v.id
      end
      if lackResourceBuildId == nil and state == BuildState.BUILD_LIST_LACK_RESOURCE then
        lackResourceBuildId = v.id
      end
    end
  end
  local buildList1 = DataCenter.BuildManager:GetCanUpgradeBuildUuidList(false, isSeason)
  if buildList1 ~= nil and 0 < table.count(buildList1) then
    local buildData = buildList1[1]
    GoToUtil.GotoCityByBuildUuid(buildData, WorldTileBtnType.City_Upgrade)
    self:CloseSelf()
    return true
  end
  if lackResourceBuildId ~= nil then
    GoToUtil.GotoFastBuildList(lackResourceBuildId)
    self:CloseSelf()
    return true
  end
  local buildList2 = DataCenter.BuildManager:GetCanUpgradeBuildUuidList(true, isSeason)
  local lowestBuild
  local currentLowestLv = IntMaxValue
  if buildList2 ~= nil and 0 < table.count(buildList2) then
    table.walk(buildList2, function(_, v)
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
      if buildData.level < currentLowestLv then
        lowestBuild = v
      end
    end)
  end
  if lowestBuild ~= nil then
    GoToUtil.GotoCityByBuildUuid(lowestBuild, WorldTileBtnType.City_Upgrade)
    self:CloseSelf()
    return true
  end
  return false
end

local function DoWhenClickScience(self)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_SCIENE)
  if buildData == nil or buildData.state == BuildingStateType.FoldUp then
    return
  end
  local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(buildData.uuid)
  if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SCIENE, WorldTileBtnType.City_SpeedUpScience)
    self:CloseSelf()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < buildData.updateTime then
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SCIENE, WorldTileBtnType.City_SpeedUp)
    self:CloseSelf()
    return
  end
  local list = DataCenter.TaskManager:GetAllMainTask()
  if list ~= nil then
    for k, v in ipairs(list) do
      if v.state == TaskState.NoComplete then
        local template = DataCenter.QuestTemplateManager:GetQuestTemplate(v.id)
        if template ~= nil and tonumber(template.gotype2) == QuestGoType.Science then
          GoToUtil.GoToByQuestId(template)
          self:CloseSelf()
          return
        end
      end
    end
  end
  local allTab = DataCenter.ScienceTemplateManager:GetCurShowTab(ScienceType.Build)
  local gotoScienceId
  for k, v in ipairs(allTab) do
    local tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(v.id)
    if tabLine ~= nil then
      for _, k in ipairs(tabLine) do
        for _, sId in pairs(k) do
          if self:IsUnLockScience(sId) then
            local curLevel = DataCenter.ScienceManager:GetScienceLevel(sId)
            local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(sId)
            if curLevel < maxLevel then
              if gotoScienceId == nil then
                gotoScienceId = sId
              end
              if self:CanScienceUpgrade(sId, curLevel) then
                GoToUtil.GotoScience(sId)
                self:CloseSelf()
                return
              end
            end
          end
        end
      end
    end
  end
  if gotoScienceId ~= nil then
    GoToUtil.GotoScience(gotoScienceId)
    self:CloseSelf()
    return
  end
end

local function CanScienceUpgrade(self, sId, lv)
  local nextScienceTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(sId, lv + 1)
  if nextScienceTemplate == nil then
    return false
  end
  local resources = nextScienceTemplate.needResource
  if resources ~= nil then
    for k1, v1 in ipairs(resources) do
      local own = LuaEntry.Resource:GetCntByResType(v1.resourceType)
      if own < v1.count then
        return false
      end
    end
  end
  local items = nextScienceTemplate.needResourceItem
  if items ~= nil then
    for k1, v1 in ipairs(items) do
      local own = 0
      local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v1.resourceItemId)
      if item ~= nil then
        own = item.number
      end
      if own < v1.count then
        return false
      end
    end
  end
  local items = nextScienceTemplate.needItem
  if items ~= nil then
    for k1, v1 in ipairs(items) do
      local own = 0
      local item = DataCenter.ItemData:GetItemById(v1.itemId)
      if item ~= nil then
        own = item.count
      end
      if own < v1.count then
        return false
      end
    end
  end
  return true
end

local function IsUnLockScience(self, scienceId)
  local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
  if template == nil then
    return false
  end
  local needScience = template.needScience
  if needScience ~= nil then
    for _, v in ipairs(needScience) do
      if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
        return false
      end
    end
  end
  local needBuild = template.needBuild
  if needBuild ~= nil then
    for _, v in ipairs(needBuild) do
      if not DataCenter.BuildManager:HasBuildByIdAndLevel(v.buildId, v.level) then
        return false
      end
    end
  end
  return true
end

local function DoWhenClickFarm(self)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_FARM)
  if buildData == nil or buildData.state == BuildingStateType.FoldUp then
    return
  end
  local bUuid = buildData.uuid
  local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(bUuid, false, false)
  if queue ~= nil then
    local open = LuaEntry.Effect:GetGameEffect(EffectDefine.ROBOT_IN_PASTURE)
    if 0 < open then
      local pastures = {
        BuildingTypes.APS_BUILD_PASTURE_OSTRICH,
        BuildingTypes.APS_BUILD_PASTURE_CATTLE,
        BuildingTypes.APS_BUILD_PASTURE_SANDWORM
      }
      for k, v in ipairs(pastures) do
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v)
        if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
          local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(buildData.uuid, false, false)
          if queue == nil then
            GoToUtil.GotoPastureByUuid(buildData.uuid)
            self:CloseSelf()
            return
          end
        end
      end
      UIUtil.ShowTips(Localization:GetString("121204"))
    else
      local template = DataCenter.ScienceManager:GetScienceTemplate(ScienceId_200193)
      if template ~= nil then
        local str = Localization:GetString("200193", Localization:GetString(template.name))
        UIUtil.ShowMessage(str, 1, "confirm", GameDialogDefine.CANCEL, function()
          GoToUtil.GotoScience(ScienceId_200193)
          self:CloseSelf()
        end)
      end
    end
  else
    GoToUtil.GotoCityByBuildUuid(bUuid, WorldTileBtnType.City_Robot_Set)
    self:CloseSelf()
  end
end

local function DoWhenClickFactory(self)
  for k, v in ipairs(FactoryBuild) do
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v)
    if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
      local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(buildData.uuid, false, false)
      if queue == nil then
        GoToUtil.GotoCityByBuildUuid(buildData.uuid, WorldTileBtnType.City_Robot_Set)
        self:CloseSelf()
        return
      end
    end
  end
  UIUtil.ShowTips(Localization:GetString("121205"))
end

local function GetShowFarm(self)
  local open = LuaEntry.Effect:GetGameEffect(EffectDefine.ROBOT_IN_FARM)
  return open ~= nil and 0 < open
end

local function GetShowFactory(self)
  local open = LuaEntry.Effect:GetGameEffect(EffectDefine.ROBOT_IN_FACTORY)
  return open ~= nil and 0 < open
end

local function GetEffectName(self, effectId)
  local effectName = GetTableData(TableName.EffectNumDesc, effectId, "desc")
  if effectId == EffectDefine.BUILD_SPEED_ADD then
    effectName = "220288"
  elseif effectId == EffectDefine.BUILD_TIME_REDUCE then
    effectName = "220289"
  elseif effectId == EffectDefine.SEASON_BUILD_TIME_REDUCE then
    effectName = GameDialogDefine.SEASON_FREE_TIME_BUILD_NAME
  end
  return Localization:GetString(effectName)
end

local function GetBuffListData(self, isSeason)
  local result = {}
  for i = 1, BuildListBuffType.BuildListBuffType_Max - 1 do
    local effectIdList = self:BuffListType2EffectId(i, isSeason)
    local allNum = 0
    local num = 0
    local param
    for k, v in ipairs(effectIdList) do
      num = LuaEntry.Effect:GetGameEffect(v)
      if num ~= nil and 0 < num then
        allNum = allNum + num
        if param == nil then
          param = {}
          table.insert(result, param)
          param.name = self:GetEffectName(v)
          param.type = i
          param.effectType = GetTableData(TableName.EffectNumDesc, v, "type")
          param.effectId = v
        end
      end
    end
    if param ~= nil then
      param.num = self:GetEffectValueStr(param.effectType, allNum, param.effectId)
    end
  end
  return result
end

local function BuffListType2EffectId(self, type, isSeason)
  local result = {}
  if type == BuildListBuffType.BuildListBuffType_SpeedUp then
    table.insert(result, EffectDefine.BUILD_SPEED_ADD)
  elseif type == BuildListBuffType.BuildListBuffType_Free then
    table.insert(result, EffectDefine.BUILD_TIME_REDUCE)
    if isSeason then
      table.insert(result, EffectDefine.SEASON_BUILD_TIME_REDUCE)
    end
  end
  return result
end

local function GetBuffDetailInfoListData(self, type, isSeason)
  local effectList = self:BuffListType2EffectId(type, isSeason)
  if type == BuildListBuffType.BuildListBuffType_SpeedUp then
    return self:GetBuffDetail(effectList, {
      EffectReasonType.Science,
      EffectReasonType.Hero,
      EffectReasonType.VIP,
      -1
    })
  elseif type == BuildListBuffType.BuildListBuffType_Free then
    return self:GetBuffDetail(effectList, {
      EffectReasonType.BASE_TALENT,
      EffectReasonType.Hero,
      EffectReasonType.Building
    })
  end
  return nil
end

local function GetInfoDetailReasonName(self, reasonType, effectId)
  if reasonType == EffectReasonType.Science then
    return GameDialogDefine.SCIENCE
  elseif reasonType == EffectReasonType.Hero then
    return GameDialogDefine.REASON_HERO
  elseif reasonType == EffectReasonType.VIP then
    return GameDialogDefine.REASON_VIP
  elseif reasonType == EffectReasonType.BASE_TALENT then
    return "131000"
  elseif reasonType == EffectReasonType.Building then
    if effectId == EffectDefine.BUILD_TIME_REDUCE then
      return "100315"
    end
    return ""
  elseif reasonType == -1 then
    return "100374"
  end
  return ""
end

local function GetEffectValueStr(self, type, value, effectId)
  local effectValue = ""
  value = toInt(value)
  local effectType = toInt(type)
  if effectType == EffectLocalTypeInEffectDesc.Num then
    if effectId == EffectDefine.BUILD_TIME_REDUCE then
      effectValue = UITimeManager:GetInstance():MilliSecondToFmtString(value * 1000)
    else
      effectValue = string.GetFormattedSeperatorNum(value)
    end
  elseif effectType == EffectLocalTypeInEffectDesc.Percent then
    effectValue = "+" .. value .. "%"
  elseif effectType == EffectLocalTypeInEffectDesc.Thousandth then
    effectValue = string.GetFormattedThousandthStr(value / 1000)
  end
  return effectValue
end

local function GetBuffDetail(self, effectList, reasonTypes)
  local titleInfo = {}
  local dataList = {}
  local value = 0
  local currentNum = 0
  local effectValue
  local effectNum = #effectList
  for k, v in ipairs(effectList) do
    value = value + LuaEntry.Effect:GetGameEffect(v)
  end
  local mainEffect = effectList[1]
  if mainEffect ~= nil and mainEffect ~= 0 then
    titleInfo.name = self:GetEffectName(mainEffect)
    local effectType = GetTableData(TableName.EffectNumDesc, mainEffect, "type")
    titleInfo.value = self:GetEffectValueStr(effectType, value, mainEffect)
    for k, v in ipairs(reasonTypes) do
      if v < 0 then
        effectValue = value - currentNum
      else
        effectValue = LuaEntry.Effect:GetReasonEffectValue(mainEffect, v)
      end
      if effectValue ~= nil and 0 < effectValue then
        local paramDes = {}
        paramDes.name = Localization:GetString(self:GetInfoDetailReasonName(v, mainEffect))
        paramDes.num = self:GetEffectValueStr(effectType, effectValue, mainEffect)
        paramDes.icon = BuffReasonIcon[v]
        table.insert(dataList, paramDes)
        currentNum = currentNum + effectValue
      end
      effectValue = nil
    end
    if 1 < effectNum then
      for i = 2, effectNum do
        local subValue = LuaEntry.Effect:GetGameEffect(effectList[i])
        if subValue ~= nil and subValue ~= 0 then
          local paramDes = {}
          paramDes.name = self:GetEffectName(effectList[i])
          paramDes.num = self:GetEffectValueStr(effectType, subValue, mainEffect)
          paramDes.icon = self:GetEffectIcon(effectList[i])
          table.insert(dataList, paramDes)
        end
      end
    end
  end
  return titleInfo, dataList
end

local function NeedShowBuffList(self)
  local k1 = LuaEntry.DataConfig:TryGetNum("buildingbuff_level", "k1")
  local mainLv = DataCenter.BuildManager.MainLv
  return k1 <= mainLv
end

local function GetIsShowBuy(template)
  local function GetDecorationCount(baseBuildId)
    local res = 0
    
    if DataCenter.BuildManager.buildIdBuilding and DataCenter.BuildManager.buildIdBuilding[baseBuildId] then
      local list = DataCenter.BuildManager.buildIdBuilding[baseBuildId]
      if list ~= nil then
        for k, v in ipairs(list) do
          res = res + 1
        end
      end
    end
    return res
  end
  
  if template == nil then
    return nil
  end
  if template.unlockBuildInfo and template.unlockBuildInfo[1] and template.unlockBuildInfo[1].needbuild and template.unlockBuildInfo[1].needbuild[1] then
    local needBuild = template.unlockBuildInfo[1].needbuild[1]
    if needBuild.buildId and needBuild.level then
      local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(needBuild.buildId)
      if buildData.level >= needBuild.level then
        local haveCount = GetDecorationCount(template.id)
        local maxCount = template.unlockBuildInfo[1].canBuildNun
        return haveCount < maxCount
      end
    end
  end
end

function UIBuildListCtrl:GetEffectIcon(effectId)
  if effectId == EffectDefine.SEASON_BUILD_TIME_REDUCE then
    return BuffReasonIcon[EffectReasonType.Building]
  end
  return BuffReasonIcon[EffectReasonType.Building]
end

local function GetAllDecorate()
  local dic = DataCenter.BuildManager:GetDecorateByState()
  local template = {}
  local param = {}
  local paramList = {}
  local idDic = {}
  for i, buildDataList in pairs(dic) do
    for _, buildData in pairs(buildDataList) do
      if buildData then
        param = {}
        template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
        if template then
          param.buildType = UIBuildListBuildType.Decorate
          param.id = template.id
          param.order = template.order
          param.buildTemplate = template
          param.needLevel = 0
          local baseBuildingId = CommonUtil.GetBuildBaseType(template.id)
          if idDic[baseBuildingId] == nil then
            local oneData = {
              index = (#paramList and #paramList or 0) + 1,
              level = buildData.level
            }
            idDic[baseBuildingId] = oneData
            param.buildDataList = {}
            table.insert(param.buildDataList, buildData)
            param.count = #param.buildDataList
            table.insert(paramList, param)
          elseif idDic[baseBuildingId].level < buildData.level then
            idDic[baseBuildingId].level = buildData.level
            paramList[idDic[baseBuildingId].index].buildDataList = {}
            table.insert(paramList[idDic[baseBuildingId].index].buildDataList, buildData)
            paramList[idDic[baseBuildingId].index].count = #paramList[idDic[baseBuildingId].index].buildDataList
          elseif idDic[baseBuildingId].level == buildData.level then
            table.insert(paramList[idDic[baseBuildingId].index].buildDataList, buildData)
            paramList[idDic[baseBuildingId].index].count = #paramList[idDic[baseBuildingId].index].buildDataList
          end
        end
      end
    end
  end
  local list = DataCenter.BuildTemplateManager:GetBuyDecorateDataList()
  local temp
  for i = 1, #list do
    param = {}
    template = list[i]
    param.id = CommonUtil.GetBuildBaseType(template.id)
    temp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(param.id)
    if GetIsShowBuy(temp) then
      param.buildType = UIBuildListBuildType.Decorate
      param.order = template.order
      param.buildTemplate = template
      param.needLevel = 0
      param.isBuy = true
      table.insert(paramList, param)
    end
  end
  return paramList
end

UIBuildListCtrl.NeedShowBuffList = NeedShowBuffList
UIBuildListCtrl.GetShowData = GetShowData
UIBuildListCtrl.DoWhenClickBuild = DoWhenClickBuild
UIBuildListCtrl.DoWhenClickScience = DoWhenClickScience
UIBuildListCtrl.DoWhenClickFactory = DoWhenClickFactory
UIBuildListCtrl.DoWhenClickFarm = DoWhenClickFarm
UIBuildListCtrl.GetShowFarm = GetShowFarm
UIBuildListCtrl.GetShowFactory = GetShowFactory
UIBuildListCtrl.IsUnLockScience = IsUnLockScience
UIBuildListCtrl.CanScienceUpgrade = CanScienceUpgrade
UIBuildListCtrl.Close = Close
UIBuildListCtrl.CloseSelf = CloseSelf
UIBuildListCtrl.GetBuffListData = GetBuffListData
UIBuildListCtrl.GetBuffDetailInfoListData = GetBuffDetailInfoListData
UIBuildListCtrl.BuffListType2EffectId = BuffListType2EffectId
UIBuildListCtrl.GetBuffDetail = GetBuffDetail
UIBuildListCtrl.GetEffectValueStr = GetEffectValueStr
UIBuildListCtrl.GetInfoDetailReasonName = GetInfoDetailReasonName
UIBuildListCtrl.GetEffectName = GetEffectName
UIBuildListCtrl.GetAllDecorate = GetAllDecorate
return UIBuildListCtrl
