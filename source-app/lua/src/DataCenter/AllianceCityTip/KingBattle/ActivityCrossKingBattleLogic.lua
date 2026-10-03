local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local ActivityCrossKingBattleLogic = BaseClass("ActivityCrossKingBattleLogic", base)
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local Localization = CS.GameEntry.Localization

function ActivityCrossKingBattleLogic:__init(gameObject)
  base.__init(self, gameObject)
  self.ThroneOccupyRoot = self.transform:Find("ThroneOccupy").gameObject
  self.throneKing_pro1bg = self.transform:Find("ThroneOccupy/proBg1"):GetComponent(typeof(SpriteRenderer))
  self.throneKing_pro2bg = self.transform:Find("ThroneOccupy/proBg2"):GetComponent(typeof(SpriteRenderer))
  self.throneKing_pro1 = self.transform:Find("ThroneOccupy/pro1/pro1"):GetComponent(typeof(SpriteRenderer))
  self.throneKing_pro2 = self.transform:Find("ThroneOccupy/pro2/pro2"):GetComponent(typeof(SpriteRenderer))
  self.throneKing_pro_num1 = self.transform:Find("ThroneOccupy/pro1/pro_num1"):GetComponent(typeof(SuperTextMesh))
  self.throneKing_pro_num2 = self.transform:Find("ThroneOccupy/pro2/pro_num2"):GetComponent(typeof(SuperTextMesh))
  self.throneKing_pro_server1 = self.transform:Find("ThroneOccupy/pro1/pro_server1"):GetComponent(typeof(SuperTextMesh))
  self.throneKing_pro_server2 = self.transform:Find("ThroneOccupy/pro2/pro_server2"):GetComponent(typeof(SuperTextMesh))
  self.throneKing_pro_camper1 = self.transform:Find("ThroneOccupy/pro1/IconCampA"):GetComponent(typeof(SpriteRenderer))
  self.throneKing_pro_camper2 = self.transform:Find("ThroneOccupy/pro2/IconCampB"):GetComponent(typeof(SpriteRenderer))
  self.throneKing_title = self.transform:Find("ThroneOccupy/titleThrone"):GetComponent(typeof(SuperTextMesh))
  self.throneKing_occupy_btn = self.transform:Find("ThroneOccupy/btnThrone"):GetComponent(typeof(TouchObjectEventTrigger))
  
  function self.throneKing_occupy_btn.onPointerClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.CrossOccupyRankDetail, {anim = true}, self.serverId)
  end
  
  self.throneKing_occupy_btn.previewType = CS.WorldPreviewType.GUI
  self.ThroneOccupyRoot:SetActive(false)
  self.timer_tick = 0.1
end

function ActivityCrossKingBattleLogic:__delete()
  self.throneKing_occupy_btn.onPointerClick = nil
  self.ThroneOccupyRoot:SetActive(false)
  base.__delete(self)
end

