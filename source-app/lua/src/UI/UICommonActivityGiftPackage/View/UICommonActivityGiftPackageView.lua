local base = UIBaseView
local UICommonActivityGiftPackageView = BaseClass("UICommonActivityGiftPackageView", base)
local Localization = CS.GameEntry.Localization
local UICommonActivityGiftPackageItem = require("UI/UICommonActivityGiftPackage/Component/UICommonActivityGiftPackageItem")
local ActShopHalloweenItemComponent = require("UI/UICommonActivityGiftPackage/Component/ActShopHalloweenItemComponent")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local UICommonActivityGiftPackageTitleItem = require("UI/UICommonActivityGiftPackage/Component/UICommonActivityGiftPackageTitleItem")
local title_txt_path = "Root/TopBar/TextTitle"
local back_btn_path = "Root/BottomBar/BtnBack"
local item_bar_path = "Root/TopBar/ItemBar"
local item_bar2_path = "Root/TopBar/ItemBar2"
local diamond_bar_path = "Root/TopBar/DiamondBar"
local pack_list_path = "Root/PackList"
local pack_list_content_path = "Root/PackList/Viewport/Content"
local timeCountDownContainer_path = "Root/TimeCountDownContainer"
local timeCountDownTipsText_path = "Root/TimeCountDownContainer/HorLayout/TimeCountDownTipsText"
local timeCountDownText_path = "Root/TimeCountDownContainer/HorLayout/TimeCountDownText"
local emptyText_path = "Root/EmptyText"
UICommonActivityGiftPackageView.GiftPackageType = {
  Pay = 0,
  Free = 1,
  Gold = 2
}
UICommonActivityGiftPackageView.ItemContentType = {
  Gift = 1,
  Halloween = 2,
  Title = 3,
  GiftInAct = 4
}

function UICommonActivityGiftPackageView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  if self.param == nil then
    return
  end
  local resDataList = {}
  if self.param.topResBarResTypeList ~= nil then
    for i, v in pairs(self.param.topResBarResTypeList) do
      table.insert(resDataList, {data = v, dataType = "resource"})
    end
  end
  if self.param.topResBarItemIdList ~= nil then
    for i, v in pairs(self.param.topResBarItemIdList) do
      table.insert(resDataList, {data = v, dataType = "goods"})
    end
  end
  for i, v in pairs(self.itemBarList) do
    v:SetActive(resDataList[i] ~= nil)
    if resDataList[i] ~= nil then
      if resDataList[i].dataType == "resource" then
        v:SetData(nil, resDataList[i].data, nil)
      end
      if resDataList[i].dataType == "goods" then
        v:SetData(resDataList[i].data, nil, nil)
      end
    end
  end
  if self.param.title ~= nil then
    self.title_txt:SetText(self.param.title)
  else
    self.title_txt:SetText("")
  end
  if self.param.nextRefreshTime then
    self.timeCountDownContainer:SetActive(true)
    self:Update1000MS()
    self.pack_list:SetOffsetMaxXY(0, -160)
  else
    self.pack_list:SetOffsetMaxXY(0, -111.9)
  end
  self:Refresh()
end

function UICommonActivityGiftPackageView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonActivityGiftPackageView:Update1000MS()
  if self.param and self.param.nextRefreshTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.param.nextRefreshTime * 1000 - curTime, 0
    self.timeCountDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(leftTime, 0)))
    if leftTime < 0 and self.param.refreshTimeDuration ~= nil and 0 < self.param.refreshTimeDuration then
      self.param.nextRefreshTime = self.param.nextRefreshTime + self.param.refreshTimeDuration
      self:Refresh()
    end
  end
end

