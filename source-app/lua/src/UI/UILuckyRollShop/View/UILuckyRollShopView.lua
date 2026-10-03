local base = UIBaseView
local UILuckyRollShopView = BaseClass("UILuckyRollShopView", base)
local Localization = CS.GameEntry.Localization
local UILuckyRollShopItem = require("UI.UILuckyRollShop.Component.UILuckyRollShopItem")
local UILuckyRollShopBuyItem = require("UI.UILuckyRollShop.Component.UILuckyRollShopBuyItem")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local title_txt_path = "Root/TopBar/TextTitle"
local back_btn_path = "Root/BottomBar/BtnBack"
local text_desc_path = "Root/BottomBar/TextDesc"
local item_bar_path = "Root/TopBar/ItemBar"
local item_bar2_path = "Root/TopBar/ItemBar2"
local diamond_bar_path = "Root/TopBar/DiamondBar"
local pack_list_path = "Root/PackList"
local pack_list_content_path = "Root/PackList/Viewport/Content"
local timeCountDownContainer_path = "Root/TimeCountDownContainer"
local timeCountDownTipsText_path = "Root/TimeCountDownContainer/HorLayout/TimeCountDownTipsText"
local emptyTipsText_path = "Root/EmptyTipsText"
local timeCountDownText_path = "Root/TimeCountDownContainer/HorLayout/TimeCountDownText"
local TopBar = "Root/TopBar"
local ImageBg = "ImgBg"
local dec_path = "Root/TopBar/Dec"
local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
local topBarBgDefaultHeight = 91.5
local topBarBgNewHeight = 150

local function OnCreate(self)
  base.OnCreate(self)
  self.actId, self.packGroup, self.costItemId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  if self.costItemId and type(self.costItemId) == "table" then
    local totalCount = math.min(#self.costItemId, #self.itemBarList)
    for i = 1, totalCount do
      self.itemBarList[i]:SetActive(true)
      self.itemBarList[i]:SetData(self.costItemId[i], nil, nil)
    end
    for i = #self.costItemId + 1, #self.itemBarList do
      self.itemBarList[i]:SetActive(false)
    end
  else
    self.diamond_bar:SetData(nil, ResourceType.Gold, nil)
    self.item_bar:SetData(self.costItemId, nil, nil)
    self.item_bar2:SetActive(false)
  end
  local title, desc = "", ""
  local showTimeCountDown = false
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if actInfo then
    self.actData = DataCenter.ActivityListDataManager:GetActivityShopActData(self.actId)
    if actInfo.type == EnumActivity.LuckyRoll.Type then
      title = 2000349
    elseif actInfo.type == EnumActivity.ScratchOffGame.Type then
      title = 2000801
    elseif actInfo.type == EnumActivity.GiftBoxActivity.Type then
      PostEventLog.Track(PostEventLog.Defines.OpenGiftBoxGetKeyPanel, {})
      title = 2800072
    elseif actInfo.type == EnumActivity.LuckyShop.Type then
      title = 2800044
    elseif actInfo.type == EnumActivity.Cooking.Type then
      title = "thanksactivity_UI009"
    elseif actInfo.type == EnumActivity.Banquet.Type then
      title = "thanksactivity_UI010"
    elseif actInfo.type == EnumActivity.ActMonopoly.Type then
      title = "320003"
    elseif actInfo.type == EnumActivity.BargainShop.Type then
      title = "320003"
    elseif actInfo.type == EnumActivity.ActSlotMachine.Type then
      title = "320003"
    elseif actInfo.type == EnumActivity.TitaniumBlueStore.Type then
      showTimeCountDown = true
      self.timeCountDownContainer:SetActive(true)
      self.timeCountDownTipsText:SetLocalText("activity_blue_shop_desc9")
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local surplusTime = self.actData.nextRefreshTime - curTime
      self.timeCountDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    elseif actInfo.type == EnumActivity.ActMigration.Type then
      title = "migration_activity_interface_10112"
    elseif actInfo.type == EnumActivity.ActBountyHunter.Type then
      self.emptyTipsText:SetLocalText("activity_hunter_gift_desc2")
      self.timeCountDownContainer:SetActive(true)
      showTimeCountDown = true
    end
  end
  if self.packGroup == GiftSystemConst.ShopGroupId then
    if not self.nextWeekDayTime then
      self.nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.nextWeekDayTime - curTime
    if remainTime <= 0 then
      self.nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
      remainTime = self.nextWeekDayTime - curTime
    end
    self.timeCountDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    showTimeCountDown = true
    self.timeCountDownContainer:SetActive(true)
    self.timeCountDownTipsText:SetLocalText("shop_refresh_tips_weekly")
  end
  self.title_txt:SetLocalText(title)
  self.text_desc:SetLocalText(desc)
  if showTimeCountDown then
    self.pack_list:SetOffsetMaxXY(0, -160)
  else
    self.pack_list:SetOffsetMaxXY(0, -111.9)
  end
  self:Refresh()
  self:RefreshPackByAct()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function Update1000MS(self)
  if self.actData and self.actData.nextRefreshTime and self.timeCountDownText then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local surplusTime = self.actData.nextRefreshTime - curTime
    if 0 <= surplusTime then
      self.timeCountDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    end
  elseif self.packGroup == GiftSystemConst.ShopGroupId and self.nextWeekDayTime and self.timeCountDownText then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local surplusTime = self.nextWeekDayTime - curTime
    if 0 <= surplusTime then
      self.timeCountDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    end
  end
end

local function RefreshData(self)
  self.packDataList = {}
  if self.actData and not table.IsNullOrEmpty(self.actData.freeReward) then
    local freePackData = {}
    freePackData.isFree = true
    freePackData.realData = {}
    freePackData.realData.actId = self.actId
    freePackData.realData.lastReceiveFreeTime = self.actData.lastReceiveFreeTime
    freePackData.realData.rewards = self.actData.freeReward
    table.insert(self.packDataList, freePackData)
  end
  local ignoreTime = self.packGroup == GiftSystemConst.ShopGroupId
  local giftPack = GiftPackManager.GetPacksByGroupId(self.packGroup, false, ignoreTime)
  for _, v in pairs(giftPack) do
    local giftPackData = {}
    giftPackData.isFree = false
    giftPackData.realData = v
    table.insert(self.packDataList, giftPackData)
  end
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if actInfo and actInfo.type == EnumActivity.ActMigration.Type and LuaEntry.Player:IsInAlliance() then
    local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.AllianceShop, DataCenter.ActMigrationManager:GetItemShopId())
    if goodsConf then
      local shopBuyData = {}
      shopBuyData.isShopBuy = true
      local realData = {}
      realData.goodsConf = goodsConf
      realData.pic = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_btn_alliance.png"
      realData.name = "450125"
      realData.des = "450128"
      shopBuyData.realData = realData
      table.insert(self.packDataList, shopBuyData)
    end
  end
