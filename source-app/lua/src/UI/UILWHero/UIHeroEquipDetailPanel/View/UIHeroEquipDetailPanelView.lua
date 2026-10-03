local UIHeroEquipDetailPanelView = BaseClass("UIHeroEquipDetailPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIEquipDetailPropertyLineItem = require("UI.UILWHero.UIHeroEquipDetailPanel.Component.UIEquipDetailPropertyLineItem")
local UIEquipBasicPropertyLineItem = require("UI.UILWHero.UIHeroEquipDetailPanel.Component.UIEquipBasicPropertyLineItem")
local BaseUIEquipItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem")
local info_btn_path = "Root/InfoBtn"

local function RefreshUpgradeTemplateData(self)
  if self.equipData ~= nil then
    self.equipUpgradeTemplate = DataCenter.EquipUpgradeTemplateManager:GetTemplateBySlotQualityHeroType(self.equipData.config.slot, self.equipData.config.quality, self.equipData.config.heroType)
    if self.equipUpgradeTemplate ~= nil then
      self.costStoneCount = self.equipUpgradeTemplate:GetCostStoneByLevel(self.equipData.level)
      self.costResourceCount = self.equipUpgradeTemplate:GetCostResourceValueByLevel(self.equipData.level)
      self.costResourceType = self.equipUpgradeTemplate:GetCostResourceTypeByLevel(self.equipData.level)
      if self.costGoldIcon ~= nil then
        self.costGoldIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.costResourceType))
      end
    else
      self.costStoneCount = 0
      self.costResourceCount = 0
      self.costResourceType = 2
    end
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.equipDataUuid, self.closeCallBack, self.equipUuids, self.showHeroRelatedBtn = self:GetUserData()
  if self.showHeroRelatedBtn == nil then
    self.showHeroRelatedBtn = true
  end
  self.ctrl:SetCloseCallBack(self.closeCallBack)
  local equipData = DataCenter.EquipDataManager:GetEquipByUuid(self.equipDataUuid)
  if equipData == nil then
    self:OnBtnCloseClick()
    return
  end
  if not self.equipUuids then
    self.equipUuids = {
      self.equipDataUuid
    }
  end
  local index = 1
  for i, v in ipairs(self.equipUuids) do
    if v == self.equipDataUuid then
      index = i
      break
    end
  end
  if not index then
    self:OnBtnCloseClick()
  end
  self:GotoPage(index)
end

local function ClearScroll(self)
  self.propertyScroll:RemoveComponents(UIEquipDetailPropertyLineItem)
  self.proeprtyList:ClearAllItems()
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.allEquipWords then
    return nil
  end
  local wordData = self.allEquipWords[index]
  local item = loopScroll:NewListViewItem("EquipPropertyLineItem")
  local script = self.propertyScroll:GetComponent(item.gameObject.name, UIEquipDetailPropertyLineItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.propertyScroll:AddComponent(UIEquipDetailPropertyLineItem, objectName)
  end
  script:SetActive(true)
  if self.equipData.promoteLevel > 0 or self.equipData:CanStartPromote() and DataCenter.EquipDataManager:IsPromoteFunctionOpen() then
    script:SetPromoteData(wordData, self.equipData.promoteLevel)
  else
    script:SetUpradeData(wordData, self.equipData.level)
  end
  self.cells[index] = script
  return item
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnReplaceBtnClick(self, slotType)
  if self.curHeroData == nil or self.equipData == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquipListPanel, {anim = true}, self.curHeroData, self.equipData.slot)
end

local function OnUpgradeBtnClick(self)
  RefreshUpgradeTemplateData(self)
  local maxLevel = self.equipData.level
  if self.equipUpgradeTemplate ~= nil then
    maxLevel = self.equipUpgradeTemplate.maxLevel
  end
  if maxLevel <= self.equipData.level then
    UIUtil.ShowTipsId(430746)
    return
  end
  local haveGoldCount = CommonUtil.GetResOrItemCount(self.costResourceType)
  if haveGoldCount < self.costResourceCount then
    if CS.SceneManager:IsInPVE() then
      UIUtil.ShowTipsId("quick_upgrade_tips")
      return
    end
    local data = {}
    table.insert(data, {
      resType = self.costResourceType,
      need = self.costResourceCount
    })
    LWResourceLackUtil:GotoResLack(data)
    return
  end
  local haveStoneCount = DataCenter.ResourceItemDataManager:GetCountByItemId(ResourceItemId.EquipStrengtheningStone)
  if haveStoneCount < self.costStoneCount then
    if CS.SceneManager:IsInPVE() then
      UIUtil.ShowTipsId("quick_upgrade_tips")
      return
    end
    LWResourceLackUtil:GotoResourceItemLack(ResourceItemId.EquipStrengtheningStone, self.costStoneCount)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroEquipUpgrade, self.equipData.uuid)
