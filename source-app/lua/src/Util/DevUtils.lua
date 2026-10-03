local DevUtils = {}
DevUtils.dbg = nil
DevUtils.luaConnectState = 0
DevUtils.libPath = nil
local CSDevUtil = CS.DevUtils
if CSDevUtil then
  CSDevUtil.luaDevUtils = DevUtils
end

local function AutoDebugLua()
  return CSDevUtil and CSDevUtil.AutoDebugLua
end

local function EditorEmmyLibPath()
  return CSDevUtil and CSDevUtil.EditorEmmyLibPath or ""
end

function DevUtils.StartDebug()
  if not DevUtils.dbg then
    if not package.loaded.emmy_core then
      local litPath = EditorEmmyLibPath()
      if not litPath then
        Logger.LogError("DevToolsConfig\228\184\173\230\156\170\233\133\141\231\189\174dylib\231\154\132\228\189\141\231\189\174\229\147\166~")
        return
      end
      local emmyPath = litPath
      package.cpath = package.cpath .. ";" .. emmyPath
      DevUtils.dbg = require("emmy_core")
    else
      Logger.Log("[EmmyLua]emmy_core loaded.")
      DevUtils.dbg = require("emmy_core")
    end
  end
  
  local function loadEmmyCore()
    Logger.Log("[EmmyLua]Try connect debugger...")
    DevUtils.dbg.tcpConnect("localhost", 9966)
  end
  
  local ok, dbg = xpcall(loadEmmyCore, debug.traceback)
  if ok then
    Logger.Log("[EmmyLua]Connect debugger succeed")
    DevUtils.luaConnectState = 1
  end
end

function DevUtils.EditorTryLogFunction(fun)
  if not CommonUtil.IsEditor() then
    return
  end
  if not fun then
    return
  end
  if type(fun) ~= "function" then
    return
  end
  local info = debug.getinfo(fun)
  if info then
    local log = string.format("[Editor]%s:%s", info.short_src, info.linedefined)
    DevUtils.Log(log)
    local tips = Mathf.Random(1, 3)
    if tips == 1 then
      UIUtil.ShowTips("\231\130\185\230\136\145\230\152\175\229\144\167\239\188\159\239\188\159")
    elseif tips == 2 then
      UIUtil.ShowTips("\230\157\165\229\149\138\231\130\185\229\149\138\239\188\129\228\189\160\231\130\185\230\136\145\229\149\138\239\188\129")
    elseif tips == 3 then
      UIUtil.ShowTips("\231\130\185\230\173\187\230\136\145\229\149\138\239\188\129\239\188\129\231\130\185\230\136\145\229\149\138\239\188\129\239\188\129")
    end
    return true
  end
end

function DevUtils.Log(format, ...)
  local text = string.format(format, ...)
  Logger.Log(string.format("[Dev]%s", text))
end

function DevUtils.StopDebug()
  if not DevUtils.luaConnectState then
    Logger.LogError("[Lua]Stop debug failed.")
    return
  end
  Logger.Log("Try stop debug...")
  
  local function _stop()
    DevUtils.dbg.stop()
  end
  
  local ok, dbg = xpcall(_stop, debug.traceback)
  if ok then
    DevUtils.luaConnectState = 0
    Logger.Log("[EmmyLua]Debugger disconnected.")
  end
end

if AutoDebugLua() then
  Logger.Log("[EmmyLua]Auto debug lua.")
  DevUtils.StartDebug()
end
local adjustmentName = {
  [0] = "\229\133\179\233\151\173",
  [-1] = "\228\189\142",
  [-2] = "\228\184\173",
  [-3] = "\233\171\152",
  [-4] = "\232\182\133\231\186\167"
}

local function GetTroopLimit()
  local Settings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
  local thresholds = Settings.LevelAdjustmentThresholdsList
  if thresholds ~= nil then
    for i, threshold in ipairs(thresholds) do
      if threshold >= Settings.SquadCount then
        return threshold
      end
    end
    return "\226\136\158"
  end
  if Settings.SquadCount <= Settings.LevelAdjustmentSquadCountThreshold then
    return Settings.LevelAdjustmentSquadCountThreshold
  elseif Settings.SquadCount <= Settings.LevelAdjustmentSquadCountThreshold * 2 then
    return Settings.LevelAdjustmentSquadCountThreshold * 2
  elseif Settings.SquadCount <= Settings.LevelAdjustmentSquadCountThreshold * 6 then
    return Settings.LevelAdjustmentSquadCountThreshold * 6
  elseif Settings.SquadCount <= Settings.LevelAdjustmentSquadCountThreshold * 10 then
    return Settings.LevelAdjustmentSquadCountThreshold * 10
  else
    return "\226\136\158"
  end
