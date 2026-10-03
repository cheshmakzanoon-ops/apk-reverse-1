local SeasonDataManager = BaseClass("SeasonDataManager")
local Localization = CS.GameEntry.Localization
local PlayerPrefs = CS.UnityEngine.PlayerPrefs
local AllianceCityTip = require("DataCenter.AllianceCityTip.AllianceCityTip")
local RewardUtil = require("Util.RewardUtil")

function SeasonDataManager:__init()
  self.occupyNum = 0
  self.occupyMaxNum = 0
  self.dailyOccupyNum = 0
  self.theNinePalacesData = {}
  self.theMonsterDetail = {}
  self.ShareDesertStatus = {}
  self.ShareDesertStatusPost = {}
  self.CrossDeclareWarCityList = {}
  self.playerSeasonInfo = nil
  self.serverSeasonInfo = nil
  self.SpecialServerSeasonInfoList = nil
  self.CrossOccupyCityMaxNumLocal = 6
  self.CrossOccupyCityMaxNumOther = 6
  self.monsterSearchMaxLevel = {}
  self.seasonRankData = {}
  
  function self.timer_action(temp)
    self:CheckVirus()
  end
  
  self.heroPromoteData = {}
  self.CrossDeclareWarInfo = nil
end

function SeasonDataManager:__delete()
  self:DeleteCheckVirusTimer()
  self.CrossDeclareWarCityList = nil
  self.monsterSearchMaxLevel = nil
  self.heroPromoteData = nil
  self.CrossDeclareWarInfo = nil
end

function SeasonDataManager:StartUp()
end

function SeasonDataManager:EnterCity()
end

function SeasonDataManager:EnterWorld()
  DataCenter.SeasonRainforestKingBattleManager:GetBattleInfo(true, false)
end

function SeasonDataManager:UpdateMonsterRebornAni(uuid)
  local info = self.theMonsterDetail[tostring(uuid)]
  if info then
    info.reborn = true
    CS.GameEntry.Data.Player:SetData(uuid .. "_reborn", tostring(uuid))
  end
end

function SeasonDataManager:UpdateMonsterDetail(uuid, detail)
  if detail and uuid and detail.curNum and detail.maxNum then
    self.theMonsterDetail[tostring(uuid)] = detail
    EventManager:GetInstance():Broadcast(EventId.CityStrongholdMonsterDetailRefresh, uuid)
  end
end

function SeasonDataManager:GetMonsterDetail(uuid)
  return self.theMonsterDetail[tostring(uuid)]
end

function SeasonDataManager:CheckVirus()
  if LuaEntry.Player.VirusLayer == 0 then
    self:DeleteCheckVirusTimer()
    return
  end
  if BattleFieldUtil.InBattleField() then
    return
  end
  local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_HOSPITL)
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
  if data ~= nil and queue ~= nil and 0 < toInt(data.level) then
    local state = queue:GetQueueState()
    if state ~= NewQueueState.Work then
      SFSNetwork.SendMessage(MsgDefines.GetVirusHospitalSync)
    end
  end
end

function SeasonDataManager:DeleteCheckVirusTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function SeasonDataManager:AddCheckVirusTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(60, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function SeasonDataManager:ExistZoneSkinColor(seasonTypeNow)
  if not SeasonUtil.InSourceMapNow() then
    return false
  end
  local k1 = LuaEntry.DataConfig:TryGetStr("season_map_zone_mode", "k1")
  if k1 == nil or k1 == "" then
    return false
  end
  if seasonTypeNow == SeasonMapType.NineNationRainforest then
    seasonTypeNow = 7
  end
  local typeList = string.split_ss_array(k1, "|")
  table.insert(typeList, "7;1")
  for k, v in pairs(typeList) do
    local seasonType, seasonDay = string.split_ii(v, ";")
    if seasonType == seasonTypeNow then
      if seasonDay == nil or seasonDay == 0 then
        return true
      end
      if self.playerSeasonInfo ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local seasonStartTime = self.playerSeasonInfo:GetSeasonStartTime()
        if 0 < curTime - seasonStartTime - seasonDay * OneDayTime * 1000 then
          return true
        end
      end
    end
  end
  return false
end

function SeasonDataManager:UpdateZoneSkinColor()
  if self.skinColorSet then
    return
  end
  local key_name = "season_map_zone_mode"
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    key_name = "season6_map_zone_mode"
  end
  local serverStr = self.playerSeasonInfo.serverStr
  local k2 = LuaEntry.DataConfig:TryGetStr(key_name, "k2", "")
  local k3 = LuaEntry.DataConfig:TryGetStr(key_name, "k3", "")
  local k4 = LuaEntry.DataConfig:TryGetStr(key_name, "k4", "")
  local k5 = LuaEntry.DataConfig:TryGetStr(key_name, "k5", "")
  local k6 = LuaEntry.DataConfig:TryGetStr(key_name, "k6", "")
  local k7 = LuaEntry.DataConfig:TryGetStr(key_name, "k7", "")
  local k2ColorList = string.split_ss_array(k2, "|")
  local k3ColorList = string.split_ss_array(k3, "|")
  local k4ColorList = string.split_ss_array(k4, "|")
  local k5ColorList = string.split_ss_array(k5, "|")
  local k6ColorList = string.split_ss_array(k6, "|")
  local k7ColorList = string.split_ss_array(k7, "|")
  AllianceCityTip.UpdateZoneSkinColor(serverStr, k2ColorList, k3ColorList, k4ColorList, k5ColorList, k6ColorList, k7ColorList)
  local mgr = CS.SeasonDataManager.Instance
  if mgr ~= nil then
    mgr:SetData(key_name, "k1", serverStr)
    mgr:SetData(key_name, "k2", k2ColorList[3] or "")
    mgr:SetData(key_name, "k3", k3ColorList[3] or "")
    mgr:SetData(key_name, "k4", k4ColorList[3] or "")
    mgr:SetData(key_name, "k5", k5ColorList[3] or "")
    mgr:SetData(key_name, "k6", k6ColorList[3] or "")
    mgr:SetData(key_name, "k7", k7ColorList[3] or "")
  end
  self.skinColorSet = true
end

function SeasonDataManager:OnEnterGame()
  if self.playerSeasonInfo == nil or self.serverSeasonInfo == nil then
    return
  end
  local checkUserLevelSucc = DataCenter.BuildManager.MainLv >= SEASON_MIN_LEVEL
  if checkUserLevelSucc then
    DataCenter.AllianceMineManager:InitTemplates()
  end
  local seasonIndex = toInt(self:GetSeason())
  if 0 < seasonIndex then
    local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
    if LuaEntry.Player:IsInAlliance() then
      if 0 < SeasonUtil.GetFarmerConfigId() then
        SFSNetwork.SendMessage(MsgDefines.FetchCityAttachmentList)
        SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentBubbleClickList)
        DataCenter.SeasonFarmerTemplateManager:GetALLBuildTemplate()
      end
      SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentEffectInfo)
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
      DataCenter.AllianceMineManager:RequestAllianceMineInfo(true)
    end
    if seasonType == SeasonMapType.Desert then
      DataCenter.DesertDataManager:OnEnterGame()
    elseif seasonType == SeasonMapType.Mummy then
      SFSNetwork.SendMessage(MsgDefines.GetLastWarActivityInfo)
    elseif seasonType == SeasonMapType.Darkness then
      SFSNetwork.SendMessage(MsgDefines.GetLastWarActivityInfo)
      SFSNetwork.SendMessage(MsgDefines.FetchUserCardBoxList)
    elseif seasonType == SeasonMapType.NineNation then
      SFSNetwork.SendMessage(MsgDefines.GetLastWarActivityInfo)
      SFSNetwork.SendMessage(MsgDefines.FetchUserCardBoxList)
    elseif seasonType == SeasonMapType.NineNationRainforest then
      SFSNetwork.SendMessage(MsgDefines.GetLastWarActivityInfo)
      SFSNetwork.SendMessage(MsgDefines.FetchUserCardBoxList)
    end
    CommonUtil.ProtectCall(function()
      DataCenter.SeasonRewardDataManager:OnEnterGame()
    end)
    Setting:SetPrivateBool("season_map_zone_mode", false)
  end
  local dataList = {}
  if self.playerSeasonInfo.serverListInt then
    for serverId, _ in pairs(self.playerSeasonInfo.serverListInt) do
      dataList[serverId] = 1
    end
  end
  if self.serverSeasonInfo.serverListInt then
    for serverId, _ in pairs(self.serverSeasonInfo.serverListInt) do
      dataList[serverId] = 1
    end
  end
  local serverList = table.keys(dataList)
  if 0 < #serverList then
    SFSNetwork.SendMessage(MsgDefines.GetCrossServerKingInfo, table.concat(serverList, ","))
  end
  if self.playerSeasonInfo then
    if (seasonIndex == 5 or LuaEntry.Player:IsInAlliance()) and self.playerSeasonInfo:InNormalMode() then
      SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
      SFSNetwork.SendMessage(MsgDefines.SeasonCrossAttackCityInfo)
    end
    self:GetActivityPreviewInfo()
  end
  if SeasonUtil.IsInSeason() then
    DataCenter.AllianceSeasonTaskManager:RequestTaskInfo()
    SFSNetwork.SendMessage(MsgDefines.LwSeasonTrendInfo)
    local actWeek = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonPeriodicCard.Type)
    if actWeek ~= nil then
      local cardId = toInt(actWeek.para)
      if 0 < cardId then
        local weekConfig = LocalController:instance():getLine(TableName.Season_Week_Card, cardId)
        if weekConfig then
          SFSNetwork.SendMessage(MsgDefines.LWSeasonWeekCardInfo, cardId)
        end
      end
    end
    if 0 < LuaEntry.Player.VirusLayer then
      Setting:SetPrivateBool("HasVirus", true)
      local max = Setting:GetPrivateInt("VirusMax", 0)
      if max < LuaEntry.Player.VirusLayer then
        Setting:SetPrivateInt("VirusMax", LuaEntry.Player.VirusLayer)
      end
      self:CheckVirus()
      self:AddCheckVirusTimer()
    end
    if checkUserLevelSucc then
      local lastOffLineTime = LuaEntry.Player.lastOffLineTime
      local lastOffLineTimeLocal = toInt(Setting:GetPrivateString("LastCleanTime", "0"))
      if lastOffLineTime ~= nil and SceneUtils.GetIsInCity() then
        local now = UITimeManager:GetInstance():GetServerTime()
        if 3600000 < now - lastOffLineTime or 3600000 < now - lastOffLineTimeLocal then
          TimerManager:GetInstance():DelayInvoke(function()
            local data = DataCenter.LandLockManager:GetLandLockDataById(95)
            if data ~= nil then
              local pointId = data:GetCenterPointId()
              local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City)
              GoToUtil.GotoPos(worldPos, CS.SceneManager.World.InitZoom, 0)
              Logger.Log("GetLandLockDataById:GotoPos(95)")
            end
          end, 0.1)
        end
      end
    end
  else
    Setting:SetPrivateBool("HasVirus", false)
    Setting:SetPrivateInt("VirusMax", 0)
    Setting:SetPrivateInt("SelectSeasonFaction", -1)
  end
  if SeasonUtil.IsInAndAfterSeasonSnowMode() then
    DataCenter.TemperatureManager:OnEnterGame()
  end
  if SeasonUtil.IsInSeasonMummyMode() then
    DataCenter.SandWormHuntDataManager:FetchActivityData()
  end
  if SeasonUtil.IsInSeasonDarknessMode() then
    DataCenter.SeasonHunterManager:FetchSeasonHunterGetShadowInfo()
  end
  CrossServerUtil.TryGetCrossEnableServerList(true)
  DataCenter.WorldBattleGuideManager:Init()
  DataCenter.AllianceSkillManager:OnEnterGame()
  DataCenter.SeasonFarmerManager:SyncBubbleData()
  DataCenter.SurprisePointManager:OnEnterGame()
  DataCenter.EventCollectManager:OnEnterGame()
  self.heroPromoteData = {}
  self:InitHeroPromoteData()
  if self.playerSeasonInfo and LuaEntry.Player:IsInAlliance() and (self.playerSeasonInfo:InSettleTime() or self.playerSeasonInfo:InIdleTime()) then
    DataCenter.SeasonRewardDataManager:CheckAllianceRewardData()
  end
