local PlayerInfo = BaseClass("PlayerInfo")
local Setting = CS.GameEntry.Setting
local GM_ONLY_SHOW_KEY_FLAG = SettingKeys.GM_ONLY_SHOW_KEY_FLAG
local USER_REG_TIME = SettingKeys.USER_REG_TIME
local SettingKeys = CS.GameDefines.SettingKeys
local Localization = CS.GameEntry.Localization
local AccountListManager = require("DataCenter.AccountData.AccountListManager")
local AccountInfo = require("DataCenter.AccountData.AccountInfo")

function PlayerInfo:__init()
  self:__reset()
end

function PlayerInfo:__delete()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function PlayerInfo:__reset()
  self.serverMax = 0
  self.serverId = -1
  self.serverType = 0
  self.crossFightSrcServerId = -1
  self.checkServerId = CS.GameEntry.Data.Player:GetCrossServerId()
  self.checkWorldId = CS.GameEntry.Data.Player:GetWorldId()
  self.checkWorldType = CS.GameEntry.Data.Player:GetWorldType()
  self.deviceId = ""
  self.uuid = ""
  self.uid = ""
  self.name = ""
  self.level = 0
  self.careerType = MasteryHome.None
  self.careerLv = 0
  self.exp = 0
  self.abTest = ""
  self.gmFlag = 0
  self.isFirstJoin = 0
  self.allianceId = ""
  self.alsignrewardlog = ""
  self.newbies_ab = false
  self.monopoly_ab = -1
  self.iOSVersionUpdateTipLimit = 0
  self.pic = ""
  self.picVer = 0
  self.picUploading = false
  self.lastUpdateTime = 0
  self.nickName = ""
  self.renameTime = 0
  self.gender = 0
  self.chGenderTime = 0
  self.lastFreeAlMoveTime = 0
  self.country = ""
  self.countryFlag = ""
  self.regCountry = ""
  self.regTime = 0
  self.lastOffLineTime = 0
  self.inviCode = ""
  self.analyticID = ""
  self.pushMark = 0
  self.gold = 0
  self.paidGoid = 0
  self.sm_addGoldCount = 0
  self.gold1 = 0
  self.payTotal = 0
  self.payDollerTotal = 0
  self.openServerTime = 0
  self.curServerOpenTime = 0
  self.checkServerOpenTime = 0
  self.lastPower = 0
  self.power = 0
  self.heroPower = 0
  self.sciencePower = 0
  self.buildingPower = 0
  self.armyPower = 0
  self.playerPower = 0
  self.squadEquipPower = 0
  self.decoPower = 0
  self.dominatorPower = 0
  self.battleCardPower = 0
  self.armyDead = 0
  self.armyKill = 0
  self.armyCure = 0
  self.battleLose = 0
  self.battleWin = 0
  self.gmGold = 0
  self.gmGoldLimit = 0
  self.ProtectTimeStamp = 0
  self.ResourceProtectTimeStamp = 0
  self.CooldownTime = ""
  self.ProtectCoolDownTime = ""
  self.vipActivePoint = 0
  self.isVipStoreUnlock = false
  self.vipframe = 0
  self.SVIPLevel = 0
  self.pinPwdStatus = 0
  self.pinPwdCheckFrequency = 0
  self.pinPwdChange = 0
  self.serverName = ""
  self.nextDay = 0
  self.moodStr = 0
  self.ptGold = 0
  self.pveLevel = 0
  self.firstModfiyPic = false
  self.modfiyPicStatus = false
  self.payMonthlyDollarTotal = 0
  self.alGiftHideName = 0
  self.konbiniInfo = {}
  self.newAccount = false
  self.translateKey = ""
  self.curNotifyUserInfoIndex = 0
  self.agreeUserAgreementFlag = 0
  self.stamina = 0
  self.lastStaminaTime = 0
  self.playerStaminaGoldTime = 0
  self.playerStaminaGoldNum = 0
  self.tempStaminaValue = 0
  self.staminaValue = 0
  self.pveStamina = 0
  self.lastPveStaminaTime = 0
  self.pveFakeStamina = 0
  self.lastClaimFreeStaminaTime = 0
  self.todayFreeStamina = 0
  self.fold_cross_worm_hole_time = 0
  self.world_main_pos = -1
  self.dragon_main_pos = -1
  self.firstFreeAlliance = {}
  self.goldBrickInfos = {}
  self.VirusLayer = 0
  self.killMonsterIds = {}
  self.canBuyGoldBrick = 0
  self.newBeeMigrateWay = 0
  self.newBeeMigrateServer = 0
  self.immigrateSoldierLv = 0
  self.immigrateSoldierCount = 0
  self.storeCountry = nil
  self.storeCountry = nil
  self.unpackResourceReward = {}
  self.seasonRole = {}
  self.csBuilding = nil
  self.playerMaxPower = 0
  self.alreadyBuyGoldBrick = false
  self.goldBrickSwitch = false
  self.hasStoreCurrency = false
  self.armed_upgrade_tag = -1
  self.armed_upgrade_repair = 0
  if not self:IsInSelfServer() then
    self:SendGetOtherServerInfo(self.checkServerId)
  end
end

function PlayerInfo:InitFromNet(obj)
  if obj.user then
    self:UpdateUser(obj.user)
  end
  if obj.userSetting then
    self:UpdateUserSetting(obj.userSetting)
  end
  if obj.playerInfo then
    self:UpdatePlayerInfo(obj.playerInfo, true)
  end
  if obj.lastFreeMoveTime then
    self.lastFreeAlMoveTime = obj.lastFreeMoveTime
  end
  if obj.oldThumbsUpCount then
    self.oldThumbsUpCount = obj.oldThumbsUpCount
  end
  if obj.newThumbsUpCount then
    self.newThumbsUpCount = obj.newThumbsUpCount
  end
  if obj.thumbsUpInfoObj then
    self.thumbsUpInfoObj = obj.thumbsUpInfoObj
  end
  if obj.konbiniInfo then
    self:UpdateKonbiniInfo(obj.konbiniInfo)
  end
  if obj.playerStamina ~= nil then
    self:SetStaminaGoldTime(obj.playerStamina)
  end
  if obj.firstFreeMoveAlliance ~= nil then
    self:InitFirstFreeAlliance(obj.firstFreeMoveAlliance)
  end
  if obj.canBuyGoldBrick then
    self.canBuyGoldBrick = obj.canBuyGoldBrick
  end
  if obj.transferSelfOrder then
    self.transferSelfOrder = obj.transferSelfOrder == 1
  else
    self.transferSelfOrder = false
  end
  if obj.alreadyBuyGoldBrick ~= nil then
    self.alreadyBuyGoldBrick = obj.alreadyBuyGoldBrick == 1
  else
    self.alreadyBuyGoldBrick = false
  end
  if obj.goldBrickSwitch ~= nil then
    self.goldBrickSwitch = obj.goldBrickSwitch == 1
  else
    self.goldBrickSwitch = false
  end
  if obj.seasonRole then
    self:RefreshSeasonRole(obj.seasonRole)
  end
  self:SetFoldCrossWormHoleTime(obj)
  self:UpdateVIPInfo(obj)
  self:UpdateOtherInfo(obj)
  self:OnHandleNewBeeMigrate(obj)
  Setting:SetString(SettingKeys.DEVICE_UID, self.deviceId)
  Setting:SetString(SettingKeys.UUID, self.uuid)
  Setting:SetInt(SettingKeys.GM_FLAG, self.gmFlag)
  CommonUtil.RefreshAutoArabicMirrorSwitch()
  CS.MirrorVersionConfig.RefreshOpenFlag()
  local isShowKey = Setting:GetBool(GM_ONLY_SHOW_KEY_FLAG .. LuaEntry.Player.uid, false)
  Localization.ShowKey = isShowKey
  self.hasStoreCurrency = false
  CommonUtil.ProtectCall(function()
    DataCenter.PayManager:TryCollectStoreInfo()
  end)
  DataCenter.SeasonTradeShopDataManager:InitAssignationRedPacketData(obj)
  self.csBuilding = CS.GameEntry.Data.Building
  DataCenter.SeasonResourceDownloadManager:PlayerSettingInit()
