local cmd = {}

function cmd.Execute(arr)
  local subCmd = arr[2]
  if subCmd == "unlock" then
    local unlockId = tonumber(arr[3])
    DataCenter.LWFunctionUnlockManager:TestUnlockEffect(unlockId)
  elseif subCmd == "cam2b" then
    local buildingId = tonumber(arr[3])
    local data = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildingId)[1]
    if data == nil then
      return "Can't find building data: " .. buildingId
    end
    local tile = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), buildingId, "tiles") * 0.5 * TileSize
    local pos = SceneUtils.TileIndexToWorld(data.pointId, ForceChangeScene.City) - Vector3(tile, 0, tile)
    local offset = 106.05
    pos.x = pos.x + offset
    pos.z = pos.z - offset
    pos.y = 150
    CS.SceneManager.World:LockCamera(pos, 0)
    CS.SceneManager.World:FreeCamera()
  elseif subCmd == "uistack" then
    return table.dump(UIManager:GetInstance().windowStack)
  elseif subCmd == "tryfold" then
    DataCenter.BuildManager:PushBuildFoldUpHandle({needRemove = 968764313965716498})
  elseif subCmd == "bubble" then
    local plotId = tonumber(arr[3])
    local anchor = Vector3(tonumber(arr[4]), tonumber(arr[5]), tonumber(arr[6]))
    local mode = arr[7]
    local playerInfo = {
      uid = "2092407001000100",
      pic = "player_head_20",
      picVer = 0
    }
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, {
      plotId = plotId,
      anchor = anchor,
      mode = mode,
      playerInfo = playerInfo
    })
  elseif subCmd == "bubble_rand" then
    local plotGroupId = tonumber(arr[3])
    local anchor = Vector3(tonumber(arr[4]), tonumber(arr[5]), tonumber(arr[6]))
    local mode = arr[7]
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, {
      plotGroupId = plotGroupId,
      anchor = anchor,
      mode = mode
    })
  elseif subCmd == "opstar" then
    local starNum = tonumber(arr[3])
    local buildingId = tonumber(arr[4])
    local pointId = tonumber(arr[5])
    DataCenter.LWOpeningStageManager.dirtyWorks:AbsorbStars(starNum, buildingId, pointId)
  elseif subCmd == "opback" then
    local isWin = arr[3] == "true"
    require("DataCenter.LWOpeningStageManager.LWOpeningStageUtils").ShowBattleResult(isWin)
  elseif subCmd == "opnewhero" then
    for _, hero in pairs(DataCenter.HeroDataManager.allHero) do
      DataCenter.LWOpeningStageManager.squadProxy.newHero = hero
      DataCenter.LWOpeningStageManager.squadProxy:WelcomeNewFellow()
      break
    end
  elseif subCmd == "op4workers" then
    local tile = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), 10100000, "tiles") * TileSize * 0.5
    local birthPos = SceneUtils.TileIndexToWorld(5051, ForceChangeScene.City) - Vector3(tile, 0, tile) * 0.707
    for i = 1, 4 do
      local targetPos = birthPos + Vector3(-4 + (i - 1) * 2, 0, -5)
      local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(10107000)[1]
      DataCenter.GainWorkerManager:ShowFakeWorker(22101, buildingData, birthPos, targetPos)
    end
  elseif subCmd == "finger" then
    local fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    fingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      transform.position = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View.bottom:GetQuestPosition()
      TimerManager:GetInstance():DelayInvoke(function()
        fingerHandle:Destroy()
      end, 2)
    end)
  elseif subCmd == "adddrop" then
    local heroId = tonumber(arr[3])
    DataCenter.BuildHeroManager:AddNewHero(heroId)
  elseif subCmd == "checkunlock" then
    local unlockId = tonumber(arr[3])
    printError(tostring(DataCenter.LWFunctionUnlockManager:CheckCanShow(unlockId)))
  elseif subCmd == "zombiestate" then
    for _, zombie in pairs(DataCenter.LWGateDefenceManager.zombieInsts) do
      printError(zombie.id .. " -> " .. zombie.fsm.currStateName)
    end
  elseif subCmd == "uianim" then
    local mask = tonumber(arr[3])
    local show = arr[4] == "true"
    EventManager:GetInstance():Broadcast(EventId.PlayMainUIAnim, {mask, show})
  elseif subCmd == "numstr" then
    local number = tonumber(arr[3])
    local digits = tonumber(arr[4])
    local sep = arr[5] == "true" and "," or nil
    return string.numbericFormationWithPrefix(number, digits, sep)
  elseif subCmd == "quitcount" then
    DataCenter.LWBattleManager:SetGameOver(true)
    DataCenter.LWBattleManager:Exit(nil, "quit")
  elseif subCmd == "reboot" then
    CS.ApplicationLaunch.Instance:ReloadGame()
  elseif subCmd == "droptwo" then
    DataCenter.BuildHeroManager:RemoveBuildHero(30005)
    DataCenter.BuildHeroManager:RemoveBuildHero(40010)
    DataCenter.BuildHeroManager:CreateBuildHero(30005)
    DataCenter.BuildHeroManager:CreateBuildHero(40010)
  elseif subCmd == "parkourmap" then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMap, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, {guidStageId = 101})
  elseif subCmd == "reload" then
    CS.ApplicationLaunch.Instance:ReloadGame()
  elseif subCmd == "openui" then
    local uiName = arr[3]
    UIManager:GetInstance():OpenWindow(uiName, {anim = false})
  elseif subCmd == "arenarank" then
    local lastRank = tonumber(arr[3])
    local currRank = tonumber(arr[4])
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.LWPVPArenaMain)
    if window and window.State == 2 then
      local arenaData = window.View.arenaData
      arenaData.selfRank = currRank
      arenaData.lastSelfRank = lastRank
      window.Ctrl:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWPVPArenaMain, {anim = false}, {msg = arenaData})
    end
  elseif subCmd == "push" then
    local pushId = arr[3]
    local pushType = arr[4]
    local pushTime = tonumber(arr[5])
    local param = {}
    param.type = pushType
    param.time = pushTime
    param.body = "Test Push: " .. pushId .. " => " .. pushType
    param.soundKey = ""
    param.pushType = pushType
    param.playerMark = LuaEntry.Player.pushMark
    param.gameUid = LuaEntry.Player.uid
    param.pushId = pushId
    local strJson = require("rapidjson").encode(param)
    CS.PushNoticeManager.PushNotice(strJson)
  elseif subCmd == "cancel" then
    local pushId = arr[3]
    local pushType = arr[4]
    local param = {}
    param.type = pushType
    param.pushType = pushType
    param.pushId = pushId
    local strJson = require("rapidjson").encode(param)
    CS.PushNoticeManager.CancelNotice(strJson)
  elseif subCmd == "fakemarch" then
    local marchDist = tonumber(arr[3])
    local marchTime = tonumber(arr[4])
    local batchCount = tonumber(arr[5])
    local batchInterval = tonumber(arr[6])
    local basePos = LuaEntry.Player:GetMainWorldPos()
    local endPosX = math.floor(basePos / 1000)
    local endPosY = math.floor(basePos % 1000)
    
    local function createFakeMarch()
      local endPos = Vector3.New(endPosX, 0, endPosY)
      local startPos = endPos + Quaternion.Euler(0, math.random(0, 360), 0) * Vector3.forward * marchDist
      local startIndex = math.floor(startPos.x) * 1000 + math.floor(startPos.z)
      local endIndex = endPosX * 1000 + endPosY
      CS.SceneManager.World:AddFakeAttackMonsterMarchData(startIndex, endIndex, marchTime, "fakeUser")
    end
    
    if 0 < batchInterval then
      for i = 1, batchCount do
        TimerManager:GetInstance():DelayInvoke(function()
          createFakeMarch()
        end, batchInterval * (i - 1))
      end
    else
      for i = 1, batchCount do
        createFakeMarch()
      end
    end
  elseif subCmd == "noticepanel" then
    local __server_back_json = "{\"bannericon\":\"ddd\",\"title\":\"<LAST WAR> \230\155\180\230\150\176\229\133\172\229\145\138\",\"banner\":\"\230\155\180\230\150\176\229\133\172\229\145\138\",\"date\":\"2024.08.22\",\"contents\":[{\"style\":\"h2\",\"dot\":false,\"text\":\"\228\186\178\231\136\177\231\154\132\230\140\135\230\140\165\229\174\152\"},{\"style\":\"text\",\"dot\":false,\"text\":\"\232\142\171\229\166\174\229\141\161\229\143\130\232\176\139\229\174\152\230\157\165\229\149\166\239\188\140\229\184\166\230\157\165\228\184\128\230\179\162\230\156\128\230\150\176\230\182\136\230\129\175\239\188\129\230\155\180\230\150\176\232\174\161\229\136\146\229\174\154\228\186\142<color=#ff0000>8\230\156\13622\230\151\165</color>\232\191\155\232\161\140\239\188\140<color=#ff0000>\229\177\138\230\151\182\230\156\141\229\138\161\229\153\168\229\176\134\229\129\156\230\156\1865\229\136\134\233\146\159\227\128\130</color>\229\156\168\231\187\180\230\138\164\230\156\159\233\151\180\239\188\140\230\130\168\229\176\134\230\151\160\230\179\149\231\153\187\229\133\165\230\184\184\230\136\143\227\128\130\228\184\186\231\161\174\228\191\157\230\130\168\231\154\132\232\180\166\230\136\183\232\181\132\230\150\153\230\173\163\231\161\174\239\188\140\232\175\183\229\156\168\231\187\180\230\138\164\229\137\141\229\133\179\233\151\173\230\184\184\230\136\143\227\128\130\"},{\"style\":\"h2\",\"dot\":true,\"text\":\"\227\128\144\230\150\176\229\162\158\227\128\145\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"[\230\156\171\230\151\165\233\156\184\228\184\154]\233\161\181\233\157\162\229\162\158\229\138\160S2\232\181\155\229\173\163\231\155\184\229\133\179\228\191\161\230\129\175\227\128\130\"},{\"style\":\"h2\",\"dot\":true,\"text\":\"\227\128\144\228\188\152\229\140\150\227\128\145\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"1. \232\191\155\232\161\140\232\191\129\229\159\142\230\151\182\239\188\140\231\148\177\229\142\159\229\133\136\230\152\190\231\164\186\231\148\187\233\157\162\228\184\173\229\191\131\231\130\185\231\154\132\229\157\144\230\160\135\239\188\140\232\176\131\230\149\180\228\184\186\230\152\190\231\164\186\232\191\129\229\159\142\231\155\174\230\160\135\231\130\185\229\157\144\230\160\135\227\128\130\"},{\"style\":\"h2\",\"dot\":true,\"text\":\"2. [\230\148\187\229\159\142\230\139\148\229\175\168]\229\146\140[\233\152\178\229\190\161\229\183\165\228\189\156]\231\154\132\231\167\145\230\138\128\231\186\191\228\184\173\239\188\140[\229\176\143\233\152\159\229\134\133\232\139\177\233\155\132]\231\154\132[\231\148\159\229\145\189\229\128\188]\239\188\140[\230\148\187\229\135\187\229\138\155]\239\188\140[\233\152\178\229\190\161\229\138\155]\230\143\144\229\141\135\231\154\132\231\167\145\230\138\128\231\154\132\231\148\159\230\149\136\230\157\161\228\187\182\239\188\140\231\148\177\229\142\159\229\133\136[\229\156\168\229\159\142\229\134\133\233\152\178\229\174\136\230\151\182]\230\136\150[\230\148\187\229\135\187\230\149\140\230\150\185\230\140\135\230\140\165\229\174\152\229\159\186\229\156\176\230\151\182]\239\188\140\232\176\131\230\149\180\228\184\186[PVP\230\136\152\230\150\151\230\151\182]\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"3. \229\156\168[\229\144\140\231\155\159\231\167\145\230\138\128]\231\154\132\233\131\168\229\136\134\231\167\145\230\138\128\228\187\139\231\187\141\228\184\173\229\162\158\229\138\160\228\186\134\229\164\154\228\184\170[\229\133\179\233\148\174\232\175\141]\232\175\180\230\152\142\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"4. [\230\128\187\233\131\168]\231\154\132\229\162\158\231\155\138\230\149\136\230\158\156\230\159\165\231\156\139\229\136\151\232\161\168\228\184\173\239\188\140[\230\136\152\230\150\151\231\177\187]-[\230\149\180\228\189\147\232\161\140\229\134\155\233\128\159\229\186\166\230\143\144\229\141\135]\232\161\165\229\133\133\228\186\134\230\157\165\232\135\170[\229\144\140\231\155\159\229\159\142\229\184\130]\231\154\132\229\138\160\230\136\144\230\152\190\231\164\186\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"5. [3v3\228\186\137\233\156\184\232\181\155]\231\154\132\229\164\141\228\187\135\232\167\166\229\143\145\230\157\161\228\187\182\239\188\140\231\148\177\229\142\159\229\133\136\232\162\171\229\144\140\228\184\128\228\184\170\230\140\135\230\140\165\229\174\152\231\180\175\232\174\161\229\135\187\232\180\165[5\230\172\161]\232\176\131\230\149\180\228\184\186[3\230\172\161]\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"6. \233\128\137\228\184\173\229\156\176\229\155\190\228\184\173\231\154\132[\229\159\142\229\184\130]\230\151\182\239\188\140\228\184\141\229\134\141\229\188\186\229\136\182\230\148\185\229\143\152\229\156\176\229\155\190\231\154\132\231\188\169\230\148\190\230\175\148\228\190\139\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"7. \228\188\152\229\140\150\228\186\134[\229\144\140\231\155\159\229\175\185\229\134\179]\229\146\140[\229\134\155\229\164\135\231\171\158\232\181\155]\232\142\183\229\190\151\231\167\175\229\136\134\230\151\182\231\154\132\232\191\155\229\186\166\232\161\168\231\142\176\230\149\136\230\158\156\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"8. \232\139\177\233\155\132\229\136\151\232\161\168\229\134\133\229\143\175\228\187\165\231\156\139\229\136\176\229\189\147\229\137\141\232\139\177\233\155\132\230\137\128\229\156\168\231\154\132\229\176\143\233\152\159\231\188\150\229\143\183\228\186\134\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"9. \229\143\175\228\187\165\230\155\180\230\150\185\228\190\191\229\156\176\229\136\160\233\153\164\229\156\176\229\155\190\228\184\138[\230\148\182\232\151\143]\231\154\132\229\157\144\230\160\135\228\186\134\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"10. \229\143\175\228\187\165\229\134\141\230\172\161\231\130\185\229\135\187\232\129\138\229\164\169\230\182\136\230\129\175\228\184\173\231\154\132[\232\181\158]\230\136\150[\232\184\169]\231\154\132\229\155\190\230\160\135\230\157\165\229\143\150\230\182\136\232\191\153\228\184\170\229\143\141\229\186\148\227\128\130\"},{\"style\":\"h2\",\"dot\":true,\"text\":\"\227\128\144\228\191\174\229\164\141\227\128\145\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"1. \228\191\174\229\164\141\228\186\134\230\156\137\230\151\182\228\188\154\233\148\153\232\175\175\230\143\144\231\164\186\230\173\164\230\172\161\232\191\155\230\148\187\228\188\154\232\167\163\233\153\164[\233\152\178\230\138\164\231\189\169]\231\138\182\230\128\129\231\154\132\233\151\174\233\162\152\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"2. \228\191\174\229\164\141\228\186\134\233\131\168\229\136\134\230\131\133\229\134\181\228\184\139\239\188\140\230\142\160\229\164\186\232\181\132\230\186\144\231\154\132\230\149\176\229\128\188\230\152\190\231\164\186\233\148\153\232\175\175\231\154\132\233\151\174\233\162\152\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"3. \228\191\174\229\164\141\228\186\134\233\131\168\229\136\134\230\131\133\229\134\181\228\184\139\239\188\140[\233\147\182\230\157\143\230\160\145]\232\163\133\233\165\176\231\137\169\231\154\132\229\143\175\230\145\134\230\148\190\230\149\176\233\135\143\229\188\130\229\184\184\231\154\132\233\151\174\233\162\152\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"4. \228\191\174\229\164\141\228\186\134[\231\180\167\230\128\165\230\178\187\231\150\151]\230\138\128\232\131\189\228\187\164\229\163\171\229\133\181\230\149\176\233\135\143\232\182\133\229\135\186\230\160\161\229\156\186\229\143\175\229\174\185\231\186\179\228\184\138\233\153\144\231\154\132\233\151\174\233\162\152\227\128\130\"},{\"style\":\"h3\",\"dot\":true,\"text\":\"5. \228\191\174\229\164\141\228\186\134\229\144\140\231\155\159\228\184\173\228\187\187\229\145\189[\229\144\140\231\155\159\229\174\152\229\145\152]\229\144\142\239\188\140\229\144\140\231\155\159\230\136\144\229\145\152\229\136\151\232\161\168\231\154\132\230\152\190\231\164\186\230\178\161\230\156\137\229\174\158\230\151\182\229\136\183\230\150\176\231\154\132\233\151\174\233\162\152\227\128\130\"}]}"
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIServerNotice, {anim = false, playEffect = 10003}, __server_back_json)
  elseif subCmd == "marchlimit" then
    local limit = tonumber(arr[3])
    require("DataCenter.WorldBattle.WorldBattleDisplaySettings").SetLevelLimit(limit)
  elseif subCmd == "marchthreshold" then
    local threshold = tonumber(arr[3])
    require("DataCenter.WorldBattle.WorldBattleDisplaySettings").LevelAdjustmentSquadCountThreshold = threshold
  elseif subCmd == "marchopswitch" then
    return tostring(LuaEntry.DataConfig:CheckSwitch("march_optimize"))
  elseif subCmd == "battleSound" then
    for i = 1, 1000 do
      ProfilerUtil.BeginSample("LWBattleSoundManager.AddOrUpdateMarch")
      DataCenter.LWBattleSoundManager:AddOrUpdateMarch(i, 497500)
      ProfilerUtil.EndSample()
    end
    local testTable1 = {}
    ProfilerUtil.BeginSample("TestTable1")
    for i = 1, 1000 do
      local has = testTable1[i]
    end
    ProfilerUtil.EndSample()
    local testTable2 = {}
    ProfilerUtil.BeginSample("TestTable2")
    for i = 1, 60 do
      local has = testTable2[i]
    end
    ProfilerUtil.EndSample()
  elseif subCmd == "thumbs" then
    DataCenter.LWAllyStationDataManager:ThumbsTest()
  elseif subCmd == "circles" then
    local array = CS.CSUtils.PoissonDiscSampler(1, 10, 3)
    local param = {}
    local posTable = {}
    local length = array.Length
    for i = 1, length do
      local base = array[i - 1]
      table.insert(posTable, {
        base.x,
        base.y
      })
    end
    param.posArray = posTable
    local strJson = require("rapidjson").encode(param)
    Logger.LogError("posJson : " .. strJson)
  elseif subCmd == "arrayTest" then
    local array = {}
    for i = 1, 300 do
      table.insert(array, i)
    end
    local map = {}
    for i = 100, 400 do
      map[i * 3] = i
    end
    ProfilerUtil.BeginSample("TestArrayTest")
    for i = 1, 100 do
      for i, v in ipairs(array) do
        v = v + 1
      end
    end
    ProfilerUtil.EndSample()
    ProfilerUtil.BeginSample("TestMapTest")
    for i = 1, 100 do
      for i, v in pairs(map) do
        v = v + 1
      end
    end
    ProfilerUtil.EndSample()
  elseif subCmd == "arrayV3" then
    local array = arrayV3.new()
    for i = 1, 10 do
      local t = {index = i}
      local index = array:Add(t)
      t.ind = index
    end
    local v = array:RemoveAt(3)
    local v2 = array:RemoveAt(6)
    local v3 = array:RemoveAt(9)
    local t11 = {
      index == 11
    }
    local ind = array:Add(t11)
    local t12 = {index = 12}
    ind = array:Add(t12)
    local t13 = {index = 13}
    ind = array:Add(t13)
    local t14 = {index = 12}
    ind = array:Add(t14)
  elseif subCmd == "lua#Array" then
    local effectViewFacade = CS.PVEBattleLogic.Effect.EffectViewFacade
    local luaArray = LuaCSharpArray.New(128)
    for i = 1, 128 do
      if i % 2 == 0 then
        luaArray[i] = math.maxinteger
      else
        luaArray[i] = math.maxinteger + i
      end
    end
    local luaArrayAccess = luaArray:GetCSharpAccess()
    ProfilerUtil.BeginSample("TestLuaCSharpArray")
    effectViewFacade.TestLuaCSharpArray(luaArrayAccess)
    ProfilerUtil.EndSample()
    luaArray = nil
    local testArray = {}
    for i = 1, 128 do
      testArray[i] = 0
    end
    for i = 1, 128 do
      testArray[i] = i
    end
    ProfilerUtil.BeginSample("TestLuaTable")
    effectViewFacade.TestLuaTable(testArray)
    ProfilerUtil.EndSample()
    collectgarbage("collect")
  elseif subCmd == "resizeLuaArray" then
    PvePhysicsUtil.BulletCollider(Time.deltaTime)
  elseif subCmd == "ossTest" then
    CS.OSSClientManager.Instance:ListBuckets()
  elseif subCmd == "pveLogUpload" then
    local uid = DataCenter.LWGhostParkourDataManager:GetNpcUid()
    local uuid = arr[3]
    local fileName = arr[4]
    local uploadType = arr[5] and tonumber(arr[5]) or PVELogFuncType.GhostParkour
    local name = SURFING_DOWNLOAD_LOG_PATH
    if uploadType == PVELogFuncType.GhostParkour then
      name = PVE_LOG_LOCAL_PATH .. PVELogFilePathName[uploadType]
    end
    local dirName = CS.UnityEngine.Application.persistentDataPath .. name
    local path = dirName .. fileName
    CS.PVELogManager.Instance:UploadPVESurfingLogFile(uid, uuid, path, function(succeed)
      Logger.LogError("pveLogUpload : " .. tostring(succeed))
    end, uploadType)
  elseif subCmd == "pveLogDownload" then
    CS.PVELogManager.Instance:DownloadPVESurfingLog(LuaEntry.Player.uid, "1277552344812250180", "D:/ossTest/testSurfingLog4", function(succeed)
      Logger.LogError("pveLogDownload : " .. tostring(succeed))
    end)
  end
  return nil
end

return cmd
