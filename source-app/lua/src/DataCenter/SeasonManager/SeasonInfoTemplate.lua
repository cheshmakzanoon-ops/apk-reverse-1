local SeasonInfoTemplate = BaseClass("SeasonInfoTemplate")
local SeasonWorldColorTemplate = require("DataCenter.SeasonManager.SeasonWorldColorTemplate")

function SeasonInfoTemplate:__init(serverId, info, bigMap)
  if info == nil then
    return
  end
  local activeSeasonConfigId
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.CacheCampIdDict = {}
  self.serverId = serverId
  self.mode = 0
  self.seasonWeek = 1
  self.open = not not info.open
  self.fightWinLv = info.fightWinLv or 0
  self.seasonId = toInt(info.seasonId)
  self.seasonConfigId = info.seasonConfigId
  self.nextSeasonId = info.nextSeasonId
  self.nextSeasonConfigId = info.nextSeasonConfigId
  self.nextSeasonStartTime = info.nextSeasonStartTime
  self.nextSeasonPreviewTime = info.nextSeasonPreviewTime
  self.seasonStartTime = info.seasonStartTime
  self.seasonSettleTime = info.seasonSettleTime
  self.seasonEndTime = info.seasonEndTime
  if self.seasonStartTime and self.seasonEndTime then
    if curTime < self.seasonStartTime then
      self.mode = 1
    elseif curTime < self.seasonEndTime then
      self.mode = 1
      activeSeasonConfigId = info.seasonConfigId
      local elapsedTime = curTime - self.seasonStartTime
      if 0 <= elapsedTime then
        self.seasonWeek = math.floor(elapsedTime / (7 * OneDayTime * 1000)) + 1
      end
    elseif curTime >= self.seasonEndTime then
      self.mode = 2
      activeSeasonConfigId = info.seasonConfigId
      if not (self.nextSeasonPreviewTime and self.nextSeasonStartTime) or curTime < self.nextSeasonPreviewTime then
      elseif curTime > self.nextSeasonPreviewTime and curTime < self.nextSeasonStartTime then
        self.mode = 3
        activeSeasonConfigId = info.nextSeasonConfigId
      elseif curTime >= self.nextSeasonStartTime then
        self.mode = 3
        activeSeasonConfigId = info.nextSeasonConfigId
      end
    end
  elseif self.nextSeasonPreviewTime and self.nextSeasonStartTime then
    if curTime < self.nextSeasonPreviewTime then
      self.mode = 0
    elseif curTime > self.nextSeasonPreviewTime and curTime < self.nextSeasonStartTime then
      self.mode = 3
      activeSeasonConfigId = info.nextSeasonConfigId
    elseif curTime >= self.nextSeasonStartTime then
      self.mode = 3
      activeSeasonConfigId = info.nextSeasonConfigId
    end
  else
    if self.open then
      self.mode = 1
    else
      self.mode = 0
    end
    activeSeasonConfigId = info.seasonConfigId
  end
  if self.mode == 1 and self.seasonStartTime and (self.settleTime == nil or self.settleTime == 0) then
    self.settleTime = self.seasonStartTime + 4838400000
  end
  if activeSeasonConfigId and self.mode and self.mode ~= 0 then
    self.seasonConfig = LocalController:instance():getLine(TableName.LW_Season, activeSeasonConfigId)
  end
  self.isNinePalaces = false
  if self.seasonId >= 5 and self.open ~= true then
    self.isSingleServerMode = info.singleServerMode
  else
    self.isSingleServerMode = false
  end
  self.theNinePalacesData = {}
  self.currentSeasonConfig = LocalController:instance():getLine(TableName.LW_Season, self.seasonConfigId)
  local seasonConfig = self.seasonConfig or self.currentSeasonConfig
  if seasonConfig then
    local serverStr = seasonConfig.server
    self.serverListStr = {}
    self.serverListInt = {}
    if serverStr == nil or serverStr == "" or serverStr == "-1" or serverStr == -1 then
    elseif type(serverStr) == "string" then
      local list = string.split_ss_array(serverStr, ";")
      if list then
        for _, v in ipairs(list) do
          self.serverListStr[v] = v
          self.serverListInt[toInt(v)] = v
        end
      end
      self.serverStr = ";" .. serverStr .. ";"
    end
  end
  local season_type = self:GetServerType()
  if 0 < self.seasonId and season_type == SeasonMapType.NineNation then
    local bigMapData = bigMap or info.bigMap
    if bigMapData == nil and CS.CommonUtils.IsDebug() then
      bigMapData = {}
      if self.serverListInt then
        local index = 1
        for sid, _ in pairs(self.serverListInt) do
          bigMapData[sid] = index
          index = index + 1
        end
      end
    end
    self:InitNinePalacesInfo(bigMapData)
  else
    self.isNinePalaces = false
  end
  if serverId ~= nil and info.campInfo and 0 < #info.campInfo then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local dataCount = 0
    self.campInfo = info.campInfo
    local dataCountCamp1 = 0
    local dataCountCamp2 = 0
    for _, v in ipairs(self.campInfo) do
      if v and v.serverId == mySourceServerId then
        DataCenter.SeasonFactionWarDataManager.myCampId = v.campId
      end
      if v.campId == 1 then
        dataCountCamp1 = dataCountCamp1 + 1
      elseif v.campId == 2 then
        dataCountCamp2 = dataCountCamp2 + 1
      end
      self.CacheCampIdDict[v.serverId] = v.campId
      dataCount = dataCount + 1
    end
    if 0 < dataCount then
      local _bigMap = bigMap or info.bigMap
      if _bigMap and CS.CommonUtils.IsDebug() then
        for _serverId, _index in pairs(_bigMap) do
          if _serverId ~= "centerServerId" and _serverId ~= "centerServerState" then
            local theServerId = tonumber(_serverId)
            if theServerId ~= nil then
              if _index == 5 then
                self.CacheCampIdDict[theServerId] = 3
              elseif self.CacheCampIdDict[theServerId] == nil then
                if dataCountCamp1 < 4 then
                  self.CacheCampIdDict[theServerId] = 1
                  dataCountCamp1 = dataCountCamp1 + 1
                  table.insert(self.campInfo, {campId = 1, serverId = theServerId})
                elseif dataCountCamp2 < 4 then
                  self.CacheCampIdDict[theServerId] = 2
                  dataCountCamp2 = dataCountCamp2 + 1
                  table.insert(self.campInfo, {campId = 2, serverId = theServerId})
                end
              end
            end
          end
        end
      end
      pcall(function()
        local mgr = CS.SeasonDataManager.Instance
        if mgr.GetCampIdByServerId and mgr.UpdateServerCampData and mgr:GetCampIdByServerId(serverId) == 0 then
          mgr:UpdateServerCampData(info.campInfo)
        end
      end)
    end
  end
  pcall(function()
    local mapConfigName = self:GetMapConfigName()
    if mapConfigName then
      Setting:SetPrivateString("MapTableName" .. serverId, mapConfigName)
    end
  end)