end

function PlayerInfo:HasNewThumbsUpInfo()
  return toInt(self.oldThumbsUpCount) < toInt(self.newThumbsUpCount)
end

function PlayerInfo:ResetThumbsUpInfo()
  self.oldThumbsUpCount = 0
  self.newThumbsUpCount = 0
end

function PlayerInfo:GetCurWorldId()
  return self.checkWorldId or 0
end

function PlayerInfo:SetWorldId(worldId)
  self.checkWorldId = worldId
  CS.GameEntry.Data.Player:SetWorldId(worldId)
end

function PlayerInfo:GetCurWorldType()
  return self.checkWorldType or 0
end

function PlayerInfo:SetWorldType(worldType)
  self.checkWorldType = worldType
  CS.GameEntry.Data.Player:SetWorldType(worldType)
end

function PlayerInfo:UpdateOtherInfo(obj)
  if obj.newAccount then
    self.newAccount = obj.newAccount
  end
  if obj.kingdom_contribution then
    self.kingdomContribution = obj.kingdom_contribution
  end
end

function PlayerInfo:UpdateClaimFreeStamina(msg)
  local todayFreeStamina = self.todayFreeStamina
  if msg.lastClaimFreeStaminaTime then
    self.lastClaimFreeStaminaTime = msg.lastClaimFreeStaminaTime
  end
  if msg.todayFreeStamina then
    self.todayFreeStamina = msg.todayFreeStamina
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshClaimFreeStamina)
  if self.delay == nil then
    local dayCd = UITimeManager:GetInstance():GetResSecondsTo24() + 5 + math.random() * 10
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.UserGetDailyStaminaInfo)
      if self.delay then
        self.delay:Stop()
        self.delay = nil
      end
    end, dayCd)
  end
end

function PlayerInfo:UpdateVIPInfo(obj)
  if obj.vipstoreLevel then
    self.vipstoreLevel = obj.vipstoreLevel
  end
  if obj.vipstorestate then
    self.vipstorestate = obj.vipstorestate
  end
  if obj.activepoint then
    self.vipActivePoint = obj.activepoint
  end
  return
end

function PlayerInfo:UpdatePowerData(playerInfo)
  self.lastPower = self.power
  if playerInfo.heroPower then
    self.heroPower = playerInfo.heroPower
  end
  if playerInfo.buildingPower then
    self.buildingPower = playerInfo.buildingPower
  end
  if playerInfo.armyPower then
    self.armyPower = playerInfo.armyPower
  end
  if playerInfo.sciencePower then
    self.sciencePower = playerInfo.sciencePower
  end
  if playerInfo.squadEquipPower then
    self.squadEquipPower = playerInfo.squadEquipPower
  end
  if playerInfo.decoPower then
    self.decoPower = playerInfo.decoPower
  end
  if playerInfo.dominatorPower then
    self.dominatorPower = playerInfo.dominatorPower
  end
  if playerInfo.battleCardPower then
    self.battleCardPower = playerInfo.battleCardPower
  end
  if playerInfo.modfiyPicStatus then
    self.modfiyPicStatus = playerInfo.modfiyPicStatus == 1
  end
  self.power = self.heroPower + self.buildingPower + self.armyPower + self.sciencePower + self.squadEquipPower + self.dominatorPower + self.battleCardPower
  if self.lastPower ~= 0 and self.lastPower ~= self.power then
    if self.power > self.lastPower then
      UIUtil.ShowPowerUpTip(self.power - self.lastPower)
    end
    EventManager:GetInstance():Broadcast(EventId.PlayerPowerInfoUpdated)
  end
  self:SetStaminaData(playerInfo)
  self:SetPveStaminaData(playerInfo)
end

function PlayerInfo:UpdatePowerDataNew(info)
  self.lastPower = self.power or 0
  local totalPwr = info["0"]
  if totalPwr then
    self.power = totalPwr
  else
    return
  end
  local lastHeroPower = self.heroPower or 0
  local power1 = info["1"]
  if power1 then
    self.heroPower = power1
  end
  local lastDronePower = self.squadEquipPower or 0
  local power2 = info["2"]
  if power2 then
    self.squadEquipPower = power2
  end
  local lastBuildingPower = self.buildingPower or 0
  local power3 = info["3"]
  if power3 then
    self.buildingPower = power3
  end
  local lastArmyPower = self.armyPower or 0
  local power4 = info["4"]
  if power4 then
    self.armyPower = power4
  end
  local lastSciencePower = self.sciencePower or 0
  local power5 = info["5"]
  if power5 then
    self.sciencePower = power5
  end
  local lastDominatorPower = self.dominatorPower or 0
  local power6 = info["6"]
  if power6 then
    self.dominatorPower = power6
  end
  local lastBattleCardPower = self.battleCardPower or 0
  local power7 = info["7"]
  if power7 then
    self.battleCardPower = power7
  end
  local powerChange = {
    {
      key = "powerAdd",
      value = totalPwr - self.lastPower
    },
    {
      key = "heroPowerAdd",
      value = self.heroPower - lastHeroPower
    },
    {
      key = "dronePowerAdd",
      value = self.squadEquipPower - lastDronePower
    },
    {
      key = "buildingPowerAdd",
      value = self.buildingPower - lastBuildingPower
    },
    {
      key = "armyPowerAdd",
      value = self.armyPower - lastArmyPower
    },
    {
      key = "sciencePowerAdd",
      value = self.sciencePower - lastSciencePower
    },
    {
      key = "dominatorPowerAdd",
      value = self.dominatorPower - lastDominatorPower
    },
    {
      key = "battleCardPowerAdd",
      value = self.battleCardPower - lastBattleCardPower
    }
  }
  table.sort(powerChange, function(a, b)
    if a.key == "powerAdd" then
      return true
    elseif b.key == "powerAdd" then
      return false
    end
    return a.value > b.value
  end)
  if self.lastPower ~= 0 and self.lastPower ~= totalPwr then
    if totalPwr > self.lastPower then
      UIUtil.ShowPowerUpTipNew(powerChange)
    end
    EventManager:GetInstance():Broadcast(EventId.PlayerPowerInfoUpdated)
  end
end

function PlayerInfo:UpdatePlayerInfo(playerInfo, init)
  local function_on = LuaEntry.DataConfig:CheckSwitch("player_combat_change")
  if not function_on then
    self:UpdatePowerData(playerInfo)
  elseif init then
    self:UpdatePowerData(playerInfo)
  else
    if playerInfo.modfiyPicStatus then
      self.modfiyPicStatus = playerInfo.modfiyPicStatus == 1
    end
    self:SetStaminaData(playerInfo)
    self:SetPveStaminaData(playerInfo)
    if playerInfo.decoPower then
      self.decoPower = playerInfo.decoPower
    end
  end
  if playerInfo.serverName then
    self.serverName = playerInfo.serverName
  end
  if playerInfo.nextDay then
    self.nextDay = playerInfo.nextDay
  end
  if playerInfo.alGiftHideName then
    self.alGiftHideName = playerInfo.alGiftHideName
  end
  if playerInfo.moodStr then
    self.moodStr = playerInfo.moodStr
  end
  if playerInfo.ptGold then
    self.ptGold = playerInfo.ptGold
  end
  if playerInfo.pveLevel then
    self.pveLevel = playerInfo.pveLevel
  end
  if playerInfo.gmGold then
    self.gmGold = playerInfo.gmGold
  end
  if playerInfo.gmGoldLimit then
    self.gmGoldLimit = playerInfo.gmGoldLimit
  end
  if playerInfo.agreeUserAgreementFlag then
    self.agreeUserAgreementFlag = playerInfo.agreeUserAgreementFlag
  end
  if playerInfo.goldBrick then
    self.goldBrickInfos = playerInfo.goldBrick
  end
  if playerInfo.firstKillMonsters then
    self.killMonsterIds = {}
    for key, value in pairs(playerInfo.firstKillMonsters) do
      self.killMonsterIds[value] = true
    end
  end
  if playerInfo.playerMaxPower then
    self.playerMaxPower = playerInfo.playerMaxPower
  end
