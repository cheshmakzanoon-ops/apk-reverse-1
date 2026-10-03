local base = UIBaseContainer
local OldVIPLevelPackageItem = BaseClass("OldVIPLevelPackageItem", base)
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UIGray = CS.UIGray
local img_path = "img"
local packName_txt_path = "LevelPackName/LevelPackTxtName"
local reward_content_path = "LevelPackCellScroll/Viewport/LevelPackContent"
local discount_txt_path = "TopInfo/discountBg/Bg/DiscountText"
local desc_txt_path = "TopInfo/TxtDesc"
local price_txt_path = "Bottom/BuyButton/BuyTxtPrice2"
local giftPackPoint_obj_path = "Bottom/BuyButton/UIGiftPackagePoint"
local buy_btn_path = "Bottom/BuyButton"
local discount_path = "TopInfo/discountBg"

local function ClearRewardScroll(self)
  if self.rewardItems then
    for i = 1, #self.rewardItems do
      self:GameObjectDestroy(self.rewardItems[i])
    end
  end
  if self.reward_content then
    self.reward_content:RemoveComponents(UICommonResItem)
  end
  self.rewardsPackId = nil
  self.rewardItems = {}
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  ClearRewardScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.img = self:AddComponent(UIRawImage, img_path)
  self.packName_txt = self:AddComponent(UITextMeshProUGUIEx, packName_txt_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.discount_txt = self:AddComponent(UIText, discount_txt_path)
  self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, desc_txt_path)
  self.price_txt = self:AddComponent(UIText, price_txt_path)
  self.giftPackPoint_obj = self:AddComponent(UIBaseContainer, giftPackPoint_obj_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.discount = self:AddComponent(UIBaseContainer, discount_path)
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, giftPackPoint_obj_path)
  self.buy_btn:SetOnClick(function()
    if self.packageData then
      DataCenter.PayManager:BuyGift(self.packageData)
    end
  end)
end

local function ComponentDestroy(self)
  self.img = nil
  self.packName_txt = nil
  self.reward_content = nil
  self.discount_txt = nil
  self.desc_txt = nil
  self.price_txt = nil
  self.giftPackPoint_obj = nil
  self.buy_btn = nil
  self.discount = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshData(self, data)
  if not data then
    self:SetActive(false)
    return
  end
  self.data = data
  local packId = data.packId
  self.packageData = GiftPackageData.get(tostring(packId))
  if not self.packageData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.packName_txt:SetText(self.packageData:getNameText())
  self.img:LoadSprite(self.packageData:getPopupImageMini())
  self.img:SetNativeSize()
  local percent = self.packageData:getPercent()
  if not string.IsNullOrEmpty(percent) then
    self.discount:SetActive(true)
    self.discount_txt:SetText(string.format("%s", percent))
  else
    self.discount:SetActive(false)
  end
  local selfVipLevel = 0
  local vipData = DataCenter.VIPManager:GetVipData()
  if vipData then
    selfVipLevel = vipData.level
  end
  if selfVipLevel < data.vipLevel then
    UIGray.SetGray(self.buy_btn.transform, true, false)
    self.giftPackPoint:SetActive(false)
    self.price_txt:SetLocalText(2000292)
    self.desc_txt:SetLocalText(2000267, self.packageData:getBuyTimes())
  elseif not self.packageData:isBought() then
    UIGray.SetGray(self.buy_btn.transform, false, true)
    self.price_txt:SetText(self.packageData:getPriceText())
    self.desc_txt:SetLocalText(2000267, self.packageData:getBuyTimes())
    self.giftPackPoint:SetActive(true)
    self.giftPackPoint:RefreshPoint(self.packageData)
  else
    UIGray.SetGray(self.buy_btn.transform, true, false)
    self.giftPackPoint:SetActive(false)
    self.price_txt:SetLocalText("2000294")
    self.desc_txt:SetLocalText(2000267, self.packageData:getBuyTimes())
    self.giftPackPoint:SetActive(false)
  end
  if self.rewardsPackId and self.rewardsPackId == packId then
    return
  else
    ClearRewardScroll(self)
  end
  self.rewards = self.packageData:getItems(true)
  if 0 < #self.rewards then
    self.reward_content:SetActive(true)
    for i = 1, #self.rewards do
      local request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if not IsNull(request.gameObject) then
          local go = request.gameObject
          go.transform:SetParent(self.reward_content.transform)
          go.transform.localScale = Vector3.New(0.7, 0.7, 1)
          local name = "resItem" .. i
          go.name = name
          local resItem = self.reward_content:AddComponent(UICommonResItem, name)
          resItem:SetSizeDeltaXY(85, 85)
          resItem:SetPivotXY(0.5, 0.5)
          resItem:ReInit(self.rewards[i])
        end
      end)
      self.rewardItems[i] = request
    end
    self.rewardsPackId = packId
  else
    self.reward_content:SetActive(false)
  end
end

OldVIPLevelPackageItem.OnCreate = OnCreate
OldVIPLevelPackageItem.OnDestroy = OnDestroy
OldVIPLevelPackageItem.OnEnable = OnEnable
OldVIPLevelPackageItem.OnDisable = OnDisable
OldVIPLevelPackageItem.ComponentDefine = ComponentDefine
OldVIPLevelPackageItem.ComponentDestroy = ComponentDestroy
OldVIPLevelPackageItem.DataDefine = DataDefine
OldVIPLevelPackageItem.DataDestroy = DataDestroy
OldVIPLevelPackageItem.RefreshData = RefreshData
return OldVIPLevelPackageItem
