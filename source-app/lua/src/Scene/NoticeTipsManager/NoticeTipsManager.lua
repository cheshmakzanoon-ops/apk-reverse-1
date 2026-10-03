local NoticeTipsManager = BaseClass("NoticeTipsManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.allPushTip = {}
  
  function self.wait_timer_func(temp)
    self:WaitTimeRef(temp)
  end
  
  self.isSelf = false
end

local function __delete(self)
  self.allPushTip = nil
  self.wait_timer_func = nil
  self.isSelf = nil
  self:DeleteTime()
end

local function NetPush(self, message)
  if message.id ~= nil then
    local config = {}
    local id = message.id
    config.id = id
    config.type = GetTableData(TableName.Announcement, id, "type")
    config.base = GetTableData(TableName.Announcement, id, "base")
    config.content = GetTableData(TableName.Announcement, id, "content")
    config.para1 = GetTableData(TableName.Announcement, id, "para1")
    local priority = GetTableData(TableName.Announcement, id, "priority")
    if priority == nil or priority == "" then
      priority = "0"
    end
    config.priority = tonumber(priority)
    self:OnUpdateNotice(message, config)
  end
end

local function OnUpdateNotice(self, message, config)
  local baseLevelArray = string.split(config.base, ";")
  if table.count(baseLevelArray) == 2 then
    local minLevel = tonumber(baseLevelArray[1])
    local maxLevel = tonumber(baseLevelArray[2])
    if minLevel > DataCenter.BuildManager.MainLv or maxLevel < DataCenter.BuildManager.MainLv then
      return
    end
  end
  if message.params ~= nil then
    local cfgId = toInt(config.id)
    local params = message.params
    local noticeType = tonumber(config.type)
    if noticeType == NoticeType.DetectCaveExplorationFinish then
      local strUser = UIUtil.FormatServerAllianceName(params.serverId, params.abbr, params.name)
      local str = Localization:GetString(config.content, strUser)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.StoveCenterBattleFinish then
      local robValue = string.GetFormattedStr2(toInt(params.robValue))
      local str = Localization:GetString(config.content, params.enemy, params.friend, robValue)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.AresMissile and params.userObj and params.pointId then
      local meta = DataCenter.AllianceGovernmentSkillManager:GetTemplatesByAnnounceId(cfgId)
      if not meta then
        return
      end
      local strUser = UIUtil.FormatServerAllianceName(params.userObj.serverId, params.userObj.abbr, params.userObj.name)
      local tilePos = SceneUtils.IndexToTilePos(params.pointId, ForceChangeScene.World)
      local strPos = UIUtil.FormatServerPosition(nil, tilePos.x, tilePos.y)
      local strMsg
      if cfgId == meta.announce_success then
        strMsg = Localization:GetString(config.content, strUser, strPos, params.num or 1)
      elseif cfgId == meta.announce_fail then
        local interruptUser = UIUtil.FormatServerAllianceName(params.interruptUser.serverId, params.interruptUser.abbr, params.interruptUser.name)
        strMsg = Localization:GetString(config.content, interruptUser, strUser, strPos)
      elseif cfgId == meta.announce_prepare then
        strMsg = Localization:GetString(config.content, strUser, strPos)
      end
      if strMsg ~= nil and strMsg ~= "" then
        self:ShowNotice(strMsg, config.priority, noticeType)
      end
    elseif noticeType == NoticeType.KingdomPositionAppoint then
      local kingName = params.kingName
      local targetName = params.targetName
      local positionId = params.positionId
      local kingPositionId = params.kingPositionId
      local configData = DataCenter.GovernmentTemplateManager:GetTemplate(positionId)
      if configData ~= nil then
        local king = ""
        if kingPositionId then
          local cfgKing = DataCenter.GovernmentTemplateManager:GetTemplate(kingPositionId)
          if cfgKing and cfgKing.name then
            king = Localization:GetString(cfgKing.name)
          end
        end
        local str = Localization:GetString(config.content, kingName, targetName, Localization:GetString(configData.name), king)
        self:ShowNotice(str, config.priority, noticeType)
      end
    elseif noticeType == NoticeType.CrossServer then
      local serverId = params.serverId
      local rank = params.rank
      local name = params.nameIsKey and Localization:GetString(params.name) or UIUtil.FormatAllianceAndName(params.alAbbr, params.name)
      local power = params.power
      local str = Localization:GetString(config.content, rank, power, name, serverId)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.DiscoverHugeSandWorm then
      local str = Localization:GetString(config.content, params.playerName, params.level)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.MultiKill then
      local abbr = params.allianceInfo and params.allianceInfo.allianceAbbr
      local name = UIUtil.FormatServerAllianceName(params.serverId, abbr, params.name, params.uid)
      local str = Localization:GetString(config.content, name, params.killNum)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.FirstOccupyCity then
      if params.cityId ~= nil and params.cityId ~= nil then
        local cityId = params.cityId
        local alAbbr = params.alAbbr
        local allianceId = params.alId
        local zoneId = tostring(cityId)
        local name = params.cityName
        if name == nil or name == "" then
          local nameKey = GetTableData(TableName.WorldCity, zoneId, "name")
          name = Localization:GetString(nameKey)
        end
        local cityLv = GetTableData(TableName.WorldCity, zoneId, "level")
        local levelStr = "Lv." .. tostring(cityLv)
        local str = Localization:GetString(tostring(config.content), alAbbr, levelStr, name)
        self:CheckShowAllianceCityTip(str, allianceId, function()
          EventManager:GetInstance():Broadcast(EventId.AllianceCityFirstOccupy, {cityId = cityId, aid = allianceId})
        end)
        self:ShowNotice(str, config.priority, noticeType)
      end
    elseif noticeType == NoticeType.OccupyEmptyCity then
      if params.cityId ~= nil and params.cityId ~= nil then
        local cityId = params.cityId
        local alAbbr = params.alAbbr
        local allianceId = params.alId
        local zoneId = tostring(cityId)
        local name = params.cityName
        if name == nil or name == "" then
          local nameKey = GetTableData(TableName.WorldCity, zoneId, "name")
          name = Localization:GetString(nameKey)
        end
        local cityLv = GetTableData(TableName.WorldCity, zoneId, "level")
        local levelStr = "Lv." .. tostring(cityLv)
        local str = Localization:GetString(tostring(config.content), alAbbr, levelStr, name)
        self:CheckShowAllianceCityTip(str, allianceId)
        self:ShowNotice(str, config.priority, noticeType)
      end
    elseif noticeType == NoticeType.ChangeOccupyCity then
      if params.cityId ~= nil and params.cityId ~= nil then
        local cityId = params.cityId
        local alAbbr = params.alAbbr
        local oldAbbr = params.oldAlAbbr
        local allianceId = params.alId
        local oldAllianceId = params.oldAlId
        local zoneId = tostring(cityId)
        local name = params.cityName
        if name == nil or name == "" then
          local nameKey = GetTableData(TableName.WorldCity, zoneId, "name")
          name = Localization:GetString(nameKey)
        end
        local cityLv = GetTableData(TableName.WorldCity, zoneId, "level")
        local levelStr = "Lv." .. tostring(cityLv)
        local str = Localization:GetString(config.content, alAbbr, oldAbbr, levelStr, name)
        self:CheckShowAllianceCityTip(str, allianceId, oldAllianceId)
        self:ShowNotice(str, config.priority, noticeType)
      end
    elseif noticeType == NoticeType.DestroyCampCity then
      local cityInfo = params.cityInfo
      local attackerInfo = params.attackerInfo
      local defenderInfo = params.defenderInfo
      local campName = params.attackCampName or ""
      local _attackerName = ""
      if attackerInfo then
        _attackerName = string.format("#%s[%s]%s", attackerInfo.serverId or "", attackerInfo.abbr or "", attackerInfo.name or "")
      end
      local _strPos = ""
      local _cityName = ""
      if cityInfo then
        local _name = GetTableData(TableName.WorldCity, cityInfo.cityId, "name")
        local _location = GetTableData(TableName.WorldCity, cityInfo.cityId, "location")
        local _x, _y = string.string2_ii(_location or "0|0", "|")
        _strPos = string.format("#%s(X:%s,Y:%s)", cityInfo.serverId or 0, _x or 0, _y or 0)
        _cityName = Localization:GetString(_name)
      end
      local _key = config.content
      local str = ""
      if defenderInfo then
        local _defenderName = string.format("#%s[%s]%s", defenderInfo.serverId or "", defenderInfo.abbr or "", defenderInfo.name or "")
        str = Localization:GetString(_key, _attackerName, _strPos, _defenderName, _cityName, Localization:GetString(campName))
      else
        str = Localization:GetString(_key, _attackerName, _strPos, _cityName, Localization:GetString(campName))
      end
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.RecruitHero then
      local name = params.name
      if params.abbr then
        name = "[" .. params.abbr .. "] " .. params.name
      end
      if params.allianceId == LuaEntry.Player.allianceId and params.name ~= LuaEntry.Player.name then
        name = string.format("<color='%s'>%s</color>", AllianceColor, name)
      end
      self.isSelf = params.name == LuaEntry.Player.name
      local heroName = GetTableData(HeroUtils.GetHeroXmlName(), params.heroId, "name")
      local colorName = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(params.quality), Localization:GetString(heroName))
      local str = Localization:GetString(config.content, name, colorName)
      local tab = {}
      tab.configId = params.heroId
      tab.quality = params.quality
      self:ShowNotice(str, config.priority, noticeType, tab)
    elseif noticeType == NoticeType.HeroCard_Use then
    elseif noticeType == NoticeType.NewServer_Act_Reward then
      local userName = params.name
      local actId = params.actId
      local type = params.type
      local heroId, quality
      local itemType = params.itemType
      local itemId = params.itemId
      local itemNum = params.itemNum
      local itemIndex = params.itemIndex
    elseif noticeType == NoticeType.RadarRally then
      local userName = params.userName
      local activityId = params.activityId
      local heroId = params.heroId
      local activityLine = LocalController:instance():getLine(TableName.ActivityPanel, activityId)
      local activityName = Localization:GetString(activityLine.name)
      local heroLine = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
      local heroName = Localization:GetString(heroLine.name)
      local heroQuality = tonumber(heroLine.init_quality_level)
      local str = Localization:GetString(tostring(config.content), userName, activityName, heroName)
      local tab = {configId = heroId, quality = heroQuality}
      self:ShowNotice(str, config.priority, noticeType, tab)
    elseif noticeType == NoticeType.AlElectResult then
      local alName = params.allianceName
      local userName = params.userName
      local str = Localization:GetString(tostring(config.content), userName, alName)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.CrossServer then
      local name = params.name
      local abbr = params.alAbbr
      if abbr ~= nil and abbr ~= "" then
        name = "[" .. abbr .. "] " .. params.name
      end
      local serverId = params.server
      name = string.format("<color=#dd2828> %s</color>", name)
      serverId = string.format("<color=#dd2828> %s</color>", serverId)
      local srcServerId = LuaEntry.Player:GetSelfServerId()
      srcServerId = string.format("<color=#B5F831> %s</color>", srcServerId)
      local str = Localization:GetString(tostring(config.content), serverId, name, srcServerId)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.AcquireHero then
      local name = params.userName
      if params.abbr then
        name = "[" .. params.abbr .. "] " .. params.userName
      end
      if params.allianceId == LuaEntry.Player.allianceId and params.userName ~= LuaEntry.Player.name then
        name = string.format("<color='%s'>%s</color>", AllianceColor, name)
      end
      local rarity = GetTableData(HeroUtils.GetHeroXmlName(), params.heroId, "rarity")
      local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(rarity), Localization:GetString(GetTableData(HeroUtils.GetHeroXmlName(), params.heroId, "name")))
      local str = Localization:GetString(config.content, name, heroName)
      local tab = {}
      tab.configId = params.heroId
      tab.quality = params.quality
      tab.loop = GetTableData(TableName.Announcement, config.id, "loop")
      self:ShowNotice(str, config.priority, noticeType, tab)
    elseif noticeType == NoticeType.ActBossOpen then
      local str = Localization:GetString(tostring(config.content), Localization:GetString(params.name))
      EventManager:GetInstance():Broadcast(EventId.ShowActBossOpen)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ActBossClose then
      local str = Localization:GetString(tostring(config.content), Localization:GetString(params.name))
      EventManager:GetInstance():Broadcast(EventId.ShowActBossClose)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ActBoss1stNo1 or noticeType == NoticeType.ActBossNo1New or noticeType == NoticeType.ActBossNo1Modify then
      local abbr = params.abbr
      local name = params.name
      local damage = string.GetFormattedSeperatorNum(params.damage)
      if not string.IsNullOrEmpty(abbr) then
        abbr = "[" .. abbr .. "] "
      end
      local str
      if noticeType == NoticeType.ActBossNo1Modify then
        local oldabbr = params.oldAbbr
        if not string.IsNullOrEmpty(oldabbr) then
          oldabbr = "[" .. oldabbr .. "] "
        end
        local oldname = params.oldName
        str = Localization:GetString(config.content, abbr, name, damage, oldabbr, oldname, Localization:GetString(params.bossName))
      else
        str = Localization:GetString(config.content, abbr, name, damage, Localization:GetString(params.bossName))
      end
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ArenaUnlock then
      local abbr = string.IsNullOrEmpty(params.abbr) and "" or string.format("[%s]", params.abbr)
      local str = Localization:GetString(tostring(config.content), abbr, params.playerName, params.rank)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ArenaChampion then
      local serverArr = string.split(params.serverGroup, "|")
      local serverGroupStr = ""
      for i, serverId in ipairs(serverArr) do
        if not string.IsNullOrEmpty(serverId) then
          serverGroupStr = serverGroupStr .. " #" .. serverId
        end
      end
      local abbr = string.IsNullOrEmpty(params.abbr) and "" or string.format("[%s]", params.abbr)
      local str = Localization:GetString(tostring(config.content), params.serverId, abbr, params.playerName, serverGroupStr)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ActScratchFirstReward then
      local abbr = string.IsNullOrEmpty(params.abbr) and "" or string.format("[%s]", params.abbr)
      local str = Localization:GetString(tostring(config.content), abbr, params.name, params.diamond)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.PUSH_3V3ARENA then
      local oldPlayerName = params.oldFirstName
      local oldPlayerServerId = params.oldServerId
      local oldPlayerAbbr = params.oldAbbr
      local oldPlayerStr = ""
      if not string.IsNullOrEmpty(oldPlayerServerId) then
        oldPlayerStr = oldPlayerStr .. " #" .. oldPlayerServerId
      end
      if not string.IsNullOrEmpty(oldPlayerAbbr) then
        oldPlayerStr = oldPlayerStr .. " [" .. oldPlayerAbbr .. "] "
      end
      oldPlayerStr = oldPlayerStr .. " " .. oldPlayerName
      local newPlayerScore = params.newScore
      local newPlayerName = params.newFirstName
      local newPlayerServerId = params.newServerId
      local newPlayerAbbr = params.newAbbr
      local newPlayerStr = ""
      if not string.IsNullOrEmpty(newPlayerServerId) then
        newPlayerStr = newPlayerStr .. " #" .. newPlayerServerId
      end
      if not string.IsNullOrEmpty(newPlayerAbbr) then
        newPlayerStr = newPlayerStr .. " [" .. newPlayerAbbr .. "] "
      end
      newPlayerStr = newPlayerStr .. " " .. newPlayerName
      local str = Localization:GetString(tostring(config.content), newPlayerStr, newPlayerScore, oldPlayerStr)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.BoxGetReward then
      local playerName = params.para0
      local boxName = params.para1
      local rewardName = params.para2
      local str = Localization:GetString(tostring(config.content), playerName, Localization:GetString(boxName), Localization:GetString(rewardName))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.CrossKingdomNotice26 then
      local str = Localization:GetString("801552", config.para1, "#" .. params.battleServerId)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.CrossKingdomNotice27 then
      local userName = params.name
      if not string.IsNullOrEmpty(params.alliance_abbr) then
        userName = string.format("[%s]%s", params.alliance_abbr, params.name)
      end
      if cfgId == 23010 then
        local str = Localization:GetString("801553", userName, Localization:GetString("302304"))
        self:CleanItemByType(noticeType, cfgId)
        self:ShowNotice(str, config.priority, noticeType, nil, cfgId)
      elseif cfgId == 23011 then
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(params.cityId)
        if cityTemplate ~= nil then
          local str = Localization:GetString("801553", userName, cityTemplate:GetName())
          self:CleanItemByType(noticeType, cfgId)
          self:ShowNotice(str, config.priority, noticeType, nil, cfgId)
        end
      end
    elseif noticeType == NoticeType.CrossKingdomNotice28 then
      if cfgId == 40001 or cfgId == 40002 then
        local str = ""
        if params.serverId and params.serverId > 0 then
          str = string.format("#%s", params.serverId)
        end
        str = Localization:GetString("season_s5_announcement_40001", string.format("%s[%s]", str, params.allianceAbbr or "-"), config.para1)
        self:ShowNotice(str, config.priority, noticeType, nil, cfgId)
      else
        local str = Localization:GetString("801554", "#" .. params.serverId, config.para1)
        self:ShowNotice(str, config.priority, noticeType, nil, cfgId)
      end
    elseif noticeType == NoticeType.CrossKingdomNotice29 then
      self:CleanItemByType(NoticeType.CrossKingdomNotice27, 23010)
      self:CleanItemByType(NoticeType.CrossKingdomNotice27, 23011)
      self:CleanItemByType(NoticeType.CrossKingdomNotice28, 23020)
      self:CleanItemByType(NoticeType.CrossKingdomNotice28, 23021)
      self:CleanItemByType(NoticeType.CrossKingdomNotice28, 40001)
      self:CleanItemByType(NoticeType.CrossKingdomNotice28, 40002)
      DataCenter.GovernmentManager:GetKingInfo(LuaEntry.Player:GetCurServerId())
      local str = Localization:GetString("801555", "#" .. params.attackerServerId, "#" .. params.serverId)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.CrossKingdomNotice30 then
      self:CleanItemByType(NoticeType.CrossKingdomNotice27, 23010)
      self:CleanItemByType(NoticeType.CrossKingdomNotice27, 23011)
      self:CleanItemByType(NoticeType.CrossKingdomNotice28, 23020)
      self:CleanItemByType(NoticeType.CrossKingdomNotice28, 23021)
      self:CleanItemByType(NoticeType.CrossKingdomNotice28, 40001)
      self:CleanItemByType(NoticeType.CrossKingdomNotice28, 40002)
      local str = Localization:GetString("801556", "#" .. params.serverId, "#" .. params.attackerServerId)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.NewbieArena then
      if cfgId == 20003 then
        local name = UIUtil.FormatAllianceAndName(params.abbr, params.playerName)
        local str = Localization:GetString(config.content, name)
        self:ShowNotice(str, config.priority, noticeType)
      elseif cfgId == 20004 then
        local name = UIUtil.FormatAllianceAndName(params.abbr, params.playerName)
        local str = Localization:GetString(config.content, name, params.rank)
        self:ShowNotice(str, config.priority, noticeType)
      end
    elseif noticeType == NoticeType.MonsterInvasion then
      local str = Localization:GetString(tostring(config.content))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.LuckyRoll then
      local userName = params.playerName
      if not string.IsNullOrEmpty(params.abbr) then
        userName = string.format("[%s]%s", params.abbr, params.playerName)
      end
      local str = Localization:GetString(config.content, userName, Localization:GetString(params.name), params.num)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.RunningBossKillTip then
      local name = params.name
      local lv = params.lv
      local str = Localization:GetString(config.content, name, lv)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.RecruitWorker then
      local userName = params.userName
      local str = Localization:GetString(config.content, userName)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.FisrtOccupyFLINT or noticeType == NoticeType.FisrtOccupyOBSIDIAN then
      local level = params.lv
      local name = params.name
      local str = Localization:GetString(config.content, name, level)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.SlotMachineEvent then
      local userName = params.playerName
      local str = Localization:GetString(config.content, userName, Localization:GetString(params.activityName), tostring(params.multiple), Localization:GetString(params.name), tostring(params.num))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.SlotMachienGain then
      local userName = params.playerName
      local str = Localization:GetString(config.content, userName, Localization:GetString(params.activityName), Localization:GetString(params.name), tostring(params.num))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.DispatchTreasure then
      local strUser = UIUtil.FormatAllianceAndName(params.abbr, params.name)
      local str = Localization:GetString(config.content, strUser, tostring(params.num), Localization:GetString(params.itemName))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.OpenGetBigReward then
      local playerName = params.playerName
      local totalName = playerName
      if not string.IsNullOrEmpty(params.alliance_abbr) then
        totalName = string.format("[%s]%s", params.alliance_abbr, playerName)
      end
      local str = Localization:GetString(config.content, totalName, Localization:GetString(params.userItemName), Localization:GetString(params.gainItemName), tostring(params.num))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.BlackMarket then
      local playerName = params.playerName
      local totalName = playerName
      if not string.IsNullOrEmpty(params.alliance_abbr) then
        totalName = string.format("[%s]%s", params.alliance_abbr, playerName)
      end
      local str = Localization:GetString(config.content, totalName, Localization:GetString(params.gainItemName))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.DecorationGacha then
      local playerName = params.playerName
      local totalName = playerName
      if not string.IsNullOrEmpty(params.alliance_abbr) then
        totalName = string.format("[%s]%s", params.alliance_abbr, playerName)
      end
      local str = Localization:GetString(config.content, totalName, Localization:GetString(params.activityName), tostring(params.multiple), Localization:GetString(params.gainItemName), tostring(params.num))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.MultipleRankTop then
      local name = params.name or ""
      local abbr = params.abbr
      name = UIUtil.FormatAllianceAndName(abbr, name)
      local level = params.level or 1
      local str = Localization:GetString(config.content, name, level)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ActMonopolyRewardTip1 then
      local ownerName = params.ownerName
      local activityName = params.activityName
      local alliance_abbr = params.alliance_abbr
      local otherName = params.otherName
      local eventName = params.eventName
      local gainItemName = params.gainItemName
      local num = params.num
      local totalName = ownerName
      if not string.IsNullOrEmpty(alliance_abbr) then
        totalName = string.format("[%s]%s", alliance_abbr, ownerName)
      end
      local str = Localization:GetString(config.content, totalName, Localization:GetString(activityName), otherName, Localization:GetString(eventName), Localization:GetString(gainItemName), num)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ActMonopolyRewardTip2 then
      local ownerName = params.ownerName
      local activityName = params.activityName
      local alliance_abbr = params.alliance_abbr
      local gainItemName = params.gainItemName
      local num = params.num
      local totalName = ownerName
      if not string.IsNullOrEmpty(alliance_abbr) then
        totalName = string.format("[%s]%s", alliance_abbr, ownerName)
      end
      local str = Localization:GetString(config.content, totalName, Localization:GetString(activityName), Localization:GetString(gainItemName), num)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ActMonopolyRewardTip3 then
      local ownerName = params.ownerName
      local activityName = params.activityName
      local alliance_abbr = params.alliance_abbr
      local eventName = params.eventName
      local gainItemName = params.gainItemName
      local num = params.num
      local totalName = ownerName
      if not string.IsNullOrEmpty(alliance_abbr) then
        totalName = string.format("[%s]%s", alliance_abbr, ownerName)
      end
      local str = Localization:GetString(config.content, totalName, Localization:GetString(activityName), Localization:GetString(eventName), Localization:GetString(gainItemName), num)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ActLotteryBigReward then
      local playerName = params.playerName
      local tickerNumber = params.tickerNumber
      local alliance_abbr = params.abbr
      local totalName = playerName
      if not string.IsNullOrEmpty(alliance_abbr) then
        totalName = string.format("[%s]%s", alliance_abbr, playerName)
      end
      local str = Localization:GetString(config.content, totalName, tickerNumber)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.BerserkBoss then
      local name = params.name or ""
      local str = ""
      if string.IsNullOrEmpty(name) then
        str = Localization:GetString(config.content)
      else
        str = Localization:GetString(config.content, Localization:GetString(name))
      end
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.PUSH_COMMON_NOTICE then
      local data = params.d
      local str = UIUtil.JsonBuildData(data)
      if str and str ~= "" then
        self:ShowNotice(str, config.priority, noticeType)
      end
    elseif noticeType == NoticeType.RecursionLang then
      local data = {
        id = config.content,
        params = params
      }
      local str = UIUtil.DecodeServerLang(data)
      if str and str ~= "" then
        self:ShowNotice(str, config.priority, noticeType)
      end
    elseif noticeType == NoticeType.Ghostrecon then
      local str = Localization:GetString(config.content)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.BehemothSkill then
      local totalHurt = params.totalHurt
      local str = Localization:GetString(config.content, string.format("%.2f", totalHurt))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.BehemothDeath then
      local name = UIUtil.FormatAllianceAndName(params.allianceAbbr, params.name)
      local tilePos = SceneUtils.IndexToTilePos(params.pointId, ForceChangeScene.World)
      local strPos = UIUtil.FormatServerPosition(nil, tilePos.x, tilePos.y)
      local str = Localization:GetString(config.content, name, strPos)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.BehemothShow then
      self:ShowNotice(Localization:GetString(config.content), config.priority, noticeType)
    elseif noticeType == NoticeType.InvasionMonsterLastKill then
      if params and params.name and params.multiple then
        local name = params.name
        local multiple = params.multiple
        local strMsg = Localization:GetString("activity_godzilla_attack_kill", name, multiple)
        if not string.IsNullOrEmpty(strMsg) then
          self:ShowNotice(strMsg, config.priority, noticeType)
        end
      end
    elseif noticeType == NoticeType.ADGachaGoldenReward then
      if params then
        local name = params.para0
        local itemName = params.para1
        local itemNum = params.para2
        local strMsg = Localization:GetString(config.content, name, Localization:GetString(itemName), itemNum)
        if not string.IsNullOrEmpty(strMsg) then
          self:ShowNotice(strMsg, config.priority, noticeType)
        end
      end
    elseif noticeType == NoticeType.SuperRunningBoss then
      local name = UIUtil.FormatAllianceAndName(params.allianceAbbr, params.name)
      local tilePos = SceneUtils.IndexToTilePos(params.location, ForceChangeScene.World)
      local strPos = UIUtil.FormatServerPosition(nil, tilePos.x, tilePos.y)
      local str = Localization:GetString(config.content, name, strPos, params.level)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.ExplorerTreasure then
      local playerName = UIUtil.FormatAllianceAndName(params.abbr, params.playerName)
      local boxName = DataCenter.ExplorerTreasureManager:GetRewardBoxName(params.quality)
      local boxStr = Localization:GetString(boxName)
      local str = Localization:GetString(config.content, playerName, boxStr)
      TimerManager:GetInstance():DelayInvoke(function()
        self:ShowNotice(str, config.priority, noticeType)
      end, 4)
    elseif noticeType == NoticeType.RecaptureBuff then
      local monsterLv = params.monsterLv
      local serverId = params.serverId
      local buffId = params.buffId
      local cfg = LocalController:instance():getLine(TableName.StatusTab, buffId)
      local str = Localization:GetString(config.content, monsterLv, Localization:GetString(cfg.name))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.SurfingZoneRankListed then
      local name = params.name
      local score = params.score
      local rank = params.rank
      local str = Localization:GetString(config.content, name, score, rank)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.WeatherSummon then
      local name = params.playerName
      if string.IsNullOrEmpty(params.abbr) then
        name = string.format("#%s %s", params.server, name)
      else
        name = string.format("#%s [%s]%s", params.server, params.abbr, name)
      end
      local lastInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(params.lastWeatherId)
      local curInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(params.curWeatherId)
      local str = Localization:GetString(config.content, name, lastInfo and Localization:GetString(lastInfo.name), curInfo and Localization:GetString(curInfo.name))
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.GhostParkourRank then
      local name = params.name
      local score = UITimeManager:GetInstance():GetCompetitionTimeFormat(tonumber(params.score))
      local rank = params.rank
      local str = Localization:GetString(config.content, name, score, rank)
      self:ShowNotice(str, config.priority, noticeType)
    elseif noticeType == NoticeType.FrontBreakSunday then
      do
        local name = UIUtil.FormatAllianceAndName(params.abbr, params.playerName)
        local score = params.soldierNum
        local str = Localization:GetString("frontline_weekend_info_01", name, score)
        self:ShowNotice(str, config.priority, noticeType)
      end
    end
  end
