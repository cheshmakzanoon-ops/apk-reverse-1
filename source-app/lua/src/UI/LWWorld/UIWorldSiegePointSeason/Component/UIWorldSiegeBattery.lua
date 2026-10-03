local UIWorldSiegeBatterySeason = BaseClass("UIWorldSiegeBatterySeason", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local detail_title_path = "detailTitle"
local detail_des_title_path = "detailTitle/detailDesTitle"
local des_txt_path = "detailTitle/desTxt"
local title_path = "Bg/info/title"
local time_path = "Bg/info/time"
local mine_path = "Bg/info/mine"
local other_path = "Bg/info/other"
local buff1_path = "buff1"
local buff_text1_path = "buff1/buffText1"
local buff2_path = "buff2"
local buff_text2_path = "buff2/buffText2"
local desc_path = "desc"
local fire_status_root_path = "fireStatus"
local fire_status_path = "fireStatus/fireStatusText"
local score_path = "score"
local score_slider_1 = "score/Slider1"
local score_slider_2 = "score/Slider2"
local score_name_1 = "score/Slider1/ServerValue1"
local score_name_2 = "score/Slider2/ServerValue2"
local score_value_1 = "score/Slider1/SliderValue1"
local score_value_2 = "score/Slider2/SliderValue2"
local score_value_slider_img_1 = "score/Slider1/Fill Area/Fill1"
local score_value_slider_img_2 = "score/Slider2/Fill Area/Fill2"
local icon_camp_a_path = "score/IconCampA"
local icon_camp_b_path = "score/IconCampB"

function UIWorldSiegeBatterySeason:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.timeText = self:AddComponent(UIText, time_path)
  self.mine = self:AddComponent(UIText, mine_path)
  self.other = self:AddComponent(UIText, other_path)
  self.buff1 = self:AddComponent(UIImage, buff1_path)
  self.buff_text1 = self:AddComponent(UIText, buff_text1_path)
  self.buff2 = self:AddComponent(UIImage, buff2_path)
  self.buff_text2 = self:AddComponent(UIText, buff_text2_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.fire_status_root = self:AddComponent(UIBaseContainer, fire_status_root_path)
  self.fire_status = self:AddComponent(UIText, fire_status_path)
  self.buff1:SetActive(false)
  self.buff2:SetActive(false)
  self.detail_title = self:AddComponent(UIImage, detail_title_path)
  self.detail_des_title = self:AddComponent(UIText, detail_des_title_path)
  self.detail_des_txt = self:AddComponent(UIText, des_txt_path)
  self.detail_title:SetActive(false)
  self.detail_des_title:SetLocalText(300705)
  self.detail_des_txt:SetLocalText(801474)
  self.scoreRoot = self:AddComponent(UIBaseContainer, score_path)
  self.scoreSliderBlue = self:AddComponent(UISlider, score_slider_1)
  self.scoreSliderRed = self:AddComponent(UISlider, score_slider_2)
  self.scoreNameTextBlue = self:AddComponent(UIText, score_name_1)
  self.scoreNameTextRed = self:AddComponent(UIText, score_name_2)
  self.scoreValueTextBlue = self:AddComponent(UIText, score_value_1)
  self.scoreValueTextRed = self:AddComponent(UIText, score_value_2)
  self.scoreValueSliderImgBlue = self:AddComponent(UIImage, score_value_slider_img_1)
  self.scoreValueSliderImgRed = self:AddComponent(UIImage, score_value_slider_img_2)
  self.icon_camp_a = self:AddComponent(UIImage, icon_camp_a_path)
  self.icon_camp_b = self:AddComponent(UIImage, icon_camp_b_path)
end

function UIWorldSiegeBatterySeason:OnDestroy()
  self.data = nil
  base.OnDestroy(self)
end

function UIWorldSiegeBatterySeason:OnAddListener()
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.OnCityDetailUpdate)
  self:AddUIListener(EventId.KingdomBadgesFire, self.DoAttackFire)
end

function UIWorldSiegeBatterySeason:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.OnCityDetailUpdate)
  self:RemoveUIListener(EventId.KingdomBadgesFire, self.DoAttackFire)
end

function UIWorldSiegeBatterySeason:UpdateData()
  self:InitData(self.data)
end

function UIWorldSiegeBatterySeason:OnInfoClick()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  self.detail_title:SetActive(true)
  return self.activeSelf
end

