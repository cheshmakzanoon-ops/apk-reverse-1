local LWUIResourceLackView = BaseClass("LWUIResourceLackView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local LWMaxAdListItemView = require("UI.LWUIMaxAd.Component.LWMaxAdListItemView")
local titlePath = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local expand_content = "UICommonPopUpTitle/Common_bg_orange"
local resTitle_path = "Root/ResourceInfo/ResourceTitle"
local resBar_path = "Root/ResourceInfo/ResourceBar"
local resBarText_path = "Root/ResourceInfo/ResourceBarText"
local resIcon_path = "Root/ResourceInfo/ResourceBarIcon"
local content_path = "Root/Scroll/Viewport/Content"
local tab_path = "Root/TabLayout/Tab%d"
local tab_root_path = "Root/TabLayout"
local tab_btn_path = "Btn"
local tab_select_path = "Select"
local tab_unselect_path = "UnSelect"
local tab_iconGroup_path = "Group"
local tab_icon_path = "Group/Icon"
local tab_mark_path = "Group/Mark"
local black_mask_path = "UICommonPopUpTitle/panel"
local completeBtn_path = "completeBtn"
local gift_package_item_path = "Root/GiftPackageItem"

function LWUIResourceLackView:OnCreate()
  base.OnCreate(self)
  self.data = self:GetUserData()
  self.data.id = tonumber(self.data.id)
  self.showGiftPackageId = nil
  self:ComponentDefine()
  self:ReInit()
  if self.selectResourceData then
    PostEventLog.Track(PostEventLog.Defines.getmoreOpen, {
      af_receipt_id = self.selectResourceData.resType,
      af_order_id = self.showGiftPackageId
    })
  end
end

function LWUIResourceLackView:OnDestroy()
  DataCenter.ArrowManager:RemoveArrow()
  self:ComponentDestroy()
  self.showGiftPackageId = nil
  self.click = false
  if self.delayClick then
    self.delayClick:Stop()
    self.delayClick = nil
  end
  base.OnDestroy(self)
end

function LWUIResourceLackView:ComponentDefine()
  self.title = self:AddComponent(UIText, titlePath)
  self.title:SetText(Localization:GetString("450010"))
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.completeBtn = self:AddComponent(UIButton, completeBtn_path)
  self.completeBtn:SetOnClick(function()
    self:OnCompleteBtnClick()
  end)
  self.maskBtnN = self:AddComponent(UIButton, black_mask_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnText = self:AddComponent(UIText, "completeBtn/Text")
  self.expandBg = self:AddComponent(UIBaseContainer, expand_content).rectTransform
  self.tabs = {}
  self.tabsRoot = self:AddComponent(UIBaseContainer, tab_root_path)
  for i = 1, 4 do
    local tab = {}
    local rootPath = string.format(tab_path, i)
    tab.tab = self:AddComponent(UIBaseContainer, rootPath)
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, tab_select_path)
    tab.tab_unselect = tab.tab:AddComponent(UIBaseContainer, tab_unselect_path)
    tab.tab_iconGroup = tab.tab:AddComponent(UICanvasGroup, tab_iconGroup_path)
    tab.tab_icon = tab.tab:AddComponent(UIImage, tab_icon_path)
    tab.tab_mark = tab.tab:AddComponent(UIImage, tab_mark_path)
    tab.tab_btn = tab.tab:AddComponent(UIButton, tab_btn_path)
    local index = i
    tab.tab_btn:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
  self.resTitle = self:AddComponent(UIText, resTitle_path)
  self.resBarText = self:AddComponent(UIText, resBarText_path)
  self.resBar = self:AddComponent(UISlider, resBar_path)
  self.resIcon = self:AddComponent(UIImage, resIcon_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.gift_package_item = self:AddComponent(LWResourceLackCell, gift_package_item_path)
  self.gift_package_item:SetActive(false)
end

function LWUIResourceLackView:ComponentDestroy()
  self.content:RemoveComponents(LWMaxAdListItemView)
  self:GameObjectDestroy(self.adCellReq)
  self.adCellReq = nil
  self.adItem = nil
  self:ClearList()
  self.content = nil
  self.gift_package_item = nil
end

function LWUIResourceLackView:OnCompleteBtnClick()
  if self.click then
    return
  end
  self.click = true
  self.delayClick = TimerManager:GetInstance():DelayInvoke(function()
    self.click = false
  end, 1)
  local resCount = 0
  local have = LuaEntry.Resource:GetCntByResType(self.selectResourceData.resType)
  local tempHave = 0
  local deficiencyRes = self.selectResourceData.need - have
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
      UIUtil.ShowTipsId("fill_up_collect_resources")
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
        DataCenter.LWResourceLackManager:SetReceiveHangUpRewardSilentlySign()
        SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 1, true)
        resCount = resCount + 1
      end
    end
  end
  deficiencyRes = deficiencyRes - tempHave
  local goItemList = {}
  if 0 < deficiencyRes then
    local list = DeepCopy(self.dataList)
    goItemList = self:GetSortCountList(list)
    if 0 < #goItemList then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSupplementAll, {anim = true}, self.data, {
        resType = self.selectResourceData.resType,
        needResCount = deficiencyRes
      })
      return
    end
  end
  if 0 < resCount then
    self:RefreshBar()
    self:RefreshContent()
  else
    UIUtil.ShowTipsId("res_not_enough_tips_1")
  end
