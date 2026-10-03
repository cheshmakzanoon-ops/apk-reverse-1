local UIGainDiamonds = require("UI.UIGiftPackage.Component.UIGainDiamonds")
local GiftPackagePagePanel = require("UI.UIGiftPackage.Component.GiftPackagePagePanel")
local WeeklyPackageMain = require("UI.UIGiftPackage.Component.WeeklyPackage.WeeklyPackageMain")
local WeeklyPackageNewMain = require("UI.UIGiftPackage.Component.WeeklyPackageNew.WeeklyPackageNewMain")
local WeekCardMain = require("UI.UIGiftPackage.Component.WeekCard.WeekCardMain")
local HeroMedalPackageMain = require("UI.UIGiftPackage.Component.HeroMedal.HeroMedalPackageMain")
local UIGolloesMonthCardPanel = require("UI.UIGiftPackage.Component.UIGolloesMonthCardPanel")
local UIRobotPackPanel = require("UI.UIGiftPackage.Component.UIRobotPackPanel")
local UIGiftTypeButton = require("UI.UIGiftPackage.Component.UIGiftTypeButton")
local UIPiggyBankPanel = require("UI.UIGiftPackage.Component.UIPiggyBankPanel")
local UIEnergyBankPanel = require("UI.UIGiftPackage.Component.UIEnergyBankPanel")
local UIGrowthPlanPanel = require("UI.UIGiftPackage.Component.UIGrowthPlanPanel")
local UIScrollPackPanel = require("UI.UIGiftPackage.Component.UIScrollPackPanel")
local HeroMonthCardPanel = require("UI.UIGiftPackage.Component.HeroMonthCard.HeroMonthCardMain")
local CumulativeRecharge = require("UI.UIGiftPackage.Component.CumulativeRecharge")
local DailyPackage = require("UI.UIGiftPackage.Component.DailyPackage")
local UIGiftPackagePopUpView = BaseClass("UIGiftPackagePopUpView", UIBaseView)
local base = UIBaseView
local ResetPosition = Vector3.New(6, 0, 0)
local panel_path = "safeArea/List/"
local gift_type_button_path = "CellGo"
local scroll_view_path = "safeArea/ButtonList"
local btn_path = "safeArea/BtnReturn"
local gift_type_button_select_path = "CellGo/TypeButtonSelectImage"
local _cpGold_path = "safeArea/goldObj"
local _cp_goldNum = "safeArea/goldObj/goldNum"
local weeklyPackageIemContainer_path = "weeklyPackageItemsContainer"
local subPanelContainer_path = "safeArea/List"
local Param = DataClass("Param", ParamData)
local ParamData = {
  showMainType,
  showSubType,
  goldExchangeId
}
local PanelEnum = {
  GainDiamonds = "UIGainDiamonds",
  GiftPackagePagePanel = "GiftPackagePagePanel",
  RobotPackPanel = "UIRobotPackPanel",
  WeeklyPackagePanel = "UIweeklyPackage",
  WeeklyPackageNewPanel = "WeeklyPackageNewPanel",
  WeekCardPanel = "WeekCardPanel",
  HeroMedalPackagePanel = "HeroMedalPackagePanel",
  GolloesMonthCardPanel = "UIGolloesMonthCardPanel",
  PiggyBankPanel = "UIPiggyBankPanel",
  EnergyBankPanel = "UIEnergyBankPanel",
  GrowthPlanPanel = "UIGrowthPlanPanel",
  ScrollPackPanel = "UIScrollPackPanel",
  HeroMonthCardPanel = "HeroMonthCardMain",
  CumulativeRecharge = "CumulativeRecharge",
  DailyPackage = "DailyPackage"
}
local PanelConf = {
  [PanelEnum.GainDiamonds] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/UIGainDiamonds.prefab",
    Script = UIGainDiamonds,
    Container = "UIGainDiamonds"
  },
  [PanelEnum.GiftPackagePagePanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/GiftPackagePagePanel.prefab",
    Script = GiftPackagePagePanel,
    Container = "GiftPackagePagePanel"
  },
  [PanelEnum.RobotPackPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/UIRobotPackPanel.prefab",
    Script = UIRobotPackPanel,
    Container = "UIRobotPackPanel"
  },
  [PanelEnum.WeeklyPackagePanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/WeeklyPackageMain.prefab",
    Script = WeeklyPackageMain,
    Container = "UIweeklyPackage"
  },
  [PanelEnum.WeeklyPackageNewPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/WeeklyPackageNew/WeeklyPackageNewMain.prefab",
    Script = WeeklyPackageNewMain,
    Container = "WeeklyPackageNewPanel"
  },
  [PanelEnum.WeekCardPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/WeekCard/WeekCardMain.prefab",
    Script = WeekCardMain,
    Container = "WeekCardPanel"
  },
  [PanelEnum.HeroMedalPackagePanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/HeroMedalPackageMain.prefab",
    Script = HeroMedalPackageMain,
    Container = "HeroMedalPackagePanel"
  },
  [PanelEnum.GolloesMonthCardPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/UIGolloesMonthCardPanel.prefab",
    Script = UIGolloesMonthCardPanel,
    Container = "UIGolloesMonthCardPanel"
  },
  [PanelEnum.PiggyBankPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/UIPiggyBankPanel.prefab",
    Script = UIPiggyBankPanel,
    Container = "UIPiggyBankPanel"
  },
  [PanelEnum.EnergyBankPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/UIEnergyBankPanel.prefab",
    Script = UIEnergyBankPanel,
    Container = "UIEnergyBankPanel"
  },
  [PanelEnum.GrowthPlanPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/GrowthPlan/UIGrowthPlanPanel.prefab",
    Script = UIGrowthPlanPanel,
    Container = "UIGrowthPlanPanel"
  },
  [PanelEnum.ScrollPackPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/UIScrollPackPanel.prefab",
    Script = UIScrollPackPanel,
    Container = "UIScrollPackPanel"
  },
  [PanelEnum.HeroMonthCardPanel] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/HeroMonthCardMain.prefab",
    Script = HeroMonthCardPanel,
    Container = "HeroMonthCardMain"
  },
  [PanelEnum.CumulativeRecharge] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/CumulativeRecharge.prefab",
    Script = CumulativeRecharge,
    Container = "CumulativeRecharge"
  },
  [PanelEnum.DailyPackage] = {
    Asset = "Assets/Main/Prefabs/UI/GiftPackage/DailyPackage/DailyPackage.prefab",
    Script = DailyPackage,
    Container = "DailyPackage"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local userdata = self:GetUserData()
  self.userdata = userdata or {}
  self.curWelfareType = userdata and userdata.welfareTagType and userdata.welfareTagType or WelfareTagType.PackStore
  self.targetShowType = userdata and userdata.targetShowType or nil
  self.targetPackageId = userdata and userdata.targetPackageId or nil
  self:ReInit()
end

local function OnDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.RefreshGoldStoreRed)
  self:SetPanelActive()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.cell_go = self:AddComponent(UIBaseContainer, gift_type_button_path)
  self.gift_type_button_select = self:AddComponent(UIBaseContainer, gift_type_button_select_path).transform
  self._goldNum = self:AddComponent(UIText, _cp_goldNum)
  self._cpGold = self:AddComponent(UIBaseContainer, _cpGold_path)
  self.weeklyPackageItemsContainer = self:AddComponent(UIBaseContainer, weeklyPackageIemContainer_path)
  self.weeklyPackageItemsContainer:SetActive(false)
  self.panels = {}
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.gift_type_button_select:SetParent(self.cell_go.transform)
  self.cell_go = nil
  self.gift_type_button_select = nil
  self.scroll_view = nil
  self.panels = nil
