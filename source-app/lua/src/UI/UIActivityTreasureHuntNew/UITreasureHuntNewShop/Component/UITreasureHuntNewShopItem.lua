local UITreasureHuntNewShopItem = BaseClass("UITreasureHuntNewShopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local bgPath = "Bg"
local bgGotoPath = "BgGoto"
local glowBgPath = "GlowBg"
local nameTextPath = "NameText"
local iconPath = "Icon"
local descText = "DescText"
local gotoTypeText = "GotoTypeText"
local freeGetBtnPath = "FreeGetBtn"
local freeGetBtnTextPath = "FreeGetBtn/FreeGetBtnText"
local buyBtnPath = "BuyBtn"
local buyBtnTextPath = "BuyBtn/BuyBtnText"
local hotTagPath = "HotTag"
local hotTagTextPath = "HotTag/HotText"
local discountBgPath = "DiscountBg"
local discountTextPath = "DiscountBg/DiscountText"
local rewardItemsPath = "RewardItemScroll/RewardItems"
local giftPackPointPath = "BuyBtn/UIGiftPackagePoint"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewards()
  self:DelTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnClickGoto(self)
  if self.isGoto and self.data then
    local gotoId = tonumber(self.data.GotoId)
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(gotoId)
    if activityInfo == nil then
      return
    end
    GoToUtil.GoActWindow({gotoId})
  end
end

local function OnBuyBtnClick(self)
  if not self.isGoto and self.giftPackData then
    DataCenter.PayManager:CallPayment(self.giftPackData, UIWindowNames.UITreasureHuntNewShop)
  end
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, bgPath)
  self.bgGoto = self:AddComponent(UIImage, bgGotoPath)
  self.glowBg = self:AddComponent(UIImage, glowBgPath)
  self.nameText = self:AddComponent(UIText, nameTextPath)
  self.icon = self:AddComponent(UIImage, iconPath)
  self.descText = self:AddComponent(UIText, descText)
  self.gotoTypeText = self:AddComponent(UIText, gotoTypeText)
  self.freeGetBtn = self:AddComponent(UIButton, freeGetBtnPath)
  self.freeGetBtn:SetOnClick(function()
    OnClickGoto(self)
  end)
  self.freeGetBtnText = self:AddComponent(UIText, freeGetBtnTextPath)
  self.freeGetBtnText:SetLocalText(2000645)
  self.buyBtn = self:AddComponent(UIButton, buyBtnPath)
  self.buyBtn:SetOnClick(function()
    OnBuyBtnClick(self)
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.buyBtnText = self:AddComponent(UIText, buyBtnTextPath)
  self.hotTag = self:AddComponent(UIImage, hotTagPath)
  self.hotTagText = self:AddComponent(UIText, hotTagTextPath)
  self.hotTagText:SetLocalText(2000353)
  self.discountBg = self:AddComponent(UIImage, discountBgPath)
  self.discountText = self:AddComponent(UIText, discountTextPath)
  self.rewardItems = self:AddComponent(UIBaseContainer, rewardItemsPath)
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, giftPackPointPath)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.bgGoto = nil
  self.glowBg = nil
  self.nameText = nil
  self.icon = nil
  self.descText = nil
  self.gotoTypeText = nil
  self.freeGetBtn = nil
  self.freeGetBtnText = nil
  self.buyBtn = nil
  self.buyBtnText = nil
  self.hotTag = nil
  self.hotTagText = nil
  self.discountBg = nil
  self.discountText = nil
  self.rewardItems = nil
  self.giftPackPoint = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.TimerAction = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshRed()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, data)
  self.isGoto = data.isGoto
  self.data = data.realData
  self:RefreshAll()
end

local function ClearRewards(self)
  self.rewardItems:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function RefreshRewards(self, rewards)
  self:ClearRewards()
  for i = 1, table.length(rewards) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.rewardItems.transform)
      go.transform:Set_localScale(0.84, 0.84, 1)
      go.transform:Set_sizeDelta(98, 98)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_pivot(0.5, 0.5)
      go.name = "item" .. i
      local cell = self.rewardItems:AddComponent(UICommonResItem, go.name)
      cell:ReInit(rewards[i])
    end)
  end
