local GoToUtil = {}
local Data = CS.GameEntry.Data
local Localization = CS.GameEntry.Localization
local ResType = {
  [1] = ResourceType.Oil,
  [2] = ResourceType.Metal,
  [3] = ResourceType.Water,
  [4] = ResourceType.Electricity
}
local Const = require("Scene.PVEBattleLevel.Const")
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject

local function GotoCityByBuildId(buildId, worldTileBtnType, questTemplate, directShow, isCheckBuildFinish)
  local uuid
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local maxLevel = -1
    for k, v in pairs(list) do
      local level = v.level
      if maxLevel < level then
        maxLevel = level
        uuid = v.uuid
      end
    end
  end
  if uuid == nil then
    GoToUtil.GotoBuildListByBuildId(buildId)
  else
    GoToUtil.GotoCityByBuildUuid(uuid, worldTileBtnType, nil, questTemplate, directShow, isCheckBuildFinish)
  end
end

local function GotoCityByCondBuildId(buildId, worldTileBtnType, questTemplate, directShow)
  local uuid
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local maxLevel = -1
    for k, v in pairs(list) do
      local level = v.level
      if maxLevel < level then
        maxLevel = level
        uuid = v.uuid
      end
    end
  end
  if buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4 then
    local buildData
    if uuid == nil then
      local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildId)
      if dataList and 0 < #dataList and dataList[1] then
        buildData = dataList[1]
      end
    else
      buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    end
    if buildData ~= nil then
      local worldPointPos = buildData:GetCenterVec()
      GoToUtil.CloseAllWindows()
      SceneUtils.ChangeToCity(function()
        GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2)
        TimerManager:GetInstance():DelayInvoke(function()
          local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
          local param = {}
          param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
          param.arrowType = ArrowType.Building
          param.positionType = PositionType.Screen
          param.isPanel = false
          param.isAutoClose = 2
          DataCenter.ArrowManager:ShowArrow(param)
        end, 0.5)
      end)
      return
    end
  end
  if uuid == nil then
    GoToUtil.GotoBuildListByBuildId(buildId)
  else
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    local itemId = buildData and buildData.itemId
    local isSpecialBuilding = false
    if itemId == BuildingTypes.FUN_BUILD_SCIENE or itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO or itemId == BuildingTypes.LW_BUILE_SCIENCE_THREE then
      itemId = GoToUtil.GetHighestLevelBuild(BuildingTypes.FUN_BUILD_SCIENE, BuildingTypes.LW_BUILE_SCIENCE_TWO, BuildingTypes.LW_BUILE_SCIENCE_THREE)
      isSpecialBuilding = true
    elseif itemId == BuildingTypes.LW_BUILD_TANKCENTER or itemId == BuildingTypes.LW_BUILD_ARTILLERYCENTER or itemId == BuildingTypes.LW_BUILD_AIRCRAFTCENTER then
      itemId = GoToUtil.GetHighestLevelBuild(BuildingTypes.LW_BUILD_TANKCENTER, BuildingTypes.LW_BUILD_ARTILLERYCENTER)
      itemId = GoToUtil.GetHighestLevelBuild(itemId, BuildingTypes.LW_BUILD_AIRCRAFTCENTER)
      isSpecialBuilding = true
    end
    if not string.IsNullOrEmpty(itemId) and isSpecialBuilding then
      local bD = DataCenter.BuildManager:GetFunbuildByItemID(itemId)
      if bD then
        uuid = bD.uuid
      end
    end
    if DataCenter.UIPopWindowManager:IsWindowInQueue(UIWindowNames.UILWScienceMain) then
      DataCenter.UIPopWindowManager:Pop()
    end
    GoToUtil.GotoCityByBuildUuid(uuid, worldTileBtnType, nil, questTemplate, directShow)
  end
end

local function GetHighestLevelBuild(buildAId, buildBId, buildCId)
  local buildId = buildAId
  local buildA = DataCenter.BuildManager:GetFunbuildByItemID(buildAId)
  local highestLevel = 0
  if buildA ~= nil then
    highestLevel = buildA.level
  end
  local buildB = DataCenter.BuildManager:GetFunbuildByItemID(buildBId)
  if buildB ~= nil and highestLevel < buildB.level then
    buildId = buildB.itemId
  end
  local buildC = DataCenter.BuildManager:GetFunbuildByItemID(buildCId)
  if buildC ~= nil and highestLevel < buildC.level then
    buildId = buildC.itemId
  end
  return buildId
end

local function GotoBuildListByBuildId(bId, hideProtect)
  local buildId = bId
  SceneUtils.ChangeToCity(function()
    GoToUtil.CloseAllWindows()
    if buildId == nil or buildId <= 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList)
    else
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil and 0 < table.count(list) then
        for i = 1, #list do
          if 0 < list[i].updateTime then
            GoToUtil.GotoCityByBuildUuid(list[i].uuid)
            return
          end
        end
      end
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      if template ~= nil and template.build_type == BuildType.Second then
        local num = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(template.sup_main_build_id)
        if num <= 0 then
          buildId = template.sup_main_build_id
          local mainTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
          if mainTemplate ~= nil then
            UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEED_FIRST_BUILD, Localization:GetString(mainTemplate.name)))
          end
        end
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList, buildId, true, nil, nil, nil, hideProtect)
    end
  end)
end

local function OpenChatView(closeAllWindows, ...)
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if closeAllWindows then
    GoToUtil.CloseAllWindows()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatNew_v2, ...)
end

local function GotoOpenView(ui_name, ...)
  GoToUtil.CloseAllWindows()
  if ui_name == UIWindowNames.UISearch then
    UIManager:GetInstance():OpenWindow(ui_name, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, ...)
  elseif ui_name == UIWindowNames.UIAllianceWarMainTable then
    UIManager:GetInstance():OpenWindow(ui_name, {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, ...)
  else
    UIManager:GetInstance():OpenWindow(ui_name, ...)
  end
end

local function GotoOpenViewOpenOptions(ui_name, OpenOptions, ...)
  GoToUtil.CloseAllWindows()
  UIManager:GetInstance():OpenWindow(ui_name, OpenOptions, ...)
end

local function GotoOpenView_BattleReturnOpt(ui_name, preLoadAssets, ...)
  if DataCenter.LWBattleManager:IsOpenReturnOpt() then
    for k, v in pairs(preLoadAssets) do
      Resource:PreloadAsset(k, typeof(GameObject))
    end
    GoToUtil.GotoOpenViewOpenOptions(ui_name, {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide,
      ultraHigh = true
    }, ...)
  else
    GoToUtil.GotoOpenView(ui_name, ...)
  end
end

local function GoToMonthCard(monthCardId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true}, {
    welfareTagType = WelfareTagType.MonthCard
  })
end

local function GotoGiftPackView(packageInfo, welfareTagType)
  local packId
  if packageInfo then
    packId = packageInfo:getID()
    local targetPack = GiftPackManager.get(packId)
    if targetPack then
      local rechargeLine = targetPack:getRechargeLineData()
      if rechargeLine and rechargeLine.type == WelfareTagType.ScrollPack then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIScrollPack, {anim = true}, packageInfo)
        return
      end
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true}, {targetPackageId = packId, welfareTagType = welfareTagType})
end

local function GotoScience(scienceId, tab, bUuid, noClose)
  local buildUuid = 0
  local buildId = BuildingTypes.FUN_BUILD_SCIENE
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  local hasBuild = true
  if bUuid ~= nil and bUuid ~= 0 then
    buildUuid = bUuid
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData == nil then
      hasBuild = false
    end
  elseif list ~= nil and 0 < table.count(list) then
    for k, v in ipairs(list) do
      buildUuid = v.uuid
    end
  else
    hasBuild = false
  end
  if hasBuild == false then
    UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEED_FIRST_BUILD, Localization:GetString(buildTemplate.name)))
    GoToUtil.GotoBuildListByBuildId(buildId)
  elseif scienceId == nil then
    if tab == nil then
      GoToUtil.OpenScienceTabPanel(tab, buildUuid, noClose)
    else
      local state = DataCenter.ScienceTemplateManager:GetTabState(tab)
      if state == ScienceTabState.UnLock or state == ScienceTabState.CanUnlock then
        GoToUtil.OpenScienceTabPanel(tab, buildUuid, noClose)
      elseif state == ScienceTabState.Lock then
        GoToUtil.OpenScienceTabPanel(tab, buildUuid, noClose)
      end
    end
  else
    local tempTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, 1)
    if tempTemplate ~= nil then
      local state = DataCenter.ScienceTemplateManager:GetTabState(tempTemplate.tab)
      if state == ScienceTabState.UnLock or state == ScienceTabState.CanUnlock then
        GoToUtil.OpenScienceTree(scienceId, tempTemplate.tab, buildUuid, noClose)
      elseif state == ScienceTabState.Lock then
        if tempTemplate.name and tempTemplate.level then
          local scienceName = CS.GameEntry.Localization:GetString(tempTemplate.name)
          UIUtil.ShowTips(CS.GameEntry.Localization:GetString("130314", scienceName, tempTemplate.level))
        else
          UIUtil.ShowTipsId(GameDialogDefine.NEED_UNLOCK_SCIENCE)
        end
        GoToUtil.OpenScienceTabPanel(tempTemplate.tab, buildUuid, noClose, true)
      elseif state == ScienceTabState.LockShow then
        GoToUtil.OpenScienceTabPanel(tempTemplate.tab, buildUuid, noClose, true)
      end
    end
  end
end

local function OpenSciencePanel(tab, scienceId, bUuid)
  GoToUtil.CloseAllWindows()
  local panel = UIManager:GetInstance():GetWindow(UIWindowNames.UIScience)
  if panel == nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience, tab, scienceId, false, bUuid)
  elseif scienceId == nil then
    EventManager:GetInstance():Broadcast(EventId.GOTO_SCIENCE, tab)
  else
    EventManager:GetInstance():Broadcast(EventId.GOTO_SCIENCE, scienceId)
  end
end

local function OpenScienceTabPanel(tab, bUuid, noClose, isNeedRollTargetTable)
  if not noClose then
    GoToUtil.CloseAllWindows()
  end
  local panel = UIManager:GetInstance():GetWindow(UIWindowNames.UILWScienceMain)
  if panel == nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceMain, tab, bUuid, isNeedRollTargetTable)
  end
end

local function OpenScienceTree(scienceId, tab, bUuid, noClose)
  if not noClose then
    GoToUtil.CloseAllWindows()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceTree, {anim = true, hideTop = true}, tab, scienceId, true, bUuid)
end

local function GetSourceByResourceItem(resourceItemId)
  local resourceItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(resourceItemId)
  if resourceItemTemplate ~= nil then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(resourceItemTemplate.building)
    if resourceItemTemplate ~= nil then
      local param = {}
      param.name = Localization:GetString(resourceItemTemplate.name)
      param.buildName = ""
      if buildTemplate ~= nil then
        param.buildName = Localization:GetString("140022", Localization:GetString(buildTemplate.name))
      elseif resourceItemTemplate.monster ~= nil and resourceItemTemplate.monster ~= "" then
        param.buildName = Localization:GetString("140022", Localization:GetString("104193"))
      end
      return param
    end
  end
end

local function CloseAllWindows()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
  local isShowUIMain = true
  local curSceneId = CS.SceneManager.CurrSceneID
  if curSceneId == SceneManagerSceneID.World then
    local curLod = CS.SceneManager.World:GetLodLevel()
    if 3 < curLod then
      isShowUIMain = false
    end
  end
  if isShowUIMain then
    UIManager:GetInstance():PlayUIMainShowAnimation(UIMainAnimType.AllShow, nil)
  end
end

local function MoveToWorldPoint(pointId, sceneId)
  if sceneId and sceneId == SceneManagerSceneID.City then
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom)
  else
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom)
  end
end

local function MoveToWorldPointAndOpen(pointId, type, uuid, _serverId, _worldId)
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  local serverId = _serverId
  local worldId = _worldId
  if serverId == nil then
    serverId = LuaEntry.Player:GetSelfServerId()
  end
  GoToUtil.GotoWorldPos(pos, nil, nil, function()
    GoToUtil.OnClickWorldPoint(pointId, type, uuid)
  end, serverId, worldId)
end

function GoToUtil.MoveToWorldMarchAndOpen(pointId, uuid, serverId, worldId)
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos, nil, nil, function()
    GoToUtil.OnClickWorldPoint(nil, nil, uuid)
  end, serverId, worldId)
end

function GoToUtil.JumpToWorldPoint(pointId, uuid, serverId, worldId, time)
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos, nil, time, nil, serverId, worldId)
end

function GoToUtil.JumpToMarchByUuid(marchUuid, serverId, worldId, marchType)
  if not marchUuid then
    return
  end
  marchUuid = tonumber(marchUuid)
  if marchUuid <= 0 then
    return
  end
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  local marchData = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
  if marchData then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    GoToUtil.GotoMarchCurPos(marchData, nil, function()
      GoToUtil.OnClickWorldPoint(nil, nil, marchUuid)
    end)
    return
  end
  if serverId then
    SFSNetwork.SendMessage(MsgDefines.GetMarchPos, serverId, worldId, marchUuid, marchType)
  end
end

local function OnClickWorldPoint(pointId, type, uuid)
  local info
  if pointId then
    info = CS.SceneManager.World:GetPointInfo(pointId)
  end
  local marchInfo
  if info ~= nil then
    UIUtil.OnClickWorld(pointId, type)
  elseif uuid ~= nil then
    marchInfo = CS.SceneManager.World:GetMarch(uuid)
    if marchInfo ~= nil then
      UIUtil.OnClickWorldTroop(uuid)
    end
  end
  if info == nil and marchInfo == nil then
    DataCenter.WorldPointWaitOpenManager:SetWaitOpenPointData(pointId, type, uuid)
  end
end

local function GotoPayTips(need)
  if not need then
    Logger.LogError("need value")
    need = 10
  end
  local data = {}
  table.insert(data, {
    resType = ResourceType.Gold,
    need = need
  })
  LWResourceLackUtil:GotoResLack(data)
end

local function GotoPay()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond)
end

local function GoToCityBuildByQuest(buildId, worldTileBtnType, questTemplate)
  local uuid
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local maxLevel = 9999
    for k, v in pairs(list) do
      local level = v.level
      if maxLevel > level then
        maxLevel = level
        uuid = v.uuid
      end
    end
  end
  if uuid == nil then
    GoToUtil.GotoBuildListByBuildId(buildId)
  else
    GoToUtil.GotoCityByBuildUuid(uuid, worldTileBtnType, nil, questTemplate)
  end
end