end

local function DataDefine(self)
  self.showMainType = ""
  self.showSubType = ""
  self.goldExchangeId = ""
  self.welfarelist = {}
  self.curTypeButtonId = nil
  self.showButtonType = nil
  self.selectTypeIndex = nil
  self.typeCells = {}
  self.curWelfareType = nil
  self.curRechargeId = nil
end

local function DataDestroy(self)
  self.showMainType = nil
  self.showSubType = nil
  self.goldExchangeId = nil
  self.welfarelist = nil
  self.curTypeButtonId = nil
  self.showButtonType = nil
  self.selectTypeIndex = nil
  self.typeCells = nil
  self.curWelfareType = nil
  self.curRechargeId = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
  self:AddUIListener(EventId.UpdateGold, self.SetGoldNum)
  self:AddUIListener(EventId.RefreshWelfareRedDot, self.OnRefreshWelfareRedDot)
  self:AddUIListener(EventId.GoGiftPackagePop, self.GotoButtonType)
  self:AddUIListener(EventId.FreeWeeklyPackage, self.DailyPackageFree)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
  self:RemoveUIListener(EventId.UpdateGold, self.SetGoldNum)
  self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.OnRefreshWelfareRedDot)
  self:RemoveUIListener(EventId.GoGiftPackagePop, self.GotoButtonType)
  self:RemoveUIListener(EventId.FreeWeeklyPackage, self.DailyPackageFree)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  if self.targetPackageId ~= nil then
    local targetPack = GiftPackManager.get(self.targetPackageId)
    if targetPack then
      local rechargeLine = targetPack:getRechargeLineData()
      if rechargeLine then
        self.curRechargeId = rechargeLine.id
        self.curWelfareType = rechargeLine.type
      elseif targetPack:IsWeeklyPackage() then
        self.curWelfareType = WelfareTagType.WeeklyPackage
      elseif targetPack:IsWeeklyPackageNew() then
        self.curWelfareType = WelfareTagType.WeeklyPackageNew
      end
    end
  end
  self:ShowTypeButton()
  self:SetGoldNum()
  if self.curWelfareType ~= nil then
    for index, v in ipairs(self.welfarelist) do
      if self.curWelfareType == v:getType() then
        local toIndex = math.max(index - 2, 1)
        self.scroll_view:ScrollToCell(toIndex, 2000)
        break
      end
    end
  end
