local LWUIGoodsLackView = BaseClass("LWUIGoodsLackView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local titlePath = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local content_path = "Root/Scroll/Viewport/Content"
local item_name_path = "Root/ResourceInfo/ResourceTitle"
local item_hold_count = "Root/ResourceInfo/ResourceHoldCount"
local item_icon_path = "Root/ResourceInfo/UICommonResItem"
local black_mask_path = "UICommonPopUpTitle/panel"
local bg_path = "UICommonPopUpTitle/Common_bg_orange"
local noway_text_path = "Root/NoWayText"
local empty_text_path = "Root/EmptyText"
local gift_package_item_path = "Root/GiftPackageItem"

function LWUIGoodsLackView:OnCreate()
  base.OnCreate(self)
  self.data = self:GetUserData()
  self.data.id = tonumber(self.data.id)
  if CS.CommonUtils.IsDebug() and self.data then
    Logger.LogCustom(string.format("\231\188\186\229\176\145\239\188\154Type=%s,Id= %s,Num=%s", self.data.type, self.data.id, self.data.need))
  end
  self.masteryExpItem = self.data.id == LuaEntry.DataConfig:TryGetNum("lw_season_mastery", "k3")
  self.hasInitWindow = false
  self:ComponentDefine()
  self:ReInit()
end

function LWUIGoodsLackView:OnDestroy()
  DataCenter.ArrowManager:RemoveArrow()
  self:ClearList()
  self:ComponentDestroy()
  base.OnDestroy(self)
  if self.data and self.data.closeCallback then
    self.data.closeCallback()
  end
end

function LWUIGoodsLackView:ComponentDefine()
  self.title = self:AddComponent(UIText, titlePath)
  self.title:SetText(Localization:GetString("450012"))
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, black_mask_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.completeBtn = self:AddComponent(UIButton, "completeBtn")
  self.btnText = self:AddComponent(UIText, "completeBtn/Text")
  self.completeBtn:SetOnClick(function()
    self:OnCompleteBtnClick()
  end)
  self.itemName = self:AddComponent(UIText, item_name_path)
  self.itemHoldCount = self:AddComponent(UIText, item_hold_count)
  self.icon = self:AddComponent(UICommonResItem, item_icon_path)
  self.resBar = self:AddComponent(UISlider, "Root/ResourceInfo/ResourceBar")
  self.resBarText = self:AddComponent(UIText, "Root/ResourceInfo/ResourceBarText")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.emptyText = self:AddComponent(UIText, empty_text_path)
  self.emptyText:SetActive(false)
  self.nowayText = self:AddComponent(UIText, noway_text_path)
  self.nowayText:SetLocalText(2000497)
  self.gift_package_item = self:AddComponent(LWResourceLackCell, gift_package_item_path)
  self.gift_package_item:SetActive(false)
end

function LWUIGoodsLackView:GetIsShowCompleteBtn()
  if self.data.id == ResourceItemId.EquipStrengtheningStone or self.data.id == ResourceItemId.HeroExp then
    return true
  end
  return false
end

function LWUIGoodsLackView:GetIsFull()
  local have = 0
  if self.data then
    have = DataCenter.ResourceItemDataManager:GetCountByItemId(self.data.id)
    return have >= self.data.need
  end
end

function LWUIGoodsLackView:ComponentDestroy()
  self:ClearList()
  self.completeBtn = nil
  self.resBar = nil
  self.resBarText = nil
  self.btnText = nil
  self.content = nil
  self.hangUpValue = nil
  self.nowayText = nil
  self.emptyText = nil
  self.gift_package_item = nil
  self.bg = nil
  self.hasInitWindow = nil
end

function LWUIGoodsLackView:OnEnable()
  base.OnEnable(self)
  if self.hasInitWindow then
    self:ReInit()
  else
    self.hasInitWindow = true
  end
end

function LWUIGoodsLackView:OnDisable()
  base.OnDisable(self)
end

function LWUIGoodsLackView:OnResOrItemUpdate()
  self:RefreshNeed()
  for k, v in pairs(self.cells) do
    if v.data.tips == LWResourceLackGetWay.UseItem then
      local items = DataCenter.ItemData:GetItemById(v.data.para1)
      local itemCount = items and items.count or 0
      if 0 < itemCount then
        v:RefreshMultUseBtn()
      end
    elseif v.data.tips == LWResourceLackGetWay.MultiUseItem then
      v:RefreshSelf()
    end
  end
end

function LWUIGoodsLackView:OnProductLineCollect()
  for k, v in pairs(self.cells) do
    if v.data.tips == LWResourceLackGetWay.CityCollection then
      v:RefreshCollectionCount()
    end
  end
end

function LWUIGoodsLackView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.ProductLineCollect, self.OnProductLineCollect)
  self:AddUIListener(EventId.OnGetQueryHangUpRewardResult, self.OnGetQueryResult)
  self:AddUIListener(EventId.UpdateGiftPackData, self.ReInit)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.UpdateOneCommonShopGoods, self.ReInit)
  self:AddUIListener(EventId.RefreshItems, self.OnItemDataUpdate)
  self:AddUIListener(EventId.FirstRechargeExpBigRewardReceived, self.OnFirstRechargeExpBigRewardReceived)
  self:AddUIListener(EventId.RefreshLackViewList, self.RefreshContent)
