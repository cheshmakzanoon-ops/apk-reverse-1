local base = UIBaseContainer
local rewardItemComponent = BaseClass("rewardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function rewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function rewardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function rewardItemComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitleText")
  self.rewardContent = self:AddComponent(UIBaseContainer, "RewardContent/RewardScrollView/LevelRewardContent")
end

function rewardItemComponent:ComponentDestroy()
  self.textTitle = nil
  self.rewardContent = nil
end

function rewardItemComponent:DataDefine()
  self.asyncModels = {}
end

function rewardItemComponent:DataDestroy()
  self:ClearRewardItems()
  self.asyncModels = nil
end

function rewardItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function rewardItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function rewardItemComponent:ReInit(data, index)
  if index == 1 then
    self.textTitle:SetLocalText("city_war_reward_show_04")
  else
    self.textTitle:SetLocalText("city_war_reward_show_05")
  end
  self.cityRewardList = data
  self:ShowRewardList()
end

function rewardItemComponent:ClearRewardItems()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.asyncModels then
    for _, v in pairs(self.asyncModels) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.asyncModels = {}
end

function rewardItemComponent:ShowRewardList()
  self:ClearRewardItems()
  for i = 1, #self.cityRewardList do
    self.asyncModels[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.rewardContent.transform)
      go.transform:Set_localScale(0.76, 0.76, 1)
      go.name = "item" .. i
      local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
      local rewardData = self.cityRewardList[i]
      if rewardData then
        cell:ReInit(rewardData)
      end
    end)
  end
end

return rewardItemComponent