end

function SeasonInfoTemplate:__delete()
  self.seasonConfig = nil
  self.currentSeasonConfig = nil
  self.mode = 0
  self.seasonWeek = 1
  self.seasonDamageConfig = nil
  self.fightWinLv = 0
  self.seasonId = 0
  self.seasonConfigId = 1
  self.centerServerId = nil
  self.centerServerState = nil
  self.centerServerParams = nil
end

function SeasonInfoTemplate:GetCampIdByServerId(serverId)
  local campId = self.CacheCampIdDict[serverId]
  if campId == nil and self.campInfo and self:IsInBattleServerGroupInt(serverId) then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    for _, v in ipairs(self.campInfo) do
      if v and v.serverId == mySourceServerId then
        DataCenter.SeasonFactionWarDataManager.myCampId = v.campId
      end
      self.CacheCampIdDict[v.serverId] = v.campId
    end
  end
  return campId
end

function SeasonInfoTemplate:GetCampIdByMapIndex(bigMapIndex)
  return self.CacheCampIdDict[self:GetNinePalacesServer(bigMapIndex)]
end

function SeasonInfoTemplate:ClientInReady()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.seasonStartTime and self.seasonEndTime and curTime >= self.seasonStartTime and curTime < self.seasonEndTime then
    return true
  end
  if self.nextSeasonStartTime and curTime >= self.nextSeasonStartTime then
    return true
  end
  return false
end

function SeasonInfoTemplate:GetMainBannerPath()
  if self:InPreviewMode() and self.seasonConfig then
    return self.seasonConfig.main_banner
  end
  if self.currentSeasonConfig then
    return self.currentSeasonConfig.main_banner
  end
  return nil
end

function SeasonInfoTemplate:GetMainBgPath()
  if self:InPreviewMode() and self.seasonConfig then
    return self.seasonConfig.main_pic
  end
  if self.currentSeasonConfig then
    return self.currentSeasonConfig.main_pic
  end
  return nil
end

function SeasonInfoTemplate:GetServerSubdivisionType(includePreview)
  local nType1 = 0
  local nType2 = 0
  if includePreview and self:InPreviewMode() and self.seasonConfig then
    nType1 = self.seasonConfig.type
    nType2 = self.seasonConfig.type1 or self.seasonConfig.type2 or 0
  elseif self.currentSeasonConfig then
    nType1 = self.currentSeasonConfig.type
    nType2 = self.currentSeasonConfig.type1 or self.currentSeasonConfig.type2 or 0
  end
  return SeasonUtil.TypeAndType1ToSubdivisionType(nType1, nType2)
end