end

local function SetGoldNum(self)
  self._goldNum:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

local function GotoButtonType(self, type)
  for index, v in ipairs(self.welfarelist) do
    if type == v:getType() then
      local toIndex = math.max(index - 2, 1)
      self.curWelfareType = v:getType()
      self.scroll_view:ScrollToCell(toIndex, 2000)
      self.typeCells[index]:SetSelect(true)
      self.typeCells[index]:OnClick()
      break
    end
  end
end

local function OnUpdateGiftPackData(self)
  if not self.ctrl then
    return
  end
  if self.curWelfareType == WelfareTagType.GrowthPlan then
    self:ShowGrowthPlanPanel()
  elseif self.curWelfareType == WelfareTagType.PackStore then
    self:ShowGiftPanel()
  elseif self.curWelfareType == WelfareTagType.WeeklyPackageNew or self.curWelfareType == WelfareTagType.WeeklyPackage or self.curWelfareType == WelfareTagType.HeroMedalPackage then
  elseif self.curWelfareType == WelfareTagType.ScrollPack then
    self:ShowScrollPackPanel()
  elseif self.curWelfareType == WelfareTagType.HeroMonthCardNew then
    self:ShowHeroMonthCardPanel()
  elseif self.curWelfareType == WelfareTagType.DailyPackage then
    self:ShowDailyPackagePanel()
  elseif self.curWelfareType == WelfareTagType.WeekCard then
    self:ShowWeekCardPanel()
  else
    self.ctrl:CloseSelf()
  end
  self:OnRefreshWelfareRedDot()
end