end

function PlayerInfo:UpdateSendCustomHead(message)
  if message.modfiyPicStatus ~= nil then
    self.modfiyPicStatus = message.modfiyPicStatus == 1
  end
end

function PlayerInfo:UpdateUser(user)
  if user.serverMax then
    self.serverMax = user.serverMax
  end
  if user.serverId then
    self.serverId = user.serverId
  end
  if user.serverType then
    self.serverType = user.serverType
  end
  if user.serverCountryList then
    local serverCountryList = user.serverCountryList
    local array = string.split(serverCountryList, ",")
    self.serverCountryList = {}
    if not table.IsNullOrEmpty(array) then
      for k, v in pairs(array) do
        self.serverCountryList[v] = true
      end
    end
  end
  if user.crossFightSrcServerId then
    self.crossFightSrcServerId = user.crossFightSrcServerId
  end
  if CS.GameEntry.Data.Player.SetCrossFightSrcServerId ~= nil then
    CS.GameEntry.Data.Player:SetCrossFightSrcServerId(self.crossFightSrcServerId or -1)
  end
  if user.deviceId then
    self.deviceId = user.deviceId
  end
  if user.uuid then
    self.uuid = user.uuid
  end
  if user.uid then
    self.uid = user.uid
  end
  if user.name then
    self.name = user.name
  end
  if user.level then
    self:OnLevelUpdate(user.level)
    self.level = user.level
  end
  if user.careerType then
    self.careerType = user.careerType
  end
  if user.careerLv then
    self.careerLv = user.careerLv
  end
  if user.exp then
    self.exp = user.exp
  end
  if user.pic then
    self.pic = user.pic
  end
  if user.picVer then
    self.picVer = user.picVer
  end
  if user.abTest then
    self.abTest = user.abTest
    if self.abTest == ABTestType.B then
      Logger.Log("<color=#F100BC>GetABTestType  B  </color>")
    else
      Logger.Log("<color=#F100BC>GetABTestType  A  </color>")
    end
  end
  if user.newbies_ab then
    self.newbies_ab = user.newbies_ab
  end
  if user.monopoly_ab then
    self.monopoly_ab = user.monopoly_ab
    DataCenter.LWCivilizationSparkExtend:RefreshGuideVersion()
  end
  if user.iOS_Version_Update_Tip then
    self.iOSVersionUpdateTipLimit = user.iOS_Version_Update_Tip
  end
  if user.gmFlag then
    self.gmFlag = user.gmFlag
  end
  if user.isfirstJoin then
    self.isFirstJoin = user.isfirstJoin
  end
  if user.allianceId then
    self:SetAllianceUid(user.allianceId)
  end
  if user.alsignrewardlog then
    self.alsignrewardlog = user.alsignrewardlog
  end
  if user.lastUpdateTime then
    self.lastUpdateTime = toInt(user.lastUpdateTime)
  end
  if user.nickName then
    self.nickName = user.nickName
  end
  if user.chNameCount then
    self.renameTime = user.chNameCount
  end
  if user.gender then
    self.gender = user.gender
  end
  if user.chGenderTime then
    self.chGenderTime = user.chGenderTime
  end
  if user.country then
    self.country = user.country
    Setting:SetString(SettingKeys.SERVER_COUNTRY, self.country)
    Logger.Log("Server Country: " .. self.country)
    self.JPUser = self.country == "JP"
  end
  if user.countryflag then
    self.countryFlag = user.countryflag
  end
  if user.regCountry then
    self.regCountry = user.regCountry
  end
  if user.regTime then
    self.regTime = user.regTime
    Setting:SetString(USER_REG_TIME, self.regTime)
  end
  if user.lastOffLineTime then
    self.lastOffLineTime = user.lastOffLineTime
  end
  if user.inviCode then
    self.inviCode = user.inviCode
  end
  self.analyticID = ""
  local sm_gold = self.gold
  if user.gold then
    self.gold = user.gold
  end
  if user.paidGold then
    self.paidGoid = user.paidGold
  end
  if user.gold1 then
    self.gold1 = user.gold1
  end
  self.sm_addGoldCount = self.gold - sm_gold
  if user.payTotal then
    self.payTotal = user.payTotal
  end
  if user.payDollerTotal then
    self.payDollerTotal = user.payDollerTotal
  end
  if user.openServerTime then
    self.openServerTime = user.openServerTime
    self:SyncOpenServerTime()
  end
  if user.curServerOpenTime then
    self.curServerOpenTime = user.curServerOpenTime
    if self.openServerTime == 0 then
      self.openServerTime = self.curServerOpenTime
      self:SyncOpenServerTime()
    end
  end
  if user.pushMark then
    self.pushMark = user.pushMark
  end
  if user.armed_upgrade_tag then
    self.armed_upgrade_tag = user.armed_upgrade_tag
  end
  if user.armed_upgrade_repair then
    self.armed_upgrade_repair = user.armed_upgrade_repair
  end
  self:SaveThisAccount()
  self:LogToFacebook()
end

function PlayerInfo:UpdatePayDollerTotal(payDollerTotal)
  self.payDollerTotal = payDollerTotal
end

function PlayerInfo:LogToFacebook()
  local time = UITimeManager:GetInstance():GetServerTime()
  local diff = UITimeManager:GetInstance():GetBetweenDaysForLocal(self.regTime / 1000, time / 1000)
  local login_times = Setting:GetInt(SettingKeys.LOGIN_SECOND_DAYS, 0)
  if login_times == 0 and diff == 1 then
    CS.GameEntry.Sdk:LogEvent("secondLogin", self.uid)
    Setting:SetInt(SettingKeys.LOGIN_SECOND_DAYS, 1)
  end
end

function PlayerInfo:SaveThisAccount()
  local accountInfo = AccountInfo.New()
  accountInfo.serverid = self.serverId
  accountInfo.gameUid = self.uid
  accountInfo.nickname = self.name
  accountInfo.newLevel = DataCenter.BuildManager.MainLv
  accountInfo.ip = CS.AccountCredentialManager.ServerInfo.ip
  accountInfo.port = CS.AccountCredentialManager.ServerInfo.port
  accountInfo.zone = CS.AccountCredentialManager.ServerInfo.zone
  accountInfo.accessToken = CS.AccountCredentialManager.AuthTokens.at
  local enumName = CS.System.Enum.GetName(typeof(CS.URLGroupType), CS.NetworkURLConfig.URLGroupType)
  accountInfo.urlEnv = tostring(enumName)
  DataCenter.AccountListManager:AddAcountInfo(accountInfo, true)
  Logger.LogInfo("[AT]SetGUID_SaveAccount:" .. tostring(self.uid))
  CS.AccountCredentialManager.SetUID(self.uid)
  CS.AccountCredentialManager.SetGMFlag(self.gmFlag)
end