end

local function OnTakeOffBtnClick(self)
  if not self.curHeroData or not self.equipData then
    return
  end
  local temp = {}
  table.insert(temp, self.equipData.slot)
  SFSNetwork.SendMessage(MsgDefines.HeroEquipUninstall, self.curHeroData.uuid, temp)
end

local function OnPromoteBtnClick(self)
  if not self.equipData then
    return
  end
  if not DataCenter.EquipDataManager:IsPromoteFunctionOpen() or not self.equipData:CanStartPromote() then
    return
  end
  if not DataCenter.EquipDataManager:CheckRedEquipOpen() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRedEquipLimitTip)
    return
  end
  local equipUuids = {}
  if self.equipUuids ~= nil then
    for _, v in ipairs(self.equipUuids) do
      local equipData = DataCenter.EquipDataManager:GetEquipByUuid(v)
      if equipData and equipData:CanStartPromote() then
        table.insert(equipUuids, v)
      end
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipPromote, {anim = false}, self.equipData.uuid, equipUuids)
end

local function OnGotoBuildingBtnClick(self)
  if CS.SceneManager:IsInPVE() then
    UIUtil.ShowTipsId("quick_upgrade_block_tips")
    return
  end
  GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_SMITH_SHOP, WorldTileBtnType.City_Upgrade)
end

local function RefreshReplaceBtnRedPoint(self)
  local showRedPoint = false
  if self.equipData ~= nil and DataCenter.EquipDataManager:HasBetterEquipBySlotAndHeroType(self.equipData.config.slot, self.equipData.config.heroType, self.equipData.power) then
    showRedPoint = true
  end
  self.replaceBtnRedPoint:SetActive(showRedPoint)
  self.showReplaceBtnRedPoint = showRedPoint
end

local function OnClickGold(self)
  if self.costResourceCount > self.haveResourceCount then
    if CS.SceneManager:IsInPVE() then
      UIUtil.ShowTipsId("quick_upgrade_tips")
      return
    end
    local data = {}
    table.insert(data, {
      resType = self.costResourceType,
      need = self.costResourceCount
    })
    LWResourceLackUtil:GotoResLack(data)
  end
end

