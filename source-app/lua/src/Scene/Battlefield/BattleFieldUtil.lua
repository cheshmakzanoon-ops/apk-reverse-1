local BattleFieldUtil = {}
local Setting = CS.GameEntry.Setting
local BattleFieldPingUtil = require("Scene.Battlefield.Common.BattleFieldPingUtil")

function BattleFieldUtil.OnEnter()
  local inMapFlag = false
  for bfType, config in pairs(BattlefieldBaseConfig or {}) do
    CommonUtil.ProtectCall(function()
      local mgr = config.BattlefieldMgrGetter()
      if mgr and mgr.OnEnterGame then
        mgr:OnEnterGame()
      end
    end)
    if not inMapFlag then
      local mapObj = BattleFieldUtil.GetMapObj(bfType)
      if not IsNull(mapObj) then
        inMapFlag = true
      end
    end
  end
  if not inMapFlag then
    BattleFieldUtil.Reset()
  end
end

function BattleFieldUtil.Delete()
  for _, config in pairs(BattlefieldBaseConfig or {}) do
    CommonUtil.ProtectCall(function()
      local mgr = config.BattlefieldMgrGetter()
      if mgr then
        mgr:Delete()
      end
    end)
    CommonUtil.ProtectCall(function()
      local mgr = config.BattlefieldTemplateMgrGetter()
      if mgr then
        mgr:Delete()
      end
    end)
  end
  BattleFieldUtil.Reset()
end

function BattleFieldUtil.Reset()
  local hasCanEnterFlag = BattleFieldUtil.battleFieldCanEnterFlags ~= nil and next(BattleFieldUtil.battleFieldCanEnterFlags) ~= nil
  BattleFieldUtil.battleFieldCanEnterFlags = {}
  if hasCanEnterFlag then
    EventManager:GetInstance():Broadcast(EventId.BattleFieldCanEnterPush)
  end
  BattleFieldUtil.BASE_PING_CD = nil
  BattleFieldUtil.preWatchIdx = 0
  BattleFieldUtil.prePointId = 0
  BattleFieldUtil.testJump = false
  BattleFieldUtil.cool = nil
  BattleFieldUtil.SetObserve(false)
  BattleFieldUtil.effectList = {}
  BattleFieldUtil.effectDic = {}
  BattleFieldUtil.lastPingSec = 0
  DataCenter.BattleFieldAnimManager:ClearAll()
  BattleFieldPingUtil.CleanPingMark()
end

function BattleFieldUtil.BFPingUtil()
  return BattleFieldPingUtil
end

function BattleFieldUtil.BTestJump()
  if CommonUtil.IsDebug() then
    return BattleFieldUtil.testJump
  end
  return false
end

function BattleFieldUtil.GetMgr(bfType)
  local cfg = BattleFieldUtil.GetBaseConfig(bfType)
  if cfg then
    return cfg.BattlefieldMgrGetter()
  end
  if bfType == BattleFieldType.Desert then
    return DataCenter.ActDragonManager
  elseif bfType == BattleFieldType.WinterStorm then
    return DataCenter.ActWinterStormManager
  elseif bfType == BattleFieldType.EpidemicZone then
    return DataCenter.ActEpidemicZoneManager
  elseif bfType == BattleFieldType.DsbDuel then
    return DataCenter.BattlefieldDsbDuelManager
  end
end

function BattleFieldUtil.GetTemplateMgr(bfType)
  local cfg = BattleFieldUtil.GetBaseConfig(bfType)
  if cfg then
    return cfg.BattlefieldTemplateMgrGetter()
  end
  if bfType == BattleFieldType.Desert then
    return DataCenter.DragonBuildTemplateManager
  elseif bfType == BattleFieldType.WinterStorm then
    return DataCenter.WinterStormTemplateManager
  elseif bfType == BattleFieldType.EpidemicZone then
    return DataCenter.EpidemicBuildTemplateMgr
  elseif bfType == BattleFieldType.DsbDuel then
    return DataCenter.BattlefieldDsbDuelTemplateManager
  end
end

function BattleFieldUtil.GetMgrActive()
  local cur = LuaEntry.Player:GetCurWorldType()
  return BattleFieldUtil.GetMgr(cur)
end

function BattleFieldUtil.GetBattleFieldTypeByActType(actType)
  if actType == EnumActivity.ActDragon.Type then
    return BattleFieldType.Desert
  end
  if actType == EnumActivity.ActWinterStorm.Type then
    return BattleFieldType.WinterStorm
  end
  if actType == EnumActivity.ActEpidemic.Type then
    return BattleFieldType.EpidemicZone
  end
  if actType == EnumActivity.ActDsbDuel.Type then
    return BattleFieldType.DsbDuel
  end
end

function BattleFieldUtil.GetTemplateMgrActive()
  local cur = LuaEntry.Player:GetCurWorldType()
  return BattleFieldUtil.GetTemplateMgr(cur)
end

function BattleFieldUtil.ObserveIdx()
  return BattleFieldUtil.watchIdx or 0
end

function BattleFieldUtil.SetLastPingSec()
  BattleFieldUtil.lastPingSec = UITimeManager:GetInstance():GetServerSeconds()
end

function BattleFieldUtil.CoolData()
  return BattleFieldUtil.cool
end

function BattleFieldUtil.InBattleField(bfType)
  local cur = LuaEntry.Player:GetCurWorldType()
  if bfType then
    return bfType == cur
  else
    return cur ~= BattleFieldType.Default
  end
end

function BattleFieldUtil.GetMainUIName(wType)
  local worldType = wType or LuaEntry.Player:GetCurWorldType()
  local config = BattleFieldUtil.GetBaseConfig(worldType)
  if not config then
    return ""
  end
  return config.UIName
end

function BattleFieldUtil.InitSeasonConfigs()
  if BattleFieldUtil.seasonConfigs == nil then
    local configDic = {}
    local configs = {}
    LocalController.instance():visitTable(TableName.LW_BattleField_Season, function(id, lineData)
      local type = lineData.type
      configs[id] = type
      configDic[type] = configDic[type] or {}
      local info = {}
      info.server = lineData.server or {}
      info.season = lineData:getIntValue("season")
      configDic[type][id] = info
    end)
    BattleFieldUtil.seasonConfigDic = configDic
    BattleFieldUtil.seasonConfigs = configs
  end
end

function BattleFieldUtil.GetSeasonCfgId(bfType, season)
  BattleFieldUtil.InitSeasonConfigs()
  local cfgId = bfType * 100000 + season
  local myServer = LuaEntry.Player:GetSourceServerId()
  local dic = BattleFieldUtil.seasonConfigDic[bfType] or {}
  for id, info in pairs(dic) do
    if info.season == season then
      local server = info.server
      local sMin = server[1]
      if sMin ~= nil then
        local sMax = server[2] or server[1]
        if myServer >= sMin and myServer <= sMax then
          return id, true
        end
      end
    end
  end
  return cfgId, false
end

function BattleFieldUtil.GetSeasonConfigById(id)
  BattleFieldUtil.InitSeasonConfigs()
  local template
  if BattleFieldUtil.seasonConfigs[id] ~= nil then
    template = LocalController.instance():getLine(TableName.LW_BattleField_Season, id)
  end
  return template
end

function BattleFieldUtil.GetSeasonConfig(bfType, season)
  local curSeason = SeasonUtil.GetSeason()
  if season > curSeason and season ~= BattleField_SEASON then
    season = curSeason
  end
  if season < 0 then
    season = 0
  end
  BattleFieldUtil.InitSeasonConfigs()
  local id, bFix = BattleFieldUtil.GetSeasonCfgId(bfType, season)
  if not bFix and BattleFieldUtil.seasonConfigs[id] == nil and 0 < season then
    local maxSign = 0
    local maxSeasonLimit = math.min(season, curSeason)
    local dic = BattleFieldUtil.seasonConfigDic[bfType] or {}
    local myServer = LuaEntry.Player:GetSourceServerId()
    for key, info in pairs(dic) do
      local ts = info.season
      if maxSeasonLimit >= ts and maxSign <= ts then
        local inS = true
        local server = info.server
        local sMin = server[1]
        if sMin ~= nil then
          local sMax = server[2] or server[1]
          if myServer < sMin or myServer > sMax then
            inS = false
          end
        end
        if inS then
          maxSign = ts
          id = key
        end
      end
    end
  end
  return BattleFieldUtil.GetSeasonConfigById(id)
end

function BattleFieldUtil.GetBattleFieldCfgValue(bfType, tableKey, season)
  local mgr = BattleFieldUtil.GetMgr(bfType)
  if not mgr then
    return ""
  end
  local config
  if season ~= nil then
    config = BattleFieldUtil.GetSeasonConfig(bfType, season)
  else
    local curCfgId = mgr.GetActSCfgId and mgr:GetActSCfgId()
    if curCfgId ~= nil and curCfgId ~= 0 then
      config = BattleFieldUtil.GetSeasonConfigById(curCfgId)
    end
    if config == nil then
      local curSeason = mgr.GetActSeason and mgr:GetActSeason()
      if curSeason ~= nil then
        config = BattleFieldUtil.GetSeasonConfig(bfType, curSeason)
      end
    end
    if config == nil then
      config = BattleFieldUtil.GetSeasonConfig(bfType, SeasonUtil.GetSeason())
    end
  end
  local tbName = config ~= nil and config:getValue(tableKey) or ""
  return tbName