function PlayerInfo:getPayLevel()
  local score = {
    0,
    100,
    1000,
    5000,
    10000,
    30000,
    80000
  }
  for i = 10, -1, 0 do
    if self.payMonthlyDollarTotal > score[i] then
      return i
    end
  end
  return 0
end

function PlayerInfo:getPayLevelM()
  local score = {
    0,
    1000,
    2000,
    3000,
    4000,
    5000,
    6000,
    7000,
    8000,
    9000,
    10000
  }
  for i = 10, -1, 0 do
    if self.payMonthlyDollarTotal > score[i] then
      return i
    end
  end
  return 0
end

function PlayerInfo:GetUid()
  return self.uid
end

function PlayerInfo:SetName(name)
  if self.name == name then
    return
  end
  self.name = name
end

function PlayerInfo:GetName()
  return self.name
end

function PlayerInfo:SetGender(gender)
  if self.gender == gender then
    return
  end
  self.gender = gender
end

function PlayerInfo:GetGender()
  return self.gender
end

function PlayerInfo:SetPic(pic)
  self.pic = pic
end

function PlayerInfo:GetPic()
  return self.pic
end

function PlayerInfo:GetFullPic()
  local index = string.find(self.pic, "player_head_", 0, true)
  if index == nil or index < 0 then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_player_head_big"
  else
    return "Assets/Main/Sprites/UI/UIHeadIcon/" .. self.pic .. ".png"
  end
end

function PlayerInfo:GetServerId(serverEnum)
  if serverEnum == ServerEnum.Source then
    return self:GetSourceServerId()
  elseif serverEnum == ServerEnum.View then
    return self:GetCurServerId()
  end
  return self:GetSelfServerId()
end

function PlayerInfo:GetSourceServerId()
  return self.crossFightSrcServerId >= 0 and self.crossFightSrcServerId or self:GetSelfServerId()
end

function PlayerInfo:GetSelfServerId()
  if self.serverId == -1 or self.serverId == 0 or self.serverId == nil then
    local theServerId = CS.GameEntry.Data.Player:GetSelfServerId()
    if theServerId ~= 0 then
      if self.serverId == nil then
        Logger.LogError("GetSelfServerId fail, serverId is nil, " .. theServerId)
      else
        Logger.LogError("GetSelfServerId fail, serverId = " .. self.serverId .. " , " .. theServerId)
      end
    end
    if theServerId ~= 0 and theServerId ~= -1 and theServerId ~= nil then
      self.serverId = theServerId
    end
  end
  return self.serverId
end

function PlayerInfo:GetCurServerId()
  local serverId = self.serverId
  if self.checkServerId > 0 then
    serverId = self.checkServerId
  else
    serverId = self:GetSelfServerId()
  end
  if serverId <= 1 and CS.NetworkURLConfig.IsOnline then
    Logger.LogError("GetCurServerId fail, serverId = " .. self.serverId .. " , checkServerId = " .. self.checkServerId)
  end
  return serverId
end

function PlayerInfo:IsInSourceServer()
  return self:GetCurServerId() == self:GetSourceServerId()
end

function PlayerInfo:IsLoginSourceServer()
  return self.crossFightSrcServerId < 0 or self.crossFightSrcServerId == self.serverId
end

function PlayerInfo:AtHomeNow()
  return self:IsLoginSourceServer() and self:IsInSourceServer()
end

function PlayerInfo:IsInSelfServer()
  return self.checkServerId < 0 or self.checkServerId == self.serverId
end

function PlayerInfo:SetCrossServerId(crossServerId)
  local curServerId = self.checkServerId
  self.checkServerId = crossServerId
  CS.GameEntry.Data.Player:OnCrossServerId(crossServerId)
  if CommonUtil.IsEditor() then
    print("SetCrossServerId = " .. tostring(crossServerId))
  end
  if crossServerId ~= curServerId then
    EventManager:GetInstance():Broadcast(EventId.OnSetCrossID)
    EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
  end
end

function PlayerInfo:GetCrossServerId()
  return self.checkServerId
end

function PlayerInfo:GetCityProtectCoolDownTime()
  if string.IsNullOrEmpty(self.CooldownTime) then
    return 0
  end
  local cooltimes = self.CooldownTime.Split(";")
  local mainLv = 1
  if mainLv > cooltimes.Length then
    return 0
  end
  return toInt(cooltimes[mainLv - 1])
end

function PlayerInfo:GetGMFlag()
  return self.gmFlag
end

function PlayerInfo:IsGrayServer(from, stop)
  local startServer = tonumber(from) or -1
  local endServer = tonumber(stop) or -1
  if startServer < 0 or endServer < 0 or startServer > endServer then
    return false
  end
  local server = CS.AccountCredentialManager.ServerInfo.zone
  server = string.gsub(server, "APS", "")
  server = tonumber(server) or -1
  if string.IsNullOrEmpty(server) or server < 0 then
    return false
  end
  return startServer <= server and endServer >= server
end

function PlayerInfo:IsPresident(serverId)
  local curPresident = DataCenter.GovernmentManager:GetCurPresident(serverId)
  return curPresident ~= nil and curPresident.uid == self.uid
end

function PlayerInfo:IsBuildingLeader(serverId, buildingId)
  return self:IsSurfaceLeader(serverId, buildingId) or self:IsDeepLeader(serverId, buildingId) or self:IsVicePresident(serverId, buildingId)
end

function PlayerInfo:IsDeepLeader(serverId, buildingId)
  if not DataCenter.AllianceBaseDataManager:IsR5() then
    return false
  end
  if self.allianceId == DataCenter.BuildingOfficialManager:GetBuildingAllianceId(serverId, buildingId) then
    return true
  end
  local template = DataCenter.AllianceCityTemplateManager:GetTemplate(buildingId, serverId)
  if template and template:IsThroneCity() then
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(buildingId, serverId)
    if cityInfo and self.allianceId == cityInfo.destroyAllianceId then
      return true
    end
  end
  return false
end

function PlayerInfo:IsSurfaceLeader(serverId, buildingId)
  local curPresident = DataCenter.BuildingOfficialManager:GetSurfaceLeader(serverId, buildingId)
  return curPresident ~= nil and curPresident.uid == self.uid
end

function PlayerInfo:IsVicePresident(serverId, buildingId)
  return DataCenter.BuildingOfficialManager:ImVicePresident(serverId, buildingId)
end

function PlayerInfo:IsFirstLady(serverId)
  local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(10002, serverId)
  return positionInfo ~= nil and positionInfo.uid == self.uid
end

function PlayerInfo:IsPosition(positionId, serverId)
  local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(positionId, serverId)
  return positionInfo ~= nil and positionInfo.uid == self.uid
end

function PlayerInfo:GetFullName()
  if string.IsNullOrEmpty(self.allianceId) then
    return self.name
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
    return "[" .. data.abbr .. "] " .. self.name
  end
  return self.name
end

function PlayerInfo:GetFullNameWithSourceServier()
  return self:GetFullNameWithSourceServer()
end

function PlayerInfo:GetFullNameWithSourceServer()
  local server = self:GetSourceServerId()
  if string.IsNullOrEmpty(self.allianceId) then
    return string.format("#%d", server) .. self.name
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
    return string.format("#%d", server) .. "[" .. data.abbr .. "] " .. self.name
  end
  return string.format("#%d ", server) .. self.name
end

function PlayerInfo:GetAllianceAbbr()
  if string.IsNullOrEmpty(self.allianceId) then
    return "???"
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
    return "[" .. data.abbr .. "] "
  end
  return "???"
end

function PlayerInfo:GetFullAllianceName()
  if string.IsNullOrEmpty(self.allianceId) then
    return "???"
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
    return "[" .. data.abbr .. "] " .. data.allianceName
  end
  return "???"
