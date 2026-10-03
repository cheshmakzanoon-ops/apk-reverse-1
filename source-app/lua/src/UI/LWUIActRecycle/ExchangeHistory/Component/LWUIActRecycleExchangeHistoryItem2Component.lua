local base = UIBaseContainer
local LWUIActRecycleExchangeHistoryItem2Component = BaseClass("LWUIActRecycleExchangeHistoryItem2Component", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActRecycleExchangeHistoryItem2Component:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleExchangeHistoryItem2Component:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleExchangeHistoryItem2Component:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compUICommonResItem01 = self.viewSkin:AddComponent(self, UICommonResItem, 2)
end

function LWUIActRecycleExchangeHistoryItem2Component:ComponentDestroy()
  self.viewSkin = nil
  self.textTime = nil
  self.compUICommonResItem01 = nil
end

function LWUIActRecycleExchangeHistoryItem2Component:DataDefine()
end

function LWUIActRecycleExchangeHistoryItem2Component:DataDestroy()
end

function LWUIActRecycleExchangeHistoryItem2Component:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleExchangeHistoryItem2Component:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleExchangeHistoryItem2Component:ReInit(data)
  if data == nil then
    return
  end
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMDHM(data.time or 0))
  if data.content then
    local shopTemplate = DataCenter.ActRecycleManager:GetActivityCycleShopTemplateById(data.content.id or 0)
    if shopTemplate then
      local num = data.content.num or 0
      local reward = shopTemplate:GetReward()
      if reward then
        self.compUICommonResItem01:ReInit(reward)
        self.compUICommonResItem01:SetItemCount(num * reward.count)
      end
    end
  end
end

return LWUIActRecycleExchangeHistoryItem2Component