end

function BattleFieldUtil.GetSeasonConfigVal(configId, key)
  if not configId then
    return
  end
  local line = LocalController.instance():getLine(TableName.LW_BattleField_Season, configId)
  return line and line[key]
end

function BattleFieldUtil.GetRuleList(bfType, theType)
  local ruleList = {}
  local rules_id = BattleFieldUtil.GetBattleFieldCfgValue(bfType, BattleFieldTableKey.RULES)
  LocalController:instance():visitTable(TableName.LW_BattleField_Rules, function(id, lineData)
    local battle_type = lineData:getIntValue("battle_type")
    local group_id = lineData:getValue("group_id")
    local type = lineData:getIntValue("type")
    if battle_type ~= bfType or group_id ~= rules_id or type ~= theType then
      return
    end
    table.insert(ruleList, {
      id = id,
      order = lineData:getIntValue("order"),
      title = lineData:getValue("title"),
      desc1 = lineData:getValue("desc1"),
      desc2 = lineData:getValue("desc2"),
      battle_building = lineData:getIntValue("battle_building"),
      battle_skill = lineData:getValue("battle_skill"),
      new_tag = lineData:getValue("new_tag"),
      reward_point = lineData:getIntValue("reward_point")
    })
  end)
  table.sort(ruleList, function(a, b)
    return a.order < b.order
  end)
  return ruleList
end

function BattleFieldUtil.GetGuideList(bfType)
  local guideList = {}
  local curGroupId = BattleFieldUtil.GetBattleFieldCfgValue(bfType, BattleFieldTableKey.GUIDE)
  LocalController:instance():visitTable(TableName.LW_BattleField_Guide, function(id, lineData)
    local battle_type = lineData:getIntValue("battle_type")
    local group_id = lineData:getValue("group_id")
    if battle_type == bfType and group_id == curGroupId then
      table.insert(guideList, {
        num = lineData:getIntValue("id"),
        tittle = lineData:getValue("tittle"),
        battle_type = battle_type,
        group_id = group_id,
        big_pic = lineData:getValue("big_pic"),
        small_pic = lineData:getValue("small_pic_list"),
        desc = lineData:getValue("small_pic_desc_list")
      })
    end
  end)
  table.sort(guideList, function(a, b)
    return a.num < b.num
  end)
  return guideList
end

function BattleFieldUtil.CanMultiAssistance(bfType)
  local multiAssistance = BattleFieldUtil.GetBattleFieldCfgValue(bfType, BattleFieldTableKey.MULTIPLE_ASSISTANCE)
  multiAssistance = tonumber(multiAssistance) or 0
  return 0 < multiAssistance
end

local UPDATE_NOTE_KEY = "_BattleFiled_UpdateNote_"

function BattleFieldUtil.CheckShowUpdateNote(bfType, season)
  local id = BattleFieldUtil.GetSeasonCfgId(bfType, season)
  local flag = CommonUtil.PlayerPrefsGetBool(UPDATE_NOTE_KEY .. id, false)
  if flag then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldUpDateNote, {anim = true}, bfType, season)
end

function BattleFieldUtil.SignUpdateNoteFlag(bfType, season)
  local id = BattleFieldUtil.GetSeasonCfgId(bfType, season)
  CommonUtil.PlayerPrefsSetBool(UPDATE_NOTE_KEY .. id, true)
end

function BattleFieldUtil.SetObserve(bWatching)
  BattleFieldUtil.isObserve = bWatching
  if not bWatching then
    BattleFieldUtil.watchIdx = 0
  end
  CS.GameEntry.Data.Player.IsBattleFieldWatching = bWatching
end

local BFS_TEST = 1
local BFS_L = {
  9001,
  9002,
  9003,
  9004,
  9005
}

function BattleFieldUtil.CleanTestJump(errCode)
  if not BattleFieldUtil.BTestJump() then
    return
  end
  if not errCode then
    GMUtils.Close()
    return
  end
  BFS_TEST = BFS_TEST + 1
  if BFS_TEST > #BFS_L then
    BFS_TEST = 1
  end
end

function BattleFieldUtil.DebugEnterBattlefield(bfType)
  if not CommonUtil.IsDebug() then
    return
  end
  BattleFieldUtil.testJump = true
  if BFS_TEST > #BFS_L then
    BFS_TEST = 1
  end
  local sId = BFS_L[BFS_TEST]
  local t = {
    pId = 500500,
    server = sId,
    world = 1,
    cool = {
      moveCount = 0,
      costCount = 1,
      coolTime = 0
    }
  }
  local mgr = BattleFieldUtil.GetMgr(bfType)
  if mgr then
    mgr:OnHandleEnterBattleMessage(t, true)
    BattleFieldUtil.SetObserve(true)
  end
end

function BattleFieldUtil.GMEnterBattlefield(bfType)
  if bfType == BattleFieldType.DsbDuel then
    SFSNetwork.SendMessage(MsgDefines.TestBattleEnter, bfType)
  end
end

function BattleFieldUtil.InSceneStopEnterMap(showTips)
  local flag = false
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWCloud) or CS.ApplicationLaunch.Instance.Loading.IsLoading or CS.SceneManager.IsInPVE() or DataCenter.LWHummerSceneManager.inHummerScene or DataCenter.LWSeasonTowerSceneManager.inSeasonTowerScene then
    flag = true
  end
  if flag and showTips then
    UIUtil.ShowTipsId("winter_s0_tips_17")
  end
  return flag
end

function BattleFieldUtil.CanGotoMap(bfType)
  if BattleFieldUtil.BTestJump() then
    return
  end
  local mainIndex = LuaEntry.Player:GetBattleFieldPos()
  if mainIndex ~= nil and toInt(mainIndex) > 0 then
    return
  end
  local mgr = BattleFieldUtil.GetMgr(bfType)
  local tipsId
  if mgr and mgr.CanGotoMap then
    tipsId = mgr:CanGotoMap()
  end
  return tipsId
end

function BattleFieldUtil.GetBattlefieldBuildTemplate(id)
  local battlefieldType = LuaEntry.Player:GetCurWorldType()
  return BattleFieldUtil.GetBuildTemplate(id, battlefieldType)
end

function BattleFieldUtil.GetBuildTemplate(buildId, bfType)
  local templateMgr = BattleFieldUtil.GetTemplateMgr(bfType)
  if templateMgr then
    return templateMgr:GetTemplate(buildId)
  end
  return nil
end

function BattleFieldUtil.SetBattleFieldCanEnterFlag(worldType)
  if worldType == nil then
    return
  end
  local key = toInt(worldType)
  BattleFieldUtil.battleFieldCanEnterFlags = BattleFieldUtil.battleFieldCanEnterFlags or {}
  local flags = BattleFieldUtil.battleFieldCanEnterFlags
  if flags[key] == true then
    return
  end
  flags[key] = true
  EventManager:GetInstance():Broadcast(EventId.BattleFieldCanEnterPush, key)
end

function BattleFieldUtil.GetBattleFieldCanEnterFlag(worldType)
  if worldType == nil then
    return false
  end
  local flags = BattleFieldUtil.battleFieldCanEnterFlags
  if flags == nil then
    return false
  end
  return flags[toInt(worldType)] == true
end

function BattleFieldUtil.ClearBattleFieldCanEnterFlag(worldType)
  if worldType == nil then
    return
  end
  local flags = BattleFieldUtil.battleFieldCanEnterFlags
  if flags == nil then
    return
  end
  local key = toInt(worldType)
  if flags[key] == nil then
    return
  end
  flags[key] = nil
  EventManager:GetInstance():Broadcast(EventId.BattleFieldCanEnterPush, key)
end

function BattleFieldUtil.CheckCanEnterBattlefield(bfType, bWatch)
  local mgr = BattleFieldUtil.GetMgr(bfType)
  if not mgr then
    return false
  end
  if not mgr.CheckCanEnterBattlefield then
    return true
  end
  for i = BattlefieldEnterCheckType.MIN, BattlefieldEnterCheckType.MAX do
    if not bWatch or i ~= BattlefieldEnterCheckType.InBlackRect then
      local valid, canEnter = mgr:CheckCanEnterBattlefield(i)
      if valid and not canEnter then
        return false
      end
    end
  end
  return true
end

function BattleFieldUtil.CheckCanEnterBattlefieldByCheckType(bfType, checkType)
  local mgr = BattleFieldUtil.GetMgr(bfType)
  if not mgr then
    return nil, nil, nil
  end
  return mgr:CheckCanEnterBattlefield(checkType)
end

function BattleFieldUtil.CheckCanGotoBattleField(serverId, worldId, worldType)
  local tipsId
  local sId, wId = BattleFieldUtil.GetBattleServerInfo(worldType)
  if worldType ~= nil and worldType ~= BattleFieldType.Default then
    tipsId = BattleFieldUtil.CanGotoMap(worldType)
    if tipsId == nil and (sId ~= serverId or wId ~= worldId) then
      tipsId = 500018
    end
  elseif worldId ~= nil and 0 < worldId then
    tipsId = 500018
  end
  if tipsId ~= nil then
    UIUtil.ShowTipsId(tipsId)
    return false
  end
  return true