local function ShowGiftPanel(self)
  self:SetPanelActive(PanelEnum.GiftPackagePagePanel)
  if self.panels[PanelEnum.GiftPackagePagePanel] then
    local param = GiftPackagePagePanel.Param.New()
    param.showMainType = self.showMainType
    param.showSubType = self.showSubType
    param.goldExchangeId = self.goldExchangeId
    param.welfareTagType = self.curWelfareType
    param.targetShowType = self.targetShowType
    param.targetPackageId = self.targetPackageId
    self.targetShowType = nil
    self.targetPackageId = nil
    
    function param.callBack()
      self:CallBackActive()
    end
    
    self.panels[PanelEnum.GiftPackagePagePanel]:ReInit(param)
  else
    self:LoadPanel(PanelEnum.GiftPackagePagePanel)
  end
end

local function ShowWeeklyPackagePanel(self)
  self:SetPanelActive(PanelEnum.WeeklyPackagePanel)
  if self.panels[PanelEnum.WeeklyPackagePanel] then
    self.panels[PanelEnum.WeeklyPackagePanel]:ReInit(self.targetPackageId)
    self.targetPackageId = nil
  else
    self:LoadPanel(PanelEnum.WeeklyPackagePanel)
  end
end

local function ShowWeeklyPackageNewPanel(self)
  self:SetPanelActive(PanelEnum.WeeklyPackageNewPanel)
  if self.panels[PanelEnum.WeeklyPackageNewPanel] then
    self.panels[PanelEnum.WeeklyPackageNewPanel]:ReInit(self.targetPackageId)
    self.targetPackageId = nil
  else
    self:LoadPanel(PanelEnum.WeeklyPackageNewPanel)
  end
end

local function ShowWeekCardPanel(self)
  self:SetPanelActive(PanelEnum.WeekCardPanel)
  if self.panels[PanelEnum.WeekCardPanel] then
    self.panels[PanelEnum.WeekCardPanel]:ReInit()
    self.targetPackageId = nil
  else
    self:LoadPanel(PanelEnum.WeekCardPanel)
  end
end

local function ShowHeroMedalPackagePanel(self)
  self:SetPanelActive(PanelEnum.HeroMedalPackagePanel)
  if self.panels[PanelEnum.HeroMedalPackagePanel] then
    self.panels[PanelEnum.HeroMedalPackagePanel]:ReInit()
  else
    self:LoadPanel(PanelEnum.HeroMedalPackagePanel)
  end
end

local function ShowGolloesMonthCardPanel(self, tempData)
  self:SetPanelActive(PanelEnum.GolloesMonthCardPanel)
  if self.panels[PanelEnum.GolloesMonthCardPanel] then
    local param = {}
    param.monthCardInfo = tempData
    
    function param.callBack()
      self:CallBackActive()
    end
    
    self.panels[PanelEnum.GolloesMonthCardPanel]:ReInit(param, self)
  else
    self:LoadPanel(PanelEnum.GolloesMonthCardPanel)
  end
end

local function ShowPremiumPackPanel(self)
  self:SetPanelActive(PanelEnum.GiftPackagePagePanel)
  if self.panels[PanelEnum.GiftPackagePagePanel] then
    local param = GiftPackagePagePanel.Param.New()
    param.showMainType = self.showMainType
    param.showSubType = self.showSubType
    param.goldExchangeId = self.goldExchangeId
    param.welfareTagType = self.curWelfareType
    
    function param.callBack()
      self:CallBackActive()
    end
    
    self.panels[PanelEnum.GiftPackagePagePanel]:ReInit(param)
  else
    self:LoadPanel(PanelEnum.GiftPackagePagePanel)
  end
end

local function ShowRobotPackPanel(self, data)
  self:SetPanelActive(PanelEnum.RobotPackPanel)
  if self.panels[PanelEnum.RobotPackPanel] then
    self.panels[PanelEnum.RobotPackPanel]:ReInit(data, self)
  else
    self:LoadPanel(PanelEnum.RobotPackPanel)
  end
end

