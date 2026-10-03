local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local ActivityCityBattleLod45 = BaseClass("ActivityCityBattleLod45", base)
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local occupy_path = "LOD45"
local nameText_path = "LOD45/LOD45_name"
local arrow_path = "LOD45/LOD45_arrow"
local COLOR_MY = Color.New(0.5294117647058824, 0.8823529411764706, 1, 1)
local COLOR_ENEMY = Color.New(1, 0.6941176470588235, 0.6941176470588235, 1)

function ActivityCityBattleLod45:__init(gameObject)
  base.__init(self, gameObject)
  self.occupyRoot = self.transform:Find(occupy_path).gameObject
  self.bg = self.transform:Find(occupy_path):GetComponent(typeof(SpriteRenderer))
  self.name_text = self.transform:Find(nameText_path):GetComponent(typeof(CS.TextMeshProEx))
  self.arrow = self.transform:Find(arrow_path):GetComponent(typeof(SpriteRenderer))
  self.name_spr = self.transform:Find("NameLabel").gameObject
  self.lv_spr = self.transform:Find("LevelLabel").gameObject
  self.occupyRoot:SetActive(false)
end

function ActivityCityBattleLod45:__delete()
  self.occupyInfo = nil
  self.occupyRoot:SetActive(false)
  base.__delete(self)
end

function ActivityCityBattleLod45:OnKingOccupyProgressRefresh()
  base.UpdateCityInfo(self)
  self:DoRefresh()
end

function ActivityCityBattleLod45:OnPointDateUpdate()
  base.UpdateCityInfo(self)
  self:DoRefresh()
end

function ActivityCityBattleLod45:OnWorldAllianceCityDetail()
  base.UpdateCityInfo(self)
  self:DoRefresh()
end

function ActivityCityBattleLod45:SetLod(lod)
  base.SetLod(self, lod)
  self:DoRefresh()
end

function ActivityCityBattleLod45:CheckLod(lod)
  base.CheckLod(self, lod)
  self:DoRefresh()
end

function ActivityCityBattleLod45:ReInit(data)
  base.ReInit(self, data)
end

function ActivityCityBattleLod45:TimerAction()
  if not self.isKingCity or not self:BTarget() then
    self.occupyRoot:SetActive(false)
    self:DeleteTimer()
    return
  end
  local occupyInfo = self.occupyInfo
  if occupyInfo == nil or occupyInfo.startTime == nil then
    return
  end
  local passSec = 0
  local startTime = toInt(occupyInfo.startTime)
  if 1700000000000 < startTime then
    passSec = (UITimeManager:GetInstance():GetServerTime() - startTime) / 1000
  else
    passSec = UITimeManager:GetInstance():GetServerSeconds() - startTime
  end
  local point = occupyInfo.point + occupyInfo.point_add * passSec
  local rate = string.percentage(point, occupyInfo.point_max, 2)
  self.name_text.text = string.format("#%s [%s] %s", occupyInfo.serverId, occupyInfo.abbr, rate)
end

function ActivityCityBattleLod45:BTarget()
  if self.data == nil or self.theExtraInfo == nil then
    return false
  end
  if (self.lodCache == 4 or self.lodCache == 5) and (self.isKingCity or self.cityType == WorldAllianceCityType.Canon or self.cityType == WorldAllianceCityType.MissileFactory) then
    return true
  end
  return false
end

function ActivityCityBattleLod45:BgLoad(bAlly)
  local bgFile = bAlly and "mjc_wzz_jijianshitubg_lan" or "mjc_wzz_jijianshitubg_hong.png"
  self.bg:LoadSprite(string.format(LoadPath.LodIcon, bgFile))
  self.arrow.color = bAlly and COLOR_MY or COLOR_ENEMY
end

function ActivityCityBattleLod45:RefreshCross()
  local flag, bAlly = false, false
  self.occupyInfo = nil
  local extraInfo = self.theExtraInfo
  local buildPointInfo = extraInfo.buildPointInfo
  local buildStartTime = extraInfo.buildStartTime
  local currentData = DataCenter.GovernmentManager:GetKingOccupyPlayer(self.serverId)
  if currentData then
    local serverBuildPoint = currentData.serverBuildPoint
    local serverBuildStartTime = currentData.serverBuildStartTime
    if serverBuildPoint and serverBuildStartTime ~= nil and serverBuildStartTime ~= 0 then
      buildPointInfo = serverBuildPoint
      buildStartTime = serverBuildStartTime
    end
  end
  local pCnt = buildPointInfo ~= nil and #buildPointInfo or 0
  if buildStartTime == nil or buildStartTime == 0 or pCnt == 0 then
    return flag, bAlly
  end
  local isBattleMember = SeasonUtil.IsBattleMember(self.serverId)
  if not isBattleMember and pCnt ~= 2 then
    return flag, bAlly
  end
  local ownerServerId = extraInfo.serverId
  local ownerAllianceId = extraInfo.allianceId
  local ownerAbbr = extraInfo.alAbbr
  local enemyServer, enemyAllianceId, enemyAbbr = SeasonUtil.GetMyEnemyServerNow(ownerServerId, ownerAllianceId)
  for _, v in ipairs(buildPointInfo) do
    if not SeasonUtil.IsAlly(ownerServerId, v.serverId, ownerAllianceId, v.allianceId) then
      enemyServer = v.serverId
      enemyAllianceId = v.allianceId
      enemyAbbr = v.allianceAbbr
    end
  end
  local addPoint = SeasonUtil.GetWorldBattlePointSpeed(self.serverId)
  local myPoint = {
    buildPoint = 0,
    serverId = ownerServerId,
    buildSpeed = addPoint,
    campId = 0,
    allianceId = ownerAllianceId,
    allianceAbbr = ownerAbbr
  }
  local targetPoint = {
    buildPoint = 0,
    serverId = enemyServer,
    buildSpeed = addPoint,
    campId = 0,
    allianceId = enemyAllianceId,
    allianceAbbr = enemyAbbr
  }
  for _, v in ipairs(buildPointInfo) do
    if SeasonUtil.IsAlly(ownerServerId, v.serverId, ownerAllianceId, v.allianceId) then
      myPoint = v
    elseif SeasonUtil.IsAlly(enemyServer, v.serverId, enemyAllianceId, v.allianceId) then
      targetPoint = v
    end
  end
  self.occupyInfo = {
    point = myPoint.buildPoint,
    startTime = buildStartTime,
    abbr = extraInfo.alAbbr,
    serverId = ownerServerId,
    point_max = SeasonUtil.GetWorldBattleTotalPoint(self.serverId),
    point_add = myPoint.buildSpeed
  }
  flag = true
  bAlly = SeasonUtil.IsAlly(ownerServerId, LuaEntry.Player:GetSourceServerId(), ownerAllianceId)
  return flag, bAlly
