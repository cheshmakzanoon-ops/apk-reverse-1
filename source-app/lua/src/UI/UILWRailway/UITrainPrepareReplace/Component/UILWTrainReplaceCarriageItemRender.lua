local UILWTrainReplaceCarriageItemRender = BaseClass("UILWTrainReplaceCarriageItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RectTransformCSType = typeof(CS.UnityEngine.RectTransform)
local ResourceManager = CS.GameEntry.Resource
local goods_item_group_scale_path = "GoodsItemGroupScale"

function UILWTrainReplaceCarriageItemRender:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UILWTrainReplaceCarriageItemRender:OnDestroy()
  self:ClearReward()
  self:ClearRewardEffect()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainReplaceCarriageItemRender:DataDefine()
  self.rewardReqs = {}
  self.rewardItems = {}
  self.isURTrain = false
end

function UILWTrainReplaceCarriageItemRender:DataDestroy()
  self.rewardDataList = nil
  self.isURTrain = nil
end

function UILWTrainReplaceCarriageItemRender:ComponentDefine()
  self.goods_item_group_scale = self:AddComponent(UIBaseContainer, goods_item_group_scale_path)
end

function UILWTrainReplaceCarriageItemRender:ComponentDestroy()
  self.goods_item_group_scale = nil
end

function UILWTrainReplaceCarriageItemRender:ShowReward(rewardDataList, isURTrain)
  self.rewardDataList = rewardDataList
  self.isURTrain = isURTrain
  for i, v in ipairs(self.rewardDataList) do
    self:AddOrRefreshOneReward(i, v, self.rewardDataList[i])
  end
  self:ShowRewardEffect()
end

function UILWTrainReplaceCarriageItemRender:AddOrRefreshOneReward(i, data)
  local rewardItem = self.rewardItems[i]
  if rewardItem then
    local param = UICommonResItem.Param.New()
    param.rewardType = data.type
    if type(data.value) == "table" then
      param.itemId = data.value.id
      param.count = data.value.num
    else
      param.itemId = data.type
      param.count = data.value
    end
    param.rewardType = data.type
    param.heroUuid = data.heroUuid
    param.isHeroBox = data.isHeroBox
    param.isDelete = false
    rewardItem:ReInit(param)
    self:RefreshRewardEffectViewState(rewardItem, i)
    return
  end
  if self.rewardReqs[i] == nil then
    self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local index = i
      local nameStr = "UICommonResItem" .. index
      go.name = nameStr
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.goods_item_group_scale.transform)
      transform:Set_localScale(0.9, 0.9, 1)
      transform:Set_pivot(0, 1)
      local item = self.goods_item_group_scale:AddComponent(UICommonResItem, nameStr)
      self.rewardItems[i] = item
      local rewardData = self.rewardDataList[i]
      local param = UICommonResItem.Param.New()
      if type(rewardData.value) == "table" then
        param.itemId = rewardData.value.id
        param.count = rewardData.value.num
      else
        param.itemId = rewardData.type
        param.count = rewardData.value
      end
      param.rewardType = rewardData.type
      param.heroUuid = rewardData.heroUuid
      param.isHeroBox = rewardData.isHeroBox
      param.isDelete = false
      item:ReInit(param)
      self:RefreshRewardEffectViewState(item, i)
    end)
  end
end

function UILWTrainReplaceCarriageItemRender:ClearReward()
  self.goods_item_group_scale:RemoveComponents(UICommonResItem)
  self.rewardItems = nil
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = nil
end

function UILWTrainReplaceCarriageItemRender:ShowRewardEffect()
  if self.isURTrain then
    self.showEffectRewardIndexes = DataCenter.LWAllyStationDataManager:GetURTrainRewardHighlight()
    local count = self.showEffectRewardIndexes ~= nil and #self.showEffectRewardIndexes or 0
    if count <= 0 then
      self:ClearRewardEffect()
      return
    end
    if self.rewardEffectReqs ~= nil then
      return
    end
    self.rewardEffectReqs = {}
    for i = 1, count do
      local req = ResourceManager:InstantiateAsync(EffectAssets.ItemCanGetEffect)
      table.insert(self.rewardEffectReqs, req)
      req:completed("+", function(request)
        if self.rewardEffectReqs == nil then
          request:Destroy()
          return
        end
        if self.showEffectRewardIndexes == nil then
          request:Destroy()
          return
        end
        local index = self.showEffectRewardIndexes[i]
        if index == nil then
          request:Destroy()
          return
        end
        local go = request.gameObject
        local transform = go.transform
        local item = self.rewardItems[index]
        if item == nil then
          go:SetActive(false)
          return
        end
        go:SetActive(true)
        local rectTransform = go:GetComponent(RectTransformCSType)
        transform:SetParent(item.transform)
        rectTransform:Set_anchoredPosition(ResetPosition.x, ResetPosition.y)
        transform:Set_localScale(1.43, 1.43, 1)
      end)
    end
  else
    self:ClearRewardEffect()
  end
end

function UILWTrainReplaceCarriageItemRender:RefreshRewardEffectViewState(rewardItem, rewardItemIndex)
  local effectIndex = DataCenter.LWAllyStationDataManager:GetURTrainRewardHighlightIndex(rewardItemIndex)
  if 0 < effectIndex and self.rewardEffectReqs ~= nil then
    local effectReq = self.rewardEffectReqs[effectIndex]
    if effectReq ~= nil and not IsNull(effectReq.gameObject) then
      local effectGo = effectReq.gameObject
      local effectTransform = effectGo.transform
      effectGo:SetActive(true)
      local rectTransform = effectGo:GetComponent(RectTransformCSType)
      effectTransform:SetParent(rewardItem.transform)
      rectTransform:Set_anchoredPosition(ResetPosition.x, ResetPosition.y)
      effectTransform:Set_localScale(1.43, 1.43, 1)
    end
  end
end

function UILWTrainReplaceCarriageItemRender:ClearRewardEffect()
  if self.rewardEffectReqs then
    for _, req in pairs(self.rewardEffectReqs) do
      req:Destroy()
    end
  end
  self.rewardEffectReqs = nil
  self.showEffectRewardIndexes = nil
end

return UILWTrainReplaceCarriageItemRender