local function ShowPiggyBankPanel(self)
  self:SetPanelActive(PanelEnum.PiggyBankPanel)
  if self.panels[PanelEnum.PiggyBankPanel] then
    self.panels[PanelEnum.PiggyBankPanel]:ReInit(self)
  else
    self:LoadPanel(PanelEnum.PiggyBankPanel)
  end
end

local function ShowEnergyBankPanel(self)
  self:SetPanelActive(PanelEnum.EnergyBankPanel)
  if self.panels[PanelEnum.EnergyBankPanel] then
    self.panels[PanelEnum.EnergyBankPanel]:ReInit(self)
  else
    self:LoadPanel(PanelEnum.EnergyBankPanel)
  end
end

local function ShowGrowthPlanPanel(self)
  self:SetPanelActive(PanelEnum.GrowthPlanPanel)
  if self.panels[PanelEnum.GrowthPlanPanel] then
    self.panels[PanelEnum.GrowthPlanPanel]:ReInit(self)
  else
    self:LoadPanel(PanelEnum.GrowthPlanPanel)
  end
end

local function ShowHeroMonthCardPanel(self)
  self:SetPanelActive(PanelEnum.HeroMonthCardPanel)
  if self.panels[PanelEnum.HeroMonthCardPanel] then
    self.panels[PanelEnum.HeroMonthCardPanel]:ReInit(true)
  else
    self:LoadPanel(PanelEnum.HeroMonthCardPanel)
  end
end

local function ShowCumulativeRechargePanel(self)
  self:SetPanelActive(PanelEnum.CumulativeRecharge)
  if self.panels[PanelEnum.CumulativeRecharge] then
    self.panels[PanelEnum.CumulativeRecharge]:ReInit(self.welfarelist)
  else
    self:LoadPanel(PanelEnum.CumulativeRecharge)
  end
end

local function ShowScrollPackPanel(self)
  self:SetPanelActive(PanelEnum.ScrollPackPanel)
  if self.panels[PanelEnum.ScrollPackPanel] then
    self.panels[PanelEnum.ScrollPackPanel]:ReInit(self, self.curRechargeId, self.targetPackageId)
  else
    self:LoadPanel(PanelEnum.ScrollPackPanel)
  end
end

local function ShowDailyPackagePanel(self)
  self:SetPanelActive(PanelEnum.DailyPackage)
  if self.panels[PanelEnum.DailyPackage] then
    self.panels[PanelEnum.DailyPackage]:ReInit(self.welfarelist)
  else
    self:LoadPanel(PanelEnum.DailyPackage)
  end
end

local function DailyPackageFree(self)
  if self.panels[PanelEnum.DailyPackage] then
    self.panels[PanelEnum.DailyPackage]:RefreshTop()
  end
end

local function LoadPanel(self, targetPanel)
  local tempConf = PanelConf[targetPanel]
  if not self.panels[targetPanel] then
    if not self.panelModels then
      self.panelModels = {}
    end
    local assetPath = tempConf.Asset
    self.panelModels[targetPanel] = self:GameObjectInstantiateAsync(assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(false)
      local tempContainer = self:AddComponent(UIBaseContainer, string.format("safeArea/List/%s", tempConf.Container))
      go.transform:SetParent(tempContainer.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = targetPanel
      local cell = tempContainer:AddComponent(tempConf.Script, go.name)
      self.panels[targetPanel] = cell
      self:ShowClickTypeButtonList()
    end)
  end
end

local function ClearScroll(self)
  self.typeCells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIGiftTypeButton)
end

local function ShowTypeButton(self)
  self.welfarelist = self.ctrl:GetTypeButtonList()
  self:ClearScroll()
  local count = #self.welfarelist
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIGiftTypeButton, itemObj)
  local param = UIGiftTypeButton.Param.New()
  param.welfare_data = self.welfarelist[index]
  
  function param.callBack(trans, welfareType, rechargeId, cellIndex)
    self:TypeButtonCallBack(trans, welfareType, rechargeId, cellIndex)
  end
  
  if self.selectTypeIndex == nil and self.curWelfareType == param.welfare_data:getType() then
    local select = true
    if self.curRechargeId ~= nil then
      select = self.curRechargeId == param.welfare_data:getID()
    end
    if select then
      param.needClick = true
      self.selectTypeIndex = index
      self.curWelfareType = nil
      self.curRechargeId = nil
    end
  else
    param.needClick = false
  end
  param.index = index
  param.redDotNum = self.welfarelist[index]:getRedDotNum()
  cellItem:ReInit(param)
  self.typeCells[index] = cellItem