end

function BattleFieldUtil.GetMapBaseName(bfType)
  local config = BattleFieldUtil.GetBaseConfig(bfType)
  if not config then
    return
  end
  return config.MapBaseName
end

function BattleFieldUtil.GetMapObj(bfType)
  local world = CS.SceneManager.World
  local baseObj = world ~= nil and world.GetDragonLandRangeObj ~= nil and world:GetDragonLandRangeObj() or nil
  if IsNull(baseObj) then
    local mapBaseName = BattleFieldUtil.GetMapBaseName(bfType)
    if not string.IsNullOrEmpty(mapBaseName) then
      local mapInfo = BattleFieldUtil.GetBattleFieldMapCfg(bfType)
      local world_terrain = mapInfo ~= nil and BattleFieldUtil.GetMapExtStr(mapInfo.world_terrain) or ""
      baseObj = CS.UnityEngine.GameObject.Find(string.format("%s%s(Clone)", mapBaseName, world_terrain))
    end
  end
  return baseObj
end

function BattleFieldUtil.InMap(bfType)
  if not SceneUtils.GetIsInWorld() then
    return false
  end
  if not BattleFieldUtil.InBattleField(bfType) then
    return false
  end
  local mapObj = BattleFieldUtil.GetMapObj(bfType)
  return not IsNull(mapObj)
end

function BattleFieldUtil.CheckStatus()
  for i = 1, 3 do
    if BattleFieldUtil.InMap(i) then
      local serverId, worldId = BattleFieldUtil.GetBattleServerInfo(i)
      BattleFieldUtil.UpdateBattleServerInfo(serverId, worldId, i)
      break
    end
  end
end

function BattleFieldUtil.GetCurBattleFieldType()
  local worldType = LuaEntry.Player:GetCurWorldType()
  return worldType
end

function BattleFieldUtil.UpdateBattleServerInfo(serverId, worldId, bfType, bSign)
  if bfType == BattleFieldType.Desert then
    local mg = DataCenter.ActDragonManager:GetCurGroup()
    if mg then
      mg.battleServerId = serverId
      mg.worldId = worldId
    end
  elseif bfType == BattleFieldType.WinterStorm then
    local mr = DataCenter.ActWinterStormManager:GetMarchResult()
    if mr ~= nil then
      mr.battleServerId = serverId
      mr.worldId = worldId
    end
  elseif bfType == BattleFieldType.EpidemicZone then
  end
  LuaEntry.Player:SetWorldType(bfType)
  if not bSign then
    LuaEntry.Player:SetWorldId(worldId)
    LuaEntry.Player:SetCrossServerId(serverId)
  end
  BattleFieldUtil.battleServerId = toInt(serverId)
  BattleFieldUtil.battleWorldId = toInt(worldId)
  Setting:SetPrivateInt(LastDragonServerId, BattleFieldUtil.battleServerId)
  Setting:SetPrivateInt(LastDragonWorldId, BattleFieldUtil.battleWorldId)
end

function BattleFieldUtil.GetBattleServerInfo(bfType)
  local serverId = BattleFieldUtil.battleServerId or -1
  if serverId == -1 then
    serverId = Setting:GetPrivateInt(LastDragonServerId, -1)
  end
  local worldId = BattleFieldUtil.battleWorldId or 0
  if worldId == 0 then
    worldId = Setting:GetPrivateInt(LastDragonWorldId, -1)
  end
  if bfType == BattleFieldType.Desert then
    local mg = DataCenter.ActDragonManager:GetCurGroup()
    if serverId == 0 and mg ~= nil then
      serverId = mg.battleServerId or 0
      worldId = mg.worldId or 0
    end
  elseif bfType == BattleFieldType.WinterStorm then
    local mr = DataCenter.ActWinterStormManager:GetMarchResult()
    if serverId == 0 and mr ~= nil then
      serverId = mr.battleServerId
      worldId = mr.worldId
    end
  elseif bfType == BattleFieldType.EpidemicZone then
  end
  return serverId, worldId
end

function BattleFieldUtil.OnBackSelfServerFromBattleField()
  CS.WorldScene.EndBattlefieldSample()
  local worldType = LuaEntry.Player:GetCurWorldType()
  if worldType == BattleFieldType.Desert then
    DataCenter.ActDragonManager:CleanOrderMark()
  elseif worldType == BattleFieldType.WinterStorm then
    BattleFieldPingUtil.CleanPingMark()
  elseif worldType == BattleFieldType.EpidemicZone then
    if BattleFieldUtil.isObserve then
      DataCenter.ActEpidemicZoneManager:ReqBattleWatchExit()
    end
    BattleFieldPingUtil.CleanPingMark()
  end
  BattleFieldUtil.Reset()
  BattleFieldUtil.UpdateBattleServerInfo(-1, 0, 0)
end

function BattleFieldUtil.BackToCity(bfType, cb)
  if bfType == BattleFieldType.Desert then
    DataCenter.ActDragonManager:CleanOrderMark()
  elseif bfType == BattleFieldType.WinterStorm then
    DataCenter.ActWinterStormManager:CleanResult()
    BattleFieldPingUtil.CleanPingMark()
  elseif bfType == BattleFieldType.EpidemicZone then
    DataCenter.ActEpidemicZoneManager:CleanBattleInfo()
    BattleFieldPingUtil.CleanPingMark()
  end
  CrossServerUtil.OnBackSelfServerFromDragonWorld()
  DataCenter.AllianceWarDataManager:CleanDragonWar()
  DataCenter.WorldMarchDataManager:CleanDragonWar()
  SceneUtils.ChangeToCity(function()
    LuaEntry.Player:SetBattleFieldPointId(-1)
    if cb then
      cb()
    end
  end)
end

BattleFieldUtil.desertTimes = nil

local function InitDesertTime()
  BattleFieldUtil.desertTimes = {}
  local battleStartTime = LuaEntry.DataConfig:TryGetStr("dragon_battle_time", "k7")
  local battleDurationSec = LuaEntry.DataConfig:TryGetNum("dragon_battle_time", "k6")
  local _times = string.split(battleStartTime, ";")
  for k, v in ipairs(_times) do
    local hs = string.split(v, "-")
    if hs and #hs == 2 then
      local hh = tonumber(hs[1]) or 0
      local mm = tonumber(hs[2]) or 0
      table.insert(BattleFieldUtil.desertTimes, {
        [1] = hh * 3600 + mm * 60,
        [2] = hh * 3600 + mm * 60 + battleDurationSec
      })
    end
  end
end

function BattleFieldUtil.GetDesertOpenTime()
  if not BattleFieldUtil.desertTimes then
    InitDesertTime()
  end
  return BattleFieldUtil.desertTimes
end

function BattleFieldUtil.GetDesertOpenTimeByIndex(index)
  local nIdx = tonumber(index) or 1
  nIdx = Mathf.Clamp(nIdx, 1, 3)
  if not BattleFieldUtil.desertTimes then
    InitDesertTime()
  end
  return BattleFieldUtil.desertTimes[nIdx] or {}
end

function BattleFieldUtil.OnReconnect(bfType)
  if not BattleFieldUtil.InMap(bfType) then
    return
  end
  if BattleFieldUtil.isObserve then
    BattleFieldUtil.BackToCity(bfType)
    return
  end
  BattleFieldUtil.BackToCity(bfType, function()
    local mgr = BattleFieldUtil.GetMgr(bfType)
    if mgr then
      mgr:TryEnterBattlefield()
    end
  end)
end

function BattleFieldUtil.CrossEnterReq(bfType)
  local mgr = BattleFieldUtil.GetMgr(bfType)
  if mgr then
    if mgr.ReqBattleEffect then
      mgr:ReqBattleEffect()
    end
    if bfType == BattleFieldType.Desert then
      mgr:RequestBattleInfo(true)
    end
  end
end

function BattleFieldUtil.TryEnterBattlefieldFromShare(params)
  if not params or params.worldId == nil or params.worldType == nil then
    return false
  end
  local worldType = tonumber(params.worldType) or 0
  local pointId = tonumber(params.pointId) or 0
  local allianceId = params.allianceId
  local groupIdx = tonumber(params.actDragonGroup) or 0
  local mgr = BattleFieldUtil.GetMgr(worldType)
  if mgr == nil then
    return false
  end
  if worldType == BattleFieldType.WinterStorm then
    return mgr:TryEnterBattlefield(nil, pointId)
  end
  if allianceId == nil or allianceId ~= LuaEntry.Player:GetAllianceUid() then
    UIUtil.ShowTipsId(458141)
    return false
  end
  local myGroupIdx
  if worldType == BattleFieldType.DsbDuel then
    myGroupIdx = BattlefieldDsbDuelUtils.GetMyTeam()
  elseif worldType == BattleFieldType.EpidemicZone or worldType == BattleFieldType.Desert then
    myGroupIdx = mgr:GetCurGroupIdx()
  end
  if myGroupIdx ~= nil then
    if (groupIdx == 0 or groupIdx == myGroupIdx) and mgr:CanShowEnter() then
      return mgr:TryEnterBattlefield(nil, pointId)
    end
    return mgr:TryEnterBattlefield(groupIdx, pointId)
  end
  return false