end

function DevUtils.GetPerformanceInfo()
  local Settings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
  local GameQualitySettings = require("Util.GameQualitySettings")
  local sb = StringBuilder.New()
  sb:AppendLine(string.format("\229\189\147\229\137\141\232\174\190\229\164\135\229\136\134\231\186\167:%s", GameQualitySettings.GetDeviceLevel()))
  sb:AppendLine(string.format("\229\189\147\229\137\141\230\128\167\232\131\189\229\136\134\231\186\167:%s", GameQualitySettings.GetQualityByConfigLevel()))
  sb:AppendLine(string.format("\229\189\147\229\137\141\232\174\190\231\189\174\233\128\137\233\161\185:%s", GameQualitySettings.GetQuality()))
  sb:AppendLine("-------------")
  sb:AppendLine(string.format("\230\152\175\229\144\166\230\148\175\230\140\129\229\174\158\228\190\139\229\140\150\230\184\178\230\159\147:%s", tostring(Settings.SupportGPUInstancing)))
  sb:AppendLine(string.format("\229\188\128\229\133\179\230\152\175\229\144\166\230\137\147\229\188\128:%s", Settings.SwitchOn == nil and "\230\156\170\231\159\165" or tostring(Settings.SwitchOn)))
  sb:AppendLine(string.format("\232\161\140\229\134\155\231\186\191\229\188\128\229\133\179\230\152\175\229\144\166\230\137\147\229\188\128:%s", Settings.LineSwitchOn == nil and "\230\156\170\231\159\165" or tostring(Settings.LineSwitchOn)))
  sb:AppendLine(string.format("Fps\232\167\166\229\143\145\228\189\142\229\184\167\231\142\135\229\188\128\229\133\179:%s", Settings.FpsSwitchOn == nil and "\230\156\170\231\159\165" or tostring(Settings.FpsSwitchOn)))
  sb:AppendLine("-------------")
  sb:AppendLine(string.format("\229\189\147\229\137\141\233\131\168\233\152\159\230\158\129\231\174\128\230\168\161\229\188\143\231\186\167\229\136\171:%s", adjustmentName[Settings.LevelAdjustment]))
  sb:AppendLine(string.format("\229\189\147\229\137\141\232\167\166\229\143\145\230\158\129\231\174\128\230\168\161\229\188\143\233\131\168\233\152\159\230\149\176\233\135\143:%s", Settings.SquadCount))
  sb:AppendLine(string.format("\228\184\139\228\184\128\230\161\163\230\149\176\233\135\143\233\152\136\229\128\188:%s", GetTroopLimit()))
  sb:AppendLine("-------------")
  local legacyCount = 0
  local newCount = 0
  local world = CS.SceneManager.World
  if world and world.TroopLineManager then
    local troopLineMgr = world.TroopLineManager
    legacyCount = troopLineMgr.LegacyTroopLineCount
    newCount = troopLineMgr.NewTroopLineCount
  end
  sb:AppendLine(string.format("\229\189\147\229\137\141\232\161\140\229\134\155\231\186\191\230\158\129\231\174\128\230\152\175\229\144\166\230\137\147\229\188\128:%s", Settings.IsLittleSmartTroopLineEnable()))
  sb:AppendLine(string.format("\229\189\147\229\137\141\232\167\166\229\143\145\232\161\140\229\134\155\231\186\191\230\158\129\231\174\128\231\154\132\232\161\140\229\134\155\231\186\191\230\149\176\233\135\143:%s(\230\150\176),%s(\230\151\167)", newCount, legacyCount))
  sb:AppendLine(string.format("\232\167\166\229\143\145\230\158\129\231\174\128\232\161\140\229\134\155\231\186\191\233\152\136\229\128\188:%s", Settings.LittleSmartTroopLineThreshold))
  return sb:ToString()
end

function DevUtils.RefreshDisplaySettings()
  local Settings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
  Settings.SetSquadCount(Settings.SquadCount)
end

