local UILuckyRollShopItem = BaseClass("UILuckyRollShopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local bgPath = "Bg"
local rawBgPath = "RawImgBg"
local glowBgPath = "GlowBg"
local nameTextPath = "NameText"
local iconPath = "Icon"
local descText = "DescText"
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
local bg1 = "Bg1"

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

local function OnClickFreeGet(self)
  if self.isFree and self.data then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local canGet = not UITimeManager:GetInstance():IsSameDayForServer(self.data.lastReceiveFreeTime / 1000, curTime)
    if canGet and self.actInfo then
      if self.actInfo.type == EnumActivity.LuckyRoll.Type then
        SFSNetwork.SendMessage(MsgDefines.LuckyRollReceiveFreeReward, self.data.actId)
      elseif self.actInfo.type == EnumActivity.GiftBoxActivity.Type then
        SFSNetwork.SendMessage(MsgDefines.GiftBoxFreeReward, self.data.actId)
      elseif self.actInfo.type == EnumActivity.LuckyShop.Type then
        SFSNetwork.SendMessage(MsgDefines.DiscountFreeReward, tonumber(self.data.actId))
      elseif self.actInfo.type == EnumActivity.Cooking.Type then
        local param = {}
        param.aid = tonumber(self.data.actId)
        param.id = tonumber(DataCenter.ActCookingData.actMakeFoodId)
        SFSNetwork.SendMessage(MsgDefines.ActivityMakeFoodFreeReward, param)
      elseif self.actInfo.type == EnumActivity.Banquet.Type then
        local param = {}
        param.aid = tonumber(self.data.actId)
        param.id = tonumber(DataCenter.ActBanquetData.actBanquetId)
        SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyRewardFree, param)
      elseif self.actInfo.type == EnumActivity.ActMonopoly.Type then
        local aid = tonumber(self.data.actId)
        SFSNetwork.SendMessage(MsgDefines.RichManDayReward, aid)
      elseif self.actInfo.type == EnumActivity.ActSlotMachine.Type then
        local aid = tonumber(self.data.actId)
        SFSNetwork.SendMessage(MsgDefines.SlotsDailyReward, aid)
      elseif self.actInfo.type == EnumActivity.BargainShop.Type then
        local aid = tonumber(self.data.actId)
        SFSNetwork.SendMessage(MsgDefines.BargainDayReward, aid)
      elseif self.actInfo.type == EnumActivity.TitaniumBlueStore.Type then
        local aid = tonumber(self.data.actId)
        SFSNetwork.SendMessage(MsgDefines.BlueShopDayReward, aid)
      elseif self.actInfo.type == EnumActivity.ActBountyHunter.Type then
        local aid = tonumber(self.data.actId)
        SFSNetwork.SendMessage(MsgDefines.BountyHunterReceiveFreeReward, aid)
      end
    end
  end
end

local function OnBuyBtnClick(self)
  if not self.isFree and self.giftPackData then
    DataCenter.PayManager:CallPayment(self.giftPackData, UIWindowNames.UILuckyRollShop)
  end
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, bgPath)
  self.rawImgBg = self:AddComponent(UIRawImage, rawBgPath)
  self.glowBg = self:AddComponent(UIImage, glowBgPath)
  self.nameText = self:AddComponent(UIText, nameTextPath)
  self.icon = self:AddComponent(UIImage, iconPath)
  self.descText = self:AddComponent(UIText, descText)
  self.freeGetBtn = self:AddComponent(UIButton, freeGetBtnPath)
  self.freeGetBtn:SetOnClick(function()
    OnClickFreeGet(self)
  end)
  self.freeGetBtnText = self:AddComponent(UIText, freeGetBtnTextPath)
  self.freeGetBtnText:SetLocalText(170004)
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, buyBtnPath)
  self.buyBtn:SetSafeClickMode(true)
  self.hotTag = self:AddComponent(UIImage, hotTagPath)
  self.hotTagText = self:AddComponent(UIText, hotTagTextPath)
  self.hotTagText:SetLocalText(2000353)
  self.discountBg = self:AddComponent(UIImage, discountBgPath)
  self.discountText = self:AddComponent(UIText, discountTextPath)
  self.rewardItems = self:AddComponent(UIBaseContainer, rewardItemsPath)
  self.buyFreeBtn = self:AddComponent(UIButton, "buyFreeBtn")
  self.buyFreeBtnBg = self:AddComponent(UIImage, "buyFreeBtn")
  self.buyFreeBtn:SetOnClick(function()
    self:OnClickFreeAndGoldPayBtn()
  end)
  self.buyFreeBtn:SetSafeClickMode(true)
  self.buyFreeBtnText = self:AddComponent(UITextMeshProUGUIEx, "buyFreeBtn/layout/buyFreeBtnText")
  self.buyFreeCostIcon = self:AddComponent(UIImage, "buyFreeBtn/layout/buyFreeCostIcon")
  self.buyFreeBtnLayout = self:AddComponent(UIBaseContainer, "buyFreeBtn/layout")
  self.bg1 = self:AddComponent(UIImage, bg1)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.glowBg = nil
  self.nameText = nil
  self.icon = nil
  self.descText = nil
  self.freeGetBtn = nil
  self.freeGetBtnText = nil
  self.buyBtn = nil
  self.hotTag = nil
  self.hotTagText = nil
  self.discountBg = nil
  self.discountText = nil
  self.rewardItems = nil
  self.buyFreeBtnLayout = nil
  self.bg1 = nil
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