end

function LWUIResourceLackView:SetMinItemInfo(deficiencyRes, info, index, isOr)
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

function LWUIResourceLackView:SetMaxItemInfo(deficiencyRes, infos, index)
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

function LWUIResourceLackView:GetHaveMinCountItemIndex(list, deficiencyRes)
  if 0 < deficiencyRes then
    for i = #list, 1, -1 do
      if 0 < list[i].haveNum then
        return i
      end
    end
  end
end

function LWUIResourceLackView:GetSortCountList(list, deficiencyRes)
  local goItemList = {}
  for i, data in pairs(list) do
    if data.tips == LWResourceLackGetWay.UseItem then
      local items = DataCenter.ItemData:GetItemById(data.para1)
      local itemCount = items and items.count or 0
      local have = 0
      if self.selectResourceData.type == 2 then
        have = DataCenter.ResourceItemDataManager:GetCountByItemId(self.selectResourceData.id)
      elseif self.selectResourceData.type == 1 then
        have = DataCenter.ItemData:GetItemCount(self.selectResourceData.id)
      else
        have = LuaEntry.Resource:GetCntByResType(self.selectResourceData.resType)
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
        elseif goods:IsSelectBox() and not goods:IsGuarantBox() then
          local List = string.split(items.para1, "|")
          local options = {}
          local optionsIndices = {}
          for i = 1, #List do
            local item = string.split(List[i], ",")
            options[tonumber(item[1])] = tonumber(item[2])
            optionsIndices[tonumber(item[1])] = i
          end
          local templates = {}
          templates = DataCenter.LWResourceLackManager:GetResourceWay(self.selectResourceData.resType)
          if templates then
            for i = 1, #templates do
              local lackTemplate = templates[i]
              local para1Num = tonumber(lackTemplate.para1)
              if para1Num and lackTemplate.tips == LWResourceLackGetWay.UseItem and options[para1Num] then
                local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(para1Num)
                local perGainItemCount = GoodsUtil.GetGoodsReturnItemCount(goodsTemplate.id, self.selectResourceData.resType)
                table.insert(goItemList, {
                  itemId = tonumber(items.itemId),
                  give = perGainItemCount,
                  haveNum = itemCount,
                  quality = goods.color,
                  chooseItemIndex = optionsIndices[para1Num]
                })
                break
              end
            end
          end
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

function LWUIResourceLackView:OnEnable()
  base.OnEnable(self)
end

function LWUIResourceLackView:OnDisable()
  base.OnDisable(self)
end

function LWUIResourceLackView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.UpdateGold, self.UpdateResource)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResource)
  self:AddUIListener(EventId.OnGetQueryHangUpRewardResult, self.OnGetQueryResult)
  self:AddUIListener(EventId.ProductLineUpdate, self.OnCityCollectionBack)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshCurrentPage)
  self:AddUIListener(EventId.MaxAd_RefreshAdInfo, self.RefreshAdItem)
end