function DevUtils.SetPerformanceLevel(level)
  local Settings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
  local lv = tonumber(level)
  if lv == 0 then
    UIUtil.ShowTips("\229\136\135\230\141\162\228\184\186\232\135\170\229\138\168")
    Settings.LevelAdjustmentMax = 0
    Settings.LevelAdjustmentMin = -4
    Settings.SetSquadCount(Settings.SquadCount)
  elseif lv == 1 then
    UIUtil.ShowTips("\229\188\186\229\136\182\229\133\179\233\151\173\231\174\128\229\141\149\230\168\161\229\188\143")
    Settings.LevelAdjustmentMax = 0
    Settings.LevelAdjustmentMin = 0
    Settings.SetLevelAdjustment(0, true)
  elseif lv == 2 then
    UIUtil.ShowTips("\229\136\135\230\141\162\228\184\186 \228\189\142\231\186\167 \231\174\128\229\141\149\230\168\161\229\188\143")
    Settings.LevelAdjustmentMax = -1
    Settings.LevelAdjustmentMin = -1
    Settings.SetLevelAdjustment(-1, true)
  elseif lv == 3 then
    UIUtil.ShowTips("\229\136\135\230\141\162\228\184\186 \228\184\173\231\186\167 \231\174\128\229\141\149\230\168\161\229\188\143")
    Settings.LevelAdjustmentMax = -2
    Settings.LevelAdjustmentMin = -2
    Settings.SetLevelAdjustment(-2, true)
  elseif lv == 4 then
    UIUtil.ShowTips("\229\136\135\230\141\162\228\184\186 \233\171\152\231\186\167 \231\174\128\229\141\149\230\168\161\229\188\143")
    Settings.LevelAdjustmentMax = -3
    Settings.LevelAdjustmentMin = -3
    Settings.SetLevelAdjustment(-3, true)
  elseif lv == 5 then
    UIUtil.ShowTips("\229\136\135\230\141\162\228\184\186 \232\182\133\231\186\167 \231\174\128\229\141\149\230\168\161\229\188\143")
    Settings.LevelAdjustmentMax = -4
    Settings.LevelAdjustmentMin = -4
    Settings.SetLevelAdjustment(-4, true)
  else
    UIUtil.ShowTips("?\228\189\160\232\190\147\229\133\165\231\154\132\230\152\175\228\187\128\228\185\136\233\172\188?")
  end
end

function DevUtils.GetPerformanceLevelLv()
  local Settings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
  if Settings.LevelAdjustmentMax == 0 and Settings.LevelAdjustmentMin == -4 then
    return 0
  elseif Settings.LevelAdjustmentMax == 0 and Settings.LevelAdjustmentMin == 0 then
    return 1
  elseif Settings.LevelAdjustmentMax == -1 and Settings.LevelAdjustmentMin == -1 then
    return 2
  elseif Settings.LevelAdjustmentMax == -2 and Settings.LevelAdjustmentMin == -2 then
    return 3
  elseif Settings.LevelAdjustmentMax == -3 and Settings.LevelAdjustmentMin == -3 then
    return 4
  elseif Settings.LevelAdjustmentMax == -4 and Settings.LevelAdjustmentMin == -4 then
    return 5
  end
end

function DevUtils.SimulateTroop(batchCount, marchCountPerBatch, interval, marchTime, isSelf)
  local marchDist = 20
  local batchInterval = interval * 1.0 / 1000
  local basePos = LuaEntry.Player:GetMainWorldPos()
  local endPosX = math.floor(basePos / 1000)
  local endPosY = math.floor(basePos % 1000)
  
  local function createFakeMarch()
    UIUtil.ShowTips(string.format("\229\143\145\228\184\128\230\179\162\232\161\140\229\134\155:%s", marchCountPerBatch))
    for i = 1, marchCountPerBatch do
      local endPos = Vector3.New(endPosX, 0, endPosY)
      local randomEuler = math.random(0, 36000) * 0.01
      local startPos = endPos + Quaternion.Euler(0, randomEuler, 0) * Vector3.forward * marchDist * 0.01 * math.random(85, 115)
      local startIndex = math.floor(startPos.x) * 1000 + math.floor(startPos.z)
      local endIndex = endPosX * 1000 + endPosY
      CS.SceneManager.World:AddFakeAttackMonsterMarchData(startIndex, endIndex, marchTime, isSelf and LuaEntry.Player.uid or "fakeUser")
    end
  end
  
  for i = 1, batchCount do
    TimerManager:GetInstance():DelayInvoke(function()
      createFakeMarch()
    end, batchInterval * (i - 1))
  end