function UICommonActivityGiftPackageView:RefreshData()
  self.packDataList = {}
  if self.param and self.param.extension and self.param.extension.halloweenJumpDataList ~= nil then
    for i, v in ipairs(self.param.extension.halloweenJumpDataList) do
      v.itemContentType = self.ItemContentType.Halloween
      table.insert(self.packDataList, v)
    end
  end
  if self.param and not table.IsNullOrEmpty(self.param.freeGiftPackageDataList) then
    for i, v in pairs(self.param.freeGiftPackageDataList) do
      local freePackData = {}
      freePackData.itemContentType = self.ItemContentType.Gift
      freePackData.giftPackageType = self.GiftPackageType.Free
      freePackData.activityId = self.param.activityId
      freePackData.realData = {}
      freePackData.realData.index = i
      freePackData.realData.clickBuyFunc = v.clickBuyFunc
      freePackData.realData.canBuyFunc = v.canBuyFunc
      freePackData.realData.icon = v.icon
      freePackData.realData.background = v.background
      freePackData.realData.rewards = v.rewards
      freePackData.realData.title = v.title
      freePackData.realData.userData = v.userData
      table.insert(self.packDataList, freePackData)
    end
  end
  if self.param and not table.IsNullOrEmpty(self.param.goldGiftPackageDataList) then
    for i, v in pairs(self.param.goldGiftPackageDataList) do
      local goldPackData = {}
      goldPackData.itemContentType = self.ItemContentType.Gift
      goldPackData.giftPackageType = self.GiftPackageType.Gold
      goldPackData.activityId = self.param.activityId
      goldPackData.realData = {}
      goldPackData.realData.index = i
      goldPackData.realData.clickBuyFunc = v.clickBuyFunc
      goldPackData.realData.canBuyFunc = v.canBuyFunc
      goldPackData.realData.icon = v.icon
      goldPackData.realData.quality = v.quality
      goldPackData.realData.costGoldNum = v.costGoldNum
      goldPackData.realData.background = v.background
      goldPackData.realData.rewards = v.rewards
      goldPackData.realData.title = v.title
      goldPackData.realData.userData = v.userData
      table.insert(self.packDataList, goldPackData)
    end
  end
  if self.param and self.param.exchangeGroupId ~= nil then
    local giftPack = GiftPackManager.GetPacksByGroupId(self.param.exchangeGroupId, false)
    for i, v in pairs(giftPack) do
      local giftPackData = {}
      giftPackData.itemContentType = self.ItemContentType.Gift
      giftPackData.activityId = self.param.activityId
      giftPackData.giftPackageType = self.GiftPackageType.Pay
      giftPackData.exchangeGiftPackageIcon = self.param.exchangeGiftPackageIcon
      giftPackData.realData = v
      giftPackData.realData.index = i
      giftPackData.clickBuyFreeFunc = self.param.clickBuyFreeFunc
      giftPackData.clickBuyGoldFunc = self.param.clickBuyGoldFunc
      table.insert(self.packDataList, giftPackData)
    end
  end
  if self.param and self.param.exchangeGroupIdByAct ~= nil and self.param.exchangeGroupIdByAct > 0 then
    local giftPack = GiftPackManager.GetPacksByGroupId(self.param.exchangeGroupIdByAct, true)
    if giftPack and 0 < #giftPack then
      local titleData = {}
      titleData.itemContentType = self.ItemContentType.Title
      titleData.title = "package_tips_event_refresh_01"
      table.insert(self.packDataList, titleData)
      for i, v in pairs(giftPack) do
        local giftPackData = {}
        giftPackData.itemContentType = self.ItemContentType.GiftInAct
        giftPackData.activityId = self.param.activityId
        giftPackData.giftPackageType = self.GiftPackageType.Pay
        giftPackData.exchangeGiftPackageIcon = self.param.exchangeGiftPackageIcon
        giftPackData.realData = v
        giftPackData.realData.index = i
        giftPackData.clickBuyFreeFunc = self.param.clickBuyFreeFunc
        giftPackData.clickBuyGoldFunc = self.param.clickBuyGoldFunc
        table.insert(self.packDataList, giftPackData)
      end
    end
  end
end

