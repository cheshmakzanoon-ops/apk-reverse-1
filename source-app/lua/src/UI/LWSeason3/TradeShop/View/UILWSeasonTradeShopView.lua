local UILWSeasonTradeShopView = BaseClass("UILWSeasonTradeShopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWSeasonTradeShopItem = require("UI.LWSeason3.TradeShop.Component.UILWSeasonTradeShopItem")
local UIDynamicSkin = require("Framework.UI.Component.UIDynamicSkin")
local res_root_path = "Root/TopBar/ResRoot"
local res_text_path = "Root/TopBar/ResRoot/ResText"
local icon_path = "Root/TopBar/ResRoot/ResText/Icon"
local plus_path = "Root/TopBar/ResRoot/ResText/plus"
local btn_back_path = "Root/BottomBar/BtnBack"
local tip_text_path = "Root/BottomBar/TipText"
local player_head_path = "Root/Center/top/Head/UIPlayerHead"
local desc_text_path = "Root/Center/top/DescText"
local info_btn_path = "Root/Center/top/InfoBtn"
local city_btn_path = "Root/Center/top/cityBtn"
local name_text_path = "Root/Center/top/NameText"
local shop_time_path = "Root/Center/top/TimeInfoItem"
local shop_time_text_path = "Root/Center/top/TimeInfoItem/timeBg2/TimeText"
local scroll_view_path = "Root/Center/ScrollView"
local scroll_content_path = "Root/Center/ScrollView/Viewport/Content"
local buy_times_text_path = "Root/Center/BuyTimesText"
local top_rawImage_path = "Root/Center/top"
local info_root_path = "Root/Center/top/InfoRoot"

function UILWSeasonTradeShopView:OnCreate()
  base.OnCreate(self)
  self.res_root = self:AddComponent(UIButton, res_root_path)
  self.res_root:SetOnClick(function()
    self:OnClickRes()
  end)
  self.res_text = self:AddComponent(UITextMeshProUGUIEx, res_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.plus = self:AddComponent(UIButton, plus_path)
  self.plus:SetOnClick(function()
    self:OnClickRes()
  end)
  self.top_rawImage = self:AddComponent(UIRawImage, top_rawImage_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString("170001"), nil, Localization:GetString("season_s3_activity_1000072_desc46"))
  end)
  self.city_btn = self:AddComponent(UIButton, city_btn_path)
  self.city_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.TradeStationCity, {anim = true}, self.serverId)
  end)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.shop_time_text = self:AddComponent(UIText, shop_time_text_path)
  self.shop_time_root = self:AddComponent(UIBaseContainer, shop_time_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
  self.buy_times_text = self:AddComponent(UITextMeshProUGUIEx, buy_times_text_path)
  self.info_root = self:AddComponent(UIBaseContainer, info_root_path)
  self.skinMgr = self:AddComponent(UIDynamicSkin, "")
  self.tradeId, self.serverId = self:GetUserData()
  if not self.serverId then
    self.serverId = LuaEntry.Player:GetCurServerId()
  end
  self:DataDefine()
  self:OnRefreshRes()
  self:RefreshInfo()
  self:TryUpdateTradeData()
  self:TryReqShopGoodsInfo()
end

function UILWSeasonTradeShopView:OnDestroy()
  if self.infoRequest then
    self.infoRequest:Destroy()
    self.infoRequest = nil
  end
  DataCenter.SeasonTradeShopDataManager:NotifyServerCloseShopUI(self.tradeId, self.serverId)
  self:ClearItems()
  self.res_root = nil
  self.res_text = nil
  self.icon = nil
  self.btn_back = nil
  self.tip_text = nil
  self.player_head = nil
  self.desc_text = nil
  self.info_btn = nil
  self.name_text = nil
  self.shop_time_text = nil
  self.scroll_view = nil
  self.shop_time_text = nil
  self.buy_times_text = nil
  DataCenter.SeasonTradeShopDataManager:CleanShopInfo()
  self.tradeId = nil
  self.serverId = nil
  self.tradeData = nil
  self.cityTemplate = nil
  self.list = nil
  self.maxTimes = nil
  self.last_update_time = nil
  self.last_req_time = nil
  base.OnDestroy(self)
end

function UILWSeasonTradeShopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.OnRefreshRes)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshRes)
  self:AddUIListener(EventId.GetTradeShopGoodsInfo, self.OnRefreshInfo)
  self:AddUIListener(EventId.UpdateTradeShopGoodsInfo, self.TryRefreshInfo)
  self:AddUIListener(EventId.GetTradeDetail, self.OnRefreshDetail)
  self:AddUIListener(EventId.BloodyNightActivityRefresh, self.BloodyNightActivityRefresh)