function SeasonInfoTemplate:GetServerType2(includePreview)
  if includePreview and self:InPreviewMode() and self.seasonConfig then
    return self.seasonConfig.type1 or self.seasonConfig.type2 or 0
  end
  if self.currentSeasonConfig then
    return self.currentSeasonConfig.type1 or self.currentSeasonConfig.type2 or 0
  end
  return 0
end

function SeasonInfoTemplate:GetServerType(includePreview)
  if includePreview and self:InPreviewMode() and self.seasonConfig then
    return self.seasonConfig.type
  end
  if self.currentSeasonConfig then
    return self.currentSeasonConfig.type
  end
  return SeasonMapType.Nothing
end

function SeasonInfoTemplate:GetSeasonVersion(includePreview)
  if includePreview and self:InPreviewMode() and self.seasonConfig then
    return toInt(self.seasonConfig.version)
  end
  if self.currentSeasonConfig then
    return toInt(self.currentSeasonConfig.version)
  end
  return 0
end

function SeasonInfoTemplate:GetSeasonTypeAndVersion(includePreview)
  if includePreview == true and self:InPreviewMode() and self.seasonConfig then
    return self.seasonConfig.type, toInt(self.seasonConfig.version)
  end
  if self.currentSeasonConfig then
    return self.currentSeasonConfig.type, toInt(self.currentSeasonConfig.version)
  end
  return SeasonMapType.Nothing, 0
end

function SeasonInfoTemplate:ServerInReady()
  return self.open == true
end

function SeasonInfoTemplate:InPreviewMode()
  return self.mode == 3
end

function SeasonInfoTemplate:InNormalMode()
  if self.mode == 1 and self.seasonEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.seasonEndTime then
      return true
    end
  end
  return false
end

function SeasonInfoTemplate:InHaltMode()
  return self.mode == 2 or self.mode == 3
end

function SeasonInfoTemplate:InTruceMode()
  return self.mode == 2
end

function SeasonInfoTemplate:GetWorldCityTableName()
  local config = self.currentSeasonConfig
  if config == nil then
    config = self.seasonConfig
  end
  if self.seasonId == 5 and DataCenter.LandlordMgr:GetCenterServerId() == self.serverId and DataCenter.LandlordMgr:IsInNewCenterMapPeriod() then
    return DataCenter.LandlordMgr:GetCityTemplateTableName()
  end
  if config then
    return string.TryGetValue(config.city, "lw_worldcity")
  end
  return "lw_worldcity"
end

function SeasonInfoTemplate:GetWorldChessColorSettingList()
  if self.theWorldChessColorList ~= nil then
    return self.theWorldChessColorList
  end
  local skinCfg = self:GetSkinTemplate()
  local theWorldChessColorList = {}
  if skinCfg then
    local world_chess_group = toInt(skinCfg.world_chess_color)
    if 0 < world_chess_group then
      LocalController:instance():visitTable(TableName.World_Chess_Color, function(id, lineData)
        if toInt(lineData.group) == world_chess_group then
          local chess_type_list = string.split_ii_array(tostring(lineData.chess_type), "|")
          local chess_name_list = string.split_ss_array(tostring(lineData.color_help), "|")
          for index, chess_type in ipairs(chess_type_list) do
            local chess_name = chess_name_list[index]
            table.insert(theWorldChessColorList, SeasonWorldColorTemplate.New(id, world_chess_group, chess_type, chess_name, lineData))
          end
        end
      end)
    end
  end
  table.sort(theWorldChessColorList, function(a, b)
    return a.color_weight > b.color_weight
  end)
  self.theWorldChessColorList = theWorldChessColorList
  return theWorldChessColorList
end

function SeasonInfoTemplate:GetWorldChessColorSetting(serverId, allianceId, uid, currentServerId)
  local theWorldChessColorList = self:GetWorldChessColorSettingList()
  if theWorldChessColorList then
    local isMyFriendAlly = DataCenter.SeasonAllyFriendManager:IsMyFriendAlly(allianceId)
    if isMyFriendAlly then
      for _, cfg in ipairs(theWorldChessColorList) do
        if cfg ~= nil and cfg.chess_type == 8 then
          return cfg
        end
      end
    end
    for _, cfg in ipairs(theWorldChessColorList) do
      if cfg ~= nil and cfg:Match(serverId, allianceId, uid, currentServerId) then
        return cfg
      end
    end
  end
  return nil
end

function SeasonInfoTemplate:GetSkinTemplate()
  local mapIndex = self:GetNinePalacesIndex(self.serverId)
  return self:GetWorldSkinTemplate(mapIndex)
end