end

function SeasonDataManager:InitData(message)
  if message ~= nil and message.globalState ~= nil then
    CommonUtil.ProtectCall(function()
      self:SetGlobalStatus(message.globalState.list)
    end)
  end
  if message ~= nil and message.heroEventUserData ~= nil then
    CommonUtil.ProtectCall(function()
      RewardUtil.UpdateHeroEventData(message.heroEventUserData)
    end)
  end
  self.seasonActivity = nil
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local firstEnter = self.playerSeasonInfo == nil and self.serverSeasonInfo == nil
  local playerInfo = message.playerServerSeasonInfo
  local curServerSeasonInfo = message.curServerSeasonInfo
  local bigMap = message.bigMap
  local theTemplate = require("DataCenter.SeasonManager.SeasonInfoTemplate")
  local seasonIndex = toInt(playerInfo.seasonId)
  self.playerSeasonInfo = theTemplate.New(mySourceServerId, playerInfo, bigMap)
  self.serverSeasonInfo = theTemplate.New(loginServerId, curServerSeasonInfo, bigMap)
  if self.serverSeasonInfo and CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    if self.serverSeasonInfo.mode == 1 and self.serverSeasonInfo.serverListInt ~= nil then
      self.serverSeasonInfo.serverListStr[tostring(loginServerId)] = tostring(loginServerId)
      self.serverSeasonInfo.serverListInt[loginServerId] = loginServerId
    end
    CS.UnityEngine.Debug.Log(self:Description())
    Logger.LogInfo("SpecialServerSeasonInfo : " .. tostring(loginServerId) .. " , " .. tostring(self.serverSeasonInfo.seasonConfigId) .. " , " .. tostring(self.serverSeasonInfo.isSingleServerMode))
    Logger.LogInfo("SpecialServerSeasonInfo : " .. tostring(mySourceServerId) .. " , " .. tostring(self.playerSeasonInfo.seasonConfigId) .. " , " .. tostring(self.playerSeasonInfo.isSingleServerMode))
  end
  if playerInfo and 0 < seasonIndex then
    if playerInfo.monsterLevelInfos then
      self.monsterSearchMaxLevel = {}
      for key, value in pairs(playerInfo.monsterLevelInfos) do
        self.monsterSearchMaxLevel[value.monsterType] = value.level
      end
    end
    if curServerSeasonInfo.seasonStartTime and curServerSeasonInfo.seasonSettleTime and curServerSeasonInfo.seasonEndTime then
      PlayerPrefs.SetString("SeasonStartTime", tostring(curServerSeasonInfo.seasonStartTime))
      PlayerPrefs.SetString("SeasonSettleTime", tostring(curServerSeasonInfo.seasonSettleTime))
      PlayerPrefs.SetString("SeasonEndTime", tostring(curServerSeasonInfo.seasonEndTime))
    else
      PlayerPrefs.SetString("SeasonStartTime", "0")
      PlayerPrefs.SetString("SeasonSettleTime", "0")
      PlayerPrefs.SetString("SeasonEndTime", "0")
    end
    if SeasonUtil.SeasonHasMummyYardBuild(self.playerSeasonInfo:GetServerType(false)) then
      local mummy_config_k4 = SeasonUtil.GetMummyConfigStr("k4", "703050|703060|703070")
      if mummy_config_k4 then
        local statusList = string.split_ii_array(mummy_config_k4, "|")
        if statusList then
          EffectDefine.SEASON_MUMMY_Status_Id_CURSE1 = statusList[1] or 703050
          EffectDefine.SEASON_MUMMY_Status_Id_CURSE2 = statusList[2] or 703060
          EffectDefine.SEASON_MUMMY_Status_Id_CURSE3 = statusList[3] or 703070
          local stateMeta = LocalController:instance():getLine(TableName.StatusTab, EffectDefine.SEASON_MUMMY_Status_Id_CURSE1)
          if stateMeta then
            EffectDefine.SEASON_MUMMY_Effect_Id_CURSE1 = toInt(stateMeta.effect)
          end
          stateMeta = LocalController:instance():getLine(TableName.StatusTab, EffectDefine.SEASON_MUMMY_Status_Id_CURSE2)
          if stateMeta then
            EffectDefine.SEASON_MUMMY_Effect_Id_CURSE2 = toInt(stateMeta.effect)
          end
          stateMeta = LocalController:instance():getLine(TableName.StatusTab, EffectDefine.SEASON_MUMMY_Status_Id_CURSE3)
          if stateMeta then
            EffectDefine.SEASON_MUMMY_Effect_Id_CURSE3 = toInt(stateMeta.effect)
          end
        end
      end
    end
  end
  local reqSeasonInfo = {}
  local cityMax = LuaEntry.DataConfig:TryGetNum("worldcity_s0", "k12", 6)
  if 0 < seasonIndex then
    local SeasonConfig = self.playerSeasonInfo:GetCurrentSeasonConfig()
    if SeasonConfig then
      local cityMaxNew = toInt(SeasonConfig.city_max)
      if 0 < cityMaxNew then
        cityMax = cityMaxNew
      end
    end
  end
  self.CrossOccupyCityMaxNumLocal = cityMax
  self.CrossOccupyCityMaxNumOther = cityMax
  self.nextSeasonStartTime = self.playerSeasonInfo.nextSeasonStartTime
  if self.playerSeasonInfo then
    local serverListInt = self.playerSeasonInfo:GetServerListInt(false)
    local infoList = self.SpecialServerSeasonInfoList or {}
    infoList[toInt(mySourceServerId)] = self.playerSeasonInfo
    if serverListInt then
      if self.playerSeasonInfo.isSingleServerMode ~= true then
        for _, serverId in pairs(serverListInt) do
          if infoList[serverId] == nil then
            infoList[serverId] = theTemplate.New(serverId, playerInfo, bigMap)
          end
        end
      else
        for _, serverId in pairs(serverListInt) do
          if serverId ~= mySourceServerId and reqSeasonInfo[serverId] == nil then
            SFSNetwork.SendMessage(MsgDefines.GetSpecialServerSeasonInfo, serverId)
            reqSeasonInfo[serverId] = serverId
          end
        end
      end
    end
    if self.SpecialServerSeasonInfoList == nil then
      self.SpecialServerSeasonInfoList = infoList
    end
  end
  if self.serverSeasonInfo and 0 < seasonIndex then
    local serverListInt = self.serverSeasonInfo:GetServerListInt(false)
    local infoList = self.SpecialServerSeasonInfoList or {}
    infoList[toInt(loginServerId)] = self.serverSeasonInfo
    if serverListInt then
      if self.serverSeasonInfo.isSingleServerMode ~= true then
        for _, serverId in pairs(serverListInt) do
          if infoList[serverId] == nil then
            infoList[serverId] = theTemplate.New(serverId, curServerSeasonInfo, bigMap)
          end
        end
      else
        for _, serverId in pairs(serverListInt) do
          if serverId ~= loginServerId and reqSeasonInfo[serverId] == nil then
            SFSNetwork.SendMessage(MsgDefines.GetSpecialServerSeasonInfo, serverId)
            reqSeasonInfo[serverId] = serverId
          end
        end
      end
    end
    if self.SpecialServerSeasonInfoList == nil then
      self.SpecialServerSeasonInfoList = infoList
    end
    if not self.serverSeasonInfo:ActiveSkin() then
      local skin = SeasonWorldSkinUtil.GetSkin(1)
      if skin then
        self:SetLoginServerSkinMeta(skin)
      end
    end
    if self.serverSeasonInfo.currentSeasonConfig then
      SeasonUtil.UpdateResourceSkin(self.serverSeasonInfo:GetSkinTemplate())
      DataCenter.LWResourceLackManager:CleanData()
      DataCenter.AllianceGovernmentSkillManager:InitTemplates(true)
      DataCenter.AllianceGovernmentCommonSkillManager:InitTemplates()
    end
  else
    if self.serverSeasonInfo then
      local infoList = self.SpecialServerSeasonInfoList or {}
      infoList[toInt(loginServerId)] = self.serverSeasonInfo
      if self.SpecialServerSeasonInfoList == nil then
        self.SpecialServerSeasonInfoList = infoList
      end
    end
    local skin = SeasonWorldSkinUtil.GetSkin(1)
    if skin then
      self:SetLoginServerSkinMeta(skin)
    end
  end
  local hasVirus, theEffectId, theVirusMaxEffectId = SeasonUtil.HasVirus()
  if hasVirus and message.effectStateExtra ~= nil and 0 < table.count(message.effectStateExtra) then
    for k, v in pairs(message.effectStateExtra) do
      if v and v.stateId == CityState.VirusCity then
        LuaEntry.Player.VirusLayer = toInt(v.layer)
        Setting:SetPrivateBool("HasVirus", true)
        break
      end
    end
  end
  local seasonNum = SeasonUtil.GetSeason()
  if seasonNum ~= 0 and type(Localization.UpdateSkinData) == "function" and LocalController:instance():hasTable(TableName.Dialog_Skin) then
    local seasonCheck = string.format(";%s;", seasonNum)
    local dict = {}
    LocalController:instance():visitTable(TableName.Dialog_Skin, function(id, line)
      if line and line.season and string.match(line.season, seasonCheck) then
        dict[line.dialog_1] = line.dialog_2
      end
    end)
    SeasonUtil.UpdateDialogSkin(dict, true)
  end
  local theType = SeasonUtil.GetSeasonType(false, true)
  if SeasonUtil.SeasonHasAllianceSkill(theType) then
    DataCenter.AllianceSkillManager:RequestWorldEffectAlter()
    if SceneUtils.GetIsInWorld() then
      DataCenter.AllianceSkillManager:ClearAll()
      local theWorld = CS.SceneManager.World
      if theWorld ~= nil then
        theWorld:SetFirstViewRequestFlag(true)
        theWorld:UpdateViewRequest(true)
      end
    end
  end
  if not firstEnter then
    self:OnEnterGame()
  end
  UIRawImage.Link("Assets/Main/SeasonRes/S5/Sprites/CommonS5/wxy_S5_jianzhu_banner.png", "Assets/Main/SeasonRes/S5/Textures/Activity/Task/wxy_S5_jianzhu_banner.png")
  LuaEntry.GlobalData.UseLightWorkerMan = 0
  if theType == SeasonMapType.Darkness then
    if message ~= nil and message.lighthouse ~= nil then
      DataCenter.SeasonPowerWorkerManager:UpdateLightHouse(message.lighthouse)
    end
    if message ~= nil and message.powerWorker ~= nil then
      DataCenter.SeasonPowerWorkerManager:UpdatePowerWorkers(message.powerWorker)
    end
    if message ~= nil and message.powerWorker_formation ~= nil then
      DataCenter.SeasonPowerWorkerManager:UpdatePowerWorkerFormation(message.powerWorker_formation)
    end
  end
  if theType == SeasonMapType.NineNationRainforest then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostPosList)
    SFSNetwork.SendMessage(MsgDefines.FetchSourceMapOutpostList)
  end
  DataCenter.SeasonWeatherManager:RequestData()
  DataCenter.SeasonFarmerManager:SyncBubbleData()
  DataCenter.SeasonResourceDownloadManager:CheckResourceAutoDownload()
