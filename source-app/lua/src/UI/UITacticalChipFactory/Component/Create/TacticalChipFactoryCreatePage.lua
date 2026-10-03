local base = UIBaseContainer
local TacticalChipFactoryCreatePage = BaseClass("TacticalChipFactoryCreatePage", UIBaseContainer)
local TWSkillChipTemplate = require("DataCenter.TacticalWeapon.TWSkillChipTemplateManager.TWSkillChipTemplate")
local TacticalChipItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipItem")
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local Localization = CS.GameEntry.Localization
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local PROGRESS_VALUE_MAX = 470

function TacticalChipFactoryCreatePage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitTab()
end

function TacticalChipFactoryCreatePage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalChipFactoryCreatePage:ComponentDefine()
  self.compChipBg = self:AddComponent(UIBaseContainer, "Top/chipBg")
  self.canvasGroupChipBg = self:AddComponent(UICanvasGroup, "Top/chipBg")
  self.textSelectChipTip = self:AddComponent(UIText, "Top/selectChipTip")
  self.textSelectChipTip:SetLocalText("battlesystem_factory_craft_desc1")
  self.compChipInfoNode = self:AddComponent(UIBaseContainer, "Top/chipInfoNode")
  self.imgChipPosIcon = self:AddComponent(UIImage, "Top/chipInfoNode/chipTypeName/chipPosIcon")
  if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == -1 then
    self.imgChipPosIcon:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.imgChipPosIcon:SetLocalScaleXYZ(1, 1, 1)
  end
  self.textChipTypeName = self:AddComponent(UIText, "Top/chipInfoNode/chipTypeName")
  self.textChipName = self:AddComponent(UIText, "Top/chipInfoNode/chipName")
  self.chipItemNode = self:AddComponent(UIBaseContainer, "Top/chipInfoNode/chipItemNode")
  self.btnChipDetail = self:AddComponent(UIButton, "Top/chipInfoNode/chipDetailBtn")
  self.btnChipDetail:SetOnClick(function()
    self:OnBtnChipDetailClick()
  end)
  self.textChipCostPropsNum = self:AddComponent(UIText, "Top/chipInfoNode/costNode/chipCostPropsNum")
  self.compChipListNode = self:AddComponent(UIBaseContainer, "Middle/chipListNode")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "Middle/chipListNode/ItemHolder")
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.compItemContent = self:AddComponent(UIBaseContainer, "Middle/chipListNode/ItemHolder/Viewport/ItemContent")
  self.compTabTank = self:AddComponent(UICommonTab, "Middle/chipListNode/tabRoot/tabTank")
  self.compTabMissile = self:AddComponent(UICommonTab, "Middle/chipListNode/tabRoot/tabMissile")
  self.compTabAir = self:AddComponent(UICommonTab, "Middle/chipListNode/tabRoot/tabAir")
  self.textNoChipTip = self:AddComponent(UIText, "Middle/chipListNode/noChipTip")
  self.timeDurationNode = self:AddComponent(UIBaseContainer, "Bottom/timeDurationNode")
  self.textChipProductResidueTime = self:AddComponent(UIText, "Bottom/timeDurationNode/chipProductDurationTime")
  self.btnProduct = self:AddComponent(UIButton, "Bottom/productBtn")
  self.btnProduct:SetOnClick(function()
    self:OnBtnProductClick()
  end)
  self.textProductBtn = self:AddComponent(UIText, "Bottom/productBtn/Btn/productBtnText")
  self.textProductBtn:SetLocalText("battlesystem_factory_craft_button1")
  self.productBtnTextNum = self:AddComponent(UIText, "Bottom/productBtn/Btn/productBtnTextNum")
  self.compPropsItemNode = self:AddComponent(UIBaseContainer, "Top/chipInfoNode/costNode/propsItemNode")
  self.btnCollect = self:AddComponent(UIButton, "Bottom/collectBtn")
  self.btnCollect:SetOnClick(function()
    self:OnBtnCollectClick()
  end)
  self.collectBtnText = self:AddComponent(UIText, "Bottom/collectBtn/Btn/collectBtnText")
  self.collectBtnText:SetLocalText("battlesystem_factory_craft_button2")
  self.bottomNode = self:AddComponent(UIBaseContainer, "Bottom")
  self.compResidueTimeNode = self:AddComponent(UIBaseContainer, "Bottom/residueTimeNode")
  self.compResidueTimeProgressFill = self:AddComponent(UIBaseContainer, "Bottom/residueTimeNode/residueTimeProgressNode/Bg/residueTimeProgressFill")
  self.textResidueTimeProgressValue = self:AddComponent(UIText, "Bottom/residueTimeNode/residueTimeProgressNode/residueTimeProgressValue")
  self.textMakingDesc = self:AddComponent(UIText, "Bottom/residueTimeNode/makingDesc")
  self.textMakingDesc:SetLocalText("battlesystem_factory_craft_desc3")
  self.btnAddSpeed = self:AddComponent(UIButton, "Bottom/residueTimeNode/addSpeedBtn")
  self.btnAddSpeed:SetOnClick(function()
    self:OnBtnAddSpeedClick()
  end)
  self.lockDesc = self:AddComponent(UIText, "Bottom/lockDesc")
  self.chipBgVfxNode = self:AddComponent(UIVfx, "Top/chipBg/chipBgVfxNode", VfxAssets.TacticalChipFactoryCreatePageDianLiu, {
    lifeType = UIVfxLifeType.Stay
  })
  self.sliderGroup = self:AddComponent(UISliderGroup, "Bottom/UISliderGroup")
  self.curHighestStarNode = self:AddComponent(UIBaseContainer, "Top/chipInfoNode/curHighestStarNode")
  self.curHighestStarLayout = self:AddComponent(UIBaseContainer, "Top/chipInfoNode/curHighestStarNode/starNode/starLayout")
  self.curHighestStarCheckOutBtn = self:AddComponent(UIButton, "Top/chipInfoNode/curHighestStarNode/starNode/checkNode/curHighestStarCheckBtn")
  self.curHighestStarCheckOutBtn:SetOnClick(function()
    self:OnCurHighestStarCheckOutBtnClick()
  end)
  self.curHighestStarNeedDesc = self:AddComponent(UITextMeshProUGUIEx, "Top/chipInfoNode/curHighestStarNode/curHighestStarNeedDesc")
  self.notOwnChipTip = self:AddComponent(UITextMeshProUGUIEx, "Top/chipInfoNode/notOwnChipTip")
  self.curHighestStarNeedTitle = self:AddComponent(UITextMeshProUGUIEx, "Top/chipInfoNode/curHighestStarNode/starNode/curHighestStarNeedTitle")