end

local function Refresh(self)
  RefreshData(self)
  if self.packDataList == nil or #self.packDataList == 0 then
    self.pack_list:SetActive(false)
    self.emptyTipsText:SetActive(true)
  else
    self.pack_list:SetActive(true)
    self.pack_list:SetListItemCount(#self.packDataList, false, false)
    self.pack_list:RefreshAllShownItem()
  end
end

local function RefreshGold(self)
  if self.diamond_bar then
    self.diamond_bar:RefreshData()
  end
end

local function RefreshGoods(self)
  for i = 1, #self.itemBarList do
    self.itemBarList[i]:RefreshData()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:AddUIListener(EventId.ActLuckyRollUpdate, self.Refresh)
  self:AddUIListener(EventId.ActGiftFreeRewardReceive, self.Refresh)
  self:AddUIListener(EventId.ActFreeRewardReceive, self.Refresh)
  self:AddUIListener(EventId.ActMonopolyDailyRewardUpdate, self.Refresh)
  self:AddUIListener(EventId.ActSlotDailyRewardUpdate, self.Refresh)
  self:AddUIListener(EventId.BargainDayRewardUpdate, self.Refresh)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
  self:AddUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:AddUIListener(EventId.RefreshTitaniumBlueDailyRewardData, self.Refresh)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.BountyHunterDailyRewardUpdate, self.Refresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:RemoveUIListener(EventId.ActLuckyRollUpdate, self.Refresh)
  self:RemoveUIListener(EventId.ActGiftFreeRewardReceive, self.Refresh)
  self:RemoveUIListener(EventId.ActFreeRewardReceive, self.Refresh)
  self:RemoveUIListener(EventId.ActMonopolyDailyRewardUpdate, self.Refresh)
  self:RemoveUIListener(EventId.ActSlotDailyRewardUpdate, self.Refresh)
  self:RemoveUIListener(EventId.BargainDayRewardUpdate, self.Refresh)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:RemoveUIListener(EventId.RefreshTitaniumBlueDailyRewardData, self.Refresh)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.BountyHunterDailyRewardUpdate, self.Refresh)
end

local function ClearScroll(self)
  self.pack_list_content:RemoveComponents(UILuckyRollShopItem)
  self.pack_list_content:RemoveComponents(UILuckyRollShopBuyItem)
  self.pack_list:ClearAllItems()
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.packDataList then
    return nil
  end
  local packData = self.packDataList[index]
  local itemKey = packData.isShopBuy and "ShopBuyItem" or "PackItem"
  local itemCls = packData.isShopBuy and UILuckyRollShopBuyItem or UILuckyRollShopItem
  local item = loopScroll:NewListViewItem(itemKey)
  local script = self.pack_list_content:GetComponent(item.gameObject.name, itemCls)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.pack_list_content:AddComponent(itemCls, objectName)
  end
  script:SetActive(true)
  script:SetData(packData, self.actId)
  return item
end