local function OnClickStone(self)
  if self.costStoneCount > self.haveStoneCount then
    if CS.SceneManager:IsInPVE() then
      UIUtil.ShowTipsId("quick_upgrade_tips")
      return
    end
    LWResourceLackUtil:GotoResourceItemLack(ResourceItemId.EquipStrengtheningStone, self.costStoneCount)
  end
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "Panel")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.contentRoot = self:AddComponent(UIBaseContainer, "Root/ImgBg")
  self.equipNameText = self:AddComponent(UIText, "Root/EquipBasicInfo/EquipNameText")
  self.equipPowerText = self:AddComponent(UIText, "Root/EquipBasicInfo/EquipPowerGroup/PowerText")
  self.proeprtyList = self:AddComponent(UILoopListView2, "Root/AdditionProperty/PropertyScroll")
  self.proeprtyList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.propertyScroll = self:AddComponent(UIBaseContainer, "Root/AdditionProperty/PropertyScroll/Viewport/Content")
  self.upgradeCostGroup = self:AddComponent(UIBaseContainer, "Root/UpgradeCostGroup")
  self.costGold = self:AddComponent(UIButton, "Root/UpgradeCostGroup/CostGold")
  self.costGold:SetOnClick(BindCallback(self, OnClickGold))
  self.costGoldIcon = self:AddComponent(UIImage, "Root/UpgradeCostGroup/CostGold/GoldIcon")
  self.costGoldCountText = self:AddComponent(UIText, "Root/UpgradeCostGroup/CostGold/GoldCountText")
  self.costStone = self:AddComponent(UIButton, "Root/UpgradeCostGroup/CostStone")
  self.costStone:SetOnClick(BindCallback(self, OnClickStone))
  self.costStoneIcon = self:AddComponent(UIImage, "Root/UpgradeCostGroup/CostStone/StoneIcon")
  self.costStoneIcon:LoadSprite(DataCenter.ResourceItemDataManager:GetIconPath(ResourceItemId.EquipStrengtheningStone))
  self.costStoneCountText = self:AddComponent(UIText, "Root/UpgradeCostGroup/CostStone/StoneCountText")
  self.btnGroup = self:AddComponent(UIBaseContainer, "Root/BtnGroup")
  self.upgradeBtn = self:AddComponent(UIButton, "Root/BtnGroup/UpgradeBtn")
  self.upgradeBtnText = self:AddComponent(UIText, "Root/BtnGroup/UpgradeBtn/UpgradeBtnText")
  self.upgradeBtnRedPoint = self:AddComponent(UIImage, "Root/BtnGroup/UpgradeBtn/RedPoint")
  self.upgradeBtn:SetOnClick(BindCallback(self, OnUpgradeBtnClick))
  self.replaceBtn = self:AddComponent(UIButton, "Root/BtnGroup/ReplaceBtn")
  self.replaceBtnText = self:AddComponent(UIText, "Root/BtnGroup/ReplaceBtn/ReplaceBtnText")
  self.replaceBtnRedPoint = self:AddComponent(UIImage, "Root/BtnGroup/ReplaceBtn/ReplaceBtnRedPoint")
  self.replaceBtn:SetOnClick(BindCallback(self, OnReplaceBtnClick))
  self.takeOffBtn = self:AddComponent(UIButton, "Root/BtnGroup/TakeOffBtn")
  self.takeOffBtnText = self:AddComponent(UIText, "Root/BtnGroup/TakeOffBtn/TakeOffBtnText")
  self.takeOffBtn:SetOnClick(BindCallback(self, function()
    self:OnTakeOffBtnClick()
  end))
  self.imgArrow = self:AddComponent(UIImage, "Root/Arrow")
  self.basePropertyArea = self:AddComponent(UIBaseContainer, "Root/BasePropertyArea")
  self.basePropertyItems = {}
  for i = 1, 4 do
    local item = self:AddComponent(UIEquipBasicPropertyLineItem, "Root/BasePropertyArea/PropertyItem" .. i)
    item:SetActive(false)
    table.insert(self.basePropertyItems, item)
  end
  self.equipLevelText = self:AddComponent(UIText, "Root/EquipBasicInfo/EquipLevelText")
  self.promoteContainer = self:AddComponent(UIBaseContainer, "Root/BtnGroup/Promote")
  self.promoteBtn = self:AddComponent(UIButton, "Root/BtnGroup/Promote/PromoteBtn")
  self.promoteBtn:SetOnClick(BindCallback(self, OnPromoteBtnClick))
  self.promoteBtnRedPoint = self:AddComponent(UIImage, "Root/BtnGroup/Promote/PromoteBtn/PromoteBtnRedPoint")
  self.promoteNeedBuildingTip = self:AddComponent(UIText, "Root/BtnGroup/Promote/NeedBuildingTip")
  self.needBuildingLvSlider = self:AddComponent(UISlider, "Root/BtnGroup/Promote/NeedBuildingTip/BuildingLvSldierBg/BuildingLvSldier")
  self.needBuildingLvText = self:AddComponent(UIText, "Root/BtnGroup/Promote/NeedBuildingTip/BuildingLvSldierBg/BuildingLvText")
  self.gotoUpgradeBuildBtn = self:AddComponent(UIButton, "Root/BtnGroup/Promote/NeedBuildingTip/GotoUpgradeBuildBtn")
  self.gotoUpgradeBuildBtn:SetOnClick(BindCallback(self, OnGotoBuildingBtnClick))
  self.curEquipItem = self:AddComponent(BaseUIEquipItem, "Root/EquipBasicInfo/EquipItem")
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.needBuildingLvTipText = self:AddComponent(UIText, "Root/BtnGroup/Promote/NeedBuildingTip/NeedBuildingTipText")
  self.emptyAdditionPropertyText = self:AddComponent(UIText, "Root/AdditionProperty/EmptyAdditionPropertyText")
  self.leftArrow = self:AddComponent(UIButton, "Root/ChangeHeroArrow/ToPrevHeroArrow")
  self.leftArrow:SetOnClick(BindCallback(self, function()
    self:GotoNextPage(true)
  end))
  self.rightArrow = self:AddComponent(UIButton, "Root/ChangeHeroArrow/ToNextHeroArrow")
  self.rightArrow:SetOnClick(BindCallback(self, function()
    self:GotoNextPage(false)
  end))
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString(170001), nil, Localization:GetString(150010))
  end)