end

function TacticalChipFactoryCreatePage:ComponentDestroy()
  self:StopCrafting()
  if self.compItemContent then
    self.compItemContent:RemoveComponents(TacticalChipItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.sliderGroup = nil
  self.compChipBg = nil
  self.canvasGroupChipBg = nil
  self.textSelectChipTip = nil
  self.compChipInfoNode = nil
  self.imgChipPosIcon = nil
  self.textChipTypeName = nil
  self.textChipName = nil
  self.btnChipDetail = nil
  self.textChipCostPropsNum = nil
  self.compChipListNode = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.compTabTank = nil
  self.compTabMissile = nil
  self.compTabAir = nil
  self.textNoChipTip = nil
  self.timeDurationNode = nil
  self.textChipProductResidueTime = nil
  self.btnProduct = nil
  self.textProductBtn = nil
  self.compPropsItemNode = nil
  self.btnCollect = nil
  self.compResidueTimeNode = nil
  self.compResidueTimeProgressFill = nil
  self.textResidueTimeProgressValue = nil
  self.textMakingDesc = nil
  self.btnAddSpeed = nil
  self.chipItemNode = nil
  self.bottomNode = nil
  self.lockDesc = nil
end

function TacticalChipFactoryCreatePage:DataDefine()
  self.highestChipStars = {}
end

function TacticalChipFactoryCreatePage:DataDestroy()
  self:ClearHighestChipStars()
  self.chipItem = nil
  self.chipCostItem = nil
  self.chipItemReq = nil
  self.chipCostItemReq = nil
  self.curSelectChipId = nil
  self.buildingUuid = nil
  self.buildingData = nil
  self.curStatus = nil
  self.tabItemList = nil
end

function TacticalChipFactoryCreatePage:OnEnable()
  base.OnEnable(self)
end

function TacticalChipFactoryCreatePage:OnDisable()
  self.chipBgVfxNode:Stop()
  self.curSelectChipId = nil
  if self.curTab then
    self.curTab:SetSelect(false)
    self.curTab = nil
  end
  base.OnDisable(self)
end

function TacticalChipFactoryCreatePage:ReInit(buildingUuid)
  self.buildingUuid = buildingUuid
  self:RefreshBaseData()
  if string.IsNullOrEmpty(self.buildingUuid) or self.buildingData == nil then
    Logger.LogError("buildingUuid or buildingData is nil!")
    return
  end
  self:OnTabClick(self.compTabTank)
  self:RefreshChipInfo()
end

function TacticalChipFactoryCreatePage:SetCustomParam(param)
  if param == nil then
    return
  end
  if param.tarTab == 1 then
    self:OnTabClick(self.compTabTank)
  elseif param.tarTab == 2 then
    self:OnTabClick(self.compTabMissile)
  elseif param.tarTab == 3 then
    self:OnTabClick(self.compTabAir)
  end
  self:OnChipItemClick(param.tarChipId)
end

function TacticalChipFactoryCreatePage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.TacticalChipProductComplete, self.OnProductComplete)
end