function ActivityCrossKingBattleLogic:TimerAction()
  if self.isCrossServerThrone and self.throneKingOccupyPoint and self.throneKingBuildStartTime and self.throneKingOccupyPointAdd and self.allianceCityPointInfo and self.allianceCityPointInfo.serverId ~= nil and self.allianceCityPointInfo.serverId ~= 0 then
    local totalPoint = SeasonUtil.GetWorldBattleTotalPoint(self.serverId)
    local addPoint = self.throneKingOccupyPointAdd
    local Seconds = UITimeManager:GetInstance():GetServerSeconds() - self.throneKingBuildStartTime
    local pointNow = self.throneKingOccupyPoint + addPoint * Seconds
    local rate = math.min(pointNow / totalPoint, 1.0)
    self.throneKing_pro1:Set_size(1.72 * rate, 0.2)
    self.throneKing_pro_num1.text = math.floor(rate * 10000) * 0.01 .. "%"
    local remainTime = DataCenter.ZoneWarManager:CalcOccupyTime(pointNow, addPoint)
    local winnerInfo = self:GetWinnerInfo(pointNow, addPoint, remainTime)
    if not winnerInfo then
      return
    end
    local max_size = 0.2
    self.throneKing_title.size = max_size
    local colorA, colorA32 = SeasonUtil.GetWorldBattleColor(not SeasonUtil.IsAlly(winnerInfo.serverId, nil, winnerInfo.allianceId))
    self.throneKing_title.color = colorA32
    local name = SeasonUtil.GetWorldBattleName(winnerInfo, false, nil, self.serverId, true)
    if 0 < remainTime then
      local str = Localization:GetString("801482", name, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.throneKing_title.text = str
    else
      local str = Localization:GetString("801485", name)
      self.throneKing_title.text = str
    end
    local textWidth = self.throneKing_title:GetWidth()
    if 2.5 < textWidth then
      for i = 1, 15 do
        max_size = max_size - 0.01
        self.throneKing_title.size = max_size
        textWidth = self.throneKing_title:GetWidth()
        if textWidth < 2.5 then
          break
        end
      end
    end
    self.throneKing_title.transform:Set_localPosition(-textWidth * 0.5, 0.22, 0)
  end
end

function ActivityCrossKingBattleLogic:OnKingOccupyProgressRefresh()
  base.UpdateCityInfo(self)
  if self.data and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory or self.data.type == WorldAllianceCityType.King) and self.isCrossServerThrone then
    self:DoRefresh(false, true)
  else
    self:DoRefresh(false, false)
  end
end

function ActivityCrossKingBattleLogic:OnPointDateUpdate()
  base.UpdateCityInfo(self)
  self:RequestDetail()
  if self.data and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory or self.data.type == WorldAllianceCityType.King) and self.isCrossServerThrone then
    self:DoRefresh(false, true)
  else
    self:DoRefresh(false, false)
  end
end

function ActivityCrossKingBattleLogic:OnWorldAllianceCityDetail()
  base.UpdateCityInfo(self)
  if self.data and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory or self.data.type == WorldAllianceCityType.King) and self.isCrossServerThrone then
    self:DoRefresh(false, true)
  else
    self:DoRefresh(false, false)
  end
end

function ActivityCrossKingBattleLogic:DoRefresh(KingOccupyProgressRefresh, isOpen)
  if self.isCrossServerThrone and self.isKingCity then
    self:UpdateThroneOccupy(KingOccupyProgressRefresh)
  end
  if self.data and self.theExtraInfo and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory) then
    local sourceServerId = LuaEntry.Player:GetSourceServerId()
    local isNineNationRainforest = self.seasonInfo ~= nil and self.seasonType == SeasonMapType.NineNationRainforest
    local isBattleMember = isNineNationRainforest and self.seasonInfo:IsInBattleServerGroupInt(sourceServerId) or SeasonUtil.IsBattleMember(self.serverId)
    local extraInfo = self.theExtraInfo
    local cityId = self.cityId
    local cityDetail = self.theCityDetail
    local nameModel = SeasonUtil.GetCanonNameModel(cityId)
    if isOpen and cityDetail == nil then
      self:RequestDetail()
    end
    if nameModel then
      local BatteryName = nameModel:GetComponent(typeof(CS.SuperTextMesh))
      if isOpen and extraInfo.state == AllianceCityState.SERVER_BUILD_THRONE then
        local ownerServerId = extraInfo.serverId
        local ownerAlId = extraInfo.allianceId
        if isBattleMember then
          if SeasonUtil.IsAlly(ownerServerId, sourceServerId, ownerAlId) then
            BatteryName.color32 = Color32.New(84, 196, 242, 255)
          else
            BatteryName.color32 = Color32.New(229, 39, 39, 255)
          end
        else
          BatteryName.color32 = Color32.New(255, 255, 255, 255)
        end
        local owner = string.format("#%s [%s]%s", ownerServerId, extraInfo.alAbbr, extraInfo.alName)
        if string.IsNullOrEmpty(extraInfo.alName) and cityDetail and cityDetail.defenceList then
          local defendInfo = cityDetail.defenceList[1]
          if defendInfo and not string.IsNullOrEmpty(defendInfo.alAbbr) and not string.IsNullOrEmpty(defendInfo.alName) then
            owner = string.format("#%s [%s]%s", ownerServerId, defendInfo.alAbbr, defendInfo.alName)
          end
        end
        BatteryName.text = owner
      else
        BatteryName.color32 = Color32.New(255, 255, 255, 255)
        BatteryName.text = self.data:GetName()
      end
    end
    local skinModel = SeasonUtil.GetCanonAnimModel(cityId)
    if skinModel then
      local simAnim = skinModel:GetComponent(typeof(CS.SimpleAnimation))
      if simAnim then
        if not isOpen or cityDetail and cityDetail.towerInfo and cityDetail.towerInfo.insideTroopCount == 0 or extraInfo.state == AllianceCityState.SERVER_TOWER_NOT_START or extraInfo.state == AllianceCityState.SERVER_NEUTRAL or extraInfo.state == AllianceCityState.SERVER_OCCUPIED then
          simAnim:Stop()
        elseif not simAnim:IsPlaying("idle") then
          simAnim:Play("idle")
        end
      end
    end
  end