function LWUIResourceLackView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateResource)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResource)
  self:RemoveUIListener(EventId.OnGetQueryHangUpRewardResult, self.OnGetQueryResult)
  self:RemoveUIListener(EventId.ProductLineUpdate, self.OnCityCollectionBack)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshCurrentPage)
  self:RemoveUIListener(EventId.MaxAd_RefreshAdInfo, self.RefreshAdItem)
end

function LWUIResourceLackView:RefreshCurrentPage()
  if self.selectResourceData and self.selectTab then
    self:RefreshBar()
    self:RefreshContent()
  end
end

function LWUIResourceLackView:ReInit()
  self.selectResourceData = nil
  self.selectTab = nil
  for k, v in pairs(self.tabs) do
    local tab = v
    if k > #self.data then
      tab.tab.gameObject:SetActive(false)
    else
      local itemData = self.data[k]
      tab.tab.gameObject:SetActive(true)
      tab.tab_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(itemData.resType))
      local curHave = LuaEntry.Resource:GetCntByResType(itemData.resType)
      local isEnough = curHave >= itemData.need
      tab.tab_mark.gameObject:SetActive(isEnough)
      tab.isEnough = isEnough
      if k == 1 then
        self.selectResourceData = itemData
        self.selectTab = tab
        tab.tab_iconGroup:SetAlpha(1)
        tab.tab_select.gameObject:SetActive(true)
        tab.tab_unselect.gameObject:SetActive(false)
      else
        tab.tab_iconGroup:SetAlpha(0.7)
        tab.tab_select.gameObject:SetActive(false)
        tab.tab_unselect.gameObject:SetActive(true)
      end
    end
  end
  if #self.data == 1 then
    self.tabsRoot:SetActive(false)
    self.expandBg:Set_sizeDelta(820, 1250)
  else
    self.tabsRoot:SetActive(true)
    self.expandBg:Set_sizeDelta(820, 1310)
  end
  self:RefreshBar()
  self:RefreshContent()
  self.btnText:SetLocalText(130256)
end

function LWUIResourceLackView:GetIsShow()
  local have = 0
  local type = self.selectResourceData.resType
  if self.selectResourceData and (type == ResourceType.Metal or type == ResourceType.Food or type == ResourceType.Wood or type == ResourceType.Petroleum) then
    have = LuaEntry.Resource:GetCntByResType(self.selectResourceData.resType)
    return have < self.selectResourceData.need
  end
end

function LWUIResourceLackView:RefreshBar()
  self.resIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.selectResourceData.resType))
  local have = LuaEntry.Resource:GetCntByResType(self.selectResourceData.resType)
  local need = self.selectResourceData.need
  self.resBarText:SetText(string.GetFormattedSeperatorNum(have) .. "/" .. string.GetFormattedSeperatorNum(need))
  self.resBar:SetValue(have / need)
  local showNum = Mathf.Max(0, need - have)
  self.resTitle:SetText(string.format(Localization:GetString("450011", string.GetFormattedSeperatorNum(showNum), DataCenter.ResourceManager:GetResourceNameByType(self.selectResourceData.resType))))
  if self.selectTab then
    local isEnough = have >= need
    self.selectTab.tab_mark.gameObject:SetActive(isEnough)
    if isEnough == true and self.selectTab.isEnough ~= isEnough then
      self.selectTab.isEnough = isEnough
      local index = -1
      for k, v in pairs(self.tabs) do
        if k <= #self.data then
          local tab = v
          if not tab.isEnough then
            index = k
            break
          end
        end
      end
      if 0 < index then
        self:DoSelectTabIndex(index)
      end
    end
  end
end