function TacticalChipFactoryCreatePage:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.TacticalChipProductComplete, self.OnProductComplete)
  base.OnRemoveListener(self)
end

function TacticalChipFactoryCreatePage:OnProductComplete()
  self:RefreshBaseData()
  self:RefreshChipInfo()
  self:RefreshDataListShow()
end

function TacticalChipFactoryCreatePage:OnResOrItemUpdate()
  self:RefreshItemCost()
end

function TacticalChipFactoryCreatePage:InitTab()
  local tabTankParam = {}
  tabTankParam.tabId = HeroType.Tank
  tabTankParam.clickHandler = self.OnTabClick
  self.compTabTank:ReInit(tabTankParam)
  self.compTabTank:SetSelect(false)
  local tabMissileParam = {}
  tabMissileParam.tabId = HeroType.Missile
  tabMissileParam.clickHandler = self.OnTabClick
  self.compTabMissile:ReInit(tabMissileParam)
  self.compTabMissile:SetSelect(false)
  local tabAirParam = {}
  tabAirParam.tabId = HeroType.Aircraft
  tabAirParam.clickHandler = self.OnTabClick
  self.compTabAir:ReInit(tabAirParam)
  self.compTabAir:SetSelect(false)
  self.tabItemList = {
    self.compTabTank,
    self.compTabMissile,
    self.compTabAir
  }
end

function TacticalChipFactoryCreatePage:StartCrafting()
  if self.updateTimer == nil then
    self.updateTimer = TimerManager:GetInstance():GetTimer(1, self.UpdateCrafting, self, false, false, false)
    self.updateTimer:Start()
    self:UpdateCrafting()
  end
end

function TacticalChipFactoryCreatePage:StopCrafting()
  if self.updateTimer ~= nil then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
end

function TacticalChipFactoryCreatePage:RefreshBaseData()
  self.buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildingUuid)
  self.buildingLv = self.buildingData.level
end

function TacticalChipFactoryCreatePage:RefreshDataList()
  if self.curTab == nil then
    return
  end
  self.chipsDataList = DataCenter.TacticalChipFactoryManager:GetCanProductChipTemplateList(self.curTab.tabId)
  local dataCount = 0
  if self.chipsDataList then
    dataCount = #self.chipsDataList
  end
  self.loopGridViewItemHolder:SetActive(0 < dataCount)
  self.textNoChipTip:SetActive(dataCount <= 0)
  self.loopGridViewItemHolder:SetListItemCount(dataCount)
  self.loopGridViewItemHolder:RefreshAllShownItem()
end