end

function UILWSeasonTradeShopView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGold, self.OnRefreshRes)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshRes)
  self:RemoveUIListener(EventId.GetTradeShopGoodsInfo, self.OnRefreshInfo)
  self:RemoveUIListener(EventId.UpdateTradeShopGoodsInfo, self.TryRefreshInfo)
  self:RemoveUIListener(EventId.GetTradeDetail, self.OnRefreshDetail)
  self:RemoveUIListener(EventId.BloodyNightActivityRefresh, self.BloodyNightActivityRefresh)
  base.OnRemoveListener(self)
end

function UILWSeasonTradeShopView:DataDefine()
  self.shopType = DataCenter.SeasonTradeShopDataManager:GetShopType()
  self:RefreshData()
end

function UILWSeasonTradeShopView:RefreshData()
  self.cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.tradeId, self.serverId)
  local shopId = self.cityTemplate ~= nil and self.cityTemplate:GetShopId(self.shopType)
  self.list = DataCenter.SeasonTradeShopDataManager:GetItemsByShopId(shopId)
  self.maxTimes = DataCenter.SeasonTradeShopDataManager:GetTradePostShopValue("k1", 0)
  local item = self.list[1]
  if item ~= nil then
    self.resId = item.currency_id
    self.icon:LoadSprite(CommonUtil.GetResOrItemIcon(self.resId))
  end
  self.nextRefreshLimitTime = DataCenter.SeasonTradeShopDataManager.nextRefreshLimitTime
  local level = self.cityTemplate ~= nil and self.cityTemplate.level or 1
  self.desc:SetLocalText("season_s3_activity_1000072_desc25", level)
end

function UILWSeasonTradeShopView:OnRefreshRes()
  if not self.resId then
    return
  end
  local num = CommonUtil.GetResOrItemCount(self.resId)
  self.res_text:SetText(string.GetFormattedGoldNum(num))
end

function UILWSeasonTradeShopView:OnRefreshDetail()
  self.tradeData = DataCenter.SeasonTradeShopDataManager.curTrade
  self.discount = 1
  if self.tradeData.allianceId == LuaEntry.Player:GetAllianceUid() then
    self.discount = self.cityTemplate.alliance_discount
  end
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.TradeShopDiscount)
  if 0 < effectValue then
    self.discount = self.discount - effectValue
  end
  self:RefreshInfo()
  self:RefreshSkin()
end

function UILWSeasonTradeShopView:OnRefreshInfo(configId)
  self.nextRefreshLimitTime = DataCenter.SeasonTradeShopDataManager.nextRefreshLimitTime
  self:OnRefreshRes()
  if configId == nil then
    self:RefreshList()
  end
  self:RefreshBuyTime()
end

function UILWSeasonTradeShopView:RefreshInfo()
  local tradeData = self.tradeData
  local haveLord = tradeData ~= nil and not string.IsNullOrEmpty(tradeData.uid)
  self.player_head:SetActive(haveLord)
  self.name_text:SetActive(haveLord)
  if haveLord then
    self.player_head:SetHeadAndFrame(tradeData.uid, tradeData.pic, tradeData.picVer, false, tradeData.headSkinId, tradeData.headSkinET)
    local playerName = UIUtil.FormatServerAllianceName(tradeData.srcServerId or tradeData.serverId, tradeData.abbr, tradeData.name, tradeData.uid)
    self.name_text:SetText(playerName)
    local percent = math.modf((self.cityTemplate ~= nil and self.cityTemplate.tax_rate or 0) * 100)
    self.tip_text:SetLocalText("season_s3_activity_1000072_desc28", percent, playerName)
  else
    self.tip_text:SetLocalText("season_s3_activity_1000072_desc48")
  end
  if self:RefreshShopTime() then
    self.shop_time_root:SetActive(true)
  else
    self.shop_time_root:SetActive(false)
  end
end

