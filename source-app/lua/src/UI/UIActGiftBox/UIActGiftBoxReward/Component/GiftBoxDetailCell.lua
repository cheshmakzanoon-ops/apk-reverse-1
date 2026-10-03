local GiftBoxDetailCell = BaseClass("GiftBoxDetailCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonResItemMouth = require("UI.UICommonResItem.UICommonResItemMouth")
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local Localization = CS.GameEntry.Localization
local box_img_path = "BoxImg"
local name_text_path = "NameText"
local prop_text_path = "PropText"
local cost_text_path = "LayoutContent/costText"
local tab_root_path = "LayoutContent/weightTabRoot"
local tab_list_path = "LayoutContent/weightTabRoot/tabList"
local reward_list_path = "LayoutContent/propsScrollView/Viewport/rewardList"
local rate_node_high_path = "rateNodeHigh"
local rate_node_high_text_path = "rateNodeHigh/rateNodeHighText"
local rate_node_middle_path = "rateNodeMiddle"
local rate_node_middle_text_path = "rateNodeMiddle/rateNodeMiddleText"
local rate_node_free_path = "rateNodeFree"
local rate_node_free_text_path = "rateNodeFree/rateNodeFreeText"

function GiftBoxDetailCell:OnCreate()
  base.OnCreate(self)
  self.box_img = self:AddComponent(UIImage, box_img_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.prop_text = self:AddComponent(UITextMeshProUGUIEx, prop_text_path)
  self.cost_text = self:AddComponent(UITextMeshProUGUIEx, cost_text_path)
  self.tab_root_path = self:AddComponent(UIBaseContainer, tab_root_path)
  self.tab_list = self:AddComponent(UIBaseContainer, tab_list_path)
  self.reward_list = self:AddComponent(UIBaseContainer, reward_list_path)
  self.rate_node_high = self:AddComponent(UIBaseContainer, rate_node_high_path)
  self.rate_node_middle = self:AddComponent(UIBaseContainer, rate_node_middle_path)
  self.rate_node_free = self:AddComponent(UIBaseContainer, rate_node_free_path)
  self.rate_high_text = self:AddComponent(UITextMeshProUGUIEx, rate_node_high_text_path)
  self.rate_middle_text = self:AddComponent(UITextMeshProUGUIEx, rate_node_middle_text_path)
  self.rate_free_text = self:AddComponent(UITextMeshProUGUIEx, rate_node_free_text_path)
  self:InitTabCptList()
end

function GiftBoxDetailCell:OnDestroy()
  self:RemoveRewardItemList()
  self.tab_list:RemoveComponents(UICommonTab)
  self.tabItemList = nil
  self.boxData = nil
  self.box_img = nil
  self.name_text = nil
  self.prop_text = nil
  self.cost_text = nil
  self.tab_list = nil
  self.reward_list = nil
  self.isFreeBox = nil
  base.OnDestroy(self)
end

function GiftBoxDetailCell:ReInit(boxData, activityId)
  self.boxData = boxData
  self.isFreeBox = self.boxData ~= nil and self.boxData.quality == 6 or false
  local goodsConfig = boxData.goodsConfigTotalList[1]
  self:RefreshRateText()
  self:CheckIsShowTabArea()
  self.prop_text:SetText(Localization:GetString("airdrop_supply_desc7") .. " " .. string.format("%.2f", boxData.weightPercent * 100) .. "%")
  self:SetRateNodeVisible(goodsConfig.display_multiplier_type)
  self.box_img:LoadSprite(string.format(LoadPath.UImystery, goodsConfig.reward_icon))
  self.name_text:SetLocalText(goodsConfig.reward_name)
  self.rate_free_text:SetLocalText(130126)
  self:InitTabList(boxData.groupWeightPercentMap)
end

function GiftBoxDetailCell:CheckIsShowTabArea()
  self.tab_root_path:SetActive(not self.isFreeBox)
  self.cost_text:SetActive(not self.isFreeBox)
end

function GiftBoxDetailCell:RefreshRateText()
  if self.boxData == nil then
    return
  end
  if self.isFreeBox then
    return
  end
  local goodsConfig = self.boxData.goodsConfigTotalList[1]
  local textCpt = self:GetRateTextCpt(goodsConfig.display_multiplier_type)
  textCpt:SetText(Localization:GetString("airdrop_supply_desc15", goodsConfig.display_multiplier))
end

function GiftBoxDetailCell:GetRateTextCpt(displayType)
  if displayType == nil then
    return
  end
  if displayType == 3 then
    return self.rate_high_text
  end
  return self.rate_middle_text
end

function GiftBoxDetailCell:SetRateNodeVisible(displayType)
  self.rate_node_free:SetActive(displayType == 4)
  self.rate_node_high:SetActive(displayType == 3)
  self.rate_node_middle:SetActive(displayType ~= 3 and displayType ~= 4)
end

function GiftBoxDetailCell:InitTabCptList()
  self.tabItemList = {}
  local childCount = self.tab_list.transform.childCount
  for i = 1, childCount do
    self.tabItemList[i] = self.tab_list:AddComponent(UICommonTab, "tab_" .. i)
    self.tabItemList[i]:SetActive(true)
  end
end

function GiftBoxDetailCell:InitTabList(groupWeightPercentMap)
  for i = 1, table.count(self.tabItemList) do
    local boxesTabParam = {}
    local groupId = 6 - i
    boxesTabParam.tabId = groupId
    boxesTabParam.title = Localization:GetString(self:GetTabText(groupId)) .. "\n" .. string.format("%.2f", groupWeightPercentMap[groupId] * 100) .. "%"
    boxesTabParam.clickHandler = self.OnTabClick
    boxesTabParam.customHolder = self
    self.tabItemList[i]:ReInit(boxesTabParam)
    self.tabItemList[i]:SetSelect(false)
  end
  self:OnTabClick(self.tabItemList[1])
end

function GiftBoxDetailCell:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self:RefreshRewardItemList(self.curTab.tabId)
  local config = self.boxData.goodsConfigListMap[self.curTab.tabId][1]
  if not self.isFreeBox then
    self.cost_text:SetText(Localization:GetString("airdrop_supply_desc14", config.unlock_cost))
  end
end

function GiftBoxDetailCell:RefreshRewardItemList(tabId)
  self:RemoveRewardItemList()
  local goodsConfigList = self.boxData.goodsConfigListMap[tabId]
  self.goodsItemList = {}
  if goodsConfigList then
    for i = 1, table.count(goodsConfigList) do
      self.goodsItemList[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItemMouth, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.reward_list.transform)
        go.transform:Set_localScale(0.9, 0.9, 0.9)
        go.name = "goods_" .. i
        local cell = self.reward_list:AddComponent(UICommonResItemMouth, go.name)
        local param = {}
        param.mouthText = string.format("%.2f", goodsConfigList[i].goodsItem.weightPercent * 100) .. "%"
        param.rewardParam = goodsConfigList[i].goodsItem
        cell:ReInit(param)
      end)
    end
  end
end

function GiftBoxDetailCell:RemoveRewardItemList()
  if self.goodsItemList then
    self.reward_list:RemoveComponents(UICommonResItemMouth)
    for k, v in pairs(self.goodsItemList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.goodsItemList = nil
  end
end

function GiftBoxDetailCell:GetTabText(tabId)
  local textKey = ""
  if tabId == 5 then
    textKey = "airdrop_supply_desc8"
  elseif tabId == 4 then
    textKey = "airdrop_supply_desc9"
  elseif tabId == 3 then
    textKey = "airdrop_supply_desc10"
  elseif tabId == 2 then
    textKey = "airdrop_supply_desc11"
  elseif tabId == 1 then
    textKey = "airdrop_supply_desc12"
  end
  return textKey
end

return GiftBoxDetailCell