end

function BattleFieldUtil.HandleEnterWorld(bfType, t, enterCB)
  BattleFieldUtil.soliderUuid = t.soliderUuid
  if t.soliderUuid ~= nil then
    DataCenter.SoldierDataManager:CleanDragonSoldier(t.soliderUuid)
  end
  if t.server == nil or t.server == 0 or t.world == nil or t.world == 0 then
    UIUtil.ShowTipsId("E100087")
    return
  end
  local willPos = SceneUtils.TileIndexToWorld(t.pId or 500500, ForceChangeScene.World)
  if t.pId then
    LuaEntry.Player:SetBattleFieldPointId(t.pId)
    if BattleFieldUtil.prePointId == nil then
      BattleFieldUtil.prePointId = t.pId
    end
  end
  if t.cool then
    BattleFieldUtil.cool = t.cool
    EventManager:GetInstance():Broadcast(EventId.DragonCityMoveCoolDown, t.cool)
  end
  DataCenter.ArmyFormationDataManager.UseBattleFieldFlag = true
  BattleFieldUtil.UpdateBattleServerInfo(t.server, t.world, bfType, true)
  GoToUtil.CloseAllWindows()
  local prePoint = BattleFieldUtil.prePointId
  BattleFieldUtil.prePointId = nil
  if BattleFieldUtil.isObserve and (prePoint == nil or prePoint == 0) then
    prePoint = 500500
  end
  local initZoom = CS.SceneManager.World ~= nil and CS.SceneManager.World.InitZoom or 240
  
  local function _callback()
    if enterCB then
      enterCB()
    end
    if prePoint == nil or prePoint == 0 then
      GoToUtil.GotoDragonBuildPos()
    else
      local args = {}
      args.worldPos = SceneUtils.TileIndexToWorld(prePoint, ForceChangeScene.World)
      args.zoom = initZoom
      GoToUtil.GotoBattlefield(args)
    end
  end
  
  if (bfType == BattleFieldType.Desert or bfType == BattleFieldType.EpidemicZone or bfType == BattleFieldType.DsbDuel) and BattleFieldUtil.InBattleField(bfType) then
    local mapObj = BattleFieldUtil.GetMapObj(bfType)
    if not IsNull(mapObj) then
      UIUtil.PlayCutSceneAnim(function()
        CrossServerUtil.SyncDragonWorldData(t.server, t.world, bfType)
        _callback()
        EventManager:GetInstance():Broadcast(EventId.DragonWatchStateChange)
        if bfType == BattleFieldType.Desert then
          EventManager:GetInstance():Broadcast(EventId.HospitalUpdate)
        end
      end, nil, t.server)
      return
    end
  end
  local args = {}
  args.worldPos = willPos
  args.zoom = initZoom
  args.time = 0.02
  args.onComplete = _callback
  args.serverId = t.server
  args.worldId = t.world
  args.worldType = bfType
  GoToUtil.GotoBattlefield(args)
end

function BattleFieldUtil.GetSoldiersInfo()
  local info = {}
  local soldier = DataCenter.SoldierDataManager:GetDragonSoldierInfo()
  if soldier then
    local finishSoldierNum = 0
    if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
      finishSoldierNum = DataCenter.ActDragonManager:GetTreatmentFinishSoldierNum() or 0
    elseif BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
      finishSoldierNum = DataCenter.BattlefieldDsbDuelManager:GetTreatmentFinishSoldierNum() or 0
    end
    info.id = soldier.id
    info.count = soldier.count
    info.finishSoldierNum = finishSoldierNum
    info.lv = soldier.lv
    info.heal = 0
    info.dead = 0
    local _soldierInfo = DataCenter.HospitalManager:FindHospitalInfo(info.id)
    if _soldierInfo then
      info.heal = _soldierInfo.heal or 0
      info.dead = _soldierInfo.dead or 0
    end
    info.total = info.count + info.finishSoldierNum + (info.heal or 0) + (info.dead or 0)
    local template = DataCenter.SoldierDataManager:GetTemplate(info.id)
    info.quality = template.quality
  end
  return info
end

function BattleFieldUtil.GetBuildTemplate(buildId, bfType, season)
  if bfType == BattleFieldType.Desert then
    return DataCenter.DragonBuildTemplateManager:GetTemplate(buildId, season)
  elseif bfType == BattleFieldType.WinterStorm then
    return DataCenter.WinterStormTemplateManager:GetTemplate(buildId, season)
  elseif bfType == BattleFieldType.EpidemicZone then
    return DataCenter.EpidemicBuildTemplateMgr:GetTemplate(buildId, season)
  elseif bfType == BattleFieldType.DsbDuel then
    return DataCenter.BattlefieldDsbDuelTemplateManager:GetBuildTemplate(buildId, season)
  end
end

function BattleFieldUtil.GetMiniMapSpritePath(detailInfo, bfType, bSp)
  if bfType == BattleFieldType.Desert then
    return DataCenter.DragonBuildTemplateManager:GetDragonMiniMapSpritePath(detailInfo, bSp)
  elseif bfType == BattleFieldType.WinterStorm then
    return DataCenter.WinterStormTemplateManager:GetWinterEntityMiniMapSpritePath(detailInfo, bSp)
  elseif bfType == BattleFieldType.EpidemicZone then
    return DataCenter.EpidemicBuildTemplateMgr:GetMiniMapSpritePath(detailInfo, bSp)
  elseif bfType == BattleFieldType.DsbDuel then
    return DataCenter.BattlefieldDsbDuelTemplateManager:GetMiniMapSpritePathByBuildId(detailInfo)
  end
  return ""
end

function BattleFieldUtil.GetBattlefieldPreviewSpritePath(detailInfo, bfType, bSp)
  if bfType == BattleFieldType.Desert then
    return BattleFieldUtil.GetMiniMapSpritePath(detailInfo, bfType, bSp)
  elseif bfType == BattleFieldType.WinterStorm then
    return BattleFieldUtil.GetMiniMapSpritePath(detailInfo, bfType, bSp)
  elseif bfType == BattleFieldType.EpidemicZone then
    return BattleFieldUtil.GetMiniMapSpritePath(detailInfo, bfType, bSp)
  elseif bfType == BattleFieldType.DsbDuel then
    return DataCenter.BattlefieldDsbDuelTemplateManager:GetBattlefieldPreviewSpritePath(detailInfo)
  end
  return ""
end

function BattleFieldUtil.GetWorldCampInBattleField(param, bfType)
  if bfType == BattleFieldType.Desert then
    return param == LuaEntry.Player:GetAllianceUid() and WorldCamp.Ally or WorldCamp.Enemy
  elseif bfType == BattleFieldType.WinterStorm then
    return DataCenter.ActWinterStormManager:GetWorldCampInWinterStorm(param)
  elseif bfType == BattleFieldType.EpidemicZone then
    return DataCenter.ActEpidemicZoneManager:GetWorldCampInEpidemic(param)
  elseif bfType == BattleFieldType.DsbDuel then
    return DataCenter.BattlefieldDsbDuelManager:GetWorldCamp(param)
  end
  return WorldCamp.Neutral
end

function BattleFieldUtil.IsBattleFieldEnemy(param, bfType)
  local worldCamp = BattleFieldUtil.GetWorldCampInBattleField(param, bfType)
  return worldCamp == WorldCamp.WsEnemy or worldCamp == WorldCamp.Enemy
end

function BattleFieldUtil.OnSpecialWorldCreate()
  local wType = LuaEntry.Player:GetCurWorldType()
  local mgr = BattleFieldUtil.GetMgr(wType)
  if mgr then
    mgr:UpdateMapBR()
  end
end

function BattleFieldUtil.GetMapExtStr(value)
  if string.IsNullOrEmpty(value) then
    return ""
  end
  return "_" .. value
end

function BattleFieldUtil.GetSpecialWorldCreateInfo()
  local wType = LuaEntry.Player:GetCurWorldType()
  local mapInfo = BattleFieldUtil.GetBattleFieldMapCfg(wType)
  local world_deco_byte, world_deco_asset, world_terrain = "", "", ""
  if mapInfo ~= nil then
    world_terrain = BattleFieldUtil.GetMapExtStr(mapInfo.world_terrain)
    world_deco_byte = BattleFieldUtil.GetMapExtStr(mapInfo.world_deco_byte)
    world_deco_asset = BattleFieldUtil.GetMapExtStr(mapInfo.world_deco_asset)
  end
  local nameBase = BattleFieldUtil.GetMapBaseName(wType)
  if string.IsNullOrEmpty(nameBase) then
    return {
      "",
      "",
      ""
    }
  end
  local worldBase, sceneBase
  local config = BattleFieldUtil.GetBaseConfig(wType)
  if config then
    worldBase = config.WorldPrefabPath
    sceneBase = config.ScenePath
  end
  if not worldBase or not sceneBase then
    return {
      "",
      "",
      ""
    }
  end
  return {
    string.format("%s/%s%s.prefab", worldBase, nameBase, world_terrain),
    string.format("%s/%s%s.bytes", sceneBase, nameBase, world_deco_byte),
    string.format("%s/%s%s.asset", sceneBase, nameBase, world_deco_asset)
  }