end

function SeasonDataManager:GetServerListInt(checkPreview)
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:GetServerListInt(checkPreview)
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  return {loginServerId}
end

function SeasonDataManager:GetNinePalacesIndexByWorldPos(worldPos)
  local x = Mathf.Clamp(worldPos.x / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
  local y = Mathf.Clamp(worldPos.z / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
  return 3 * y + x + 1
end

function SeasonDataManager:GetSeasonInfo(serverEnum_)
  local seasonInfo = self.serverSeasonInfo
  if serverEnum_ == ServerEnum.Source then
    seasonInfo = self.playerSeasonInfo
  elseif serverEnum_ == ServerEnum.View then
    seasonInfo = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
  end
  return seasonInfo
end

function SeasonDataManager:GetNinePalacesServer(mapIndex, serverEnum)
  local seasonInfo = self:GetSeasonInfo(serverEnum)
  return seasonInfo and seasonInfo:GetNinePalacesServer(mapIndex) or 0
end

function SeasonDataManager:GetNinePalacesServerByWorldPos(worldPos, serverEnum)
  local mapIndex = self:GetNinePalacesIndexByWorldPos(worldPos)
  return self:GetNinePalacesServer(mapIndex, serverEnum)
end

function SeasonDataManager:GetNinePalacesIndex(serverId, serverEnum)
  local seasonInfo = self:GetSeasonInfo(serverEnum)
  return seasonInfo and seasonInfo:GetNinePalacesIndex(serverId) or 1
end

function SeasonDataManager:IsInNinePalacesMode(serverId, serverEnum)
  local seasonInfo = self:GetSeasonInfo(serverEnum)
  return seasonInfo and seasonInfo:IsInNinePalacesMode(serverId) or false
end

function SeasonDataManager:GetActivityPreviewInfo()
  if self.playerSeasonInfo then
    local config = self.playerSeasonInfo:GetConfig()
    if config and not string.IsNullOrEmpty(config.activity) then
      self:InitSeasonActivity()
      local theActivityList = {}
      for activityId, _ in pairs(self.seasonActivity) do
        table.insert(theActivityList, toInt(activityId))
      end
      SFSNetwork.SendMessage(MsgDefines.GetActivityPreviewInfo, theActivityList)
    end
  end
end

function SeasonDataManager:GetOffSeasonActivityPreviewInfo()
  if self.playerSeasonInfo then
    local config = self.playerSeasonInfo:GetConfig()
    if config and not string.IsNullOrEmpty(config.truce_activity) then
      local theActivityList = {}
      for item in string.gmatch(config.truce_activity, "([^;]+)|?") do
        table.insert(theActivityList, toInt(item))
      end
      SFSNetwork.SendMessage(MsgDefines.GetActivityPreviewInfo, theActivityList, PreviewActivityType.OffSeason)
    end
  end
end

function SeasonDataManager:GetWorldCityTableName()
  if self.serverSeasonInfo then
    return self.serverSeasonInfo:GetWorldCityTableName()
  end
  return "lw_worldcity"
end

function SeasonDataManager:IsSameGroup(serverId)
  if LuaEntry.Player:IsInSourceServer() then
    return true
  end
  serverId = serverId or LuaEntry.Player:GetSelfServerId()
  if self.serverSeasonInfo and self.serverSeasonInfo.serverListInt then
    return self.serverSeasonInfo.serverListInt[serverId] ~= nil
  end
  return false
end

function SeasonDataManager:GetDamageConfig(ratio)
  local config = self.seasonDamageConfig
  if config == nil then
    config = {}
    LocalController:instance():visitTable(TableName.LW_Season_Damage, function(id, lineData)
      table.insert(config, {
        ratio = lineData.resistance_ratio / 10000,
        reduction = lineData.damage_reduction / 10000
      })
    end)
    table.sort(config, function(a, b)
      return a.ratio > b.ratio
    end)
    self.seasonDamageConfig = config
  end
  if config ~= nil then
    for _, v in ipairs(config) do
      if ratio >= v.ratio then
        return v.reduction
      end
    end
  end
  return 1
end

function SeasonDataManager:GetDamageConfig2(ratio)
  local config = self.seasonDamageConfig2
  if config == nil then
    config = {}
    LocalController:instance():visitTable(TableName.LW_Season_Damage_New, function(id, lineData)
      table.insert(config, {
        ratio = lineData.resistance_ratio,
        reduction = lineData.damage_reduction / 10000
      })
    end)
    table.sort(config, function(a, b)
      return a.ratio > b.ratio
    end)
    self.seasonDamageConfig2 = config
  end
  if config ~= nil then
    for _, v in ipairs(config) do
      if ratio >= v.ratio then
        return v.reduction
      end
    end
  end
  return 1
end

function SeasonDataManager:GetDamage1Config(ratio)
  local config = self.seasonDamage1Config
  if config == nil then
    config = {}
    LocalController:instance():visitTable(TableName.LW_Season_Damage, function(id, lineData)
      table.insert(config, {
        ratio = lineData.resistance_ratio / 10000,
        reduction = lineData.damage_reduction_1 / 10000
      })
    end)
    table.sort(config, function(a, b)
      return a.ratio > b.ratio
    end)
    self.seasonDamage1Config = config
  end
  if config ~= nil then
    for _, v in ipairs(config) do
      if ratio >= v.ratio then
        return v.reduction
      end
    end
  end
  return 1
end

function SeasonDataManager:GetMonsterDamageConfig(ratio)
  local config = self.seasonMonsterDamageConfig
  if config == nil then
    config = {}
    LocalController:instance():visitTable(TableName.LW_Season_Damage, function(id, lineData)
      table.insert(config, {
        ratio = lineData.resistance_ratio / 10000,
        reduction = lineData.monster_damage / 10000
      })
    end)
    table.sort(config, function(a, b)
      return a.ratio > b.ratio
    end)
    self.seasonMonsterDamageConfig = config
  end
  if config ~= nil then
    for _, v in ipairs(config) do
      if ratio >= v.ratio then
        return v.reduction
      end
    end
  end
  return 9
end

function SeasonDataManager:GetMonsterDamageConfig2(ratio)
  local config = self.seasonMonsterDamageConfig2
  if config == nil then
    config = {}
    LocalController:instance():visitTable(TableName.LW_Season_Damage_New, function(id, lineData)
      table.insert(config, {
        ratio = lineData.resistance_ratio,
        reduction = lineData.monster_damage / 10000
      })
    end)
    table.sort(config, function(a, b)
      return a.ratio > b.ratio
    end)
    self.seasonMonsterDamageConfig2 = config
  end
  if config ~= nil then
    for _, v in ipairs(config) do
      if ratio >= v.ratio then
        return v.reduction
      end
    end
  end
  return 9
end

function SeasonDataManager:GetDamagePoisonLayer(ratio)
  local config = self.seasonDamageConfigPoisonedLayer
  if config == nil then
    config = {}
    LocalController:instance():visitTable(TableName.LW_Season_Damage, function(id, lineData)
      table.insert(config, {
        ratio = lineData.resistance_ratio / 10000,
        layer = lineData.poisoned_layers
      })
    end)
    table.sort(config, function(a, b)
      return a.ratio > b.ratio
    end)
    self.seasonDamageConfigPoisonedLayer = config
  end
  if config ~= nil then
    for _, v in ipairs(config) do
      if ratio >= v.ratio then
        return v.layer
      end
    end
  end
  return 0
end

function SeasonDataManager:GetDamagePoisonLayer2(targetValue, selfValue)
  local resistance_base = LuaEntry.DataConfig:TryGetNum("resistance_base", "k1", 250)
  if resistance_base == 0 then
    resistance_base = 250
  end
  local ratio = math.floor((targetValue - selfValue) / resistance_base + 0.5)
  local config = self.seasonDamageConfigPoisonedLayer2
  if config == nil then
    config = {}
    LocalController:instance():visitTable(TableName.LW_Season_Damage_New, function(id, lineData)
      table.insert(config, {
        ratio = lineData.resistance_ratio,
        layer = lineData.poisoned_layers
      })
    end)
    table.sort(config, function(a, b)
      return a.ratio > b.ratio
    end)
    self.seasonDamageConfigPoisonedLayer2 = config
  end
  if config ~= nil then
    for _, v in ipairs(config) do
      if ratio >= v.ratio then
        return v.layer
      end
    end
  end
  return 0
end

function SeasonDataManager:GetSeasonWeekInfo()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo.seasonId, self.playerSeasonInfo:GetSeasonWeek()
  end
  return 0, 0
end

function SeasonDataManager:GetSeasonWeek(time)
  if self.playerSeasonInfo then
    return self.playerSeasonInfo.seasonId, self.playerSeasonInfo:GetSeasonWeekFromStart(time)
  end
  return 0, 0
end

function SeasonDataManager:WeekCardNeedRedPoint(theUtils)
  if self.playerSeasonInfo and self.playerSeasonInfo:GetConfig() and self.playerSeasonInfo:GetConfig().week_card then
    if theUtils == nil then
      theUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
    end
    if theUtils ~= nil and theUtils.GetWeekCardTabBtn(self.playerSeasonInfo:GetConfig().week_card) then
      return true
    end
  end
  return false
end

function SeasonDataManager:IsTacticalCardOpen(seasonType)
  if seasonType ~= SeasonMapType.Darkness and seasonType ~= SeasonMapType.NineNation then
    return false
  end
  if not TacticalCardUtil.IsFunctionOpen() then
    return false
  end
  local isOpen = DataCenter.MasteryManager:Enabled()
  if isOpen then
    local data = DataCenter.MasteryManager:GetData()
    if data == nil then
      return false
    elseif data.home_id == 0 then
      return false
    end
  end
  return true
end

function SeasonDataManager:GetRedPointCount()
  local count = 0
  local theUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
  if theUtils == nil then
    return 0
  end
  local disRed = CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE)
  if disRed then
    if theUtils.SeasonMainTab() then
      count = count + 1
    end
    if self:WeekCardNeedRedPoint(theUtils) then
      count = count + 1
    end
  end
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(true)
  for key, value in pairs(list) do
    if not disRed and ActivityRedPointDefs[value.type] then
    elseif value.type == EnumActivity.BattlePass_new.Type then
      if theUtils.SeasonBattlePassTabRedPoint(value.activityId) then
        count = count + 1
      end
    elseif value.type == EnumActivity.ActHeroPromotion.Type then
      if theUtils.SeasonHeroPromotionRedPoint(value.activityId) then
        count = count + 1
      end
    elseif value.type == EnumActivity.SeasonCrossAttackCityActivity.Type then
      count = count + theUtils.GetCrossAttackCityRedPoint()
    elseif value.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
      count = count + theUtils.GetCrossDeclareWarRedPoint(nil)
    elseif value.type == EnumActivity.SeasonAttackCityActivity.Type then
      if LuaEntry.Player:IsInAlliance() then
        local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
        if data and data.content then
          local click_count = UIUtil.GetTodayActiveCount("SeasonAttackCity" .. data.content, false)
          if click_count == 0 then
            count = count + 1
          end
        end
      end
    elseif value.type == EnumActivity.CounterAttack.Type then
      if DataCenter.CounterAttackDataManager:GetFirstSeenRedPoint() or 0 < DataCenter.CounterAttackDataManager:GetAwardRedPoint() then
        count = count + 1
      end
    elseif value.type == EnumActivity.HighSpeedRailway.Type then
      if 0 < DataCenter.HSRDataManager:GetRedPoint() then
        count = count + 1
      end
    elseif value.type == EnumActivity.SandWormHunt.Type then
      if DataCenter.SandWormHuntDataManager:GetCanReceive() or DataCenter.SandWormHuntDataManager:GetFirstSeenRedPoint() then
        count = count + 1
      end
    elseif value.type == EnumActivity.JungleTrial.Type then
      if DataCenter.JungleTrialDataManager:GetCanReceive() or 0 < DataCenter.JungleTrialDataManager:GetCanOpenBoxNum() then
        count = count + 1
      end
    elseif value.type == EnumActivity.BloodyNight.Type then
      if DataCenter.BloodyNightDataManager:GetCanReceive() or DataCenter.BloodyNightDataManager:GetFirstSeenRedPoint() then
        count = count + 1
      end
    elseif value.type == EnumActivity.SeasonNuclearPowerPlantActivity.Type then
      if DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityTaskRedState() then
        count = count + 1
      end
    elseif value.type == EnumActivity.SnowStormComing.Type then
      local state = DataCenter.SeasonSnowStormDataManager:GetActivityStateData()
      if state ~= ActivitySnowStormState.SnowStorm then
        local curActivity = DataCenter.SeasonSnowStormDataManager.curActivity
        local flag = false
        if curActivity then
          local configId = curActivity.cfgId
          local eventConfig = LocalController:instance():getLine(TableName.StormEvent, configId)
          if eventConfig then
            for index, value in ipairs(eventConfig.quest) do
              local taskData = DataCenter.TaskManager:FindTaskInfo(value)
              if taskData and taskData.state == TaskState.CanReceive then
                flag = true
                break
              end
            end
          end
        end
        if flag then
          count = count + 1
        end
      end
    elseif value.type == EnumActivity.ActivityTetris.Type then
      if theUtils.IsShowTetrisRed() then
        count = count + 1
      end
    elseif value.type == EnumActivity.ActMigration.Type then
      if 0 < DataCenter.ActMigrationManager:GetRedNum() then
        count = count + 1
      end
    elseif value.type == EnumActivity.DiggingGame.Type then
      local diggingCount = DataCenter.DiggingDataManager:GetRedCount()
      if 0 < diggingCount then
        count = count + diggingCount
      end
    elseif value.type == EnumActivity.SeasonGreen.Type then
      local rewardCount = DataCenter.SeasonGreenManager:GetRedCount()
      if 0 < rewardCount then
        count = count + rewardCount
      end
    elseif value.type == EnumActivity.GoldTree.Type then
      local prayCount = DataCenter.SeasonGoldTreeManager:CanPrayCardCount()
      if 0 < prayCount then
        count = count + prayCount
      end
    elseif value.type == EnumActivity.SeasonLastWar.Type then
      local tasks = DataCenter.ActivityListDataManager:GetExtraData(EVE_DECISIVE_BATTLE_TASK)
      if tasks then
        for _, task in pairs(tasks) do
          if task and task.state == TaskState.CanReceive then
            count = count + 1
            break
          end
        end
      end
    elseif value.type == EnumActivity.SeasonBountyShop.Type then
      if DataCenter.SeasonBountyShopManager:ShowDailyRed() then
        count = count + 1
      end
    elseif value.type == EnumActivity.SeasonWarZoneOutpostAttack.Type then
      local FetchOutpostBattleInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostBattleInfoMessage")
      if FetchOutpostBattleInfo and FetchOutpostBattleInfo.HasRed() then
        count = count + 1
      end
    elseif value.type == EnumActivity.SeasonKillMonsterRank.Type or value.type == EnumActivity.SeasonStrongholdRank.Type or value.type == EnumActivity.SeasonAttackWorldDesertActivity.Type then
      local rewardCount = DataCenter.LWSeasonWastelandDataManager:GetRedCount(value.activityId)
      count = count + rewardCount
    end
  end
  return count
end

function SeasonDataManager:UpdateDesertMaxLevel(level)
  if level and self.playerSeasonInfo then
    self.playerSeasonInfo.fightWinLv = math.max(level, self.playerSeasonInfo.fightWinLv or 1)
  end
end

function SeasonDataManager:GetDesertMaxLevel()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo.fightWinLv or 1
  end
  return 1
end

function SeasonDataManager:IsInBattleServerGroup(serverId)
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:IsInBattleServerGroup(serverId)
  end
  return false
end

function SeasonDataManager:InNormalMode()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:InNormalMode()
  end
  return false
end

function SeasonDataManager:InPreviewMode()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:InPreviewMode()
  end
  return false
end

function SeasonDataManager:InSettleTime()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:InSettleTime()
  end
  return false
end

function SeasonDataManager:GetUserSeasonInfo()
  return self.playerSeasonInfo
end

function SeasonDataManager:GetServerSeasonInfo()
  return self.serverSeasonInfo
end

function SeasonDataManager:GetSeasonConfig()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:GetConfig()
  end
  return nil
end

function SeasonDataManager:GetPlayerCurrentSeasonConfig()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:GetCurrentSeasonConfig()
  end
  return nil
end

function SeasonDataManager:GetServerCurrentSeasonConfig()
  if self.serverSeasonInfo then
    return self.serverSeasonInfo:GetCurrentSeasonConfig()
  end
  return nil
end

function SeasonDataManager:GetServerSeasonConfig()
  if self.serverSeasonInfo then
    return self.serverSeasonInfo:GetConfig()
  end
  return nil
end

function SeasonDataManager:GetLootRewardList()
  local config = self.playerSeasonInfo:GetConfig()
  if self.lootRewardList == nil and config and config.loot_reward_show then
    self.lootRewardList = DataCenter.RewardManager:ParseRewardsStr(config.loot_reward_show)
  end
  return self.lootRewardList
end

function SeasonDataManager:GetHeroIdsList()
  if self.heroIdsList ~= nil then
    return self.heroIdsList
  end
  local config = self.playerSeasonInfo:GetConfig()
  if config and config.season_heros then
    self.heroIdsList = {}
    for item in string.gmatch(config.season_heros, "([^;]+);?") do
      table.insert(self.heroIdsList, toInt(item))
    end
    return self.heroIdsList
  end
  return {}
end

function SeasonDataManager:GetSeasonId(includePreview)
  if self.playerSeasonInfo then
    if includePreview and self.playerSeasonInfo:InPreviewMode() and self.playerSeasonInfo.nextSeasonConfigId then
      return self.playerSeasonInfo.nextSeasonConfigId
    end
    return self.playerSeasonInfo.seasonConfigId or 1
  end
  return 1
end

function SeasonDataManager:GetSeason()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo.seasonId or 0
  end
  return 0
end

function SeasonDataManager:GetSeasonStartTime()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:GetSeasonStartTime()
  end
  return MANY_YEARS_LATER
end

function SeasonDataManager:GetSeasonSettleTime()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:GetSeasonSettleTime()
  end
  return MANY_YEARS_LATER
end

function SeasonDataManager:GetSeasonEndTime()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:GetSeasonEndTime()
  end
  return MANY_YEARS_LATER
end

function SeasonDataManager:GetSeasonDurationDay()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:GetSeasonDurationDay()
  end
  return 56
end

function SeasonDataManager:GetNextSeasonStartTime()
  if self.playerSeasonInfo then
    return self.playerSeasonInfo:GetNextSeasonStartTime()
  end
  return 0
end

function SeasonDataManager:GetAllianceMilestoneGroup()
  if self.playerSeasonInfo then
    local config = self.playerSeasonInfo:GetConfig()
    if config then
      return toInt(config.alliance_milestone)
    end
  end
  return 0
end

function SeasonDataManager:InitSeasonActivity(force)
  if self.playerSeasonInfo == nil then
    return
  end
  if not force and self.seasonActivity ~= nil then
    return
  end
  local config = self.playerSeasonInfo:GetConfig()
  self.seasonActivity = {}
  self.seasonPreActivity = {}
  if config then
    local activity = config.activity or ""
    for item in string.gmatch(activity, "([^;]+)|?") do
      self.seasonActivity[item] = true
    end
    activity = config.pre_activity or ""
    for item in string.gmatch(activity, "([^;]+)|?") do
      self.seasonActivity[item] = true
      self.seasonPreActivity[item] = true
    end
  end
end

function SeasonDataManager:IsActivityForSeason(activityId)
  if self.playerSeasonInfo == nil then
    return false, false, SeasonMapType.Nothing
  end
  local activityStr = tostring(activityId)
  self:InitSeasonActivity()
  return self.seasonActivity[activityStr] ~= nil, self.seasonPreActivity[activityStr] ~= nil, self.playerSeasonInfo:GetServerType(false)
end

function SeasonDataManager:GetActivityIds()
  if self.playerSeasonInfo then
    local config = self.playerSeasonInfo:GetConfig()
    if config and not string.IsNullOrEmpty(config.activity) then
      local result = {}
      for item in string.gmatch(config.activity, "([^;]+)|?") do
        result[item] = true
      end
      return result
    end
  end
  return {}
end

function SeasonDataManager:GetPrepareActivityIds()
  if self.playerSeasonInfo then
    local config = self.playerSeasonInfo:GetConfig()
    if config and not string.IsNullOrEmpty(config.pre_activity) then
      local result = {}
      for item in string.gmatch(config.pre_activity, "([^;]+)|?") do
        result[item] = true
      end
      return result
    end
  end
  return {}
end

function SeasonDataManager:SetCrossDeclareWarCityList(t)
  if t and t.targetServer then
    if self.CrossDeclareWarCityList == nil then
      self.CrossDeclareWarCityList = {}
    end
    self.CrossDeclareWarCityList[tostring(t.targetServer)] = t.cityInfoList
    EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossDeclareWarCityList)
  end