local function GoToByTypeAndParam(goType, goPara, questTemplate, isCloseAllWindow)
  if not goType then
    return
  end
  if goType == QuestGoType.BuildBtn or goType == QuestGoType.BuildBtn_Newbies then
    local isCheckBuildFinish = true
    local checkBuildFinishMaxMainLv = LuaEntry.DataConfig:TryGetNum("task_goto_params", "k1", 0)
    if 0 < checkBuildFinishMaxMainLv and checkBuildFinishMaxMainLv <= DataCenter.BuildManager.MainLv then
      isCheckBuildFinish = false
    end
    SceneUtils.ChangeToCity(function()
      if goPara ~= nil and table.count(goPara) > 1 then
        GoToUtil.GotoCityByBuildId(tonumber(goPara[1]), tonumber(goPara[2]), questTemplate, nil, isCheckBuildFinish)
      elseif table.count(goPara) == 1 then
        GoToUtil.GotoCityByBuildId(tonumber(goPara[1]), nil, nil, nil, isCheckBuildFinish)
      elseif goPara ~= "" then
        local str = string.split(goPara, ";")
        GoToUtil.GotoCityByBuildId(tonumber(str[1]), tonumber(str[2]), nil, nil, isCheckBuildFinish)
      end
    end)
  elseif goType == QuestGoType.Season3JumpMummyMainUI then
    if SeasonUtil.IsMummySoldierFunctionEnabled() then
      local defaultTab = 1
      if goPara then
        if type(goPara) == "number" or type(goPara) == "string" then
          defaultTab = toInt(goPara)
        else
          defaultTab = toInt(goPara[1] or 1)
        end
      end
      if defaultTab == 0 then
        defaultTab = 1
      end
      SeasonUtil.ShowSeasonUI(UIWindowNames.UILWMummyMain, {anim = true}, defaultTab)
    else
      UIUtil.ShowTipsId("801141")
    end
  elseif goType == QuestGoType.GoTacticalCard then
    TacticalCardUtil.OpenTacticalCardMain()
  elseif goType == QuestGoType.Season3JumpHelpConvert then
    if SeasonUtil.IsInSeasonMummyMode() then
      SFSNetwork.SendMessage(MsgDefines.FindSeasonMummyConvertPos)
    else
      UIUtil.ShowTipsId("801141")
    end
  elseif goType == QuestGoType.Season3JumpLackSoldierUI then
    if SeasonUtil.IsMummySoldierFunctionEnabled() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMummyLackSource)
    else
      UIUtil.ShowTipsId("801141")
    end
  elseif goType == QuestGoType.Season3JumpLackMummyUI then
    if SeasonUtil.IsMummySoldierFunctionEnabled() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMummyLack, {anim = true})
    else
      UIUtil.ShowTipsId("801141")
    end
  elseif goType == QuestGoType.Farm then
    GoToUtil.GotoFarm(questTemplate)
  elseif goType == QuestGoType.FarmGet then
    if goPara ~= nil and 0 < table.count(goPara) then
      GoToUtil.GotoFarmGet(tonumber(goPara[1]))
    elseif goPara == "" or not next(goPara) then
      GoToUtil.GotoFarmGet()
    end
  elseif goType == QuestGoType.Pasture then
    if goPara ~= nil and 0 < table.count(goPara) then
      GoToUtil.GotoPasture(tonumber(goPara[1]), tonumber(goPara[2]))
    end
  elseif goType == QuestGoType.GetResource then
    if goPara ~= nil and 0 < table.count(goPara) then
      local list = DataCenter.BuildManager:GetCanGetResourceBuildUuidByResourceType(tonumber(goPara[1]))
      if list == nil then
        GoToUtil.GotoBuildListByBuildId()
      else
        GoToUtil.GotoCityByBuildUuid(list.uuid)
      end
    end
  elseif goType == QuestGoType.GetResourceRandom then
    GoToUtil.GotoResourceBuild()
  elseif goType == QuestGoType.BuildList then
    if goPara ~= nil and 0 < table.count(goPara) then
      local uuid
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(goPara[1]))
      if list ~= nil and 0 < table.count(list) then
        for i = 1, table.count(list) do
          if list[i].level == 0 then
            uuid = list[i].uuid
          end
        end
      end
      if uuid == nil then
        GoToUtil.GotoBuildListByBuildId(tonumber(goPara[1]))
      else
        GoToUtil.GotoCityByBuildUuid(uuid, nil)
      end
    end
  elseif goType == QuestGoType.Science then
    local notClose
    if isCloseAllWindow ~= nil then
      notClose = not isCloseAllWindow
    end
    if goPara ~= nil and 0 < table.count(goPara) then
      if isCloseAllWindow then
        GoToUtil.CloseAllWindows()
      end
      local baseId = CommonUtil.GetScienceBaseType(tonumber(goPara[1]))
      GoToUtil.GotoScience(baseId, nil, nil, notClose)
    else
      GoToUtil.GotoScience(nil, nil, nil, notClose)
    end
  elseif goType == QuestGoType.HeroUpgrade then
    local isArrow = 2
    GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif goType == QuestGoType.BuildRoad then
    GoToUtil.GotoBuildRoad()
  elseif goType == QuestGoType.SearchingMonster then
    GoToUtil.CloseAllWindows()
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local targetLv
    if goPara and #goPara == 1 then
      local template = DataCenter.MonsterTemplateManager:GetMonsterTemplate(goPara[1])
      if template ~= nil then
        targetLv = template.level
      end
    end
    SceneUtils.ChangeToWorld(function()
      if not IsNull(CS.SceneManager.World) then
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
      end
      GoToUtil.GotoOpenViewOpenOptions(UIWindowNames.UISearch, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        onFinish = function()
          if not IsNull(CS.SceneManager.World) then
            CS.SceneManager.World:SetTouchInputControllerEnable(true)
          end
        end
      }, UISearchType.Monster, targetLv)
    end)
  elseif goType == QuestGoType.CollectResource then
    if goPara ~= nil and 0 < table.count(goPara) then
      GoToUtil.GotoWorldResource(tonumber(goPara[1]))
    elseif goPara ~= "" then
      GoToUtil.GotoWorldResource(tonumber(goPara))
    end
  elseif goType == QuestGoType.DailyBuildUp then
    if goPara == "" then
      local buildIdList = DataCenter.BuildManager:GetSelfBuildMinLevel()
      if next(buildIdList) then
        GoToUtil.GotoCityByBuildUuid(buildIdList[1].bUuid)
      else
        GoToUtil.CloseAllWindows()
      end
    elseif goPara ~= "" and tonumber(goPara) == 1 then
      local uuid = DataCenter.BuildQueueManager:GetAllQueueUuid()
      if uuid then
        GoToUtil.GotoCityByBuildUuid(uuid, WorldTileBtnType.City_SpeedUp)
      else
        GoToUtil.CloseAllWindows()
      end
    end
  elseif goType == QuestGoType.DailyBarn then
    local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueForPasture()
    if next(buildIdList) then
      GoToUtil.GotoPastureByUuid(buildIdList[1])
    else
      GoToUtil.GotoPasture(BuildingTypes.APS_BUILD_PASTURE_OSTRICH)
    end
  elseif goType == QuestGoType.DailyFoodFactory then
    GoToUtil.GoFactory()
  elseif goType == QuestGoType.AttackMonster then
    GoToUtil.CloseAllWindows()
    if SceneUtils.CheckCanGotoWorld() then
      SceneUtils.ChangeToWorld(function()
        if not IsNull(CS.SceneManager.World) then
          CS.SceneManager.World:SetTouchInputControllerEnable(false)
        end
        GoToUtil.GotoOpenViewOpenOptions(UIWindowNames.UISearch, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide,
          onFinish = function()
            if not IsNull(CS.SceneManager.World) then
              CS.SceneManager.World:SetTouchInputControllerEnable(true)
            end
          end
        }, UISearchType.Boss)
      end)
    end
  elseif goType == QuestGoType.AllianceHelp then
    GoToUtil.CloseAllWindows()
    if LuaEntry.Player:IsInAlliance() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlHelp, {
        anim = true,
        hideTop = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    else
      local params = {guide = false}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    end
  elseif goType == QuestGoType.AllianceGift then
    GoToUtil.CloseAllWindows()
    if LuaEntry.Player:IsInAlliance() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceGift, {anim = true, hideTop = true})
    else
      local params = {guide = false}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    end
  elseif goType == QuestGoType.RadarProbe then
    local isInCrossServer = false
    if not UIUtil.CheckDetectCanCrossServer() then
      local player = LuaEntry.Player
      if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() then
        isInCrossServer = true
      end
    end
    if isInCrossServer then
      UIUtil.ShowTipsId("bp_goto_alert1")
      return
    end
    local para1, para2
    if not string.IsNullOrEmpty(goPara[1]) then
      para1 = tonumber(goPara[1])
    end
    if not string.IsNullOrEmpty(goPara[2]) then
      para2 = tonumber(goPara[2])
    end
    GoToUtil.GoRadarProbe(para1, para2)
  elseif goType == QuestGoType.ChangePlayerName then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, LuaEntry.Player.uid, 1)
  elseif goType == QuestGoType.GoBusinessCenterWindow then
    GoToUtil.GoBusinessCenterWindow()
  elseif goType == QuestGoType.CollectGarbage then
    GoToUtil.GoGarbage(questTemplate)
  elseif goType == QuestGoType.FactoryWork or goType == QuestGoType.FactoryWorkNew then
    GoToUtil.GoFactoryWork(questTemplate, goType)
  elseif goType == QuestGoType.GoRobot then
    GoToUtil.GotoBuildListRobotByRobotId(goPara[1])
  elseif goType == QuestGoType.GoTrainingCamp then
    GoToUtil.GoBarracks()
  elseif goType == QuestGoType.GoBindAccount then
    GoToUtil.CloseAllWindows()
    if DataCenter.AccountScoreManager:CheckAccountIDOpen() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountManage, {anim = true, hideTop = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount, {anim = true, hideTop = true})
    end
  elseif goType == QuestGoType.GoConnectBuild then
    GoToUtil.GoConnectBuild(questTemplate.para1)
  elseif goType == QuestGoType.MonsterReward then
    GoToUtil.GotoMonsterReward()
  elseif goType == QuestGoType.GoHeroStation then
    GoToUtil.GoHeroStation(questTemplate)
  elseif goType == QuestGoType.GoGiftMall then
    GoToUtil.GoGiftMall()
  elseif goType == QuestGoType.GoBagPackUseItem then
    GoToUtil.GoBagPackUseItem()
  elseif goType == QuestGoType.GoSearchEnemy then
    GoToUtil.GoSearchEnemy(goPara)
  elseif goType == QuestGoType.GoGarageUpgrade then
    GoToUtil.GoGarageUpgrade(goPara)
  elseif goType == QuestGoType.GoHeroStationScores then
    GoToUtil.GoHeroStationScores(questTemplate)
  elseif goType == QuestGoType.GoHospital then
    GoToUtil.GoHospital(questTemplate)
  elseif goType == QuestGoType.GoPveLevel then
    GoToUtil.GoPveLevel(tonumber(questTemplate.para1))
  elseif goType == QuestGoType.GoTile then
    GoToUtil.GoLandLockById(tonumber(goPara[1]))
  elseif goType == QuestGoType.GoUnlockedTile then
    GoToUtil.GoUnlockedTile()
  elseif goType == QuestGoType.GoLockMonster then
    GoToUtil.GoLockMonster(questTemplate)
  elseif goType == QuestGoType.GoHeroTrust then
    GoToUtil.GoHeroTrust(questTemplate)
  elseif goType == QuestGoType.GoTriggerPve or goType == QuestGoType.GoPveAutoTo then
    GoToUtil.GoTriggerPve(goPara)
  elseif goType == QuestGoType.GoLandPve then
    GoToUtil.GoLandPve(tonumber(goPara[1]))
  elseif goType == QuestGoType.GoEnergy then
    GoToUtil.GoEnergy(tonumber(goPara[1]))
  elseif goType == QuestGoType.GoFelledTree then
  elseif goType == QuestGoType.GoActUI then
    if type(goPara) == "string" then
      GoToUtil.GoActWindow({
        tonumber(goPara)
      })
    else
      GoToUtil.GoActWindow({
        tonumber(goPara[1])
      })
    end
  elseif goType == QuestGoType.GoCityCollect then
    GoToUtil.GoCityCollect(tonumber(goPara[1]))
  elseif goType == QuestGoType.GoFormation then
    GoToUtil.GoFormation(tonumber(goPara[1]))
  elseif goType == QuestGoType.GoTaskToBuild then
    if goPara ~= nil and 1 < table.count(goPara) then
      GoToUtil.GoToCityBuildByQuest(tonumber(goPara[1]), tonumber(goPara[2]), questTemplate)
    elseif table.count(goPara) == 1 then
      GoToUtil.GoToCityBuildByQuest(tonumber(goPara[1]))
    elseif goPara ~= "" then
      local str = string.split(goPara, ";")
      GoToUtil.GoToCityBuildByQuest(tonumber(str[1]), tonumber(str[2]))
    end
  elseif goType == QuestGoType.GoCheckBuild then
    GoToUtil.GoCheckBuild(tonumber(goPara[1]), tonumber(goPara[2]))
  elseif goType == QuestGoType.GoHeroBag then
    GoToUtil.GoHeroBag()
  elseif goType == QuestGoType.GoHeroSkill then
    GoToUtil.GoHeroDetails(questTemplate.para3, HeroDetailGuideArrowType.Skill)
  elseif goType == QuestGoType.GoHeroDetails then
    GoToUtil.GoHeroDetails(goPara[1])
  elseif goType == QuestGoType.GoHeroRank then
    GoToUtil.GoHeroDetails(goPara[1], HeroDetailGuideArrowType.Rank)
  elseif goType == QuestGoType.OpenHeroUniqueWeaponPreview then
    GoToUtil.GoHeroUniqueWeaponPreview(goPara[1])
  elseif goType == QuestGoType.OpenHeroAwakenPage then
    GoToUtil.GotoHeroAwaken(goPara[1])
  elseif goType == QuestGoType.OpenUIDispatchTaskMain then
    GoToUtil.GoToWindow(JumpWindowType.Other, OtherWindow.UIDispatchTaskMain, true)
  elseif goType == QuestGoType.GoBuildOpenUpgrade then
    if goPara ~= nil and 1 < table.count(goPara) then
      GoToUtil.GoBuildOpenUpgrade(tonumber(goPara[1]), questTemplate)
    elseif table.count(goPara) == 1 then
      GoToUtil.GoBuildOpenUpgrade(tonumber(goPara[1]), questTemplate)
    elseif goPara ~= "" then
      local str = string.split(goPara, ";")
      GoToUtil.GoBuildOpenUpgrade(tonumber(str[1]), questTemplate)
    end
  elseif goType == QuestGoType.GoMainUIBtn then
    if type(questTemplate.gopara) == "string" then
      GoToUtil.GoMainUIBtn(tonumber(questTemplate.gopara))
    else
      GoToUtil.GoMainUIBtn(tonumber(questTemplate.gopara[1]))
    end
  elseif goType == QuestGoType.GotoAllianceCity then
    local cityId = 0
    if type(questTemplate.gopara) == "string" then
      cityId = tonumber(questTemplate.gopara)
    else
      cityId = tonumber(questTemplate.gopara[1])
    end
    if 0 < cityId then
      local zoom = tonumber(questTemplate.gopara[2])
      local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
      if meta then
        meta:JumpTo(zoom, true)
      end
    end
  elseif goType == QuestGoType.GotoBag then
    GoToUtil.GotoOpenView(UIWindowNames.UILWBagMain)
  elseif goType == QuestGoType.GotoMastery then
    if SeasonUtil.IsOpen() then
      if DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.SEASON_CAREER_BUILD, 1) then
        local masteryData = DataCenter.MasteryManager:GetData()
        if masteryData == nil or masteryData.home_id == MasteryHome.None then
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          })
        elseif masteryData then
          local params = {}
          local thePara
          if type(goPara) == "string" then
            thePara = goPara
          elseif goPara then
            thePara = goPara[1]
          end
          params.tabType = MasteryTabType.MasterSkillTab
          params.data = {
            homeId = masteryData.home_id,
            jumpLinkSkill = string.split_ii_array(tostring(thePara), "|")
          }
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, params)
        end
      else
        UIUtil.ShowTipsId("season_mastery_error_code_01")
      end
    else
      UIUtil.ShowTipsId("power_display_new_109")
    end
  elseif goType == QuestGoType.GoLWParkourBattle then
    GoToUtil.GoLWParkourBattle(questTemplate.para1, questTemplate.para2)
  elseif goType == QuestGoType.GoDoorWorker then
    local pos = Vector3.New(100, 0, 75)
    SceneUtils.ChangeToCity(function()
      GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        local param = {}
        param.position = CS.CSUtils.WorldPositionToUISpacePosition(pos)
        param.arrowType = ArrowType.Building
        param.positionType = PositionType.Screen
        DataCenter.ArrowManager:ShowArrow(param)
      end)
    end)
  elseif goType == QuestGoType.GoOpeningStage then
    if goPara ~= nil and 0 < table.count(goPara) then
      DataCenter.LWOpeningStageManager.utils.FocusCameraToStageNode(tonumber(goPara[1]), 0.5, nil, 150)
    end
  elseif goType == QuestGoType.GoMonopolyPlaceality then
    if goPara ~= nil and 0 < table.count(goPara) then
      SceneUtils.ChangeToCity(function()
        local data = DataCenter.MonopolyManager:GetPlacealityDataById(tonumber(goPara[1]))
        GoToUtil.GotoPos(data:GetCenterWorldPos(), CS.SceneManager.World.InitZoom, 0.5, function()
          local param = {}
          param.position = CS.CSUtils.WorldPositionToUISpacePosition(data:GetCenterWorldPos())
          param.arrowType = ArrowType.Building
          param.positionType = PositionType.Screen
          param.isPanel = false
          DataCenter.ArrowManager:ShowArrow(param)
        end)
      end)
    end
  elseif goType == QuestGoType.GoAllianceIntro then
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if hasAlliance then
      GoToUtil.GotoOpenView(UIWindowNames.UILWAlMain)
    else
      local params = {guide = false}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    end
  elseif goType == QuestGoType.GoWorldSearch then
    GoToUtil.CloseAllWindows()
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local pageType, subType
    if goPara ~= nil and table.count(goPara) == 1 then
      pageType = tonumber(goPara[1])
    elseif goPara ~= nil and table.count(goPara) == 2 then
      pageType = tonumber(goPara[1])
      subType = tonumber(goPara[2])
    elseif not string.IsNullOrEmpty(goPara) then
      local str = string.split(goPara, ";")
      if str[1] then
        pageType = tonumber(str[1])
      end
      if str[2] then
        subType = tonumber(str[2])
      end
    end
    SceneUtils.ChangeToWorld(function()
      if not IsNull(CS.SceneManager.World) then
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
      end
      GoToUtil.GotoOpenViewOpenOptions(UIWindowNames.UISearch, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        onFinish = function()
          if not IsNull(CS.SceneManager.World) then
            CS.SceneManager.World:SetTouchInputControllerEnable(true)
          end
        end
      }, pageType, nil, subType)
    end)
  elseif goType == QuestGoType.GoWorld then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    GoToUtil.CloseAllWindows()
    SceneUtils.ChangeToWorld()
  elseif goType == QuestGoType.GoAllianceTech then
    GoToUtil.CloseAllWindows()
    if LuaEntry.Player:IsInAlliance() then
      if goPara ~= nil and table.count(goPara) == 1 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {
          anim = true,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide,
          hideTop = true
        }, {}, tonumber(goPara[1]))
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {
          anim = true,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide,
          hideTop = true
        })
      end
    else
      local params = {guide = false}
      GoToUtil.GotoOpenView(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    end
  elseif goType == QuestGoType.GoVistor then
    local data = DataCenter.CityVisitorManager:GetFristVisitorData()
    if data and data:GetEndPos() then
      GoToUtil.GotoCityPos(data:GetEndPos(), nil, LookAtFocusTime, function()
        local param = {
          position = CS.CSUtils.WorldPositionToUISpacePosition(data:GetEndPos()),
          positionType = PositionType.Screen,
          useLiteAnim = true,
          arrowType = ArrowType.CityNpc
        }
        DataCenter.ArrowManager:ShowArrow(param)
      end)
    else
      UIUtil.ShowTipsId(170557)
    end
  elseif goType == QuestGoType.GoUpgradeBuilding then
    GoToUtil.CloseAllWindows()
    local isCheckBuildFinish = true
    local checkBuildFinishMaxMainLv = LuaEntry.DataConfig:TryGetNum("task_goto_params", "k1", 0)
    if 0 < checkBuildFinishMaxMainLv and checkBuildFinishMaxMainLv <= DataCenter.BuildManager.MainLv then
      isCheckBuildFinish = false
    end
    local list = DataCenter.BuildManager:GetCanUpgradeBuildUuidListFilterd()
    if 0 < table.count(list) then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(list[1])
      if buildData ~= nil then
        GoToUtil.GotoCityByBuildId(buildData.itemId, WorldTileBtnType.City_Upgrade, nil, nil, isCheckBuildFinish)
      else
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade, nil, nil, isCheckBuildFinish)
      end
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade, nil, nil, isCheckBuildFinish)
    end
  elseif goType == QuestGoType.GoVip then
    local vipOpen = DataCenter.VIPManager:CheckVipLvOpen()
    if vipOpen then
      GoToUtil.GotoOpenView(UIWindowNames.UIVip)
    end
  elseif goType == QuestGoType.GoActCommonGroup then
    local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_Activity)
    if unlock then
      local actGroupId
      if goPara ~= nil and table.count(goPara) >= 1 then
        actGroupId = tonumber(goPara[1])
        local actId = tonumber(goPara[2])
        if actId then
          local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
          if actInfo then
            GoToUtil.OpenActivityCommonGroupWindow(actGroupId, actId)
          end
        end
      end
    end
  elseif goType == QuestGoType.GoActDontClose then
    GoToUtil.GoActWindowDontClose({
      tonumber(goPara[1])
    })
  elseif goType == QuestGoType.GoActWindowByType then
    GoToUtil.GoToWindow(JumpWindowType.Activity, goPara[1], true)
  elseif goType == QuestGoType.GoActWorldBoss then
    GoToUtil.GoToWindow(JumpWindowType.Activity, EnumActivity.WorldBoss.Type, true)
  elseif goType == QuestGoType.GoActShop then
    if goPara and goPara[1] then
      GoToUtil.GotoActShopWindowMission(tonumber(goPara[1]))
    end
  elseif goType == QuestGoType.GoSeasonMain then
    if SeasonUtil.IsInSeasonDesertMode() then
      SeasonUtil.ShowSeasonUI(UIWindowNames.UILWSeasonMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, goPara[1])
    elseif SeasonUtil.OpenSeasonActivityById(true, goPara[1]) then
    else
      UIUtil.ShowTipsId("season_tips137")
    end
  elseif goType == QuestGoType.GoHeroRecruit then
    GoToUtil.GotoOpenView(UIWindowNames.UIHeroRecruit, nil, nil, goPara[1])
  elseif goType == QuestGoType.SeasonBuilding then
    GoToUtil.CloseAllWindows()
    if SeasonUtil.IsInSeasonDesertMode() then
      local param
      if goPara and goPara[1] then
        param = tonumber(goPara[1])
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonBuild, {
        anim = true,
        hideTop = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, param)
    end
  elseif goType == QuestGoType.GoToSeasonBuilding then
    GoToUtil.CloseAllWindows()
    if SeasonUtil.IsInSeasonDesertMode() then
      local buildingId, buildData
      if goPara and goPara[1] then
        buildingId = tonumber(goPara[1])
        local buildDic = DataCenter.DesertDataManager:GetSeasonBuildList()
        for k, v in pairs(buildDic) do
          if v.itemId == buildingId then
            buildData = v
            break
          end
        end
      end
      if buildData then
        local serverId = LuaEntry.Player:GetSourceServerId()
        local pos = SceneUtils.TileIndexToWorld(self.buildData.pointId, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(pos, nil, nil, function()
        end, serverId, 0)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonBuild, {
          anim = true,
          hideTop = false,
          UIMainAnim = UIMainAnimType.AllHide
        }, 2)
      end
    end
  elseif goType == QuestGoType.GoToMonsterBoss then
    GoToUtil.CloseAllWindows()
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local level = DataCenter.MonsterTemplateManager:GetMonsterMaxLevelbyType(LWWorldMonsterType.Boss)
    local selfLevel = LuaEntry.Player.level
    level = math.min(selfLevel, level)
    if level <= 0 then
      level = 1
    end
    SFSNetwork.SendMessage(MsgDefines.FindMonsterBoss, level)
  elseif goType == QuestGoType.GoTWSkillChip then
    GoToUtil.GotoTWSkillChipView()
  elseif goType == QuestGoType.GoSeasonTrendMain then
    if goPara == nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, toInt(goPara[1]), toInt(goPara[2]))
    end
  elseif goType == QuestGoType.GoMasteryMain then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif goType == QuestGoType.GoUnownedCityStronghold then
    GoToUtil.GotoNearestCityStronghold(true)
  elseif goType == QuestGoType.GoCityStronghold then
    GoToUtil.GotoNearestCityStronghold(false)
  elseif goType == QuestGoType.GoCommonShop then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, toInt(goPara[1]))
  elseif goType == QuestGoType.GoToCountBattleMap then
    GoToUtil.GoToCountBattleMap()
  elseif goType == QuestGoType.GoToAllianceFurnace then
    GoToUtil.GoToAllianceFurnace()
  elseif goType == QuestGoType.GoWorldCity then
    if goPara ~= nil and table.count(goPara) == 2 then
      GoToUtil.GotoNearestCity(toInt(goPara[2]), toInt(goPara[1]))
    end
  elseif goType == QuestGoType.SeasonCityList then
    if goPara ~= nil and table.count(goPara) == 1 then
      GoToUtil.GoToSeasonCityList(toInt(goPara[1]))
    end
  elseif goType == QuestGoType.FindAllianceMemberWorldPoint then
    if goPara ~= nil and table.count(goPara) == 1 then
      GoToUtil.RequestAllianceMemberBasePoint(toInt(goPara[1]))
    end
  elseif goType == QuestGoType.FindNearMonsterBySpecialType then
    if goPara ~= nil and table.count(goPara) == 1 then
      SFSNetwork.SendMessage(MsgDefines.FindNearMonster, toInt(goPara[1]))
    end
  elseif goType == QuestGoType.GotoNearestTradeStationWithoutLord then
    GoToUtil.RequestNearestTradeStationWithoutLord()
  elseif goType == QuestGoType.GotoNearestTradeStationWithLord then
    GoToUtil.RequestNearestTradeStationWithLord()
  elseif goType == QuestGoType.OpenUICollectReward then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICollectReward, {anim = true})
  elseif goType == QuestGoType.GoToSeasonActivity then
    if goPara ~= nil and table.count(goPara) == 1 then
      GoToUtil.GotoSeasonActivityView(toInt(goPara[1]))
    end
  elseif goType == QuestGoType.GoDominatorGorillaTreatment then
    GoToUtil.CloseAllWindows()
    DataCenter.DominatorManager:OpenGorillaTreatmentWindow()
  elseif goType == QuestGoType.GoDominatorMainUI then
    GoToUtil.CloseAllWindows()
    DataCenter.DominatorManager:OpenDominatorMain(toInt(goPara[1]), toInt(goPara[2]))
  elseif goType == QuestGoType.GoMasterySkillPanel then
    if SeasonUtil.IsOpen() then
      if DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.SEASON_CAREER_BUILD, 1) then
        local masteryData = DataCenter.MasteryManager:GetData()
        if goPara ~= nil and table.count(goPara) == 1 and masteryData then
          local masteryId = toInt(goPara[1])
          local params = {}
          params.tabType = MasteryTabType.MasterSkillTab
          params.data = {
            homeId = masteryData.home_id,
            jumpMasteryId = masteryId
          }
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, params)
        end
      else
        UIUtil.ShowTipsId("season_mastery_error_code_01")
      end
    else
      UIUtil.ShowTipsId("power_display_new_109")
    end
  elseif goType == QuestGoType.GoCityEventBoss then
    GoToUtil.CloseAllWindows()
    local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
    local cityEvent = DataCenter.LWBeginnerDirectorManager:GetCurCityEvent()
    if cityEventId ~= -1 and cityEvent then
      local bossNpc = cityEvent:GetOneAliveArmyNpc()
      if bossNpc then
        local x, z = bossNpc:GetPositionXZ()
        GoToUtil.GotoPos(Vector3(x, 0, z), CS.SceneManager.World.InitZoom, 0.5)
      end
    end
  elseif goType == QuestGoType.GoDecalreWarCity then
    local decalreBuildInfo = DataCenter.AllianceMineManager:GetAllianceS0CityFightDecalreMineInfo()
    local pos
    if decalreBuildInfo then
      pos = SceneUtils.IndexToTilePos(decalreBuildInfo.pointId, ForceChangeScene.World)
    else
      local selfWarData = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if selfWarData then
        local cityId = selfWarData.content
        local cityConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
        if cityConfig ~= nil and cityConfig.pos and cityConfig.pos.x ~= nil and cityConfig.pos.y ~= nil then
          pos = cityConfig.pos
        end
      end
    end
    if pos then
      local v3 = SceneUtils.TileToWorld(pos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetCurServerId())
    else
      UIUtil.ShowTipsId("city_event_desc50")
    end
  elseif goType == QuestGoType.GoToNearestDispatchTask then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    GoToUtil.CloseAllWindows()
    SFSNetwork.SendMessage(MsgDefines.DispatchFindNearestPoint)
  elseif goType == QuestGoType.GotoToFixBuilding_Newbies then
    if goPara ~= nil and 0 < table.count(goPara) then
      local uuid, xx
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(goPara[1]))
      if list ~= nil and 0 < table.count(list) then
        for i = 1, table.count(list) do
          if list[i].level == 0 then
            local pos = SceneUtils.TileIndexToWorld(list[i].pointId)
            if xx == nil then
              xx = pos
              uuid = list[i].uuid
            elseif pos.x < xx.x then
              xx = pos
              uuid = list[i].uuid
            end
          end
        end
      end
      if uuid == nil then
        GoToUtil.GotoBuildListByBuildId(tonumber(goPara[1]))
      else
        GoToUtil.GotoCityByBuildUuid(uuid, nil)
      end
    end
  elseif goType == QuestGoType.GotoBuilding_Newbies then
    if goPara ~= nil and 0 < table.count(goPara) then
      local uuid, xx
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(goPara[1]))
      if list ~= nil and 0 < table.count(list) then
        for i = 1, table.count(list) do
          if list[i].level == 0 then
            local pos = SceneUtils.TileIndexToWorld(list[i].pointId)
            if xx == nil then
              xx = pos
              uuid = list[i].uuid
            elseif pos.x < xx.x then
              xx = pos
              uuid = list[i].uuid
            end
          end
        end
      end
      if uuid ~= nil then
        local bd = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
        local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(bd.itemId)
        local worldPointPos = BuildingUtils.GetBuildModelCenterVec(bd.pointId, template.tileX, template.tileY)
        GoToUtil.GotoPos(worldPointPos, 180, 0.5)
        DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
      end
    end
  elseif goType == QuestGoType.GoToConsumeEnergy then
    GoToUtil.CloseAllWindows()
    local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
    if not table.IsNullOrEmpty(list) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
      return
    end
    local allianceId = LuaEntry.Player.allianceId
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local searchType = UISearchType.Boss
    if allianceId == "" then
      searchType = UISearchType.Monster
    end
    SceneUtils.ChangeToWorld(function()
      if not IsNull(CS.SceneManager.World) then
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
      end
      GoToUtil.GotoOpenViewOpenOptions(UIWindowNames.UISearch, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        onFinish = function()
          if not IsNull(CS.SceneManager.World) then
            CS.SceneManager.World:SetTouchInputControllerEnable(true)
          end
        end
      }, searchType)
    end)
  elseif goType == QuestGoType.GotoTW then
    GoToUtil.GotoTWView(tonumber(goPara[1]))
  elseif goType == QuestGoType.GotoAccelerateBuilding then
    GoToUtil.CloseAllWindows()
    local minRemainQueue = DataCenter.BuildQueueManager:GetMinRemainTimeQueue()
    if minRemainQueue ~= nil then
      GoToUtil.GotoCityByBuildUuid(minRemainQueue.occupyUuid)
    else
      GoToUtil.GotoOpenView(UIWindowNames.UIBuildQueue)
    end
  elseif goType == QuestGoType.GotoBuildingPowerUp then
    GoToUtil.GotoFinishedBuilding()
  elseif goType == QuestGoType.GotoTruckView then
    local railwayState = DataCenter.LWMyStationDataManager:GetRailwayStationState()
    if railwayState == RailwayStationState.FirstReward then
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_RAILWAY_STATION, WorldTileBtnType.TrainList)
    elseif railwayState > RailwayStationState.FirstReward then
      RailwayUtil.OpenUITrainList(TrainTab.Mine)
    end
  elseif goType == QuestGoType.GotoWorkerRecruitView then
    GoToUtil.GotoOpenView(UIWindowNames.UIHeroRecruit, nil, nil, nil, nil, true)
  elseif goType == QuestGoType.GotoHospital then
    GoToUtil.GotoOpenView(UIWindowNames.LWUIHospital)
  elseif goType == QuestGoType.GotoADCrossServer then
    if DataCenter.AllianceCompeteDataManager:CanOpenAllyDuelUI() then
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllyDuel) then
        EventManager:GetInstance():Broadcast(EventId.AllyDuelChangeTabInView, tonumber(goPara[1]))
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuel, {anim = true}, tonumber(goPara[1]))
      end
    end
  elseif goType == QuestGoType.GoToTacticalCard then
    SFSNetwork.SendMessage(MsgDefines.FetchUserCardBoxList)
    if TacticalCardUtil.OpenTacticalCardMain() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardBoxPanel)
    end
  elseif goType == QuestGoType.GoToCampScience then
    GoToUtil.GoToCampScience(goPara or 0)
  elseif goType == QuestGoType.GoToNewAllianceSkill then
    GoToUtil.GoToNewAllianceSkill()
  elseif goType == QuestGoType.GotoFirstPay then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, {delay = 0.5})
  elseif goType == QuestGoType.GoToArmedUpgradePanel then
    DataCenter.LWArmedUpgradeManager:JumpToArmedUpgradeCityModel(true)
  elseif goType == QuestGoType.GoToCivilizationSparkBattle then
    GoToUtil.GoToCivilizationSparkBattle()
  elseif goType == QuestGoType.GoToCivilizationSparkUpgrade then
    GoToUtil.GoToCivilizationSparkUpgrade()
  else
    GoToUtil.CloseAllWindows()
  end