end

function BattleFieldUtil.GetPlayerSideInBattleField(bfType)
  if bfType == BattleFieldType.Desert then
    local battleInfo = DataCenter.ActDragonManager:GetCurBattleInfo()
    if battleInfo then
      return battleInfo.selfSide
    end
  elseif bfType == BattleFieldType.WinterStorm then
    return DataCenter.ActWinterStormManager:GetMySide()
  elseif bfType == BattleFieldType.EpidemicZone then
    return DataCenter.ActEpidemicZoneManager:GetCurSide()
  elseif bfType == BattleFieldType.DsbDuel then
    return BattlefieldDsbDuelUtils.GetMyRoleId()
  end
  return -1
end

function BattleFieldUtil.GetAllBuildSize()
  local list = {}
  local list1 = DataCenter.DragonBuildTemplateManager:GetALLBuildSize()
  for _, v in ipairs(list1) do
    table.insert(list, v)
  end
  local list2 = DataCenter.WinterStormTemplateManager:GetALLBuildSize()
  for _, v in ipairs(list2) do
    table.insert(list, v)
  end
  local list3 = DataCenter.EpidemicBuildTemplateMgr:GetALLBuildSize()
  for _, v in ipairs(list3) do
    table.insert(list, v)
  end
  local list4 = DataCenter.BattlefieldDsbDuelTemplateManager:GetALLBuildSize()
  for _, v in ipairs(list4) do
    table.insert(list, v)
  end
  return list
end

function BattleFieldUtil.HandleEffects(t, bfType)
  local list
  if bfType == BattleFieldType.Desert then
    list = t.effect or nil
  elseif bfType == BattleFieldType.WinterStorm then
    list = t.battleEffect or nil
  elseif bfType == BattleFieldType.EpidemicZone then
    local effList, effDic = DataCenter.ActEpidemicZoneManager:HandleEffects(t)
    BattleFieldUtil.effectList = effList
    BattleFieldUtil.effectDic = effDic
    EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus)
    return
  elseif bfType == BattleFieldType.DsbDuel then
    local effList, effDic = DataCenter.BattlefieldDsbDuelManager:HandleEffects(t)
    BattleFieldUtil.effectList = effList
    BattleFieldUtil.effectDic = effDic
    EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus)
  end
  if list ~= nil then
    local effList = {}
    local effDic = {}
    local id, value, curNum
    for k, v in pairs(list) do
      id = tostring(k)
      value = toInt(v)
      curNum = effDic[id] or 0
      effDic[id] = curNum + value
      table.insert(effList, {
        id = id,
        value = value,
        bfType = bfType,
        template = BattleFieldUtil.GetEffectInfo(id, bfType)
      })
    end
    BattleFieldUtil.effectList = effList
    BattleFieldUtil.effectDic = effDic
    EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus)
  end
end

function BattleFieldUtil.TryUpdateBattleEffects(bfType, effList, effDic)
  if bfType ~= BattleFieldUtil.GetCurBattleFieldType() then
    return
  end
  BattleFieldUtil.effectList = effList
  BattleFieldUtil.effectDic = effDic
  EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus)
end

function BattleFieldUtil.GetEffectById(id)
  local num = 0
  if id ~= nil and id ~= 0 and BattleFieldUtil.InBattleField() then
    if not BattleFieldUtil.effectDic then
      num = 0
    else
      num = BattleFieldUtil.effectDic[tostring(id)] or 0
    end
  end
  return num
end

function BattleFieldUtil.GetEffectInfo(effId, bfType)
  if not effId then
    return
  end
  if bfType == BattleFieldType.Desert then
    return DataCenter.DragonBuildTemplateManager:GetEffectInfo(effId)
  elseif bfType == BattleFieldType.WinterStorm then
    return DataCenter.WinterStormTemplateManager:GetEffectInfo(effId)
  elseif bfType == BattleFieldType.DsbDuel then
    return DataCenter.BattlefieldDsbDuelTemplateManager:GetEffectInfo(effId)
  end
end

function BattleFieldUtil.LeaveBattlefield()
  if BattleFieldUtil.InBattleField() then
    UIUtil.PlayCutSceneAnim(function()
      LuaEntry.Player:SetBattleFieldPointId(-1)
      CrossServerUtil.OnBackSelfServerFromDragonWorld(SceneType.City)
      SceneUtils.ChangeToCity()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SwitchScene01)
    end, nil, LuaEntry.Player:GetSelfServerId())
    return
  end
end

function BattleFieldUtil.GetEffectListWithInfo()
  local rtList = {}
  local list = BattleFieldUtil.effectList or {}
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  for _, info in ipairs(list) do
    if (info.value == nil or info.value > 0) and info.template and (info.expireTime == nil or curSec < info.expireTime) then
      table.insert(rtList, info)
    end
  end
  return rtList
end

function BattleFieldUtil._DoOpenHospital()
  local bfType = LuaEntry.Player:GetCurWorldType()
  if bfType == BattleFieldType.EpidemicZone then
    local flag = DataCenter.ActEpidemicZoneManager:CheckCureRed()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleHeal, {anim = true}, flag and 1 or 2)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIHospital)
  end
end

function BattleFieldUtil.TryOpenHospital()
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.DragonHospital)
  if queue ~= nil then
    local state = queue:GetQueueState()
    if state == NewQueueState.Finish then
      SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
        uuid = queue.uuid
      })
    end
  end
  BattleFieldUtil._DoOpenHospital()
end

function BattleFieldUtil.GetDetailInfoByCfgId(cfgId)
  local theWorld = CS.SceneManager.World
  local list = theWorld ~= nil and theWorld:GetAllDragonPointList() or nil
  if list == nil then
    return nil
  end
  for _, v in pairs(list) do
    local detailInfo = v.detail
    local buildId = detailInfo ~= nil and (detailInfo.BuildId or detailInfo.ItemId) or nil
    if buildId == cfgId then
      return detailInfo
    end
  end
  return nil
end

function BattleFieldUtil.GetBattleFieldMapCfg(bfType, updateBlock)
  local mgr = BattleFieldUtil.GetMgr(bfType)
  if not mgr then
    return
  end
  local actInfo = mgr:GetActInfo()
  if actInfo == nil then
    return
  end
  local seasonMapInfo = actInfo.seasonMapInfo or nil
  if seasonMapInfo ~= nil then
    if updateBlock then
      BattleFieldUtil.SetBlockRangeData(seasonMapInfo.world_block, bfType)
    end
    return seasonMapInfo
  end
  local mapId = BattleFieldUtil.GetBattleFieldCfgValue(bfType, BattleFieldTableKey.MAP)
  local line = LocalController.instance():getLine(TableName.LW_BattleField_Map, mapId)
  if line == nil then
    return
  end
  seasonMapInfo = {
    world_deco_byte = line:getValue("world_deco_byte"),
    world_deco_asset = line:getValue("world_deco_asset"),
    world_terrain = line:getValue("world_terrain"),
    world_block = line:getIntValue("world_block", 0),
    troop_line_color = line:getValue("troopline_color"),
    camera_rot_range = line:getValue("camera_rot_range"),
    map_area = line:getIntValue("map_area")
  }
  local cameraValue = line:getValue("camera_para")
  if type(cameraValue) == "table" then
    seasonMapInfo.camera_para = cameraValue
  else
    seasonMapInfo.camera_para = string.string2array_i_oneSep(cameraValue or "", ",")
  end
  actInfo.seasonMapInfo = seasonMapInfo
  if updateBlock then
    BattleFieldUtil.SetBlockRangeData(seasonMapInfo.world_block, bfType)
  end
  return seasonMapInfo
end

function BattleFieldUtil.GetBattleFieldMiniMapArea(bfType)
  local mapCfg = BattleFieldUtil.GetBattleFieldMapCfg(bfType)
  if mapCfg == nil then
    local mapId = BattleFieldUtil.GetBattleFieldCfgValue(bfType, BattleFieldTableKey.MAP)
    mapCfg = LocalController.instance():getLine(TableName.LW_BattleField_Map, mapId)
  end
  local infos = {}
  if mapCfg ~= nil then
    local map_area = mapCfg.map_area
    LocalController.instance():visitTable(TableName.LW_BattleField_MiniMap, function(_, line)
      if line.group_id == map_area and line.battle_type == bfType then
        local id = line:getIntValue("mapId")
        local coordinate = line:getValue("coordinate")
        local x = coordinate ~= nil and coordinate[1] or 0
        local y = coordinate ~= nil and coordinate[2] or 0
        local mainIndex = id < 100 and id or SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
        local area = line:getValue("area")
        local w = area ~= nil and area[1] or 0
        local h = area ~= nil and area[2] or 0
        infos[id] = {
          id = id,
          mainIndex = mainIndex,
          x = x,
          y = y,
          w = w,
          h = h
        }
      end
    end)
  end
  return infos
