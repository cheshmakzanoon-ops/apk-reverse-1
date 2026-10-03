local GiftBoxRewardCellNew = BaseClass("GiftBoxRewardCellNew", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rate_node_high_path = "rateNodeHigh"
local rate_node_high_text_path = "rateNodeHigh/rateNodeHighText"
local rate_node_middle_path = "rateNodeMiddle"
local rate_node_middle_text_path = "rateNodeMiddle/rateNodeMiddleText"
local rate_node_free_path = "rateNodeFree"
local rete_node_free_text_path = "rateNodeFree/rateNodeFreeText"

function GiftBoxRewardCellNew:OnCreate()
  base.OnCreate(self)
  self._giftIcon_img = self:AddComponent(UIImage, "BoxImg")
  self._name_txt = self:AddComponent(UIText, "NameText")
  self._name_txt:SetLocalText("airdrop_supply_desc7")
  self._prop_txt = self:AddComponent(UIText, "PropText")
  self.rate_node_high = self:AddComponent(UIBaseContainer, rate_node_high_path)
  self.rate_node_middle = self:AddComponent(UIBaseContainer, rate_node_middle_path)
  self.rate_node_free = self:AddComponent(UIBaseContainer, rate_node_free_path)
  self.rate_high_text = self:AddComponent(UITextMeshProUGUIEx, rate_node_high_text_path)
  self.rate_middle_text = self:AddComponent(UITextMeshProUGUIEx, rate_node_middle_text_path)
  self.rate_free_text = self:AddComponent(UITextMeshProUGUIEx, rete_node_free_text_path)
end

function GiftBoxRewardCellNew:OnDestroy()
  base.OnDestroy(self)
end

function GiftBoxRewardCellNew:ReInit(boxData, activityId)
  local goodsConfig = boxData.goodsConfigTotalList[1]
  local textCpt = self:GetRateTextCpt(goodsConfig.display_multiplier_type)
  textCpt:SetText(Localization:GetString("airdrop_supply_desc15", goodsConfig.display_multiplier))
  self._prop_txt:SetText(string.format("%.1f", boxData.weightPercent * 100) .. "%")
  self:SetRateNodeVisible(goodsConfig.display_multiplier_type)
  self._giftIcon_img:LoadSprite(string.format(LoadPath.UImystery, goodsConfig.reward_icon))
  self.rate_free_text:SetLocalText(130126)
end

function GiftBoxRewardCellNew:GetRateTextCpt(displayType)
  if displayType == 3 then
    return self.rate_high_text
  end
  return self.rate_middle_text
end

function GiftBoxRewardCellNew:SetRateNodeVisible(displayType)
  self.rate_node_high:SetActive(displayType == 3)
  self.rate_node_free:SetActive(displayType == 4)
  self.rate_node_middle:SetActive(displayType ~= 3 and displayType ~= 4)
end

return GiftBoxRewardCellNew
