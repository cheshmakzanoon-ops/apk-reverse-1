local UILWSeasonCrossOccupyDetailItem = BaseClass("UILWSeasonCrossOccupyDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_path = "name"
local icon_city_path = "iconCity"
local count_city_path = "iconCity/countCity"
local msg_city_path = "iconCity/msgCity"
local icon_stronghold_path = "iconStronghold"
local count_stronghold_path = "iconStronghold/countStronghold"
local msg_stronghold_path = "iconStronghold/msgStronghold"
local bg1_path = "bg1"
local bg2_path = "bg2"
local influence_city_title_path = "iconCity/influenceCityTitle"
local influence_city_value_path = "iconCity/influenceCityValue"
local influence_stronghold_title_path = "iconStronghold/influenceStrongholdTitle"
local influence_stronghold_value_path = "iconStronghold/influenceStrongholdValue"

function UILWSeasonCrossOccupyDetailItem:OnCreate()
  base.OnCreate(self)
  self.bg1 = self:AddComponent(UIRawImage, bg1_path)
  self.bg2 = self:AddComponent(UIRawImage, bg2_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.icon_city = self:AddComponent(UIImage, icon_city_path)
  self.count_city = self:AddComponent(UITextMeshProUGUIEx, count_city_path)
  self.msg_city = self:AddComponent(UITextMeshProUGUIEx, msg_city_path)
  self.icon_stronghold = self:AddComponent(UIImage, icon_stronghold_path)
  self.count_stronghold = self:AddComponent(UITextMeshProUGUIEx, count_stronghold_path)
  self.msg_stronghold = self:AddComponent(UITextMeshProUGUIEx, msg_stronghold_path)
  self.influence_city_title = self:AddComponent(UITextMeshProUGUIEx, influence_city_title_path)
  self.influence_city_value = self:AddComponent(UITextMeshProUGUIEx, influence_city_value_path)
  self.influence_stronghold_title = self:AddComponent(UITextMeshProUGUIEx, influence_stronghold_title_path)
  self.influence_stronghold_value = self:AddComponent(UITextMeshProUGUIEx, influence_stronghold_value_path)
end

function UILWSeasonCrossOccupyDetailItem:OnDestroy()
  self.bg1 = nil
  self.bg2 = nil
  self.name = nil
  self.icon_city = nil
  self.count_city = nil
  self.msg_city = nil
  self.icon_stronghold = nil
  self.count_stronghold = nil
  self.msg_stronghold = nil
  self.influence_city_title = nil
  self.influence_city_value = nil
  self.influence_stronghold_title = nil
  self.influence_stronghold_value = nil
  base.OnDestroy(self)
end

function UILWSeasonCrossOccupyDetailItem:ReInit(localServer)
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
  local local_city_force = 0
  local other_city_force = 0
  local local_stronghold_force = 0
  local other_stronghold_force = 0
  local local_city_count = 0
  local other_city_count = 0
  local local_stronghold_count = 0
  local other_stronghold_count = 0
  local cityMeta
  for k, v in pairs(CrossOccupyCityList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.cityId), v.serverId)
    if cityMeta and cityMeta:IsCity() then
      if localServer and v.serverId == sourceServerId then
        local_city_force = local_city_force + cityMeta.force
        local_city_count = local_city_count + 1
      elseif v.serverId ~= sourceServerId then
        other_city_force = other_city_force + cityMeta.force
        other_city_count = other_city_count + 1
      end
    end
  end
  for k, v in pairs(CrossOccupyStrongholdList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.id), v.serverId)
    if cityMeta and cityMeta:IsCityStronghold() then
      if localServer and v.serverId == sourceServerId then
        local_stronghold_force = local_stronghold_force + cityMeta.force
        local_stronghold_count = local_stronghold_count + 1
      elseif v.serverId ~= sourceServerId then
        other_stronghold_force = other_stronghold_force + cityMeta.force
        other_stronghold_count = other_stronghold_count + 1
      end
    end
  end
  local strongholdMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s1_stronghold", "k4", 30))
  local strongholdMaxLocal = strongholdMax
  local strongholdMaxOther = 0
  local CrossOccupyStrongholdMaxNum = DataCenter.SeasonDataManager.CrossOccupyStrongholdMaxNum
  local occupyServerCount = 0
  if CrossOccupyStrongholdMaxNum then
    for k, v in pairs(CrossOccupyStrongholdMaxNum) do
      if toInt(k) == sourceServerId then
        strongholdMaxLocal = toInt(v)
      else
        occupyServerCount = occupyServerCount + 1
        strongholdMaxOther = strongholdMaxOther + toInt(v)
      end
    end
  end
  if 4 < occupyServerCount then
    strongholdMaxOther = strongholdMaxOther - strongholdMax * (occupyServerCount - 4)
  end
  self.localServer = localServer
  if localServer then
    self.count_city:SetLocalText(150033, local_city_count, DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal)
    self.count_stronghold:SetLocalText(150033, local_stronghold_count, strongholdMaxLocal)
    self.msg_city:SetActive(false)
    self.msg_stronghold:SetActive(false)
    self.influence_city_title:SetActive(true)
    self.influence_city_value:SetActive(true)
    self.influence_stronghold_title:SetActive(true)
    self.influence_stronghold_value:SetActive(true)
    self.influence_city_value:SetText("+" .. string.GetFormattedSeparatorNum(local_city_force))
    self.influence_stronghold_value:SetText("+" .. string.GetFormattedSeparatorNum(local_stronghold_force))
  else
    local CrossAttackStrongholdActivityType = EnumActivity.SeasonCrossAttackCityActivity.Type
    local CrossAttackCityActivityType = EnumActivity.SeasonCrossDeclareWarActivity.Type
    local hasCrossAttackStronghold = false
    local hasCrossAttackCity = false
    local seasonSettleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.count_city:SetLocalText(150033, other_city_count, DataCenter.SeasonDataManager.CrossOccupyCityMaxNumOther)
    self.count_stronghold:SetLocalText(150033, other_stronghold_count, strongholdMaxOther)
    if seasonSettleTime <= curTime then
      hasCrossAttackStronghold = true
      hasCrossAttackCity = true
    else
      hasCrossAttackStronghold = DataCenter.ActivityListDataManager:CheckIfActivityOpen(CrossAttackStrongholdActivityType)
      hasCrossAttackCity = DataCenter.ActivityListDataManager:CheckIfActivityOpen(CrossAttackCityActivityType)
    end
    if hasCrossAttackCity and hasCrossAttackStronghold then
      self.previewInfoCity = nil
      self.icon_city:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/ServerDetail/lrb_jdzl_chengshi_icon.png")
      self.bg2:LoadSprite("Assets/Main/TextureEx/Season/ServerDetail/lrb_jdzl_bgzi.png")
      self.msg_city:SetActive(false)
      self.influence_city_title:SetActive(true)
      self.influence_city_value:SetActive(true)
      self.influence_city_value:SetText("+" .. string.GetFormattedSeparatorNum(other_city_force))
      self.previewInfoStronghold = nil
      self.icon_stronghold:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/ServerDetail/lrb_jdzl_jvdian_icon.png")
      self.bg1:LoadSprite("Assets/Main/TextureEx/Season/ServerDetail/lrb_jdzl_bgzi.png")
      self.msg_stronghold:SetActive(false)
      self.influence_stronghold_title:SetActive(true)
      self.influence_stronghold_value:SetActive(true)
      self.influence_stronghold_value:SetText("+" .. string.GetFormattedSeparatorNum(other_stronghold_force))
    else
      local ActivityIds = DataCenter.SeasonDataManager:GetActivityIds()
      local seasonActivity = DataCenter.SeasonDataManager.ActivityPreviewInfos or {}
      for activityId, existIt in pairs(ActivityIds) do
        if existIt then
          local cfg = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
          if not hasCrossAttackCity and cfg ~= nil and toInt(cfg.type) == CrossAttackCityActivityType then
            self.previewInfoCity = seasonActivity[tostring(activityId)]
          elseif not hasCrossAttackStronghold and cfg ~= nil and toInt(cfg.type) == CrossAttackStrongholdActivityType then
            self.previewInfoStronghold = seasonActivity[tostring(activityId)]
          end
        end
      end
      if hasCrossAttackCity then
        self.previewInfoCity = nil
        self.icon_city:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/ServerDetail/lrb_jdzl_chengshi_icon.png")
        self.bg2:LoadSprite("Assets/Main/TextureEx/Season/ServerDetail/lrb_jdzl_bgzi.png")
        self.msg_city:SetActive(false)
        self.influence_city_title:SetActive(true)
        self.influence_city_value:SetActive(true)
        self.influence_city_value:SetText("+" .. string.GetFormattedSeparatorNum(other_city_force))
      else
        self.msg_city:SetLocalText("372617")
        self.msg_city:SetActive(true)
        self.influence_city_title:SetActive(false)
        self.influence_city_value:SetActive(false)
        self.bg2:LoadSprite("Assets/Main/TextureEx/Season/ServerDetail/lrb_jdzl_bghui.png")
        self.icon_city:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/ServerDetail/cfm_tubiao_suo.png")
      end
      if hasCrossAttackStronghold then
        self.previewInfoStronghold = nil
        self.icon_stronghold:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/ServerDetail/lrb_jdzl_jvdian_icon.png")
        self.bg1:LoadSprite("Assets/Main/TextureEx/Season/ServerDetail/lrb_jdzl_bgzi.png")
        self.msg_stronghold:SetActive(false)
        self.influence_stronghold_title:SetActive(true)
        self.influence_stronghold_value:SetActive(true)
        self.influence_stronghold_value:SetText("+" .. string.GetFormattedSeparatorNum(other_stronghold_force))
      else
        self.msg_stronghold:SetLocalText("372617")
        self.msg_stronghold:SetActive(true)
        self.influence_stronghold_title:SetActive(false)
        self.influence_stronghold_value:SetActive(false)
        self.bg1:LoadSprite("Assets/Main/TextureEx/Season/ServerDetail/lrb_jdzl_bghui.png")
        self.icon_stronghold:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/ServerDetail/cfm_tubiao_suo.png")
      end
      self:Update1000MS()
    end
  end