function LWUIResourceLackView:RefreshContent()
  local resType = self.selectResourceData.resType
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
  local need = self.selectResourceData.need
  local tempDataList
  if not table.IsNullOrEmpty(templates) then
    tempDataList = LWResourceLackUtil:FilterResourceTemplates(templates, need)
  end
  self.gift_package_item:SetActive(false)
  if not tempDataList or #tempDataList == 0 then
    self.completeBtn:SetActive(false)
    return
  end
  table.sort(tempDataList, function(a, b)
    return a.order < b.order
  end)
  if 0 < table.count(tempDataList) then
    local giftPackageData = tempDataList[1]
    if giftPackageData.tips == LWResourceLackGetWay.GiftPackage or giftPackageData.tips == LWResourceLackGetWay.GiftPackageList then
      local openLv = LuaEntry.DataConfig:TryGetNum("guide_opt", "k11")
      local mainLv = DataCenter.BuildManager.MainLv
      local giftPackUnlock = openLv <= mainLv
      if giftPackUnlock then
        self.gift_package_item:SetActive(true)
        self.showGiftPackageId = giftPackageData.id
        self.gift_package_item:Refresh(true, giftPackageData, self.ctrl, self.selectResourceData)
      end
      self.dataList = {}
      if table.count(tempDataList) > 1 then
        for k = 2, table.count(tempDataList) do
          table.insert(self.dataList, tempDataList[k])
        end
      end
    else
      self.dataList = tempDataList
    end
  end
  self.newCells = self.newCells or {}
  self.dataList = self.dataList or {}
  for k, v in ipairs(self.dataList) do
    local data = v
    local index = k
    local cellData = self.newCells[index]
    if data then
      if cellData then
        if cellData.cell then
          self:TryRefreshCell(index, cellData.cell)
        end
      else
        self:CreateCell(index)
      end
    end
  end
  for k, v in pairs(self.newCells) do
    if v.cell and k > #self.dataList then
      v.cell:SetActive(false)
    end
  end
  self:RefreshAdItem()
  self.completeBtn:SetActive(self:GetIsShow())
  UIUtil.CheckEventTrigger(OpMode.ClickBtnResource, resType)
end

function LWUIResourceLackView:CreateCell(index)
  local _ = {}
  _.index = index
  _.cell = nil
  _.request = nil
  self.newCells[index] = _
  _.request = self:GameObjectInstantiateAsync(UIAssets.LWLackResourceItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = string.format("LWResourceLackCell_%s", _.index)
    go.name = nameStr
    local cell = self.content:AddComponent(LWResourceLackCell, nameStr)
    _.cell = cell
    cell:Init()
    self:TryRefreshCell(_.index, cell)
  end)
end

function LWUIResourceLackView:TryRefreshCell(index, cell)
  if not cell then
    return
  end
  local data = self.dataList and self.dataList[index]
  if data then
    cell:Refresh(false, data, self.ctrl, self.selectResourceData)
    cell:SetActive(true)
    if data.tips == LWResourceLackGetWay.HangUp then
      SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0, true)
    end
  else
    cell:SetActive(false)
  end
end

function LWUIResourceLackView:ClearList()
  if self.newCells then
    self.content:RemoveComponents(LWResourceLackCell)
    for k, v in pairs(self.newCells) do
      if v.request then
        self:GameObjectDestroy(v.request)
      end
    end
    self.newCells = nil
  end
end

function LWUIResourceLackView:DoSelectTabIndex(index)
  self.selectResourceData = self.data[index]
  local newTab = self.tabs[index]
  local oldTab = self.selectTab
  if newTab ~= oldTab then
    if oldTab then
      oldTab.tab_iconGroup:SetAlpha(0.7)
      oldTab.tab_select.gameObject:SetActive(false)
      oldTab.tab_unselect.gameObject:SetActive(true)
    end
    self.selectTab = newTab
    newTab.tab_iconGroup:SetAlpha(1)
    newTab.tab_select.gameObject:SetActive(true)
    newTab.tab_unselect.gameObject:SetActive(false)
    self:RefreshBar()
    self:RefreshContent()
  end
end

function LWUIResourceLackView:UpdateResource()
  self:RefreshBar()
  self:UseItemSuccessHandle()
  local allClear = true
  for k, v in pairs(self.data) do
    local have = LuaEntry.Resource:GetCntByResType(v.resType)
    local need = v.need
    if have < need then
      allClear = false
      break
    end
  end
  if allClear then
    self.ctrl:CloseSelf()
  end
end