end

function PlayerInfo:GetAllianceName()
  if string.IsNullOrEmpty(self.allianceId) then
    return "???"
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data and data.allianceName then
    return data.allianceName
  end
  return "???"
end

function PlayerInfo:IsInAlliance(isTemp)
  return not string.IsNullOrEmpty(self.allianceId)
end

function PlayerInfo:IsFirstJoinAlliance()
  return self.isFirstJoin == 1 and not self:IsInAlliance()
end

function PlayerInfo:SetFirstJoinAlliance(state)
  self.isFirstJoin = state
end

function PlayerInfo:CheckIfHasFreeAlMove()
  local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceMoveCity)
  if not unlock then
    return false
  end
  if self.lastFreeAlMoveTime == 0 then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local timeSpanM = LuaEntry.DataConfig:TryGetNum("TP_CD", "k1")
  local nextFreeTime = self.lastFreeAlMoveTime + timeSpanM * 60000
  if curTime > nextFreeTime then
    return true
  else
    return false, nextFreeTime
  end
end

function PlayerInfo:UpdatePic(message)
  if message.picVer == nil then
    return
  end
  self.picVer = message.picVer
  self.pic = message.pic or ""
  if message.nextUpdateTime ~= nil then
    Setting:SetPrivateString("nextUpdateHeadPicTime", tostring(message.nextUpdateTime))
  end
  if message.lastUpdateTime then
    LuaEntry.Player:SetLastUpdateTime(message.lastUpdateTime)
  end
  local obj = SFSObject.New()
  obj:PutUtfString("uid", self.uid)
  obj:PutUtfString("pic", self.pic)
  obj:PutInt("picVer", self.picVer)
  EventManager:GetInstance():Broadcast(EventId.UpdateHeadImg, obj)
end

function PlayerInfo:GetPicVer()
  return self.picVer
end

function PlayerInfo:SetAllianceUid(uid)
  self.allianceId = uid
  if CS.GameEntry.Data.Player then
    CS.GameEntry.Data.Player:SetAllianceId(uid)
  end
end

function PlayerInfo:GetAllianceUid()
  return self.allianceId
end

function PlayerInfo:SetLastFreeMvTime(lastTime)
  self.lastFreeAlMoveTime = lastTime
end

function PlayerInfo:GetHeadBgImg()
  return DataCenter.DecorationDataManager:GetSelfHeadFrame()
end

function PlayerInfo:GetHeadBgET()
  return DataCenter.DecorationDataManager:GetSelfHeadFrameAndET()
end

function PlayerInfo:SetLastUpdateTime(lastUpdateTime)
  self.lastUpdateTime = toInt(lastUpdateTime)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SET_INFO)
end

function PlayerInfo:SetProtectTimeStamp(timeStamp)
  self.ProtectTimeStamp = timeStamp
end

function PlayerInfo:SetResourceProtectTimeStamp(timeStamp)
  self.ResourceProtectTimeStamp = timeStamp
end

function PlayerInfo:GetValue(strKey)
  if self[strKey] then
    return self[strKey]
  end
  return nil
end

function PlayerInfo:SetValue(strKey, value)
  self[strKey] = value
end

function PlayerInfo:GetABTestTableName(tableName)
  if tableName == TableName.LW_EASY_STAGE_FEATURE_CHAPTER and self:IsEasyStageFeatureChapterNewbieB() then
    return TableName.LW_EASY_STAGE_FEATURE_CHAPTER_B
  end
  if tableName == TableName.DETECT_LEVEL and self:IsMonopolyDetectB() then
    return TableName.DETECT_LEVEL_B
  end
  if tableName == TableName.LW_ARMED_UPGRADE and LuaEntry.Player.JPUser then
    return TableName.LW_ARMED_UPGRADE_JP
  end
  if self:IsCivilizationSparkB() then
    if tableName == TableName.SingleMapPosition then
      return TableName.SingleMapPosition_B
    end
    if tableName == TableName.Chapter then
      return TableName.Chapter_B
    end
    if tableName == TableName.LandLock then
      return TableName.LandLock_B
    end
    if tableName == TableName.LW_Trigger_Item then
      return TableName.LW_Trigger_Item_B
    end
    if tableName == TableName.LW_Guide_Flow then
      return TableName.LW_Guide_Flow_B
    end
    if tableName == TableName.LW_Opening_Stage then
      return TableName.LW_Opening_Stage_B
    end
    if tableName == TableName.LW_Monopoly then
      return TableName.LW_Monopoly_B
    end
    if tableName == TableName.Building then
      return TableName.Building_B
    end
    if tableName == TableName.LW_FUNCTION_UNLOCK then
      return TableName.LW_FUNCTION_UNLOCK_B
    end
    if tableName == TableName.LW_Stage_Feature then
      return TableName.LW_Stage_Feature_B
    end
    if tableName == TableName.BuildZone then
      return TableName.BuildZone_B
    end
    if tableName == TableName.LW_Monster then
      return TableName.LW_Monster_B
    end
  end
  return tableName
end

local _parkourGpuSkinAppearanceMap = {
  [10001] = 10018,
  [10010] = 10040,
  [10011] = 10041,
  [10012] = 10042,
  [10013] = 10043,
  [10014] = 10044,
  [10015] = 10045,
  [10016] = 10046,
  [10017] = 10047,
  [10020] = 10050
}
local _katyushaSpecialStageId = {
  [205] = 9999
}

function PlayerInfo:GetGrayTestParkourStage(id)
  local newId = id
  if _katyushaSpecialStageId[id] ~= nil and DataCenter.HeroTryOutManager:IsKatyushaSpecialBonusFunctionOn() and not DataCenter.HeroTryOutManager:IsHasBoughtFirstPay() then
    newId = _katyushaSpecialStageId[id]
  end
  if not DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.PveGpuSkinFull) then
    return newId
  end
  if newId < 101 or 107 < newId and newId < 201 or 304 < newId then
    return newId
  end
  return newId, _parkourGpuSkinAppearanceMap
end

local _parkourRvoStageID = {
  [203] = true
}

function PlayerInfo:GetGrayTestParkourRvoOptEnable(id)
  if not DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.PveUseRvoOpt) then
    return false
  end
  if self.abTest == nil or self.abTest == ABTestType.A then
    return false
  end
  if _parkourRvoStageID[id] then
    return true
  end
  return false
end

function PlayerInfo:ShowPlayerChangeHeadRedPot()
  local result = UIUtil:IsRedPointCustomizeAvatar()
  return result
end

function PlayerInfo:UpdateKonbiniInfo(info)
  if info.freeBuyCount then
    self.konbiniInfo.freeBuyCount = info.freeBuyCount
  end
  if info.payBuyCount then
    self.konbiniInfo.payBuyCount = info.payBuyCount
  end
  if info.lastBuyTime then
    self.konbiniInfo.lastBuyTime = info.lastBuyTime
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateKonbini)
end

function PlayerInfo:GetKonbiniFreeBuyCountToday()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, (self.konbiniInfo.lastBuyTime or 0) // 1000)
  if not sameDay then
    self.konbiniInfo.freeBuyCount = 0
    self.konbiniInfo.payBuyCount = 0
    self.konbiniInfo.lastBuyTime = curTime
  end
  return self.konbiniInfo.freeBuyCount
end

function PlayerInfo:IsPicUploading()
  return self.picUploading
end

function PlayerInfo:UploadPicStart()
  self.picUploading = true
  UIUtil.ShowTipsId(280180)
  EventManager:GetInstance():Broadcast(EventId.UploadHead_Start)
end

