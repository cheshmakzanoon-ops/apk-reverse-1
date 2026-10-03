local base = UIBaseContainer
local TradeStationHonorItem = BaseClass("TradeStationHonorItem", base)
local city_name_path = "content/cityName"
local compUIPlayerHead_path = "content/UIPlayerHead"
local city_icon_path = "content/completeRoot/cityIcon"
local city_btn_path = "content/cityBtn"
local stars_path = "content/Stars"
local star_path = "content/Stars/iconStar"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.city_name = self:AddComponent(UIText, city_name_path)
  self.compUIPlayerHead = self:AddComponent(UIBaseContainer, compUIPlayerHead_path)
  self.city_icon = self:AddComponent(UIImage, city_icon_path)
  self.city_btn = self:AddComponent(UIButton, city_btn_path)
  self.stars = self:AddComponent(UIBaseContainer, stars_path)
  self.star = self:AddComponent(UIBaseContainer, star_path)
  self.compUIPlayerHead = self:AddComponent(UICommonHead, compUIPlayerHead_path)
  self.city_btn:SetOnClick(function()
    self:OnCityBtnClick()
  end)
  self.itemObj = self.star.gameObject
  self.itemObj:GameObjectCreatePool()
  self.itemObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.stars:RemoveComponents(UIImage)
  self.itemObj:GameObjectRecycleAll()
  self.city_name = nil
  self.compUIPlayerHead = nil
  self.city_icon = nil
  self.city_btn = nil
  self.stars = nil
  self.star = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeStationHonorItem:ReInit(param)
  local starList, index = {}, 1
  for i, v in ipairs(param.tradeCityLevelArr) do
    for j = 1, v.num do
      starList[index] = v.level
      index = index + 1
      if 4 < index then
        break
      end
    end
  end
  param.starList = starList
  self.data = param
  self:Refresh()
end

function TradeStationHonorItem:Refresh()
  if not self.data then
    return
  end
  local info = self.data.userInfo
  self.compUIPlayerHead:SetHeadAndFrame(info.uid, info.pic, info.picver)
  self.city_name:SetText(string.format("[%s] %s", info.abbr, info.name))
  local skinId = self.data.baseSkinId
  local skinTemplate = skinId and DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  local icon = skinTemplate and skinTemplate.icon
  if not string.IsNullOrEmpty(icon) then
    self.city_icon:LoadSprite(icon)
  end
  self.stars:RemoveComponents(UIImage)
  self.itemObj:GameObjectRecycleAll()
  local goItem, theItem
  for i, level in ipairs(self.data.starList) do
    goItem = self.itemObj:GameObjectSpawn(self.stars.transform)
    goItem.name = string.format("star_%d", i)
    theItem = self.stars:AddComponent(UIImage, goItem.name)
    local config = DataCenter.SeasonTradeDataManager:GetTitleTemplateByLevel(level)
    if config then
      theItem:LoadSprite(config.message_show_icon)
      goItem:SetActive(true)
    else
      goItem:SetActive(false)
    end
    if 5 <= i then
      break
    end
  end
end

function TradeStationHonorItem:OnCityBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {
    serverId = self.data.userInfo.serverId,
    uid = self.data.userInfo.uid
  })
end

TradeStationHonorItem.OnCreate = OnCreate
TradeStationHonorItem.OnDestroy = OnDestroy
TradeStationHonorItem.OnEnable = OnEnable
TradeStationHonorItem.OnDisable = OnDisable
TradeStationHonorItem.ComponentDefine = ComponentDefine
TradeStationHonorItem.ComponentDestroy = ComponentDestroy
TradeStationHonorItem.DataDefine = DataDefine
TradeStationHonorItem.DataDestroy = DataDestroy
return TradeStationHonorItem