end

local function DataDefine(self)
  self.itemIndex = 0
  self.cells = {}
  self.showCostGroup = false
  self.showReplaceBtnRedPoint = false
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.root = nil
  self.contentRoot = nil
  self.equipNameText = nil
  self.equipPowerText = nil
  self.proeprtyList = nil
  self.propertyScroll = nil
  self.upgradeCostGroup = nil
  self.costGold = nil
  self.costGoldIcon = nil
  self.costGoldCountText = nil
  self.costStone = nil
  self.costStoneIcon = nil
  self.costStoneCountText = nil
  self.btnGroup = nil
  self.upgradeBtn = nil
  self.upgradeBtnText = nil
  self.upgradeBtnRedPoint = nil
  self.replaceBtn = nil
  self.replaceBtnText = nil
  self.replaceBtnRedPoint = nil
  self.reformBtn = nil
  self.reformBtnText = nil
  self.imgArrow = nil
  self.basePropertyArea = nil
  self.basePropertyItems = nil
  self.equipLevelText = nil
  self.promoteContainer = nil
  self.promoteBtn = nil
  self.promoteBtnRedPoint = nil
  self.promoteNeedBuildingTip = nil
  self.needBuildingLvSlider = nil
  self.needBuildingLvText = nil
  self.gotoUpgradeBuildBtn = nil
  self.curEquipItem = nil
  self.closeBtn = nil
  self.needBuildingLvTipText = nil
  self.emptyAdditionPropertyText = nil
  self.leftArrow = nil
  self.rightArrow = nil
end

local function DataDestroy(self)
  self.itemIndex = 0
  self.alignObject = nil
  self.cells = nil
  self.showCostGroup = false
  self.showReplaceBtnRedPoint = false
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  if self.equipData ~= nil then
    self:OnOpen()
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function RefreshCostCondition(self)
  if not self.showCostGroup then
    return
  end
  self.haveResourceCount = CommonUtil.GetResOrItemCount(self.costResourceType)
  self.haveStoneCount = DataCenter.ResourceItemDataManager:GetCountByItemId(ResourceItemId.EquipStrengtheningStone)
  local showRedPoint = true
  if self.costResourceCount > self.haveResourceCount then
    self.costGoldCountText:SetText(string.format("<color=#F53C3D>%s</color>/%s", string.GetFormattedStr(self.haveResourceCount), string.GetFormattedStr(self.costResourceCount)))
    showRedPoint = false
  else
    self.costGoldCountText:SetText(string.format("<color=#FFFFFF>%s</color>/%s", string.GetFormattedStr(self.haveResourceCount), string.GetFormattedStr(self.costResourceCount)))
  end
  if self.costStoneCount > self.haveStoneCount then
    self.costStoneCountText:SetText(string.format("<color=#F53C3D>%s</color>/%s", string.GetFormattedStr(self.haveStoneCount), string.GetFormattedStr(self.costStoneCount)))
    showRedPoint = false
  else
    self.costStoneCountText:SetText(string.format("<color=#FFFFFF>%s</color>/%s", string.GetFormattedStr(self.haveStoneCount), string.GetFormattedStr(self.costStoneCount)))
  end
  if self.showReplaceBtnRedPoint then
    showRedPoint = false
  end
  self.upgradeBtnRedPoint:SetActive(showRedPoint)
end

local function OnResOrItemUpdate(self)
  RefreshCostCondition(self)
  if self.equipData ~= nil and self.equipData:SupportPromote() and self.promoteBtn:GetActiveInHierarchy() then
    self.promoteBtnRedPoint:SetActive(self.equipData:CanPromote() and DataCenter.EquipDataManager:CheckRedEquipOpen())
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEquipInstall, self.OnBtnCloseClick)
  self:AddUIListener(EventId.HeroEquipUninstall, self.OnBtnCloseClick)
  self:AddUIListener(EventId.HeroEquipUpgrade, self.OnEquipUpgrade)
  self:AddUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  self:AddUIListener(EventId.HeorEquipPromote, self.OnEquipUpgrade)
  self:AddUIListener(EventId.ExitEquipPromote, self.OnEquipPromoteExit)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroEquipInstall, self.OnBtnCloseClick)
  self:RemoveUIListener(EventId.HeroEquipUninstall, self.OnBtnCloseClick)
  self:RemoveUIListener(EventId.HeroEquipUpgrade, self.OnEquipUpgrade)
  self:RemoveUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.HeorEquipPromote, self.OnEquipUpgrade)
  self:RemoveUIListener(EventId.ExitEquipPromote, self.OnEquipPromoteExit)