end

function ActivityCityBattleLod45:RefreshLocal()
  local flag, bAlly = false, false
  self.occupyInfo = nil
  local extraInfo = self.theExtraInfo
  local curPresident = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
  if curPresident ~= nil or extraInfo.state ~= AllianceCityState.BUILDING then
    return flag, bAlly
  end
  local occupyPlayer = DataCenter.GovernmentManager:GetKingOccupyPlayer(self.serverId)
  if occupyPlayer == nil then
    local kingOccupyList = DataCenter.GovernmentManager:GetKingOccupyList(self.serverId)
    if kingOccupyList ~= nil then
      for _, v in ipairs(kingOccupyList) do
        if v and v.isBuilding == 1 then
          occupyPlayer = v
          break
        end
      end
    end
  end
  if occupyPlayer == nil then
    local alAbbr = extraInfo.alAbbr
    local buildPoint = extraInfo.buildPoint
    local buildStartTime = extraInfo.buildStartTime
    if buildStartTime ~= nil and buildStartTime ~= 0 and buildStartTime ~= "" then
      self.occupyInfo = {
        point = buildPoint,
        startTime = buildStartTime,
        abbr = alAbbr
      }
    end
  else
    self.occupyInfo = {
      point = occupyPlayer.point,
      startTime = occupyPlayer.startTime,
      abbr = occupyPlayer.abbr
    }
  end
  flag = self.occupyInfo ~= nil
  if flag then
    self.occupyInfo.serverId = self.serverId or LuaEntry.Player:GetCurServerId()
    self.occupyInfo.point_max = SeasonUtil.GetPresidentOccupationRate("k2", 28800)
    self.occupyInfo.point_add = SeasonUtil.GetPresidentOccupationRate("k1", 1)
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local abbr = data ~= nil and data.abbr or nil
    bAlly = abbr ~= nil and self.occupyInfo.abbr == abbr
  end
  return flag, bAlly
end

function ActivityCityBattleLod45:RefreshCanon()
  local flag, bAlly = false, false
  local extraInfo = self.theExtraInfo
  if not self.isCrossServerThrone or extraInfo.state ~= AllianceCityState.SERVER_BUILD_THRONE then
    self.ownerName = nil
    return flag, bAlly
  end
  flag = true
  local isBattleMember = SeasonUtil.IsBattleMember(self.serverId)
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local ownerServerId = extraInfo.serverId
  local ownerAllianceId = extraInfo.allianceId
  bAlly = isBattleMember and SeasonUtil.IsAlly(ownerServerId, sourceServerId, ownerAllianceId)
  local ownerName
  if string.IsNullOrEmpty(extraInfo.alAbbr) then
    local cityDetail = self.theCityDetail
    local defendInfo
    if cityDetail ~= nil and cityDetail.defenceList then
      defendInfo = cityDetail.defenceList[1]
    end
    if defendInfo and not string.IsNullOrEmpty(defendInfo.alAbbr) then
      ownerName = string.format("#%s [%s]", ownerServerId, defendInfo.alAbbr)
    end
  else
    ownerName = string.format("#%s [%s]", ownerServerId, extraInfo.alAbbr)
  end
  if string.IsNullOrEmpty(ownerName) then
    flag = false
    bAlly = false
  else
    self.name_text.text = ownerName
  end
  return flag, bAlly
end

function ActivityCityBattleLod45:DoRefresh()
  local flag, bAlly = false, false
  if self:BTarget() then
    if self.isKingCity then
      if self.isCrossServerThrone then
        flag, bAlly = self:RefreshCross()
      else
        flag, bAlly = self:RefreshLocal()
      end
    else
      flag, bAlly = self:RefreshCanon()
    end
  end
  self.occupyRoot:SetActive(flag)
  if flag then
    self.name_spr:SetActive(false)
    self.lv_spr:SetActive(false)
    self:BgLoad(bAlly)
    if self.isKingCity then
      self:TimerAction()
      self:AddTimer()
    else
      self:DeleteTimer()
    end
  else
    self.name_spr:SetActive(self.cityType ~= WorldAllianceCityType.Canon and self.cityType ~= WorldAllianceCityType.MissileFactory)
    self.lv_spr:SetActive(self.cityType ~= WorldAllianceCityType.Canon and self.cityType ~= WorldAllianceCityType.MissileFactory)
    self:DeleteTimer()
  end
end

return ActivityCityBattleLod45