function PlayerInfo:UploadPicEnd()
  self.picUploading = false
  LuaEntry.GlobalData.serverPicVer = 0
  EventManager:GetInstance():Broadcast(EventId.UploadHead_End)
end

function PlayerInfo:SetStaminaData(message)
  self.pveFakeStamina = 0
  local oldStamina = self.stamina
  if message.stamina ~= nil then
    self.stamina = message.stamina
  end
  if message.lastStaminaTime ~= nil then
    self.lastStaminaTime = message.lastStaminaTime
  end
  if oldStamina ~= self.stamina then
    EventManager:GetInstance():Broadcast(EventId.PlayerStaminaUpdate)
  end
end

function PlayerInfo:SetStaminaGoldTime(message)
  if message.playerStaminaGoldTime ~= nil then
    self.playerStaminaGoldTime = message.playerStaminaGoldTime
  end
  if message.playerStaminaGoldNum ~= nil then
    self.playerStaminaGoldNum = message.playerStaminaGoldNum
  end
end

function PlayerInfo:GetCurStaminaGoldNum()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if not UITimeManager:GetInstance():IsSameDayForServer(math.floor(self.playerStaminaGoldTime / 1000), curTime) then
    self.playerStaminaGoldNum = 0
  end
  return self.playerStaminaGoldNum
end

function PlayerInfo:GetCurStamina()
  local num = self.stamina
  num = math.floor(num)
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil and config.FormationStaminaMax > self.stamina then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = curTime - self.lastStaminaTime
    local realStamina = math.floor(deltaTime / (config.FormationStaminaUpdateTime * 1000) + num)
    num = math.min(realStamina, config.FormationStaminaMax)
  end
  num = math.floor(math.max(0, num + self.pveFakeStamina))
  return num
end

function PlayerInfo:GetStaminaFullTime()
  local staminaFullTime = 0
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil and self.stamina and self.lastStaminaTime and config.FormationStaminaMax > self.stamina then
    staminaFullTime = math.floor((config.FormationStaminaMax - self.stamina) * (config.FormationStaminaUpdateTime * 1000) + self.lastStaminaTime)
  end
  return staminaFullTime
end

function PlayerInfo:SetPveStaminaData(message)
  self.pveFakeStamina = 0
  if message.pveStamina ~= nil then
    self.pveStamina = message.pveStamina
  end
  if message.lastPveStaminaTime ~= nil then
    self.lastPveStaminaTime = message.lastPveStaminaTime
  end
end

function PlayerInfo:GetCurPveStamina()
  return self:GetCurStamina()
end

function PlayerInfo:ChangePveStamina(addNum)
  self.pveFakeStamina = self.pveFakeStamina + addNum
end

function PlayerInfo:GetMaxPveStamina()
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil then
    return config.FormationStaminaMax
  end
  return 0
end

function PlayerInfo:SetFoldCrossWormHoleTime(obj)
  if obj.fold_cross_worm_hole_time ~= nil then
    self.fold_cross_worm_hole_time = obj.fold_cross_worm_hole_time
  end
end

function PlayerInfo:GetFoldCrossWormHoleTime()
  return self.fold_cross_worm_hole_time
end

function PlayerInfo:IsInBlackRange(signLog)
  if BattleFieldUtil.InBattleField() then
    return false
  end
  local pointId = self.world_main_pos
  local sId = self:GetSelfServerId()
  local flag = SceneUtils.IsInBlackRange(pointId, sId)
  if signLog and flag then
    local v2 = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
    local info = SeasonUtil.GetSeasonInfo(sId)
    local seasonId = info and info.seasonId or "?"
    local a, b, c, d = DataCenter.BirthPointTemplateManager:GetBlackLandRange(sId)
    if v2.x >= a.x and v2.x <= b.x and v2.y <= a.y and v2.y >= d.y then
      local log = string.format("[IsInBlackRange] pt=%s | pos=%s,%s | sId=%s | season=%s | rect=%s,%s,%s,%s", pointId, v2.x, v2.y, sId, seasonId, a.x, b.x, a.y, d.y)
      Logger.LogInfo(log)
      return true
    end
  end
  return flag
end

function PlayerInfo:IsInCityField(signLog)
  if BattleFieldUtil.InBattleField() then
    return false
  end
  local loginServerId = self:GetSelfServerId()
  local flag = SceneUtils.IsInCityField(self.world_main_pos, loginServerId)
  if signLog and flag then
    local info = SeasonUtil.GetSeasonInfo(loginServerId)
    local seasonId = info and info.seasonId or "?"
    local log = string.format("[IsInCityField] pt=%s | sId=%s | season=%s", self.world_main_pos, loginServerId, seasonId)
    Logger.LogInfo(log)
  end
  return flag
end

function PlayerInfo:GetMainWorldPos()
  if BattleFieldUtil.InBattleField() then
    return self.dragon_main_pos
  end
  return self.world_main_pos
end

function PlayerInfo:GetBattleFieldPos()
  return self.dragon_main_pos or 0
end

function PlayerInfo:SyncBattleFieldPos(pos)
  self.dragon_main_pos = pos
  pcall(function()
    if self.csBuilding then
      self.csBuilding:UpdateDragonWorldPos(self.dragon_main_pos)
    end
  end)
end

function PlayerInfo:SetBattleFieldPointId(pointId)
  if 0 < pointId then
    local posV3 = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    if posV3 ~= nil then
      posV3.x = posV3.x
      posV3.z = posV3.z
      self:SyncBattleFieldPos(SceneUtils.WorldToTileIndex(posV3, ForceChangeScene.World))
    end
    EventManager:GetInstance():Broadcast(EventId.SetMainWorldPointId)
  else
    self:SyncBattleFieldPos(pointId)
  end
end

function PlayerInfo:SetMainWorldPointId(pointId)
  if BattleFieldUtil.InBattleField() then
    self:SetBattleFieldPointId(pointId)
    self:UpdateCsharpPlayerWorldPointId(-1)
    return
  end
  if 0 < pointId then
    local posV3 = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    if posV3 ~= nil then
      posV3.x = posV3.x
      posV3.z = posV3.z
      self.world_main_pos = SceneUtils.WorldToTileIndex(posV3, ForceChangeScene.World)
    end
    EventManager:GetInstance():Broadcast(EventId.SetMainWorldPointId)
  else
    self.world_main_pos = pointId
  end
  self:UpdateCsharpPlayerWorldPointId(pointId)
  if SeasonUtil.IsInSeasonDarknessMode(true) then
    SFSNetwork.SendMessage(MsgDefines.FetchPowerWorkerDetail)
    SFSNetwork.SendMessage(MsgDefines.FetchCityLightStatusInfo)
  end
end

function PlayerInfo:UpdateCsharpPlayerWorldPointId(pointId)
  if CS.GameEntry.Data.Player.UpdatePlayerWorldPointId ~= nil then
    CS.GameEntry.Data.Player:UpdatePlayerWorldPointId(pointId)
  end
end

function PlayerInfo:InitFirstFreeAlliance(tbl)
  self.firstFreeAlliance = tbl
end

function PlayerInfo:CanFreeAllianceMove(markType)
  if not self:IsInAlliance() then
    return false
  end
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  if sourceServerId and 0 < sourceServerId then
    if markType == MarkType.Alliance_rally and not LuaEntry.Player:IsLoginSourceServer() then
      if SeasonUtil.InSeasonBigMapMode(sourceServerId) then
        if not SeasonUtil.IsInSameGroup(selfServerId) then
          return true
        end
      else
        return true
      end
    elseif markType == MarkType.Alliance_OtherServerRally and not SeasonUtil.IsInSameGroup(selfServerId) then
      return true
    end
  end
  if DataCenter.AllianceBaseDataManager:IsSelfLeader() then
    return false
  end
  local k1 = LuaEntry.DataConfig:TryGetNum("free_teleport_time", "k1")
  if k1 <= table.count(self.firstFreeAlliance) then
    return false
  end
  if self.firstFreeAlliance then
    for k, v in ipairs(self.firstFreeAlliance) do
      if v == self.allianceId then
        return false
      end
    end
  end
  return true