end

function BattleFieldUtil.GetBattleFieldCameraParam(bfType)
  local mapCfg = BattleFieldUtil.GetBattleFieldMapCfg(bfType, true)
  local rotMin = 37
  local rotMax = 54.5
  if mapCfg ~= nil then
    local array = mapCfg.camera_para
    local rotRange = mapCfg.camera_rot_range
    rotMin = rotRange and rotRange[1] or rotMin
    rotMax = rotRange and rotRange[2] or rotMax
    return array[2], array[1], rotMin, rotMax, mapCfg
  end
  return 80, 240, rotMin, rotMax
end

function BattleFieldUtil.GetBattleFieldWorldSize(bfType)
  local mapCfg = BattleFieldUtil.GetBattleFieldMapCfg(bfType)
  if mapCfg ~= nil then
    local array = mapCfg.camera_para
    if array[3] and array[4] then
      return array[3], array[4]
    end
  end
  local config = BattleFieldUtil.GetBaseConfig(bfType)
  if config then
    return table.unpack(config.BattlefieldSize)
  end
  return 500, 500
end

function BattleFieldUtil.GetBattleFieldRange(bfType)
  local x, y = BattleFieldUtil.GetBattleFieldWorldSize(bfType)
  local center = 500
  local halfX = x / 2
  local halfY = y / 2
  return {
    minX = center - halfX,
    maxX = center + halfX,
    minY = center - halfY,
    maxY = center + halfY
  }
end

local PREFAB_SOLIDER_TIP = "Assets/Main/Prefabs/World/BattleField/BattleFieldCitySoliderTip.prefab"
local BING_PATH = "Assets/Main/Sprites/UI/UILWWorld/wxy_jishashibing_"
local COLOR_BING_RED = Color.New(0.9372549019607843, 0.43137254901960786, 0.37254901960784315, 1)
local COLOR_BING_GREEN = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1)

function BattleFieldUtil.PlaySoliderNumChange(bEnemy, pointId, count)
  if count == 0 then
    return
  end
  local imgPath = BING_PATH .. (bEnemy and "hongbing" or "lanbing")
  local color = count < 0 and COLOR_BING_RED or COLOR_BING_GREEN
  BattleFieldUtil.PlayNumChangeTip(pointId, count, imgPath, color)
end

function BattleFieldUtil.PlayMvCDNumChange(pointId, count)
  if count == 0 then
    return
  end
  local imgPath = string.format(LoadPath.LWBattleFieldEpidemicPath, "mjc_yibianjinqu_qiancheng_icon.png")
  local color = 0 < count and COLOR_BING_RED or COLOR_BING_GREEN
  BattleFieldUtil.PlayNumChangeTip(pointId, count, imgPath, color, "s", 2)
end

function BattleFieldUtil.PlayNumChangeTip(pointId, count, imgPath, color, extStr, time)
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(PREFAB_SOLIDER_TIP)
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not SceneUtils.GetIsInWorld() then
      req:Destroy()
      return
    end
    local go = req.gameObject
    go.name = string.format("BattleField_NumChangeTip_%s", pointId)
    go.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    go:SetActive(true)
    local tf = go.transform
    local tip_s_img = tf:Find("TipSImg"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    local tip_s_text = tf:Find("TipSImg/numSText"):GetComponent(typeof(CS.TMPro.TextMeshPro))
    tip_s_img:LoadSpriteAuto(imgPath)
    tip_s_img.transform:Set_localScale(1, 1, 1)
    local str = (count < 0 and "" or "+") .. count
    if extStr then
      str = str .. extStr
    end
    tip_s_text.text = str
    tip_s_text.color = color
    local realTime = time or 1
    local pTime = 0.4
    local seq = CS.DG.Tweening.DOTween.Sequence()
    seq:Join(tf:DOLocalMoveY(0.1, realTime))
    local seq2 = CS.DG.Tweening.DOTween.Sequence()
    seq2:Append(CS.DG.Tweening.DOTween.To(function()
      return 0
    end, function(alpha)
      tip_s_text.color = Color(color.r, color.g, color.b, alpha)
      tip_s_img.color = Color(1, 1, 1, alpha)
    end, 1, pTime):SetEase(CS.DG.Tweening.Ease.InExpo))
    seq2:AppendInterval(math.max(realTime - pTime * 2, 0.1))
    seq2:Append(CS.DG.Tweening.DOTween.To(function()
      return 1
    end, function(alpha)
      tip_s_text.color = Color(color.r, color.g, color.b, alpha)
      tip_s_img.color = Color(1, 1, 1, alpha)
    end, 0, pTime):SetEase(CS.DG.Tweening.Ease.InExpo))
    seq:Join(seq2)
    
    function seq.onComplete()
      if not IsNull(go) then
        go:SetActive(false)
        if req ~= nil then
          req:Destroy()
        end
      end
    end
  end)
end

function BattleFieldUtil._GetBR(bfType)
  if bfType == nil then
    bfType = LuaEntry.Player:GetCurWorldType()
  end
  if not BattleFieldUtil.InBattleField(bfType) then
    return
  end
  local config = BattleFieldUtil.GetBaseConfig(bfType)
  if not config then
    return
  end
  local success, block = pcall(require, config.BlockRangeLua)
  if not success then
    BattleFieldUtil.LogError("Try get blockrange from %s failed. ex:%s", config.BlockRangeLua, block)
    block = nil
  end
  return block
end

function BattleFieldUtil.SetBlockRangeData(idx, bfType)
  local br = BattleFieldUtil._GetBR(bfType)
  if br and br.SetBlockRangeData then
    local data = br.SetBlockRangeData(idx)
    local theWorld = CS.SceneManager.World
    if data and theWorld and theWorld.MapGridRenderer then
      local list = {}
      for y, v in pairs(data) do
        for _, info in pairs(v) do
          table.insert(list, y)
          table.insert(list, info.f)
          table.insert(list, info.t)
          table.insert(list, info.i)
        end
      end
      local l = #list
      local array = LuaCSharpArray.New(l)
      for i, v in ipairs(list) do
        array[i] = v
      end
      local arrayAccess = array:GetCSharpAccess()
      theWorld.MapGridRenderer:SetBlockRangeData(l, arrayAccess)
      array:DestroyCSharpAccess()
      array = nil
      arrayAccess = nil
    end
  end
end

function BattleFieldUtil.IsInBlockRange(pointId, bfType)
  local br = BattleFieldUtil._GetBR(bfType)
  if br and br.IsInBlockRange then
    return br.IsInBlockRange(pointId)
  end
  return false
end

function BattleFieldUtil.GetBlockRangeValue(pointId, bfType)
  local br = BattleFieldUtil._GetBR(bfType)
  if br and br.GetBlockRangeValue then
    return br.GetBlockRangeValue(pointId)
  end
  return 0
end

function BattleFieldUtil.GetNearSafePoint(pointId, bfType, side)
  local br = BattleFieldUtil._GetBR(bfType)
  if br and br.GetNearSafePoint then
    return br.GetNearSafePoint(pointId, side)
  end
  return -1
end

function BattleFieldUtil.CheckHospitalEffState()
  local showHospitalEffect = false
  local showHospitalEffectGreen = false
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.DragonHospital)
  if queue ~= nil then
    local state = queue:GetQueueState()
    if state == NewQueueState.Finish then
      showHospitalEffect = true
    elseif state == NewQueueState.Work then
      showHospitalEffectGreen = true
    end
  end
  if not showHospitalEffect and not showHospitalEffectGreen then
    local deadSoldierCount = 0
    local soldiers = DataCenter.HospitalManager:GetDeadHospital()
    if soldiers then
      for i = 1, #soldiers do
        if soldiers[i].dead then
          deadSoldierCount = deadSoldierCount + soldiers[i].dead
        end
      end
    end
    showHospitalEffect = 0 < deadSoldierCount
  end
  return showHospitalEffect, showHospitalEffectGreen
end

function BattleFieldUtil.CheckPlayerInBF(uid)
  if not BattleFieldUtil.InBattleField() then
    return nil
  end
  local theWorld = CS.SceneManager.World
  if theWorld == nil or not CS.SceneManager:IsInWorld() then
    return false
  end
  local cityList = theWorld:GetAllMainBaseList()
  if cityList == nil then
    return false
  end
  for _, v in pairs(cityList) do
    if v.ownerUid == uid then
      return true, v
    end
  end
  return false
end

function BattleFieldUtil.GetSelfMainCity()
  local flag, pInfo = BattleFieldUtil.CheckPlayerInBF(LuaEntry.Player:GetUid())
  if flag then
    return pInfo
  end
  return nil
end

function BattleFieldUtil.Log(fmt, ...)
  if not CommonUtil.IsDebug() then
    return
  end
  local _ = string.format(fmt, ...)
  _ = string.format("<color=#FFFF00>[Battlefield]%s</color>", _)
  Logger.Log(_)
end

function BattleFieldUtil.LogError(fmt, ...)
  local _ = string.format(fmt, ...)
  _ = "[Battlefield][Error]" .. _
  Logger.LogError(_)
end