end

function LWUIGoodsLackView:OnRemoveListener()
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.ProductLineCollect, self.OnProductLineCollect)
  self:RemoveUIListener(EventId.OnGetQueryHangUpRewardResult, self.OnGetQueryResult)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.ReInit)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.UpdateOneCommonShopGoods, self.ReInit)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemDataUpdate)
  self:RemoveUIListener(EventId.FirstRechargeExpBigRewardReceived, self.OnFirstRechargeExpBigRewardReceived)
  self:RemoveUIListener(EventId.RefreshLackViewList, self.RefreshContent)
  base.OnRemoveListener(self)
end

function LWUIGoodsLackView:ReInit()
  self:RefreshBar()
  self:RefreshContent()
  self.btnText:SetLocalText(130256)
  local isShow = self:GetIsShowCompleteBtn()
  self.resBar:SetActive(isShow)
  self.resBarText:SetActive(isShow)
  self.itemHoldCount:SetActive(not isShow)
end

function LWUIGoodsLackView:RefreshBar()
  local iconData = {}
  if self.data.type == ResLackContextType.Good then
    iconData.rewardType = RewardType.GOODS
    iconData.itemId = self.data.id
    local have = DataCenter.ItemData:GetItemCount(self.data.id)
    self.itemHoldCount:SetText(Localization:GetString("450019", have))
  else
    self.itemHoldCount:SetText("")
    if self.data.type == ResLackContextType.ResItem then
      iconData.rewardType = RewardType.RESOURCE_ITEM
      iconData.itemId = self.data.id
      if self.data.id == DataCenter.TacticalCardDataManager:GetTcCardExpItemId() then
        self.itemHoldCount:SetLocalText("resource_item_14501_desc")
      end
    end
  end
  local name = DataCenter.RewardManager:GetNameByType(tonumber(iconData.rewardType), tonumber(iconData.itemId))
  self.icon:ReInit(iconData)
  self.itemName:SetText(name)
  local shouldAutoExitWhenComplete = self.data.autoExitWhenComplete == nil or self.data.autoExitWhenComplete == true
  if not shouldAutoExitWhenComplete and self:GetIsShowCompleteBtn() and self:GetIsFull() then
    CS.UIGray.SetGray(self.completeBtn.transform, true, false)
  else
    CS.UIGray.SetGray(self.completeBtn.transform, false, true)
  end
end

function LWUIGoodsLackView:RefreshNeed()
  local have = DataCenter.ResourceItemDataManager:GetCountByItemId(self.data.id)
  if have and self:GetIsShowCompleteBtn() and self.resBar and self.resBarText then
    self.resBar:SetValue(have / self.data.need)
    self.resBarText:SetText(string.GetFormattedSeperatorNum(have) .. "/" .. string.GetFormattedSeperatorNum(self.data.need))
  end
  local shouldAutoExitWhenComplete = self.data.autoExitWhenComplete == nil or self.data.autoExitWhenComplete == true
  if not self.masteryExpItem and shouldAutoExitWhenComplete and self.data.need - have <= 0 and self.ctrl then
    local ctrl = self.ctrl
    TimerManager:GetInstance():DelayFrameInvoke(function()
      if ctrl then
        ctrl:CloseSelf()
      end
    end, 1)
  end