function SeasonInfoTemplate:GetSkin()
  local config = self.currentSeasonConfig or self.seasonConfig
  if config then
    local world_skin = config.world_skin
    if world_skin ~= nil and world_skin ~= "" then
      local skinCfg = self:GetSkinTemplate()
      local skin = SeasonWorldSkinUtil.GetSkin(skinCfg.id, skinCfg)
      if skin then
        skin.mapType = config.type
        if skin.mapType2 ~= nil then
          skin.mapType2 = toInt(config.type1 or config.type2)
        end
        skin.world_city_table_name = string.TryGetValue(config.city, "lw_worldcity")
        skin.world_city_color = string.TryGetValue(config.worldcity_color, "worldcity_color")
        skin.splash_fill_mode = config.worldcity_color_icon
        if skin.seasonNext ~= nil and self.nextSeasonId ~= nil and self.seasonConfig ~= nil then
          skin.seasonNext = toInt(self.seasonConfig.type)
          if skin.seasonNextType2 ~= nil then
            skin.seasonNextType2 = toInt(self.seasonConfig.type1 or self.seasonConfig.type2)
          end
        end
        return skin
      end
    end
  end
  return nil
end

function SeasonInfoTemplate:ActiveSkin()
  self:SyncLandlordCenterServerForView()
  local skin = self:GetSkin()
  if skin then
    self:ActiveNinePalacesData()
    self:UpdateUISkin()
    DataCenter.SeasonDataManager:SetLoginServerSkinMeta(skin)
    return true
  end
  return false
end

function SeasonInfoTemplate:ActiveViewModeSkin()
  self:SyncLandlordCenterServerForView()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if self.serverId then
    if self.isNinePalaces and self.theNinePalacesData ~= nil then
      pcall(function()
        local thePresident = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
        if thePresident == nil and self.theNinePalacesData ~= nil then
          local serverList = table.values(self.theNinePalacesData)
          if serverList and 0 < #serverList then
            SFSNetwork.SendMessage(MsgDefines.GetCrossServerKingInfo, table.concat(serverList, ","))
          end
        end
      end)
    end
    if self:GetServerType() == SeasonMapType.NineNation and self:IsInBattleServerGroupInt(loginServerId) and not self.isSingleServerMode then
      self:ActiveNinePalacesData()
      DataCenter.SeasonDataManager:SetViewServerSkinMeta(nil)
      return
    end
  end
  if self.serverId == loginServerId then
    self:ActiveNinePalacesData()
    DataCenter.SeasonDataManager:SetViewServerSkinMeta(nil)
  else
    local skin = self:GetSkin()
    if skin then
      self:ActiveNinePalacesData()
      DataCenter.SeasonDataManager:SetViewServerSkinMeta(skin)
    end
  end
end

function SeasonInfoTemplate:ActiveNinePalacesData()
  local mgr = CS.SeasonDataManager.Instance
  if self.isNinePalaces and self.theNinePalacesData then
    mgr:UpdateNinePalacesData(self.theNinePalacesData)
    if self.worldSkinTemplate then
      local config = self.currentSeasonConfig or self.seasonConfig
      for mapIndex, skinCfg in ipairs(self.worldSkinTemplate) do
        if skinCfg then
          local serverId = self.theNinePalacesData[mapIndex] or 0
          local skin = SeasonWorldSkinUtil.GetSkin(skinCfg.id, skinCfg)
          if skin then
            skin.mapType = config.type
            if skin.mapType2 ~= nil then
              skin.mapType2 = toInt(config.type1 or config.type2)
            end
            skin.world_city_table_name = string.TryGetValue(config.city, "lw_worldcity")
            skin.world_city_color = string.TryGetValue(config.worldcity_color, "worldcity_color")
            skin.splash_fill_mode = config.worldcity_color_icon
            if skin.seasonNext ~= nil and self.nextSeasonId ~= nil and self.seasonConfig ~= nil then
              skin.seasonNext = toInt(self.seasonConfig.type)
              if skin.seasonNextType2 ~= nil then
                skin.seasonNextType2 = toInt(self.seasonConfig.type1 or self.seasonConfig.type2)
              end
            end
            mgr:UpdateNinePalacesSkin(serverId, mapIndex, skin)
          end
        end
      end
    end
  else
    mgr:CleanNinePalacesData()
  end
end

function SeasonInfoTemplate:GetMapConfigName()
  local config = self.currentSeasonConfig
  if config == nil then
    config = self.seasonConfig
  end
  if config and config.city then
    return string.TryGetValue(config.city, "lw_worldcity")
  end
  return "lw_worldcity"
end

function SeasonInfoTemplate:GetConfig()
  return self.seasonConfig
end

function SeasonInfoTemplate:GetCurrentSeasonConfig()
  return self.currentSeasonConfig
end