function BattleFieldUtil.GetBaseConfig(battlefieldType)
  local config = BattlefieldBaseConfig[battlefieldType]
  if not config and CommonUtil.IsEditor() then
    Logger.LogWarning(string.format("Get battlefield config %s failed!!", battlefieldType))
  end
  return config
end

function BattleFieldUtil.GetCurrentBaseConfig()
  local currentBattlefieldType = BattleFieldUtil.GetCurBattleFieldType()
  return BattleFieldUtil.GetBaseConfig(currentBattlefieldType)
end

function BattleFieldUtil.SaveAssignedInfo(bfType, group, assigned, sPeriod, eTime)
  local str = string.format("%s,%s,%s,%s", group, assigned, sPeriod, eTime)
  CommonUtil.PlayerPrefsSetString(BattleFieldAssignedInfo .. bfType, str)
end

function BattleFieldUtil.GetAssignedInfo(bfType)
  local str = CommonUtil.PlayerPrefsGetString(BattleFieldAssignedInfo .. bfType, "")
  local infos = string.string2array_num_oneSep(str, ",")
  return infos[1] or 0, infos[2] or 0, infos[3] or 0, infos[4] or 0
end

function BattleFieldUtil.BuildOpenCheckWithTime(openTime)
  local battlefieldType = LuaEntry.Player:GetCurWorldType()
  if battlefieldType == BattleFieldType.EpidemicZone then
    return DataCenter.ActEpidemicZoneManager:BuildOpenCheckWithTime(openTime)
  elseif battlefieldType == BattleFieldType.DsbDuel then
    return true
  end
end

function BattleFieldUtil.CreateAsyncBase(type, bfType, view, parent, cb, offsetY, offsetX)
  local baseData = BattleFieldUtil.GetBaseConfig(bfType)
  if not baseData then
    return
  end
  local lua, prefab, name
  local defX, defY = offsetX, offsetY
  if type == 1 then
    lua = baseData.MiniMapLua
    prefab = baseData.MiniMapPrefab
    name = "MiniMap"
    defX = defX or -10
    defY = defY or baseData.MiniMapOffY
  elseif type == 2 then
    lua = baseData.BattleInfoLua
    prefab = baseData.BattleInfoPrefab
    defY = defY or baseData.BattleInfoOffY
    name = "BattleInfo"
  elseif type == 3 then
    lua = baseData.SignPopLua
    prefab = baseData.SignPopPrefab
    defY = defY or baseData.SignPopOffY
    name = "SignPop"
  end
  if not lua or not prefab then
    return
  end
  defX = defX or 0
  defY = defY or 0
  local cls = require(lua)
  local comp
  comp = view:LoadComponentAsync(cls, prefab, parent, function(_, go)
    if type == 2 then
      go.transform:SetAsLastSibling()
    else
      go.transform:SetAsFirstSibling()
    end
    go.name = name
    local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTF ~= nil then
      rectTF:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      if type == 1 then
        local xp = 1
        if CommonUtil.IsArabicAutoMirrorOpen() then
          defX = -1 * defX
          xp = 0
        end
        rectTF:Set_anchorMin(xp, 1)
        rectTF:Set_anchorMax(xp, 1)
        rectTF:Set_pivot(xp, 1)
      elseif type == 2 then
        rectTF:Set_pivot(0.5, 1)
      end
      rectTF:Set_anchoredPosition(defX, defY)
    end
    if cb then
      cb(go, comp)
    end
  end)
  return comp
end

function BattleFieldUtil.CreateMiniMap(bfType, view, parent, cb, offsetY, offsetX)
  return BattleFieldUtil.CreateAsyncBase(1, bfType, view, parent, cb, offsetY, offsetX)
end

function BattleFieldUtil.CreateBattleInfo(bfType, view, parent, cb, offsetY, offsetX)
  return BattleFieldUtil.CreateAsyncBase(2, bfType, view, parent, cb, offsetY, offsetX)
end

function BattleFieldUtil.CreateSignPop(bfType, view, parent, cb, offsetY, offsetX)
  return BattleFieldUtil.CreateAsyncBase(3, bfType, view, parent, cb, offsetY, offsetX)
end

function BattleFieldUtil.Description()
  local sb = StringBuilder.New()
  for i = BattleFieldType.MIN, BattleFieldType.MAX do
    sb:AppendFormatLine("InBattleField %s = %s", i, BattleFieldUtil.InBattleField(i))
  end
  return sb:ToString()
end

function BattleFieldUtil.CanUseSkill()
  if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    if BattleFieldUtil.BTestJump() then
      return true
    end
    return DataCenter.ActEpidemicZoneManager:CheckUseSkill()
  end
  return false
end

function BattleFieldUtil.CanUsePingSign()
  if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    return true
  end
  if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    if BattleFieldUtil.BTestJump() then
      return true
    end
    return DataCenter.ActEpidemicZoneManager:IsSelfCommander()
  end
  return false
end

function BattleFieldUtil.OpenPingSign(pointId, showTips)
  if not BattleFieldUtil.CanUsePingSign() then
    if showTips then
      UIUtil.ShowTipsId("Desert_strom_commander_1027")
    end
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local cdSec = BattleFieldUtil.BASE_PING_CD
  if cdSec == nil then
    local value = BattleFieldUtil.GetBattleFieldCfgValue(LuaEntry.Player:GetCurWorldType(), BattleFieldTableKey.PING_CD)
    cdSec = tonumber(value) or 0
    BattleFieldUtil.BASE_PING_CD = cdSec
  end
  local remainSec = cdSec - (curSec - (BattleFieldUtil.lastPingSec or 0))
  if 0 < remainSec then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("YiBianJinQu_ping_error_1", remainSec))
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    pointId = info.mainIndex
  end
  local tileX = BuildTilesSize.One
  local tileY = BuildTilesSize.One
  local worldPos = BuildingUtils.GetBuildModelCenterVec(pointId, tileX, tileY)
  GoToUtil.GotoDragonPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldPingSign, {anim = false}, pointId)
  end, LuaEntry.Player:GetCurServerId(), LuaEntry.Player:GetCurWorldId(), LuaEntry.Player:GetCurWorldType())
end

function BattleFieldUtil.InitPingGroup(curGroup)
  local dic = {}
  LocalController.instance():visitTable(TableName.LW_BattleField_Ping, function(id, lineData)
    local group = lineData:getIntValue("group")
    if group ~= curGroup then
      return
    end
    local data = {}
    data.id = id
    data.name = lineData:getValue("name")
    data.targetType = lineData:getValue("target_type")
    data.camp = lineData:getIntValue("camp")
    data.icon = lineData:getValue("icon_res")
    data.bg = lineData:getValue("icon_background_res")
    data.world_res = lineData:getValue("world_res")
    data.world_duration = lineData:getIntValue("world_duration")
    data.map_res = lineData:getValue("map_res")
    data.map_duration = lineData:getIntValue("map_duration")
    data.request_duration = lineData:getIntValue("request_duration")
    data.request_text = lineData:getValue("request_text")
    data.link_skill = lineData:getIntValue("link_skill")
    dic[id] = data
  end)
  return dic
end

function BattleFieldUtil.GetPingTemplate(cfgId, bfType)
  local tmpType = bfType
  if tmpType == nil then
    tmpType = LuaEntry.Player:GetCurWorldType()
    if tmpType == 0 then
      tmpType = BattleFieldType.EpidemicZone
    end
  end
  if tmpType == BattleFieldType.EpidemicZone then
    return DataCenter.ActEpidemicZoneManager:GetPingTemplate(cfgId)
  elseif tmpType == BattleFieldType.WinterStorm then
    return DataCenter.ActWinterStormManager:GetPingTemplate(cfgId)
  end
end

function BattleFieldUtil.GetCurPings(tType)
  local templatePings
  local role = 0
  if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    templatePings = DataCenter.ActEpidemicZoneManager:InitPing()
    role = DataCenter.ActEpidemicZoneManager:GetCurRole()
  elseif BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    templatePings = DataCenter.ActWinterStormManager:InitPing()
  end
  local list = {}
  if templatePings then
    for _, v in pairs(templatePings) do
      if v.camp == 0 or v.camp == role then
        local find = string.find(v.targetType, tType)
        if find and 0 < find then
          table.insert(list, v)
        end
      end
    end
  end
  return list
end

function BattleFieldUtil.TestCleanPing()
  BattleFieldPingUtil.CleanPingMark()
end