end

function LWUIGoodsLackView:GetType59ItemIdMap()
  local type59ItemIdMap = {}
  local type59ItemTemplates = DataCenter.ItemData:GetItemTemplatesByType(GOODS_TYPE.GOODS_TYPE_59)
  if type59ItemTemplates and 0 < #type59ItemTemplates then
    for _, itemTemplate in ipairs(type59ItemTemplates) do
      if itemTemplate:IsType59ItemContain(tostring(self.data.id)) and itemTemplate.para5 ~= "1" then
        type59ItemIdMap[itemTemplate.id] = itemTemplate
      end
    end
  end
  return type59ItemIdMap
end

function LWUIGoodsLackView:RemoveDuplicateType59Templates(tempDataList, type59ItemIdMap)
  if table.IsNullOrEmpty(tempDataList) or next(type59ItemIdMap) == nil then
    return
  end
  for i = #tempDataList, 1, -1 do
    local template = tempDataList[i]
    if not string.IsNullOrEmpty(template.para1) then
      local para1List = string.split(template.para1, "|")
      if #para1List == 1 then
        local para1Id = para1List[1]
        if type59ItemIdMap[para1Id] then
          table.remove(tempDataList, i)
        end
      end
    end
  end
end

function LWUIGoodsLackView:GetType59FakeDataList(type59ItemIdMap)
  local type59FakeDataList = {}
  for itemId, itemTemplate in pairs(type59ItemIdMap) do
    local param = {}
    param.goods = self.data.id
    param.itemId = itemId
    param.itemOrder = tonumber(itemTemplate.para2) or 0
    local fakeLackData = DataCenter.LWResourceLackManager:GetType59FakeLackData(param)
    table.insert(type59FakeDataList, fakeLackData)
  end
  table.sort(type59FakeDataList, function(a, b)
    return a.itemOrder > b.itemOrder
  end)
  return type59FakeDataList
end

