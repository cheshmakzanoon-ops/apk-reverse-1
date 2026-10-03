local base = UIBaseContainer
local CommonGroupCostItemComponent = BaseClass("CommonGroupCostItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function CommonGroupCostItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonGroupCostItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonGroupCostItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textCost = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function CommonGroupCostItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textCost = nil
end

function CommonGroupCostItemComponent:DataDefine()
end

function CommonGroupCostItemComponent:DataDestroy()
end

function CommonGroupCostItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function CommonGroupCostItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CommonGroupCostItemComponent:RefreshCost()
  if not self.itemId or not self.cost then
    self.textCost:SetText("")
    return
  end
  local have = self:GetHaveResCount()
  local colorStr = ""
  if self.whiteColor then
    colorStr = "<color=#FFFFFF>"
  elseif have < self.cost then
    colorStr = "<color=#F97077>"
  else
    colorStr = "<color=#5FEF87>"
  end
  local haveStr = string.GetFormattedStr2(have)
  local costStr = string.GetFormattedStr2(self.cost)
  self.textCost:SetText(string.format("%s%s</color>/%s", colorStr, haveStr, costStr))
end

function CommonGroupCostItemComponent:ReInit(itemId, cost, type, whiteColor)
  self.itemId = itemId
  self.cost = cost
  self.type = type
  self.whiteColor = whiteColor
  self:RefreshIcon()
  self:RefreshCost()
end

function CommonGroupCostItemComponent:RefreshIcon()
  local iconPath = self:GetIconPath()
  self.imgIcon:LoadSprite(iconPath)
end

function CommonGroupCostItemComponent:GetIconPath()
  if self.type == CommonCostNeedType.Resource then
    return DataCenter.ResourceManager:GetResourceIconByType(self.itemId)
  elseif self.type == CommonCostNeedType.ResourceItem then
    return DataCenter.ResourceItemDataManager:GetIconPath(self.itemId)
  elseif self.type == CommonCostNeedType.Goods then
    return DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.itemId)
  end
  return ""
end

function CommonGroupCostItemComponent:GetHaveResCount()
  local have = 0
  if self.type == CommonCostNeedType.ResourceItem then
    have = DataCenter.ResourceItemDataManager:GetCountByItemId(self.itemId)
  elseif self.type == CommonCostNeedType.Goods then
    have = DataCenter.ItemData:GetItemCount(self.itemId)
  elseif self.type == CommonCostNeedType.Resource then
    have = LuaEntry.Resource:GetCntByResType(self.itemId)
  end
  return have
end

return CommonGroupCostItemComponent