end

local function CreatePropertyDataList(self)
  self.baseWordData, self.allEquipWords = self.equipData:GetAllWordPropertiesSeperate()
  if self.allEquipWords == nil or #self.allEquipWords == 0 then
    self.proeprtyList:SetActive(false)
    self.emptyAdditionPropertyText:SetActive(true)
  else
    self.proeprtyList:SetActive(true)
    self.emptyAdditionPropertyText:SetActive(false)
    self.proeprtyList:SetListItemCount(#self.allEquipWords, false, false)
    self.proeprtyList:RefreshAllShownItem()
  end
  if self.baseWordData and not table.IsNullOrEmpty(self.baseWordData) then
    for i = 1, 4 do
      local baseWordData = self.baseWordData[i]
      if self.basePropertyItems[i] then
        self.basePropertyItems[i]:SetData(baseWordData, self.equipData)
      end
    end
    self.basePropertyArea:SetActive(true)
  else
    self.basePropertyArea:SetActive(false)
  end
end

local function RefreshShowData(self)
  if self.ctrl == nil then
    return
  end
  self.equipNameText:SetLocalText(self.equipData.config.name)
  self.equipPowerText:SetText(math.floor(self.equipData.power))
  if self.equipData.level < self.equipData.maxLevel then
    self.equipLevelText:SetText(string.format("%s: %s/%s", Localization:GetString(129251), self.equipData.level, self.equipData.maxLevel))
  else
    self.equipLevelText:SetText(string.format("%s:  %s", Localization:GetString(129251), self.equipData.level))
  end
  self.curEquipItem:SetData(self.equipData, nil, false, true, true)
  self.curEquipItem:ShowOwnerHero(self.equipData.heroUuid)
  self.replaceBtn:SetActive(self.showHeroRelatedBtn and self.curHeroData ~= nil)
  self.takeOffBtn:SetActive(self.showHeroRelatedBtn and self.curHeroData ~= nil)
  self.btnGroup:SetActive(true)
  local maxLevel = self.equipData.level
  if self.equipUpgradeTemplate ~= nil then
    maxLevel = self.equipUpgradeTemplate.maxLevel
  end
  if maxLevel <= self.equipData.level then
    self.upgradeCostGroup:SetActive(false)
    local equipCanPromote = self.equipData:SupportPromote()
    if equipCanPromote then
      self.upgradeBtn:SetActive(false)
      self.promoteContainer:SetActive(true)
      self.showCostGroup = false
      local needBuildingLv = LuaEntry.DataConfig:TryGetNum("equip_promote_unlock", "k1", 0)
      local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SMITH_SHOP)
      local buildLv = 0
      if build ~= nil then
        buildLv = build.level
      end
      if needBuildingLv <= buildLv then
        self.promoteBtn:SetActive(true)
        self.promoteBtnRedPoint:SetActive(self.equipData:CanPromote() and DataCenter.EquipDataManager:CheckRedEquipOpen())
        self.promoteNeedBuildingTip:SetActive(false)
        self:CheckRedEquipOpenGuide()
        local needGray = not DataCenter.EquipDataManager:CheckRedEquipOpen()
        UIGray.SetGray(self.promoteBtn.transform, needGray, true)
      else
        self.promoteBtn:SetActive(false)
        self.promoteNeedBuildingTip:SetActive(true)
        self.needBuildingLvTipText:SetLocalText(150008, needBuildingLv)
        self.needBuildingLvSlider:SetValue(buildLv / needBuildingLv)
        self.needBuildingLvText:SetText(string.format("%s/%s", buildLv, needBuildingLv))
      end
    else
      self.upgradeBtn:SetActive(true)
      UIGray.SetGray(self.upgradeBtn.transform, true, true)
      self.promoteContainer:SetActive(false)
      self.upgradeBtnText:SetLocalText(430738)
      self.upgradeBtnRedPoint:SetActive(false)
    end
  else
    self.upgradeBtn:SetActive(true)
    UIGray.SetGray(self.upgradeBtn.transform, false, true)
    self.promoteContainer:SetActive(false)
    self.upgradeBtnText:SetLocalText(151049)
    self.upgradeCostGroup:SetActive(true)
    self.showCostGroup = true
    RefreshCostCondition(self)
  end
  CreatePropertyDataList(self)
end