end

local function OnDeleteCell(self, itemObj, index)
  self.typeCells[index] = nil
  if self.selectTypeIndex == index then
    self.gift_type_button_select:SetParent(self.cell_go.transform)
    self.selectTypeIndex = nil
  end
  self.scroll_view:RemoveComponent(itemObj.name, UIGiftTypeButton)
end

local function TypeButtonCallBack(self, trans, wTagType, rechargeId, cellIndex)
  if self.curWelfareType ~= wTagType or self.curRechargeId ~= rechargeId then
    self:SetTypeSelect(self.selectTypeIndex, false)
    self.selectTypeIndex = cellIndex
    self:SetTypeSelect(cellIndex, true)
    self.curWelfareType = wTagType
    self.curRechargeId = rechargeId
    self.gift_type_button_select:SetParent(trans)
    self.gift_type_button_select:SetSiblingIndex(1)
    self.gift_type_button_select:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.gift_type_button_select:Set_localScale(1, 1, 1)
    self:ShowClickTypeButtonList()
    EventManager:GetInstance():Broadcast(EventId.CacheGoldStoreOpenType, self.curWelfareType)
  end
end

local function ShowClickTypeButtonList(self)
  self._cpGold:SetActive(true)
  if self.curWelfareType == WelfareTagType.PackStore then
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = self.userdata.goldExchangeId or ""
    self:ShowGiftPanel()
  elseif self.curWelfareType == WelfareTagType.WeeklyPackage then
    self.showMainType = ""
    self.showSubType = ""
    self:ShowWeeklyPackagePanel()
  elseif self.curWelfareType == WelfareTagType.WeeklyPackageNew then
    self.showMainType = ""
    self.showSubType = ""
    self:ShowWeeklyPackageNewPanel()
  elseif self.curWelfareType == WelfareTagType.WeekCard then
    self.showMainType = ""
    self.showSubType = ""
    self:ShowWeekCardPanel()
  elseif self.curWelfareType == WelfareTagType.HeroMedalPackage then
    self.showMainType = ""
    self.showSubType = ""
    self:ShowHeroMedalPackagePanel()
  elseif self.curWelfareType == WelfareTagType.PremiumPack then
    self.showMainType = ""
    self.showSubType = ""
    self:ShowPremiumPackPanel()
  elseif self.curWelfareType == WelfareTagType.RobotPack then
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = self.userdata.goldExchangeId or ""
    local dataList = GiftPackageData.getRobotPacksByRechargeId(self.curRechargeId)
    if dataList ~= nil and 0 < #dataList then
      local data = dataList[1]
      self:ShowRobotPackPanel(data)
    end
  elseif self.curWelfareType == WelfareTagType.MonthCard then
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = self.userdata.goldExchangeId or ""
    local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
    self:ShowGolloesMonthCardPanel(golloesMonthCard)
  elseif self.curWelfareType == WelfareTagType.PiggyBank then
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = self.userdata.goldExchangeId or ""
    self:ShowPiggyBankPanel()
  elseif self.curWelfareType == WelfareTagType.EnergyBank then
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = self.userdata.goldExchangeId or ""
    self:ShowEnergyBankPanel()
  elseif self.curWelfareType == WelfareTagType.GrowthPlan then
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = self.userdata.goldExchangeId or ""
    self:ShowGrowthPlanPanel()
  elseif self.curWelfareType == WelfareTagType.ScrollPack then
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = self.userdata.goldExchangeId or ""
    self:ShowScrollPackPanel()
  elseif self.curWelfareType == WelfareTagType.HeroMonthCardNew then
    self.showMainType = ""
    self.showSubType = ""
    self:ShowHeroMonthCardPanel()
  elseif self.curWelfareType == WelfareTagType.CumulativeRecharge then
    self.showMainType = ""
    self.showSubType = ""
    self:ShowCumulativeRechargePanel()
  elseif self.curWelfareType == WelfareTagType.DailyPackage then
    self.showMainType = ""
    self.showSubType = ""
    self:ShowDailyPackagePanel()
  else
    self.showMainType = ""
    self.showSubType = ""
    self:ShowGiftPanel()
  end