function LWUIGoodsLackView:RefreshContent()
  self:ClearList()
  local templates
  local type59ItemIdMap = self:GetType59ItemIdMap()
  if self.data.type == ResLackContextType.Good then
    templates = DataCenter.LWResourceLackManager:GetGoodsWay(self.data.id)
    if self.data.id >= 870001 and self.data.id <= 870007 then
      self.title:SetLocalText("Treasure_map_50")
    end
  elseif self.data.type == ResLackContextType.ResItem then
    templates = DataCenter.LWResourceLackManager:GetResourceItemWay(self.data.id)
    if self.data.id >= 3005 and self.data.id <= 3014 then
      self.title:SetLocalText("battle_tip_soldiers")
    end
  end
  local need = self.data.need
  self:RefreshNeed()
  local tempDataList = {}
  if not table.IsNullOrEmpty(templates) then
    local param = {}
    param.skipFilterTypeList = {}
    table.merge(param.skipFilterTypeList, LWResourceLackShow_SoldOutTypes)
    table.merge(param.skipFilterTypeList, LWResourceLackShow_NotOpenTypes)
    tempDataList = LWResourceLackUtil:FilterResourceTemplates(templates, need, param, self.data.id) or {}
  end
  table.sort(tempDataList, function(a, b)
    return a.order < b.order
  end)
  local isShowGiftCard = false
  if table.count(tempDataList) > 0 then
    local giftPackageData = tempDataList[1]
    if giftPackageData.tips == LWResourceLackGetWay.GiftPackage or giftPackageData.tips == LWResourceLackGetWay.GiftPackageList then
      isShowGiftCard = true
    end
  end
  self:RemoveDuplicateType59Templates(tempDataList, type59ItemIdMap)
  if next(type59ItemIdMap) ~= nil then
    local type59FakeDataList = self:GetType59FakeDataList(type59ItemIdMap)
    for i = 1, #type59FakeDataList do
      local fakeData = type59FakeDataList[i]
      if isShowGiftCard then
        table.insert(tempDataList, 2, fakeData)
      else
        table.insert(tempDataList, 1, fakeData)
      end
    end
  end
  self.gift_package_item:SetActive(false)
  if not tempDataList or #tempDataList == 0 then
    self.nowayText:SetActive(true)
    self.completeBtn:SetActive(false)
    return
  else
    self.nowayText:SetActive(false)
  end
  if table.IsNullOrEmpty(tempDataList) then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.id)
    if itemTemplate and (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98) then
      self.emptyText:SetLocalText(458844)
      self.emptyText:SetActive(true)
    else
      self.nowayText:SetActive(true)
    end
  else
    self.nowayText:SetActive(false)
  end
  local isShowBtn = self:GetIsShowCompleteBtn()
  self.completeBtn:SetActive(isShowBtn)
  if table.count(tempDataList) > 0 then
    local giftPackageData = tempDataList[1]
    if giftPackageData.tips == LWResourceLackGetWay.GiftPackage or giftPackageData.tips == LWResourceLackGetWay.GiftPackageList then
      local openLv = LuaEntry.DataConfig:TryGetNum("guide_opt", "k11")
      local mainLv = DataCenter.BuildManager.MainLv
      local giftPackUnlock = openLv <= mainLv
      if giftPackUnlock then
        self.gift_package_item:SetActive(true)
        self.gift_package_item:Refresh(true, giftPackageData, self.ctrl, self.selectResourceData)
      end
      self.dataList = {}
      if table.count(tempDataList) > 1 then
        for k = 2, table.count(tempDataList) do
          table.insert(self.dataList, tempDataList[k])
        end
      end
      self.bg:SetSizeDeltaXY(self.bg:GetSizeDelta().x, isShowBtn and 1250 or 1140)
    else
      self.dataList = {}
      for k, v in ipairs(tempDataList) do
        table.insert(self.dataList, v)
      end
      self.bg:SetSizeDeltaXY(self.bg:GetSizeDelta().x, isShowBtn and 1250 or 1070)
    end
  end
  self:CheckSelfDataListIsShow()
  LWResourceLackUtil:SortShowDataList(self.dataList)
  for k, v in pairs(self.dataList) do
    self.cellReqs[k] = self:GameObjectInstantiateAsync(UIAssets.LWLackResourceItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = UIUtil.GetLoopListItemIndex("LWLackResourceItem")
      self.cells[k] = self.content:AddComponent(LWResourceLackCell, go.name)
      self.cells[k]:SetIsShowSpendLessFeature(true)
      self.cells[k]:Refresh(false, v, self.ctrl, self.data)
      if v.tips == LWResourceLackGetWay.HangUp then
        SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0)
      end
    end)
  end
end

function LWUIGoodsLackView:OnItemDataUpdate()
  self:RefreshBar()
  self:OnResOrItemUpdate()
end

function LWUIGoodsLackView:OnFirstRechargeExpBigRewardReceived()
  self:ReInit()
end

function LWUIGoodsLackView:UseItemSuccessHandle()
  if not self.dataList then
    return
  end
  local waitDel = {}
  for k, v in pairs(self.dataList) do
    if v.tips == LWResourceLackGetWay.UseItem then
      local items = DataCenter.ItemData:GetItemById(v.para1)
      local itemCount = items and items.count or 0
      if itemCount == 0 then
        waitDel[k] = v
      else
        local cell = self.cells[k]
        if cell then
          cell.title2:SetText(Localization:GetString(v.des, itemCount))
          cell:RefreshMultUseBtn()
        end
      end
    elseif v.tips == LWResourceLackGetWay.MultiUseItem then
      local itemId = LWResourceLackUtil:GetShowItemIdFromMultiUseItemGetWay(v)
      if itemId == nil then
        waitDel[k] = v
      end
    end
  end
  for k, v in pairs(waitDel) do
    local cell = self.cells[k]
    if cell then
      self.content:RemoveComponent(cell.gameObject.name, LWResourceLackCell)
    end
    local req = self.cellReqs[k]
    if req then
      self:GameObjectDestroy(req)
      self.cellReqs[k] = nil
    end
    self.cells[k] = nil
  end
  for k, v in pairs(self.cells) do
    v:RefreshLightBg(self:IsFirst(k))
  end
  if table.IsNullOrEmpty(self.dataList) then
    self.nowayText:SetActive(true)
  else
    self.nowayText:SetActive(false)
  end