end

function ActivityCrossKingBattleLogic:SetLod(lod)
  base.SetLod(self, lod)
  self:UpdateThroneOccupy()
end

function ActivityCrossKingBattleLogic:CheckLod(lod)
  base.CheckLod(self, lod)
  self:UpdateThroneOccupy()
end

function ActivityCrossKingBattleLogic:ReInit(data)
  base.ReInit(self, data)
end

function ActivityCrossKingBattleLogic:RequestDetail()
  if self.data and self.theExtraInfo ~= nil and self.theCityDetail == nil and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory) then
    WorldBattleUtil.TryRequestCityInfo(self.cityId, self.serverId)
  end
end

function ActivityCrossKingBattleLogic:UpdateThroneOccupy(KingOccupyProgressRefresh)
  if self.data == nil or not self.isKingCity then
    self.throneKingOccupyPoint = nil
    self.ThroneOccupyRoot:SetActive(false)
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local isNineNationRainforest = self.seasonInfo ~= nil and self.seasonType == SeasonMapType.NineNationRainforest
  local allianceCityPointInfo = self.theExtraInfo
  local playerInfo = self.theExtraInfo
  if playerInfo == nil or playerInfo.state ~= AllianceCityState.SERVER_NEUTRAL and playerInfo.state ~= AllianceCityState.SERVER_BUILD_THRONE then
    self.throneKingOccupyPoint = nil
    self.ThroneOccupyRoot:SetActive(false)
    return
  end
  self.allianceCityPointInfo = allianceCityPointInfo
  if isNineNationRainforest and allianceCityPointInfo and (allianceCityPointInfo.serverId == 0 or allianceCityPointInfo.serverId == nil) then
    allianceCityPointInfo.serverId = self.serverId
  end
  if KingOccupyProgressRefresh or isNineNationRainforest then
    local currentData = DataCenter.GovernmentManager:GetKingOccupyPlayer(self.serverId)
    if currentData then
      local serverBuildPoint = currentData.serverBuildPoint
      local serverBuildStartTime = currentData.serverBuildStartTime
      if serverBuildPoint and serverBuildStartTime ~= nil and serverBuildStartTime ~= 0 then
        playerInfo = currentData
        self.CrossKingBuildPointInfo = serverBuildPoint
        self.throneKingBuildStartTime = serverBuildStartTime
      end
    end
  end
  if allianceCityPointInfo ~= nil then
    local buildStartTime = toInt(allianceCityPointInfo.buildStartTime)
    local throneKingBuildStartTime = toInt(self.throneKingBuildStartTime)
    local buildPointInfo = allianceCityPointInfo.buildPointInfo
    if 0 < buildStartTime and buildPointInfo ~= nil and (throneKingBuildStartTime <= 0 or buildStartTime >= throneKingBuildStartTime) then
      self.CrossKingBuildPointInfo = buildPointInfo
      self.throneKingBuildStartTime = buildStartTime
    end
  end
  local buildPointInfo = self.CrossKingBuildPointInfo
  if allianceCityPointInfo == nil or self.throneKingBuildStartTime == nil or self.throneKingBuildStartTime == 0 or buildPointInfo == nil or #buildPointInfo == 0 then
    self.throneKingOccupyPoint = nil
    self.ThroneOccupyRoot:SetActive(false)
    return
  end
  if table.IsNullOrEmpty(buildPointInfo) then
    self.throneKingOccupyPoint = nil
    self.ThroneOccupyRoot:SetActive(false)
    return
  end
  local isBattleMember = false
  if isNineNationRainforest then
    isBattleMember = self.seasonInfo:IsInBattleServerGroupInt(mySourceServerId)
  else
    isBattleMember = SeasonUtil.IsBattleMember(self.serverId)
  end
  local totalPoint = SeasonUtil.GetWorldBattleTotalPoint(self.serverId)
  local addPoint = SeasonUtil.GetWorldBattlePointSpeed(self.serverId)
  local alAbbr = playerInfo.alAbbr or playerInfo.abbr or playerInfo.allianceAbbr
  local alName = playerInfo.alName or playerInfo.name
  local ownerServerId = playerInfo.serverId
  local ownerAlId = playerInfo.allianceId or playerInfo.aId
  self.throneKing_title.text = string.format("#%s [%s]%s", ownerServerId, alAbbr, alName)
  local textWidth = self.throneKing_title:GetWidth()
  self.throneKing_title.transform:Set_localPosition(-textWidth * 0.5, 0.22, 0)
  local enemyServer, enemyAllianceId, enemyAbbr = SeasonUtil.GetMyEnemyServerNow(ownerServerId, ownerAlId)
  for _, v in ipairs(buildPointInfo) do
    if not SeasonUtil.IsAlly(ownerServerId, v.serverId, ownerAlId, v.allianceId) then
      enemyServer = v.serverId
      enemyAllianceId = v.allianceId
      enemyAbbr = v.allianceAbbr
      break
    end
  end
  local ownerPoint = {
    buildPoint = 0,
    serverId = ownerServerId,
    buildSpeed = addPoint,
    campId = 0,
    allianceId = ownerAlId,
    allianceAbbr = alAbbr
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
    if SeasonUtil.IsAlly(v.serverId, ownerServerId, v.allianceId, ownerAlId) then
      if v.buildPoint >= ownerPoint.buildPoint then
        ownerPoint = v
      end
    elseif SeasonUtil.IsAlly(v.serverId, enemyServer, v.allianceId, enemyAllianceId) and v.buildPoint >= targetPoint.buildPoint then
      targetPoint = v
    end
  end
  local myRate = ownerPoint.buildPoint / totalPoint
  local targetRate = targetPoint.buildPoint / totalPoint
  self.throneKingOccupyPoint = ownerPoint.buildPoint
  self.throneKingOccupyPointAdd = ownerPoint.buildSpeed
  self.targetPoint = targetPoint
  self.throneKing_pro1:Set_size(1.72 * myRate, 0.2)
  self.throneKing_pro2:Set_size(1.72 * targetRate, 0.2)
  self.throneKing_pro_num1.text = math.floor(myRate * 10000) * 0.01 .. "%"
  self.throneKing_pro_num2.text = math.floor(targetRate * 10000) * 0.01 .. "%"
  local AIsEnemy = false
  local BIsEnemy = true
  if isBattleMember then
    AIsEnemy = not SeasonUtil.IsAlly(ownerPoint.serverId, mySourceServerId, ownerPoint.allianceId)
    BIsEnemy = not SeasonUtil.IsAlly(targetPoint.serverId, mySourceServerId, targetPoint.allianceId)
  end
  local colorA, colorA32 = SeasonUtil.GetWorldBattleColor(AIsEnemy)
  local colorB, colorB32 = SeasonUtil.GetWorldBattleColor(BIsEnemy)
  local hasFactionWar = self.seasonInfo ~= nil and self.seasonType ~= nil and SeasonUtil.SeasonHasFactionWar(self.seasonType)
  if hasFactionWar and self.seasonInfo ~= nil and (ownerPoint.campId ~= 0 or targetPoint.campId ~= 0) then
    local campId1 = ownerPoint.campId
    local campId2 = targetPoint.campId
    if campId1 == nil or campId1 == 0 and ownerPoint.serverId ~= 0 then
      campId1 = self.seasonInfo:GetCampIdByServerId(ownerPoint.serverId)
    end
    if campId2 == nil or campId2 == 0 and targetPoint.serverId ~= 0 then
      campId2 = self.seasonInfo:GetCampIdByServerId(targetPoint.serverId)
    end
    if campId1 == nil and campId2 ~= nil then
      if campId2 == 1 then
        campId1 = 2
      else
        campId1 = 1
      end
    end
    if campId2 == nil and campId1 ~= nil then
      if campId1 == 1 then
        campId2 = 2
      else
        campId2 = 1
      end
    end
    local campIconA = DataCenter.SeasonFactionWarDataManager:GetCampIcon(campId1, true)
    local campIconB = DataCenter.SeasonFactionWarDataManager:GetCampIcon(campId2, true)
    self.throneKing_pro_camper1:LoadSprite(campIconA or "")
    self.throneKing_pro_camper2:LoadSprite(campIconB or "")
    self.throneKing_pro_camper1.gameObject:SetActive(true)
    self.throneKing_pro_camper2.gameObject:SetActive(true)
    self.throneKing_pro_server1.gameObject:SetActive(false)
    self.throneKing_pro_server2.gameObject:SetActive(false)
    self.throneKing_pro_camper1.size = Vector2.New(2, 2)
    self.throneKing_pro_camper2.size = Vector2.New(2, 2)
    if isNineNationRainforest then
      if ownerPoint.campId == 1 then
        colorA = Color.New(0.3803921568627451, 0.9372549019607843, 0.5333333333333333, 1)
        colorB = Color.New(0.27450980392156865, 0.7764705882352941, 0.9176470588235294, 1)
      else
        colorA = Color.New(0.27450980392156865, 0.7764705882352941, 0.9176470588235294, 1)
        colorB = Color.New(0.3803921568627451, 0.9372549019607843, 0.5333333333333333, 1)
      end
    end
  else
    self.throneKing_pro_server1.text = SeasonUtil.GetWorldBattleName(ownerPoint, nil, nil, self.serverId)
    self.throneKing_pro_server2.text = SeasonUtil.GetWorldBattleName(targetPoint, nil, nil, self.serverId)
    self.throneKing_pro_camper1.gameObject:SetActive(false)
    self.throneKing_pro_camper2.gameObject:SetActive(false)
    self.throneKing_pro_server1.gameObject:SetActive(true)
    self.throneKing_pro_server2.gameObject:SetActive(true)
  end
  if isNineNationRainforest then
    self.throneKing_pro1bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg_white.png")
    self.throneKing_pro2bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg_white.png")
    self.throneKing_pro1bg.color = Color.New(colorA.r, colorA.g, colorA.b, 0.5)
    self.throneKing_pro2bg.color = Color.New(colorB.r, colorB.g, colorB.b, 0.5)
  else
    self.throneKing_pro1bg:LoadSprite(self:GetProBg(AIsEnemy))
    self.throneKing_pro2bg:LoadSprite(self:GetProBg(BIsEnemy))
    self.throneKing_pro1bg.color = Color.white
    self.throneKing_pro2bg.color = Color.white
  end
  self.throneKing_pro1.color = colorA
  self.throneKing_pro2.color = colorB
  self:TimerAction()
  self.ThroneOccupyRoot:SetActive(self.data and self.isKingCity and self.lodCache < 3 and self.isCrossServerThrone)
end

function ActivityCrossKingBattleLogic:GetWinnerInfo(pointNow, addPoint, remainTime)
  if not self.targetPoint or pointNow > self.targetPoint.buildPoint then
    return self.theExtraInfo, true
  end
  local pointEnd = pointNow + addPoint * (remainTime / 1000)
  if pointEnd < self.targetPoint.buildPoint then
    return self.targetPoint, false
  end
  return self.theExtraInfo, true
end

function ActivityCrossKingBattleLogic:GetProBg(isEnemy)
  if isEnemy then
    return "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_wangzuozhanling_hongfang.png"
  else
    return "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_wangzuozhanling_lanfang.png"
  end
end

return ActivityCrossKingBattleLogic
