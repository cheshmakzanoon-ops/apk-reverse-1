local UILWSeasonMilitaryCenterWork = BaseClass("UILWSeasonMilitaryCenterWork", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local WorkItem = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenter.Component.UILWSeasonMilitaryCenterWorkItem")
local build_icon_path = "TargetItem/buildIcon"
local buff_btn_path = "TargetItem/buffBtn"
local title_path = "TargetItem/title"
local speed_now_path = "TargetItem/speedNow"
local speed_now_value_path = "TargetItem/speedNow/speedNowValue"
local speed_all_path = "TargetItem/speedAll"
local speed_all_value_path = "TargetItem/speedAll/speedAllValue"
local cell_path = "Cell"

function UILWSeasonMilitaryCenterWork:OnCreate()
  base.OnCreate(self)
  self.build_icon = self:AddComponent(UIButton, build_icon_path)
  self.buff_btn = self:AddComponent(UIButton, buff_btn_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.speed_now = self:AddComponent(UITextMeshProUGUIEx, speed_now_path)
  self.speed_now_value = self:AddComponent(UITextMeshProUGUIEx, speed_now_value_path)
  self.speed_all = self:AddComponent(UITextMeshProUGUIEx, speed_all_path)
  self.speed_all_value = self:AddComponent(UITextMeshProUGUIEx, speed_all_value_path)
  self.buff_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityBuff, {anim = true})
  end)
  self.build_icon:SetOnClick(function()
    if self.meta then
      local param = {}
      param.type = "nameDesc"
      param.title = Localization:GetString(self.meta.name)
      param.desc = Localization:GetString(self.meta.desc)
      param.isLocal = true
      param.alignObject = self.build_icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
end

function UILWSeasonMilitaryCenterWork:OnDestroy()
  self:RemoveComponents(WorkItem)
  self.theItem:GameObjectRecycleAll()
  self.build_icon = nil
  self.buff_btn = nil
  self.title = nil
  self.speed_now = nil
  self.speed_now_value = nil
  self.speed_all = nil
  self.speed_all_value = nil
  base.OnDestroy(self)
end

function UILWSeasonMilitaryCenterWork:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryCenterWork:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryCenterWork:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  self:RemoveComponents(WorkItem)
  self.theItem:GameObjectRecycleAll()
  local build = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  if build then
    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(build.level + build.buildId)
    if template ~= nil then
      local speedHour = 0
      local speedHourCity = 0
      if template.hour_product_stone then
        speedHour = toInt(template.hour_product_stone[ResourceType.AllianceStone]) * SEASON_MUMMY_RES_TIME_SCALE
      end
      local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
      local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
      local cityMeta
      for k, v in pairs(CrossOccupyCityList) do
        cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.cityId), v.serverId)
        if cityMeta and cityMeta.season_snow_stone_value ~= 0 and cityMeta.season_snow_stone_id == ResourceType.AllianceStone then
          speedHourCity = speedHourCity + toInt(cityMeta.season_snow_stone_value or 0)
        end
      end
      for k, v in pairs(CrossOccupyStrongholdList) do
        cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.id), v.serverId)
        if cityMeta and cityMeta.season_snow_stone_value ~= 0 and cityMeta.season_snow_stone_id == ResourceType.AllianceStone then
          speedHourCity = speedHourCity + toInt(cityMeta.season_snow_stone_value or 0)
        end
      end
      self.meta = template
      self.build_icon:LoadSprite(template:GetIconPath())
      self.title:SetLocalText(template.name)
      self.speed_now:SetLocalText("season_s3_alliance_res_build_speed_now")
      self.speed_all:SetLocalText("season_s3_alliance_res_build_speed_all")
      if build.status ~= AllianceMineStatus.Normal or build:Injuried() then
        self.speed_now_value:SetLocalText("season_s3_alliance_building_ui08")
        self.speed_all_value:SetText("+" .. speedHourCity .. "/h")
      else
        self.speed_now_value:SetText("+" .. speedHour .. "/h")
        self.speed_all_value:SetText("+" .. speedHourCity + speedHour .. "/h")
      end
      self.buff_btn:SetActive(false)
    end
  end
  local theAttachmentList = DataCenter.AllianceMineManager:GetAllianceCenterAttachmentList()
  if theAttachmentList ~= nil then
    local buildList = {}
    for _, theBuild in pairs(theAttachmentList) do
      buildList[theBuild.buildId + theBuild.level] = theBuild
    end
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(BuildingTypes.SEASON_MUMMY_CENTER)
    if meta then
      local maxLevel = meta.max_level
      local goItem, theItem
      for level = 1, maxLevel do
        meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(level + BuildingTypes.SEASON_MUMMY_CENTER)
        if meta and meta.active_building_id then
          goItem = self.theItem:GameObjectSpawn(self.transform)
          goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
          goItem:SetActive(true)
          theItem = self:AddComponent(WorkItem, goItem.name)
          theItem:ReInit(level, meta.active_building_id, buildList[meta.active_building_id])
        end
      end
    end
  end
end

return UILWSeasonMilitaryCenterWork