end

local glowBgColor = {
  [2] = Color.New(0.29, 0.94, 0.71, 1),
  [3] = Color.New(0.3, 0.92, 0.93, 1),
  [4] = Color.New(0.78, 0.59, 0.98, 1),
  [5] = Color.New(0.99, 0.86, 0.36, 1)
}

local function SetQuality(self, quality)
  local qualityNum = tonumber(quality)
  self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UILuckyRoll/cfm_huodong_dazhuanpan_libao_ka_%d.png", qualityNum))
  if 1 < qualityNum then
    self.glowBg:SetActive(true)
    self.glowBg:SetColor(glowBgColor[qualityNum])
  else
    self.glowBg:SetActive(false)
  end
end

local function RefreshAll(self)
  if not self.data then
    return
  end
  self:DelTimer()
  if self.isGoto then
    self.nameText:SetLocalText(2000643)
    self.icon:SetActive(false)
    self.descText:SetActive(false)
    self.freeGetBtn:SetActive(true)
    self.buyBtn:SetActive(false)
    self.hotTag:SetActive(false)
    self.discountBg:SetActive(false)
    RefreshRewards(self, {})
    self.bgGoto:SetActive(true)
    self.gotoTypeText:SetActive(true)
    local gotoId = tonumber(self.data.GotoId)
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(gotoId)
    if activityInfo ~= nil then
      self.gotoTypeText:SetLocalText(activityInfo.activityName)
    end
  else
    self.giftPackData = self.data
    self.icon:SetActive(true)
    self.descText:SetActive(true)
    self.descText:SetLocalText(2000790, self.giftPackData._tableData.buy_times - (self.giftPackData._serverData.buys or 0))
    self.freeGetBtn:SetActive(false)
    self.buyBtn:SetActive(true)
    self.buyBtnText:SetText(self.giftPackData:getPriceText())
    self.giftPackPoint:RefreshPoint(self.giftPackData)
    self.nameText:SetText(self.giftPackData:getNameText())
    local percent = self.giftPackData:getPercent()
    if percent then
      self.hotTag:SetActive(true)
      self.discountBg:SetActive(true)
      self.discountText:SetText(string.format("%s%%", tostring(percent)))
    else
      self.hotTag:SetActive(false)
      self.discountBg:SetActive(false)
    end
    local isBestBuy = self.giftPackData:IsBestBuy()
    self.hotTag:SetActive(isBestBuy)
    local quality = self.giftPackData:getQuality()
    SetQuality(self, quality)
    RefreshRewards(self, self.giftPackData:getItems(true))
    self.bgGoto:SetActive(false)
    self.gotoTypeText:SetActive(false)
  end
end

local function RefreshRed(self)
end

local function AddTimer(self)
  function self.TimerAction()
    self:SetRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

local function SetRemainTime(self)
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

UITreasureHuntNewShopItem.OnCreate = OnCreate
UITreasureHuntNewShopItem.OnDestroy = OnDestroy
UITreasureHuntNewShopItem.ComponentDefine = ComponentDefine
UITreasureHuntNewShopItem.ComponentDestroy = ComponentDestroy
UITreasureHuntNewShopItem.DataDefine = DataDefine
UITreasureHuntNewShopItem.DataDestroy = DataDestroy
UITreasureHuntNewShopItem.OnEnable = OnEnable
UITreasureHuntNewShopItem.OnDisable = OnDisable
UITreasureHuntNewShopItem.SetData = SetData
UITreasureHuntNewShopItem.RefreshAll = RefreshAll
UITreasureHuntNewShopItem.RefreshRed = RefreshRed
UITreasureHuntNewShopItem.AddTimer = AddTimer
UITreasureHuntNewShopItem.SetRemainTime = SetRemainTime
UITreasureHuntNewShopItem.DelTimer = DelTimer
UITreasureHuntNewShopItem.ClearRewards = ClearRewards
UITreasureHuntNewShopItem.RefreshRewards = RefreshRewards
return UITreasureHuntNewShopItem