function SeasonInfoTemplate:UpdateUISkin(skinId)
  local mgr = CS.SeasonDataManager.Instance
  if mgr then
    local skinCfg = self:GetSkinTemplate()
    local bgDefault = "Assets/Main/TextureEx/UICommonWindowBg/cfm_tongyon_quanping_di_1.png"
    local topDefault = ""
    local backPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_fanhui.png"
    local isNineNationRainforest = self.seasonId == 6 and self.currentSeasonConfig ~= nil and (self.currentSeasonConfig.type1 == 1 or self.currentSeasonConfig.type2 == 1)
    if self.nextSeasonId ~= nil then
      isNineNationRainforest = self.nextSeasonId == 6 and self.seasonConfig ~= nil and (self.seasonConfig.type1 == 1 or self.seasonConfig.type2 == 1)
    end
    if self.seasonId >= 4 then
      topDefault = "Assets/Main/TextureEx/SeasonCommon/zxl_biaoti.png"
      backPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_fanhui.png"
    end
    if skinCfg ~= nil then
      local season_ui_top_bg = skinCfg.season_ui_top_bg
      local season_ui_bg_color = skinCfg.season_ui_bg_color
      if isNineNationRainforest then
        season_ui_top_bg = "Assets/Main/SeasonRes/S6/Textures/Activity/ljq_s6_biaoti.png"
        season_ui_bg_color = "#165A2B"
      end
      if string.IsNullOrEmpty(season_ui_top_bg) and string.IsNullOrEmpty(season_ui_bg_color) then
        mgr:UpdateUISkin(Color.white, bgDefault, topDefault, backPath)
        return
      else
        if season_ui_bg_color ~= nil and season_ui_bg_color ~= "" then
          local clr = Color.FromHex(season_ui_bg_color)
          mgr:UpdateUISkin(clr, "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg_white.png", season_ui_top_bg, backPath)
        else
          mgr:UpdateUISkin(Color.white, bgDefault, season_ui_top_bg, backPath)
        end
        return
      end
    end
    mgr:UpdateUISkin(Color.white, bgDefault, topDefault, backPath)
  end
end

function SeasonInfoTemplate:GetServerListInt(checkPreview)
  local theSeasonConfig = self.currentSeasonConfig
  theSeasonConfig = checkPreview == true and self.seasonConfig or theSeasonConfig
  if theSeasonConfig then
    local serverStr = theSeasonConfig.server
    if serverStr == nil or serverStr == "" or serverStr == "-1" or serverStr == -1 then
    elseif type(serverStr) == "string" then
      local serverListInt = {}
      local list = string.split_ss_array(serverStr, ";")
      if list then
        for _, v in ipairs(list) do
          table.insert(serverListInt, toInt(v))
        end
      end
      return serverListInt
    end
  end
  if self.serverListInt then
    return table.keys(self.serverListInt)
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  return {loginServerId}
end

function SeasonInfoTemplate:IsInSameChatGroup(serverId)
  local serverIdInt = toInt(serverId)
  if self.serverListInt and self.nextSeasonId == nil then
    return self.serverListInt[serverIdInt] ~= nil
  end
  local theSeasonConfig = self.seasonConfig or self.currentSeasonConfig
  if theSeasonConfig then
    local serverStr = theSeasonConfig.server
    if serverStr == nil or serverStr == "" or serverStr == "-1" or serverStr == -1 then
    elseif type(serverStr) == "string" then
      local serverIdStr = tostring(serverId)
      local list = string.split_ss_array(serverStr, ";")
      if list then
        for _, v in ipairs(list) do
          if v == serverIdStr then
            return true
          end
        end
      end
    end
  end
  return false
end

function SeasonInfoTemplate:IsInBattleServerGroup(serverId)
  return self:IsInBattleServerGroupInt(toInt(serverId))
end

function SeasonInfoTemplate:IsInBattleServerGroupInt(serverIdInt)
  if self.serverId ~= serverIdInt and self.isSingleServerMode then
    return false
  end
  return self:IsInBattleServerGroupInt_IgnoreSplitServer(serverIdInt)
end

function SeasonInfoTemplate:IsInBattleServerGroupInt_IgnoreSplitServer(serverIdInt)
  if serverIdInt then
    if self.isNinePalaces and self.theNinePalacesData then
      for k, v in ipairs(self.theNinePalacesData) do
        if v == serverIdInt then
          return true
        end
      end
      return false
    end
    if self.serverListInt and self.nextSeasonId == nil then
      return self.serverListInt[serverIdInt] ~= nil
    end
    local theSeasonConfig = self.currentSeasonConfig
    if self.nextSeasonId ~= nil then
      theSeasonConfig = self.seasonConfig
    end
    if theSeasonConfig then
      local serverStr = theSeasonConfig.server
      if serverStr == nil or serverStr == "" or serverStr == "-1" or serverStr == -1 then
      elseif type(serverStr) == "string" then
        local list = string.split_ss_array(serverStr, ";")
        if list then
          for _, v in ipairs(list) do
            if toInt(v) == serverIdInt then
              return true
            end
          end
        end
      end
    end
  end
  return false
end