end

local function GoToByQuestId(questTemplate)
  if questTemplate ~= nil then
    DataCenter.GuideManager.questTemplate = questTemplate
    local goType = tonumber(questTemplate.gotype2)
    local goPara = questTemplate.gopara
    GoToByTypeAndParam(goType, goPara, questTemplate)
  end
end

local function GotoCityByBuildUuid(uuid, btnType, needShow, quest, directShow, isCheckBuildFinish)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local isLock = false
    local tipId = ""
    if buildData.itemId == BuildingTypes.LW_BUILD_RAILWAY_STATION or buildData.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_1 or buildData.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_2 or buildData.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_3 or buildData.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_4 then
      isLock = DataCenter.LWMyStationDataManager:IsTruckFunctionLock()
      tipId = "sevenday_event_des42"
    end
    if isLock then
      UIUtil.ShowTipsId(tipId)
      return
    end
    local isFinish = true
    if buildData.destroyStartTime <= 0 and (isCheckBuildFinish == nil or isCheckBuildFinish == true) then
      isFinish = DataCenter.BuildManager:CheckSendBuildFinish(buildData.uuid, true)
    end
    local worldTileBtnType = btnType
    local needShowWorldTileUI = needShow
    local questTemplate = quest
    local isWorldBuild = buildData.isWorldBuild
    if buildData.itemId and (buildData.itemId == BuildingTypes.WORM_HOLE_CROSS or buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or BuildingUtils.IsInEdenSubwayGroup(buildData.itemId) == true) then
      isWorldBuild = true
    end
    if isWorldBuild then
      SceneUtils.ChangeToWorld(function()
        GoToUtil.GotoWorldBuildAndOpenUI(buildData.pointId, worldTileBtnType, needShowWorldTileUI, isFinish, buildData.itemId, buildData.uuid, questTemplate, directShow, true)
      end)
    else
      SceneUtils.ChangeToCity(function()
        GoToUtil.GotoWorldBuildAndOpenUI(buildData.pointId, worldTileBtnType, needShowWorldTileUI, isFinish, buildData.itemId, buildData.uuid, questTemplate, directShow, false)
        local checkLv = LuaEntry.DataConfig:TryGetNum("arrow_show", "k2")
        if not isFinish and not DataCenter.RecommendShowManager:IsHaveShowRecommend() and checkLv >= DataCenter.BuildManager.MainLv and not UIManager:GetInstance():HasWindow() then
          DataCenter.ArrowManager:RemoveArrow()
          WorldArrowManager:GetInstance():RemoveEffect()
        end
      end)
    end
  end
end

local function GotoWorldBuildAndOpenUI(pointId, worldTileBtnType, needShowWorldTileUI, isFinish, itemId, uuid, questTemplate, directShow, isWorldBuild)
  GoToUtil.CloseAllWindows()
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
  local worldPointPos = BuildingUtils.GetBuildModelCenterVec(pointId, template.tileX, template.tileY)
  if worldTileBtnType == WorldTileBtnType.City_Upgrade then
    if itemId == BuildingTypes.FUN_BUILD_MAIN then
      worldPointPos.z = worldPointPos.z + 5
    else
      local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
      if building ~= nil and not string.IsNullOrEmpty(building.upgrade_notice) then
        local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.BuildCanUpgrade, itemId)
        if obj then
          worldPointPos = obj.transform.position
        end
      end
    end
  elseif worldTileBtnType == WorldTileBtnType.TrainList then
    worldPointPos = worldPointPos + Vector3.New(0, 0, -30)
  end
  GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime)
  local timer = TimerManager:GetInstance():GetTimer(LookAtFocusTime, function()
    local level = 0
    local isInOpeningStage = not DataCenter.LWOpeningStageManager:IsAllDone()
    local blockUpgradeView = isInOpeningStage
    local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId, isWorldBuild)
    if buildData ~= nil then
      level = buildData.level
    end
    if 0 <= level and needShowWorldTileUI ~= false then
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) and worldTileBtnType then
        local param = {}
        param.pointId = pointId
        param.worldTileBtnType = worldTileBtnType
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI, param)
      elseif isFinish then
        local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId, isWorldBuild)
        if buildData ~= nil and buildData.itemId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
          if buildData.itemId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
            UIUtil.CheckAndOpenBusinessCenter()
          end
        elseif buildData ~= nil and buildData.itemId == BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY and level == 0 then
        elseif worldTileBtnType then
          if worldTileBtnType == WorldTileBtnType.City_Upgrade then
            local data
            if CS.SceneManager:IsInWorld() then
              data = CS.SceneManager.World:GetPointInfo(pointId)
            elseif CS.SceneManager:IsInCity() then
              data = buildData
              if directShow == true then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, data.uuid)
                return
              end
            end
            if data then
              local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(data.itemId)
              if building ~= nil then
                if not string.IsNullOrEmpty(building.upgrade_notice) then
                  local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.BuildCanUpgrade, data.itemId)
                  if obj then
                    WorldArrowManager:GetInstance():ShowArrowEffect(0, obj.transform.position, ArrowType.Building)
                    return
                  elseif level == 0 then
                    if not blockUpgradeView then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, data.uuid)
                    end
                    return
                  end
                elseif level == 0 then
                  if not blockUpgradeView then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, data.uuid)
                  end
                  return
                end
              end
            end
          elseif worldTileBtnType == WorldTileBtnType.TrainList then
            return
          elseif worldTileBtnType == WorldTileBtnType.Train_Soldier then
            local data
            if CS.SceneManager:IsInWorld() then
              data = CS.SceneManager.World:GetPointInfo(pointId)
            elseif CS.SceneManager:IsInCity() then
              data = buildData
            end
            if data then
              local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(data.itemId)
              if building ~= nil then
                local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.BuildCanUpgrade, data.itemId)
                if obj then
                  WorldArrowManager:GetInstance():ShowArrowEffect(0, obj.transform.position, ArrowType.Building)
                  return
                elseif level == 0 then
                  if not blockUpgradeView then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, data.uuid)
                  end
                  return
                end
              end
            end
          elseif level == 0 then
            local isIgnore = true
            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.BuildingLv0Ruins, buildData.itemId, isIgnore)
            if obj then
              WorldArrowManager:GetInstance():ShowArrowEffect(0, obj.transform.position)
            elseif not blockUpgradeView then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
            end
            return
          end
          local info
          if CS.SceneManager:IsInWorld() then
            info = CS.SceneManager.World:GetPointInfo(pointId)
          elseif CS.SceneManager:IsInCity() then
            info = DataCenter.BuildManager:GetBuildingDataByPointId(pointId, isWorldBuild)
          end
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, pointId, false, worldTileBtnType, questTemplate)
        elseif level == 0 then
          local SendFreeBuildingUpNew = true
          if template then
            local quest_condition = template.quest_condition
            local taskInfo = DataCenter.TaskManager:FindTaskInfo(quest_condition)
            if taskInfo == nil then
              if not string.IsNullOrEmpty(quest_condition) then
                SendFreeBuildingUpNew = false
                local need_task = tostring(quest_condition)
                local task_id_vec = string.split_ss_array(buildData.completeTask or "", ",")
                for _, taskId in ipairs(task_id_vec) do
                  if need_task == taskId then
                    SendFreeBuildingUpNew = true
                  end
                end
              end
            elseif taskInfo.state ~= TaskState.Received then
              SendFreeBuildingUpNew = false
            end
          end
          if SendFreeBuildingUpNew then
            local param = {}
            param.uuid = tostring(buildData.uuid)
            param.gold = BuildUpgradeUseGoldType.No
            param.upLevel = 1
            param.clientParam = ""
            param.truckId = 0
            param.pathTime = 0
            param.robotUuid = 0
            SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
          end
          WorldArrowManager:GetInstance():ShowArrowEffect(0, buildData:GetCenterVec(), ArrowType.Building)
        elseif buildData ~= nil and buildData.itemId == BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY then
          local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
          local pos = BuildingUtils.GetBuildModelCenterVec(buildData.pointId, buildTemplate.tileX, buildTemplate.tileY)
          local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(pos)
          local param = {}
          param.position = Vector3.New(uiPos.x, uiPos.y + 60, uiPos.z)
          param.arrowType = ArrowType.Building
          param.positionType = PositionType.Screen
          param.isPanel = false
          DataCenter.ArrowManager:ShowArrow(param)
        end
      else
        DataCenter.BuildManager:CheckSendBuildFinish(uuid)
      end
    else
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    end
  end, nil, true, false, false)
  timer:Start()
end

local function GotoWorldResource(resourceType)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  if list ~= nil and table.count(list) > 0 then
    GoToUtil.CloseAllWindows()
    if resourceType >= ResourceType.ResourceItem then
      SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, ResourceType.ResourceItem, 0, tostring(resourceType))
    else
      SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, resourceType, 0)
    end
  end
end

local function GotoResourceBuild()
  local lists = {}
  for i = 1, 4 do
    lists[i] = DataCenter.BuildManager:GetCanGetResourceBuildUuidByResourceType(ResType[i]) or 0
  end
  for i = 4, 1, -1 do
    if lists[i] == 0 then
      table.remove(lists, i)
    end
  end
  if next(lists) then
    table.sort(lists, function(a, b)
      if a.num > b.num then
        return true
      elseif a.num == b.num then
        return false
      end
      return false
    end)
    GoToUtil.GotoCityByBuildUuid(lists[1].uuid)
  else
    GoToUtil.GotoBuildListByBuildId()
  end
end

local function GoAttackMonster()
  local targetOwnerList = CS.SceneManager.World:GetMarchesBossInfo()
  local isGoto = false
  for i, v in pairs(targetOwnerList) do
    if v:IsOrdinaryBoss() then
      GoToUtil.CloseAllWindows()
      isGoto = true
      GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(v.startPos), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, v.uuid, v.startPos, "", WorldPointUIType.Monster, 0)
      end)
      break
    end
  end
  if not isGoto then
    UIUtil.ShowTipsId(170441)
  end