function UIWorldSiegeBatterySeason:OnReturnClick()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  self.detail_title:SetActive(false)
  return self.activeSelf
end

function UIWorldSiegeBatterySeason:InitData(param)
  if param == nil or IsNull(self.gameObject) then
    self.data = param
    return
  end
  local cityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(param.cityId)
  if cityDetail and cityDetail.towerInfo then
    self.towerInfo = cityDetail.towerInfo
  else
    self.towerInfo = {
      lastTowerAttackTime = 0,
      insideTroopCount = 0,
      state = 0
    }
  end
  if cityDetail and cityDetail.defenceList and 0 < #cityDetail.defenceList then
    self.defendInfo = cityDetail.defenceList[1]
  else
    self.defendInfo = {
      occupyServerId = 0,
      aid = 0,
      alAbbr = "",
      alName = ""
    }
  end
  if cityDetail then
    local descId = GetTableData(TableName.WorldCity, cityDetail.cityId, "desc")
    self.detail_des_txt:SetLocalText(not string.IsNullOrEmpty(descId) and descId or 801474)
  end
  self.timeText:SetActive(false)
  self.mine:SetActive(false)
  self.other:SetActive(false)
  self.buff1:SetActive(false)
  self.buff2:SetActive(false)
  self.desc:SetActive(false)
  self.fire_status_root:SetActive(false)
  self.data = param
  self.fireTime = nil
  self.protectTime = nil
  self.fireEnable = false
  self:RefreshScore(self.towerInfo, param)
  local desc1, desc2, desc3 = SeasonUtil.GetBatteryDesc(param.serverId)
  if param.state == AllianceCityState.SERVER_TOWER_NOT_START then
    self.desc:SetActive(true)
    self.desc:SetLocalText(desc2)
    self.title:SetLocalText(desc1)
  elseif param.canBattle then
    if param.state == AllianceCityState.SERVER_OCCUPIED or param.state == AllianceCityState.SERVER_NEUTRAL then
      self.title:SetLocalText(801471)
      self.desc:SetActive(true)
      self.desc:SetLocalText(desc3)
    elseif param.state == AllianceCityState.SERVER_BUILD_THRONE then
      local canAttack = false
      local owner = string.format("#%s [%s]%s", param.ownerServerId, param.alAbbr, param.alName)
      if self.defendInfo and not string.IsNullOrEmpty(self.defendInfo.alAbbr) and not string.IsNullOrEmpty(self.defendInfo.alName) then
        owner = string.format("#%s [%s]%s", self.defendInfo.occupyServerId, self.defendInfo.alAbbr, self.defendInfo.alName)
      end
      self.title:SetLocalText(801472)
      local myServerId = LuaEntry.Player:GetSourceServerId()
      local ownerServerIdKingCity, ownerAllianceIdKingCity = DataCenter.ZoneWarManager:GetOwnerServerIdKingCity()
      if SeasonUtil.IsAlly(param.ownerServerId, myServerId, param.allianceId) then
        self.mine:SetActive(true)
        self.mine:SetText(owner)
        if SeasonUtil.IsAlly(param.ownerServerId, param.serverId) then
          self.buff1:SetActive(true)
          self.buff_text1:SetText(self:GetEffectText(75162))
        else
          self.buff1:SetActive(false)
        end
        local isKingCityOwner = SeasonUtil.IsAlly(ownerServerIdKingCity, myServerId, ownerAllianceIdKingCity)
        self.buff2:SetActive(isKingCityOwner)
        if isKingCityOwner then
          local towerSpeedAdd = SeasonUtil.GetTowerSpeedAdd(param.serverId)
          self.buff_text2:SetLocalText("tower_zone_war_buff2", towerSpeedAdd)
        end
        if (ownerServerIdKingCity ~= 0 or not string.IsNullOrEmpty(ownerAllianceIdKingCity)) and not isKingCityOwner then
          canAttack = true
        end
      else
        self.other:SetActive(true)
        self.other:SetText(owner)
        if SeasonUtil.IsAlly(ownerServerIdKingCity, myServerId, ownerAllianceIdKingCity) then
          canAttack = true
        end
      end
      if canAttack then
        self.fire_status_root:SetActive(true)
        if self.towerInfo.insideTroopCount == 0 then
          self.fire_status:SetLocalText(801477)
        else
          self.fireEnable = true
          self.fire_status:SetLocalText(801476)
          self:UpdateFireTime()
        end
      else
        self.fire_status_root:SetActive(false)
      end
      self:UpdateModelName()
    end
  elseif param.state ~= nil then
    self.desc:SetActive(true)
    self.desc:SetLocalText(desc3)
    self.title:SetLocalText(801470)
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if curTime < param.openTime then
      self.protectTime = param.openTime * 1000
    elseif curTime < param.protectTime then
      self.protectTime = param.protectTime * 1000
    elseif curTime > param.protectTime then
      if CS.CommonUtils.IsDebug() then
        Logger.Log("[Debug] \231\130\174\229\143\176\230\149\176\230\141\174\233\148\153\232\175\175")
        Logger.Log("TOWER.openTime = " .. param.openTime)
        Logger.Log("TOWER.protectTime = " .. param.protectTime)
      end
      self.protectTime = nil
      self.timeText:SetText("")
      self.title:SetLocalText(param.name)
    else
      self.protectTime = nil
      self.title:SetLocalText(param.name)
    end
    if LuaEntry.Player:AtHomeNow() then
      local activityServerData = DataCenter.GovernmentManager.activityServerData
      if activityServerData == nil or activityServerData.actFightStep ~= 2 then
        self.protectTime = nil
        self.timeText:SetText("")
        self.title:SetLocalText(param.name)
      end
    end
    self.timeText:SetActive(0 < toInt(self.protectTime))
  else
    self.desc:SetActive(true)
    self.desc:SetLocalText(desc3)
    self.title:SetLocalText(801471)
  end
  self:Update100MS()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UIWorldSiegeBatterySeason:UpdateModelName()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  local cityId = tonumber(self.data.cityId)
  local cityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(cityId)
  local model = SeasonUtil.GetCanonNameModel(cityId)
  if model then
    local BatteryName = model:GetComponent(typeof(CS.SuperTextMesh))
    local ownerServerId = self.data.ownerServerId
    local ownerAllianceId = self.data.allianceId
    if ownerServerId == nil or ownerServerId == 0 then
      BatteryName.color32 = Color32.New(255, 255, 255, 255)
      BatteryName.text = CS.GameEntry.Localization:GetString(self.data.name)
    else
      local sourceServerId = LuaEntry.Player:GetSourceServerId()
      if SeasonUtil.IsAlly(ownerServerId, sourceServerId, ownerAllianceId) then
        BatteryName.color32 = Color32.New(84, 196, 242, 255)
      else
        BatteryName.color32 = Color32.New(229, 39, 39, 255)
      end
      local owner = string.format("#%s [%s]%s", ownerServerId, self.data.alAbbr, self.data.alName)
      if cityDetail and cityDetail.defenceList then
        local defendInfo = cityDetail.defenceList[1]
        if defendInfo and not string.IsNullOrEmpty(defendInfo.alAbbr) and not string.IsNullOrEmpty(defendInfo.alName) then
          owner = string.format("#%s [%s]%s", ownerServerId, defendInfo.alAbbr, defendInfo.alName)
        end
      end
      BatteryName.text = owner
    end
  end