function UICommonActivityGiftPackageView:Refresh()
  self:RefreshData()
  if self.packDataList == nil or #self.packDataList == 0 then
    if self.param and self.param.emptyText then
      self.emptyText:SetText(self.param.emptyText)
    else
      self.emptyText:SetLocalText("commongift_buy_alert1")
    end
    self.emptyText:SetActive(true)
    self.pack_list:SetActive(false)
  else
    self.emptyText:SetActive(false)
    self.pack_list:SetActive(true)
    self.pack_list:SetListItemCount(#self.packDataList, false, false)
    self.pack_list:RefreshAllShownItem()
  end
end

function UICommonActivityGiftPackageView:RefreshGold()
  if self.diamond_bar then
    self.diamond_bar:RefreshData()
  end
end

function UICommonActivityGiftPackageView:RefreshGoods()
  for i = 1, #self.itemBarList do
    self.itemBarList[i]:RefreshData()
  end
end

function UICommonActivityGiftPackageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:AddUIListener(EventId.CommonActivityGiftPackageViewRefresh, self.Refresh)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
  self:AddUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UICommonActivityGiftPackageView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:RemoveUIListener(EventId.CommonActivityGiftPackageViewRefresh, self.Refresh)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UICommonActivityGiftPackageView:ClearScroll()
  self.pack_list_content:RemoveComponents(UICommonActivityGiftPackageItem)
  self.pack_list_content:RemoveComponents(ActShopHalloweenItemComponent)
  self.pack_list_content:RemoveComponents(UICommonActivityGiftPackageTitleItem)
  self.pack_list:ClearAllItems()
end

function UICommonActivityGiftPackageView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if table.IsNullOrEmpty(self.packDataList) then
    return nil
  end
  if index < 1 or index > #self.packDataList then
    return nil
  end
  local packData = self.packDataList[index]
  local itemPrefabName = self:GetItemPrefabName(packData)
  local itemScriptComponent = self:GetItemScriptComponent(packData)
  local item = loopScroll:NewListViewItem(itemPrefabName)
  local script = self.pack_list_content:GetComponent(item.gameObject.name, itemScriptComponent)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.pack_list_content:AddComponent(itemScriptComponent, objectName)
  end
  script:SetActive(true)
  script:SetData(packData)
  return item
end

function UICommonActivityGiftPackageView:GetItemPrefabName(data)
  if data then
    if data.itemContentType == self.ItemContentType.Halloween then
      return "ActShopNewYearItem"
    end
    if data.itemContentType == self.ItemContentType.Title then
      return "PackTitleItem"
    end
  end
  return "PackItem"
end

function UICommonActivityGiftPackageView:GetItemScriptComponent(data)
  if data then
    if data.itemContentType == self.ItemContentType.Halloween then
      return ActShopHalloweenItemComponent
    end
    if data.itemContentType == self.ItemContentType.Title then
      return UICommonActivityGiftPackageTitleItem
    end
  end
  return UICommonActivityGiftPackageItem
end

function UICommonActivityGiftPackageView:ComponentDefine()
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.pack_list = self:AddComponent(UILoopListView2, pack_list_path)
  self.pack_list:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
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
  self.emptyText = self:AddComponent(UIText, emptyText_path)
  self.timeCountDownContainer:SetActive(false)
  self.item_bar:SetShowAddBtn(false)
  self.item_bar2:SetShowAddBtn(false)
  self.diamond_bar:SetShowAddBtn(false)
end

function UICommonActivityGiftPackageView:ComponentDestroy()
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
  self.emptyText = nil
end

function UICommonActivityGiftPackageView:DataDestroy()
  self.param = nil
end

function UICommonActivityGiftPackageView:DataDefine()
  self.param = nil
end

function UICommonActivityGiftPackageView:OnPassDay()
  if self.actId then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
    if not actData or not actData:IsValid() then
      self.ctrl:CloseSelf()
      return
    end
  end
end

return UICommonActivityGiftPackageView
