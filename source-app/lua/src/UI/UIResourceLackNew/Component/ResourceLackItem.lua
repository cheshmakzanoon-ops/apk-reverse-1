local ResourceLackItem = BaseClass("ResourceLackItem", UIBaseContainer)
local base = UIBaseContainer
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local ConsumeItem = require("UI.UIResourceLackNew.Component.ConsumeItem")
local Localization = CS.GameEntry.Localization
local recommend_path = "AddBtn/Recommend"
local item_icon_path = "AddBtn/icon"
local name_text_path = "AddBtn/Rect_Desc/Name_Txt"
local desc_text_path = "AddBtn/Rect_Desc/Desc_Txt"
local gift_rect_path = "AddBtn/Rect_Gift"
local giftEffect_rect_path = "AddBtn/Rect_GiftEffect"
local buy_text_path = "AddBtn/Txt_BuyNum"
local add_btn_path = "AddBtn"
local go_btn_path = "Btn_Go"
local go_txt_path = "Btn_Go/Txt_Go"
local price_rect_path = "Btn_Go/Rect_Price"
local buy_txt_path = "Btn_Go/Rect_Price/Txt_Buy"
local price_txt_path = "Btn_Go/Rect_Price/Txt_Price"
local gift_btn_path = "Btn_Gift"
local priceGift_txt_path = "Btn_Gift/Txt_PriceGift"
local point_path = "Btn_Gift/UIGiftPackagePoint"
local consume_rect_path = "AddBtn/Rect_Consume"
local content_path = "AddBtn/Rect_Consume/content"
local item_path = "AddBtn/Item"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.recommend_rect = self:AddComponent(UIBaseContainer, recommend_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self._add_btn = self:AddComponent(UIButton, add_btn_path)
  self._buy_text = self:AddComponent(UIText, buy_text_path)
  self.gift_rect = self:AddComponent(UIBaseContainer, gift_rect_path)
  self.rewardList = {}
  for i = 1, 3 do
    self.rewardList[i] = self.gift_rect:AddComponent(UICommonResItem, "UICommonResItem" .. i)
  end
  self.giftEffect_rect = self:AddComponent(UIBaseContainer, giftEffect_rect_path)
  self.item = self:AddComponent(UICommonResItem, item_path)
  self._add_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.go_txt = self:AddComponent(UIText, go_txt_path)
  self.price_rect = self:AddComponent(UIBaseContainer, price_rect_path)
  self.buy_txt = self:AddComponent(UIText, buy_txt_path)
  self.price_txt = self:AddComponent(UIText, price_txt_path)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.gift_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.priceGift_txt = self:AddComponent(UIText, priceGift_txt_path)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
  self.consume_rect = self:AddComponent(UIBaseContainer, consume_rect_path)
  self.consume_content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self.recommend_rect = nil
  self.item_icon = nil
  self.name_text = nil
  self.desc_text = nil
  self._add_btn = nil
  self.point_rect = nil
  self:ClearList()
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param, distab)
  self.param = param
  self.lacktab = distab
  self:ShowRecommend(false)
  self.model = {}
  self:ClearList()
  self._buy_text:SetActive(false)
  self.item:SetActive(false)
  self.consume_rect:SetActive(false)
  self.giftEffect_rect:SetActive(false)
  self._add_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_bg_item2"))
  if param:GetTips() == ResLackGoToType.UsePaperItem then
    self.desc_text:SetActive(true)
    self.desc_text:SetText(param:GetParam())
  else
    self.desc_text:SetActive(false)
  end
  if param:GetTips() == ResLackGoToType.BuyGiftNew or param:GetTips() == ResLackGoToType.BuyGiftResNew then
    self.item_icon:SetActive(false)
    self.name_text:SetText(self.param:GetGiftName())
    self.gift_btn:SetActive(true)
    self.go_btn:SetActive(false)
    self.gift_rect:SetActive(true)
    self._add_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_bg_item_pay"))
    self:SetGiftBtnInfo()
  elseif param:GetTips() == ResLackGoToType.ResourceBagUse or param:GetTips() == ResLackGoToType.LoesCamp or param:GetTips() == ResLackGoToType.UseBuildGoods then
    self.name_text:SetText(self.param:GetName())
    self.gift_btn:SetActive(false)
    self.go_btn:SetActive(true)
    self.gift_rect:SetActive(false)
    self:SetBtnInfo()
    self:CreateConsume()
  else
    self.item_icon:SetActive(true)
    self.item_icon:LoadSpriteAuto(param:GetIcon())
    self.name_text:SetText(self.param:GetName())
    self.gift_btn:SetActive(false)
    self.go_btn:SetActive(true)
    self.gift_rect:SetActive(false)
    self:SetBtnInfo()
    if param:GetTips() == ResLackGoToType.BuyGiftShop then
      self._add_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_bg_item_pay"))
      self.giftEffect_rect:SetActive(true)
    end
  end