end

function PlayerInfo:IsMeOrMyAlly(uid, allianceUid)
  if self:GetUid() == uid then
    return true
  end
  if self:IsInAlliance() and self:GetAllianceUid() == allianceUid then
    return true
  end
  return false
end

function PlayerInfo:IsFromBIGCHINAorUsingLangZH()
  if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    return false
  end
  local fromCN = self.regCountry == "CN" or self.regCountry == "HK" or self.regCountry == "TW" or self.regCountry == "MO"
  local lang = CS.GameEntry.Localization:GetLanguage()
  local langZH = lang == Language.ChineseSimplified or lang == Language.ChineseTraditional
  local notGM = self.gmFlag <= 0
  return (fromCN or langZH) and notGM
end

function PlayerInfo:GetGoldBrickInfos()
  if self.goldBrickInfos == nil then
    self.goldBrickInfos = {}
    return {}
  end
  return DeepCopy(self.goldBrickInfos)
end

function PlayerInfo:GetUserRegDay()
  local now = UITimeManager:GetInstance():GetServerTime() / 1000
  local reg = LuaEntry.Player.regTime / 1000
  local day1 = 86400
  local userRegDay = (now - reg) / day1 + 1
  return userRegDay
end

function PlayerInfo:IsContainCountry(country)
  if self.serverCountryList then
    if table.count(self.serverCountryList) == 0 then
      return true
    end
    return self.serverCountryList[country] ~= nil
  end
end

function PlayerInfo:UpdateUserSetting(userSetting)
  self.userSetting = {}
  if userSetting then
    for k, v in pairs(userSetting) do
      self.userSetting[tonumber(k)] = v
    end
  end
end

function PlayerInfo:SetUserSetting(key, value)
  if not self.userSetting then
    self.userSetting = {}
  end
  if self.userSetting[key] == value then
    return
  end
  self.userSetting[key] = value
  EventManager:GetInstance():Broadcast(EventId.UserSettingChanged, key)
  if key == UserSettingKey.ActivityAlarmClock then
    local showServerTime = value == "1"
    EventManager:GetInstance():Broadcast(EventId.UpdateActivityAlarmClockBuildingTimeShow, showServerTime)
  end
end

function PlayerInfo:GetUserSetting(key)
  if not self.userSetting then
    self.userSetting = {}
  end
  return self.userSetting[key]
end

function PlayerInfo:IsKillMonster(monsterId)
  return self.killMonsterIds[monsterId] ~= nil
end

function PlayerInfo:IsNewGuideB()
end

function PlayerInfo:IsMonopolyDetectB()
  if self.monopolyDetectB ~= nil then
    return self.monopolyDetectB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.monopolyDetectB = self.monopoly_ab == 1
  return self.monopolyDetectB
end

function PlayerInfo:IsNewbiesStageB()
  if self.newbiesStageB ~= nil then
    return self.newbiesStageB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.newbiesStageB = self.monopoly_ab == 2
  return self.newbiesStageB
end

function PlayerInfo:IsEasyStageFeatureBoxRewardB()
  if self.easyStageFeatureBoxRewardB ~= nil then
    return self.easyStageFeatureBoxRewardB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.easyStageFeatureBoxRewardB = self.monopoly_ab == 3
  return self.easyStageFeatureBoxRewardB
end

function PlayerInfo:IsSkyBattleNormalChapterB()
  if self.skyBattleNormalChapterB ~= nil then
    return self.skyBattleNormalChapterB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.skyBattleNormalChapterB = self.monopoly_ab == 8
  return self.skyBattleNormalChapterB
end

function PlayerInfo:IsFirstPayB()
  if self.firstPayB ~= nil then
    return self.firstPayB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.firstPayB = self.monopoly_ab == 5
  return self.firstPayB
end

function PlayerInfo:IsEasyStageFeatureChapterNewbieB()
  if self.easyStageFeatureChapterNewbieB ~= nil then
    return self.easyStageFeatureChapterNewbieB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.easyStageFeatureChapterNewbieB = self.monopoly_ab == 6
  return self.easyStageFeatureChapterNewbieB
end

function PlayerInfo:IsWaterBottleStageNewbieB()
  if self.monopolyAndLWOpeningStageNewbieB ~= nil then
    return self.monopolyAndLWOpeningStageNewbieB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.monopolyAndLWOpeningStageNewbieB = self.monopoly_ab == 7
  return self.monopolyAndLWOpeningStageNewbieB
end

function PlayerInfo:IsHeroAppearanceB()
  if self.heroAppearanceB ~= nil then
    return self.heroAppearanceB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.heroAppearanceB = self.monopoly_ab == 10
  return self.heroAppearanceB
end

function PlayerInfo:IsMaxAdB()
  if self.maxAdB ~= nil then
    return self.maxAdB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.maxAdB = self.monopoly_ab == 13
  return self.maxAdB
end

function PlayerInfo:IsKatyushaSpecialBonusStageB()
  if self.katyushaSpacialBonusStageB ~= nil then
    return self.katyushaSpacialBonusStageB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.katyushaSpacialBonusStageB = self.monopoly_ab == 16
  return self.katyushaSpacialBonusStageB
end

function PlayerInfo:IsMonicaArmamentUpgradeB()
  if self.monicaArmamentUpgradeB ~= nil then
    return self.monicaArmamentUpgradeB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.monicaArmamentUpgradeB = self.monopoly_ab == 9 or 0 < self.armed_upgrade_tag
  return self.monicaArmamentUpgradeB
end

function PlayerInfo:IsCivilizationSparkB()
  if self.civilizationSparkB ~= nil then
    return self.civilizationSparkB
  end
  if not self.monopoly_ab or self.monopoly_ab < 0 then
    return false
  end
  self.civilizationSparkB = self.monopoly_ab == 18
  return self.civilizationSparkB
end

function PlayerInfo:UpdateGold(user)
  if user.paidGold then
    self.paidGoid = user.paidGold
  end
  if user.gold1 then
    self.gold1 = user.gold1
  end
end

function PlayerInfo:UpdateGoldBrickDetail(user)
  if user.freeCount then
    self.freeGoldBrick = user.freeCount
  end
  if user.paidCount then
    self.paidGoldBrick = user.paidCount
  end
end

function PlayerInfo:GetFreeGold()
  return self.gold1 or 0
end

function PlayerInfo:GetPaidGold()
  return self.paidGoid or 0
end

function PlayerInfo:GetFreeGoldBrick()
  return self.freeGoldBrick or 0
end

function PlayerInfo:GetPaidGoldBrick()
  return self.paidGoldBrick or 0
end

function PlayerInfo:GetNewBeeMigrateWay()
  return self.newBeeMigrateWay or 0
end

function PlayerInfo:ClearNewBeeMigrate()
  self.newBeeMigrateWay = 0
  self.newBeeMigrateServer = 0
  self.immigrateSoldierLv = 0
  self.immigrateSoldierCount = 0
end

function PlayerInfo:OnHandleNewBeeMigrate(t)
  self.newBeeMigrateWay = t.newBeeImmigrateWay or 0
  self.newBeeMigrateServer = t.newBeeImmigrateServer or 0
  self.immigrateSoldierLv = t.immigrateSoldierLv or 0
  self.immigrateSoldierCount = t.immigrateSoldierCount or 0
  if self.newBeeMigrateWay > 0 then
    Logger.LogInfo("[PlayerInfo:OnHandleNewBeeMigrate] newBeeMigrateWay=", self.newBeeMigrateWay)
  else
    Logger.Log("[PlayerInfo:OnHandleNewBeeMigrate] newBeeMigrateWay=", self.newBeeMigrateWay)
  end
  if self.newBeeMigrateWay > 0 and self.newBeeMigrateWay % 2 == 1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUINewBeeMigrateLoading, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