end

local function GotoBossMonsterBetweenLv(self, minLevel, maxLevel)
  local targetOwnerList = CS.SceneManager.World:GetMarchesBossInfo()
  local findMonster
  local currentMonsterLv = 0
  for i, v in pairs(targetOwnerList) do
    if v:IsOrdinaryBoss() then
      local monsterId = v.monsterId
      local template = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
      if template ~= nil and minLevel <= template.level and maxLevel >= template.level and currentMonsterLv < template.level then
        findMonster = v
        currentMonsterLv = template.level
      end
    end
  end
  if findMonster ~= nil then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(findMonster.startPos), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, findMonster.uuid, findMonster.startPos, "", WorldPointUIType.Monster, 0)
    end)
  end
end

local function GoFactory()
  local mark = {
    BuildingTypes.FUN_BUILD_FOODSHOP,
    BuildingTypes.FUN_BUILD_FOOD,
    BuildingTypes.FUN_BUILD_FOOD_1,
    BuildingTypes.FUN_BUILD_METALLURGY,
    BuildingTypes.FUN_BUILD_FOOD_2,
    BuildingTypes.FUN_BUILD_OIL_REFINERY,
    BuildingTypes.FUN_BUILD_PVE_FACTORY,
    BuildingTypes.FUN_BUILD_FACTORY_STONE,
    BuildingTypes.APS_BUILD_FARM
  }
  local result = {}
  local factoryData = DataCenter.FactoryDataManager:GetFactoryNoWorkData()
  if next(factoryData) then
    for i = 1, table.length(factoryData) do
      for k = 1, table.length(mark) do
        if factoryData[i] == mark[k] then
          table.insert(result, k)
        end
      end
    end
    if next(result) then
      table.sort(result, function(a, b)
        if a < b then
          return true
        else
          return false
        end
      end)
      GoToUtil.GotoCityByBuildId(mark[1])
    end
  else
    GoToUtil.GotoCityByBuildId(mark[1])
  end
end

local function GoRadarProbe(eventId, eventType)
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityByBuildId(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
    return
  end
  if not UIUtil.CheckDetectCanCrossServer() and CrossServerUtil:NeedIntercept(500019) then
    return
  end
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local result = {}
  
  local function GetOneEventData(uuid)
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
    if data == nil then
      return nil
    end
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    if template == nil then
      return nil
    end
    local param = {}
    param.uuid = uuid
    param.eventId = tonumber(data.eventId)
    param.template = template
    return param
  end
  
  table.walk(list, function(k, v)
    local param = GetOneEventData(v)
    if param ~= nil then
      table.insert(result, param)
    end
  end)
  local isFind = false
  local isSpecial = 0
  local quality = 0
  local uuid = 0
  for i = 1, #result do
    if result[i].template.type == DetectEventType.DetectEventTypeSpecial then
      isSpecial = i
    end
    if eventId == result[i].eventId or eventType == result[i].template.type then
      if quality < result[i].template.quality then
        quality = result[i].template.quality
        uuid = result[i].uuid
      end
      isFind = true
    end
  end
  if isFind then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, uuid)
  else
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
  if isSpecial ~= 0 and not isFind then
    UIUtil.ShowTips(Localization:GetString("129098", result[isSpecial].template.nameValue))
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, result[isSpecial].uuid)
  end
end

local function GotoFarm(questTemplate)
  local buildId = BuildingTypes.APS_BUILD_FARM_FIELD
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local finishIndex
    for k3, v3 in ipairs(list) do
      local bUuid = v3.uuid
      local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(bUuid)
      if queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
        local onComplete
        if not DataCenter.GuideManager:InGuide() then
          function onComplete()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarm, {
              anim = true,
              
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, tostring(bUuid), questTemplate.para1)
          end
        end
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(v3.pointId, ForceChangeScene.City), nil, LookAtFocusTime, function()
          CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(v3.pointId, ForceChangeScene.City), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
        end)
        return
      elseif queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
        finishIndex = v3
      end
    end
    GoToUtil.CloseAllWindows()
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.QuestTriggerBuild, tostring(questTemplate.id))
    if not DataCenter.GuideManager:InGuide() then
      do
        local dataList = DataCenter.BuildManager:GetFastBuildDataList()
        for i = 1, #dataList do
          if dataList[i].id == BuildingTypes.APS_BUILD_FARM_FIELD then
            UIUtil.ShowTipsId(120996)
            GoToUtil.GotoBuildListByBuildId(BuildingTypes.BUILDING_MORE_FARM)
            return
          end
        end
        if finishIndex ~= nil then
          GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(finishIndex.pointId, ForceChangeScene.City), nil, LookAtFocusTime, function()
            CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(finishIndex.pointId, ForceChangeScene.City), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, function()
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmGather, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, tostring(finishIndex.uuid))
            end)
          end)
        else
          GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(list[1].pointId, ForceChangeScene.City), nil, LookAtFocusTime, function()
            CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(list[1].pointId, ForceChangeScene.City), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true)
          end)
        end
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NO_USELESS, Localization:GetString(buildTemplate.name)))
      end
    end
  else
    UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEED_FIRST_BUILD, Localization:GetString(buildTemplate.name)))
    GoToUtil.GotoBuildListByBuildId(buildId)
  end
end

local function GotoPasture(buildId, btnType)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    GoToUtil.CloseAllWindows()
    for k, v in ipairs(list) do
      local pos = SceneUtils.TileIndexToWorld(v.pointId, ForceChangeScene.City)
      DataCenter.BuildManager:CheckSendBuildFinish(v.uuid)
      local onComplete
      if not DataCenter.GuideManager:InGuide() then
        function onComplete()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIPasture, {
            anim = true,
            
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, v.uuid, btnType)
        end
      end
      GoToUtil.GotoCityPos(pos, nil, LookAtFocusTime, function()
        CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
      end)
    end
  else
    UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEED_FIRST_BUILD, Localization:GetString(buildTemplate.name)))
    GoToUtil.GotoBuildListByBuildId(buildId)
  end
end

local function GotoPastureByUuid(uuid)
  GoToUtil.CloseAllWindows()
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local pos = SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City)
    local onComplete
    
    function onComplete()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPasture, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, buildData.uuid)
    end
    
    GoToUtil.GotoCityPos(pos, nil, LookAtFocusTime, function()
      CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
    end)
  end
end

local function GotoFarmGet(needResourceItem, openFarmWhenNotFind, showArrow)
  local buildId = BuildingTypes.APS_BUILD_FARM_FIELD
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local freeBUuid, freePoint, openFarmWhenNotFindPointId, openFarmWhenNotFindPointId1
    for k3, v3 in ipairs(list) do
      local bUuid = v3.uuid
      local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(bUuid)
      openFarmWhenNotFindPointId1 = v3.pointId
      if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
        local farmId = queue.itemId
        openFarmWhenNotFindPointId = v3.pointId
        local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(farmId)
        if functionTemplate ~= nil then
          local itemId = 0
          table.walk(functionTemplate.get_goods, function(m, n)
            itemId = m
          end)
          if itemId == needResourceItem then
            local onComplete
            if not DataCenter.GuideManager:InGuide() then
              function onComplete()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmGather, {
                  anim = true,
                  
                  playEffect = false,
                  UIMainAnim = UIMainAnimType.LeftRightBottomHide
                }, tostring(bUuid))
              end
            end
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(v3.pointId, ForceChangeScene.City), nil, LookAtFocusTime, function()
              CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(v3.pointId, ForceChangeScene.City), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
            end)
            return
          elseif needResourceItem == nil then
            do
              local onComplete
              if not DataCenter.GuideManager:InGuide() then
                function onComplete()
                  if showArrow == true then
                    local position = SceneUtils.TileIndexToWorld(v3.pointId, ForceChangeScene.City)
                    
                    position.x = position.x
                    position.y = position.y
                    position.z = position.z + 1
                    WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
                  else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmGather, {
                      anim = true,
                      playEffect = false,
                      UIMainAnim = UIMainAnimType.LeftRightBottomHide
                    }, tostring(bUuid))
                  end
                end
              end
              GoToUtil.CloseAllWindows()
              GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(v3.pointId, ForceChangeScene.City), nil, LookAtFocusTime, function()
                CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(v3.pointId, ForceChangeScene.City), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
              end)
              return
            end
          end
        end
      elseif queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
        freeBUuid = bUuid
        freePoint = v3.pointId
      end
    end
    if freeBUuid ~= nil and freePoint ~= nil then
      local onComplete
      
      function onComplete()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarm, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, tostring(freeBUuid))
      end
      
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(freePoint, ForceChangeScene.City), nil, LookAtFocusTime, function()
        CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(freePoint, ForceChangeScene.City), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
      end)
      return
    else
      do
        local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(needResourceItem)
        if resourceItemData ~= nil then
          if openFarmWhenNotFind == true and openFarmWhenNotFindPointId ~= nil then
            if openFarmWhenNotFindPointId ~= nil then
              local function onComplete()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmGather, {
                  anim = true,
                  
                  playEffect = false,
                  UIMainAnim = UIMainAnimType.LeftRightBottomHide
                }, tostring(bUuid))
              end
              
              GoToUtil.CloseAllWindows()
              GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(openFarmWhenNotFindPointId, ForceChangeScene.City), nil, LookAtFocusTime, function()
                CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(openFarmWhenNotFindPointId, ForceChangeScene.City), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
              end)
            elseif openFarmWhenNotFindPointId1 ~= nil then
              GoToUtil.CloseAllWindows()
              GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(openFarmWhenNotFindPointId, ForceChangeScene.City), nil, LookAtFocusTime, function()
                CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(openFarmWhenNotFindPointId, ForceChangeScene.City), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true)
              end)
            end
          else
            UIUtil.ShowTips(Localization:GetString(GameDialogDefine.DISABLE_GET, Localization:GetString(resourceItemData.name)))
          end
        elseif needResourceItem == nil then
          UIUtil.ShowTipsId(371050)
        end
      end
    end
  else
    UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEED_FIRST_BUILD, Localization:GetString(buildTemplate.name)))
    GoToUtil.GotoBuildListByBuildId(buildId)
  end
end

local function GotoBuildRoad(uuid, openWindow, showArrow)
  GoToUtil.CloseAllWindows()
  if uuid ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
      local worldPointPos = SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City)
      DataCenter.ArrowManager:RemoveArrow()
      WorldArrowManager:GetInstance():RemoveEffect()
      GoToUtil.GotoCityPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        if showArrow == true then
          WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPointPos + Vector3(-1.2, 0, 5.5), ArrowType.Building)
        end
      end)
    end
  end
  if openWindow ~= false then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList, UIBuildListTabType.Decorate)
  end
end

local function GoBusinessCenterWindow()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), CS.SceneManager.World.InitZoom)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
    return
  end
  GoToUtil.CloseAllWindows()
  UIUtil.CheckAndOpenBusinessCenter()
end

local function OpenInCity(openCallback, targetBuild)
  targetBuild = targetBuild or BuildingTypes.FUN_BUILD_MAIN
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(targetBuild)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, openCallback)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
    return
  end
end

local function GotoCityTroopAndPointToGarbage()
  GoToUtil.CloseAllWindows()
  if CS.SceneManager:IsInCity() then
    local troopPoint = CS.GameEntry.Setting:GetPrivateInt(SettingKeys.CITY_TROOP_POSITION, -1)
    if 0 <= troopPoint then
      CS.SceneManager.World:TrackMarch(1)
      local resPoint = DataCenter.CityPointDataManager:SearchGarbagePointData(troopPoint)
      if resPoint ~= nil then
        TimerManager:GetInstance():DelayInvoke(function()
          WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(resPoint.pointId), ArrowType.Guide_Garbage)
        end, 1)
      end
    else
      local cityPos = SceneUtils.TilePosToIndex(BuildingUtils.GetMainPos())
      if 0 <= cityPos then
        local resPoint = DataCenter.CityPointDataManager:SearchGarbagePointData(cityPos)
        if resPoint ~= nil then
          GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(resPoint.pointId), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(resPoint.pointId), ArrowType.Guide_Garbage)
          end)
        end
      else
        UIUtil.ShowTipsId(GameDialogDefine.NEAR_NO_GARBAGE)
      end
    end
  end
end

local function GoGarbage(questTemplate)
  GoToUtil.CloseAllWindows()
  SFSNetwork.SendMessage(MsgDefines.GetGarbageInfo)
end

local function GoFactoryWork(questTemplate, goType)
  GoToUtil.CloseAllWindows()
  local template = {}
  if tonumber(questTemplate.para1) ~= tonumber(questTemplate.gopara[1]) then
    template = DataCenter.FactoryDataManager:GetFactoryTemplate(questTemplate.para1)
  end
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(questTemplate.gopara[1]))
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    local pos = buildList[1]:GetCenterVec()
    if not next(template) then
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        if goType == QuestGoType.FactoryWork then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, buildList[1].uuid, questTemplate.para1, true)
        elseif goType == QuestGoType.FactoryWorkNew then
          DataCenter.ArrowManager:RemoveArrow()
          WorldArrowManager:GetInstance():RemoveEffect()
          local param = {
            uuid = tonumber(buildList[1].uuid),
            productId = questTemplate.para1,
            isBox = true
          }
          WorldArrowManager:GetInstance():SetArrowParam(param)
          WorldArrowManager:GetInstance():ShowArrowEffect(0, pos)
        end
      end)
      return
    end
    for k, v in pairs(template.unlock_condition) do
      if not DataCenter.BuildManager:HasBuildByIdAndLevel(tonumber(k), v) then
        GoToUtil.GotoCityByBuildId(tonumber(questTemplate.gopara[1]), WorldTileBtnType.City_Upgrade)
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(questTemplate.gopara[1])
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.FACTORY_LEVEL_TIPS, v, Localization:GetString(buildTemplate.name), Localization:GetString(template.product_name)))
        return
      end
    end
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      if goType == QuestGoType.FactoryWork then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, buildList[1].uuid, questTemplate.para1, false)
      elseif goType == QuestGoType.FactoryWorkNew then
        DataCenter.ArrowManager:RemoveArrow()
        WorldArrowManager:GetInstance():RemoveEffect()
        local param = {
          uuid = tonumber(buildList[1].uuid),
          productId = questTemplate.para1,
          isBox = false
        }
        WorldArrowManager:GetInstance():SetArrowParam(param)
        WorldArrowManager:GetInstance():ShowArrowEffect(0, pos)
      end
    end)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityByBuildId(tonumber(questTemplate.gopara[1]))
    return
  end
end

local function GotoBuildListRobotByRobotId(robotId)
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoOpenView(UIWindowNames.UIBuildList, tonumber(robotId), true)
end

local function GoBarracks()
  local buildData = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  if table.IsNullOrEmpty(buildData) then
    GoToUtil.GotoBuildListByBuildId({
      BuildingTypes.LW_BUILD_MILITARY_CAMP
    })
    return
  end
  table.sort(buildData, function(a, b)
    if a == nil or b == nil then
      if a == nil then
        return false
      else
        return true
      end
    end
    local aTraining = a.productStartTime ~= nil
    local bTraining = b.productStartTime ~= nil
    if aTraining ~= bTraining then
      return not aTraining
    end
    local aLevel = a.level
    local bLevel = b.level
    if aLevel ~= bLevel then
      return aLevel > bLevel
    end
  end)
  if not table.IsNullOrEmpty(buildData) then
    local build = buildData[1]
    if build then
      do
        local posEnd = build.pointId
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMilitaryCampPanel, {anim = true}, build.uuid)
        end)
      end
    end
  end
end

local function GotoTrainSolider(jumpType)
  local buildData = DataCenter.BuildManager:GetArmyBuildMaxLevelData()
  if buildData ~= nil then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, buildData.itemId, jumpType)
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_CAR_BARRACK)
  end
end

local function GoConnectBuild(buildId)
  GoToUtil.CloseAllWindows()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    for i = 1, #buildList do
      if 0 >= buildList[i].destroyStartTime then
        DataCenter.BuildManager:CheckSendBuildFinish(buildList[i].uuid)
      end
    end
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityByBuildId(buildId)
  end
end

local function GotoMonsterReward()
  local minDis = IntMaxValue
  local minDisPoint
  local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
  if 0 < #list then
    for i = 1, #list do
      local dis = math.ceil(SceneUtils.TileDistance(SceneUtils.IndexToTilePos(list[i].pointId, ForceChangeScene.World), DataCenter.BuildManager.main_city_pos))
      if minDis > dis then
        minDis = dis
        minDisPoint = list[i].pointId
      end
    end
  end
  if minDisPoint then
    GoToUtil.CloseAllWindows()
    DataCenter.ArrowManager:RemoveArrow()
    WorldArrowManager:GetInstance():RemoveEffect()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(minDisPoint, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(minDisPoint), ArrowType.Guide_Garbage)
    end)
  else
    SceneUtils.ChangeToWorld(function()
      if not IsNull(CS.SceneManager.World) then
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
      end
      GoToUtil.GotoOpenViewOpenOptions(UIWindowNames.UISearch, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        onFinish = function()
          if not IsNull(CS.SceneManager.World) then
            CS.SceneManager.World:SetTouchInputControllerEnable(true)
          end
        end
      }, UISearchType.Monster, DataCenter.MonsterManager:GetCurCanAttackMaxLevel())
    end)
  end
end

local function GoHeroStation(questTemplate)
  local buildId = questTemplate.para1
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  GoToUtil.CloseAllWindows()
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    if buildList[1].state == BuildingStateType.Upgrading then
      DataCenter.BuildManager:CheckSendBuildFinish(buildList[1].uuid)
    end
    local posEnd = buildList[1].pointId
    local stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(tonumber(buildId))
    local isArrow
    local index = 1
    if stationId ~= nil then
      local stationData = DataCenter.HeroStationManager:GetStationData(stationId)
      local heroUuids = stationData:GetHeroUuids()
      local emptySlot = DataCenter.HeroStationManager:GetEmptySlotList(stationId)
      local lockedSlot = DataCenter.HeroStationManager:GetLockedSlotList(stationId)
      if #heroUuids < questTemplate.para2 then
        if next(emptySlot) then
          isArrow = 1
        elseif next(lockedSlot) then
          isArrow = 3
        end
      else
        for i = 1, #heroUuids do
          local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuids[i])
          if heroData.level < tonumber(questTemplate.para3) then
            index = i
            break
          end
        end
        isArrow = 2
      end
    end
    DataCenter.BuildManager:CheckSendBuildFinish(buildList[1].uuid)
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      GoToUtil.GotoOpenView(UIWindowNames.UIHeroStation, stationId, isArrow, false, index)
    end)
  else
    GoToUtil.GotoCityByBuildId(buildId)
    return
  end
end

local function GoHeroStationScores(questTemplate)
  local buildId = questTemplate.para1
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  GoToUtil.CloseAllWindows()
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    local stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(tonumber(buildId))
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      GoToUtil.GotoOpenView(UIWindowNames.UIHeroStation, stationId, nil, false, nil, questTemplate)
    end)
  else
    GoToUtil.GotoCityByBuildId(buildId)
  end
end

local function GoHospital(questTemplate)
  local buildId = questTemplate.para1
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      local isArrow = 1
      GoToUtil.GotoOpenView(UIWindowNames.UIHospital, isArrow)
    end)
  else
    GoToUtil.GotoCityByBuildId(buildId)
  end
end