function TacticalChipFactoryCreatePage:RefreshChipInfo()
  self.compChipInfoNode:SetActive(self.curSelectChipId ~= nil)
  self.bottomNode:SetActive(self.curSelectChipId ~= nil)
  self.textSelectChipTip:SetActive(self.curSelectChipId == nil)
  self.curHighestStarNode:SetActive(self.curSelectChipId ~= nil)
  self.notOwnChipTip:SetActive(self.curSelectChipId ~= nil)
  if self.curSelectChipId == nil then
    return
  end
  local template = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.curSelectChipId)
  if template == nil then
    return
  end
  self.chipBgVfxNode:Replay()
  self.textChipName:SetLocalText(template.name)
  self.textChipTypeName:SetText(TacticalWeaponUtils.GetSkillChipTypeText(template.skill_type))
  self.imgChipPosIcon:LoadSprite(DataCenter.TacticalChipManager:GetChipPosIcon(template.skill_type))
  if self.chipItemReq == nil then
    self.chipItemReq = self:CreateChipItem()
  elseif self.chipItemReq.isDone then
    self.chipItem:SetTemplate(self.curSelectChipId)
  end
  if self.chipCostItemReq == nil then
    self.chipCostItemReq = self:CreateChipCostItem()
  elseif self.chipCostItemReq.isDone then
    self.chipCostItem:SetChipExpData({
      configId = template.craft_material[1],
      useCount = 0
    })
  end
  self:RefreshChipStatus()
  self:RefreshItemCost()
  self:RefreshHighestStarChipNeed()
end

function TacticalChipFactoryCreatePage:RefreshHighestStarChipNeed()
  if self.curSelectChipId == nil then
    return
  end
  self:ClearHighestChipStars()
  local bestChip = DataCenter.TacticalChipManager:GetBestStarChip(self.curSelectChipId)
  if not bestChip then
    self.notOwnChipTip:SetLocalText("drone_skillchip_make_15_limit_18")
  else
    if bestChip:GetStar() == 0 then
      self.curHighestStarNeedTitle:SetLocalText("drone_skillchip_make_16_limit_18")
    else
      self.curHighestStarNeedTitle:SetLocalText("drone_skillchip_make_1_limit_10")
    end
    local showPreview, ownNumStr, needNum = DataCenter.TacticalChipManager.GetUpgradeStarNeedNumFormat(bestChip)
    if showPreview then
      self.curHighestStarNeedDesc:SetLocalText("drone_skillchip_make_2_limit_10", ownNumStr, needNum)
    end
    local isMaxStar = bestChip:IsMaxStar()
    self.curHighestStarNeedDesc:SetActive(showPreview and not isMaxStar)
    self:SetHighestChipStars(bestChip:GetStar())
  end
  self.curHighestStarNode:SetActive(bestChip ~= nil)
  self.notOwnChipTip:SetActive(bestChip == nil)
end

function TacticalChipFactoryCreatePage:ClearHighestChipStars()
  if self.highestChipStars then
    self.curHighestStarLayout:RemoveComponents(UIHeroSkillStar)
    for i, v in ipairs(self.highestChipStars) do
      self:GameObjectDestroy(v)
    end
    self.highestChipStars = {}
  end
end

function TacticalChipFactoryCreatePage:SetHighestChipStars(starCount)
  self:ClearHighestChipStars()
  if 0 < starCount then
    local showStarCount = math.min(starCount, 5)
    local leftWindow = math.max(0, starCount - 5)
    local rightWindow = starCount
    for i = 1, showStarCount do
      local starRequest = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillStar, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.curHighestStarLayout.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cell = self.curHighestStarLayout:AddComponent(UIHeroSkillStar, go)
        cell:SetFilled(true)
        local viewStarIndex = rightWindow - i + 1
        cell:SetStarIndex(viewStarIndex)
        cell.transform:Set_sizeDelta(22.12, 23.26)
      end)
      table.insert(self.highestChipStars, starRequest)
    end
  end
end

function TacticalChipFactoryCreatePage:RefreshItemCost()
  if self.curSelectChipId == nil then
    return
  end
  local costItemId, costItemNum, ownItemNum = self:GetItemIdAndCostAndOwn()
  costItemNum = costItemNum * self.sliderGroup:GetCurNum()
  if ownItemNum >= costItemNum then
    self.textChipCostPropsNum:SetLocalText("battlesystem_factory_craft_desc4", ownItemNum, costItemNum)
  else
    self.textChipCostPropsNum:SetLocalText("battlesystem_factory_craft_desc5", ownItemNum, costItemNum)
  end