end

function UILWSeasonCrossOccupyDetailItem:Update1000MS()
  if self.localServer ~= true and (self.previewInfoCity ~= nil or self.previewInfoStronghold ~= nil) then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.previewInfoCity ~= nil then
      if self.previewInfoCity.startTime ~= nil then
        local remainTime = self.previewInfoCity.startTime - curTime
        if 0 < remainTime then
          local strTime = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
          self.msg_city:SetLocalText("champion_duel_tips1104", strTime)
        else
          self.msg_city:SetLocalText("372617")
          self.previewInfoCity = nil
        end
      else
        self.msg_city:SetLocalText("372617")
        self.previewInfoCity = nil
      end
    end
    if self.previewInfoStronghold ~= nil then
      if self.previewInfoStronghold.startTime ~= nil then
        local remainTime = self.previewInfoStronghold.startTime - curTime
        if 0 < remainTime then
          local strTime = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
          self.msg_stronghold:SetLocalText("champion_duel_tips1104", strTime)
        else
          self.msg_stronghold:SetLocalText("372617")
          self.previewInfoStronghold = nil
        end
      else
        self.msg_stronghold:SetLocalText("372617")
        self.previewInfoStronghold = nil
      end
    end
  end
end

return UILWSeasonCrossOccupyDetailItem