end

local function ShowRecommend(self, isRecommend)
  self.recommend_rect:SetActive(isRecommend)
end

local function SetBtnInfo(self)
  self.go_txt:SetActive(self.param:GetBtnNameType() == 1)
  self.price_rect:SetActive(self.param:GetBtnNameType() == 2)
  if self.param:GetBtnNameType() == 1 then
    self.go_txt:SetText(self.param:GetBtnName())
  elseif self.param:GetBtnNameType() == 2 then
    self.buy_txt:SetLocalText(110080)
    self.price_txt:SetText(self.param:GetBtnName())
    self._buy_text:SetActive(true)
    self._buy_text:SetText(self.param:GetBuyNum())
  end
end

local function SetGiftBtnInfo(self)
  self.priceGift_txt:SetText(self.param:GetGiftPrice())
  self.point_rect:RefreshPoint(self.packageInfo)
  local list = self.param:GetCellsList()
  for i = 1, 3 do
    if list[i] then
      self.rewardList[i]:SetActive(true)
      self.rewardList[i]:ReInit(list[i])
    else
      self.rewardList[i]:SetActive(false)
    end
  end
end

local function CreateConsume(self, useCount)
  if self.param:GetTips() ~= ResLackGoToType.ResourceBagUse and self.param:GetTips() ~= ResLackGoToType.LoesCamp and self.param:GetTips() ~= ResLackGoToType.UseBuildGoods then
    return
  end
  local list = self.param:GetConsume()
  if #list == 1 then
    self.item_icon:SetActive(false)
    self.item:SetActive(true)
    self.item:ReInit(list[1])
    if list[1].rewardType == RewardType.GOODS then
      local ItemData = DataCenter.ItemData:GetItemById(list[1].itemId)
      if ItemData then
        self.item:SetItemCountActive(true)
        if useCount then
          self.item:SetItemCount(useCount)
        else
          self.item:SetItemCount(ItemData.count)
        end
      end
    end
  else
    self.item:SetActive(false)
    self.item_icon:SetActive(true)
  end
end

local function ClearList(self)
  self.consume_content:RemoveComponents(ConsumeItem)
  if next(self.model) then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function OnBtnClick(self)
  local isClose = true
  local isRefresh = false
  if self.param:GetTips() == ResLackGoToType.ResourceBagUse or self.param:GetTips() == ResLackGoToType.LoesCamp or self.param:GetTips() == ResLackGoToType.UseBuildGoods then
    isRefresh = true
    isClose = false
  elseif self.param:GetTips() == ResLackGoToType.ResourceBagBuy then
    if self.view.isList then
      isClose = false
      isRefresh = true
    end
  elseif self.param:GetTips() == ResLackGoToType.Explore then
    isClose = false
  end
  DataCenter.ArrowManager:RemoveArrow()
  self.param:TodoAction(self.go_btn.transform.position, isRefresh, self.lacktab)
  if isClose and self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

ResourceLackItem.OnCreate = OnCreate
ResourceLackItem.OnDestroy = OnDestroy
ResourceLackItem.OnBtnClick = OnBtnClick
ResourceLackItem.OnEnable = OnEnable
ResourceLackItem.OnDisable = OnDisable
ResourceLackItem.ComponentDefine = ComponentDefine
ResourceLackItem.ComponentDestroy = ComponentDestroy
ResourceLackItem.DataDefine = DataDefine
ResourceLackItem.DataDestroy = DataDestroy
ResourceLackItem.ReInit = ReInit
ResourceLackItem.ShowRecommend = ShowRecommend
ResourceLackItem.SetBtnInfo = SetBtnInfo
ResourceLackItem.SetGiftBtnInfo = SetGiftBtnInfo
ResourceLackItem.CreateConsume = CreateConsume
ResourceLackItem.ClearList = ClearList
return ResourceLackItem
