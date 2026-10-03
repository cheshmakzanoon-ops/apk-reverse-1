local base = UIBaseContainer
local LWUIBagResourceOverviewItemRender = BaseClass("LWUIBagResourceOverviewItemRender", base)
local Localization = CS.GameEntry.Localization
local btn_path = "ImgQuality"
local icon_path = "ImgQuality/Icon"
local resourceContent_path = "ResourceContent"
local ownValueText_path = "ResourceContent/OwnValueText"
local bagCountText_path = "ResourceContent/BagCountText"
local totalValueText_path = "ResourceContent/TotalValueText"
local speedUpDesText_path = "SpeedUpContent/SpeedUpDesText"
local speedUpValueText_path = "SpeedUpContent/SpeedUpValueText"
local speedUpContent_path = "SpeedUpContent"
local otherContent_path = "OtherContent"
local otherBagCountText_path = "OtherContent/OtherBagCountText"
local otherOwnValueText_path = "OtherContent/OtherOwnValueText"
local otherTotalValueText_path = "OtherContent/OtherTotalValueText"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.resourceContent = self:AddComponent(UIBaseContainer, resourceContent_path)
  self.ownValueText = self:AddComponent(UIText, ownValueText_path)
  self.bagCountText = self:AddComponent(UIText, bagCountText_path)
  self.totalValueText = self:AddComponent(UIText, totalValueText_path)
  self.speedUpDesText = self:AddComponent(UIText, speedUpDesText_path)
  self.speedUpValueText = self:AddComponent(UIText, speedUpValueText_path)
  self.speedUpContent = self:AddComponent(UIBaseContainer, speedUpContent_path)
  self.otherContent = self:AddComponent(UIBaseContainer, otherContent_path)
  self.otherBagCountText = self:AddComponent(UIText, otherBagCountText_path)
  self.otherOwnValueText = self:AddComponent(UIText, otherOwnValueText_path)
  self.otherTotalValueText = self:AddComponent(UIText, otherTotalValueText_path)
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.icon = nil
  self.resourceContent = nil
  self.ownValueText = nil
  self.bagCountText = nil
  self.totalValueText = nil
  self.speedUpDesText = nil
  self.speedUpValueText = nil
  self.speedUpContent = nil
  self.otherContent = nil
  self.otherBagCountText = nil
  self.otherOwnValueText = nil
  self.otherTotalValueText = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.data = nil
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SelectBagResourceOverviewTimeToggle, self.UpdateSpeedUpTimeView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.SelectBagResourceOverviewTimeToggle, self.UpdateSpeedUpTimeView)
  base.OnRemoveListener(self)
end

local function InitData(self, index, data)
  self.itemIndex = index
  self.data = data
  self.resourceContent:SetActive(self.data.tabType == BagResourceOverviewTabType.Resource)
  self.speedUpContent:SetActive(self.data.tabType == BagResourceOverviewTabType.SpeedUp)
  self.otherContent:SetActive(self.data.tabType == BagResourceOverviewTabType.Other)
  local iconPath = ""
  if self.data.tabType == BagResourceOverviewTabType.Resource then
    self.ownValueText:SetText(string.GetFormattedStr(self.data.ownValue))
    self.bagCountText:SetText(string.GetFormattedStr(self.data.bagValue))
    local totalValue = self.data.ownValue + self.data.bagValue
    self.totalValueText:SetText(string.GetFormattedStr(totalValue))
    iconPath = DataCenter.ResourceManager:GetResourceIconByType(self.data.itemId)
  elseif self.data.tabType == BagResourceOverviewTabType.SpeedUp then
    self.speedUpDesText:SetLocalText(self:GetSpeedUpName())
    local iconName = self:GetSpeedUpIcon()
    iconPath = string.format(LoadPath.ItemPath, iconName)
    self:UpdateSpeedUpTimeView()
  elseif self.data.tabType == BagResourceOverviewTabType.Other then
    local cfg = BagResOverViewOtherSetting[self.data.itemId]
    if cfg then
      iconPath = cfg.iconPath
    end
    if self.data.itemId == BagResOverViewOtherType.HeroExp then
      local icon_full_path = GetTableData(TableName.Aps_Resource_Item, tonumber(self.data.itemId), "pic_new")
      if string.IsNullOrEmpty(icon_full_path) then
        local iconName = GetTableData(TableName.Aps_Resource_Item, tonumber(self.data.itemId), "pic")
        iconPath = string.format(LoadPath.ItemPath, iconName)
      else
        iconPath = icon_full_path
      end
    end
    self.otherOwnValueText:SetText(string.GetFormattedStr(self.data.ownValue))
    self.otherBagCountText:SetText(string.GetFormattedStr(self.data.bagValue))
    local totalValue = self.data.ownValue + self.data.bagValue
    self.otherTotalValueText:SetText(string.GetFormattedStr(totalValue))
  end
  self.icon:LoadSprite(iconPath)