function PlayerInfo:SendGetOtherServerInfo(_serverId)
  local serverId = tonumber(_serverId)
  if serverId == nil or serverId < 0 then
    return
  end
  if self.otherServerOpenTimeDict == nil or self.otherServerOpenTimeDict[serverId] == nil or self.otherServerOpenTimeDict[serverId] == 0 then
    if self.otherServerOpenTimeReqDict == nil then
      self.otherServerOpenTimeReqDict = {}
    end
    local now = UITimeManager:GetInstance():GetServerSeconds()
    local lastReqTime = self.otherServerOpenTimeReqDict[serverId]
    if lastReqTime == nil or now ~= lastReqTime then
      SFSNetwork.SendMessage(MsgDefines.GetOtherServerInfo, serverId)
      self.otherServerOpenTimeReqDict[serverId] = now
    end
  end
end

function PlayerInfo:SetCheckServerOpenTime(time, serverId)
  if self.otherServerOpenTimeDict == nil then
    self.otherServerOpenTimeDict = {}
  end
  self.otherServerOpenTimeDict[serverId] = time
  Logger.LogInfo(string.format("SetCheckServerOpenTime time:%s serverId:%s", time, serverId))
end

function PlayerInfo:GetCheckServerOpenTime()
  local serverStartTime = self.curServerOpenTime
  if not self:IsInSelfServer() then
    local serverId = self:GetCurServerId()
    if self.otherServerOpenTimeDict then
      serverStartTime = self.otherServerOpenTimeDict[serverId]
      if serverStartTime == nil or serverStartTime == 0 then
        Logger.LogInfo(string.format("GetCheckServerOpenTime serverId:%s", serverId))
      end
    else
      Logger.LogInfo(string.format("Not SendGetOtherServerInfo serverId:%s", serverId))
    end
  end
  return serverStartTime
end

function PlayerInfo:GetStoreInfo()
  if self.hasStoreCurrency == nil then
    return nil
  end
  return self.hasStoreCurrency == true
end

function PlayerInfo:UpdateStoreInfo()
  self.hasStoreCurrency = true
end

function PlayerInfo:RefreshSeasonRole(t)
  if self.seasonRole == nil then
    self.seasonRole = {}
  end
  self.seasonRole.tag = t.tag
  self.seasonRole.tagTime = t.tagTime
end

function PlayerInfo:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("----\231\142\169\229\174\182\228\191\161\230\129\175----")
  sb:AppendFormatLine("deviceId = %s", self.deviceId)
  sb:AppendFormatLine("uuid = %s", self.uuid)
  sb:AppendFormatLine("uid = %s", self.uid)
  sb:AppendFormatLine("name = %s", self.name)
  sb:AppendFormatLine("level = %s", self.level)
  sb:AppendFormatLine("serverId = %s", self.serverId)
  sb:AppendFormatLine("serverType = %s", self.serverType)
  sb:AppendFormatLine("openServerTime = %s", self.openServerTime)
  sb:AppendFormatLine("----\230\156\141\229\138\161\229\153\168\228\191\161\230\129\175----")
  sb:AppendFormatLine("[\229\142\159\230\156\141]GetSourceServerId = %s", self:GetSourceServerId())
  sb:AppendFormatLine("[\231\153\187\229\189\149\230\156\141]GetSelfServerId = %s", self:GetSelfServerId())
  sb:AppendFormatLine("[\229\189\147\229\137\141\232\167\130\231\156\139\230\156\141]GetCurServerId = %s", self:GetCurServerId())
  sb:AppendFormatLine("[\232\167\130\231\156\139\230\156\141\229\146\140\229\142\159\230\156\141\230\152\175\229\144\166\228\184\128\232\135\180]IsInSourceServer = %s", self:IsInSourceServer())
  sb:AppendFormatLine("[\231\153\187\229\189\149\230\156\141\229\146\140\229\142\159\230\156\141\230\152\175\229\144\166\228\184\128\232\135\180]IsLoginSourceServer = %s", self:IsLoginSourceServer())
  sb:AppendFormatLine("[\232\167\130\231\156\139\230\156\141\229\146\140\231\153\187\229\189\149\230\156\141\230\152\175\229\144\166\228\184\128\232\135\180]IsInSelfServer = %s", self:IsInSelfServer())
  sb:AppendFormatLine("[\230\152\175\229\144\166\229\176\177\229\156\168\229\142\159\230\156\141]AtHomeNow = %s", self:AtHomeNow())
  return sb:ToString()
end

function PlayerInfo:SeaonRoleState()
  if self.seasonRole == nil or self.seasonRole.tag == nil or self.seasonRole.tagTime == nil then
    return -1
  end
  if self.seasonRole.tag == 0 and self.seasonRole.tagTime == 0 then
    return 1
  end
  if self.seasonRole.tag == 1 and self.seasonRole.tagTime ~= 0 then
    return 2
  end
  if self.seasonRole.tag == 0 and self.seasonRole.tagTime ~= 0 then
    return 3
  end
  return -1
end

function PlayerInfo:AddUnpackResourceReward(resId)
  self.unpackResourceReward[toInt(resId)] = true
end

function PlayerInfo:CheckUnpackResourceReward(resId)
  return self.unpackResourceReward[toInt(resId)]
end

function PlayerInfo:OnLevelUpdate(newLv)
  if not self.level or newLv > self.level then
    local str = string.format("%s;%s;%s;%s", newLv, self.serverId, LuaEntry.Player.uid, CS.GameEntry.Resource:GetResVersion())
    if self.openServerTime and self.openServerTime ~= 0 then
      local sourceServerOpenDays = UITimeManager:GetInstance():GetServerOpenDaysByTimeStamp(self.openServerTime)
      str = str .. ";" .. sourceServerOpenDays
    end
    CS.GameEntry.Resource:SyncGameLogicInfo(str)
  end
end

function PlayerInfo:SyncOpenServerTime()
  if self.openServerTime == nil or self.openServerTime == 0 then
    return
  end
  local sourceServerOpenDays = UITimeManager:GetInstance():GetServerOpenDaysByTimeStamp(self.openServerTime)
  local str = string.format("%s;%s;%s;%s;%s", self.level, self.serverId, LuaEntry.Player.uid, CS.GameEntry.Resource:GetResVersion(), sourceServerOpenDays)
  CS.GameEntry.Resource:SyncGameLogicInfo(str)
end

function PlayerInfo:SwitchOpenOrAtHomeNow(switch)
  return LuaEntry.DataConfig:CheckSwitch(switch) or self:AtHomeNow()
end

function PlayerInfo:SwitchOpenOrIsLoginSourceServer(switch)
  return LuaEntry.DataConfig:CheckSwitch(switch) or self:IsLoginSourceServer()
end

function PlayerInfo:GetAlreadyBuyGoldBrick()
  return self.alreadyBuyGoldBrick
end

function PlayerInfo:GetGoldBrickSwitch()
  return self.goldBrickSwitch
end

function PlayerInfo:SetGoldBrickSwitch(enabled)
  self.goldBrickSwitch = enabled == true
end

function PlayerInfo:GetMainBuildUUID()
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  return mainBuild and mainBuild.uuid
end

function PlayerInfo:IsOpenReturnOpt()
  return DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.PveReturnOpt)
end

return PlayerInfo
