local base = UIBaseContainer
local LWResourceListItemComponent = BaseClass("LWResourceListItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWResourceListItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWResourceListItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWResourceListItemComponent:ComponentDefine()
  self.compBgDark = self:AddComponent(UIBaseContainer, "BgDark")
  self.compBgWhite = self:AddComponent(UIBaseContainer, "BgWhite")
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.textSeason = self:AddComponent(UIText, "SeasonText")
  self.textSpeed = self:AddComponent(UITextMeshProUGUIEx, "SpeedText")
  self.textOwn = self:AddComponent(UITextMeshProUGUIEx, "Own/OwnText")
  self.compMin = self:AddComponent(UIBaseContainer, "Own/Min")
  self.textMin = self:AddComponent(UITextMeshProUGUIEx, "Own/Min/MinText")
end

function LWResourceListItemComponent:ComponentDestroy()
  self.compBgDark = nil
  self.compBgWhite = nil
  self.imgIcon = nil
  self.textSeason = nil
  self.textSpeed = nil
  self.textOwn = nil
  self.compMin = nil
  self.textMin = nil
end

function LWResourceListItemComponent:DataDefine()
  self.template = nil
end

function LWResourceListItemComponent:DataDestroy()
  self.template = nil
end

function LWResourceListItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWResourceListItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWResourceListItemComponent:ReInit(template, index)
  self.template = template
  self.index = index
  if self.template == nil then
    return
  end
  if self.template.type == DataCenter.ResourceListManager.Type.Resource then
    self:UpdateResource()
  elseif self.template.type == DataCenter.ResourceListManager.Type.ResourceItem then
    self:UpdateResourceItem()
  elseif self.template.type == DataCenter.ResourceListManager.Type.Goods then
    self:UpdateGoods()
  end
  self.compBgDark:SetActive(self.index % 2 == 1)
  self.compBgWhite:SetActive(self.index % 2 == 0)
end

function LWResourceListItemComponent:UpdateResource()
  local resourceType = self.template.resources_id
  local iconPath = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
  self.imgIcon:LoadSprite(iconPath)
  self.imgIcon:SetSizeDeltaXY(50, 50)
  local hasCount = LuaEntry.Resource:GetCntByResType(resourceType)
  self.textOwn:SetText(string.GetFormattedStr(hasCount))
  local speed = self.view.ctrl:GetResourceSpeedCountPerHour(resourceType)
  if self.template.time == 1 then
    self.textSpeed:SetText(string.GetFormattedStr(speed) .. "/H")
  elseif self.template.time == 3 then
    self.textSpeed:SetText(string.GetFormattedStr(speed * 24) .. "/DAY")
  end
  local showMin = false
  if self.template.protect_num == 1 then
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
    local need = 0
    if template ~= nil and not string.IsNullOrEmpty(template.protect_effect_number) then
      local num = tonumber(template.protect_effect_number)
      need = toInt(LuaEntry.Effect:GetGameEffect(num))
      local addRate = 1
      if resourceType == ResourceType.Food then
        addRate = addRate + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceFoodProductAddRate) + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceExtraProductAddRate)
      elseif resourceType == ResourceType.Metal then
        addRate = addRate + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceMetalProductAddRate) + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceExtraProductAddRate)
      elseif resourceType == ResourceType.Wood then
        addRate = addRate + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceWoodProductAddRate) + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceExtraProductAddRate)
      end
      need = need * addRate
    end
    if 0 < need then
      showMin = true
      self.textMin:SetText(string.GetFormattedStr(need))
    end
  end
  self.compMin:SetActive(showMin)
  self.textSeason:SetActive(0 < self.template.season_material)
  if 0 < self.template.season_material then
    local curSeason = SeasonUtil.GetSeason()
    self.textSeason:SetText("S" .. curSeason)
  end
end

function LWResourceListItemComponent:UpdateResourceItem()
  local resourceItemId = self.template.resource_item_id
  local iconPath = DataCenter.ResourceItemDataManager:GetIconPath(resourceItemId)
  self.imgIcon:LoadSprite(iconPath)
  self.imgIcon:SetSizeDeltaXY(75, 75)
  local hasCount = 0
  local resourceItem = DataCenter.ResourceItemDataManager:GetItemDataByItemId(resourceItemId)
  if resourceItem ~= nil then
    hasCount = resourceItem.number
  end
  self.textOwn:SetText(string.GetFormattedStr(hasCount))
  local speed = self.view.ctrl:GetResourceItemSpeedCountPerHour(resourceItemId)
  if self.template.time == 1 then
    self.textSpeed:SetText(string.GetFormattedStr(speed) .. "/H")
  elseif self.template.time == 3 then
    self.textSpeed:SetText(string.GetFormattedStr(speed * 24) .. "/DAY")
  end
  local showMin = false
  self.compMin:SetActive(showMin)
  self.textSeason:SetActive(0 < self.template.season_material)
  if 0 < self.template.season_material then
    local curSeason = SeasonUtil.GetSeason()
    self.textSeason:SetText("S" .. curSeason)
  end
end

function LWResourceListItemComponent:UpdateGoods()
  local itemId = self.template.goods_id
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(itemId)
  self.imgIcon:LoadSprite(iconPath)
  self.imgIcon:SetSizeDeltaXY(75, 75)
  local hasCount = DataCenter.ItemData:GetItemCount(itemId) or 0
  self.textOwn:SetText(string.GetFormattedStr(hasCount))
  local speed = self.view.ctrl:GetGoodsSpeedCountPerHour(itemId)
  if self.template.time == 1 then
    self.textSpeed:SetText(string.GetFormattedStr(speed) .. "/H")
  elseif self.template.time == 3 then
    self.textSpeed:SetText(string.GetFormattedStr(speed * 24) .. "/DAY")
  end
  local showMin = false
  self.compMin:SetActive(showMin)
  self.textSeason:SetActive(0 < self.template.season_material)
  if 0 < self.template.season_material then
    local curSeason = SeasonUtil.GetSeason()
    self.textSeason:SetText("S" .. curSeason)
  end
end

return LWResourceListItemComponent
