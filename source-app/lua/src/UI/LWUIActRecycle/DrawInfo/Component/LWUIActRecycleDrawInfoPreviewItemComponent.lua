local base = UIBaseContainer
local LWUIActRecycleDrawInfoPreviewItemComponent = BaseClass("LWUIActRecycleDrawInfoPreviewItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActRecycleDrawInfoPreviewItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleDrawInfoPreviewItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleDrawInfoPreviewItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textSubTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.scrollViewUICommonScrollViewHorizontal = self.viewSkin:AddComponent(self, UIScrollView, 4)
  self.scrollViewUICommonScrollViewHorizontal:SetFixedItemSize(127.5, 127.5)
  self.scrollViewUICommonScrollViewHorizontal:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewHorizontal:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function LWUIActRecycleDrawInfoPreviewItemComponent:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.textTitle = nil
  self.textSubTitle = nil
  self.imgIcon = nil
  self.scrollViewUICommonScrollViewHorizontal = nil
end

function LWUIActRecycleDrawInfoPreviewItemComponent:DataDefine()
end

function LWUIActRecycleDrawInfoPreviewItemComponent:DataDestroy()
end

function LWUIActRecycleDrawInfoPreviewItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleDrawInfoPreviewItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleDrawInfoPreviewItemComponent:ReInit(quality, probability, rewardId, activityId)
  self.textTitle:SetText(self:GetQualityName(quality))
  self.textSubTitle:SetText(Localization:GetString("activity_99165_reward2_2", string.formatDecimal(probability / 100, 2) .. "%"))
  self.rewards = DataCenter.RewardTemplateManager:GetList(rewardId)
  if not table.IsNullOrEmpty(self.rewards) then
    self.scrollViewUICommonScrollViewHorizontal:SetActive(true)
    self.scrollViewUICommonScrollViewHorizontal:SetTotalCount(#self.rewards)
    self.scrollViewUICommonScrollViewHorizontal:RefillCells()
  else
    self.scrollViewUICommonScrollViewHorizontal:SetActive(false)
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo ~= nil then
    local mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(activityInfo.subType)
    if mainTemplate ~= nil then
      local iconPath = mainTemplate:GetBoxIconPath(quality)
      if iconPath ~= nil then
        self.imgIcon:LoadSpriteAsync(iconPath)
      end
    end
  end
end

function LWUIActRecycleDrawInfoPreviewItemComponent:GetQualityName(quality)
  if quality == 1 then
    return Localization:GetString("activity_99165_reward2_1")
  elseif quality == 2 then
    return Localization:GetString("activity_99165_reward2_3")
  elseif quality == 3 then
    return Localization:GetString("activity_99165_reward2_4")
  elseif quality == 4 then
    return Localization:GetString("activity_99165_reward2_5")
  end
  return ""
end

function LWUIActRecycleDrawInfoPreviewItemComponent:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewHorizontal:AddComponent(UICommonResItem, itemObj)
  cellItem:SetActive(true)
  if self.rewards and self.rewards[index] then
    cellItem.transform:Set_localScale(0.8, 0.8, 0.8)
    cellItem:ReInit(self.rewards[index])
  end
end

function LWUIActRecycleDrawInfoPreviewItemComponent:OnItemMoveOut(itemObj, index)
  self.scrollViewUICommonScrollViewHorizontal:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWUIActRecycleDrawInfoPreviewItemComponent:ClearScroll()
  self.scrollViewUICommonScrollViewHorizontal:ClearCells()
  self.scrollViewUICommonScrollViewHorizontal:RemoveComponents(UICommonResItem)
end

return LWUIActRecycleDrawInfoPreviewItemComponent