end

local function SetPanelActive(self, panel)
  for k, v in pairs(self.panels) do
    v:SetActive(k == panel)
  end
end

local function CallBackActive(self, rechargeId)
  if self.welfareTagType == WelfareTagType.PremiumPack or self.welfareTagType == WelfareTagType.PackStore then
    self:SetPanelActive(PanelEnum.GiftPackagePagePanel)
  elseif self.welfareTagType == WelfareTagType.RobotPack then
    self:SetPanelActive(PanelEnum.RobotPackPanel)
  elseif self.welfareTagType == WelfareTagType.MonthCard then
    self:SetPanelActive(PanelEnum.GolloesMonthCardPanel)
  elseif self.welfareTagType == WelfareTagType.PiggyBank then
    self:SetPanelActive(PanelEnum.PiggyBankPanel)
  elseif self.welfareTagType == WelfareTagType.EnergyBank then
    self:SetPanelActive(PanelEnum.EnergyBankPanel)
  elseif self.welfareTagType == WelfareTagType.WeeklyPackage then
    self:SetPanelActive(PanelEnum.WeeklyPackagePanel)
  elseif self.welfareTagType == WelfareTagType.HeroMedalPackage then
    self:SetPanelActive(PanelEnum.HeroMedalPackagePanel)
  elseif self.welfareTagType == WelfareTagType.GrowthPlan then
    self:SetPanelActive(PanelEnum.GrowthPlanPanel)
  elseif self.welfareTagType == WelfareTagType.HeroMonthCardNew then
    self:SetPanelActive(PanelEnum.HeroMonthCardPanel)
  elseif self.welfareTagType == WelfareTagType.ScrollPack then
    self:SetPanelActive(PanelEnum.ScrollPackPanel, rechargeId)
  elseif self.welfareTagType == WelfareTagType.CumulativeRecharge then
    self:SetPanelActive(PanelEnum.CumulativeRecharge)
  elseif self.welfareTagType == WelfareTagType.DailyPackage then
    self.SetPanelActive(PanelEnum.DailyPackage)
  end
end

local function SetTypeSelect(self, index, value)
  if self.typeCells[index] ~= nil then
    self.typeCells[index]:SetSelect(value)
  end
end

local function OnRefreshWelfareRedDot(self)
  for index, cell in pairs(self.typeCells) do
    local redDotNum = self.welfarelist[index]:getRedDotNum()
    cell:SetRedDot(redDotNum)
  end
end

local function GetWeeklyPackageModel(self, path)
  if not self.weeklyPackageItemDic or not self.weeklyPackageItemDic[path] then
    return nil
  end
  local tempList = self.weeklyPackageItemDic[path]
  local retModel
  if 0 < #tempList then
    retModel = tempList[1]
    table.remove(tempList, 1)
  end
  return retModel
end

local function RecycleOneWeeklyPackageModel(self, strPath, model)
  if not self.weeklyPackageItemDic then
    self.weeklyPackageItemDic = {}
  end
  if not self.weeklyPackageItemDic[strPath] then
    self.weeklyPackageItemDic[strPath] = {}
  end
  local go = model.gameObject
  go.gameObject:SetActive(false)
  go.transform:SetParent(self.weeklyPackageItemsContainer.transform)
  table.insert(self.weeklyPackageItemDic[strPath], model)
end

