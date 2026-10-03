local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local KingBattleMultiTip = BaseClass("KingBattleMultiTip", base)
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local Localization = CS.GameEntry.Localization

function KingBattleMultiTip:__init(gameObject)
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
end

function KingBattleMultiTip:__delete()
  self.throneKing_occupy_btn.onPointerClick = nil
  self.ThroneOccupyRoot:SetActive(false)
  base.__delete(self)
end

function KingBattleMultiTip:TimerAction()
  if self.isCrossServerThrone and self.throneKingOccupyPoint and self.throneKingBuildStartTime and self.throneKingOccupyPointAdd and self.allianceCityPointInfo and self.allianceCityPointInfo.serverId ~= nil and self.allianceCityPointInfo.serverId ~= 0 then
    local totalPoint = SeasonUtil.GetWorldBattleTotalPoint(self.serverId)
    local addPoint = self.throneKingOccupyPointAdd
    local Seconds = UITimeManager:GetInstance():GetServerSeconds() - self.throneKingBuildStartTime
    local pointNow = self.throneKingOccupyPoint + addPoint * Seconds
    local rate = math.min(pointNow / totalPoint, 1.0)
    self.throneKing_pro1:Set_size(1.72 * rate, 0.2)
    self.throneKing_pro_num1.text = math.floor(rate * 10000) * 0.01 .. "%"
    if self.theExtraInfo ~= nil then
      local max_size = 0.2
      local ownerServerId = self.theExtraInfo.serverId
      local remainTime = DataCenter.ZoneWarManager:CalcOccupyTime(pointNow, addPoint)
      self.throneKing_title.size = max_size
      if 0 < remainTime then
        local str = Localization:GetString("801482", DataCenter.ZoneWarManager:GetCampName(ownerServerId), UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
        self.throneKing_title.text = str
      else
        self.throneKing_title.text = DataCenter.ZoneWarManager:GetCampName(ownerServerId)
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
end

function KingBattleMultiTip:OnKingOccupyProgressRefresh()
  base.UpdateCityInfo(self)
  if self.data and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory or self.data.type == WorldAllianceCityType.King) and self.isCrossServerThrone then
    self:DoRefresh(false, true)
  else
    self:DoRefresh(false, false)
  end
end

function KingBattleMultiTip:OnPointDateUpdate()
  base.UpdateCityInfo(self)
  self:RequestDetail()
  if self.data and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory or self.data.type == WorldAllianceCityType.King) and self.isCrossServerThrone then
    self:DoRefresh(false, true)
  else
    self:DoRefresh(false, false)
  end
end

function KingBattleMultiTip:OnWorldAllianceCityDetail()
  base.UpdateCityInfo(self)
  if self.data and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory or self.data.type == WorldAllianceCityType.King) and self.isCrossServerThrone then
    self:DoRefresh(false, true)
  else
    self:DoRefresh(false, false)
  end
end

function KingBattleMultiTip:DoRefresh(KingOccupyProgressRefresh, isOpen)
  if self.isCrossServerThrone and self.isKingCity then
    self:UpdateThroneOccupy(KingOccupyProgressRefresh)
  end
  if self.data and self.theExtraInfo and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory) then
    local isBattleMember = SeasonUtil.IsBattleMember(self.serverId)
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
        local sourceServerId = LuaEntry.Player:GetSourceServerId()
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
        elseif simAnim:IsPlaying("idle") then
          simAnim:Rewind("idle")
        else
          simAnim:Play("idle")
        end
      end
    end
  end
end

function KingBattleMultiTip:SetLod(lod)
  base.SetLod(self, lod)
  self:UpdateThroneOccupy()
end

function KingBattleMultiTip:CheckLod(lod)
  base.CheckLod(self, lod)
  self:UpdateThroneOccupy()
end

function KingBattleMultiTip:ReInit(data)
  base.ReInit(self, data)
end

function KingBattleMultiTip:RequestDetail()
  if self.data and self.theExtraInfo ~= nil and self.theCityDetail == nil and (self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory) then
    WorldBattleUtil.TryRequestCityInfo(self.cityId, self.serverId)
  end
end