end

function DevUtils.GetActivityListDesc()
  return DataCenter.ActivityListDataManager:Description()
end

function DevUtils.GetUIManagerDesc()
  return UIManager:GetInstance():Description()
end

function DevUtils.OpenWindow(name, args)
  UIManager:GetInstance():OpenWindow(name, {anim = true}, args)
end

function DevUtils.GetMeteoriteActivityInfo()
  local sb = StringBuilder.New()
  sb:AppendLine(DataCenter.ActMeteoriteBattleManager:Description())
  return sb:ToString()
end

function DevUtils.StartMeteoriteBattle(pointIndex, hSize, lSize, startTimeSec, durationSec)
  local currentTime = UITimeManager:GetInstance():GetServerSeconds()
  currentTime = math.floor(currentTime)
  local startTime = currentTime + startTimeSec
  local endTime = startTime + durationSec
  Logger.Log(string.format("[Editor]\229\144\175\229\138\168\233\153\168\233\147\129\228\186\137\229\164\186\230\136\152\239\188\140hSize=%s, lSize=%s, startTimeSec=%s, durationSec=%s", hSize, lSize, startTimeSec, durationSec))
  DataCenter.ActMeteoriteBattleManager:ManualStart(pointIndex, hSize, lSize, startTime, endTime)
end

function DevUtils.ClearMeteoriteBattle()
  DataCenter.ActMeteoriteBattleManager:ClearWorldMeteorite()
end

function DevUtils.MeteoriteTest()
  DataCenter.ActMeteoriteBattleManager:OnHandleCollectFinish({
    pointId = LuaEntry.Player:GetMainWorldPos(),
    id = 101,
    playerInfo = {
      uid = LuaEntry.Player:GetUid(),
      headPic = LuaEntry.Player.pic,
      headPicVer = LuaEntry.Player.headPicVer
    }
  })
end

function DevUtils.ClearMeteoriteRemember()
  UIUtil.ShowTips("\229\183\178\230\184\133\233\153\164")
  CommonUtil.PlayerPrefsSetBool(SettingKeys.NO_METEORITE_DROP_PROMPT, false)
  CommonUtil.PlayerPrefsSetBool(SettingKeys.NO_METEORITE_DROP_PROMPT2, false)
  CommonUtil.PlayerPrefsSetBool(string.format("%s_1", SettingKeys.METEORITE_AWARD_ITEM_GUIDE), false)
  CommonUtil.PlayerPrefsSetBool(string.format("%s_2", SettingKeys.METEORITE_AWARD_ITEM_GUIDE), false)
  CommonUtil.PlayerPrefsSetBool(string.format("%s_3", SettingKeys.METEORITE_AWARD_ITEM_GUIDE), false)
  CommonUtil.PlayerPrefsSetBool(string.format("%s_4", SettingKeys.METEORITE_AWARD_ITEM_GUIDE), false)
end

function DevUtils.PlayRandomPlayerRankChange(upgrade, hasTarget)
  local currentRank = math.random(10, 200)
  local lastRank = upgrade and currentRank + 1 or currentRank - 1
  local player = {
    rank = currentRank,
    lastRank = lastRank,
    score = math.random(10000, 200000),
    pic = LuaEntry.Player:GetPic(),
    picVer = LuaEntry.Player.picVer
  }
  local target
  if hasTarget then
    target = {
      rank = player.rank - 1,
      score = player.score + math.random(500, 10000),
      pic = LuaEntry.Player:GetPic(),
      picVer = LuaEntry.Player.picVer
    }
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActMeteoriteRankChangedNotice, {anim = true}, {
    type = 0,
    player = player,
    target = target
  })
end

function DevUtils.GetGuideDescription()
  return DataCenter.LWGuideFlowManager:Description()
end

function DevUtils.GetGuideFlows()
  return DataCenter.LWGuideFlowManager:EditorGetFlows()
end

function DevUtils.TryGuideConditions(id)
  DataCenter.LWGuideFlowManager:EditorTryConditions(id)
end

function DevUtils.TryGuideBehaviours(id)
  DataCenter.LWGuideFlowManager:EditorTryGuideBehaviours(id)