end

local function CleanItemByType(self, noticeType, cfgId)
  if self.allPushTip then
    local hasDirtyData = false
    for k, v in ipairs(self.allPushTip) do
      if v ~= nil and v.cfgId == cfgId and v.noticeType == noticeType then
        hasDirtyData = true
        break
      end
    end
    if hasDirtyData then
      local dataNew = {}
      for k, v in ipairs(self.allPushTip) do
        if v ~= nil and (v.cfgId ~= cfgId or v.noticeType ~= noticeType) then
          table.insert(dataNew, v)
        end
      end
      self.allPushTip = dataNew
    end
  end
end

local function AddItem(self, data)
  if #self.allPushTip > 0 then
    local first = self.allPushTip[1]
    local priority = first.priority
    local dataPriority = data.priority
    if priority < dataPriority then
      table.insert(self.allPushTip, 1, data)
    else
      local index = 1
      for i, v in ipairs(self.allPushTip) do
        if dataPriority > v.priority then
          break
        end
        index = index + 1
      end
      table.insert(self.allPushTip, index, data)
    end
  else
    table.insert(self.allPushTip, data)
  end
end

local function GetNotice(self, isHero)
  if #self.allPushTip > 0 then
    if isHero then
      if self.allPushTip[1].noticeType == NoticeType.RecruitHero or self.allPushTip[1].noticeType == NoticeType.AcquireHero or self.allPushTip[1].noticeType == NoticeType.RadarRally then
        return table.remove(self.allPushTip, 1)
      end
    else
      if self.allPushTip[1].noticeType == NoticeType.RecruitHero or self.allPushTip[1].noticeType == NoticeType.AcquireHero or self.allPushTip[1].noticeType == NoticeType.RadarRally then
        return nil
      end
      return table.remove(self.allPushTip, 1)
    end
  end
  return nil
