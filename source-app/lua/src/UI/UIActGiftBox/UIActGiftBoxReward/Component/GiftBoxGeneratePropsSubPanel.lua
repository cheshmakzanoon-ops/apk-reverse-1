local GiftBoxGeneratePropsSubPanel = BaseClass("GiftBoxGeneratePropsSubPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local GiftBoxRewardCell = require("UI.UIActGiftBox.UIActGiftBoxReward.Component.GiftBoxRewardCellNew")
local UICommonResItemMouth = require("UI.UICommonResItem.UICommonResItemMouth")
local generate_item_list_content = "Viewport/Content/ScrollView1/Viewport/Content1"
local box_item_list_content = "Viewport/Content/ScrollView2/Viewport/Content2"
local extra_box_props_desc_path = "Viewport/Content/extraBoxPropsDesc"
local generate_props_desc_path = "Viewport/Content/generatePropsDesc"

function GiftBoxGeneratePropsSubPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function GiftBoxGeneratePropsSubPanel:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GiftBoxGeneratePropsSubPanel:ComponentDefine()
  self.extra_box_props_desc = self:AddComponent(UITextMeshProUGUIEx, extra_box_props_desc_path)
  self.extra_box_props_desc:SetLocalText("airdrop_supply_desc6")
  self.generate_props_desc = self:AddComponent(UITextMeshProUGUIEx, generate_props_desc_path)
  self.generate_props_desc:SetLocalText("airdrop_supply_desc5")
  self.generateItemListContent = self:AddComponent(UIBaseContainer, generate_item_list_content)
  self.boxItemListContent = self:AddComponent(UIBaseContainer, box_item_list_content)
end

function GiftBoxGeneratePropsSubPanel:ComponentDestroy()
  self:SetAllCellDestroy()
end

function GiftBoxGeneratePropsSubPanel:OnAddListener()
  base.OnAddListener(self)
end

function GiftBoxGeneratePropsSubPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GiftBoxGeneratePropsSubPanel:ReInit(actId)
  self.actId = actId
  if self.holder.boxopen_id then
    self:Refresh(self.holder.boxopen_id)
  end
end

function GiftBoxGeneratePropsSubPanel:Refresh(boxOpenId)
  if self.boxOpenId ~= boxOpenId then
    local generateItemRewardList, boxList = DataCenter.ActGiftBoxData:GetBoxOpenDataByOpenId(boxOpenId)
    self:SetAllCellDestroy()
    self:RefreshItemReward(generateItemRewardList)
    self:RefreshBoxReward(boxList)
  end
  self.boxOpenId = boxOpenId
end

function GiftBoxGeneratePropsSubPanel:RefreshItemReward(itemConfigList)
  self.propsItemList = {}
  if itemConfigList then
    for i = 1, table.count(itemConfigList) do
      self.propsItemList[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItemMouth, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.generateItemListContent.transform)
        go.transform:Set_localScale(0.9, 0.9, 0.9)
        go.name = "item_reward_" .. i
        local cell = self.generateItemListContent:AddComponent(UICommonResItemMouth, go.name)
        local goodsItem = itemConfigList[i].goodsItem
        local param = {}
        param.mouthText = string.format("%.2f%%", goodsItem.weightPercent * 100)
        param.rewardParam = goodsItem
        cell:ReInit(param)
      end)
    end
  end
end

function GiftBoxGeneratePropsSubPanel:RefreshBoxReward(boxList)
  if boxList then
    self.boxItemList = {}
    local count = 1
    for k, v in ipairs(boxList) do
      self.boxItemList[count] = self:CreateBoxItem(count, v)
      count = count + 1
    end
  end
end

function GiftBoxGeneratePropsSubPanel:CreateBoxItem(index, param)
  local item = self:GameObjectInstantiateAsync(UIAssets.GiftBoxRewardCellNew, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.boxItemListContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "item_gift_" .. index
    local cell = self.boxItemListContent:AddComponent(GiftBoxRewardCell, go.name)
    cell:ReInit(param, self.actId)
  end)
  return item
end

function GiftBoxGeneratePropsSubPanel:SetAllCellDestroy()
  self.generateItemListContent:RemoveComponents(UICommonResItemMouth)
  if self.propsItemList ~= nil then
    for _, v in ipairs(self.propsItemList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.boxItemListContent:RemoveComponents(GiftBoxRewardCell)
  if self.boxItemList ~= nil then
    for _, v in ipairs(self.boxItemList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return GiftBoxGeneratePropsSubPanel