end

function DevUtils.TryRunGuideById(id)
  DataCenter.LWGuideFlowManager:EditorTryGuideBehaviours(id)
end

function DevUtils.GetGuideBehaviourLineByID(id)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), id)
  if line == nil then
    Logger.LogError(string.format("\232\142\183\229\143\150\229\188\149\229\175\188\228\191\161\230\129\175\229\164\177\232\180\165, id=%s", id))
    return ""
  end
  return line.guide_behaviours
end

function DevUtils.TryRunBehaviourStr(id, str)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), id)
  if line == nil then
    Logger.LogError(string.format("\232\142\183\229\143\150\229\188\149\229\175\188\228\191\161\230\129\175\229\164\177\232\180\165, id=%s", id))
    return ""
  end
  DataCenter.LWGuideFlowManager:EditorTryGuideBehaviours(id, str)
end

function DevUtils.PlayRandomAllianceRankChange(upgrade, hasTarget)
  local currentRank = math.random(10, 200)
  local lastRank = upgrade and currentRank + 1 or currentRank - 1
  local player = {
    rank = currentRank,
    lastRank = lastRank,
    score = math.random(10000, 200000),
    abbr = "ABC",
    icon = "2"
  }
  local target
  if hasTarget then
    target = {
      rank = player.rank - 1,
      score = player.score + math.random(500, 10000),
      abbr = "DEF",
      icon = "3"
    }
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActMeteoriteRankChangedNotice, {anim = true}, {
    type = 1,
    player = player,
    target = target
  })
end

function DevUtils.DelSimulateTroop(delCount)
  CS.SceneManager.World:DelFakeAttackMonsterMarchDataRandom(delCount)
end

function DevUtils.SetLittleSmartMode(enableSmartMode)
  local Settings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
  Settings.SetLittleSmartEnable(enableSmartMode)
end

function DevUtils.GetSeasonInfo()
  return "I am season..."
end

function DevUtils.SeasonDescription()
  local desc = DataCenter.SeasonDataManager:Description()
  return desc
end

function DevUtils.SeasonUpgradeLogDescription()
  local desc = DataCenter.SeasonUpgradeLogManager:Description()
  return desc
end

function DevUtils.OpenSeasonUpgradeLog(season, server)
  Logger.Log(string.format("\230\149\153\231\187\131..\230\136\145\230\131\179..\230\137\147\229\188\128%s\230\156\141\231\154\132%s\232\181\155\229\173\163\230\155\180\230\150\176\232\175\180\230\152\142...", server, season))
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonUpgradeLog, {anim = true}, {season = season, server = server})
end

function DevUtils.GetSeasonInfo()
  return "I am season..."
end

function DevUtils.EpidemicZoneDescription()
  return DataCenter.ActEpidemicZoneManager:Description()
end

function DevUtils.ClearEpidemicZonePlayerPrefs()
  local actInfo = ActEpidemicUtils.GetActInfo()
  if not actInfo then
    UIUtil.ShowTips("\230\137\190\228\184\141\229\136\176\230\180\187\229\138\168")
    return
  end
  local startTime = actInfo:GetActStartTime()
  local key = string.format("EpidemicPapaFace_%s_%s", ActEpidemicUtils.Group1, startTime)
  CommonUtil.PlayerPrefsSetBool(key, false)
  key = string.format("EpidemicPapaFace_%s_%s", ActEpidemicUtils.Group2, startTime)
  CommonUtil.PlayerPrefsSetBool(key, false)
  DataCenter.ActEpidemicZoneManager:ClearRedKeys()
  UIUtil.ShowTips("\229\183\178\230\184\133\233\153\164")
end

