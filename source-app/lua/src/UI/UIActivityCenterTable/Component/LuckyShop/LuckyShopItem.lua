local LuckyShopItem = BaseClass("LuckyShopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "obj/Content/Button"
local flag_path = "obj/Content/UICommonResItem/clickBtn/FlagGo"
local flag_text_path = "obj/Content/UICommonResItem/clickBtn/FlagGo/FlagText"
local sold_out_text_path = "obj/Sold_Out_BG/Sold_Out_Text"
local sold_out_path = "obj/Sold_Out_BG"
local buy_btn_path = "obj/Content/Buy_Btn"
local buy_btn_text_path = "obj/Content/Buy_Btn/Buy_Btn_Text"
local cover_path = "obj/CloseBg"
local item_path = "obj"
local cost_img_path = "obj/Content/Buy_Btn/Buy_Btn_Text/icon"
local original_price_path = "obj/Content/Original_Price"
local item_icon_path = "obj/Content/UICommonResItem"
local content_path = "obj/Content"
local bg_path = "obj/OpenBg"
local quality_img_path = "obj/Content/QualityImg"

local function OnCreate(self)
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.commonResItem = self:AddComponent(UICommonResItem, item_icon_path)
  self.contentGo = self:AddComponent(UIBaseContainer, content_path)
  self.itemIntroBtn = self:AddComponent(UIButton, icon_path)
  self.itemIntroBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnItemIntroClick()
  end)
  self.flag = self:AddComponent(UIBaseContainer, flag_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.sold_out = self:AddComponent(UIBaseContainer, sold_out_path)
  self.sold_out_text = self:AddComponent(UIText, sold_out_text_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn_text = self:AddComponent(UIText, buy_btn_text_path)
  self.cover = self:AddComponent(UIButton, cover_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.quality_img = self:AddComponent(UIImage, quality_img_path)
  self.item = self:AddComponent(UIBaseContainer, item_path)
  self.costImg = self:AddComponent(UIImage, cost_img_path)
  self.sold_out_text:SetLocalText(320268)
  self.original_price = self:AddComponent(UIText, original_price_path)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyClick()
  end)
  self.cover:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCoverClick()
  end)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnBuyClick(self)
  if self.data == nil then
    return
  end
  local hasNum = 0
  if self.data.costType == LuckyShopItemType.LuckyShopItemType_Resource then
    hasNum = CommonUtil.GetResOrItemCount(self.data.costId)
    if self.data.costId == ResourceType.Gold then
      if hasNum < self.data.costNum then
        GoToUtil.GotoPayTips(self.data.costNum)
      else
        local itemName = DataCenter.RewardManager:GetNameByType(self.data.rewardType, self.data.rewardId)
        itemName = itemName .. "X" .. self.data.rewardNum
        local str = Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(self.data.costNum), Localization:GetString(GameDialogDefine.DIAMOND), itemName)
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, str, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          DataCenter.LuckyShopManager:BuyItem(toInt(self.data.activityId), self.data.shopId)
        end, function()
        end)
      end
      return
    end
  elseif self.data.costType == LuckyShopItemType.LuckyShopItemType_Item then
    hasNum = DataCenter.ItemData:GetItemCount(self.data.costId)
  end
  if hasNum < self.data.costNum then
    return
  end
  DataCenter.LuckyShopManager:BuyItem(toInt(self.data.activityId), self.data.id)
end

local function OnCoverClick(self)
  UIUtil.ShowTipsId(320597)
end

local function SetData(self, data)
  self.data = data
  self:Refresh()
end

local function SetQualityImg(self)
  local quality = DataCenter.RewardManager:GetRewardQuality(self.data.rewardType, self.data.rewardId)
  if quality == 2 then
    self.quality_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityLuckyShop/lrb_zhekoushangdian_kaixiang_lv.png")
  elseif quality == 3 then
    self.quality_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityLuckyShop/lrb_zhekoushangdian_kaixiang_lan.png")
  elseif quality == 4 then
    self.quality_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityLuckyShop/lrb_zhekoushangdian_kaixiang_zi.png")
  elseif quality == 5 then
    self.quality_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityLuckyShop/lrb_zhekoushangdian_kaixiang_cheng.png")
  elseif quality == 6 then
    self.quality_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityLuckyShop/lrb_zhekoushangdian_kaixiang_hong.png")
  end
end

local function Refresh(self)
  if self.data.isNull == true then
    self.cover:SetActive(true)
    self.bg:SetActive(false)
    self.contentGo:SetActive(false)
    self.sold_out:SetActive(false)
    self.quality_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityLuckyShop/lrb_zhekoushangdian_kaixiang_bai.png")
  else
    self.cover:SetActive(false)
    self.bg:SetActive(true)
    self.contentGo:SetActive(true)
    local rewardData = {
      count = self.data.rewardNum,
      itemId = self.data.rewardId,
      rewardType = self.data.rewardType
    }
    self.commonResItem:ReInit(rewardData)
    SetQualityImg(self)
    self.original_price:SetText(self.data.originalPrice)
    local iconPath = ""
    if self.data.costType == LuckyShopItemType.LuckyShopItemType_Resource then
      local temp = DataCenter.ResourceTemplateManager:GetResourceTemplate(self.data.costId)
      if temp ~= nil then
        iconPath = string.format(LoadPath.LWCommonPath, temp.icon)
      end
    elseif self.data.costType == LuckyShopItemType.LuckyShopItemType_Item then
      iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.data.costId)
    end
    self.costImg:LoadSprite(iconPath)
    self.buy_btn_text:SetText(self.data.costNum)
    self.sold_out:SetActive(self.data.isBuy)
    self.buy_btn:SetActive(not self.data.isBuy)
    self.original_price:SetActive(not self.data.isBuy)
    self.quality_img:SetActive(not self.data.isBuy)
    self.contentGo:SetActive(not self.data.isBuy)
  end
end

local function SetFlagActive(self, value)
  if self.flagActive ~= value then
    self.flagActive = value
    self.flag:SetActive(value)
  end
end

local function SetFlagText(self, value)
  if self.flagText ~= value then
    self.flagText = value
    self.flag_text:SetText(value)
  end
end

local function OnItemIntroClick(self)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.goodsId)
  if goods then
    local param = {}
    param.itemId = self.data.goodsId
    param.alignObject = self.icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

LuckyShopItem.SetFlagActive = SetFlagActive
LuckyShopItem.SetFlagText = SetFlagText
LuckyShopItem.OnCreate = OnCreate
LuckyShopItem.OnDestroy = OnDestroy
LuckyShopItem.Refresh = Refresh
LuckyShopItem.OnBuyClick = OnBuyClick
LuckyShopItem.SetData = SetData
LuckyShopItem.OnCoverClick = OnCoverClick
LuckyShopItem.OnItemIntroClick = OnItemIntroClick
return LuckyShopItem
