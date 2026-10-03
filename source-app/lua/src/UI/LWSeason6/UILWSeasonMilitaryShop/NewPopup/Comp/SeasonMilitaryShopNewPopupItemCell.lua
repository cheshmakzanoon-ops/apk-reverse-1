local base = UIBaseContainer
local SeasonMilitaryShopNewPopupItemCell = BaseClass("SeasonMilitaryShopNewPopupItemCell", UIBaseContainer)
local UILWSeasonMilitaryLevelComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryLevelComp")

function SeasonMilitaryShopNewPopupItemCell:ComponentDefine()
  local limitLayout_path = "Bg/Offset/limitLayout"
  local limitTxt_path = "Bg/Offset/limitLayout/limit"
  local limitTimes_path = "Bg/Offset/limitLayout/limitNum"
  local buyBtn_path = "Bg"
  local buy_btn_path = "Bg/Offset/buyBtn"
  local price_path = "Bg/Offset/buyBtn/price"
  local consumeIcon_path = "Bg/Offset/buyBtn/icon"
  local condition_invalid_path = "Bg/Offset/ConditionInvalid"
  local u_i_common_res_item_path = "Bg/Offset/p_trans_item_root/UICommonResItem"
  local p_comp_military_path = "Bg/Offset/ConditionInvalid/p_comp_military"
  self.limitTimesN = self:AddComponent(UITextMeshProUGUIEx, limitTimes_path)
  self.limitTxtN = self:AddComponent(UITextMeshProUGUIEx, limitTxt_path)
  self.limitLayoutN = self:AddComponent(UIBaseContainer, limitLayout_path)
  self.goBtn = self:AddComponent(UIBaseContainer, buy_btn_path)
  self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
  self.priceN = self:AddComponent(UITextMeshProUGUIEx, price_path)
  self.priceShadowN = self:AddComponent(UIShadow, price_path)
  self.consumeIconN = self:AddComponent(UIImage, consumeIcon_path)
  self.goCondition = self:AddComponent(UIBaseComponent, condition_invalid_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.p_comp_military = self:AddComponent(UILWSeasonMilitaryLevelComp, p_comp_military_path)
end

function SeasonMilitaryShopNewPopupItemCell:ComponentDestroy()
  self.limitTimesN = nil
  self.limitTxtN = nil
  self.limitLayoutN = nil
  self.goBtn = nil
  self.buyBtnN = nil
  self.priceN = nil
  self.priceShadowN = nil
  self.consumeIconN = nil
  self.goCondition = nil
  self.u_i_common_res_item = nil
  self.p_comp_military = nil
end

function SeasonMilitaryShopNewPopupItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonMilitaryShopNewPopupItemCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonMilitaryShopNewPopupItemCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonMilitaryShopNewPopupItemCell:InitData(data)
  if data ~= nil then
    self.ShopData = data
    self.ShopCell = data.ShopCell
    return true
  end
  return false
end

function SeasonMilitaryShopNewPopupItemCell:InitUi()
  local param = {
    rewardType = self.ShopData.RewardType,
    itemId = tostring(self.ShopData.ShowId),
    count = checknumber(self.ShopData.RewardNum)
  }
  self.u_i_common_res_item:SetActive(true)
  self.u_i_common_res_item:ReInit(param)
  self.goCondition:SetActive(true)
  self.limitTxtN:SetLocalText(self.ShopCell.buying_condition_desc)
  self.limitTimesN:SetText(string.GetFormattedSeparatorNum(self.ShopCell.buying_limit))
  self.limitLayoutN:SetActive(true)
  if self.ShopData.CostNum > 0 then
    self.goBtn:SetActive(true)
    self.priceN:SetActive(true)
    self.priceN:SetText(string.GetFormattedSeparatorNum(self.ShopData.CostNum))
    local iconPath = DataCenter.ItemTemplateManager:GetIconPath(checknumber(self.ShopData.CostId))
    self.consumeIconN:LoadSprite(iconPath)
  end
  local needMilitary = checknumber(self.ShopCell.buying_condition_type) == 1 and 0 < checknumber(self.ShopCell.buying_condition_value)
  self.p_comp_military:SetActive(needMilitary)
  if needMilitary then
    self.p_comp_military:ReInit(checknumber(self.ShopCell.buying_condition_value))
  end
end

return SeasonMilitaryShopNewPopupItemCell