function DevUtils.DebugEpidemicZoneNextStage()
  local newStage = 1
  local info = ActEpidemicUtils.GetActInfo()
  if info then
    newStage = info.currentStage + 1
    if newStage > EpidemicZoneStage.End then
      newStage = 0
    end
  end
  local msg = {}
  msg.stage = newStage
  msg.stageEndTime = UITimeManager:GetInstance():GetServerSeconds() + 3600
  msg.group = {}
  msg.group[1] = {
    state = newStage < EpidemicZoneStage.MatchEnd and 1 or 4,
    selfAssigned = 1,
    roleInfo = {
      {
        side = 1,
        allianceId = LuaEntry.Player:GetAllianceUid(),
        serverId = 100,
        allianceName = "allianceA",
        abbr = "AAA",
        icon = "1",
        skills = {
          1,
          2,
          3
        },
        arbiter = nil
      },
      {
        side = 2,
        allianceId = "123456",
        serverId = 101,
        allianceName = "allianceB",
        abbr = "BBB",
        icon = "3",
        skills = {
          1,
          2,
          3
        },
        arbiter = nil
      },
      {
        side = 3,
        allianceId = "1234567",
        serverId = 102,
        allianceName = "allianceC",
        abbr = "CCC",
        icon = "2",
        skills = {
          1,
          2,
          3
        },
        arbiter = nil
      }
    }
  }
  msg.group[2] = {
    state = newStage < EpidemicZoneStage.MatchEnd and 1 or 3,
    selfAssigned = 1,
    roleInfo = {
      {
        side = 1,
        allianceId = "123456",
        serverId = 101,
        allianceName = "allianceB",
        abbr = "BBB",
        icon = "3",
        skills = {
          1,
          2,
          3
        },
        arbiter = nil
      },
      {
        side = 2,
        allianceId = LuaEntry.Player:GetAllianceUid(),
        serverId = 100,
        allianceName = "allianceA",
        abbr = "AAA",
        icon = "1",
        skills = {
          1,
          2,
          3
        },
        arbiter = nil
      },
      {
        side = 3,
        allianceId = "1234567",
        serverId = 102,
        allianceName = "allianceC",
        abbr = "CCC",
        icon = "2",
        skills = {
          1,
          2,
          3
        },
        arbiter = nil
      }
    }
  }
  msg.showInfo = {
    isWin = true,
    mvp = {
      score = 9527,
      name = "helloKitty",
      uid = LuaEntry.Player.uid,
      pic = LuaEntry.Player:GetPic(),
      picVer = LuaEntry.Player:GetPicVer(),
      abbr = "ktv"
    }
  }
  DataCenter.ActEpidemicZoneManager:HandleActivityInfoMessage(msg)
end

function DevUtils.EpidemicZoneFakeAct()
  DataCenter.ActEpidemicZoneManager:EditorFakeAct()
  return DataCenter.ActEpidemicZoneManager:Description()
end

function DevUtils.EpidemicOpenSelectUser()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicSelectUserViewV2)
end

function DevUtils.EpidemicCleanSkillObj()
  ActEpidemicUtils.TestCleanSkillObj()
end

function DevUtils.EpidemicAddSkillObj(skillIdx)
  ActEpidemicUtils.TestAddSkillObj(skillIdx)
end

function DevUtils.EpidemicSkillPlayAttack()
  ActEpidemicUtils.TestPlaySkillAtk()
end

function DevUtils.EpidemicSkillPlayPreview()
  ActEpidemicUtils.TestPlaySkillPreview()
end

function DevUtils.GetRadarInfo()
  return DataCenter.RadarCenterDataManager:Description()
end

function DevUtils.GetCaveExplorationInfo()
  return DataCenter.CaveExplorationManager:Description()
end

function DevUtils.GetLandlordInfo()
  return DataCenter.LandlordMgr:Description()
end

function DevUtils.CleanInvitedSign()
  return DataCenter.LandlordMgr:SignBeInvited(true)
end

function DevUtils.WarFlagDescription()
  return DataCenter.WarFlagManager:Description()
end

function DevUtils.AlStarAddAlly(str)
  local split = string.split(str, "-")
  local uid = tonumber(split[1])
  local num = tonumber(split[2]) or 0
  for i = uid, uid + num do
    local id = tostring(i)
    local msg = {}
    msg.operateType = 1
    msg.participants_info = {}
    msg.participants_info[id] = {}
    msg.participants_info[id].uid = id
    DataCenter.AllianceStarManager:OnPushAllianceStartCeremonyParticipantsInfoChange(msg)
  end
end

function DevUtils.AlStarRemoveAlly(uid)
  local msg = {}
  msg.operateType = 0
  msg.participants_info = {}
  msg.participants_info[uid] = {}
  msg.participants_info[uid].uid = uid
  DataCenter.AllianceStarManager:OnPushAllianceStartCeremonyParticipantsInfoChange(msg)
end