end

function TacticalChipFactoryCreatePage:GetItemIdAndCostAndOwn()
  if self.curSelectChipId == nil then
    return
  end
  local template = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.curSelectChipId)
  local costItemId = template.craft_material[1]
  local costItemNum = template.craft_material[2]
  local itemInfo = DataCenter.ItemData:GetItemById(costItemId)
  local ownItemNum = 0
  if itemInfo then
    ownItemNum = itemInfo.count or 0
  end
  return costItemId, costItemNum, ownItemNum
end

function TacticalChipFactoryCreatePage:RefreshChipStatus()
  if self.curSelectChipId == nil then
    return
  end
  local template = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.curSelectChipId)
  if template == nil then
    return
  end
  local isLock = template:IsLock(self.buildingLv)
  if isLock then
    self.lockDesc:SetLocalText("battlesystem_factory_craft_desc2", template.craft_factory_level)
    self.sliderGroup:SetMinNum(1)
    self.sliderGroup:SetMaxNum(1)
    self.sliderGroup:ReInit()
  else
    local costItemId, costItemNum, ownItemNum = self:GetItemIdAndCostAndOwn()
    local canProductNum = ownItemNum // costItemNum
    self.sliderGroup:SetMinNum(1)
    self.sliderGroup:SetOnNumChangedHandler(function(num)
      self.productBtnTextNum:SetText(string.format("\195\151%s", num))
      self:RefreshItemCost()
    end)
    if canProductNum <= 0 then
      self.sliderGroup:SetMaxNum(1)
    else
      self.sliderGroup:SetMaxNum(canProductNum)
    end
    self.sliderGroup:ReInit()
  end
  self.lockDesc:SetActive(isLock)
  self.sliderGroup:SetActive(not isLock)
  self.btnProduct:SetActive(not isLock)
end

function TacticalChipFactoryCreatePage:RefreshRedPoints()
  for i, v in ipairs(self.tabItemList) do
    v:SetRedDotVisible(false)
  end
  if self.curStatus == TacticalChipFactoryStatus.CanGetChip then
    local template = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.craftingChipId)
    if template then
      for i, v in ipairs(self.tabItemList) do
        if template.heroType == v.tabId then
          v:SetRedDotVisible(true)
          break
        end
      end
    end
  end
end

function TacticalChipFactoryCreatePage:UpdateCrafting()
  self.curStatus = DataCenter.TacticalChipFactoryManager:GetFactoryStatus(self.buildingUuid)
  if self.curStatus == TacticalChipFactoryStatus.Working then
    self:RefreshResidueTime()
  else
    self:RefreshChipStatus()
    self:RefreshDataListShow()
  end
end

function TacticalChipFactoryCreatePage:RefreshResidueTime()
  self.textResidueTimeProgressValue:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(BuildingUtils.GetBuildingFunctioningRemainTime(self.buildingData)))
  local percent = BuildingUtils.GetBuildilngFunctioningProgress(self.buildingData)
  local sizeDeltaX = PROGRESS_VALUE_MAX * percent
  local sizeDelta = self.compResidueTimeProgressFill.rectTransform.sizeDelta
  sizeDelta.x = sizeDeltaX
  self.compResidueTimeProgressFill.rectTransform.sizeDelta = sizeDelta
end

function TacticalChipFactoryCreatePage:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self:RefreshDataList()
end

function TacticalChipFactoryCreatePage:RefreshDataListShow()
  self.loopGridViewItemHolder:RefreshAllShownItem()
end

function TacticalChipFactoryCreatePage:OnGetItemByRowColumn(loopScroll, index)
  if self.chipsDataList ~= nil then
    local count = #self.chipsDataList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalChipItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TacticalChipItem)
    if script == nil then
      local name = "chips_" .. index
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TacticalChipItem, name)
      script:SetOnClick(function(chipTemplateId)
        self:OnChipItemClick(chipTemplateId)
      end)
    end
    local data = self.chipsDataList[index]
    script:SetTemplate(data.id)
    script:SetActive(true)
    script:SetPosIconVisible(true)
    script:SetLockedVisible(data:IsLock(self.buildingLv))
    script:SetProductSelectedVisible(data.id == self.curSelectChipId)
    return item
  end