end

function LWUIGoodsLackView:OnGetQueryResult()
  if not self.cells then
    return
  end
  local reward = DataCenter.StageManager.idleReward
  if not reward then
    return
  end
  local value = 0
  local id = self.data.id
  if id == ResourceItemId.HeroExp then
    for _, rewardRow in ipairs(reward) do
      local resType = rewardRow.type
      local val = rewardRow.value
      if resType == RewardType.RESOURCE_ITEM then
        local goodId = val.id
        local goodNum = val.num
        if goodId == tostring(ResourceItemId.HeroExp) then
          value = value + goodNum
        end
      end
    end
  end
  if id == ResourceItemId.EquipStrengtheningStone then
    for _, rewardRow in ipairs(reward) do
      local resType = rewardRow.type
      local val = rewardRow.value
      if resType == RewardType.RESOURCE_ITEM then
        local goodId = val.id
        local goodNum = val.num
        if goodId == tostring(ResourceItemId.EquipStrengtheningStone) then
          value = value + goodNum
        end
      end
    end
  end
  self.hangUpValue = value
  for _, v in pairs(self.cells) do
    if v.data.tips == LWResourceLackGetWay.HangUp then
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
      if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
        v.title2:SetLocalText(450095)
        v.gotoBtnText:SetLocalText(450096)
      else
        v.title2:SetText(Localization:GetString(v.data.des, value))
        v.gotoBtnText:SetText(Localization:GetString(v.data.btn_name))
      end
    end
  end
end

function LWUIGoodsLackView:OnCompleteBtnClick()
  if self.click then
    return
  end
  self.click = true
  self.delayClick = TimerManager:GetInstance():DelayInvoke(function()
    self.click = false
  end, 1)
  local resCount = 0
  local have = DataCenter.ResourceItemDataManager:GetCountByItemId(self.data.id)
  local tempHave = 0
  local deficiencyRes = self.data.need - have
  local goldCfg
  if 0 < deficiencyRes then
    local tempNumber = 0
    local collection = 0
    local itemID = 0
    for i, data in pairs(self.dataList) do
      tempNumber = BuildingUtils.CityCollectionByItemId(tonumber(data.para1), nil, nil, 300) or 0
      if tempNumber and tempNumber ~= 0 then
        itemID = tonumber(data.para1)
      end
      collection = tempNumber + collection
      if data.tips == LWResourceLackGetWay.BuyGiftBag then
        goldCfg = DataCenter.ItemTemplateManager:GetItemTemplate(data.para1)
      end
    end
    if 0 < collection and 0 < itemID then
      DataCenter.LWSoundManager:PlayBubbleEffect(itemID)
      resCount = resCount + 1
    end
    tempHave = tempHave + tempNumber
    deficiencyRes = deficiencyRes - tempHave
    tempHave = 0
    if self.hangUpValue and 0 < self.hangUpValue then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local timeDelta = curTime - DataCenter.StageManager.lastIdleRewardTimeStamp
      local time = timeDelta / 1000 / 60
      if 5 < time then
        tempHave = tempHave + self.hangUpValue
        self.hangUpValue = 0
        SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 1)
        resCount = resCount + 1
      end
    end
  end
  deficiencyRes = deficiencyRes - tempHave
  local goItemList = {}
  if 0 < deficiencyRes then
    local list = DeepCopy(self.dataList)
    goItemList = self:GetSortCountList(list)
    for i = 1, #goItemList do
      goItemList[i].num = 0
      deficiencyRes = self:SetMinItemInfo(deficiencyRes, goItemList, i)
    end
  end
  if 0 < deficiencyRes then
    local index = self:GetHaveMinCountItemIndex(goItemList, deficiencyRes)
    if index then
      deficiencyRes = self:SetMaxItemInfo(deficiencyRes, goItemList, #goItemList)
    end
  end
  for i, info in pairs(goItemList) do
    if info.num and 0 < info.num then
      resCount = resCount + 1
      SFSNetwork.SendMessage(MsgDefines.ItemUse, info)
    end
  end
  if 0 < resCount then
    self:RefreshBar()
    self:RefreshContent()
  elseif table.IsNullOrEmpty(self.dataList) then
    local shop = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SHOP)
    if shop then
      UIUtil.ShowMessage(Localization:GetString("121485"), 1, 110003, 110003, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.Goods)
      end)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_SHOP)
    end
  else
    local hasJumpShop = false
    for i = 1, #self.dataList do
      if self.dataList[i].tips == LWResourceLackGetWay.AllianceShop then
        self:GuideToAllianceShop(self.dataList[i])
        hasJumpShop = true
        break
      elseif self.dataList[i].tips == LWResourceLackGetWay.VIPShop then
        self:GoCommonShop2(self.dataList[i], CommonShopType.Vip)
        hasJumpShop = true
        break
      elseif self.dataList[i].tips == LWResourceLackGetWay.GoCommonShop then
        self:GoCommonShop(self.dataList[i])
        hasJumpShop = true
        break
      elseif self.dataList[i].tips == LWResourceLackGetWay.HonorShopNew then
        self:GoCommonShop2(self.dataList[i], CommonShopType.HonorShop)
        hasJumpShop = true
        break
      end
    end
    if not hasJumpShop then
      UIUtil.ShowTipsId("get_more_goto_none")
    end
  end