local function GoPveLevel(pveLevelId)
  local data = DataCenter.LandLockManager:CheckLandLockPriorState(pveLevelId, LandLockState.Finished, true)
  if data then
    local pointId = data:GetCenterPointId()
    local bubbleObj = DataCenter.LandLockBubbleManager:GetLandLockBubble(data.id)
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      if bubbleObj then
        local template = DataCenter.LandLockManager:GetTemplate(data.id)
        WorldArrowManager:GetInstance():ShowArrowEffect(0, bubbleObj.transform.position + Vector3.New(0, template.height, 0), ArrowType.LandLock)
      else
        WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(pointId))
      end
    end)
  end
end

local function LookAtFirstCanUnlockLandLockByPve(pveLevelId)
  local firstData = DataCenter.LandLockManager:GetLandLockDataByPve(pveLevelId)
  if firstData == nil then
    return
  end
  local queue = {
    firstData.id
  }
  while table.count(queue) > 0 do
    local id = table.remove(queue, 1)
    local data = DataCenter.LandLockManager:GetLandLockDataById(id)
    if data ~= nil then
      if data.state == LandLockState.Locked or data.state == LandLockState.Unlocked then
        GoToUtil.GoPveLevel(data:GetCurPve())
        return
      elseif data.state == LandLockState.Hide then
        for _, priorId in ipairs(data.priorList) do
          table.insert(queue, priorId)
        end
      end
    end
  end
end

local function GoGiftMall()
  GoToUtil.GotoOpenView(UIWindowNames.LWBuyDiamond, {anim = true})
end

local function GoBagPackUseItem(itemId)
  GoToUtil.GotoOpenView(UIWindowNames.UICapacityTable, UICapacityTableTab.Item, itemId)
end

local function GoSearchEnemy(goPara)
  SFSNetwork.SendMessage(MsgDefines.FindEnemyPoint, tonumber(goPara[1]))
end

local function GoGarageUpgrade(goPara)
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(goPara[1]))
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      GoToUtil.GotoOpenView(UIWindowNames.UIGarageRefit, tonumber(goPara[1]), tonumber(goPara[2]))
    end)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityByBuildId(tonumber(goPara[1]))
  end
end

local function GotoDragonBuildPos(self)
  GoToUtil.GotoDragonPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetBattleFieldPos(), ForceChangeScene.World), CS.SceneManager.World.InitZoom)
end

local function GotoMainBuildPos(self)
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World), CS.SceneManager.World.InitZoom, nil, function()
    DataCenter.CityRebuildAniManager:ChangeToWorldEvent()
  end, LuaEntry.Player:GetSelfServerId())
end

local function FindMonster(level)
  SFSNetwork.SendMessage(MsgDefines.FindMonster, LuaEntry.Player:GetMainWorldPos(), level, false)
end

local function GotoGuluBox(self)
  local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
  if 0 < #list then
    GoToUtil.CloseAllWindows()
    local pointId = list[1].pointId
    local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, pos)
    end)
    return true
  end
  return false
end

local function GotoColdStorage(itemId)
  local function DoGotoColdStorage(itemId)
    local resourceItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
    
    if resourceItemTemplate ~= nil then
      if resourceItemTemplate.monster ~= nil and resourceItemTemplate.monster ~= "" then
        local monsterType, monsterMinLv, monsterMaxLv = resourceItemTemplate:GetMonsterJumpParam()
        if monsterType ~= nil and monsterMinLv ~= nil and monsterMaxLv ~= nil then
          if monsterType == ResourceItemMonsterJumpType.MonsterJumpType_Monster then
            if GoToUtil.GotoGuluBox() == false then
              GoToUtil.FindMonster(monsterMaxLv)
            end
          elseif monsterType == ResourceItemMonsterJumpType.MonsterJumpType_Boss then
            GoToUtil.GotoBossMonsterBetweenLv(monsterMinLv, monsterMaxLv)
          end
        end
        return
      end
      local buildType = toInt(resourceItemTemplate.building)
      if buildType == BuildingTypes.APS_BUILD_FARM_FIELD then
        GotoFarmGet(itemId, true)
      elseif buildType == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildType == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildType == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
        GotoPasture(buildType)
      elseif DataCenter.BuildManager:IsFactoryBuild(buildType) then
        GoToUtil.GotoCityByBuildId(buildType)
      end
    elseif itemId == ResourceType.Wood or itemId == ResourceType.Metal then
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_HERO_BAR, WorldTileBtnType.LevelExplore)
    end
  end
  
  if CS.SceneManager.IsInPVE() then
    DataCenter.BattleLevel:Exit(function()
      DoGotoColdStorage(itemId)
    end)
  else
    DoGotoColdStorage(itemId)
  end
end

local function GoToPlayerLevel(level)
  DataCenter.PlayerLevelManager:SetScrollToLevel(level)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerLevel, 1)
end

local function GoToPlayerCareer()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerLevel, 2)
end

local function GoToStorageShop(playerUid, targetTab)
  GoToUtil.CloseAllWindows()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, playerUid, targetTab)
end

local function GoToGarageRefit(garage)
  GoToUtil.CloseAllWindows()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGarageRefit, garage)
end

local function GoToCareerSelect(onClose)
  GoToUtil.CloseAllWindows()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICareerSelect, onClose)
end

local function GotoFastBuildList(buildingType)
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
    local main = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if main ~= nil and main.View ~= nil then
      GoToUtil.CloseAllWindows()
      main.View:expendFastBuildAndPointTo(buildingType)
    end
  end
end

local function GoToCurObstacle(nowShowArrow)
  local obstacle = DataCenter.MonopolyManager:GetCurObstacle()
  if not obstacle then
    return
  end
  local data = obstacle.data
  if not data then
    return
  end
  GoToUtil.GotoPos(data:GetCenterWorldPos(), CS.SceneManager.World.InitZoom, 0.5, function()
    if nowShowArrow then
      return
    end
    local param = {}
    param.position = CS.CSUtils.WorldPositionToUISpacePosition(data:GetCenterWorldPos())
    param.arrowType = ArrowType.Building
    param.positionType = PositionType.Screen
    DataCenter.ArrowManager:ShowArrow(param)
  end)
end

local function GoLandLockById(id, ignorePrior, notShowArrow)
  local data
  if ignorePrior then
    data = DataCenter.LandLockManager:GetLandLockDataById(id)
  else
    data = DataCenter.LandLockManager:CheckLandLockPriorState(id, LandLockState.Finished)
  end
  if data then
    local bubbleObj = DataCenter.LandLockBubbleManager:GetLandLockBubble(data.id)
    local pos = data:GetCenterWorldPos()
    if bubbleObj then
      pos.x = bubbleObj.root_anim.transform.position.x
    else
      local landLockObj = DataCenter.LandLockManager:GetLandLockObj(data.id)
      if landLockObj then
        pos = landLockObj:GetBubbleCenterPos()
      end
    end
    local isArrow = false
    if SceneUtils.GetIsInCity() then
      isArrow = true
    end
    GoToUtil.GotoCityPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      if notShowArrow then
        return
      end
      if isArrow then
        if bubbleObj then
          local template = DataCenter.LandLockManager:GetTemplate(data.id)
          local posBubble = bubbleObj.transform.position
          posBubble.x = bubbleObj.root_anim.transform.position.x
          WorldArrowManager:GetInstance():ShowArrowEffect(0, posBubble + Vector3.New(0, template.height, 0), ArrowType.LandLock)
        else
          WorldArrowManager:GetInstance():ShowArrowEffect(0, pos)
        end
      end
    end)
  end
  return data
end

local function GoUnlockedTile_Newbies()
  local dataList = DataCenter.LandLockManager:GetLandLockDataListByState(LandLockState.Any)
  table.sort(dataList, function(a, b)
    local template1 = DataCenter.LandLockManager:GetTemplate(a.id)
    local template2 = DataCenter.LandLockManager:GetTemplate(b.id)
    if template1.order < template2.order then
      return true
    end
    return false
  end)
  for _, v in ipairs(dataList) do
    if v.state == LandLockState.Unlocked or v.state == LandLockState.Locked then
      return v
    end
  end
end

local function GoUnlockedTile()
  local dataList = DataCenter.LandLockManager:GetLandLockDataListByState(LandLockState.Any)
  table.sort(dataList, function(a, b)
    local template1 = DataCenter.LandLockManager:GetTemplate(a.id)
    local template2 = DataCenter.LandLockManager:GetTemplate(b.id)
    if template1.order < template2.order then
      return true
    end
    return false
  end)
  for _, v in ipairs(dataList) do
    if v.state == LandLockState.Unlocked or v.state == LandLockState.Locked then
      GoToUtil.GoLandLockById(v.id)
      return v
    end
  end
end

local function GoLockMonster(questTemplate)
  local data = DataCenter.MonsterLockDataManager:GetMonsterData(tonumber(questTemplate.para1))
  if data == nil then
    return
  end
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(data.pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    local bubble = DataCenter.MonsterLockBubbleManager:GetMonsterLockBubble(tonumber(questTemplate.para1))
    if bubble ~= nil then
      bubble:SetActive(false)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
      local str = "" .. ";" .. data.pointId .. ";" .. "" .. ";" .. WorldPointUIType.MonsterLock .. ";" .. "0" .. ";" .. "0"
      EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, 0, data.pointId, "", WorldPointUIType.MonsterLock, 0, 0)
    end
  end)
end

local function GoHeroTrust(questTemplate)
  local worldPos = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustPosition(tonumber(questTemplate.gopara[1]))
  if worldPos then
    local bubbleObj = DataCenter.HeroEntrustBubbleManager:GetHeroEntrustBubbleById(tonumber(questTemplate.gopara[1]))
    if bubbleObj ~= nil then
      worldPos = bubbleObj.transform.position
    end
    GoToUtil.GotoCityPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      if bubbleObj then
        local param = {}
        param.position = worldPos
        param.position.x = param.position.x + 1
        param.position.y = param.position.y - 2
        param.positionType = PositionType.World
        param.isAutoClose = 3
        DataCenter.ArrowManager:ShowFingerArrow(param)
      end
    end)
  end
end

local function GotoPos(worldPos, zoom, time, onComplete, serverId, worldId)
  if LuaEntry.Player:GetCurWorldId() > 0 then
    return
  end
  local zoomSize = zoom
  if zoomSize == nil then
    zoomSize = CS.SceneManager.World.InitZoom
  end
  local changeTime = time
  if changeTime == nil then
    changeTime = LookAtFocusTime
  end
  local oldComplete = onComplete
  
  function onComplete()
    local theWorld = CS.SceneManager.World
    if theWorld ~= nil and CS.SceneManager:IsInWorld() then
      theWorld:UpdateViewRequest(true)
    end
    if oldComplete ~= nil then
      pcall(oldComplete)
    end
  end
  
  local nServerId = tonumber(serverId)
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local gotoServerId = nServerId or curServerId
  if gotoServerId ~= nil and 0 < gotoServerId and CS.SceneManager:IsInWorld() then
    local seasonInfo = SeasonUtil.GetSeasonInfo(gotoServerId)
    if seasonInfo and seasonInfo:GetServerType(false) == SeasonMapType.NineNation then
      local mapIndex = seasonInfo:GetNinePalacesIndex(gotoServerId)
      local x, y, z = SceneUtils.GetNinePalacesOffsetByIndex(mapIndex)
      if x ~= nil and z ~= nil then
        worldPos.x = worldPos.x % 2000 + x
        worldPos.z = worldPos.z % 2000 + z
      end
      if seasonInfo:IsInBattleServerGroupInt(curServerId) and not seasonInfo.isSingleServerMode then
        CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
        return
      end
    end
  end
  if nServerId ~= nil and 0 < nServerId and selfServerId ~= nServerId then
    local crossServerId = LuaEntry.Player:GetCrossServerId()
    if crossServerId ~= serverId then
      GoToUtil.CheckCrossWar(curServerId)
      CrossServerUtil.OnCrossServer(serverId)
    end
    CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
  elseif CrossServerUtil:GetIsCrossServer() then
    GoToUtil.CheckCrossWar(curServerId)
    CrossServerUtil.OnBackSelfServer()
    CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
  else
    CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
  end
end

local function GotoPosForDragon(worldPos, zoom, time, onComplete, serverId, worldId, worldType)
  if CS.SceneManager.World ~= nil then
    local zoomSize = zoom
    if zoomSize == nil then
      zoomSize = CS.SceneManager.World.InitZoom
    end
    local changeTime = time
    if changeTime == nil then
      changeTime = LookAtFocusTime
    end
    local selfServerId = LuaEntry.Player:GetSelfServerId()
    local curWorldId = LuaEntry.Player:GetCurWorldId()
    EventManager:GetInstance():Broadcast(EventId.GOTO_WORLD_POSITION)
    if 0 < curWorldId then
      if worldId ~= nil and 0 < worldId and worldId == curWorldId then
        CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
      elseif worldId == nil or worldId == 0 then
        CrossServerUtil.OnBackSelfServerFromDragonWorld()
        CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
      end
    elseif worldId ~= nil and 0 < worldId then
      if worldId ~= curWorldId and serverId ~= nil and selfServerId ~= serverId and 0 < serverId then
        local curWorldType = worldType
        if curWorldType == nil then
          curWorldType = LuaEntry.Player:GetCurWorldType()
        end
        CrossServerUtil.OnGotoDragonWorld(serverId, worldId, curWorldType, worldPos)
        CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
      end
    elseif serverId ~= nil and selfServerId ~= serverId and 0 < serverId then
      local crossServerId = LuaEntry.Player:GetCrossServerId()
      if crossServerId ~= serverId then
        GoToUtil.CheckCrossWar(LuaEntry.Player:GetCurServerId())
        CrossServerUtil.OnCrossServer(serverId)
      end
      CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
    elseif CrossServerUtil:GetIsCrossServer() then
      GoToUtil.CheckCrossWar(LuaEntry.Player:GetCurServerId())
      CrossServerUtil.OnBackSelfServer()
      CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
    else
      CS.SceneManager.World:AutoLookat(worldPos, zoomSize, changeTime, onComplete)
    end
  end
end

local function GotoDragonPos_private(worldPos, zoom, time, onComplete, serverId, worldId, worldType)
  local pos = worldPos
  local lookZoom = 105
  local lookTime = time
  local action = onComplete
  local targetSId = serverId or LuaEntry.Player:GetCurServerId()
  local wId = worldId or LuaEntry.Player:GetCurWorldId()
  if wId == nil or wId == 0 then
    wId = LuaEntry.Player:GetCurWorldId()
  end
  local wType = worldType or LuaEntry.Player:GetCurWorldType()
  if wType == nil or wType == 0 then
    wType = LuaEntry.Player:GetCurWorldType()
  end
  if CS.SceneManager:IsInWorld() then
    lookZoom = CS.SceneManager.World.Zoom
    if toInt(lookZoom) > 250 then
      lookZoom = 105
    end
  end
  SceneUtils.ChangeToWorld(function()
    GoToUtil.GotoPosForDragon(pos, lookZoom, lookTime, action, targetSId, wId, wType)
  end)
end

local function GotoDragonPos(worldPos, zoom, time, onComplete, serverId, worldId, worldType)
  if worldType == nil or worldType == 0 then
    worldType = BattleFieldUtil.GetCurBattleFieldType()
  end
  if serverId ~= nil and serverId ~= LuaEntry.Player:GetCurServerId() then
    if BattleFieldUtil.InBattleField() or BattleFieldUtil.CheckCanGotoBattleField(serverId, worldId, worldType) then
      UIUtil.PlayCutSceneAnim(function()
        GotoDragonPos_private(worldPos, zoom, time, onComplete, serverId, worldId, worldType)
      end, nil, serverId)
    end
  elseif BattleFieldUtil.InBattleField() or BattleFieldUtil.CheckCanGotoBattleField(serverId, worldId, worldType) then
    GotoDragonPos_private(worldPos, zoom, time, onComplete, serverId, worldId, worldType)
  end
end

local function GotoBattlefield(args)
  GoToUtil.GotoDragonPos(args.worldPos, args.zoom, args.time, args.onComplete, args.serverId, args.worldId, args.worldType)
end

local function GotoCityPos_private(cityPos, zoom, time, onComplete)
  local pos = cityPos
  local lookZoom = zoom
  local lookTime = time
  local action = onComplete
  SceneUtils.ChangeToCity(function()
    GoToUtil.GotoPos(pos, lookZoom, lookTime, action)
  end)
end

local function GotoCityPos(cityPos, zoom, time, onComplete)
  if LuaEntry.Player:IsInSelfServer() then
    GotoCityPos_private(cityPos, zoom, time, onComplete)
  else
    UIUtil.PlayCutSceneAnim(function()
      GotoCityPos_private(cityPos, zoom, time, onComplete)
    end, nil, LuaEntry.Player:GetSelfServerId())
  end
end

local function GotoWorldPos_private(worldPos, zoom, time, onComplete, serverId, worldId, worldType)
  local pos = Vector3.New(worldPos.x, worldPos.y, worldPos.z)
  local lookZoom = zoom
  local needReacquireZoom = CS.SceneManager:IsInCity() and zoom == CS.SceneManager.World.InitZoom
  local lookTime = time
  local action = onComplete
  local targetSId = serverId or LuaEntry.Player:GetSelfServerId()
  local targetWorldId = toInt(worldId or 0)
  local targetWorldType = worldType
  if targetWorldType == nil then
    targetWorldType = LuaEntry.Player:GetCurWorldType()
  end
  if targetWorldId == 0 and BattleFieldUtil.InBattleField() then
    CrossServerUtil.OnBackSelfServerFromDragonWorld()
    EventManager:GetInstance():Broadcast(EventId.OnEnterWorld)
  end
  local noSendReq = targetSId ~= LuaEntry.Player:GetCurServerId()
  SceneUtils.ChangeToWorld(function()
    if needReacquireZoom then
      lookZoom = CS.SceneManager.World.InitZoom
    end
    if targetWorldId ~= nil and targetWorldId ~= 0 then
      GoToUtil.GotoPosForDragon(pos, lookZoom or 105, lookTime, action, targetSId, targetWorldId, worldType)
    else
      GoToUtil.GotoPos(pos, lookZoom, lookTime, action, targetSId, targetWorldId)
    end
  end, noSendReq)
end

local function GotoWorldPos(worldPos, zoom, time, onComplete, serverId, worldId, worldType)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local curServerId = LuaEntry.Player:GetCurServerId()
  if serverId == nil and loginServerId ~= curServerId then
    serverId = loginServerId
  end
  if serverId ~= nil and serverId ~= 0 and serverId ~= curServerId then
    if BattleFieldUtil.CheckCanGotoBattleField(serverId, worldId, worldType) then
      local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
      if isBigMapMode and curSameGroup then
        local config = SeasonUtil.GetSeasonInfo(curServerId)
        if config ~= nil and config.isSingleServerMode then
        else
          GotoWorldPos_private(worldPos, CS.SceneManager.World.Zoom, time, onComplete, serverId, worldId, worldType)
          return
        end
      end
      if GoToUtil.GoToServerPreCheck(serverId) then
        if BattleFieldUtil.InBattleField() and serverId < 9000 then
          CrossServerUtil.OnBackSelfServerFromDragonWorld()
        end
        local toServerId = toInt(serverId)
        UIUtil.PlayCutSceneAnim(nil, function()
          local theSeasonInfo = SeasonUtil.GetSeasonInfo(toServerId)
          if theSeasonInfo ~= nil then
            if theSeasonInfo.seasonId ~= 0 and GoToUtil.CheckSeasonResourceStatus(theSeasonInfo, curServerId, toServerId) == false then
              UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCloud, {anim = true})
              return false
            end
            SeasonWorldSkinUtil.ChangeWorldSkin(toServerId)
            GotoWorldPos_private(worldPos, zoom, time, onComplete, toServerId, worldId, worldType)
            return true
          end
          return false
        end, toServerId)
      end
    end
  elseif BattleFieldUtil.CheckCanGotoBattleField(serverId, worldId, worldType) then
    GotoWorldPos_private(worldPos, zoom, time, onComplete, serverId, worldId, worldType)
  end