UIGiftPackagePopUpView.OnCreate = OnCreate
UIGiftPackagePopUpView.OnDestroy = OnDestroy
UIGiftPackagePopUpView.OnEnable = OnEnable
UIGiftPackagePopUpView.OnDisable = OnDisable
UIGiftPackagePopUpView.ComponentDefine = ComponentDefine
UIGiftPackagePopUpView.ComponentDestroy = ComponentDestroy
UIGiftPackagePopUpView.DataDefine = DataDefine
UIGiftPackagePopUpView.DataDestroy = DataDestroy
UIGiftPackagePopUpView.OnAddListener = OnAddListener
UIGiftPackagePopUpView.OnRemoveListener = OnRemoveListener
UIGiftPackagePopUpView.ReInit = ReInit
UIGiftPackagePopUpView.OnUpdateGiftPackData = OnUpdateGiftPackData
UIGiftPackagePopUpView.ShowGiftPanel = ShowGiftPanel
UIGiftPackagePopUpView.ShowPremiumPackPanel = ShowPremiumPackPanel
UIGiftPackagePopUpView.ShowRobotPackPanel = ShowRobotPackPanel
UIGiftPackagePopUpView.ShowPiggyBankPanel = ShowPiggyBankPanel
UIGiftPackagePopUpView.ShowEnergyBankPanel = ShowEnergyBankPanel
UIGiftPackagePopUpView.ShowGrowthPlanPanel = ShowGrowthPlanPanel
UIGiftPackagePopUpView.ShowScrollPackPanel = ShowScrollPackPanel
UIGiftPackagePopUpView.TypeButtonCallBack = TypeButtonCallBack
UIGiftPackagePopUpView.ClearScroll = ClearScroll
UIGiftPackagePopUpView.ShowTypeButton = ShowTypeButton
UIGiftPackagePopUpView.ShowClickTypeButtonList = ShowClickTypeButtonList
UIGiftPackagePopUpView.ShowHeroMonthCardPanel = ShowHeroMonthCardPanel
UIGiftPackagePopUpView.ShowCumulativeRechargePanel = ShowCumulativeRechargePanel
UIGiftPackagePopUpView.OnCreateCell = OnCreateCell
UIGiftPackagePopUpView.OnDeleteCell = OnDeleteCell
UIGiftPackagePopUpView.Param = Param
UIGiftPackagePopUpView.ShowDiamondPanel = ShowDiamondPanel
UIGiftPackagePopUpView.SetPanelActive = SetPanelActive
UIGiftPackagePopUpView.CallBackActive = CallBackActive
UIGiftPackagePopUpView.SetTypeSelect = SetTypeSelect
UIGiftPackagePopUpView.ShowGolloesMonthCardPanel = ShowGolloesMonthCardPanel
UIGiftPackagePopUpView.SetGoldNum = SetGoldNum
UIGiftPackagePopUpView.ShowWeeklyPackagePanel = ShowWeeklyPackagePanel
UIGiftPackagePopUpView.ShowWeeklyPackageNewPanel = ShowWeeklyPackageNewPanel
UIGiftPackagePopUpView.ShowWeekCardPanel = ShowWeekCardPanel
UIGiftPackagePopUpView.ShowHeroMedalPackagePanel = ShowHeroMedalPackagePanel
UIGiftPackagePopUpView.ShowDailyPackagePanel = ShowDailyPackagePanel
UIGiftPackagePopUpView.DailyPackageFree = DailyPackageFree
UIGiftPackagePopUpView.OnRefreshWelfareRedDot = OnRefreshWelfareRedDot
UIGiftPackagePopUpView.GotoButtonType = GotoButtonType
UIGiftPackagePopUpView.GetWeeklyPackageModel = GetWeeklyPackageModel
UIGiftPackagePopUpView.RecycleOneWeeklyPackageModel = RecycleOneWeeklyPackageModel
UIGiftPackagePopUpView.LoadPanel = LoadPanel
return UIGiftPackagePopUpView