function UILWSeasonTradeShopView:RefreshSkin()
  DataCenter.SeasonTradeDataManager:ChangeSkin(self.skinMgr, true)
  if SeasonUtil.IsInSeasonDarknessMode() then
    if not self.infoRequest then
      self.infoRequest = CS.GameEntry.Resource:InstantiateAsync(WeatherObjectInfo.BloodyMoon.path)
      self.infoRequest:completed("+", function()
        if self.infoRequest.isError or self.infoRequest.gameObject == nil then
          self.infoRequest = nil
          return
        end
        local obj = self.infoRequest.gameObject
        local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
        rectTransform:SetParent(self.info_root.transform)
        rectTransform:Set_localScale(1, 1, 1)
        rectTransform:Set_anchoredPosition(0, 0, 0)
        self.InfoScript = self.info_root:AddComponent(require("UI.UIBloodyNight.UIBloodyMoon"), obj.name)
        self.InfoScript:Refresh()
      end)
    elseif self.InfoScript then
      self.InfoScript:Refresh()
    end
  elseif self.infoRequest then
    self.infoRequest:Destroy()
    self.infoRequest = nil
    self.InfoScript = nil
  end
end

function UILWSeasonTradeShopView:ClearItems()
  self.scroll_content:RemoveComponents(UILWSeasonTradeShopItem)
  if self.items then
    for k, v in pairs(self.items) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UILWSeasonTradeShopView:RefreshList()
  self:ClearItems()
  self.items = {}
  local index = 0
  local parent = self.scroll_content.transform
  for i, data in ipairs(self.list) do
    self.items[i] = self:GameObjectInstantiateAsync("Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/UILWSeasonTradeShopItem.prefab", function(request)
      index = index + 1
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(parent)
      go.transform:Set_localScale(1, 1, 1)
      go.name = tostring(index)
      local cell = self.scroll_content:AddComponent(UILWSeasonTradeShopItem, go.name)
      local lordUid = self.tradeData ~= nil and self.tradeData.uid or nil
      local allianceId = self.tradeData ~= nil and self.tradeData.allianceId or nil
      cell:ReInit(self.list[index], self.discount, lordUid, allianceId)
    end)
  end
end

function UILWSeasonTradeShopView:OnClickItem(template, itemCost)
  local exNum, selfBuyNum = DataCenter.SeasonTradeShopDataManager:GetShopGoodsExchangeNum(template.id)
  local daily_limit = 1
  if selfBuyNum >= daily_limit then
    UIUtil.ShowTipsId("season_alliance_trade_list_8")
    return
  end
  if exNum < 0 then
    UIUtil.ShowTipsId("season_s3_activity_1000072_desc52")
    return
  end
  local itemLimit = template.cycle_times - exNum
  if itemLimit <= 0 then
    UIUtil.ShowTipsId("season_s3_activity_1000072_desc51")
    return
  end
  local buyNumber = DataCenter.SeasonTradeShopDataManager.buyNumber or 0
  local myLimit = self.maxTimes - buyNumber
  if myLimit <= 0 then
    UIUtil.ShowTipsId("season_s3_activity_1000072_desc50")
    return
  end
  if template.level_low > DataCenter.BuildManager:GetMainLevel() then
    UIUtil.ShowTipsId("120986" .. template.level_low)
    return
  end
  local tradeData = self.tradeData
  local lordUid = tradeData ~= nil and tradeData.uid or nil
  if lordUid == nil then
    UIUtil.ShowTipsId("season_s3_activity_1000072_desc47")
    return
  end
  if template.exclusive_flag and lordUid ~= LuaEntry.Player:GetUid() then
    UIUtil.ShowTipsId("season_s3_activity_1000072_desc49")
    return
  end
  local localWeek = CommonUtil.PlayerPrefsGetInt("BUY_TRADE_SHOP_ITEM", 0)
  local week = UITimeManager:GetInstance():GetWeekOfYear(UITimeManager:GetInstance():GetServerTime()) + 1
  if localWeek == 0 or week ~= localWeek then
    self.ignoreTip = true
    local tip
    if self.shopType == TradeShopType.NIGHT then
      tip = Localization:GetString("season_s4_activity_1200012_desc02", itemCost, template.itemName)
    else
      tip = Localization:GetString("season_s3_trade_tips13", template.itemName, itemCost)
    end
    UIUtil.ShowSecondMessageByParam({
      tipText = tip,
      btnNum = 1,
      showToggle = true,
      text1 = GameDialogDefine.CONFIRM,
      sureAction = function()
        if not self.ignoreTip then
          CommonUtil.PlayerPrefsSetInt("BUY_TRADE_SHOP_ITEM", week)
        end
        DataCenter.SeasonTradeShopDataManager:ReqTradeShopGoodsExchange(tradeData.tradeId, template.id, 1, self.serverId, self.shopType)
      end,
      toggleAction = function(flag)
        self.ignoreTip = flag
      end,
      toggleText = Localization:GetString("season_s3_trade_tips14")
    })
  else
    DataCenter.SeasonTradeShopDataManager:ReqTradeShopGoodsExchange(tradeData.tradeId, template.id, 1, self.serverId, self.shopType)
  end