end

function SeasonDataManager:GetCrossDeclareWarCityList(targetServer)
  if self.CrossDeclareWarCityList then
    return self.CrossDeclareWarCityList[tostring(targetServer)]
  end
  return nil
end

function SeasonDataManager:CleanCrossDeclareWarCityList()
  self.CrossDeclareWarCityList = {}
end

function SeasonDataManager:GetSeasonHeroEventIds()
  local config = self.playerSeasonInfo:GetConfig()
  if self.allianceEventIds == nil and config and config.alliance_event then
    self.allianceEventIds = string.split(config.alliance_event, "|")
  end
  return self.allianceEventIds
end

function SeasonDataManager:CanCrossDeclareWar()
  if self.CrossDeclareWarInfo == nil then
    return false
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local currEndTime = self.CrossDeclareWarInfo.currEndTime
  if currEndTime ~= nil and serverTime < currEndTime and currEndTime <= LuaEntry.GlobalData.tomorrow * 1000 + 1000 then
    return true
  end
  return false
end

function SeasonDataManager:SetShareDesertStatus(desertUuid, invalidFlag, recUser)
  local data = self.ShareDesertStatus[desertUuid]
  if data then
    self.ShareDesertStatus[desertUuid] = {
      invalid = invalidFlag,
      user = recUser,
      overTime = data.overTime
    }
  else
    self.ShareDesertStatus[desertUuid] = {invalid = invalidFlag, user = recUser}
  end