end

function GoToUtil.CheckSeasonResourceStatus(seasonInfo, fromServerId, toServerId)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if CS.UnityEngine.Application.isEditor or toServerId == loginServerId then
    return true
  end
  if toServerId and seasonInfo then
    local thePackageId = seasonInfo:GetPackageId(false)
    if thePackageId == 0 or SeasonUtil.IsSeasonResDownloaded(thePackageId) then
      return true
    end
    TimerManager:GetInstance():DelayInvoke(function()
      local winName = UIWindowNames.UILWSeasonResourceDownload
      UIManager:GetInstance():OpenWindow(winName, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, thePackageId, toServerId, true)
      Logger.LogInfo(string.format("CheckSeasonResourceByServerId %s %s %s DelayInvoke", fromServerId, toServerId, thePackageId))
    end, 0.18)
    return false
  end
  return true
end

function GoToUtil.GotoMarchCurPos(marchInfo, zoom, callback)
  if marchInfo == nil then
    return
  end
  SceneUtils.ChangeToWorld(function()
    local GotoFunction = GoToUtil.GotoWorldPos
    local serverId = marchInfo.serverId
    local worldId = marchInfo.worldId
    local worldPos = marchInfo:GetMarchCurPos()
    if 0 < worldId then
      GotoFunction = GoToUtil.GotoDragonPos
    else
      local data = SeasonUtil.GetSeasonInfo(serverId)
      if data then
        local s = data:GetServerIdFromWorldPos(worldPos)
        if s ~= 0 then
          serverId = s
        end
      end
    end
    GotoFunction(worldPos, zoom, nil, callback, serverId, worldId, marchInfo:GetWorldType())
  end)
end

function GoToUtil.GotoServerZone(serverId, isInMoveToState)
  local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
  if seasonInfo == nil or seasonInfo:GetServerType(false) ~= SeasonMapType.NineNation then
    return
  end
  LuaEntry.Player:SendGetOtherServerInfo(serverId)
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
  if not isBigMapMode or not curSameGroup then
    DataCenter.WorldAllianceCityDataManager:TryFetchStrongholdBattleState(serverId)
    DataCenter.WorldAllianceCityDataManager:TryFetchTradeStationState(serverId)
    return
  end
  if isInMoveToState then
    local selfServerId = LuaEntry.Player:GetSelfServerId()
    if serverId == selfServerId then
      LuaEntry.Player:SetCrossServerId(-1)
    else
      LuaEntry.Player:SetCrossServerId(serverId)
    end
    DataCenter.WorldAllianceCityDataManager:TryFetchStrongholdBattleState(serverId)
    DataCenter.WorldAllianceCityDataManager:TryFetchTradeStationState(serverId)
    DataCenter.LWWorldZoneChangeTipManager:ShowServerChangeTip(serverId)
    DataCenter.LandlordMgr:RefreshServerChange()
    return
  end
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  if serverId == selfServerId then
    LuaEntry.Player:SetCrossServerId(-1)
    EventManager:GetInstance():Broadcast(EventId.OnQuitCrossServer)
  else
    LuaEntry.Player:SetCrossServerId(serverId)
    EventManager:GetInstance():Broadcast(EventId.OnEnterCrossServer)
  end
  GoToUtil.CheckCrossWar(serverId)
  CS.SceneManager.World:UpdateViewRequest(true)
  EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
  DataCenter.WorldAllianceCityDataManager:UpdateAllCityDataRequest(nil, serverId)
  DataCenter.ActMeteoriteBattleManager:RequestMeteoriteWorldInfo()
  DataCenter.LWWorldZoneChangeTipManager:ShowServerChangeTip(serverId)
  DataCenter.LandlordMgr:RefreshServerChange()
end

local function CheckCrossWar(serverId)
  local list = {}
  local allianceList = DataCenter.AllianceWarDataManager:GetAllianceWarIdList()
  local personalList = DataCenter.RadarAlarmDataManager:GetAllMarches()
  if allianceList and serverId ~= LuaEntry.Player:GetSelfServerId() then
    for i = 1, #allianceList do
      local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(allianceList[i])
      if info.targetUid == LuaEntry.Player:GetUid() and info.server == serverId then
        table.insert(list, allianceList[i])
      end
    end
  end
  if personalList then
    for _, v in pairs(personalList) do
      local temp = DataCenter.AllianceWarDataManager:GetWarningType(v)
      if temp == WarningType.Attack and v.serverId == serverId then
        table.insert(list, v)
      end
    end
  end
  if next(list) then
    DataCenter.AllianceWarDataManager:AddCrossServer(serverId)
  else
    DataCenter.AllianceWarDataManager:ClearCrossServer(serverId)
  end
end

local function GoTriggerPve(goPara)
  local trigger
  for i = 1, #goPara do
    local str = string.split(goPara[i], ",")
    local isGoto = true
    for k = 1, #str do
      local temp = DataCenter.BattleLevel:GetTriggerByTriggerId(tonumber(str[k]))
      if temp then
        local isFinish = DataCenter.BattleLevel:IsFinishTrigger(tonumber(str[k]))
        if isFinish then
          isGoto = false
        end
      end
    end
    if isGoto then
      trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(tonumber(str[1]))
      if trigger then
        local isFinish = DataCenter.BattleLevel:IsFinishTrigger(tonumber(goPara[i]))
        if not isFinish then
          local pos = trigger:GetPosition()
          local cameraParam = DataCenter.BattleLevel:GetCameraParam()
          local height = cameraParam and cameraParam.height and cameraParam.height or Const.CameraParam.HeroExp[1].height
          local battleLevel = DataCenter.BattleLevel
          battleLevel:GetPlayer():PauseCameraFollow()
          battleLevel:AutoLookat(pos, height, 0.4)
          TimerManager:GetInstance():DelayInvoke(function()
            battleLevel:AddOneArrow(pos)
          end, 0.4)
          TimerManager:GetInstance():DelayInvoke(function()
            battleLevel:GetPlayer():ResumeCameraFollow()
            battleLevel:RemoveOneArrowByPos(pos)
          end, 2)
          break
        end
      end
    end
  end
end

local function GoLandPve(pos)
  local cameraParam = DataCenter.BattleLevel:GetCameraParam()
  local height = cameraParam and cameraParam.height and cameraParam.height or Const.CameraParam.HeroExp[1].height
  local battleLevel = DataCenter.BattleLevel
  battleLevel:GetPlayer():PauseCameraFollow()
  battleLevel:AutoLookat(pos, height, 0.4)
  TimerManager:GetInstance():DelayInvoke(function()
    battleLevel:AddOneArrow(pos)
  end, 0.4)
  TimerManager:GetInstance():DelayInvoke(function()
    battleLevel:GetPlayer():ResumeCameraFollow()
    battleLevel:RemoveOneArrowByPos(pos)
  end, 2)
end

local function GoEnergy(buildId)
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoCityByBuildId(buildId)
  if CS.SceneManager:IsInCity() then
    TimerManager:GetInstance():DelayInvoke(function()
      local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.EnergyOrder, buildId)
      if obj then
        WorldArrowManager:GetInstance():ShowArrowEffect(0, obj.transform.position, ArrowType.Building)
      end
    end, LookAtFocusTime)
  end
end

local function CheckActIdInOffSeasonViewAndOpen(actId)
  local result = false
  local mainLv = DataCenter.BuildManager.MainLv
  if not mainLv or not (mainLv >= SEASON_MIN_LEVEL) then
    return result
  end
  local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
  local seasonTempData = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if not config or not seasonTempData then
    return result
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local truceEnterStartTime = 0
  local truceEnterEndTime = 0
  if seasonTempData.truceEnterStartTime and seasonTempData.truceEnterEndTime then
    local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if info then
      local zeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(info.seasonStartTime // 1000)
      truceEnterStartTime = zeroTime + seasonTempData.truceEnterStartTime * 24 * 60 * 60
      truceEnterEndTime = zeroTime + seasonTempData.truceEnterEndTime * 24 * 60 * 60
    end
  end
  if curTime < truceEnterEndTime and curTime > truceEnterStartTime then
    local isHave = false
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
    if actData then
      for k, v in pairs(seasonTempData.truceEnterActivityList) do
        if v == actId then
          isHave = true
          break
        end
      end
    end
    if isHave then
      result = true
      local titleTxt = Localization:GetString(seasonTempData.truce_name)
      if actData.type == EnumActivity.ActTrends.Type then
        UIManager:GetInstance():OpenWindow(UIWindowNames.SingleActivityContainerType2, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, actId, nil)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, actId, titleTxt)
      end
      return result
    end
  end
  return result
end

local function GoActWindow(data, closeAllWindow)
  local closeAll = true
  if closeAllWindow ~= nil then
    closeAll = closeAllWindow
  end
  if closeAll then
    GoToUtil.CloseAllWindows()
  end
  if table.count(data) == 1 then
    local actId = data[1]
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(actId))
    if not actData then
      UIUtil.ShowTipsId(801141)
      return
    end
    if not DataCenter.ActivityListDataManager:CheckIfActivityOpen(nil, tonumber(actId)) then
      UIUtil.ShowTipsId(801141)
      return
    end
    if actData.type == EnumActivity.InfiniteGift.Type then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWInfiniteGift, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, actId, 3)
      return
    end
    if actData.type == EnumActivity.ActDragon.Type or actData.type == EnumActivity.ActWinterStorm.Type or actData.type == EnumActivity.ActMeteorite.Type then
      RaceEntranceUtil.GotoOpenView(actData.type)
      return
    end
    local isActOpen = GoToUtil.CheckActIdInOffSeasonViewAndOpen(tonumber(actId))
    if isActOpen then
      return
    end
    if actData.hideInActivityPanel then
      if actData.is_package == ActivityEntranceType.ThemeActivity then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIThemeActivityTable, {anim = true}, actId)
      elseif actData.festivalEntrance <= 0 then
        local tagInfo = WelfareController.getTagInfoByActId(tostring(actId))
        if tagInfo then
          local entryType = tagInfo:getEntryType()
          if entryType then
            local windowOpen = UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWBuyDiamond)
            if windowOpen then
              EventManager:GetInstance():Broadcast(EventId.ShopGotoPage, tagInfo:getID())
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {
                anim = false,
                UIMainAnim = UIMainAnimType.AllHide
              }, nil, tagInfo:getID())
            end
          end
        end
      elseif actData.festivalEntrance > 0 then
        local groupId = actData.festivalEntrance
        if groupId and groupId == CommonActivityGroupEnum.Alliance then
          GoToUtil.CloseAllWindows()
          if LuaEntry.Player:IsInAlliance() == false then
            UIUtil.ShowTipsId("300707")
            local params = {guide = false}
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
            return
          end
        end
        GoToUtil.OpenActivityCommonGroupWindow(groupId, actId)
      end
    else
      local windowOpen = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIActivityCenterTable)
      if windowOpen then
        EventManager:GetInstance():Broadcast(EventId.CommonActivityGotoPage, actId)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, actId)
      end
    end
  elseif table.count(data) == 2 then
    GoToUtil.OpenActivityCommonGroupWindow(data[1], data[2])
  end
end

local function OpenActivityCommonGroupWindow(groupId, actId)
  local lineData = LocalController:instance():getLine(TableName.Activity, actId)
  if lineData ~= nil and not string.IsNullOrEmpty(lineData.festival_interface_config) then
    local windowOpen = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFestivalActivityCommonGroupShow)
    if windowOpen then
      local gotoData = {}
      gotoData.groupId = groupId
      gotoData.actId = actId
      EventManager:GetInstance():Broadcast(EventId.CommonGroupActivityGotoPage, gotoData)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFestivalActivityCommonGroupShow, {anim = true}, groupId, actId)
    end
  else
    local windowOpen = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIActivityCommonGroupShow)
    if windowOpen then
      local gotoData = {}
      gotoData.groupId = groupId
      gotoData.actId = actId
      EventManager:GetInstance():Broadcast(EventId.CommonGroupActivityGotoPage, gotoData)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, {anim = true}, groupId, actId)
    end
  end
end

local function GoActWindowDontClose(data)
  GoToUtil.GoActWindow(data, false)
end

local function GoCityCollect(gopara)
  local template = DataCenter.CollectResourceTemplateManager:GetAllTemplate()
  if template then
    for k, v in pairs(template) do
      if v.resourceType == ResourceType.ResourceItem and tonumber(v.para) == gopara then
        local pointId = v:GetPointId()
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime)
        break
      end
    end
  end
end

local function GoFormation(goPara)
  EventManager:GetInstance():Broadcast(EventId.GoTroopListShow, goPara)
end

local function GetBuildState(buildId)
  local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
  local maxNum = DataCenter.BuildManager:GetMaxBuildNum(buildId)
  local curMaxNum = DataCenter.BuildManager:GetCurMaxBuildNum(buildId)
  if buildNum >= maxNum then
    return false
  end
  if buildNum >= curMaxNum then
    return false
  end
  local list = DataCenter.BuildManager:GetFoldUpBuildByBuildId(buildId)
  if list ~= nil and table.count(list) > 0 then
    return true
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    return buildTemplate:IsPreBuildConditionValid()
  end
  return false
end

local function GoCheckBuild(buildId, worldTileBtnType)
  local state = GoToUtil.GetBuildState(buildId)
  if state then
    GoToUtil.GotoBuildListByBuildId(buildId)
  else
    GoToUtil.GoToCityBuildByQuest(buildId, worldTileBtnType)
  end
end

local function GoHeroBag()
  GoToUtil.CloseAllWindows()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_PUB)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBag)
    end)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_RADAR_CENTER)
    return
  end
end

local function GoBuildOpenUpgrade(buildId, questTemplate)
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildList[1].uuid, nil, questTemplate.id)
    end)
  end
end

local function GoMainUIBtn(savePosType)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
    local pos = view:GetSavePos(savePosType)
    local param = {
      position = pos,
      positionType = PositionType.Screen,
      useLiteAnim = true
    }
    GoToUtil.CloseAllWindows()
    DataCenter.ArrowManager:ShowArrow(param)
  end
end

local function GoLWParkourBattle(levelId, count)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMap, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, {guidStageId = levelId})
end

local function GotoDabenPos()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    SceneUtils.ChangeToCity(function()
      local pos = SceneUtils.TileIndexToWorld(buildList[1].pointId) + Vector3.New(-10, -4, 4)
      GoToUtil.GotoCityPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        WorldArrowManager:GetInstance():ShowArrowEffect(0, pos, ArrowType.LandLock)
      end)
    end)
  end
end

local function DoPlayerAssistance(serverId, worldId, pointId)
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  local mainLv = DataCenter.BuildManager.MainLv
  local needMainLv = LuaEntry.DataConfig:TryGetNum("assistance_open", "k1", 0)
  if mainLv < needMainLv then
    UIUtil.ShowTips(Localization:GetString("121005", needMainLv))
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      local info = CS.SceneManager.World:GetPointInfo(pointId)
      if info ~= nil then
        MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_CITY, pointId, info.uuid)
      else
        DataCenter.WorldPointWaitOpenManager:SetWaitOpenPointData(pointId, "DoPlayerAssistance", nil)
      end
    end, serverId, worldId)
  end
end

local function TryJumpToWorld(linkMsg, callback)
  if linkMsg ~= nil and linkMsg.action == "Jump" then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local pointId = toInt(linkMsg.pointId)
    local serverId = linkMsg.server or linkMsg.serverId or LuaEntry.Player:GetCurServerId()
    local worldId = linkMsg.worldId or 0
    if linkMsg.t == PostType.HelpMePutAresMissile then
      if pointId == 0 and linkMsg.x ~= nil and linkMsg.y ~= nil then
        pointId = SceneUtils.TilePosToIndex(linkMsg, ForceChangeScene.World)
      end
      DoPlayerAssistance(serverId, worldId, pointId)
      return
    end
    local funGotoWorldPos = GoToUtil.GotoWorldPos
    if worldId ~= nil and worldId ~= 0 and 0 < worldId then
      funGotoWorldPos = GoToUtil.GotoDragonPos
    end
    if linkMsg.x ~= nil and linkMsg.y ~= nil then
      local v3 = SceneUtils.TileToWorld(linkMsg, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      funGotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        if callback then
          pcall(callback, v3, serverId, worldId)
        end
      end, serverId, worldId)
    elseif pointId ~= 0 then
      GoToUtil.CloseAllWindows()
      do
        local v3 = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
        funGotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
          if callback then
            pcall(callback, v3, serverId, worldId)
          end
        end, serverId, worldId)
      end
    end
  end
end

local function GotoCurrMonopolyCell(showArrow)
  local monoMgr = DataCenter.MonopolyManager
  if monoMgr and monoMgr.player and monoMgr.player.curId and monoMgr.mapDic then
    local cell = monoMgr.mapDic[monoMgr.player.curId]
    if cell and cell.obstacle and cell.obstacle.data then
      local pos = cell.obstacle.data:GetCenterWorldPos()
      GoToUtil.GotoCityPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        if showArrow then
          local param = {}
          param.position = CS.CSUtils.WorldPositionToUISpacePosition(pos)
          param.arrowType = ArrowType.Building
          param.positionType = PositionType.Screen
          DataCenter.ArrowManager:ShowArrow(param)
        end
      end)
    end
  end
end

local function GoToWindow(jumpWindowType, paral, isCloseAllWindow, activityId)
  if jumpWindowType == JumpWindowType.Shop then
    local tabId = tostring(paral)
    local tagInfo = WelfareController.getShowTagInfoById(tabId)
    if tagInfo and tagInfo:isShow() then
      local type = tagInfo._type
      if type then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, type)
      end
    end
  elseif jumpWindowType == JumpWindowType.Activity then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(tonumber(paral))
    if table.IsNullOrEmpty(actList) then
      UIUtil.ShowTipsId("E100172")
      return
    end
    local data
    if actList and activityId and 1 < #actList then
      for i = 1, #actList do
        local id = actList[i].activityId
        if actList[i]:IsValid() and id == tostring(activityId) then
          data = actList[i]
        end
      end
    elseif actList then
      for i = 1, #actList do
        if actList[i]:IsValid() then
          data = actList[i]
        end
      end
    end
    if data then
      GoToUtil.GoActWindow({
        data.id
      }, isCloseAllWindow)
      return true
    else
      UIUtil.ShowTipsId(458822)
    end
  elseif jumpWindowType == JumpWindowType.Other then
    if paral == OtherWindow.UIHeroQualityRecruit then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit)
    elseif paral == OtherWindow.UILWTrainScene then
      RailwayUtil.OpenUITrainList(TrainTab.Enemy)
    elseif paral == OtherWindow.UIAllyDuel then
      if DataCenter.AllianceCompeteDataManager:CanOpenAllyDuelUI() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuel, {anim = true}, LeagueMatchTab.Compete)
      end
    elseif paral == OtherWindow.UIGovernmentActivityMain then
      if LuaEntry.Player:IsInSourceServer() then
        local actData
        local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KingActivity.Type)
        if actList and 0 < #actList then
          actData = actList[1]
        end
        if actData ~= nil then
          UIUtil.ShowGovernmentActivityMain()
        else
          return false
        end
      else
        return false
      end
    elseif paral == OtherWindow.TacticalWeaponSkillChip then
      local type = DataCenter.TWSkillChipManager:IsFunctionUnlock() and TacticalWeaponPageType.SkillChip or TacticalWeaponPageType.Basic
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, type)
    elseif paral == OtherWindow.UIDispatchTaskMain then
      local isOpen = UIUtil.CheckDispatchTaskOpen()
      if isOpen then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskMain, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        })
      end
    elseif paral == OtherWindow.S1 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeason1Main, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    elseif paral == OtherWindow.BlackMarketeers then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, "SeasonMain")
    end
  end