local function ComponentDefine(self)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_desc = self:AddComponent(UIText, text_desc_path)
  self.pack_list = self:AddComponent(UILoopListView2, pack_list_path)
  self.pack_list:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.pack_list_content = self:AddComponent(UIBaseContainer, pack_list_content_path)
  self.item_bar = self:AddComponent(UITopItem, item_bar_path)
  self.diamond_bar = self:AddComponent(UITopItem, diamond_bar_path)
  self.item_bar2 = self:AddComponent(UITopItem, item_bar2_path)
  self.itemBarList = {
    self.diamond_bar,
    self.item_bar,
    self.item_bar2
  }
  self.timeCountDownText = self:AddComponent(UIText, timeCountDownText_path)
  self.timeCountDownTipsText = self:AddComponent(UIText, timeCountDownTipsText_path)
  self.timeCountDownContainer = self:AddComponent(UIBaseContainer, timeCountDownContainer_path)
  self.timeCountDownContainer:SetActive(false)
  self.emptyTipsText = self:AddComponent(UIText, emptyTipsText_path)
  self.emptyTipsText:SetActive(false)
  self.item_bar:SetShowAddBtn(false)
  self.item_bar2:SetShowAddBtn(false)
  self.diamond_bar:SetShowAddBtn(false)
  self.topBar = self:AddComponent(UIImage, TopBar)
  self.imgBg = self:AddComponent(UIImage, ImageBg)
  self.dec = self:AddComponent(UIBaseComponent, dec_path)
end

local function ComponentDestroy(self)
  self.title_txt = nil
  self.back_btn = nil
  self.pack_list = nil
  self.pack_content_list = nil
  self.item_bar = nil
  self.item_bar2 = nil
  self.diamond_bar = nil
  self.timeCountDownText = nil
  self.timeCountDownTipsText = nil
  self.timeCountDownContainer = nil
  self.emptyTipsText = nil
  self.topBar = nil
  self.imgBg = nil
  self.dec = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UILuckyRollShopView:OnEnable()
  base.OnEnable(self)
  self:Refresh()
  self:RefreshGold()
end

local function OnPassDay(self)
  if self.actId then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
    if not actData or not actData:IsValid() then
      self.ctrl:CloseSelf()
      return
    end
  end
end

local function RefreshPackByAct(self)
  if self.actId then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
    if actData then
      local configId = actData:GetFestivalInterfaceCfgId()
      if configId and configId ~= 0 then
        local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, actData:GetFestivalInterfaceCfgId())
        if lineData and not string.IsNullOrEmpty(lineData.banner) and not string.IsNullOrEmpty(lineData.bg) then
          local hasTopBar = false
          for _, v in pairs(self.itemBarList) do
            if v.activeSelf then
              hasTopBar = true
              break
            end
          end
          local bannerList = string.split(lineData.banner, "|")
          if bannerList and #bannerList == 2 then
            local banner = hasTopBar and bannerList[1] or lineData.bannerList[2]
            local bannerPath = string.format(activityThemPath, banner)
            self.topBar:LoadSprite(bannerPath)
            local bgPath = string.format(activityThemPath, lineData.bg)
            self.imgBg:LoadSprite(bgPath)
            self.dec:SetActive(false)
            self.topBar:SetSizeDeltaY(topBarBgNewHeight)
            return
          end
        end
      end
    end
  end
  self:RefreshDefaultPack()
end

local function RefreshDefaultPack(self)
  local defaultTopBar = "Assets/Main/TextureEx/UICommonWindowBg/cfm_tongyon_quanping_di_2.png"
  local defaultBg = "Assets/Main/TextureEx/UICommonWindowBg/cfm_tongyon_quanping_di_1.png"
  self.topBar:LoadSprite(defaultTopBar)
  self.imgBg:LoadSprite(defaultBg)
  self.dec:SetActive(true)
  self.topBar:SetSizeDeltaY(topBarBgDefaultHeight)
end

UILuckyRollShopView.OnCreate = OnCreate
UILuckyRollShopView.OnDestroy = OnDestroy
UILuckyRollShopView.OnAddListener = OnAddListener
UILuckyRollShopView.OnRemoveListener = OnRemoveListener
UILuckyRollShopView.ComponentDefine = ComponentDefine
UILuckyRollShopView.ComponentDestroy = ComponentDestroy
UILuckyRollShopView.DataDefine = DataDefine
UILuckyRollShopView.DataDestroy = DataDestroy
UILuckyRollShopView.ClearScroll = ClearScroll
UILuckyRollShopView.Refresh = Refresh
UILuckyRollShopView.RefreshGold = RefreshGold
UILuckyRollShopView.RefreshGoods = RefreshGoods
UILuckyRollShopView.Update1000MS = Update1000MS
UILuckyRollShopView.OnPassDay = OnPassDay
UILuckyRollShopView.RefreshPackByAct = RefreshPackByAct
UILuckyRollShopView.RefreshDefaultPack = RefreshDefaultPack
return UILuckyRollShopView