function KingBattleMultiTip:UpdateThroneOccupy(KingOccupyProgressRefresh)
  if self.data == nil or not self.isKingCity then
    self.throneKingOccupyPoint = nil
    self.ThroneOccupyRoot:SetActive(false)
    return
  end
  local dataFrom = 0
  local allianceCityPointInfo = self.theExtraInfo
  local playerInfo = self.theExtraInfo
  if KingOccupyProgressRefresh then
    local currentData = DataCenter.GovernmentManager:GetKingOccupyPlayer(self.serverId)
    if currentData then
      local serverBuildPoint = currentData.serverBuildPoint
      local serverBuildStartTime = currentData.serverBuildStartTime
      if serverBuildPoint and serverBuildStartTime ~= nil and serverBuildStartTime ~= 0 then
        dataFrom = 1
        playerInfo = currentData
        self.CrossKingBuildPointInfo = serverBuildPoint
        self.throneKingBuildStartTime = serverBuildStartTime
      elseif allianceCityPointInfo ~= nil then
        dataFrom = 2
        self.allianceCityPointInfo = allianceCityPointInfo
        self.CrossKingBuildPointInfo = allianceCityPointInfo.buildPointInfo
        self.throneKingBuildStartTime = allianceCityPointInfo.buildStartTime
      end
    end
  elseif allianceCityPointInfo ~= nil then
    dataFrom = 3
    self.allianceCityPointInfo = allianceCityPointInfo
    self.CrossKingBuildPointInfo = allianceCityPointInfo.buildPointInfo
    self.throneKingBuildStartTime = allianceCityPointInfo.buildStartTime
  end
  local buildPointInfo = self.CrossKingBuildPointInfo
  if allianceCityPointInfo == nil or self.throneKingBuildStartTime == nil or self.throneKingBuildStartTime == 0 or buildPointInfo == nil or #buildPointInfo == 0 then
    self.throneKingOccupyPoint = nil
    self.ThroneOccupyRoot:SetActive(false)
    return
  end
  local isBattleMember = SeasonUtil.IsBattleMember(self.serverId)
  if not isBattleMember and (buildPointInfo == nil or #buildPointInfo ~= 2) then
    self.throneKingOccupyPoint = nil
    self.ThroneOccupyRoot:SetActive(false)
    return
  end
  local totalPoint = SeasonUtil.GetWorldBattleTotalPoint(self.serverId)
  local addPoint = SeasonUtil.GetWorldBattlePointSpeed(self.serverId)
  local alAbbr = playerInfo.alAbbr
  local alName = playerInfo.alName
  local ownerServerId = playerInfo.serverId
  local ownerAlId = playerInfo.allianceId
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
      ownerPoint = v
    elseif SeasonUtil.IsAlly(v.serverId, enemyServer, v.allianceId, enemyAllianceId) then
      targetPoint = v
    end
  end
  local myRate = ownerPoint.buildPoint / totalPoint
  local targetRate = targetPoint.buildPoint / totalPoint
  self.throneKingOccupyPoint = ownerPoint.buildPoint
  self.throneKingOccupyPointAdd = ownerPoint.buildSpeed
  self.throneKing_pro1:Set_size(1.72 * myRate, 0.2)
  self.throneKing_pro2:Set_size(1.72 * targetRate, 0.2)
  self.throneKing_pro_num1.text = math.floor(myRate * 10000) * 0.01 .. "%"
  self.throneKing_pro_num2.text = math.floor(targetRate * 10000) * 0.01 .. "%"
  local campIconA = DataCenter.ZoneWarManager:GetCampIcon(ownerPoint.serverId, ownerPoint.campId)
  local campIconB = DataCenter.ZoneWarManager:GetCampIcon(targetPoint.serverId, targetPoint.campId)
  if campIconA or campIconB then
    self.throneKing_pro_camper1:LoadSprite(campIconA or "")
    self.throneKing_pro_camper2:LoadSprite(campIconB or "")
    self.throneKing_pro_camper1.gameObject:SetActive(true)
    self.throneKing_pro_camper2.gameObject:SetActive(true)
    self.throneKing_pro_server1.gameObject:SetActive(false)
    self.throneKing_pro_server2.gameObject:SetActive(false)
  else
    self.throneKing_pro_server1.text = SeasonUtil.GetWorldBattleName(ownerPoint, nil, nil, self.serverId)
    self.throneKing_pro_server2.text = SeasonUtil.GetWorldBattleName(targetPoint, nil, nil, self.serverId)
    self.throneKing_pro_camper1.gameObject:SetActive(false)
    self.throneKing_pro_camper2.gameObject:SetActive(false)
    self.throneKing_pro_server1.gameObject:SetActive(true)
    self.throneKing_pro_server2.gameObject:SetActive(true)
  end
  local AIsEnemy = false
  local BIsEnemy = true
  if isBattleMember then
    AIsEnemy = not SeasonUtil.IsAlly(ownerPoint.serverId, nil, ownerPoint.allianceId)
    BIsEnemy = not SeasonUtil.IsAlly(targetPoint.serverId, nil, targetPoint.allianceId)
  end
  self.throneKing_pro1bg:LoadSprite(self:GetProBg(AIsEnemy))
  self.throneKing_pro2bg:LoadSprite(self:GetProBg(BIsEnemy))
  local colorA, colorA32 = SeasonUtil.GetWorldBattleColor(AIsEnemy)
  local colorB, colorB32 = SeasonUtil.GetWorldBattleColor(BIsEnemy)
  self.throneKing_pro1.color = colorA
  self.throneKing_pro2.color = colorB
  self.throneKing_title.color = colorA32
  self:TimerAction()
  self.ThroneOccupyRoot:SetActive(self.data and self.isKingCity and 3 > self.lodCache and self.isCrossServerThrone)
end

function KingBattleMultiTip:GetProBg(isEnemy)
  if isEnemy then
    return "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_wangzuozhanling_hongfang.png"
  else
    return "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_wangzuozhanling_lanfang.png"
  end
end

return KingBattleMultiTip