end

function LWUIGoodsLackView:GuideToAllianceShop(data)
  if LuaEntry.Player:IsInAlliance() == false then
    UIUtil.ShowTipsId(451015)
  else
    self:GoCommonShop2(data, CommonShopType.AllianceShop)
  end
end

function LWUIGoodsLackView:GoCommonShop(data)
  local paraList = {}
  local paraSplitList = string.split(data.para1, ";")
  for i, v in ipairs(paraSplitList) do
    table.insert(paraList, v)
  end
  for _, para in ipairs(paraList) do
    local splitPara = string.split(para, "|")
    if #splitPara == 2 then
      local shopType = tonumber(splitPara[1])
      local shopId = tonumber(splitPara[2])
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(shopType, shopId)
      local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(shopType, shopId)
      if goodsConf then
        do
          local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
          if not (0 < goodsConf.maxTimes) or not (boughtTimes >= goodsConf.maxTimes) then
            if goodsConf.GetInconsistentConditions then
              local inconsistentConditions = goodsConf:GetInconsistentConditions()
              if not table.IsNullOrEmpty(inconsistentConditions) then
                goto lbl_86
              end
            end
            UIUtil.ShowMessage(Localization:GetString(data.des), 1, 110003, 110003, function()
              UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, shopType, shopId)
            end)
            break
          end
        end
      end
    end
    ::lbl_86::
  end
end

function LWUIGoodsLackView:GoCommonShop2(data, showType)
  local gotoShopId
  local shopIdList = {}
  local paraSplitList = string.split(data.para1, "|")
  for i, v in ipairs(paraSplitList) do
    table.insert(shopIdList, tonumber(v))
  end
  for _, shopId in ipairs(shopIdList) do
    local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(showType, shopId)
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(showType, shopId)
    if goodsConf then
      local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
      if not (0 < goodsConf.maxTimes) or not (boughtTimes >= goodsConf.maxTimes) then
        if goodsConf.GetInconsistentConditions then
          local inconsistentConditions = goodsConf:GetInconsistentConditions()
          if not table.IsNullOrEmpty(inconsistentConditions) then
            goto lbl_64
          end
        end
        gotoShopId = shopId
        break
      end
    end
    ::lbl_64::
  end
  if gotoShopId then
    UIUtil.ShowMessage(Localization:GetString(data.des), 1, 110003, 110003, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, showType, gotoShopId)
    end)
  end
end

function LWUIGoodsLackView:GetHaveMinCountItemIndex(list, deficiencyRes)
  if 0 < deficiencyRes then
    for i = #list, 1, -1 do
      if 0 < list[i].haveNum then
        return i
      end
    end
  end
end