end

function UIWorldSiegeBatterySeason:DoAttackFire(pointId)
  if self.data and self.data.pointId == pointId then
    self.fireTime = 2
    self.fire_status:SetLocalText(801476)
  end
end

function UIWorldSiegeBatterySeason:OnCityDetailUpdate()
  if self.data then
    self:InitData(self.data)
  end
end

function UIWorldSiegeBatterySeason:UpdateFireTime()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  if self.fire_status == nil or self.fire_status.SetLocalText == nil then
    return
  end
  local left_time = DataCenter.ZoneWarManager:GetBatteryLeftFireTime(self.data.cityId, self.towerInfo.insideTroopCount)
  if left_time < 1000 then
    self.fire_status:SetLocalText(801476)
  else
    self.fire_status:SetLocalText(801475, string.format("<size=58>%ss</size>", math.floor(left_time * 0.001)))
  end
end

function UIWorldSiegeBatterySeason:Update100MS()
  if self.fireTime then
    self.fireTime = self.fireTime - 1
    if self.fireTime <= 0 then
      self.fireTime = nil
      self:UpdateFireTime()
    end
  elseif self.fireEnable then
    self:UpdateFireTime()
  elseif self.protectTime and self.timeText then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.protectTime - curTime
    if 0 < remainTime then
      self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.protectTime = nil
      self.timeText:SetActive(false)
    end
  end