end

function SeasonDataManager:GetShareDesertStatus(desertUuid, overTime, curTime)
  local data = self.ShareDesertStatus[desertUuid]
  if data then
    data.overTime = overTime
  end
  if (data == nil or data.dirty) and desertUuid ~= nil and desertUuid ~= 0 and curTime < overTime and self.ShareDesertStatusPost[desertUuid] == nil then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonDesertShareInfo, desertUuid)
    self.ShareDesertStatusPost[desertUuid] = true
    if CS.CommonUtils.IsDebug() then
      Logger.Log("GetShareDesertStatus -> " .. desertUuid)
    end
  end
  return data
end

function SeasonDataManager:CleanShareDesertStatus()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, desertStatus in pairs(self.ShareDesertStatus) do
    if desertStatus and desertStatus.invalid ~= 1 and (desertStatus.overTime == nil or curTime < desertStatus.overTime) then
      desertStatus.dirty = true
    end
  end
  self.ShareDesertStatusPost = {}
end

function SeasonDataManager:UpdateMonsterMaxLevel(message)
  if message.monsterLevelInfos then
    for key, value in pairs(message.monsterLevelInfos) do
      self.monsterSearchMaxLevel[value.monsterType] = value.level
    end
  end
end

function SeasonDataManager:GetMonsterMaxLevel(type)
  if self.monsterSearchMaxLevel[type] and IsNumber(self.monsterSearchMaxLevel[type]) then
    local maxLevel = self.monsterSearchMaxLevel[type] + 1
    local template = DataCenter.MonsterTemplateManager:GetMonsterTemplatebyLevelType(maxLevel, type)
    if template and template.level == maxLevel then
      return maxLevel
    else
      return self.monsterSearchMaxLevel[type]
    end
  end
  return 1
