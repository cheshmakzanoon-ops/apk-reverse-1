local DeclareConditionItem = BaseClass("DeclareConditionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local CityItem = require("UI.UIDeclareCondition.Component.CityItem")
local bg_path = "bg"
local image_path = "Image"
local tick_path = "Image/tick"
local title_path = "Image/title"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local desc_path = "desc"

function DeclareConditionItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function DeclareConditionItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DeclareConditionItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.tick = self:AddComponent(UIImage, tick_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
end

function DeclareConditionItem:ComponentDestroy()
  self:RemoveCities()
end

function DeclareConditionItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshCityDeclareCount, self.OnRefreshCityDeclareCount)
end

function DeclareConditionItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshCityDeclareCount, self.OnRefreshCityDeclareCount)
end

function DeclareConditionItem:OnRefreshCityDeclareCount()
  if self.conditionType == DeclareCondition.DeclareLimit then
    self:Refresh(DeclareCondition.DeclareLimit)
  end
end

function DeclareConditionItem:Refresh(data)
  self:RemoveCities()
  local conditionType = data
  self.conditionType = conditionType
  local satisfy = false
  if conditionType == DeclareCondition.AdjacentCity then
    satisfy = DataCenter.WorldAllianceCityDataManager:GetCityIsNearBySelfAlliance(LuaEntry.Player:GetAllianceUid(), self.view:GetCityId())
    if satisfy then
      self.scroll_view:SetActive(false)
      self.bg:SetActive(false)
      self.title:SetLocalText("new_city_activity_battle_declear_tips1006")
    else
      self.scroll_view:SetActive(true)
      self.bg:SetActive(true)
      self.title:SetLocalText("new_city_activity_battle_declear_tips1001")
      local cities = DataCenter.AllianceCityTemplateManager:GetAllNearByCities(self.view:GetCityId())
      self:RefreshCities(cities)
    end
  elseif conditionType == DeclareCondition.LevelOne then
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(self.view:GetCityId())
    satisfy = template.level == 1
    if satisfy then
      self.scroll_view:SetActive(false)
      self.bg:SetActive(false)
      self.title:SetLocalText("new_city_activity_battle_declear_tips1013")
    else
      self.scroll_view:SetActive(true)
      self.bg:SetActive(true)
      self.title:SetLocalText("new_city_activity_battle_declear_tips1013")
      local cities = DataCenter.WorldAllianceCityDataManager:GetAllAdjCityByAllianceId(LuaEntry.Player:GetAllianceUid())
      self:RefreshCities(cities)
    end
  elseif conditionType == DeclareCondition.AdjacentStronghold then
    satisfy = DataCenter.WorldAllianceCityDataManager:GetCityIsNearBySelfAlliance(LuaEntry.Player:GetAllianceUid(), self.view:GetCityId())
    if satisfy then
      self.scroll_view:SetActive(false)
      self.bg:SetActive(false)
      self.title:SetLocalText("season_tips229")
    else
      self.scroll_view:SetActive(true)
      self.bg:SetActive(true)
      self.title:SetLocalText("season_tips229")
      local cities = DataCenter.AllianceCityTemplateManager:GetAllNearByCities(self.view:GetCityId())
      self:RefreshCities(cities)
    end
  elseif conditionType == DeclareCondition.OccupyLimit then
    local occupied = DataCenter.WorldAllianceCityDataManager:GetAllCityTemplateByAlId(LuaEntry.Player:GetAllianceUid(), true)
    local cityMax = SeasonUtil.GetOccupyCityMaxCount()
    satisfy = cityMax > #occupied
    if satisfy then
      self.scroll_view:SetActive(false)
      self.bg:SetActive(false)
      self.title:SetLocalText("new_city_activity_battle_declear_tips1007", #occupied, cityMax)
    else
      self.scroll_view:SetActive(true)
      self.bg:SetActive(true)
      self.title:SetLocalText("new_city_activity_battle_declear_tips1002", #occupied, cityMax)
      self:RefreshCities(occupied)
    end
  elseif conditionType == DeclareCondition.DeclareLimit then
    self.bg:SetActive(false)
    self.scroll_view:SetActive(false)
    local timeDeclare = DataCenter.AllianceDeclareWarManager:GetDeclareTime()
    local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
    satisfy = timeDeclare < k6
    if satisfy then
      self.title:SetLocalText("new_city_activity_battle_declear_tips1008", timeDeclare, k6)
    else
      self.title:SetLocalText("new_city_activity_battle_declear_tips1003", timeDeclare, k6)
    end
  elseif conditionType == DeclareCondition.NewAlliance then
    self.bg:SetActive(false)
    self.scroll_view:SetActive(false)
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local createTime = 0
    if baseData and baseData.createTime then
      createTime = baseData.createTime
    end
    local k7 = DataCenter.AllianceDeclareWarManager:GetConfigData("k7")
    local allianceHour = math.floor((UITimeManager:GetInstance():GetServerTime() - createTime) / 3600000)
    satisfy = k7 <= allianceHour
    if satisfy then
      self.title:SetLocalText("new_city_activity_battle_declear_tips1009", k7)
    else
      self.title:SetLocalText("new_city_activity_battle_declear_tips1004", k7)
    end
  elseif conditionType == DeclareCondition.SmallAlliance then
    self.bg:SetActive(false)
    self.scroll_view:SetActive(false)
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local curMember = 0
    if baseData and baseData.curMember then
      curMember = baseData.curMember
    end
    local k5 = DataCenter.AllianceDeclareWarManager:GetConfigData("k5")
    satisfy = curMember >= k5
    if satisfy then
      self.title:SetLocalText("new_city_activity_battle_declear_tips1010", k5)
    else
      self.title:SetLocalText("new_city_activity_battle_declear_tips1005", k5)
    end
  end
  self.tick:LoadSprite(satisfy and "Assets/Main/Sprites/UI/UIAttackCity/lrb_xuanzhanjiemian_fuhetiaojian.png" or "Assets/Main/Sprites/UI/UIAttackCity/lrb_xuanzhanjiemian_bufuhetiaojian.png")
  self.bg:LoadSprite(satisfy and "Assets/Main/Sprites/UI/UIAttackCity/lrb_xuanzhanjiemian_fuhetiaojianbg.png" or "Assets/Main/Sprites/UI/UIAttackCity/lrb_xuanzhanjiemian_bufuhetiaojianbg.png")
  if satisfy then
    self.image:SetColorRGBA(0.69, 0.91, 0.73, 1)
  else
    self.image:SetColorRGBA(1, 0.7, 0.66, 1)
  end
  return satisfy
end

function DeclareConditionItem:RefreshCities(cities)
  for i, city in pairs(cities) do
    self.rewardReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/World/DeclareCityItem.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(CityItem, nameStr)
      cell:Refresh(city, self.conditionType)
    end)
  end
end

function DeclareConditionItem:RemoveCities()
  self.content:RemoveComponents(CityItem)
  if self.rewardReqs then
    for _, v in pairs(self.rewardReqs) do
      v:Destroy()
    end
  end
  self.rewardReqs = {}
end

return DeclareConditionItem