end

local function GotoActShopWindow(actId, packGroup, costItemIds)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if not actInfo or not actInfo:IsValid() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, actId, packGroup, costItemIds)
end

local function GotoActShopWindowMission(actId)
  if not actId then
    return
  end
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if not actInfo or not actInfo:IsValid() then
    return
  end
  if actInfo.type == EnumActivity.ActMonopoly.Type then
    local canGotoPackShop = DataCenter.ActMonopolyDataManager:CanGotoPackShop(tonumber(actId))
    if canGotoPackShop then
      local sep1 = "|"
      local sep2 = ","
      local sep3 = ";"
      local costData = {}
      local costStr = actInfo.para_4
      local oneTypeCostStr = string.split(costStr, sep1)
      for i = 1, #oneTypeCostStr do
        local typeCostStr = oneTypeCostStr[i]
        local costRewardStr = string.split(typeCostStr, sep2)
        costData[i] = {}
        for j = 1, #costRewardStr do
          local rewardStr = costRewardStr[j]
          local rewardParam = string.split(rewardStr, sep3)
          if #rewardParam == 3 then
            local type = tonumber(rewardParam[1])
            local itemId = tonumber(rewardParam[2])
            local count = tonumber(rewardParam[3])
            local rewardType = type
            if type == 1 then
              rewardType = ResTypeToReward[itemId]
            end
            local rewardData = {
              type = rewardType,
              itemId = itemId,
              count = count
            }
            table.insert(costData[i], rewardData)
          end
        end
      end
      local costData = costData[1] and costData[1][1] or nil
      local costId = costData and costData.itemId or nil
      GoToUtil.GotoActShopWindow(actId, DataCenter.ActMonopolyDataManager:GetKeyGiftPackId(tonumber(actId)), costId)
    else
      GoToUtil.GotoPay()
    end
  elseif actInfo.type == EnumActivity.BargainShop.Type then
    local info = DataCenter.ActBargainShopData:GetInfoByActId(actInfo.activityId)
    GoToUtil.GotoActShopWindow(actInfo.activityId, info:GetGiftPackId(), tonumber(actInfo.para_2))
  elseif actInfo.type == EnumActivity.ActSlotMachine.Type then
    local info = DataCenter.ActSlotMachineDataManager:GetActData(tonumber(actInfo.activityId))
    local costData = info.infoTemp.costData
    local costId = costData.itemId
    GoToUtil.GotoActShopWindow(actInfo.activityId, info:GetGiftPackId(), tonumber(costId))
  end
end

local function GoHeroDetails(heroId, jumpType)
  if heroId ~= "" then
    local pageType = HeroDetailGuideArrowType.Equip
    if jumpType then
      pageType = jumpType
    end
    local uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(toInt(heroId))
    if uuid ~= "" then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, uuid, {uuid}, nil, {arrowType = pageType})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroId, {heroId}, nil, {
        arrowType = HeroDetailGuideArrowType.Equip
      })
    end
  else
    GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

local function GoHeroUniqueWeaponPreview(heroId)
  local attrs, skills, previewSkills, maxLvTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevelWeaponoEffects(heroId)
  if not maxLvTemplate then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroUniqueWeaponPreview, {anim = true}, heroId)
end

local function GoHeroDetailsByItemId(itemId, jumpType)
  local item = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if item and item.para2 then
    local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(toInt(item.para2))
    if heroConfig then
      itemId = heroConfig.id
    end
  end
  GoHeroDetails(itemId, jumpType)
end

local function GotoWorkerRecruitView(isCloseAllWindow)
  local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Worker_Lottery)
  if not unlock then
    UIUtil.ShowTipsId(lockTips)
  else
    if isCloseAllWindow then
      GoToUtil.CloseAllWindows()
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, nil, nil, nil, nil, true)
  end
end

local function GotoTWSkillChipView()
  local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_TACTICAL_CENTER)
  if not build or build.level <= 0 then
    GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_TACTICAL_CENTER)
    return
  end
  if not DataCenter.TWSkillChipManager:IsFunctionUnlock() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.Basic, true)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.SkillChip)
  end
end

local function GotoTWView(type)
  type = type or TacticalWeaponPageType.Basic
  GoToUtil.CloseAllWindows()
  local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_TACTICAL_CENTER)
  if not build or build.level <= 0 then
    GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_TACTICAL_CENTER)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, type, true)
end

local function GotoSeasonWeekCardView()
  if SeasonUtil.IsInSeasonDesertMode() then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, "WeekCard")
  elseif SeasonUtil.IsInSeason() then
    GoToUtil.CloseAllWindows()
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.SeasonPeriodicCard.Type)
  else
    UIUtil.ShowTipsId("season_tips137")
  end
end

local function GotoSeasonSnowStormActivity()
  if SeasonUtil.IsInSeasonSnowMode() then
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.SnowStormComing.Type)
  else
    UIUtil.ShowTipsId("season_tips137")
  end
end

local function GotoSeasonBiuBiuActivity()
  if SeasonUtil.IsInSeasonNineNationMode() then
    local activityId
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.BiuBiu.Type)
    if dataList ~= nil and 0 < #dataList then
      activityId = tostring(dataList[1].id)
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSingleActivityContainer) then
        EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerOpenPanel, {activityId = activityId})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, activityId)
      end
    else
      UIUtil.ShowTipsId("season_tips137")
    end
  else
    UIUtil.ShowTipsId("season_tips137")
  end
end

local function GotoSeasonActivityView(act_type)
  local actId
  if SeasonUtil.IsInSeason() then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(act_type)
    if actList and 0 < #actList then
      for index, value in ipairs(actList) do
        if value.forSeason then
          actId = value.id
          break
        end
      end
    end
  end
  if actId then
    if SeasonUtil.IsInSeasonDesertMode() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, actId)
    else
      SeasonUtil.OpenSeasonActivityByType(act_type)
    end
  else
    UIUtil.ShowTipsId("season_tips137")
  end
end

local function GotoNearestCityStronghold(unowned)
  local host = 0
  if unowned then
    host = 2
  else
    host = 1
  end
  GoToUtil.GotoNearestCity(host, WorldAllianceCityType.Stronghold)
end

local function IsMyAllianceCity(serverId, cityId)
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
  for k, v in pairs(CrossOccupyCityList) do
    if v.serverId == serverId and v.cityId == cityId then
      return true
    end
  end
  return false
end

local function IsMyAllianceStronghold(serverId, cityId)
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
  for k, v in pairs(CrossOccupyStrongholdList) do
    if v.serverId == serverId and v.cityId == cityId then
      return true
    end
  end
  return false
end

local function GotoNearestCity(host, cityType, serverId)
  if LuaEntry.Player:GetMainWorldPos() < 0 then
    SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
    return
  end
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local mgr = DataCenter.AllianceCityTemplateManager
  local zoneId = SceneUtils.GetZoneIdByPosId(LuaEntry.Player:GetMainWorldPos())
  local startConfig = mgr:GetTemplate(zoneId, theServerId)
  local cityList = DataCenter.WorldAllianceCityDataManager:GetAllianceCityList(theServerId)
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local targetPos
  local visited = {}
  local queue = {startConfig}
  if host == 3 then
    local cityMeta
    local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
    local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
    if cityType == WorldAllianceCityType.City then
      local maxLevelCity
      for k, v in pairs(CrossOccupyStrongholdList) do
        if v.serverId == theServerId then
          cityMeta = mgr:GetTemplate(toInt(v.id), v.serverId)
          if cityMeta and cityMeta.nearBy then
            for _, value in pairs(cityMeta.nearBy) do
              local configNear = mgr:GetTemplate(value, theServerId)
              if configNear and configNear.type == cityType and (maxLevelCity == nil or maxLevelCity.level < configNear.level) and not IsMyAllianceCity(serverId, configNear.id) then
                maxLevelCity = configNear
                targetPos = configNear.pos
              end
            end
          end
        end
      end
    end
    if cityType == WorldAllianceCityType.Stronghold then
      local maxLevelCity
      for k, v in pairs(CrossOccupyCityList) do
        if v.serverId == theServerId then
          cityMeta = mgr:GetTemplate(toInt(v.id), v.serverId)
          if cityMeta and cityMeta.nearBy then
            for _, value in pairs(cityMeta.nearBy) do
              local configNear = mgr:GetTemplate(value, theServerId)
              if configNear and configNear.type == cityType and (maxLevelCity == nil or maxLevelCity.level < configNear.level) and not IsMyAllianceStronghold(serverId, configNear.id) then
                maxLevelCity = configNear
                targetPos = configNear.pos
              end
            end
          end
        end
      end
      for k, v in pairs(CrossOccupyStrongholdList) do
        if v.serverId == theServerId then
          cityMeta = mgr:GetTemplate(toInt(v.id), v.serverId)
          if cityMeta and cityMeta.nearBy then
            for _, value in pairs(cityMeta.nearBy) do
              local configNear = mgr:GetTemplate(value, theServerId)
              if configNear and configNear.type == cityType and (maxLevelCity == nil or maxLevelCity.level < configNear.level) and not IsMyAllianceStronghold(serverId, configNear.id) then
                maxLevelCity = configNear
                targetPos = configNear.pos
              end
            end
          end
        end
      end
    end
  end
  local loop = 0
  while targetPos == nil and 0 < #queue do
    local node = table.remove(queue, 1)
    if not visited[node.id] then
      loop = loop + 1
      visited[node.id] = true
      if host == 3 then
        if node.type == cityType then
          if cityList and cityList[node.id] then
            if cityList[node.id].allianceId ~= myAllianceId then
              targetPos = node.pos
              break
            end
          else
            targetPos = node.pos
            break
          end
        end
      elseif host == 2 then
        if node.type ~= cityType or cityList and cityList[node.id] then
        else
          targetPos = node.pos
          break
        end
      elseif host == 1 then
        if node.type == cityType and cityList and cityList[node.id] and cityList[node.id].allianceId ~= myAllianceId then
          targetPos = node.pos
          break
        end
      elseif node.type == cityType then
        targetPos = node.pos
        break
      end
      if node.nearBy then
        for key, value in pairs(node.nearBy) do
          local configNear = mgr:GetTemplate(value, theServerId)
          if configNear and not visited[configNear.id] then
            if configNear.type == cityType then
              table.insert(queue, configNear)
            else
              visited[configNear.id] = true
            end
          end
        end
      end
    end
    if 1000 < loop then
      Logger.LogError("loop count greater then " .. loop)
      break
    end
  end
  if targetPos == nil then
    local cfg = mgr:GetCityByLevel(1, theServerId, cityType)
    if cfg then
      targetPos = cfg.pos
    end
  end
  if targetPos then
    local worldPointPos = SceneUtils.TileToWorld(targetPos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2, nil, toInt(theServerId), 0)
  end
end

local function GotoEffectLack(type)
  GoToUtil.CloseAllWindows()
  if type == EffectLackGotoType.SeasonTrendMain then
    GoToUtil.GoToByTypeAndParam(QuestGoType.GoSeasonTrendMain)
  end
end

local function GotoHeroUniqueWepaon(heroId)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroData then
    local heroUuid = heroData.uuid
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, {
      arrowType = HeroDetailGuideArrowType.UniqueWeapon
    })
  else
    UIUtil.ShowTipsId("104226")
  end
end

local function GotoHeroAwaken(heroId)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroData and heroData:IsHeroAwakenOpen() then
    local heroUuid = heroData.uuid
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, {
      arrowType = HeroDetailGuideArrowType.HeroAwaken
    })
  else
    UIUtil.ShowTipsId("hero_awaken_tips_23")
  end
end

local function GoToCountBattleMap(lackToShowTips)
  GoToUtil.CloseAllWindows()
  local uuid
  local buildId = BuildingTypes.LW_BUILD_COUNT_BATTLE
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local maxLevel = -1
    for k, v in pairs(list) do
      local level = v.level
      if maxLevel < level then
        maxLevel = level
        uuid = v.uuid
      end
    end
  end
  if uuid == nil then
    if lackToShowTips then
      UIUtil.ShowTipsId("130004")
    else
      GoToUtil.GotoBuildListByBuildId(buildId)
    end
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData == nil then
    return
  end
  local isFinish = true
  if 0 >= buildData.destroyStartTime then
    isFinish = DataCenter.BuildManager:CheckSendBuildFinish(buildData.uuid)
  end
  SceneUtils.ChangeToCity(function()
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    local worldPointPos = BuildingUtils.GetBuildModelCenterVec(buildData.pointId, template.tileX, template.tileY)
    GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime)
    if not isFinish then
      return
    end
    local countBattleOpen = DataCenter.LWTrailTowerManager:CheckTabOpen(TrailTowerTabType.Common)
    local stageFeatureChapterOpen = DataCenter.LWTrailTowerManager:CheckTabOpen(TrailTowerTabType.StageFeatureChapter)
    local easyStageFeatureChapterOpen = DataCenter.LWTrailTowerManager:CheckTabOpen(TrailTowerTabType.EasyStageFeatureChapter)
    local integratedStageFeatureOpen = DataCenter.LWTrailTowerManager:CheckTabOpen(TrailTowerTabType.IntegratedStageFeatureChapter)
    local tab = TrailTowerTabType.None
    if integratedStageFeatureOpen then
      tab = TrailTowerTabType.IntegratedStageFeatureChapter
    elseif stageFeatureChapterOpen then
      tab = TrailTowerTabType.StageFeatureChapter
    elseif easyStageFeatureChapterOpen then
      tab = TrailTowerTabType.EasyStageFeatureChapter
    elseif countBattleOpen then
      tab = TrailTowerTabType.Common
    end
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanelWithScene(tab, true)
  end)
end

local function GotoHeroHonorWall(heroType)
  local typeBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[heroType])
  local unlockLevel = LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)
  if typeBuilding and unlockLevel <= typeBuilding.level then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHOF, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, heroType)
  else
    GoToUtil.GotoCityByBuildId(HeroTypeBuilding[heroType], WorldTileBtnType.City_Upgrade)
  end
end

local function GoToMilitaryCampPromotion(targetSoldierId)
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  if table.IsNullOrEmpty(buildDataList) then
    GoToUtil.GotoBuildListByBuildId({
      BuildingTypes.LW_BUILD_MILITARY_CAMP
    })
    return
  end
  table.sort(buildDataList, function(a, b)
    if a == nil or b == nil then
      if a == nil then
        return false
      else
        return true
      end
    end
    local aTraining = BuildingUtils.IsBuildingFunctioning(a)
    local bTraining = BuildingUtils.IsBuildingFunctioning(b)
    if aTraining ~= bTraining then
      return not aTraining
    end
    local aLevel = a.level
    local bLevel = b.level
    if aLevel ~= bLevel then
      return aLevel < bLevel
    end
  end)
  local isFind = false
  local maxTrainingLevel = 0
  local targetBuildingData
  local targetSoldierTemplate = DataCenter.SoldierDataManager:GetTemplate(targetSoldierId)
  local targetSoldierLevel = targetSoldierTemplate.lv or 1
  for i = 1, table.count(buildDataList) do
    local buildingData = buildDataList[i]
    local isFinishTraining = BuildingUtils.IsBuildingFinishFunctioning(buildingData)
    if not isFinishTraining then
      local buildingTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingData.itemId, buildingData.level)
      if buildingTemplate and buildingTemplate.para2 ~= "" then
        local soldierList = string.split(buildingTemplate.para2, "|")
        for j = 1, table.count(soldierList) do
          local soldierId = tonumber(soldierList[j])
          local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
          if soldierTemplate then
            local isUnlockSoldier = DataCenter.SoldierDataManager:IsUnlockSoldier(soldierId, buildingData.level)
            if isUnlockSoldier and maxTrainingLevel < soldierTemplate.lv then
              maxTrainingLevel = soldierTemplate.lv
            end
          end
        end
      end
      if targetSoldierLevel < maxTrainingLevel then
        isFind = true
        targetBuildingData = buildingData
        break
      end
    end
  end
  if not isFind then
    UIUtil.ShowTipsId("barrack_tips_busyTrylater_02")
  else
    local posEnd = targetBuildingData.pointId
    local jumpToParam = {}
    local isTraining = BuildingUtils.IsBuildingFunctioning(targetBuildingData)
    jumpToParam.openSoldierUpLevelPanel = not isTraining
    jumpToParam.soldierId = targetSoldierId
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISoldierDetails) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoldierDetails)
    end
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMilitaryCampPanel, {anim = true}, targetBuildingData.uuid, jumpToParam)
    end)
  end
end

local function GoToAllianceFurnace()
  GoToUtil.CloseAllWindows()
  if LuaEntry.Player:IsInAlliance() then
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType == SeasonMapType.Snow then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonStoveCenter, {anim = true, hideTop = true})
    elseif seasonType == SeasonMapType.Mummy then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMilitaryCenter, {anim = true, hideTop = true})
    else
      if seasonType == SeasonMapType.Darkness then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason4Center, {anim = true, hideTop = true})
      else
      end
    end
  else
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

local function GotoAllianceShop(shopId)
  GoToUtil.CloseAllWindows()
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  if not DataCenter.CommonShopManager.CanShowAllianceShop() then
    return false
  end
  if shopId ~= nil then
    local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.AllianceShop, shopId)
    if goodsConf == nil then
      return false
    end
    if goodsConf.count and goodsConf.count <= 0 then
      return false
    end
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.AllianceShop, shopId)
    if goodsConf.maxTimes and 0 < goodsConf.maxTimes then
      local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
      if boughtTimes >= goodsConf.maxTimes then
        return false
      end
    end
  end
  if shopId ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true, hideTop = true}, CommonShopType.AllianceShop, shopId)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true, hideTop = true}, CommonShopType.AllianceShop)
  end
  return true
end

local function GotoMigrationTicketShop()
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActMigration.Type)
  if actData == nil then
    return false
  end
  local openConfig = DataCenter.ActMigrationManager:GetOpenConfig()
  if not (openConfig ~= nil and openConfig.exchange_group) or openConfig.exchange_group <= 0 then
    UIUtil.ShowTipsId(2000655)
    return false
  end
  local giftPack = GiftPackManager.GetPacksByGroupId(openConfig.exchange_group, false)
  if table.IsNullOrEmpty(giftPack) then
    UIUtil.ShowTipsId(2000655)
    return false
  end
  local activityId = tonumber(actData.id or 0)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, activityId, openConfig.exchange_group, DataCenter.ActMigrationManager:GetItemId())
  return true
end

local function GoToSeasonCityList(index)
  if LuaEntry.Player:IsInAlliance() then
    if SeasonUtil.IsInSeason() then
      local seasonType = SeasonUtil.GetSeasonType()
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
      if SeasonUtil.SeasonHasCityStronghold(seasonType) then
        SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
      end
      if SeasonUtil.SeasonHasTradingStation(seasonType) then
        SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStationList)
      end
      SeasonUtil.ShowSeasonUI(UIWindowNames.UILWSeasonCityOccupyList, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, index)
    else
      SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityAttackCityDetail)
    end
  else
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

local function RequestAllianceMemberBasePoint(type, langKey)
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.AlFindTheMearestMember, type, langKey)
  else
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

local function GoToAllianceMemberBase(data, langKey)
  GoToUtil.CloseAllWindows()
  if data.pointId and data.serverId and data.uid then
    local pointId = data.pointId
    local serverId = data.serverId
    local uid = data.uid
    GoToUtil.MoveToWorldPointAndOpen(pointId, nil, uid)
  elseif langKey then
    UIUtil.ShowTipsId(langKey)
  else
    SceneUtils.ChangeToWorld()
  end
end

local function RequestNearestTradeStationWithoutLord(type, langKey)
  SFSNetwork.SendMessage(MsgDefines.GetNearTradePoint, 1)