function LWUIGoodsLackView:SetMinItemInfo(deficiencyRes, info, index, isOr)
  local info = info[index]
  info.num = 0
  if 0 < deficiencyRes and (deficiencyRes > info.give or isOr) then
    local num = Mathf.Min(Mathf.Floor(deficiencyRes / info.give), info.haveNum)
    info.num = info.num + (num == 0 and 0 < info.haveNum and 1 or num)
    deficiencyRes = deficiencyRes - info.give * info.num
    info.haveNum = info.haveNum - info.num
  end
  return deficiencyRes
end

function LWUIGoodsLackView:SetMaxItemInfo(deficiencyRes, infos, index)
  local info = infos[index]
  if 0 < deficiencyRes and 0 < index then
    local num = Mathf.Min(Mathf.Ceil(deficiencyRes / info.give), info.haveNum)
    info.num = info.num + (num == 0 and 0 < info.haveNum and 1 or num)
    deficiencyRes = deficiencyRes - info.give * info.num
    info.haveNum = info.haveNum - info.num
  end
  if 0 < deficiencyRes and 0 < index then
    self:SetMaxItemInfo(deficiencyRes, infos, index - 1)
  else
    return deficiencyRes
  end
end

function LWUIGoodsLackView:GetSortCountList(list, deficiencyRes)
  local goItemList = {}
  for i, data in pairs(list) do
    if data.tips == LWResourceLackGetWay.UseItem then
      local items = DataCenter.ItemData:GetItemById(data.para1)
      local itemCount = items and items.count or 0
      local have = 0
      if self.data.type == 2 then
        have = DataCenter.ResourceItemDataManager:GetCountByItemId(self.data.id)
      elseif self.data.type == 1 then
        have = DataCenter.ItemData:GetItemCount(self.data.id)
      else
        have = LuaEntry.Resource:GetCntByResType(self.data.type)
      end
      if 1 <= itemCount then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
        local type = tonumber(goods.type)
        if type == 3 then
          local give = tonumber(items.para2) or 0
          table.insert(goItemList, {
            uuid = items.uuid,
            give = give,
            haveNum = itemCount
          })
        elseif type == GOODS_TYPE.GOODS_TYPE_109 then
          local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(goods.para1), DataCenter.BuildManager.MainLv, tonumber(goods.para2))
          local give = returnItem.count * tonumber(goods.para3)
          table.insert(goItemList, {
            uuid = items.uuid,
            give = give,
            haveNum = itemCount
          })
        end
      end
    end
  end
  table.sort(goItemList, function(a, b)
    if a.give > b.give then
      return true
    end
  end)
  return goItemList
end

function LWUIGoodsLackView:ClearList()
  if self.cellReqs then
    self.content:RemoveComponents(LWResourceLackCell)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

function LWUIGoodsLackView:IsFirst(index)
  for i = 1, index - 1 do
    if self.cells[i] ~= nil then
      return false
    end
  end
  return true
end

function LWUIGoodsLackView:GetFlyTargetPos()
  return self.icon.transform.position
end

function LWUIGoodsLackView:CheckSelfDataListIsShow()
  local moveIndexList = {}
  for k, v in ipairs(self.dataList) do
    if not LWResourceLackShow_CountdownTypes[v.tips] and not LWResourceLackShow_CompletedTypes[v.tips] and not LWResourceLackShow_SoldOutTypes[v.tips] and (not LWResourceLackShow_NotOpenTypes[v.tips] or v.para3 ~= "1") then
      if v.tips == LWResourceLackGetWay.ActivityAndCheckOpen or v.tips == LWResourceLackGetWay.GoToActivityAndDontCloseSelf then
        local isShow = UIUtil.CheckWayTypeOfActivityAndCheckOpenIsOpen(v)
        if not isShow then
          table.insert(moveIndexList, 1, k)
        end
      end
      if v.tips == LWResourceLackGetWay.FirstPayGetExp and not DataCenter.FirstPayManager:IsShowGetExpGetMore() then
        table.insert(moveIndexList, 1, k)
      end
    end
  end
  for k, v in ipairs(moveIndexList) do
    table.remove(self.dataList, v)
  end
end

return LWUIGoodsLackView