end

local function GetSpeedUpName(self)
  local name = ""
  if self.data.itemId == ItemSpdMenu.ItemSpdMenu_ALL then
    return "universal_speed_statistics"
  elseif self.data.itemId == ItemSpdMenu.ItemSpdMenu_City then
    return "building_speed_statistics"
  elseif self.data.itemId == ItemSpdMenu.ItemSpdMenu_Science then
    return "science_speed_statistics"
  elseif self.data.itemId == ItemSpdMenu.ItemSpdMenu_Soldier then
    return "training_speed_statistics"
  elseif self.data.itemId == ItemSpdMenu.ItemSpdMenu_Heal then
    return "cure_speed_statistics"
  end
  return name
end

local function GetSpeedUpIcon(self)
  local icon = ""
  if self.data.itemId == ItemSpdMenu.ItemSpdMenu_ALL then
    return "item200"
  elseif self.data.itemId == ItemSpdMenu.ItemSpdMenu_City then
    return "item207"
  elseif self.data.itemId == ItemSpdMenu.ItemSpdMenu_Science then
    return "item204"
  elseif self.data.itemId == ItemSpdMenu.ItemSpdMenu_Soldier then
    return "item205"
  elseif self.data.itemId == ItemSpdMenu.ItemSpdMenu_Heal then
    return "item203"
  end
  return icon
end

local function UpdateSpeedUpTimeView(self)
  local showTimeType = self.view.ctrl:GetSpeedUpTimeShowType()
  local day, hour, minute, second = UITimeManager:GetInstance():MilliSecondToDHMS(self.data.ownValue * 1000)
  if showTimeType == BagResourceOverviewShowTimeType.Day then
    if 0 < day then
      self.speedUpValueText:SetLocalText("according_day_statistics_para", day, hour, minute)
    elseif 0 < hour then
      self.speedUpValueText:SetLocalText("according_hour_statistics_para", hour, minute)
    else
      self.speedUpValueText:SetLocalText("according_minute_statistics_para", minute)
    end
  elseif showTimeType == BagResourceOverviewShowTimeType.Hour then
    if 0 < day then
      hour = hour + day * 24
    end
    if 0 < hour then
      self.speedUpValueText:SetLocalText("according_hour_statistics_para", hour, minute)
    else
      self.speedUpValueText:SetLocalText("according_minute_statistics_para", minute)
    end
  elseif showTimeType == BagResourceOverviewShowTimeType.Minute then
    if 0 < day then
      minute = minute + day * 24 * 60
    end
    if 0 < hour then
      minute = minute + hour * 60
    end
    self.speedUpValueText:SetLocalText("according_minute_statistics_para", minute)
  end
end

local function BtnClick(self)
  if self.data.tabType == BagResourceOverviewTabType.Resource then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, self.data.itemId)
  elseif self.data.tabType == BagResourceOverviewTabType.Other then
    if self.data.itemId == BagResOverViewOtherType.Stamina then
      LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy, nil, true)
    elseif self.data.itemId == BagResOverViewOtherType.HeroExp or self.data.itemId == BagResOverViewOtherType.Gold then
      local cfg = BagResOverViewOtherSetting[self.data.itemId]
      if cfg then
        local content = Localization:GetString(cfg.iconName)
        UIUtil.ShowBubbleTipsAuto(content, self.btn.transform.position, 0, -15, 0, nil, nil)
      end
    end
  end
end

LWUIBagResourceOverviewItemRender.OnCreate = OnCreate
LWUIBagResourceOverviewItemRender.OnDestroy = OnDestroy
LWUIBagResourceOverviewItemRender.OnEnable = OnEnable
LWUIBagResourceOverviewItemRender.OnDisable = OnDisable
LWUIBagResourceOverviewItemRender.ComponentDefine = ComponentDefine
LWUIBagResourceOverviewItemRender.ComponentDestroy = ComponentDestroy
LWUIBagResourceOverviewItemRender.DataDefine = DataDefine
LWUIBagResourceOverviewItemRender.DataDestroy = DataDestroy
LWUIBagResourceOverviewItemRender.OnAddListener = OnAddListener
LWUIBagResourceOverviewItemRender.OnRemoveListener = OnRemoveListener
LWUIBagResourceOverviewItemRender.InitData = InitData
LWUIBagResourceOverviewItemRender.GetSpeedUpName = GetSpeedUpName
LWUIBagResourceOverviewItemRender.GetSpeedUpIcon = GetSpeedUpIcon
LWUIBagResourceOverviewItemRender.UpdateSpeedUpTimeView = UpdateSpeedUpTimeView
LWUIBagResourceOverviewItemRender.BtnClick = BtnClick
return LWUIBagResourceOverviewItemRender