end

local function RequestNearestTradeStationWithLord(type, langKey)
  SFSNetwork.SendMessage(MsgDefines.GetNearTradePoint, 2)
end

local function GoToCurWorldPoint(data)
  GoToUtil.CloseAllWindows()
  local pointId = data.pointId
  GoToUtil.MoveToWorldPoint(pointId)
end

local function PersonalArmsGoto(type, val)
  if type == ScoreType.TrainSolider then
    GoToUtil.CloseAllWindows()
    GoToUtil.GoBarracks()
  elseif type == ScoreType.SciencePowerUp then
    GoToUtil.OpenScienceQueue()
  elseif type == ScoreType.Shop then
    GoToUtil.GoGiftMall()
  elseif type == ScoreType.BuildPowerUp then
    GoToUtil:GotoFinishedBuilding()
  elseif type == ScoreType.Recruit then
    GoToUtil.GotoOpenView(UIWindowNames.UIHeroRecruit)
  elseif type == ScoreType.Speed then
    if val == SpeedScoreValue.Build then
      GoToUtil.GotoOpenView(UIWindowNames.UIBuildQueue)
    elseif val == SpeedScoreValue.Science then
      GoToUtil.OpenScienceQueue()
    elseif val == SpeedScoreValue.Soldier then
      GoToUtil.OpenMinTrainTimePanel()
    end
  elseif type == ScoreType.Stamina then
    GoToUtil.CloseAllWindows()
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    SceneUtils.ChangeToWorld(function()
      if not IsNull(CS.SceneManager.World) then
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
      end
      GoToUtil.GotoOpenViewOpenOptions(UIWindowNames.UISearch, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        onFinish = function()
          if not IsNull(CS.SceneManager.World) then
            CS.SceneManager.World:SetTouchInputControllerEnable(true)
          end
        end
      }, UISearchType.Boss)
    end)
  elseif type == ScoreType.HeroUpgrade then
    GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif type == ScoreType.TWUpgrade then
    if not DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_TACTICAL_CENTER) then
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_TACTICAL_CENTER)
      return
    end
    GoToUtil.GotoOpenView(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

local function OpenScienceQueue()
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_SCIENE) then
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SCIENE)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceQueue)
end

local function OpenMinTrainTimePanel()
  local buildData = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  if table.IsNullOrEmpty(buildData) then
    GoToUtil.GotoBuildListByBuildId({
      BuildingTypes.LW_BUILD_MILITARY_CAMP
    })
    return
  end
  local remainTime = 0
  local minEndTime = 0
  local targetBuildData
  for k, v in pairs(buildData) do
    if BuildingUtils.IsBuildingFunctioning(v) and not BuildingUtils.IsBuildingFinishFunctioning(v) then
      local totalTime = BuildingUtils.GetBuildingFunctioningRemainTime(v)
      if remainTime == 0 or remainTime > totalTime then
        remainTime = totalTime
        minEndTime = v.productEndTime
        targetBuildData = v
      end
    end
  end
  if targetBuildData then
    GoToUtil.GotoOpenView(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Soldier, targetBuildData.uuid)
  else
    local maxLevel = 0
    for k, v in pairs(buildData) do
      if not BuildingUtils.IsBuildingFinishFunctioning(v) and (maxLevel == 0 or maxLevel < v.level) then
        maxLevel = v.level
        targetBuildData = v
      end
    end
    targetBuildData = targetBuildData or buildData[1]
    if targetBuildData then
      local posEnd = targetBuildData.pointId
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
        GoToUtil.GotoOpenView(UIWindowNames.UILWMilitaryCampPanel, {anim = true}, targetBuildData.uuid)
      end)
    end
  end
end

local function GotoFinishedBuilding()
  local buildData = DataCenter.BuildManager:GetMaxLevelUpgradeFinishBuild()
  if buildData then
    GoToUtil.CloseAllWindows()
    local pos = SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City)
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
    local width = buildTemplate.tileX
    local length = buildTemplate.tileY
    GoToUtil.GotoCityPos(pos, nil, nil, function()
      local param = {}
      param.position = CS.CSUtils.WorldPositionToUISpacePosition(Vector3(pos.x - width / 2, pos.y + 2, pos.z - length / 2))
      param.arrowType = ArrowType.Building
      param.positionType = PositionType.Screen
      param.isAutoClose = 2
      DataCenter.ArrowManager:ShowArrow(param)
    end)
  else
    GoToUtil.GotoOpenView(UIWindowNames.UIBuildQueue)
  end
end

function GoToUtil.GoToCampScience(scienceId)
  if not DataCenter.CampScienceDataManager:IsOpenCampScience() then
    UIUtil.ShowTipsId("season_camp_science_tips_2")
    return
  end
  local uiView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWSingleActivityContainer)
  if uiView and uiView.View and uiView.View.activityData then
    if uiView.View.activityData.type == EnumActivity.CampScience.Type then
      EventManager:GetInstance():Broadcast(EventId.GoToCampScienceView, checknumber(scienceId))
    else
      SeasonUtil.OpenSeasonActivityByType(EnumActivity.CampScience.Type, CS.GameEntry.Localization:GetString("season_s6_activity_1200104_name"), nil, checknumber(scienceId))
    end
  else
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.CampScience.Type, CS.GameEntry.Localization:GetString("season_s6_activity_1200104_name"), nil, checknumber(scienceId))
  end
end

function GoToUtil:GoToNewAllianceSkill(skillId)
  if LuaEntry.Player:IsInAlliance() == false then
    UIUtil.ShowTipsId("multiply_door_tips_027")
    return
  end
  if not DataCenter.AllianceGovernmentCommonSkillManager:IsOpen() then
    UIUtil.ShowTipsId("801141")
    return
  end
  if not DataCenter.AllianceGovernmentCommonSkillManager:HasSkill() then
    UIUtil.ShowTipsId("801141")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkill, {anim = true, hideTop = true}, skillId)
end

local function CheckLowLevelCrossServerLimit(serverId)
  if 8000 <= serverId then
    return true
  end
  local levelLimit = LuaEntry.DataConfig:TryGetNum("cross_server_view", "k1", 12)
  local serverDiffLimit = LuaEntry.DataConfig:TryGetNum("cross_server_view", "k2", 200)
  local baseLevel = DataCenter.BuildManager.MainLv
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  if baseLevel and levelLimit >= baseLevel and selfServerId and serverDiffLimit < math.abs(serverId - selfServerId) then
    UIUtil.ShowTipsId("cross_server_view_tips")
    return false
  end
  return true
end

local function GoToServerPreCheck(serverId)
  if not CheckLowLevelCrossServerLimit(serverId) then
    return false
  end
  if not SeasonUtil.CheckSeasonResourceByServerId(serverId) then
    return false
  end
  if not RaceEntranceUtil.CheckMeteoriteResourceByServerId(serverId) then
    return false
  end
  if not DataCenter.LandlordMgr:CheckLLResourceByServerId(serverId) then
    return false
  end
  return true
end

local function GoToCivilizationSparkBattle(questTemplate)
  GoToUtil.CloseAllWindows()
  local uuid
  local buildId = BuildingTypes.LW_CIVILIZATION_SPARK
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local maxLevel = -1
    for k, v in pairs(list) do
      local level = v.level
      if maxLevel < level then
        maxLevel = level
        uuid = v.uuid
      end
    end
  end
  if uuid == nil then
    local landId = DataCenter.LWCivilizationSparkManager:GetLandId()
    local obj = DataCenter.MonopolyManager:GetLandRewardObj(landId)
    if obj then
      GoToUtil.GoLandLockById(landId)
    else
      SceneUtils.ChangeToCity(function()
        GoToUtil.GoToCurObstacle(true)
      end)
    end
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData == nil then
    return
  end
  local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.CivilizationSparkEntrance, buildId)
  if obj then
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    local worldPointPos = BuildingUtils.GetBuildModelCenterVec(buildData.pointId, template.tileX, template.tileY)
    SceneUtils.ChangeToCity(function()
      GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime)
      WorldArrowManager:GetInstance():ShowArrowEffect(0, obj.transform.position, ArrowType.Building)
    end)
  else
    GoToUtil.GotoCityByBuildUuid(uuid, WorldTileBtnType.CivilizationSparkFrontBreak, nil, questTemplate, nil)
  end
end

local function GoToCivilizationSparkUpgrade(questTemplate)
  GoToUtil.CloseAllWindows()
  local uuid
  local buildId = BuildingTypes.LW_CIVILIZATION_SPARK
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local maxLevel = -1
    for k, v in pairs(list) do
      local level = v.level
      if maxLevel < level then
        maxLevel = level
        uuid = v.uuid
      end
    end
  end
  if uuid == nil then
    local landId = DataCenter.LWCivilizationSparkManager:GetLandId()
    local obj = DataCenter.MonopolyManager:GetLandRewardObj(landId)
    if obj then
      GoToUtil.GoLandLockById(landId)
    else
      SceneUtils.ChangeToCity(function()
        GoToUtil.GoToCurObstacle(true)
      end)
    end
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData == nil then
    return
  end
  GoToUtil.GotoCityByBuildUuid(uuid, WorldTileBtnType.CivilizationSparkUpgrade, nil, questTemplate, nil)
end

local function GoToCivilizationSparkBuild(zoom, onComplete)
  local uuid
  local buildId = BuildingTypes.LW_CIVILIZATION_SPARK
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil and table.count(list) > 0 then
    local maxLevel = -1
    for k, v in pairs(list) do
      local level = v.level
      if maxLevel < level then
        maxLevel = level
        uuid = v.uuid
      end
    end
  end
  if uuid == nil then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData == nil then
    return
  end
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local worldPointPos = BuildingUtils.GetBuildModelCenterVec(buildData.pointId, template.tileX, template.tileY)
  worldPointPos.x = worldPointPos.x - 5
  worldPointPos.z = worldPointPos.z + 5
  SceneUtils.ChangeToCity(function()
    CS.SceneManager.World:AutoLookat(worldPointPos, zoom or CS.SceneManager.World.InitZoom, LookAtFocusTime, onComplete)
  end)
end

GoToUtil.TryJumpToWorld = TryJumpToWorld
GoToUtil.GotoCityByBuildId = GotoCityByBuildId
GoToUtil.GotoCityByCondBuildId = GotoCityByCondBuildId
GoToUtil.GetHighestLevelBuild = GetHighestLevelBuild
GoToUtil.GotoOpenView = GotoOpenView
GoToUtil.GotoOpenViewOpenOptions = GotoOpenViewOpenOptions
GoToUtil.GotoBuildListByBuildId = GotoBuildListByBuildId
GoToUtil.GotoScience = GotoScience
GoToUtil.GoToPlayerLevel = GoToPlayerLevel
GoToUtil.GoToPlayerCareer = GoToPlayerCareer
GoToUtil.OpenSciencePanel = OpenSciencePanel
GoToUtil.OpenScienceTabPanel = OpenScienceTabPanel
GoToUtil.OpenScienceTree = OpenScienceTree
GoToUtil.CloseAllWindows = CloseAllWindows
GoToUtil.MoveToWorldPoint = MoveToWorldPoint
GoToUtil.MoveToWorldPointAndOpen = MoveToWorldPointAndOpen
GoToUtil.OnClickWorldPoint = OnClickWorldPoint
GoToUtil.GotoPayTips = GotoPayTips
GoToUtil.GotoPay = GotoPay
GoToUtil.GetSourceByResourceItem = GetSourceByResourceItem
GoToUtil.GoToCityBuildByQuest = GoToCityBuildByQuest
GoToUtil.GoToByQuestId = GoToByQuestId
GoToUtil.GotoWorldBuildAndOpenUI = GotoWorldBuildAndOpenUI
GoToUtil.GotoCityByBuildUuid = GotoCityByBuildUuid
GoToUtil.GotoFarm = GotoFarm
GoToUtil.GotoPasture = GotoPasture
GoToUtil.GotoFarmGet = GotoFarmGet
GoToUtil.GotoBuildRoad = GotoBuildRoad
GoToUtil.GotoMainBuildPos = GotoMainBuildPos
GoToUtil.GotoDragonBuildPos = GotoDragonBuildPos
GoToUtil.GotoColdStorage = GotoColdStorage
GoToUtil.GoFactory = GoFactory
GoToUtil.GoAttackMonster = GoAttackMonster
GoToUtil.GotoResourceBuild = GotoResourceBuild
GoToUtil.GotoWorldResource = GotoWorldResource
GoToUtil.GotoPastureByUuid = GotoPastureByUuid
GoToUtil.GoRadarProbe = GoRadarProbe
GoToUtil.GoGarbage = GoGarbage
GoToUtil.GoBusinessCenterWindow = GoBusinessCenterWindow
GoToUtil.GotoBossMonsterBetweenLv = GotoBossMonsterBetweenLv
GoToUtil.GoBarracks = GoBarracks
GoToUtil.GoToMonthCard = GoToMonthCard
GoToUtil.GotoBuildListRobotByRobotId = GotoBuildListRobotByRobotId
GoToUtil.GoFactoryWork = GoFactoryWork
GoToUtil.GotoCityTroopAndPointToGarbage = GotoCityTroopAndPointToGarbage
GoToUtil.OpenInCity = OpenInCity
GoToUtil.FindMonster = FindMonster
GoToUtil.GotoTrainSolider = GotoTrainSolider
GoToUtil.GoConnectBuild = GoConnectBuild
GoToUtil.GotoGuluBox = GotoGuluBox
GoToUtil.GotoMonsterReward = GotoMonsterReward
GoToUtil.GoHeroStation = GoHeroStation
GoToUtil.GoHeroStationScores = GoHeroStationScores
GoToUtil.GoGiftMall = GoGiftMall
GoToUtil.GoBagPackUseItem = GoBagPackUseItem
GoToUtil.GoToStorageShop = GoToStorageShop
GoToUtil.GoSearchEnemy = GoSearchEnemy
GoToUtil.GoGarageUpgrade = GoGarageUpgrade
GoToUtil.GoToGarageRefit = GoToGarageRefit
GoToUtil.GoToCareerSelect = GoToCareerSelect
GoToUtil.GotoGiftPackView = GotoGiftPackView
GoToUtil.GotoFastBuildList = GotoFastBuildList
GoToUtil.GoHospital = GoHospital
GoToUtil.GoPveLevel = GoPveLevel
GoToUtil.LookAtFirstCanUnlockLandLockByPve = LookAtFirstCanUnlockLandLockByPve
GoToUtil.GoToCurObstacle = GoToCurObstacle
GoToUtil.GoLandLockById = GoLandLockById
GoToUtil.GoUnlockedTile = GoUnlockedTile
GoToUtil.GoUnlockedTile_Newbies = GoUnlockedTile_Newbies
GoToUtil.GoLockMonster = GoLockMonster
GoToUtil.GoHeroTrust = GoHeroTrust
GoToUtil.GotoPos = GotoPos
GoToUtil.CheckCrossWar = CheckCrossWar
GoToUtil.GoTriggerPve = GoTriggerPve
GoToUtil.GoLandPve = GoLandPve
GoToUtil.GoEnergy = GoEnergy
GoToUtil.GoActWindow = GoActWindow
GoToUtil.CheckActIdInOffSeasonViewAndOpen = CheckActIdInOffSeasonViewAndOpen
GoToUtil.GotoWorldPos = GotoWorldPos
GoToUtil.GotoCityPos = GotoCityPos
GoToUtil.GoCityCollect = GoCityCollect
GoToUtil.GoFormation = GoFormation
GoToUtil.GetBuildState = GetBuildState
GoToUtil.GoCheckBuild = GoCheckBuild
GoToUtil.GoHeroBag = GoHeroBag
GoToUtil.GoBuildOpenUpgrade = GoBuildOpenUpgrade
GoToUtil.GoMainUIBtn = GoMainUIBtn
GoToUtil.GoLWParkourBattle = GoLWParkourBattle
GoToUtil.GotoDabenPos = GotoDabenPos
GoToUtil.GoToByTypeAndParam = GoToByTypeAndParam
GoToUtil.GoToWindow = GoToWindow
GoToUtil.DoPlayerAssistance = DoPlayerAssistance
GoToUtil.GotoDragonPos = GotoDragonPos
GoToUtil.GotoBattlefield = GotoBattlefield
GoToUtil.GotoPosForDragon = GotoPosForDragon
GoToUtil.GoHeroDetails = GoHeroDetails
GoToUtil.GoHeroDetailsByItemId = GoHeroDetailsByItemId
GoToUtil.GoHeroUniqueWeaponPreview = GoHeroUniqueWeaponPreview
GoToUtil.GotoCurrMonopolyCell = GotoCurrMonopolyCell
GoToUtil.GoActWindowDontClose = GoActWindowDontClose
GoToUtil.GotoActShopWindow = GotoActShopWindow
GoToUtil.GotoActShopWindowMission = GotoActShopWindowMission
GoToUtil.GotoWorkerRecruitView = GotoWorkerRecruitView
GoToUtil.GotoTWSkillChipView = GotoTWSkillChipView
GoToUtil.GotoTWView = GotoTWView
GoToUtil.GotoSeasonWeekCardView = GotoSeasonWeekCardView
GoToUtil.GotoNearestCityStronghold = GotoNearestCityStronghold
GoToUtil.GotoNearestCity = GotoNearestCity
GoToUtil.GotoEffectLack = GotoEffectLack
GoToUtil.GotoHeroUniqueWepaon = GotoHeroUniqueWepaon
GoToUtil.GotoHeroAwaken = GotoHeroAwaken
GoToUtil.GotoSeasonBiuBiuActivity = GotoSeasonBiuBiuActivity
GoToUtil.GotoSeasonActivityView = GotoSeasonActivityView
GoToUtil.GotoHeroHonorWall = GotoHeroHonorWall
GoToUtil.GoToCountBattleMap = GoToCountBattleMap
GoToUtil.GotoSeasonSnowStormActivity = GotoSeasonSnowStormActivity
GoToUtil.GoToMilitaryCampPromotion = GoToMilitaryCampPromotion
GoToUtil.GoToAllianceFurnace = GoToAllianceFurnace
GoToUtil.GotoAllianceShop = GotoAllianceShop
GoToUtil.GotoMigrationTicketShop = GotoMigrationTicketShop
GoToUtil.GoToSeasonCityList = GoToSeasonCityList
GoToUtil.RequestAllianceMemberBasePoint = RequestAllianceMemberBasePoint
GoToUtil.GoToAllianceMemberBase = GoToAllianceMemberBase
GoToUtil.RequestNearestTradeStationWithoutLord = RequestNearestTradeStationWithoutLord
GoToUtil.RequestNearestTradeStationWithLord = RequestNearestTradeStationWithLord
GoToUtil.GoToCurWorldPoint = GoToCurWorldPoint
GoToUtil.PersonalArmsGoto = PersonalArmsGoto
GoToUtil.OpenScienceQueue = OpenScienceQueue
GoToUtil.OpenMinTrainTimePanel = OpenMinTrainTimePanel
GoToUtil.GotoFinishedBuilding = GotoFinishedBuilding
GoToUtil.OpenChatView = OpenChatView
GoToUtil.GotoOpenView_BattleReturnOpt = GotoOpenView_BattleReturnOpt
GoToUtil.OpenActivityCommonGroupWindow = OpenActivityCommonGroupWindow
GoToUtil.GoToServerPreCheck = GoToServerPreCheck
GoToUtil.GoToCivilizationSparkBattle = GoToCivilizationSparkBattle
GoToUtil.GoToCivilizationSparkUpgrade = GoToCivilizationSparkUpgrade
GoToUtil.GoToCivilizationSparkBuild = GoToCivilizationSparkBuild
return ConstClass("GoToUtil", GoToUtil)