function SeasonInfoTemplate:GetServerGroup()
  return self.serverListInt
end

function SeasonInfoTemplate:GetSeasonStartTime()
  return self.seasonStartTime or self.nextSeasonStartTime or MANY_YEARS_LATER
end

function SeasonInfoTemplate:GetSeasonSettleTime()
  return self.seasonSettleTime or 0
end

function SeasonInfoTemplate:InSettleTime()
  if self.seasonSettleTime and self.seasonEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.seasonSettleTime and curTime < self.seasonEndTime then
      return true
    end
  end
  return false
end

function SeasonInfoTemplate:GetSeasonEndTime()
  return self.seasonEndTime or 0
end

function SeasonInfoTemplate:GetNextSeasonStartTime()
  return self.nextSeasonStartTime or 0
end

function SeasonInfoTemplate:InIdleTime()
  if self.seasonEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.seasonEndTime then
      return true
    end
  end
  return false
end

function SeasonInfoTemplate:GetSeasonDurationDay()
  if self.seasonStartTime == nil or self.seasonStartTime == 0 then
    return 0
  end
  local zeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(self.seasonStartTime // 1000) * 1000
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local duration = math.max(curTime - zeroTime, 0)
  return duration // (1000 * OneDayTime)
end

function SeasonInfoTemplate:GetSeasonWeek()
  if self.mode == 1 then
    return self:GetSeasonWeekFromStart()
  elseif self.mode == 2 then
    local elapsedTime = self.seasonEndTime - self.seasonStartTime
    if 0 <= elapsedTime then
      return math.floor(elapsedTime / (7 * OneDayTime * 1000)) + 1
    end
  else
    return 1
  end
end

function SeasonInfoTemplate:GetSeasonWeekFromStart(time)
  if self.seasonStartTime ~= nil and self.seasonStartTime ~= 0 then
    local curTime = time or UITimeManager:GetInstance():GetServerTime()
    local elapsedTime = curTime - self.seasonStartTime
    if 0 <= elapsedTime then
      return math.floor(elapsedTime / (7 * OneDayTime * 1000)) + 1
    end
  end
  return 1
end

function SeasonInfoTemplate:GetSeasonIndex()
  return toInt(self.seasonId)
end

function SeasonInfoTemplate:GetSeasonId(includePreview)
  if includePreview and self:InPreviewMode() and self.seasonConfig then
    return self.seasonConfig.season
  end
  if self.currentSeasonConfig then
    return self.currentSeasonConfig.season
  end
  return 0
end

function SeasonInfoTemplate:Description()
  local time = UITimeManager:GetInstance()
  local modeConvert = {
    [0] = "0:\230\151\160\231\138\182\230\128\129",
    [1] = "1:\232\191\155\232\161\140\228\184\173",
    [2] = "2:\228\188\145\232\181\155\230\156\159",
    [3] = "3:\233\162\132\231\131\173\228\184\173"
  }
  local seasonTypeConvert = {
    [SeasonMapType.Nothing] = "Nothing(0)",
    [SeasonMapType.Desert] = "Desert(1)",
    [SeasonMapType.CityStronghold] = "CityStronghold(2)",
    [SeasonMapType.Snow] = "Snow(3)",
    [SeasonMapType.Mummy] = "Mummy(4)",
    [SeasonMapType.Darkness] = "Darkness(5)",
    [SeasonMapType.NineNation] = "NineNation(6)",
    [SeasonMapType.NineNationRainforest] = "NineNationRainforest(60001)"
  }
  local sb = StringBuilder.New()
  sb:AppendLine(string.format("ServerId:%s", self.serverId))
  sb:AppendLine(string.format("\232\181\155\229\173\163id:%s", self.seasonId))
  sb:AppendLine(string.format("\232\181\155\229\173\163\231\138\182\230\128\129(mode):%s", modeConvert[self.mode] or self.mode))
  sb:AppendLine(string.format("\232\181\155\229\173\163\233\133\141\231\189\174id:%s", self.seasonConfigId))
  local serverType = self:GetServerType(false)
  local serverSubdivisionType = self:GetServerSubdivisionType(false)
  sb:AppendLine(string.format("\232\181\155\229\173\163\231\177\187\229\158\139(GetServerType):%s (%s)", serverType, seasonTypeConvert[serverType] or "\230\156\170\231\159\165"))
  sb:AppendLine(string.format("\232\181\155\229\173\163\231\187\134\229\136\134\231\177\187\229\158\139(GetServerSubdivisionType):%s (%s)", serverSubdivisionType, seasonTypeConvert[serverSubdivisionType] or "\230\156\170\231\159\165"))
  if self.currentSeasonConfig then
    sb:AppendLine(string.format("\232\181\155\229\173\163\231\187\132:%s", self.currentSeasonConfig.server or "???"))
    sb:AppendLine(string.format("\232\181\155\229\173\163\233\133\141\231\189\174 type:%s, type1:%s, type2:%s", self.currentSeasonConfig.type or "?", self.currentSeasonConfig.type1 or "?", self.currentSeasonConfig.type2 or "?"))
  end
  sb:AppendLine(string.format("\232\181\155\229\173\163\230\151\182\233\151\180:[\229\188\128\229\167\139]%s", time:TimeStampToTimeForServer(self.seasonStartTime or 0)))
  sb:AppendLine(string.format("\232\181\155\229\173\163\230\151\182\233\151\180:[\231\187\147\231\174\151]%s", time:TimeStampToTimeForServer(self.seasonSettleTime or 0)))
  sb:AppendLine(string.format("\232\181\155\229\173\163\230\151\182\233\151\180:[\231\187\147\230\157\159]%s", time:TimeStampToTimeForServer(self.seasonEndTime or 0)))
  if self.theNinePalacesData then
    sb:AppendLine("\228\185\157\229\174\171\230\160\188\229\136\134\231\187\132\228\191\161\230\129\175:" .. table.table2string(self.theNinePalacesData))
  end
  if self.campInfo and 0 < #self.campInfo then
    sb:AppendLine(string.format("\233\152\181\232\144\165\229\136\134\231\187\132\228\191\161\230\129\175(campInfo): \229\133\177%d\230\157\161", #self.campInfo))
    for _, v in ipairs(self.campInfo) do
      sb:AppendLine(string.format("  serverId:%s -> campId:%s", v.serverId, v.campId))
    end
  else
    sb:AppendLine("\233\152\181\232\144\165\229\136\134\231\187\132\228\191\161\230\129\175(campInfo): \230\151\160\230\149\176\230\141\174")
  end
  sb:AppendLine("----------")
  if self.nextSeasonId then
    sb:AppendLine(string.format("\228\184\139\228\184\170\232\181\155\229\173\163id:%s", self.nextSeasonId))
    sb:AppendLine(string.format("\228\184\139\228\184\170\232\181\155\229\173\163\233\133\141\231\189\174id:%s", self.nextSeasonConfigId))
    sb:AppendLine(string.format("\228\184\139\228\184\170\232\181\155\229\173\163\230\151\182\233\151\180:[\229\188\128\229\167\139]%s", time:TimeStampToTimeForServer(self.nextSeasonStartTime or 0)))
    sb:AppendLine(string.format("\228\184\139\228\184\170\232\181\155\229\173\163\230\151\182\233\151\180:[\233\162\132\232\167\136]%s", time:TimeStampToTimeForServer(self.nextSeasonPreviewTime or 0)))
  else
    sb:AppendLine("\230\154\130\230\151\160\228\184\139\228\184\170\232\181\155\229\173\163\231\154\132\228\191\161\230\129\175")
  end
  return sb:ToString()
end

function SeasonInfoTemplate:GetWorldSkinTemplate(mapIndex)
  if not self.worldSkinTemplate then
    local config = self.currentSeasonConfig or self.seasonConfig
    self.worldSkinTemplate = {}
    if config then
      local world_skin = config.world_skin
      if world_skin ~= nil and world_skin ~= "" then
        local skinList = string.split_ss_array(world_skin, "#")
        if #skinList == 1 then
          table.insert(self.worldSkinTemplate, DataCenter.SeasonDataManager:GetGetWorldSkinTemplateById(toInt(skinList[1])))
        elseif 1 < #skinList then
          for k, v in ipairs(skinList) do
            table.insert(self.worldSkinTemplate, DataCenter.SeasonDataManager:GetGetWorldSkinTemplateById(toInt(v)))
          end
        end
      end
    end
  end
  return self.worldSkinTemplate[mapIndex or 1]
end

function SeasonInfoTemplate:InitNinePalacesInfo(bigMap)
  self.theNinePalacesData = {}
  if bigMap then
    if self.serverListStr == nil then
      self.serverListStr = {}
    end
    if self.serverListInt == nil then
      self.serverListInt = {}
    end
    local count = 0
    for serverId, index in pairs(bigMap) do
      if serverId ~= 0 and serverId ~= "0" and serverId ~= "centerServerId" and serverId ~= "centerServerState" and tonumber(serverId) ~= nil then
        local strSer = tostring(serverId)
        local intSer = toInt(serverId)
        self.theNinePalacesData[index] = intSer
        self.serverListStr[strSer] = strSer
        self.serverListInt[intSer] = strSer
        count = count + 1
      end
    end
    if 1 < count and count ~= 9 and CS.CommonUtils.IsDebug() then
      for i = 1, 9 do
        if self.theNinePalacesData[i] == nil then
          local intSer = i + 7000
          local strSer = tostring(intSer)
          self.theNinePalacesData[i] = i + 7000
          self.serverListStr[strSer] = strSer
          self.serverListInt[intSer] = strSer
          count = count + 1
        end
      end
      Logger.Log(table.table2string(self.theNinePalacesData))
    end
    self.isNinePalaces = count == 9
    self:InitNinePalacesCenterServer(bigMap.centerServerId, bigMap.centerServerState, bigMap.params)
  end
end

function SeasonInfoTemplate:InitNinePalacesCenterServer(centerServerId, centerServerState, params)
  self.centerServerId = centerServerId or 0
  self.centerServerState = centerServerState or 0
  if params then
    self.centerServerParams = params
  end
  local isNewCenterMap = self.centerServerState == LLConst.Season5CenterServerCityState.LandlordCity
  DataCenter.LandlordMgr:SetIsNewCenterMapPeriod(isNewCenterMap, self.centerServerId, false)
end

function SeasonInfoTemplate:SyncLandlordCenterServerForView()
  local seasonId = self.seasonId or 0
  if seasonId < 5 then
    return
  end
  local isNewCenterMap = self.centerServerState == LLConst.Season5CenterServerCityState.LandlordCity
  DataCenter.LandlordMgr:SetIsNewCenterMapPeriod(isNewCenterMap, self.centerServerId, false)
end

function SeasonInfoTemplate:GetNinePalacesIndexByWorldPos(worldPos)
  if self.isNinePalaces and (worldPos.x >= 2000 or 2000 <= worldPos.z) then
    if worldPos.z >= 4000 then
      if worldPos.x >= 4000 then
        return 9
      end
      if worldPos.x >= 2000 then
        return 8
      end
      return 7
    end
    if 2000 <= worldPos.z then
      if worldPos.x >= 4000 then
        return 6
      end
      if worldPos.x >= 2000 then
        return 5
      end
      return 4
    end
    if worldPos.x >= 4000 then
      return 3
    end
    if worldPos.x >= 2000 then
      return 2
    end
    return 1
  end
  return 1
end

function SeasonInfoTemplate:GetNinePalacesServer(mapIndex)
  return self.theNinePalacesData[toInt(mapIndex)] or 0
end

function SeasonInfoTemplate:GetNinePalacesIndex(serverId)
  for k, v in ipairs(self.theNinePalacesData) do
    if v == serverId then
      return k
    end
  end
  return 1
end

function SeasonInfoTemplate:IsInNinePalacesMode(serverId)
  for k, v in ipairs(self.theNinePalacesData) do
    if v == serverId then
      return true
    end
  end
  return false
end

function SeasonInfoTemplate:GetSeasonGuideId()
  local seasonConfig
  if self.mode == 1 then
    seasonConfig = self.currentSeasonConfig
  else
    seasonConfig = self.seasonConfig
  end
  if seasonConfig and seasonConfig.season_guide_config then
    return toInt(seasonConfig.season_guide_config)
  end
  return 0
end

function SeasonInfoTemplate:GetServerIdFromWorldPos(worldPos)
  local x = Mathf.Clamp(worldPos.x / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
  local y = Mathf.Clamp(worldPos.z / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
  return self:GetNinePalacesServer(3 * y + x + 1)
end

function SeasonInfoTemplate:CanMoveCityTo(mapIndex)
  local config = self.currentSeasonConfig
  if config then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local elapsedTime = curTime - self.seasonStartTime
    if 0 <= elapsedTime then
      local weekIndex = math.floor(elapsedTime / (7 * OneDayTime * 1000)) + 1
      if 1 <= weekIndex and weekIndex <= 8 then
        if mapIndex == 5 then
          local is_center_cross = string.split_ii_array(config.is_center_cross or "", "|")
          if is_center_cross[weekIndex] == 1 then
            return true
          else
            for k, v in ipairs(is_center_cross) do
              if v == 1 then
                return false, self.seasonStartTime + (k - 1) * (7 * OneDayTime * 1000)
              end
            end
          end
        else
          local is_server_cross = string.split_ii_array(config.is_server_cross or "", "|")
          if is_server_cross[weekIndex] == 1 then
            return true
          else
            for k, v in ipairs(is_server_cross) do
              if v == 1 then
                return false, self.seasonStartTime + (k - 1) * (7 * OneDayTime * 1000)
              end
            end
          end
        end
      end
      return false, 0
    end
  end
  return false, 0
end

function SeasonInfoTemplate:CanAllianceMakeFriends()
  local cfg = self.currentSeasonConfig
  if cfg then
    return cfg.is_ally == 1 or cfg.is_ally == "1"
  end
  return false
end

function SeasonInfoTemplate:GetPackageId(includePreview)
  if includePreview and self:InPreviewMode() and self.seasonConfig then
    return toInt(self.seasonConfig.package)
  end
  if self.currentSeasonConfig then
    return toInt(self.currentSeasonConfig.package)
  end
  return 0
end

return SeasonInfoTemplate
