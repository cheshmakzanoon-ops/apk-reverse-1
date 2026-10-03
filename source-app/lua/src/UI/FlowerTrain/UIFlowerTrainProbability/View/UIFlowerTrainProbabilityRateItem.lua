local base = UIBaseContainer
local UIFlowerTrainProbabilityRateItem = BaseClass("UIFlowerTrainProbabilityRateItem", UIBaseContainer)
local UIFlowerTrainProbabilityRateRewardItem = require("UI.FlowerTrain.UIFlowerTrainProbability.View.UIFlowerTrainProbabilityRateRewardItem")
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local Localization = CS.GameEntry.Localization
local Padding = 8
local item_title1_path = "TitleBg/itemTitle1"
local item_desc_path = "Content/bg/itemDesc"
local reward_rate_item_path = "rewardRateItem"
local reward_common_item_path = "UICommonResItem"
local content1_path = "Content"

function UIFlowerTrainProbabilityRateItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFlowerTrainProbabilityRateItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainProbabilityRateItem:ComponentDefine()
  self.item_title1 = self:AddComponent(UITextMeshProUGUIEx, item_title1_path)
  self.reward_rate_item = self:AddComponent(UIBaseContainer, reward_rate_item_path)
  self.reward_common_item = self:AddComponent(UIBaseContainer, reward_common_item_path)
  self.rewardContent = self:AddComponent(UIGridLayoutGroup, content1_path)
  self.item_desc = self:AddComponent(UITextMeshProUGUIEx, item_desc_path)
  self.reward_rate_item:SetActive(false)
  self.reward_rate_item.gameObject:GameObjectCreatePool()
  self.reward_common_item:SetActive(false)
  self.reward_common_item.gameObject:GameObjectCreatePool()
end

function UIFlowerTrainProbabilityRateItem:ComponentDestroy()
  self:ClearRewards()
  self.item_title1 = nil
  self.reward_rate_item = nil
  self.reward_common_item = nil
  self.rewardContent = nil
  self.item_desc = nil
end

function UIFlowerTrainProbabilityRateItem:DataDefine()
  self.rewardList = {}
  self.scrollItemCfg = {}
end

function UIFlowerTrainProbabilityRateItem:DataDestroy()
  self.rewardList = {}
  self.scrollItemCfg = {}
end

function UIFlowerTrainProbabilityRateItem:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainProbabilityRateItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainProbabilityRateItem:SetData(data)
  self:RefreshView(data)
end

function UIFlowerTrainProbabilityRateItem:RefreshView(data)
  self.data = data
  self.scrollItemCfg = {data}
  self.item_title1:SetLocalText(data.sub_type_name)
  if string.IsNullOrEmpty(data.content_text) then
    self.item_desc:SetActive(false)
    self.rewardContent.unity_layout.padding.top = 70
  else
    self.item_desc:SetActive(true)
    self.item_desc:SetLocalText(data.content_text)
    local preferredValues = self.item_desc.unity_tmpro:GetPreferredValues(632, 0)
    local top = math.ceil(50 + preferredValues.y + Padding)
    self.rewardContent.unity_layout.padding.top = top
  end
  self:RefreshRewardContent()
  self:RefreshSize()
end

function UIFlowerTrainProbabilityRateItem:RefreshRewardContent()
  self:ClearRewards()
  self.rewardList = {}
  self:PrepareRewardData(1, self.rewardList)
  for i = 1, #self.rewardList do
    local showData = self.rewardList[i]
    local item, component
    local scale = 1
    if self.data.drop_show == "0" then
      item = self.reward_common_item.gameObject:GameObjectSpawn(self.rewardContent.transform)
      component = UICommonResItem
      scale = 0.83
    else
      item = self.reward_rate_item.gameObject:GameObjectSpawn(self.rewardContent.transform)
      component = UIFlowerTrainProbabilityRateRewardItem
    end
    item.name = "reward_rate_item" .. i
    local obj = self.rewardContent:AddComponent(component, item.name)
    obj:SetActive(true)
    obj:ReInit(showData)
    obj:SetLocalScaleXYZ(scale, scale, 1)
  end
end

function UIFlowerTrainProbabilityRateItem:ClearRewards()
  self.rewardContent:RemoveComponents(UIFlowerTrainProbabilityRateRewardItem)
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.reward_rate_item.gameObject:GameObjectRecycleAll()
  self.reward_common_item.gameObject:GameObjectRecycleAll()
end

function UIFlowerTrainProbabilityRateItem:PrepareRewardData(index, showRewardData)
  if self.scrollItemCfg[index] ~= nil then
    if self.scrollItemCfg[index].sub_item then
      local rewardCfgList = string.string2array_i(self.scrollItemCfg[index].sub_item, ";", "|")
      for i = 1, #rewardCfgList do
        local tmpShowData = {}
        if rewardCfgList[i][1] == 1 then
          tmpShowData = {
            rewardType = ResTypeToReward[rewardCfgList[i][2]],
            count = rewardCfgList[i][3]
          }
        else
          tmpShowData = {
            rewardType = rewardCfgList[i][1],
            itemId = rewardCfgList[i][2],
            count = rewardCfgList[i][3]
          }
        end
        table.insert(showRewardData, tmpShowData)
      end
    end
    if self.scrollItemCfg[index].drop_show then
      local rewardRateList = string.split(self.scrollItemCfg[index].drop_show, "|")
      for i = 1, #rewardRateList do
        showRewardData[i].rateNum = tonumber(rewardRateList[i]) / 100
      end
    end
    if self.scrollItemCfg[index].special then
      local rewardSpecialList = string.split(self.scrollItemCfg[index].special, "|")
      for i = 1, #rewardSpecialList do
        showRewardData[i].isTip = tonumber(rewardSpecialList[i]) or 0
      end
    end
  end
end

function UIFlowerTrainProbabilityRateItem:RefreshSize()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rewardContent.transform)
  local newHeight = self.rewardContent.rectTransform.rect.height
  self.transform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, newHeight)
end

return UIFlowerTrainProbabilityRateItem