end

function UILWSeasonTradeShopView:RefreshShopTime()
  local tradeData = self.tradeData
  if tradeData == nil then
    return false
  end
  local endTime = self.tradeData.battleStartTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = endTime - curTime
  remainTime = 0 < remainTime and remainTime or 0
  if remainTime <= 0 then
    return false
  end
  self.shop_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  return true
end

function UILWSeasonTradeShopView:RefreshBuyTime()
  local buyNumber = DataCenter.SeasonTradeShopDataManager.buyNumber
  local buyRefreshTime = self.nextRefreshLimitTime
  if buyNumber == nil or buyRefreshTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = buyRefreshTime - curTime
  remainTime = 0 < remainTime and remainTime or 0
  local leftTimes = self.maxTimes - buyNumber
  leftTimes = leftTimes < 0 and 0 or leftTimes
  local str
  if leftTimes == 0 then
    str = Localization:GetString("season_s3_activity_1000072_desc50")
  else
    str = Localization:GetString("season_alliance_trade_list_9", leftTimes .. "/" .. self.maxTimes)
  end
  self.buy_times_text:SetText(str .. "\n" .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  if remainTime == 0 then
  end
end

function UILWSeasonTradeShopView:Update1000MS()
  self:RefreshShopTime()
  self:RefreshBuyTime()
end

function UILWSeasonTradeShopView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  local newTradeId, newServerId = self:GetUserData()
  newServerId = newServerId or LuaEntry.Player:GetCurServerId()
  if newTradeId == self.tradeId and newServerId == self.serverId then
    return
  end
  self.tradeId = newTradeId
  self.serverId = newServerId
  self.tradeData = nil
  DataCenter.SeasonTradeShopDataManager:CleanShopInfo()
  self.shopType = DataCenter.SeasonTradeShopDataManager:GetShopType()
  self:RefreshData()
  self:TryUpdateTradeData(true)
  self:TryReqShopGoodsInfo(true)
end

function UILWSeasonTradeShopView:TryRefreshInfo()
  self.shopType = DataCenter.SeasonTradeShopDataManager:GetShopType()
  self:RefreshData()
  self:TryUpdateTradeData()
  self:TryReqShopGoodsInfo()
end

function UILWSeasonTradeShopView:BloodyNightActivityRefresh(serverId)
  if serverId ~= self.serverId then
    return
  end
  self.shopType = DataCenter.SeasonTradeShopDataManager:GetShopType()
  self:RefreshData()
  self:TryUpdateTradeData(true)
  self:TryReqShopGoodsInfo(true)
end

function UILWSeasonTradeShopView:TryReqShopGoodsInfo(force)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if force or self.last_req_time == nil or curTime - self.last_req_time >= 3000 then
    DataCenter.SeasonTradeShopDataManager:ReqTradeShopGoodsInfo(self.tradeId, self.serverId, self.shopType)
    self.last_req_time = curTime
  end
end

function UILWSeasonTradeShopView:TryUpdateTradeData(force)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if force or self.last_update_time == nil or curTime - self.last_update_time >= 3000 then
    DataCenter.SeasonTradeShopDataManager:ReqTradeDetail(self.tradeId, self.serverId)
    self.last_update_time = curTime
  end
end

function UILWSeasonTradeShopView:OnClickRes()
  if self.resId and self.resId ~= ResourceType.Gold then
    LWResourceLackUtil:GotoGoodsItemLack(self.resId, 1)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
  end
end

return UILWSeasonTradeShopView