end

function SeasonDataManager:GetMonsterSearchMaxLevel(type)
  local ret = self.monsterSearchMaxLevel[type]
  if ret and IsNumber(ret) then
    return ret
  end
  return 1
end

function SeasonDataManager:GetMonsterMaxLevelOfBigThree()
  local resMonster = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.ResMetal)
  local resFood = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.ResFood)
  local resGold = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.ResGold)
  local max = resMonster
  if resFood > max then
    max = resFood
  end
  if resGold > max then
    max = resGold
  end
  return max
end

function SeasonDataManager:GetSeasonWorldBGM(seasonType)
end

function SeasonDataManager:GetCityBGMId()
  local serverId = CS.GameEntry.Data.Player:GetSelfServerId()
  local info = SeasonUtil.GetSeasonInfo(serverId)
  if info and info:InIdleTime() then
    local line = LocalController:instance():getLine(TableName.World_Skin, 1)
    local soundIdDefultId = line.home_bgm
    return soundIdDefultId
  end
  local useSeasonBGM = Setting:GetBool(SettingKeys.USE_SEASON_BGM, true)
  if not useSeasonBGM then
    local line = LocalController:instance():getLine(TableName.World_Skin, 1)
    local soundIdDefultId = line.home_bgm
    return soundIdDefultId
  end
  local config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if config then
    local skin = config:GetSkinTemplate()
    if skin then
      return skin.home_bgm
    end
  end
end

function SeasonDataManager:GetWorldBGMId()
  local info = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetSelfServerId())
  if info and info:InIdleTime() then
    local line = LocalController:instance():getLine(TableName.World_Skin, 1)
    local soundIdDefultId = line.world_bgm
    return soundIdDefultId
  end
  local useSeasonBGM = Setting:GetBool(SettingKeys.USE_SEASON_BGM, true)
  if not useSeasonBGM then
    local line = LocalController:instance():getLine(TableName.World_Skin, 1)
    local soundIdDefultId = line.world_bgm
    return soundIdDefultId
  end
  local config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if config then
    local skin = config:GetSkinTemplate()
    if skin then
      return skin.world_bgm
    end
  end
end

function SeasonDataManager:GetCityAMBSoundId()
  local id = DataCenter.SeasonWeatherManager:GetAMBSoundId()
  if id ~= 0 then
    return id
  end
  local config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if config then
    local skin = config:GetSkinTemplate()
    if skin then
      id = skin.city_sound
    end
  end
  return id
end

function SeasonDataManager:GetWorldAMBSoundId()
  local id = DataCenter.SeasonWeatherManager:GetAMBSoundId()
  if id ~= 0 then
    return id
  end
  local config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if config then
    local skin = config:GetSkinTemplate()
    if skin then
      id = skin.world_sound
    end
  end
  return id
end

function SeasonDataManager:GetGateDefenceData()
  local cfg = self.playerSeasonInfo:GetSkinTemplate()
  if not string.IsNullOrEmpty(cfg.zombie_defence) then
    local str = string.split(cfg.zombie_defence, "|")
    return str
  end
  return nil
end

function SeasonDataManager:GetTrainSceneSkin()
  local cfg = self.playerSeasonInfo:GetSkinTemplate()
  if not string.IsNullOrEmpty(cfg.truck_skin) and CS.GameEntry.Resource:HasAsset(cfg.truck_skin) then
    return cfg.truck_skin
  end
  return "Assets/Main/Sprites/Scene/zyf_chengjimaoyi_bg.png"
end

function SeasonDataManager:GetOasisViewScaleList()
  local curSeasonInfo = SeasonUtil.GetCurServerConfig()
  if not curSeasonInfo or not curSeasonInfo.currentSeasonConfig then
    return
  end
  if self.OasisViewScaleList and curSeasonInfo.seasonId == self.OasisViewScaleList.seasonId then
    return self.OasisViewScaleList
  end
  local line = curSeasonInfo:GetSkinTemplate()
  if line and not string.IsNullOrEmpty(line.view_scale) then
    local index = 1
    self.OasisViewScaleList = {}
    local group = tonumber(line.view_scale) or 0
    LocalController:instance():visitTable(TableName.LW_Season_OasisViewScale, function(id, lineData)
      if lineData and lineData.group == group then
        self.OasisViewScaleList[index] = {
          id = lineData.id,
          group = lineData.group,
          order = lineData.order,
          name = lineData.name or "",
          range = lineData.range,
          innerColor = lineData.innerColor and Color.FromHex(lineData.innerColor),
          baseColor = lineData.baseColor and Color.FromHex(lineData.baseColor),
          outlineColor = lineData.outlineColor and Color.FromHex(lineData.outlineColor)
        }
        index = index + 1
      end
    end)
    table.sort(self.OasisViewScaleList, function(a, b)
      return a.order < b.order
    end)
    self.OasisViewScaleList.seasonId = curSeasonInfo.seasonId
    return self.OasisViewScaleList
  end
end

function SeasonDataManager:OnGetSeasonForceValue(valueType, value)
  if valueType == 1 then
    self.allianceForceValue = value
  elseif valueType == 2 then
    self.selfForceValue = value
  elseif valueType == 3 then
    self.serverForceValue = value
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonForceValue, valueType, value)
end

function SeasonDataManager:GetSeasonRankCache(rank_type)
  if self.seasonRankData and self.seasonRankData[rank_type] then
    return self.seasonRankData[rank_type]
  end
  return nil
