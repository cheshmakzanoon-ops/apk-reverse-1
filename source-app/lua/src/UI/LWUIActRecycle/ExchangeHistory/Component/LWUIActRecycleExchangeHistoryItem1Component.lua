local base = UIBaseContainer
local LWUIActRecycleExchangeHistoryItem1Component = BaseClass("LWUIActRecycleExchangeHistoryItem1Component", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActRecycleExchangeHistoryItem1Component:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleExchangeHistoryItem1Component:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleExchangeHistoryItem1Component:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compUICommonResItem01 = self.viewSkin:AddComponent(self, UICommonResItem, 2)
  self.compUICommonResItem02 = self.viewSkin:AddComponent(self, UICommonResItem, 3)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 4)
end

function LWUIActRecycleExchangeHistoryItem1Component:ComponentDestroy()
  self.viewSkin = nil
  self.textTime = nil
  self.compUICommonResItem01 = nil
  self.compUICommonResItem02 = nil
  self.imgArrow = nil
end

function LWUIActRecycleExchangeHistoryItem1Component:DataDefine()
end

function LWUIActRecycleExchangeHistoryItem1Component:DataDestroy()
end

function LWUIActRecycleExchangeHistoryItem1Component:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleExchangeHistoryItem1Component:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleExchangeHistoryItem1Component:ReInit(data, activityId)
  if data == nil then
    return
  end
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMDHM(data.time or 0))
  if data.content then
    local shopTemplate = DataCenter.ActRecycleManager:GetActivityCycleShopTemplateById(data.content.id or 0)
    if shopTemplate then
      local num = data.content.num or 0
      local cost = shopTemplate:GetCost()
      local reward = shopTemplate:GetReward()
      if cost and reward then
        self.compUICommonResItem01:ReInit(cost)
        self.compUICommonResItem01:SetItemCount(num * cost.count)
        self.compUICommonResItem02:ReInit(reward)
        self.compUICommonResItem02:SetItemCount(num * reward.count)
      end
    end
  end
  local arrowImagePath = UIAssets.ActRecycleExchangeArrowDefaultImage
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo ~= nil then
    local mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(activityInfo.subType)
    if mainTemplate ~= nil and not string.IsNullOrEmpty(mainTemplate.res_aro) then
      arrowImagePath = mainTemplate.res_aro
    end
  end
  self.imgArrow:LoadSpriteAsync(arrowImagePath)
end

return LWUIActRecycleExchangeHistoryItem1Component