local function OnEquipUpgrade(self, uuid)
  if self.equipData.uuid ~= uuid then
    return
  end
  self.equipData = DataCenter.EquipDataManager:GetEquipByUuid(self.equipDataUuid)
  for k, v in pairs(self.basePropertyItems) do
    v.equipPropEffect:SetActive(false)
    v.equipPropEffect:SetActive(true)
  end
  RefreshUpgradeTemplateData(self)
  RefreshReplaceBtnRedPoint(self)
  RefreshShowData(self)
end

local function UpdateView(self)
  RefreshUpgradeTemplateData(self)
  RefreshReplaceBtnRedPoint(self)
  RefreshShowData(self)
end

local function OnOpen(self)
  UpdateView(self)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnEquipPromoteExit(self, equipUuid)
  if self.equipData and self.equipData.uuid == equipUuid then
    return
  end
  local index
  for i, v in ipairs(self.equipUuids) do
    if v == equipUuid then
      index = i
      break
    end
  end
  if index then
    self:GotoPage(index)
  end
end

local function RefreshArrows(self)
  self.leftArrow:SetActive(self.index > 1)
  self.rightArrow:SetActive(self.index < #self.equipUuids)
end

local function GotoPage(self, pageId)
  if not pageId then
    return
  end
  if not self.equipUuids[pageId] then
    return
  end
  self.equipDataUuid = self.equipUuids[pageId]
  local equipData = DataCenter.EquipDataManager:GetEquipByUuid(self.equipDataUuid)
  if not equipData then
    return
  end
  self.equipData = equipData
  if self.equipData.heroUuid and self.equipData.heroUuid > 0 then
    self.curHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.equipData.heroUuid)
  else
    self.curHeroData = nil
  end
  EventManager:GetInstance():Broadcast(EventId.EquipDetailChangePage, self.equipData.uuid)
  self.index = pageId
  UpdateView(self)
  RefreshArrows(self)
end

local function CheckRedEquipOpenGuide(self)
  if not DataCenter.EquipDataManager:CheckRedEquipOpen() then
    return
  end
  if DataCenter.LWGuideFlowManager.Runner:IsRun() then
    return
  end
  local guideId = LuaEntry.DataConfig:TryGetNum("red_equip_open", "k2")
  if not DataCenter.LWGuideFlowManager:ReadDone(guideId) then
    DataCenter.LWGuideFlowManager.Runner:Run(guideId)
  end
end

local function GotoNextPage(self, isLeft)
  if isLeft and self.index <= 1 then
    return
  end
  if not isLeft and self.index >= #self.equipUuids then
    return
  end
  local pageId = self.index
  local stride = isLeft and -1 or 1
  GotoPage(self, pageId + stride)
end

UIHeroEquipDetailPanelView.OnCreate = OnCreate
UIHeroEquipDetailPanelView.OnDestroy = OnDestroy
UIHeroEquipDetailPanelView.OnEnable = OnEnable
UIHeroEquipDetailPanelView.OnDisable = OnDisable
UIHeroEquipDetailPanelView.OnAddListener = OnAddListener
UIHeroEquipDetailPanelView.OnRemoveListener = OnRemoveListener
UIHeroEquipDetailPanelView.ComponentDefine = ComponentDefine
UIHeroEquipDetailPanelView.DataDefine = DataDefine
UIHeroEquipDetailPanelView.ComponentDestroy = ComponentDestroy
UIHeroEquipDetailPanelView.DataDestroy = DataDestroy
UIHeroEquipDetailPanelView.OnOpen = OnOpen
UIHeroEquipDetailPanelView.OnBtnCloseClick = OnBtnCloseClick
UIHeroEquipDetailPanelView.OnEquipUpgrade = OnEquipUpgrade
UIHeroEquipDetailPanelView.OnTakeOffBtnClick = OnTakeOffBtnClick
UIHeroEquipDetailPanelView.OnPromoteBtnClick = OnPromoteBtnClick
UIHeroEquipDetailPanelView.OnGotoBuildingBtnClick = OnGotoBuildingBtnClick
UIHeroEquipDetailPanelView.OnEquipPromoteExit = OnEquipPromoteExit
UIHeroEquipDetailPanelView.GotoNextPage = GotoNextPage
UIHeroEquipDetailPanelView.GotoPage = GotoPage
UIHeroEquipDetailPanelView.CheckRedEquipOpenGuide = CheckRedEquipOpenGuide
return UIHeroEquipDetailPanelView