end

local function CheckNotice(self)
  return #self.allPushTip > 0
end

local function ShowTip(noticeType)
  if noticeType == NoticeType.RecruitHero or noticeType == NoticeType.AcquireHero or noticeType == NoticeType.RadarRally then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoticeTips) then
      local isHero = 1
      EventManager:GetInstance():Broadcast(EventId.UI_SHOWNOTICE, isHero)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UINoticeHeroTips, {anim = true, playEffect = false})
    end
  elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoticeHeroTips) then
    local isNotice = 2
    EventManager:GetInstance():Broadcast(EventId.UI_SHOWNOTICE, isNotice)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UINoticeTips, {anim = true, playEffect = false})
  end
end

local function ShowNotice(self, content, priority, noticeType, tab, cfgId)
  local data = {}
  data.content = content
  data.priority = priority
  data.noticeType = noticeType
  data.tab = tab
  data.cfgId = cfgId
  self:AddItem(data)
  if noticeType == NoticeType.RecruitHero and self.isSelf then
    self:WaitTime(noticeType)
    return
  end
  self.ShowTip(noticeType)
end

local function DeleteTime(self)
  if self.wait_timer ~= nil then
    self.wait_timer:Stop()
    self.wait_timer = nil
  end
end

local function WaitTime(self, noticeType)
  if self.wait_timer == nil then
    self.wait_timer = TimerManager:GetInstance():GetTimer(8, self.wait_timer_func, noticeType, false, false, false)
    self.wait_timer:Start()
  end
end

local function WaitTimeRef(self, noticeType)
  self:DeleteTime()
  self.ShowTip(noticeType)
end

local function CheckShowAllianceCityTip(self, content, allianceId, closeCallback)
  if allianceId ~= nil and allianceId == LuaEntry.Player.allianceId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldRuinsPopUp, content, nil, closeCallback)
  end
end

NoticeTipsManager.__init = __init
NoticeTipsManager.__delete = __delete
NoticeTipsManager.NetPush = NetPush
NoticeTipsManager.OnUpdateNotice = OnUpdateNotice
NoticeTipsManager.AddItem = AddItem
NoticeTipsManager.CleanItemByType = CleanItemByType
NoticeTipsManager.GetNotice = GetNotice
NoticeTipsManager.CheckNotice = CheckNotice
NoticeTipsManager.ShowTip = ShowTip
NoticeTipsManager.ShowNotice = ShowNotice
NoticeTipsManager.CheckShowAllianceCityTip = CheckShowAllianceCityTip
NoticeTipsManager.DeleteTime = DeleteTime
NoticeTipsManager.WaitTime = WaitTime
NoticeTipsManager.WaitTimeRef = WaitTimeRef
return NoticeTipsManager
