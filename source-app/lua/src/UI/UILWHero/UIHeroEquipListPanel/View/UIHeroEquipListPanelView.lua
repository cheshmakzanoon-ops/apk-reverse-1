local UIHeroEquipListPanelView = BaseClass("UIHeroEquipListPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local BaseUIEquipItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem")
local UIEquipRowItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.UIEquipRowItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curHeroData, self.slotType = self:GetUserData()
  if self.curHeroData == nil then
    self:OnBtnCloseClick()
    return
  end
  self:OnOpen()
end

local function OnEqiupBtnClick(self, equipData)
  if equipData == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroEquipInstall, self.curHeroData.uuid, {
    [self.slotType] = equipData.uuid
  })
end

local function OnRemoveBtnClick(self)
  local temp = {}
  table.insert(temp, self.slotType)
  SFSNetwork.SendMessage(MsgDefines.HeroEquipUninstall, self.curHeroData.uuid, temp)
end

local function OnGetBtnClick(self)
  if CS.SceneManager:IsInPVE() then
    UIUtil.ShowTipsId("quick_upgrade_block_tips")
    return
  end
  LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Equip, 1)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.eqiupUuidList then
    return nil
  end
  local equipDataUuid = self.eqiupUuidList[index]
  local equipData = DataCenter.EquipDataManager:GetEquipByUuid(equipDataUuid)
  local item = loopScroll:NewListViewItem("EquipRowItem")
  local script = self.equipListContent:GetComponent(item.gameObject.name, UIEquipRowItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.equipListContent:AddComponent(UIEquipRowItem, objectName)
  end
  local curEquipData = DataCenter.EquipDataManager:GetEquipByUuid(self.curEquipUuid)
  local power = curEquipData and curEquipData.power or 0
  script:SetActive(true)
  script:SetData(equipData, BindCallback(self, OnEqiupBtnClick), self.maxPowerFreeEquipUuid, power)
  self.equipItems[equipData.uuid] = script
  return item
end

local function ClearScroll(self)
  self.equipListContent:RemoveComponents(UIEquipRowItem)
  self.equipList:ClearAllItems()
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.bgPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.bgPanel:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.titleText = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.emptyEquipContent = self:AddComponent(UIBaseContainer, "Root/EmptyEquipContent")
  self.emptyEquipDescText = self:AddComponent(UIText, "Root/EmptyEquipContent/DescText")
  self.equipContent = self:AddComponent(UIBaseContainer, "Root/EquipContent")
  self.curEquipItem = self:AddComponent(BaseUIEquipItem, "Root/EquipContent/EquipItem")
  self.curEquipNameText = self:AddComponent(UIText, "Root/EquipContent/EquipNameText")
  self.curEquipPowerText = self:AddComponent(UIText, "Root/EquipContent/EquipPowerGroup/PowerText")
  self.curEquipRemoveBtn = self:AddComponent(UIButton, "Root/EquipContent/RemoveBtn")
  self.curEquipRemoveBtnText = self:AddComponent(UIText, "Root/EquipContent/RemoveBtn/BtnIcon/RemoveBtnText")
  self.curEquipRemoveBtn:SetOnClick(BindCallback(self, OnRemoveBtnClick))
  self.equipList = self:AddComponent(UILoopListView2, "Root/EquipScroll")
  self.equipList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.equipListContent = self:AddComponent(UIBaseContainer, "Root/EquipScroll/Viewport/Content")
  self.equipGetBtn = self:AddComponent(UIButton, "Root/EquipGetBtn")
  self.equipGetBtnText = self:AddComponent(UIText, "Root/EquipGetBtn/EquipGetIcon/EquipGetText")
  self.equipGetBtn:SetOnClick(BindCallback(self, OnGetBtnClick))
  self.emptyEquipListText = self:AddComponent(UIText, "Root/EmptyEquipListText")
  self.titleText:SetLocalText(430748)
  self.curEquipRemoveBtnText:SetLocalText(430741)
  self.emptyEquipDescText:SetLocalText(430745)
  self.equipGetBtnText:SetLocalText(431603)
end

local function DataDefine(self)
  self.itemIndex = 0
  self.equipItems = {}
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.titleText = nil
  self.totalPropertiesTitleText = nil
  self.powerText = nil
  self.propertyList = nil
  self.propertyScroll = nil
  self.weaponItem = nil
  self.armorItem = nil
  self.coreItem = nil
  self.radarItem = nil
  self.equipItemList = nil
  self.weaponItemLine = nil
  self.armorItemLine = nil
  self.coreItemLine = nil
  self.radarItemLine = nil
  self.equipItemLineList = nil
  self.equipGetBtn = nil
  self.equipGetBtnText = nil
  self.emptyEquipListText = nil
end

local function DataDestroy(self)
  self.curHeroData = nil
  self.itemIndex = 0
  self.equipItems = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEquipInstall, self.OnBtnCloseClick)
  self:AddUIListener(EventId.HeroEquipUninstall, self.OnBtnCloseClick)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroEquipInstall, self.OnBtnCloseClick)
  self:RemoveUIListener(EventId.HeroEquipUninstall, self.OnBtnCloseClick)
end

local function UpdateView(self)
  self.eqiupUuidList, self.curEquipUuid, self.maxPowerFreeEquipUuid = self.ctrl.GetAllEquipDataList(self.curHeroData, self.slotType)
  if self.eqiupUuidList == nil or #self.eqiupUuidList == 0 then
    self.equipList:SetActive(false)
    self.emptyEquipListText:SetActive(true)
  else
    self.equipList:SetActive(true)
    self.equipList:SetListItemCount(#self.eqiupUuidList, false, false)
    self.emptyEquipListText:SetActive(false)
  end
  if self.curEquipUuid == nil then
    self.emptyEquipContent:SetActive(true)
    self.equipContent:SetActive(false)
  else
    self.emptyEquipContent:SetActive(false)
    self.equipContent:SetActive(true)
    local curEquipData = DataCenter.EquipDataManager:GetEquipByUuid(self.curEquipUuid)
    self.curEquipItem:SetData(curEquipData, nil, false, false, true)
    self.curEquipNameText:SetLocalText(curEquipData.config.name)
    self.curEquipPowerText:SetText(math.floor(curEquipData.power))
  end
end

local function OnOpen(self)
  UpdateView(self)
end

local function OnBtnCloseClick(self)
  if self.callBack ~= nil then
    self.callBack()
  end
  self.ctrl.CloseSelf()
end

UIHeroEquipListPanelView.OnCreate = OnCreate
UIHeroEquipListPanelView.OnDestroy = OnDestroy
UIHeroEquipListPanelView.OnEnable = OnEnable
UIHeroEquipListPanelView.OnDisable = OnDisable
UIHeroEquipListPanelView.OnAddListener = OnAddListener
UIHeroEquipListPanelView.OnRemoveListener = OnRemoveListener
UIHeroEquipListPanelView.ComponentDefine = ComponentDefine
UIHeroEquipListPanelView.DataDefine = DataDefine
UIHeroEquipListPanelView.ComponentDestroy = ComponentDestroy
UIHeroEquipListPanelView.DataDestroy = DataDestroy
UIHeroEquipListPanelView.OnOpen = OnOpen
UIHeroEquipListPanelView.OnBtnCloseClick = OnBtnCloseClick
return UIHeroEquipListPanelView