function LWUIResourceLackView:UseItemSuccessHandle()
  local waitDel = {}
  for k, v in pairs(self.newCells) do
    local data = self.dataList[v.index]
    local cell = v.cell
    if not data then
      if IsNotNull(cell) then
        cell:SetActive(false)
      end
    elseif not IsNull(cell) then
      if data.tips == LWResourceLackGetWay.UseItem then
        local items = DataCenter.ItemData:GetItemById(data.para1)
        local itemCount = items and items.count or 0
        if itemCount == 0 then
          table.insert(waitDel, v.index)
        elseif cell then
          cell.title2:SetText(Localization:GetString(data.des, itemCount))
        end
        if cell then
          cell:RefreshUseCount()
        end
      elseif data.tips == LWResourceLackGetWay.BuyGiftBag and cell then
        cell:RefreshBuyCell()
      end
    end
  end
  for k, v in ipairs(waitDel) do
    local newCell = self.newCells[v]
    if newCell and newCell.cell then
      newCell.cell:SetActive(false)
    end
  end
  self.delayRefreshContent = true
end

function LWUIResourceLackView:OnGetQueryResult()
  if not self.newCells then
    return
  end
  local reward = DataCenter.StageManager.idleReward
  if not reward then
    return
  end
  local value = 0
  for i, rewardRow in ipairs(reward) do
    local resType = rewardRow.type
    local val = rewardRow.value
    if resType == RewardType.METAL and self.selectResourceData.resType == ResourceType.Metal or resType == RewardType.WOOD and self.selectResourceData.resType == ResourceType.Wood or resType == RewardType.FOOD and self.selectResourceData.resType == ResourceType.Food or resType == RewardType.FLINT and self.selectResourceData.resType == ResourceType.FLINT or resType == RewardType.OBSIDIAN and self.selectResourceData.resType == ResourceType.OBSIDIAN then
      value = val
      self.hangUpValue = val
    end
  end
  for k, v in pairs(self.newCells) do
    local data = self.dataList[v.index]
    local cell = v.cell
    if not data then
      if IsNotNull(cell) then
        cell:SetActive(false)
      end
    elseif not IsNull(cell) and data and data.tips == LWResourceLackGetWay.HangUp then
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
      if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
        cell.title2:SetLocalText(450095)
        cell.gotoBtnText:SetLocalText(450096)
      else
        cell.title2:SetText(Localization:GetString(data.des, value))
        cell.gotoBtnText:SetText(Localization:GetString(data.btn_name))
      end
    end
  end
  self.completeBtn:SetActive(self:GetIsShow())
end

function LWUIResourceLackView:OnCityCollectionBack()
  if not self.newCells then
    return
  end
  for _, v in pairs(self.newCells) do
    local data = self.dataList[v.index]
    local cell = v.cell
    if not data then
      if IsNotNull(cell) then
        cell:SetActive(false)
      end
    elseif not IsNull(cell) and data.tips == LWResourceLackGetWay.CityCollection then
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(data.para1))
      if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
        break
      end
      local total = 0
      for _, build in pairs(buildList) do
        local storage = DataCenter.ProductLineManager:GetBuildingCurrStorage(build.uuid)
        total = total + storage
      end
      cell.title2:SetText(Localization:GetString(data.des, math.floor(total)))
    end
  end
end

function LWUIResourceLackView:GetFlyTargetPos()
  return self.resIcon.transform.position
end

function LWUIResourceLackView:Update1000MS()
  if self.delayRefreshContent then
    self:RefreshContent()
    self.delayRefreshContent = false
  end
end

function LWUIResourceLackView:RefreshAdItem()
  local isShow = DataCenter.MaxAdManager:IsResourceAdShow(AdCollectionId.Resource, self.selectResourceData.resType)
  local data = DataCenter.MaxAdManager:GetAdCollectionById(AdCollectionId.Resource)
  if self.adItem then
    self.adItem:SetActive(isShow)
    if isShow then
      self.adItem:RefreshView(data)
    end
  elseif isShow and not self.adCellReq then
    local MaxAdItem = "Assets/Main/Prefabs/UI/LWUIMaxAd/LWMaxAdListItem.prefab"
    self.adCellReq = self:GameObjectInstantiateAsync(MaxAdItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "LWMaxAdListItem"
      self.adItem = self.content:AddComponent(LWMaxAdListItemView, go.name)
      self.adItem:RefreshView(data)
      self.adItem:SetAsFirstSibling()
    end)
  end
  if isShow then
    PostEventLog.Track(PostEventLog.Defines.ADEventOpen, {
      af_content_id = AdCollectionId.Resource
    })
  end
end

return LWUIResourceLackView