function DevUtils.AlStarRefreshType(type)
  type = tonumber(type)
  if type == 1 then
    local msg = {}
    msg.ceremonyEdition = 1
    msg.stateId = type
    msg.startTimeStamp = UITimeManager:GetInstance():GetServerTime() - 123000
    msg.configId = 10000
    DataCenter.AllianceStarManager:OnPushAllianceStarCeremonyInfoMessage(msg)
  else
    local msg = {}
    msg.ceremonyEdition = 1
    msg.stateId = type
    msg.startTimeStamp = UITimeManager:GetInstance():GetServerTime()
    msg.configId = 10000
    DataCenter.AllianceStarManager:OnPushAllianceStarCeremonyInfoMessage(msg)
  end
end

function DevUtils.AlStarPrintSceneState()
  DataCenter.AllianceStarManager:PrintSceneState()
end

function DevUtils.AlStarGetAllianceStartHistoryPreviewInfo()
  DataCenter.AllianceStarManager:DebugGetAllianceStartHistoryPreviewInfo()
end

function DevUtils.AlStarGetAllianceStarHistoryInfo()
  DataCenter.AllianceStarManager:DebugGetAllianceStarHistoryInfo()
end

function DevUtils.GetRaceEntranceInfo()
  return RaceEntranceUtil.GetRaceEntranceInfo()
end

function DevUtils.CleanRaceEntranceSign()
  return RaceEntranceUtil.CleanSign()
end

function DevUtils.GetDesertDescription()
  return DataCenter.ActDragonManager:Description()
end

function DevUtils.TestDesertStorm()
  BattleFieldUtil.SetBattleFieldCanEnterFlag(1)
end

function DevUtils.CleanTodaySign()
  DataCenter.ActDragonManager:CleanTodayEnterDragonWorld()
end

function DevUtils.GetWinterDescription()
  return DataCenter.ActWinterStormManager:Description()
end

function DevUtils.TestWinterStorm()
  DataCenter.ActWinterStormManager:TestDrop()
end

function DevUtils.PingClean()
  BattleFieldUtil.TestCleanPing()
end

function DevUtils.PingAdd(idx)
  BattleFieldUtil.TestAddPing(idx)
end

function DevUtils.CopyActivityData(toId, fromType)
  if not CS.SDKManager.IS_UNITY_EDITOR() then
    return nil
  end
  toId = tostring(toId)
  local activityList = DataCenter.ActivityListDataManager:GetActivityList()
  if activityList[toId] then
    return activityList[toId]
  end
  local fromData
  for i, v in pairs(activityList) do
    if v.type == fromType then
      fromData = v
      break
    end
  end
  if fromData then
    local toData = {}
    for k, v in pairs(fromData) do
      toData[k] = v
    end
    toData.id = toId
    DataCenter.ActivityListDataManager:AddOneActivity(nil, toData)
  end
  return activityList[toId]
end

local __testMsgDic = {
  [MsgDefines.AllianceBossDigGameInfo] = true
}
local SFSNetwork_SendMessage = SFSNetwork.SendMessage
local __delayTime = 0.02
local __testMsg = false

function DevUtils.TestMessage(flag)
  if not CS.SDKManager.IS_UNITY_EDITOR() then
    return nil
  end
  if __testMsg == flag then
    return flag
  end
  __testMsg = flag
  if flag then
    function SFSNetwork.SendMessage(cmd, ...)
      if __testMsg and __testMsgDic[cmd] then
        local msgType = SFSNetwork.GetMsgType(cmd)
        
        local msg = msgType:NewMessage(...)
        if msg then
          if msg.GetTestData then
            local t = msg:GetTestData(...)
            TimerManager:GetInstance():DelayInvoke(function()
              if not t then
                t = {errorCode = 0}
              end
              SFSNetwork.HandleMessage(cmd, t)
            end, __delayTime)
            return
          else
            printError("GetTestData not found in message:" .. cmd)
          end
        end
      end
      SFSNetwork_SendMessage(cmd, ...)
    end
    
    return true
  end
  SFSNetwork.SendMessage = SFSNetwork_SendMessage
  return false
end

function DevUtils.ReloadManager(name, path)
  if not CS.SDKManager.IS_UNITY_EDITOR() then
    return nil
  end
  local oldInstance = DataCenter[name]
  DataCenter[name] = nil
  reloadModule(path)
  local type = require(path)
  local inst = type.New()
  DataCenter[name] = table.copy(inst, oldInstance)
  return oldInstance
end

return DevUtils