function BattleFieldUtil.TestAddPing(idx)
  local theWorld = CS.SceneManager.World
  if theWorld == nil or not SceneUtils.GetIsInWorld() then
    ActEpidemicUtils.Log("\230\178\161\230\156\137\229\156\168\229\164\167\228\184\150\231\149\140\229\149\138\239\188\129")
    UIUtil.ShowTips("\230\178\161\230\156\137\229\156\168\229\164\167\228\184\150\231\149\140\229\149\138\239\188\129")
    return
  end
  local tmpType = LuaEntry.Player:GetCurWorldType()
  if tmpType == 0 then
    tmpType = BattleFieldType.EpidemicZone
  end
  local templates
  if tmpType == BattleFieldType.EpidemicZone then
    templates = table.keys(DataCenter.ActEpidemicZoneManager:InitPing())
  elseif tmpType == BattleFieldType.WinterStorm then
    templates = table.keys(DataCenter.ActWinterStormManager:InitPing())
  else
    templates = {}
  end
  table.sort(templates, function(a, b)
    return a < b
  end)
  local id = templates[idx]
  local template = BattleFieldUtil.GetPingTemplate(id, tmpType)
  if template == nil then
    ActEpidemicUtils.Log("\230\178\161\230\137\190\229\136\176\228\191\161\229\143\183\229\149\138\239\188\129\239\188\129\239\188\129" .. idx .. " , " .. #templates)
    UIUtil.ShowTips("\230\178\161\230\137\190\229\136\176\228\191\161\229\143\183\229\149\138\239\188\129\239\188\129\239\188\129" .. idx .. " , " .. #templates)
    return
  end
  local pointId = SceneUtils.WorldToTileIndex(theWorld.CurTarget)
  ActEpidemicUtils.Log("\230\183\187\229\138\160\228\191\161\229\143\183\239\188\129\239\188\129\239\188\129" .. pointId)
  UIUtil.ShowTips("\230\183\187\229\138\160\228\191\161\229\143\183\239\188\129\239\188\129\239\188\129" .. pointId)
  BattleFieldPingUtil.HandlePingOptPush(tmpType, {
    uuid = "BF_PING_" .. NameCount,
    cfgid = id,
    pid = pointId,
    uid = LuaEntry.Player:GetUid(),
    createinmills = UITimeManager:GetInstance():GetServerTime()
  }, true)
  NameCount = NameCount + 1
end

function BattleFieldUtil.SetShowLocalTime(show)
  CommonUtil.PlayerPrefsSetBool(SettingKeys.BATTLE_FIELD_SET_SHOW_LOCAL_TIME, show)
  EventManager:GetInstance():Broadcast(EventId.BattleFieldChangeShowLocalTime)
end

function BattleFieldUtil.GetShowLocalTime()
  return CommonUtil.PlayerPrefsGetBool(SettingKeys.BATTLE_FIELD_SET_SHOW_LOCAL_TIME, true)
end

local _recordPointInfos = {}
local _recordMinMagDistance

function BattleFieldUtil.StartRecordPointInfo(minMagDistance)
  _recordPointInfos = {}
  _recordMinMagDistance = minMagDistance
end

function BattleFieldUtil.RecordPointInfo(pointInfo)
  if not pointInfo then
    return
  end
  if not _recordMinMagDistance then
    return
  end
  local pos = SceneUtils.IndexToTilePos(pointInfo.mainIndex, ForceChangeScene.World)
  local find = false
  for k, v in ipairs(_recordPointInfos) do
    local _ptInfo = v.pointInfo
    local _minX = v.minX
    local _maxX = v.maxX
    local _minY = v.minY
    local _maxY = v.maxY
    local _centerX = (_minX + _maxX) * 0.5
    local _centerY = (_minY + _maxY) * 0.5
    local curPos = SceneUtils.IndexToTilePos(pointInfo.mainIndex, ForceChangeScene.World)
    local _gapX = curPos.x - _centerX
    local _gapY = curPos.y - _centerY
    local magDis = _gapX * _gapX + _gapY * _gapY
    if magDis <= _recordMinMagDistance then
      find = true
      _recordPointInfos[k].minX = Mathf.Min(_minX, curPos.x)
      _recordPointInfos[k].maxX = Mathf.Max(_maxX, curPos.x)
      _recordPointInfos[k].minY = Mathf.Min(_minY, curPos.y)
      _recordPointInfos[k].maxY = Mathf.Max(_maxY, curPos.y)
      break
    end
  end
  if not find then
    table.insert(_recordPointInfos, {
      minX = pos.x,
      maxX = pos.x,
      minY = pos.y,
      maxY = pos.y,
      pointInfo = pointInfo
    })
  end
end

function BattleFieldUtil.GetRecordPointInfos(output)
  if not output then
    _recordPointInfos = {}
    _recordMinMagDistance = nil
    return
  end
  if 0 < #_recordPointInfos then
    for k, v in ipairs(_recordPointInfos) do
      table.insert(output, {
        pos = {
          x = Mathf.Ceil((v.minX + v.maxX) * 0.5),
          y = Mathf.Ceil((v.minY + v.maxY) * 0.5)
        },
        pointInfo = v.pointInfo
      })
    end
  end
  _recordPointInfos = {}
  _recordMinMagDistance = nil
end

function BattleFieldUtil.ConvertAllianceName(serverId, abbr, name)
  return string.format("%s%s%s", serverId and string.format("#%s", serverId) or "", abbr and string.format("[%s]", abbr) or "", name and name or "")
end

function BattleFieldUtil.GetSoldierDescription()
  local sb = StringBuilder.New()
  local info = {}
  info.id = 0
  info.soldierCount = 0
  info.count = 0
  info.lv = 0
  info.heal = 0
  info.dead = 0
  info.finishSoldierNum = 0
  local soldier = DataCenter.SoldierDataManager:GetDragonSoldierInfo()
  if soldier then
    info.id = soldier.id
    info.soldierCount = soldier.count
    info.lv = soldier.lv
    info.heal = 0
    info.dead = 0
    local _soldierInfo = DataCenter.HospitalManager:FindHospitalInfo(info.id)
    if _soldierInfo then
      info.heal = _soldierInfo.heal or 0
      info.dead = _soldierInfo.dead or 0
    end
    local finishSoldierNum = 0
    if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
      finishSoldierNum = DataCenter.ActDragonManager:GetTreatmentFinishSoldierNum() or 0
    elseif BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
      finishSoldierNum = DataCenter.BattlefieldDsbDuelManager:GetTreatmentFinishSoldierNum() or 0
    end
    info.finishSoldierNum = finishSoldierNum
    info.total = info.soldierCount + info.finishSoldierNum + info.heal + info.dead
    local template = DataCenter.SoldierDataManager:GetTemplate(info.id)
    info.quality = template.quality
  else
    sb:AppendFormatLine("\230\137\190\228\184\141\229\136\176\228\187\187\228\189\149\229\163\171\229\133\181\228\191\161\230\129\175")
  end
  sb:AppendFormatLine("\229\189\147\229\137\141\230\136\152\229\156\186\231\177\187\229\158\139:%s", BattleFieldUtil.GetCurBattleFieldType())
  sb:AppendFormatLine("id:%s", info.id)
  sb:AppendFormatLine("\229\147\129\232\180\168:%s", info.quality)
  sb:AppendFormatLine("\230\128\187\233\135\143:%s", info.total)
  sb:AppendFormatLine("\229\143\175\231\148\168\230\149\176\233\135\143(soldierCount):%s", info.soldierCount)
  sb:AppendFormatLine("\232\135\170\229\138\168\230\178\187\231\150\151\230\149\176\233\135\143(finishSoldierNum):%s", info.finishSoldierNum)
  sb:AppendFormatLine("\230\178\187\231\150\151\228\184\173(heal):%s", info.heal)
  sb:AppendFormatLine("\229\190\133\230\178\187\231\150\151(dead):%s", info.dead)
  return sb:ToString()
end

function BattleFieldUtil.GetPlayerMaxHp(bfType)
  local id, key
  if bfType == BattleFieldType.Desert then
    id = "dragon_war"
    key = "k12"
  elseif bfType == BattleFieldType.WinterStorm then
    id = "winter_battlefield"
    key = "k25"
  elseif bfType == BattleFieldType.EpidemicZone then
    id = "YiBianJinQu_battle"
    key = "k12"
  elseif bfType == BattleFieldType.DsbDuel then
    id = "dsb_duel_league_battle_config"
    key = "k2"
  end
  return LuaEntry.DataConfig:TryGetNum(id, key, 4000)
end

function BattleFieldUtil.MergeFunctions(class, luaPath)
  if not class or not luaPath then
    return
  end
  local _ = SafeRequire(luaPath)
  if _ then
    for k, v in pairs(_) do
      if type(v) == "function" then
        class[k] = v
      end
    end
  end
end

function BattleFieldUtil.GetMainRange()
  return 0
end

function BattleFieldUtil.GetRangePoints(index, range)
  local vecPos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  local res = {}
  for i = vecPos.x - range, vecPos.x + range do
    for j = vecPos.y - range, vecPos.y + range do
      local item = SceneUtils.TileXYToIndex(i, j, ForceChangeScene.World)
      if 0 < item then
        table.insert(res, item)
      end
    end
  end
  return res
end

function BattleFieldUtil.CheckBuildInSkillRange(mainIndex, mainRange, pointsInRange)
  local tmpPoints = BattleFieldUtil.GetRangePoints(mainIndex, mainRange)
  for _, point in pairs(tmpPoints) do
    if table.hasvalue(pointsInRange, point) then
      return true
    end
  end
  return false
end

function BattleFieldUtil.GetDistanceByIndex(index, curIndex)
  local curTile = SceneUtils.IndexToTilePos(curIndex, ForceChangeScene.World)
  local tarTile = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  local dist = Vector2.Distance(curTile, tarTile)
  return dist
end

return BattleFieldUtil