end

function UIWorldSiegeBatterySeason:GetEffectText(effectId)
  local defence_buff = self.data.defence_buff
  local defence_buff_id, defence_buff_num = string.match(defence_buff, "([^;]+)[;]([^;]+)")
  local text, describe = UIUtil.GetEffectStr(nil, defence_buff_num, effectId)
  return Localization:GetString(describe) .. "<color=#099B4A>" .. (text or "") .. "</color>"
end

function UIWorldSiegeBatterySeason:RefreshScore(towerInfo, param)
  if param.type == WorldAllianceCityType.CrossZoneOutpostCanon then
    self.scoreRoot:SetActive(false)
    return
  end
  if param.state ~= AllianceCityState.OCCUPIED and param.state ~= AllianceCityState.BUILDING and param.state ~= AllianceCityState.SERVER_OCCUPIED and param.state ~= AllianceCityState.SERVER_BUILD_THRONE then
    self.scoreRoot:SetActive(false)
    return
  end
  local serverId = param and param.serverId or LuaEntry.Player:GetCurServerId()
  if not self:CanShowScore(serverId) then
    self.scoreRoot:SetActive(false)
    return
  end
  local AScoreInfo, BScoreInfo = SeasonUtil.ParseKillScoreData(towerInfo.killInfo, param.ownerServerId, param.allianceId, param.alAbbr or param.allianceAbbr)
  if not AScoreInfo or not BScoreInfo then
    self.scoreRoot:SetActive(false)
    return
  end
  local maxNum = math.max(AScoreInfo.num, BScoreInfo.num)
  self.scoreValueTextBlue:SetText(AScoreInfo.num)
  self.scoreValueTextRed:SetText(BScoreInfo.num)
  self.scoreSliderBlue:SetValue(AScoreInfo.num / maxNum * 100)
  self.scoreSliderRed:SetValue(BScoreInfo.num / maxNum * 100)
  self.scoreRoot:SetActive(true)
  local campIconA = DataCenter.ZoneWarManager:GetCampIcon(AScoreInfo.serverId, AScoreInfo.campId)
  local campIconB = DataCenter.ZoneWarManager:GetCampIcon(BScoreInfo.serverId, BScoreInfo.campId)
  if campIconA or campIconB then
    self.icon_camp_a:LoadSprite(campIconA or "")
    self.icon_camp_a:SetNativeSize()
    self.icon_camp_b:LoadSprite(campIconB or "")
    self.icon_camp_b:SetNativeSize()
    self.icon_camp_a:SetActive(true)
    self.icon_camp_b:SetActive(true)
    self.scoreNameTextBlue:SetActive(false)
    self.scoreNameTextRed:SetActive(false)
  else
    self.scoreNameTextBlue:SetText(SeasonUtil.GetWorldBattleName(AScoreInfo, false, false, serverId))
    self.scoreNameTextRed:SetText(SeasonUtil.GetWorldBattleName(BScoreInfo, false, true, serverId))
    self.scoreNameTextBlue:SetActive(true)
    self.scoreNameTextRed:SetActive(true)
    self.icon_camp_a:SetActive(false)
    self.icon_camp_b:SetActive(false)
  end
  local isBattleMember = SeasonUtil.IsBattleMember(serverId)
  local AIsEnemy = false
  local BIsEnemy = true
  if isBattleMember then
    AIsEnemy = not SeasonUtil.IsAlly(AScoreInfo.serverId, nil, AScoreInfo.allianceId)
    BIsEnemy = not SeasonUtil.IsAlly(BScoreInfo.serverId, nil, BScoreInfo.allianceId)
  end
  self.scoreValueSliderImgBlue:LoadSprite(self:GetProBg(AIsEnemy))
  self.scoreValueSliderImgRed:LoadSprite(self:GetProBg(BIsEnemy))
end

function UIWorldSiegeBatterySeason:CanShowScore(serverId)
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < configSchedule.crossStartTime or curTime > configSchedule.roundSettleTime then
      return false
    end
  end
  if SeasonUtil.IsNineKingActive(serverId) and not SeasonUtil.IsNineKingActive(serverId, true) then
    return false
  end
  return true
end

function UIWorldSiegeBatterySeason:GetProBg(isEnemy)
  if isEnemy then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_jindutiao02.png"
  else
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_jindutiao03.png"
  end
end

return UIWorldSiegeBatterySeason