end

function SeasonDataManager:GetSeasonRankDataCache(rank_type, uid)
  if self.seasonRankData and self.seasonRankData[rank_type] then
    return self.seasonRankData[rank_type][uid]
  end
  return nil
end

function SeasonDataManager:GetSeasonRankDataCacheByRank(rank_type, rank)
  if self.seasonRankData then
    local rankList = self.seasonRankData[rank_type]
    if rankList then
      local ret
      for k, v in pairs(rankList) do
        if v and v.data and v.data.rank == rank and (ret == nil or ret.updateTime < v.updateTime) then
          ret = v
        end
      end
      if ret then
        return ret.data
      end
    end
  end
  return nil
end

function SeasonDataManager:SetSeasonRankDataCache(rank_type, uid, value, rankData)
  if self.seasonRankData then
    local rankList = self.seasonRankData[rank_type]
    if rankList then
      local now = UITimeManager:GetInstance():GetServerTime()
      local data = rankList[uid]
      if data == nil then
        data = {}
        data.oldValue = value
        data.newValue = value
        rankList[uid] = data
      else
        data.oldValue = data.newValue
        data.newValue = value
      end
      data.data = rankData
      data.updateTime = now
    end
  end
end

function SeasonDataManager:UpdateSeasonRankDataCache(t)
  if t.rank_type and (t.rank_type == SeasonRankType.AlliancePower or t.rank_type == 2 or t.rank_type == 3 or t.rank_type == 6 or t.rank_type == 7 or t.rank_type == 8 or t.rank_type == 10 or t.rank_type == SeasonRankType.ServerFamer) then
    if not self.seasonRankData then
      self.seasonRankData = {}
    end
    if not self.seasonRankData[t.rank_type] then
      self.seasonRankData[t.rank_type] = {}
    end
    local rankList = t.rank or t.ranks or t.ls
    if rankList and #rankList then
      for key, value in pairs(rankList) do
        local uidKey
        if t.rank_type == 1 or t.rank_type == 6 or t.rank_type == 7 or t.rank_type == 8 or t.rank_type == SeasonRankType.ServerFamer then
          uidKey = value.aid or value.allianceId
        elseif t.rank_type == 2 then
          uidKey = value.uid
        elseif t.rank_type == 3 or t.rank_type == 10 then
          uidKey = value.serverId
        end
        local tScore = toInt(value.rank)
        DataCenter.SeasonDataManager:SetSeasonRankDataCache(t.rank_type, uidKey, tScore, value)
      end
    end
  end
end

function SeasonDataManager:GetNowSeasonAndSeasonDay()
  local nowSeason = DataCenter.SeasonDataManager:GetSeason()
  local day = UITimeManager:GetInstance():GetServerOpenDays()
  if nowSeason ~= 0 then
    day = DataCenter.SeasonDataManager:GetSeasonDurationDay() + 1
  end
  return nowSeason, day
end

function SeasonDataManager:CheckNowSeasonArrive(season, day)
  season = tonumber(season)
  day = tonumber(day)
  local nowSeason, nowDay = self:GetNowSeasonAndSeasonDay()
  return season < nowSeason or nowSeason == season and day <= nowDay
end

function SeasonDataManager:InitHeroPromoteData()
  local k1 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k1") or ""
  local k2 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k2") or ""
  local k3 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k3") or ""
  local k4 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k4") or ""
  if not string.IsNullOrEmpty(k1) then
    local activityIds = string.split(k1, "|")
    local oldIds = string.split(k2, "|")
    local newIds = string.split(k3, "|")
    local cost = string.split(k4, "|")
    if 0 < #activityIds and #activityIds == #oldIds and #activityIds == #newIds and 2 == #cost then
      for i, v in ipairs(activityIds) do
        local data = {}
        data.activityId = toInt(v)
        data.oldId = toInt(oldIds[i])
        data.newId = toInt(newIds[i])
        data.costItemId = cost[1]
        data.costCount = toInt(cost[2])
        table.insert(self.heroPromoteData, data)
      end
    end
  end
end

function SeasonDataManager:GetHeroCanPromoteData(heroId, activityId)
  if heroId == nil or activityId == nil then
    return false
  end
  if not self.heroPromoteData then
    return nil
  end
  heroId = toInt(heroId)
  activityId = toInt(activityId)
  local maxIndex = -1
  for index, v in ipairs(self.heroPromoteData) do
    if v.activityId == activityId then
      maxIndex = index
      break
    end
  end
  if maxIndex == -1 then
    return nil
  end
  local findData
  for index = 1, maxIndex do
    local promoteData = self.heroPromoteData[index]
    if promoteData and promoteData.oldId == heroId then
      findData = promoteData
    end
  end
  if not findData then
    return nil
  end
  return {
    costItemId = findData.costItemId,
    costCount = findData.costCount
  }
end

function SeasonDataManager:GetHeroCanPromoteDataByIndex(index)
  return self.heroPromoteData[index]
end

function SeasonDataManager:TryFindHeroPromoteDataIndexByTMDHeroId(heroId)
  if not heroId or not self.heroPromoteData then
    return
  end
  for k, v in ipairs(self.heroPromoteData) do
    if v.newId == heroId then
      return k
    elseif v.oldId == heroId then
      return k
    end
  end
end