end

function TacticalChipFactoryCreatePage:CreateChipItem()
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.transform:SetParent(self.chipItemNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localPosition(0, 0, 0)
    local cell = self.chipItemNode:AddComponent(TacticalChipItem, go.name)
    cell:SetPivotMiddle()
    cell:SetLocalPositionXYZ(0, 0, 0)
    self.chipItem = cell
    if self.curSelectChipId then
      self.chipItem:SetTemplate(self.curSelectChipId)
      self.chipItem:SetActive(true)
    end
  end)
end

function TacticalChipFactoryCreatePage:CreateChipCostItem()
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.transform:SetParent(self.compPropsItemNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localPosition(0, 0, 0)
    local cell = self.compPropsItemNode:AddComponent(TacticalChipItem, go.name)
    cell:SetPivotMiddle()
    cell:SetLocalPositionXYZ(0, 0, 0)
    cell:SetOnClickChipItem(function(item)
      if item.chipExpItemInfo then
        local desc = DataCenter.RewardManager:GetDescByType(RewardType.GOODS, item.chipExpItemInfo.configId)
        local name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, item.chipExpItemInfo.configId)
        local param = {}
        param.itemName = name
        param.itemDesc = desc
        param.alignObject = item
        param.isLocal = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
      end
    end)
    self.chipCostItem = cell
    if self.curSelectChipId then
      local template = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.curSelectChipId)
      local costItemId = template.craft_material[1]
      self.chipCostItem:SetChipExpData({configId = costItemId, useCount = 0})
      self.chipCostItem:SetActive(true)
    end
  end)
end

function TacticalChipFactoryCreatePage:OnChipItemClick(chipTemplateId)
  if self.curSelectChipId == chipTemplateId then
    return
  end
  self.curSelectChipId = chipTemplateId
  self:RefreshChipInfo()
  self:RefreshDataListShow()
end

function TacticalChipFactoryCreatePage:OnBtnChipDetailClick()
  if self.curSelectChipId == nil then
    return
  end
  local chipInfo = TWSkillChipInfo.New()
  chipInfo:CreateFromTemplate(self.curSelectChipId, 1, 0)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo)
end

function TacticalChipFactoryCreatePage:OnBtnProductClick()
  if self.buildingUuid == nil or self.curSelectChipId == nil then
    return
  end
  local template = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.curSelectChipId)
  local costItemId = template.craft_material[1]
  local costItemNum = template.craft_material[2]
  local itemInfo = DataCenter.ItemData:GetItemById(costItemId)
  local ownItemNum = 0
  if itemInfo then
    ownItemNum = itemInfo.count or 0
  end
  if costItemNum > ownItemNum then
    LWResourceLackUtil:GotoGoodsItemLack(costItemId, costItemNum - ownItemNum)
    return
  end
  if template:IsLock(self.buildingLv) then
    UIUtil.ShowTips(Localization:GetString("battlesystem_factory_error4"))
    return
  end
  SFSNetwork.SendMessage(MsgDefines.TacticalChipProductNew, self.curSelectChipId, self.sliderGroup:GetCurNum())
end

function TacticalChipFactoryCreatePage:OnBtnCollectClick()
  SFSNetwork.SendMessage(MsgDefines.TacticalChipCollect)
end

function TacticalChipFactoryCreatePage:OnBtnAddSpeedClick()
  if self.buildingUuid == nil then
    return
  end
  local status = DataCenter.TacticalChipFactoryManager:GetFactoryStatus(self.buildingUuid)
  if status == TacticalChipFactoryStatus.Working then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Chip_Crate, self.buildingUuid)
  end
end

function TacticalChipFactoryCreatePage:OnCurHighestStarCheckOutBtnClick()
  local param = {}
  param.alignObject = self.curHighestStarCheckOutBtn.transform
  param.width = 574
  param.chipConfigId = self.curSelectChipId
  param.showArrow = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipPlanNeedTip, {anim = true}, param)
end

return TacticalChipFactoryCreatePage