local function SetData(self, data, actId)
  self.isFree = data.isFree
  self.data = data.realData
  self.actId = actId
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
      if cell.name_text then
        cell.name_text:SetActive(false)
      end
    end)
  end
end

local glowBgColor = {
  [2] = Color.New(0.29, 0.94, 0.71, 1),
  [3] = Color.New(0.3, 0.92, 0.93, 1),
  [4] = Color.New(0.78, 0.59, 0.98, 1),
  [5] = Color.New(0.99, 0.86, 0.36, 1)
}

local function SetQuality(self, quality, isFree)
  self.rawImgBg:SetActive(false)
  local qualityNum = tonumber(quality)
  if qualityNum < 1 or 5 < qualityNum then
    return
  end
  self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UILuckyRoll/cfm_huodong_dazhuanpan_libao_ka_%d.png", qualityNum))
  if isFree and self.actInfo then
    if self.actInfo.type == EnumActivity.Cooking.Type or self.actInfo.type == EnumActivity.Banquet.Type then
      self.rawImgBg:SetActive(true)
      self.rawImgBg:LoadSprite("Assets/Main/TextureEx/UIActivityBg/Banner/Cooking/lrb_yanhui_cailiaozhigoulibao_banner.png")
    elseif self.actInfo.type == EnumActivity.ActMonopoly.Type or self.actInfo.type == EnumActivity.ActSlotMachine.Type or self.actInfo.type == EnumActivity.TorchRelay.Type or self.actInfo.type == EnumActivity.BargainShop.Type then
      local showTemp = self.actInfo:GetShowConfigTemp()
      if showTemp then
        local bannerName = showTemp.free_banner
        if not string.IsNullOrEmpty(bannerName) then
          local bannerPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.LuckyRollShopBannerPath, bannerName)
          self.rawImgBg:SetActive(true)
          self.rawImgBg:LoadSprite(bannerPath)
        end
      end
    end
  end
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
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if self.actInfo then
    if self.actInfo.type == EnumActivity.LuckyRoll.Type then
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UILuckyRoll/cfm_huodong_dazhuanpan_libao_tubiao_bi_1.png")
    elseif self.actInfo.type == EnumActivity.ScratchOffGame.Type then
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/icon_guagaulejiangquan.png")
    elseif self.actInfo.type == EnumActivity.GiftBoxActivity.Type then
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/zyf_kongtouzhaohuan_key.png")
    elseif self.actInfo.type == EnumActivity.LuckyShop.Type then
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhekoushangdian_zhekou_icon.png")
    elseif self.actInfo.type == EnumActivity.Cooking.Type then
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UIActivityThanksGiving/lrb_yanhui_cailiaozhigoulibao_icon.png")
    elseif self.actInfo.type == EnumActivity.Banquet.Type then
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UIActivityThanksGiving/zyf_ganenjie_kaojilibao_icon.png")
    elseif self.actInfo.type == EnumActivity.TitaniumBlueStore.Type then
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/zyf_tailanshangcheng_tailanbi.png")
    elseif self.actInfo.type == EnumActivity.ActBountyHunter.Type then
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/lyt_shangjinlieren_zidan.png")
    end
    self.icon:SetNativeSize()
  end
  self:DelTimer()
  if self.isFree then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if not UITimeManager:GetInstance():IsSameDayForServer(self.data.lastReceiveFreeTime / 1000, curTime) then
      CS.UIGray.SetGray(self.freeGetBtn.transform, false, true)
    else
      CS.UIGray.SetGray(self.freeGetBtn.transform, true, true)
      self:AddTimer()
    end
    self.nameText:SetLocalText(2000348)
    self.icon:SetActive(false)
    self.descText:SetActive(false)
    self.freeGetBtn:SetActive(true)
    self.buyBtn:SetActive(false)
    self.buyFreeBtn:SetActive(false)
    self.hotTag:SetActive(false)
    self.discountBg:SetActive(false)
    SetQuality(self, 1, true)
    RefreshRewards(self, self.data.rewards)
  else
    self.giftPackData = self.data
    self.icon:SetActive(true)
    self.descText:SetActive(true)
    self.descText:SetLocalText(2000790, self.giftPackData._tableData.buy_times - (self.giftPackData._serverData.buys or 0))
    self.freeGetBtn:SetActive(false)
    self.nameText:SetText(self.giftPackData:getNameText())
    local isBestBuy = self.giftPackData:IsBestBuy()
    self.hotTag:SetActive(isBestBuy)
    local quality = self.giftPackData:getQuality()
    SetQuality(self, quality, false)
    local buyType = self.giftPackData:GetBuyType()
    if buyType == GiftPackageBuyType.Money then
      self.buyBtn:Init(self.giftPackData)
      self.buyBtn:RefreshPoint()
      RefreshRewards(self, self.giftPackData:getItems(true))
      local percent = self.giftPackData:getPercent()
      if percent then
        self.discountBg:SetActive(true)
        self.discountText:SetText(string.format("%s%%", tostring(percent)))
      else
        self.discountBg:SetActive(false)
      end
    else
      self.discountBg:SetActive(false)
      RefreshRewards(self, self.giftPackData:getFreeAndGoldBuyReward())
      if buyType == GiftPackageBuyType.PlayerGold then
        local resourceType, num = self.giftPackData:GetResourceBuyCostTypeAndNum()
        if resourceType ~= nil then
          self.buyFreeCostIcon:LoadSprite(CommonUtil.GetResOrItemIcon(resourceType))
          self.buyFreeBtnText:SetText(num)
        else
          Logger.LogError("\231\173\150\229\136\146\233\133\141\233\148\153\228\186\134\239\188\129  exchangeId:" .. self.giftPackData._tableData.id)
        end
        self.buyFreeBtnBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_4.png")
      else
        self.buyFreeBtnText:SetLocalText("bingo_task_button1")
        self.buyFreeBtnBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
      end
      self.buyFreeCostIcon:SetActive(buyType == GiftPackageBuyType.PlayerGold)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyFreeBtnLayout.transform)
    end
    self.buyBtn:SetActive(buyType == GiftPackageBuyType.Money)
    self.buyFreeBtn:SetActive(buyType ~= GiftPackageBuyType.Money)
    if self.giftPackData then
      if self.actInfo then
        if self.actInfo.type == EnumActivity.Cooking.Type then
          self.icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivityThanksGiving/%s", self.giftPackData:getPopupImageMini()))
        elseif self.actInfo.type == EnumActivity.Banquet.Type then
          self.icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivityThanksGiving/%s", self.giftPackData:getPopupImageMini()))
        elseif self.actInfo.type == EnumActivity.LuckyRoll.Type then
          self.icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UILuckyRoll/%s", self.giftPackData:getPopupImageMini()))
        elseif self.actInfo.type == EnumActivity.ActMonopoly.Type or self.actInfo.type == EnumActivity.ActSlotMachine.Type or self.actInfo.type == EnumActivity.BargainShop.Type or self.actInfo.type == EnumActivity.BlackMarket.Type then
          self.icon:LoadSprite(string.format(LoadPath.ItemPath, self.giftPackData:getPopupImageMini()))
        end
        self.icon:SetNativeSize()
      end
      if self.giftPackData:getGroup() == tostring(GiftSystemConst.ShopGroupId) then
        local icon = self.giftPackData:getPopupImageMini()
        if string.IsNullOrEmpty(icon) then
          local template = DataCenter.ItemTemplateManager:GetItemTemplate(GiftSystemConst.ShopItemId)
          self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/" .. template.icon)
        else
          self.icon:LoadSprite(string.format(LoadPath.ItemPath, icon))
        end
      end
      if self.actInfo then
        local showTemp = self.actInfo:GetShowConfigTemp()
        if showTemp and not string.IsNullOrEmpty(showTemp.free_banner) then
          self.bg1:SetActive(false)
        else
          self.bg1:SetActive(true)
        end
      else
        self.bg1:SetActive(true)
      end
    end
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
  if not self.isFree then
    self:DelTimer()
    return
  end
  if not self.data then
    self:DelTimer()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if not UITimeManager:GetInstance():IsSameDayForServer(self.data.lastReceiveFreeTime / 1000, curTime) then
    CS.UIGray.SetGray(self.freeGetBtn.transform, false, true)
    self:DelTimer()
    return
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILuckyRollShopItem:OnClickFreeAndGoldPayBtn()
  if not self.isFree and self.giftPackData then
    DataCenter.PayManager:CallPayment(self.giftPackData, UIWindowNames.UILuckyRollShop)
  end
end

UILuckyRollShopItem.OnCreate = OnCreate
UILuckyRollShopItem.OnDestroy = OnDestroy
UILuckyRollShopItem.ComponentDefine = ComponentDefine
UILuckyRollShopItem.ComponentDestroy = ComponentDestroy
UILuckyRollShopItem.DataDefine = DataDefine
UILuckyRollShopItem.DataDestroy = DataDestroy
UILuckyRollShopItem.OnEnable = OnEnable
UILuckyRollShopItem.OnDisable = OnDisable
UILuckyRollShopItem.SetData = SetData
UILuckyRollShopItem.RefreshAll = RefreshAll
UILuckyRollShopItem.RefreshRed = RefreshRed
UILuckyRollShopItem.AddTimer = AddTimer
UILuckyRollShopItem.SetRemainTime = SetRemainTime
UILuckyRollShopItem.DelTimer = DelTimer
UILuckyRollShopItem.ClearRewards = ClearRewards
UILuckyRollShopItem.RefreshRewards = RefreshRewards
return UILuckyRollShopItem