function SeasonDataManager:Description()
  local time = UITimeManager:GetInstance()
  local sb = StringBuilder.New()
  sb:AppendLine(string.format("\231\142\169\229\174\182id:%s", LuaEntry.Player:GetUid()))
  sb:AppendLine(string.format("\230\156\141\229\138\161\229\153\168id:%s", LuaEntry.Player:GetSelfServerId()))
  if table.count(self.theNinePalacesData) > 0 then
    sb:AppendLine(string.format("\228\185\157\229\174\171\230\160\188\229\136\134\229\140\186:%s", table.table2string(self.theNinePalacesData)))
  end
  sb:AppendLine(string.format("\229\189\147\229\137\141\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(time:GetServerTime())))
  if self.playerSeasonInfo then
    sb:AppendLine("====\229\142\159\230\156\141\232\181\155\229\173\163\228\191\161\230\129\175(playerSeasonInfo)====")
    sb:AppendLine(self.playerSeasonInfo:Description())
  end
  if self.serverSeasonInfo then
    sb:AppendLine("====\231\153\187\229\189\149\230\156\141\232\181\155\229\173\163\228\191\161\230\129\175(serverSeasonInfo)====")
    sb:AppendLine(self.serverSeasonInfo:Description())
  end
  return sb:ToString()
end

function SeasonDataManager:UpdateServerDetail(serverId, data)
  if self.theServerDetailDict == nil then
    self.theServerDetailDict = {}
  end
  self.theServerDetailDict[serverId] = data
  EventManager:GetInstance():Broadcast(EventId.LWSeasonUpdateServerDetail, serverId)
end

function SeasonDataManager:GetServerDetail(serverId)
  if self.theServerDetailDict == nil then
    return nil
  end
  return self.theServerDetailDict[serverId]
end

function SeasonDataManager:GetLoginServerSkinMeta()
  return self.loginServerSkinMeta
end

function SeasonDataManager:GetViewServerSkinMeta()
  if self.viewServerSkinMeta then
    return self.viewServerSkinMeta
  end
  return self.loginServerSkinMeta
end

function SeasonDataManager:SetViewServerSkinMeta(skin)
  local mgr = CS.SceneSkinManager.Instance
  local curSkin = mgr:GetCurSkinMeta()
  mgr:SetViewModeSkinMeta(skin)
  if skin == nil then
    self.viewServerSkinMeta = nil
    if self.serverSeasonInfo then
      self.serverSeasonInfo:ActiveNinePalacesData()
    end
  else
    self:InitAllWorldSkinMeta()
    self.viewServerSkinMeta = self.allWorldSkinConfig[skin.id] or {}
    if curSkin and skin and skin.id == curSkin.id then
      local world = CS.SceneManager.World
      local serverId = LuaEntry.Player:GetCurServerId()
      if world and not DataCenter.SeasonDataManager:IsSameGroup(serverId) then
        local sunrise1 = DataCenter.BloodyNightDataManager:IsSunrise(serverId)
        local sunrise2 = DataCenter.BloodyNightDataManager:IsSunrise(LuaEntry.Player:GetSelfServerId())
        if sunrise1 ~= sunrise2 then
          local data = SeasonUtil.GetCurServerConfig()
          if data and data:GetServerType(false) == SeasonMapType.Darkness then
            world:OnSkinChange(true)
          end
        end
      end
    end
  end
  if SceneUtils.GetIsInWorld() then
    pcall(function()
      if skin == nil then
        local seasonType = SeasonUtil.GetSeasonType(false)
        DataCenter.SceneCameraManager.SwitchWorldClipPlane(seasonType)
      else
        DataCenter.SceneCameraManager.SwitchWorldClipPlane(skin.mapType)
      end
    end)
  end
end

function SeasonDataManager:SetLoginServerSkinMeta(skin)
  CS.SceneSkinManager.Instance:SetCurSkinMeta(skin)
  self:InitAllWorldSkinMeta()
  self.loginServerSkinMeta = self.allWorldSkinConfig[skin.id] or {}
end

function SeasonDataManager:InitAllWorldSkinMeta()
  if self.allWorldSkinConfig == nil then
    self.allWorldSkinConfig = {}
    if not LocalController:instance():hasTable(TableName.World_Skin) then
      return
    end
    LocalController:instance():visitTable(TableName.World_Skin, function(id, lineData)
      local config = {}
      config.id = lineData:getIntValue("id", 0)
      config.map = lineData:getValue("map")
      config.loading_bg = lineData:getValue("loading_bg")
      config.logo = lineData:getValue("logo")
      config.world_deco_byte = lineData:getValue("world_deco_byte")
      config.world_deco_asset = lineData:getValue("world_deco_asset")
      config.world_block = lineData:getValue("world_block")
      config.world_terrain = lineData:getValue("world_terrain")
      config.world_terrain_low = lineData:getValue("world_terrain_low")
      config.world_terrain_control = lineData:getValue("world_terrain_control")
      config.world_terrain_black = lineData:getValue("world_terrain_black")
      config.world_map = lineData:getValue("world_map")
      config.world_zone_line = lineData:getValue("world_zone_line")
      config.city_terrain = lineData:getValue("city_terrain")
      config.city_deco = lineData:getValue("city_deco")
      config.city_fog = lineData:getValue("city_fog")
      config.radar_bg = lineData:getValue("radar_bg")
      config.resource_10 = lineData:getValue("resource_10")
      config.resource_13 = lineData:getValue("resource_13")
      config.resource_alliance = lineData:getValue("resource_alliance")
      config.zombie_defence = lineData:getValue("zombie_defence")
      config.world_terrain_mode = lineData:getIntValue("world_terrain_mode", 0)
      config.world_terrain_mode_mat = lineData:getValue("world_terrain_mode_mat")
      config.troopline_color = lineData:getValue("troopline_color")
      config.truck_skin = lineData:getValue("truck_skin")
      config.camera_scaling = lineData:getValue("camera_scaling")
      config.view_scale = lineData:getValue("view_scale")
      config.season_build_zone = lineData:getValue("season_build_zone")
      config.season_type = lineData:getIntValue("season_type", 0)
      config.edge_performance = lineData:getValue("edge_performance")
      config.world_fog = lineData:getValue("world_fog")
      config.world_fog_bloody = lineData:getValue("world_fog_bloody")
      config.trade_monster = lineData:getValue("trade_monster")
      config.light_monster = lineData:getValue("light_monster")
      config.loading_bgm = lineData:getIntValue("loading_bgm", 0)
      config.home_bgm = lineData:getIntValue("home_bgm", 0)
      config.world_bgm = lineData:getIntValue("world_bgm", 0)
      config.city_sound = lineData:getValue("city_sound")
      config.world_sound = lineData:getValue("world_sound")
      config.world_chess_color = lineData:getIntValue("world_chess_color", 0)
      config.edge_world_fog = lineData:getValue("edge_world_fog")
      config.cityPostProcessVolume = lineData:getValue("cityPostProcessVolume")
      config.aliases = lineData:getValue("aliases")
      config.position = lineData:getValue("position")
      config.location_icon = lineData:getValue("location_icon")
      config.location_info = lineData:getValue("location_info")
      config.location_buff = lineData:getValue("location_buff")
      config.season_ui_top_bg = lineData:getValue("season_ui_top_bg")
      config.season_ui_bg_color = lineData:getValue("season_ui_bg_color")
      config.mini_map = lineData:getValue("mini_map")
      config.finish_bg = lineData:getValue("finish_bg")
      config.finish_tittle = lineData:getValue("finish_tittle")
      config.finish_info = lineData:getValue("finish_info")
      local world_truck_path = lineData:getValue("world_truck_path")
      if not string.IsNullOrEmpty(world_truck_path) then
        config.world_truck_path = world_truck_path
      end
      local city_truck_path = lineData:getValue("city_truck_path")
      if not string.IsNullOrEmpty(city_truck_path) then
        config.city_truck_path = city_truck_path
      end
      local truck_parking = lineData:getValue("truck_parking")
      if not string.IsNullOrEmpty(truck_parking) then
        config.truck_parking = truck_parking
      end
      local truck_small_icon = lineData:getValue("truck_small_icon")
      if not string.IsNullOrEmpty(truck_small_icon) then
        config.truck_small_icon = truck_small_icon
      end
      local truck_big_icon = lineData:getValue("truck_big_icon")
      if not string.IsNullOrEmpty(truck_big_icon) then
        config.truck_big_icon = truck_big_icon
      end
      local season_main_ui_btn_sound = lineData:getValue("season_main_ui_btn_sound")
      if not string.IsNullOrEmpty(season_main_ui_btn_sound) then
        config.season_main_ui_btn_sound = season_main_ui_btn_sound
      end
      local season_activity_ui_btn_sound = lineData:getValue("season_activity_ui_btn_sound")
      if not string.IsNullOrEmpty(season_activity_ui_btn_sound) then
        config.season_activity_ui_btn_sound = season_activity_ui_btn_sound
      end
      config.city_camp_count = lineData:getValue("city_camp_count")
      config.city_camp_terrain = lineData:getValue("city_camp_terrain")
      config.city_camp_deco = lineData:getValue("city_camp_deco")
      config.city_camp_fog = lineData:getValue("city_camp_fog")
      config.center_extra_fog = lineData:getValue("center_extra_fog")
      config.center_extra_fog_days = lineData:getValue("center_extra_fog_days")
      config.camp_congress_heitu = lineData:getValue("camp_congress_heitu")
      config.camp_city_huitu = lineData:getValue("camp_city_huitu")
      config.camp_city_wall_skin = lineData:getValue("camp_city_wall_skin")
      self.allWorldSkinConfig[id] = config
    end)
  end
end

function SeasonDataManager:GetGetWorldSkinTemplateById(id)
  self:InitAllWorldSkinMeta()
  return self.allWorldSkinConfig[id] or {}
end

function SeasonDataManager:SetGlobalStatus(message)
  self.globalStatus = {}
  if message then
    for k, v in pairs(message) do
      if v and v.effects and v.reason and v.stateId and v.reason == FetchGlobalStateReason.ACT_EVE_OF_DECISIVE_BATTLE then
        table.insert(self.globalStatus, v)
      end
    end
  end
end

function SeasonDataManager:GetGlobalStatus()
  return self.globalStatus or {}
end

function SeasonDataManager:HasGlobalStatus(statusId)
  if self.globalStatus then
    for k, v in pairs(self.globalStatus) do
      if v.stateId == statusId then
        return true
      end
    end
  end
end

function SeasonDataManager:SendGetNearAllianceWarTime(allianceId)
  if LuaEntry.Player:IsInAlliance() then
    local aid = allianceId or LuaEntry.Player.allianceId
    self.lastRequestWarTimeAllianceId = aid
    local param = {}
    param.allianceid = aid
    SFSNetwork.SendMessage(MsgDefines.AllianceWartimeNearybyalliance, param)
  end
end

function SeasonDataManager:OnGetNearAllianceWarTimeCallback(payload)
  if payload == nil then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.Season5DeclareCityWarTimeUpdate, payload)
end

function SeasonDataManager:GetSeasonPrepareBGMSoundId()
  if SeasonUtil.IsInSeasonPrepareMode() then
    local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if info ~= nil then
      local config = info:GetConfig()
      if config ~= nil then
        local world_skin = config.world_skin
        if world_skin ~= nil and world_skin ~= "" then
          local skinList = string.split_ss_array(world_skin, "#")
          if 1 <= #skinList then
            local worldSkinConfig = DataCenter.SeasonDataManager:GetGetWorldSkinTemplateById(toInt(skinList[1]))
            if worldSkinConfig ~= nil and worldSkinConfig.home_bgm > 0 then
              return worldSkinConfig.home_bgm
            end
          end
        end
      end
    end
  end
  return nil
end

function SeasonDataManager:GetSeasonMainUIButtonSoundId()
  local config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if config then
    local skin = config:GetSkinTemplate()
    if skin and not string.IsNullOrEmpty(skin.season_main_ui_btn_sound) then
      return skin.season_main_ui_btn_sound
    end
  end
end

function SeasonDataManager:GetSeasonUIButtonSoundId(activityData)
  if activityData and type(activityData.HasLoginSound) == "function" and activityData:HasLoginSound() then
    return
  end
  local config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if config then
    local skin = config:GetSkinTemplate()
    if skin and not string.IsNullOrEmpty(skin.season_activity_ui_btn_sound) then
      return skin.season_activity_ui_btn_sound
    end
  end
end

return SeasonDataManager
