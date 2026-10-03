local base = UIBaseContainer
local TacticalChipFactoryBagPage = BaseClass("TacticalChipFactoryBagPage", UIBaseContainer)
local TacticalChipItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipItem")
local UICommonOptionControl = require("UI.UICommonOptionControl.UICommonOptionControl")
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local Localization = CS.GameEntry.Localization

function TacticalChipFactoryBagPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitOption()
  self:InitTab()
end

function TacticalChipFactoryBagPage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalChipFactoryBagPage:OnEnable()
  base.OnEnable(self)
end

function TacticalChipFactoryBagPage:OnDisable()
  base.OnDisable(self)
end

function TacticalChipFactoryBagPage:ComponentDefine()
  self.compChipListNode = self:AddComponent(UIBaseContainer, "chipListNode")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "chipListNode/ItemHolder")
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.compItemContent = self:AddComponent(UIBaseContainer, "chipListNode/ItemHolder/Viewport/ItemContent")
  self.textNoChipTip = self:AddComponent(UIText, "chipListNode/noChipTip")
  self.textNoChipTip:SetLocalText("battlesystem_factory_inventory_desc1")
  self.compTabAll = self:AddComponent(UICommonTab, "chipListNode/tabRoot/tabAll")
  self.compTabTank = self:AddComponent(UICommonTab, "chipListNode/tabRoot/tabTank")
  self.compTabMissile = self:AddComponent(UICommonTab, "chipListNode/tabRoot/tabMissile")
  self.compTabAir = self:AddComponent(UICommonTab, "chipListNode/tabRoot/tabAir")
  self.compOptionControl = self:AddComponent(UICommonOptionControl, "chipListNode/optionControl")
  self.btnBattleSystem = self:AddComponent(UIButton, "Bottom/battleSystemBtn")
  self.btnBattleSystem:SetOnClick(function()
    self:OnBtnBattleSystemClick()
  end)
  self.textBattleSystemBtn = self:AddComponent(UIText, "Bottom/battleSystemBtn/Btn/battleSystemBtnText")
  self.textBattleSystemBtn:SetLocalText("battlesystem_factory_inventory_button1")
  self.btnChipReset = self:AddComponent(UIButton, "Bottom/chipResetBtn")
  self.btnChipReset:SetOnClick(function()
    self:OnBtnChipResetClick()
  end)
  self.btnChipExchange = self:AddComponent(UIButton, "Bottom/chipExchangeBtn")
  self.btnChipExchange:SetOnClick(function()
    self:OnBtnChipExchangeClick()
  end)
end

function TacticalChipFactoryBagPage:ComponentDestroy()
  if self.compItemContent then
    self.compItemContent:RemoveComponents(TacticalChipItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.compChipListNode = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.textNoChipTip = nil
  self.compTabAll = nil
  self.compTabTank = nil
  self.compTabMissile = nil
  self.compTabAir = nil
  self.compOptionControl = nil
  self.btnBattleSystem = nil
  self.textBattleSystemBtn = nil
  self.btnChipReset = nil
  self.btnChipExchange = nil
end

function TacticalChipFactoryBagPage:DataDefine()
end

function TacticalChipFactoryBagPage:DataDestroy()
  if self.curTab then
    self.curTab:SetSelect(false)
    self.curTab = nil
  end
  self.chipsDataList = nil
end

function TacticalChipFactoryBagPage:ReInit(buildingUuid)
  if self.curTab == nil then
    self:OnTabClick(self.compTabAll)
  else
    self:RefreshDataList()
  end
end

function TacticalChipFactoryBagPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnChipDataRefresh)
  self:AddUIListener(EventId.TWSkillChipStarUp, self.OnChipDataRefresh)
end

function TacticalChipFactoryBagPage:OnRemoveListener()
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnChipDataRefresh)
  self:RemoveUIListener(EventId.TWSkillChipStarUp, self.OnChipDataRefresh)
  base.OnRemoveListener(self)
end

function TacticalChipFactoryBagPage:OnChipDataRefresh()
  self:RefreshDataList()
end

function TacticalChipFactoryBagPage:InitTab()
  local tabAllParam = {}
  tabAllParam.tabId = HeroType.All
  tabAllParam.title = Localization:GetString("uav_chips_desc20")
  tabAllParam.clickHandler = self.OnTabClick
  self.compTabAll:ReInit(tabAllParam)
  self.compTabAll:SetSelect(false)
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
end

function TacticalChipFactoryBagPage:InitOption()
  local param = {}
  param.defaultOptionId = TacticalChipBagSortType.ChipType
  param.optionParamList = self:GetOptionParamList()
  param.optionClickHandler = self.OnOptionClick
  param.optionPrefabPath = UIAssets.TacticalChipBagSortOptionItem
  param.initCompleteHandler = self.OnOptionCtrlInitComplete
  self.compOptionControl:ReInit(param)
end

function TacticalChipFactoryBagPage:RefreshDataList()
  if self.curTab == nil or self.compOptionControl == nil then
    return
  end
  local sortType = self.compOptionControl:GetCurOptionId()
  local chipType = self.curTab.tabId
  self.chipsDataList = DataCenter.TacticalChipFactoryManager:GetChipsData(chipType, sortType)
  local dataCount = 0
  if self.chipsDataList then
    dataCount = #self.chipsDataList
  end
  self.loopGridViewItemHolder:SetActive(0 < dataCount)
  self.textNoChipTip:SetActive(dataCount <= 0)
  self.loopGridViewItemHolder:SetListItemCount(dataCount)
  self.loopGridViewItemHolder:RefreshAllShownItem()
end

function TacticalChipFactoryBagPage:OnGetItemByRowColumn(loopScroll, index)
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
      script:SetOnClickChipInfo(function(chipInfo)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo)
      end)
    end
    script:SetActive(true)
    local data = self.chipsDataList[index]
    script:SetCountVisible(true)
    script:SetPlanMasterVisible(true)
    script:SetData(data)
    script:SetChipTypeVisible(true)
    return item
  end
end

function TacticalChipFactoryBagPage:OnTabClick(tabItem)
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

function TacticalChipFactoryBagPage:OnOptionClick(optionItem)
  self:RefreshDataList()
  self.compOptionControl:CloseOptionList()
end

function TacticalChipFactoryBagPage:OnOptionCtrlInitComplete()
  self:OnTabClick(self.compTabAll)
end

function TacticalChipFactoryBagPage:GetOptionParamList()
  local paramList = {}
  table.insert(paramList, {
    tabId = TacticalChipBagSortType.ChipType,
    title = Localization:GetString("uav_chips_desc7")
  })
  table.insert(paramList, {
    tabId = TacticalChipBagSortType.Star,
    title = Localization:GetString("uav_chips_desc8")
  })
  table.insert(paramList, {
    tabId = TacticalChipBagSortType.Quality,
    title = Localization:GetString("uav_chips_desc10")
  })
  return paramList
end

function TacticalChipFactoryBagPage:OnBtnBattleSystemClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, TacticalWeaponPageType.SkillChip)
end

function TacticalChipFactoryBagPage:OnBtnChipResetClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSkillChipReset, {anim = true})
end

function TacticalChipFactoryBagPage:OnBtnChipExchangeClick()
end

return TacticalChipFactoryBagPage
