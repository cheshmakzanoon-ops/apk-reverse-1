local UILWBagMainView = BaseClass("UILWBagMainView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWBagItemShell = require("UI.UILWBag.UILWBagMain.Component.UILWBagItemShell")
local UIEquipPropertyLineItem = require("UI.UILWHero.UIHeroEquipPanel.Component.UIEquipPropertyLineItem")
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local string_GetFormattedStr2 = string.GetFormattedStr2
local string_IsNullOrEmpty = string.IsNullOrEmpty
local tonumber = _ENV.tonumber
local DataCenter = _ENV.DataCenter
local UIBagTab = _ENV.UIBagTab
local GOODS_TYPE = _ENV.GOODS_TYPE
local BAG_TITLE_TXT = "129000"
local NO_ITEM_TXT = GameDialogDefine.NO_ANY_GOODS
local EQUIP_TITLE_TXT = "129025"
local EQUIPED_TITLE_TXT = "129026"
local EQUIPED_REMINDS_TXT = "129057"
local SPECIAL_ITEM_INFO_PATH = {
  [GOODS_TYPE.GOODS_TYPE_174] = "Assets/Main/Prefabs/UI/LWBag/FireworkInfoContentItem.prefab"
}
local SCRIPT_PRE_PATH = "UI.UILWBag.UILWBagMain.Component."
local SPECIAL_ITEM_INFO_SCRIPT = {
  [GOODS_TYPE.GOODS_TYPE_174] = "FireworkInfoContentItem"
}
local ResBarCellPath = "Assets/Main/Prefabs/UI/UIMain/UIMainTopResourceCell.prefab"

function UILWBagMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:RefreshResourceCells()
end

function UILWBagMainView:OnDestroy()
  if GMUtils.GetBool(GMConst.ShowBagMaster, false) then
    EventManager:GetInstance():Broadcast(EventId.GM_BagMasterSelectionChanged, nil)
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBagMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.titleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.resourceBar = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.closeBtn = self.viewSkin:AddComponent(self, UIButton, 3)
  self.closeBtn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.compCondition1Select = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compCondition2Select = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compCondition3Select = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compCondition4Select = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compCondition5Select = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compCondition6Select = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textCondition1Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textCondition2Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textCondition3Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textCondition4Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textCondition5Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textCondition6Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.btnTabItem1 = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnTabItem1:SetOnClick(function()
    self:OnTabClick(UIBagShowTab[1])
  end)
  self.btnTabItem2 = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnTabItem2:SetOnClick(function()
    self:OnTabClick(UIBagShowTab[2])
  end)
  self.btnTabItem3 = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnTabItem3:SetOnClick(function()
    self:OnTabClick(UIBagShowTab[3])
  end)
  self.btnTabItem4 = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnTabItem4:SetOnClick(function()
    self:OnTabClick(UIBagShowTab[4])
  end)
  self.btnTabItem5 = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnTabItem5:SetOnClick(function()
    self:OnTabClick(UIBagShowTab[5])
  end)
  self.btnTabItem6 = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnTabItem6:SetOnClick(function()
    self:OnTabClick(UIBagShowTab[6])
  end)
  self.compCondition1RedDot = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.compCondition2RedDot = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.compCondition3RedDot = self.viewSkin:AddComponent(self, UIBaseComponent, 24)
  self.compCondition4RedDot = self.viewSkin:AddComponent(self, UIBaseComponent, 25)
  self.compCondition5RedDot = self.viewSkin:AddComponent(self, UIBaseComponent, 26)
  self.compCondition6RedDot = self.viewSkin:AddComponent(self, UIBaseComponent, 27)
  self.textRedDotText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.textRedDotText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 29)
  self.textRedDotText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 30)
  self.textRedDotText4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 31)
  self.textRedDotText5 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 32)
  self.textRedDotText6 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 33)
  self.loopGridViewItemHolder = self.viewSkin:AddComponent(self, UILoopGridView, 34)
  self.compItemContent = self.viewSkin:AddComponent(self, UIBaseContainer, 35)
  self.noItemTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.itemSelectFrame = self.viewSkin:AddComponent(self, UIBaseContainer, 37)
  self.itemInfoGo = self.viewSkin:AddComponent(self, UIBaseContainer, 38)
  self.itemInfoNormalGo = self.viewSkin:AddComponent(self, UIBaseContainer, 39)
  self.itemInfoSpecialGo = self.viewSkin:AddComponent(self, UIBaseContainer, 40)
  self.itemInfoName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 41)
  self.itemInfoCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 42)
  self.willExpireTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 43)
  self.itemInfoDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 44)
  self.itemInfoArrow = self.viewSkin:AddComponent(self, UIImage, 45)
  self.itemInfoScroll = self.viewSkin:AddComponent(self, UIScrollRect, 46)
  self.inputGo = self.viewSkin:AddComponent(self, UIBaseContainer, 47)
  self.inputSlider = self.viewSkin:AddComponent(self, UISlider, 48)
  self.inputTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 49)
  self.inputAddBtn = self.viewSkin:AddComponent(self, UIButton, 50)
  self.inputAddBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnAddBtnClick()
  end)
  self.inputDecBtn = self.viewSkin:AddComponent(self, UIButton, 51)
  self.inputDecBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnDecBtnClick()
  end)
  self.equipInfoGo = self.viewSkin:AddComponent(self, UIBaseContainer, 52)
  self.equipInfoName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 53)
  self.equipInfoPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 54)
  self.equipInfoPowerGo = self.viewSkin:AddComponent(self, UIBaseContainer, 55)
  self.equipPropContent = self.viewSkin:AddComponent(self, UIBaseContainer, 56)
  self.equipPropContentScroll = self.viewSkin:AddComponent(self, GridInfinityScrollView, 57)
  self.equipedHeroCell = self.viewSkin:AddComponent(self, UIHeroCellBig, 58)
  self.useBtnNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 59)
  self.useBtn = self.viewSkin:AddComponent(self, UIButton, 60)
  self.useBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUseBtnClick()
  end)
  self.equipedRemindsTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 61)
  self.rate_btn = self.viewSkin:AddComponent(self, UIButton, 62)
  self.rate_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRateBtnClick()
  end)
  self.got_total_num = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 63)
  self.total_num_group = self.viewSkin:AddComponent(self, UIBaseContainer, 64)
  self.bag_resource_overview_btn = self.viewSkin:AddComponent(self, UIButton, 65)
  self.bag_resource_overview_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBagResourceOverview, {anim = true})
  end)
  self.bag_resource_overview_btn_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 66)
  self.equip_info_des = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 67)
end

function UILWBagMainView:RefreshTabRedDot()
  for i = 1, #UIBagShowTab do
    local count = DataCenter.ItemData:GetItemRedDotCountByTabType(i)
    self.tabRedDot[i]:SetActive(0 < count)
    self.tabRedDotText[i]:SetText(count)
  end
end

function UILWBagMainView:ComponentDestroy()
  self.viewSkin = nil
  self.titleTxt = nil
  self.resourceBar = nil
  self.closeBtn = nil
  self.compCondition1Select = nil
  self.compCondition2Select = nil
  self.compCondition3Select = nil
  self.compCondition4Select = nil
  self.compCondition5Select = nil
  self.compCondition6Select = nil
  self.textCondition1Txt = nil
  self.textCondition2Txt = nil
  self.textCondition3Txt = nil
  self.textCondition4Txt = nil
  self.textCondition5Txt = nil
  self.textCondition6Txt = nil
  self.btnTabItem1 = nil
  self.btnTabItem2 = nil
  self.btnTabItem3 = nil
  self.btnTabItem4 = nil
  self.btnTabItem5 = nil
  self.btnTabItem6 = nil
  self.compCondition1RedDot = nil
  self.compCondition2RedDot = nil
  self.compCondition3RedDot = nil
  self.compCondition4RedDot = nil
  self.compCondition5RedDot = nil
  self.compCondition6RedDot = nil
  self.textRedDotText1 = nil
  self.textRedDotText2 = nil
  self.textRedDotText3 = nil
  self.textRedDotText4 = nil
  self.textRedDotText5 = nil
  self.textRedDotText6 = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.noItemTxt = nil
  self.itemSelectFrame = nil
  self.itemInfoGo = nil
  self.itemInfoNormalGo = nil
  self.itemInfoSpecialGo = nil
  self.itemInfoName = nil
  self.itemInfoCount = nil
  self.willExpireTime = nil
  self.itemInfoDesc = nil
  self.itemInfoArrow = nil
  self.itemInfoScroll = nil
  self.inputGo = nil
  self.inputSlider = nil
  self.inputTxt = nil
  self.inputAddBtn = nil
  self.inputDecBtn = nil
  self.equipInfoGo = nil
  self.equipInfoName = nil
  self.equipInfoPower = nil
  self.equipInfoPowerGo = nil
  self.equipPropContent = nil
  self.equipPropContentScroll = nil
  self.equipedHeroCell = nil
  self.useBtnNameTxt = nil
  self.useBtn = nil
  self.equipedRemindsTxt = nil
  self.rate_btn = nil
  self.got_total_num = nil
  self.total_num_group = nil
  self.bag_resource_overview_btn = nil
  self.bag_resource_overview_btn_text = nil
  self.equip_info_des = nil
end

function UILWBagMainView:DataDefine()
  self.curTab = 1
  self.cacheSelectCell = 1
  self.curSelectCell = self.cacheSelectCell
  self.curItemCount = 1
  self.itemList = {}
  self.typeMap = {}
  self.listGO = {}
  self.propertiesDataList = {}
  self.listEquipPropGO = {}
  self.un_equip = nil
  self.equipedHeroUuid = nil
  self.minItemCount = 1
  self.maxItemCount = 9999
  self.canSliderChange = true
  self.hasInitWindow = false
  self.cellItems = {}
  self.cellIndex = 1
  self.scrollRectValid = false
  self.showExpireTime = false
  self.expireTime = 0
  self.isEquipScrollInited = false
  self.titleTxt:SetLocalText(BAG_TITLE_TXT)
  self.resBarCellGoReqs = {}
  self.resBarCellScripts = {}
  self.tabSelectGo = {
    self.compCondition1Select,
    self.compCondition2Select,
    self.compCondition3Select,
    self.compCondition4Select,
    self.compCondition5Select,
    self.compCondition6Select
  }
  self.tabTitleTxt = {
    self.textCondition1Txt,
    self.textCondition2Txt,
    self.textCondition3Txt,
    self.textCondition4Txt,
    self.textCondition5Txt,
    self.textCondition6Txt
  }
  self.tabClickBtn = {
    self.btnTabItem1,
    self.btnTabItem2,
    self.btnTabItem3,
    self.btnTabItem4,
    self.btnTabItem5,
    self.btnTabItem6
  }
  self.tabRedDot = {
    self.compCondition1RedDot,
    self.compCondition2RedDot,
    self.compCondition3RedDot,
    self.compCondition4RedDot,
    self.compCondition5RedDot,
    self.compCondition6RedDot
  }
  self.tabRedDotText = {
    self.textRedDotText1,
    self.textRedDotText2,
    self.textRedDotText3,
    self.textRedDotText4,
    self.textRedDotText5,
    self.textRedDotText6
  }
  for i = 1, #UIBagShowTab do
    if UIBagShowTab[i] == UIBagTab.Gift then
      self.tabClickBtn[i]:SetActive(IsGiftSystemOpen)
    end
  end
  self.itemInfoArrow:SetActive(false)
  self.itemInfoScroll:AddValueChangeListener(function()
    self:RefreshDownArrow()
  end)
  self.inputSlider:SetOnValueChanged(function(value)
    self:OnInputSliderChanged(value)
  end)
  self.inputAddBtn.Mute = true
  self.inputDecBtn.Mute = true
  for i = 1, #UIBagShowTab do
    self.tabTitleTxt[i]:SetLocalText(UIBagTabTitle[UIBagShowTab[i]])
    local count = DataCenter.ItemData:GetItemRedDotCountByTabType(i)
    self.tabRedDot[i]:SetActive(0 < count)
    self.tabRedDotText[i]:SetText(count)
  end
  self.noItemTxt:SetLocalText(NO_ITEM_TXT)
  self.bag_resource_overview_btn_text:SetLocalText("goods_statistics_button")
end

function UILWBagMainView:DataDestroy()
  self:ExitResetRed()
  self.curTab = nil
  self.cacheSelectCell = nil
  self.curSelectCell = nil
  self.curItemCount = nil
  self.itemList = nil
  self.typeMap = nil
  self.listGO = nil
  self.propertiesDataList = nil
  self.listEquipPropGO = nil
  self.un_equip = nil
  self.equipedHeroUuid = nil
  self.minItemCount = nil
  self.maxItemCount = nil
  self.canSliderChange = nil
  self.hasInitWindow = false
  self.sendConvertItems = nil
  self.cellIndex = nil
  self.scrollRectValid = nil
  self.showExpireTime = false
  self.expireTime = 0
  self:ClearSpecialItemInfoReq()
  for i = 1, #UIBagShowTab do
    self.tabSelectGo[i] = nil
    self.tabTitleTxt[i] = nil
    self.tabClickBtn[i] = nil
  end
  self.tabSelectGo = nil
  self.tabTitleTxt = nil
  self.tabClickBtn = nil
  self.itemSelectFrame.transform:SetParent(self.transform)
  self:ClearItemCell()
  self:ClearEquipPropScroll()
  self:ClearResBarCells()
  if self.descDelayTimer ~= nil then
    self.descDelayTimer:Stop()
    self.descDelayTimer = nil
  end
end

function UILWBagMainView:OnEnable()
  base.OnEnable(self)
  if self.hasInitWindow then
    self:RefreshView()
  else
    self.hasInitWindow = true
  end
end

function UILWBagMainView:OnDisable()
  base.OnDisable(self)
end

function UILWBagMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ResourceUpdated, self.ResourceUpdatedSignal)
  self:AddUIListener(EventId.RefreshBagRedDot, self.RefreshTabRedDot)
  self:AddUIListener(EventId.RefreshBagItems, self.RefreshItemsToCell)
  self:AddUIListener(EventId.ExitEquipPromote, self.OnEquipPromoteWindowExit)
  self:AddUIListener(EventId.EquipDetailChangePage, self.OnEquipDetialChangePage)
  self:AddUIListener(EventId.HeroEquipInstall, self.OnEquipDataChange)
  self:AddUIListener(EventId.HeroEquipUninstall, self.OnEquipDataChange)
  self:AddUIListener(EventId.HeroEquipUpgrade, self.OnEquipDataChange)
  self:AddUIListener(EventId.ExpiredItemsConvert, self.OnExpiredItemsConvert)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, self.OnInitMessage)
end

function UILWBagMainView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ResourceUpdated, self.ResourceUpdatedSignal)
  self:RemoveUIListener(EventId.RefreshBagItems, self.RefreshItemsToCell)
  self:RemoveUIListener(EventId.RefreshBagRedDot, self.RefreshTabRedDot)
  self:RemoveUIListener(EventId.ExitEquipPromote, self.OnEquipPromoteWindowExit)
  self:RemoveUIListener(EventId.EquipDetailChangePage, self.OnEquipDetialChangePage)
  self:RemoveUIListener(EventId.HeroEquipInstall, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.HeroEquipUninstall, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.HeroEquipUpgrade, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.ExpiredItemsConvert, self.OnExpiredItemsConvert)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, self.OnInitMessage)
end

function UILWBagMainView:ReInit()
  self:ClearEquipPropScroll()
  self:SetLoopGridArrangeType()
  self.loopGridViewItemHolder:InitGridViewParam(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end, nil, nil, function(loopGridViewItem)
    self:OnRecycleItemFunc(loopGridViewItem)
  end)
  local targetTab = 1
  local userdata = self:GetUserData() or {}
  local jumpGoodsId, jumpGoodsIndex
  if userdata.jumpGoodsId then
    jumpGoodsId = userdata.jumpGoodsId
  end
  if jumpGoodsId then
    local itemList, typeMap = self.ctrl:GetItemListByType(UICapacityTableTab.Item, targetTab)
    for i, v in pairs(itemList) do
      if v.itemId == jumpGoodsId then
        jumpGoodsIndex = i
        break
      end
    end
  end
  self:OnTabClick(targetTab)
  if jumpGoodsIndex then
    self.cacheSelectCell = jumpGoodsIndex
    self:RefreshList(true)
  end
  local showTipsBubble = Setting:GetBool(SettingKeys.BAG_RESOURCE_OVERVIEW_FIRST_REMIND, true)
  if showTipsBubble then
    Setting:SetBool(SettingKeys.BAG_RESOURCE_OVERVIEW_FIRST_REMIND, false)
    local content = Localization:GetString("resource_speed_statistics_bubble")
    local parameter = {reversal = true}
    UIUtil.ShowBubbleTips(content, self.bag_resource_overview_btn.transform.position, 0, 60, -40, nil, nil, parameter)
  end
end

function UILWBagMainView:SetLoopGridArrangeType()
  if self.loopGridViewItemHolder == nil or self.loopGridViewItemHolder.unity_loopgridview == nil then
    return
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.loopGridViewItemHolder.unity_loopgridview.ArrangeType = CS.SuperScrollView.GridItemArrangeType.TopRightToBottomLeft
  else
    self.loopGridViewItemHolder.unity_loopgridview.ArrangeType = CS.SuperScrollView.GridItemArrangeType.TopLeftToBottomRight
  end
end

function UILWBagMainView:OnGetItemByRowColumn(loopScroll, index)
  local count = #self.itemList
  if index < 0 or index >= count then
    return nil
  end
  local item = loopScroll:NewListViewItem("UILWBagItemShell")
  local cellItem = self.compItemContent:GetComponent(item.gameObject.name, UILWBagItemShell)
  if cellItem == nil then
    local name = "bag_item_" .. UIUtil.GetLoopListItemIndex()
    item.gameObject.name = name
    cellItem = self.compItemContent:AddComponent(UILWBagItemShell, name)
  end
  cellItem:SetActive(true)
  local showRedPoint = true
  if self.typeMap[index + 1] == BagItemType.CommonEquip then
    showRedPoint = false
  end
  local param = {
    data = self.itemList[index + 1],
    type = self.typeMap[index + 1],
    index = index + 1,
    callBack = function(trans, index)
      self:CellsCallBack_RefreshData(index)
      self:CellsCallBack_RefreshSelectFrame(trans, index)
    end,
    showRedPoint = showRedPoint
  }
  cellItem:SetData(param)
  cellItem:SetActive(true)
  if index + 1 == self.curSelectCell then
    self:ClearAllCellSelected()
    self.cacheSelectCell = index + 1
    self.curSelectCell = self.cacheSelectCell
    if cellItem then
      cellItem:SetSelectState(true)
    end
    self:RefreshInfo()
    self.cellIndex = index + 1
  elseif cellItem then
    cellItem:SetSelectState(false)
  end
  self.cellItems[index + 1] = cellItem
  return item
end

function UILWBagMainView:OnRecycleItemFunc(loopGridViewItem)
  if loopGridViewItem == nil then
    return
  end
  local index = loopGridViewItem.ItemIndex
  local oneBasedIndex = index + 1
  if oneBasedIndex == self.curSelectCell then
    self.itemSelectFrame:SetActive(false)
    self.itemSelectFrame.transform:SetParent(self.transform)
  end
  if self.cellItems[oneBasedIndex] then
    self.cellItems[oneBasedIndex]:ResetRecycleState()
  end
  self.cellItems[oneBasedIndex] = nil
end

function UILWBagMainView:CellsCallBack_RefreshSelectFrame(trans, index)
  self.itemSelectFrame.transform:SetParent(trans:GetChild(0))
  self.itemSelectFrame.transform:SetSiblingIndex(8)
  self.itemSelectFrame.transform:Set_localPosition(0, 5, 0)
  self.itemSelectFrame.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  self.itemSelectFrame:SetActive(true)
end

function UILWBagMainView:CellsCallBack_RefreshData(index)
  self:ClearAllCellSelected()
  self.cacheSelectCell = index
  self.curSelectCell = self.cacheSelectCell
  if self.cellItems[index] ~= nil then
    self.cellItems[index]:SetSelectState(true)
  end
  self:RefreshInfo()
  self.cellIndex = index
end

function UILWBagMainView:RefreshInfo()
  self.rate_btn:SetActive(false)
  self.itemInfoGo:SetActive(false)
  self.equipInfoGo:SetActive(false)
  self.equipedHeroCell:SetActive(false)
  self.useBtnNameTxt:SetLocalPositionXYZ(0, 8.5, 0)
  if self.curTab == UIBagTab.Equip then
    self.equipInfoGo:SetActive(true)
    self:RefreshEquipInfo()
  else
    self.itemInfoGo:SetActive(true)
    self:RefreshItemInfo()
  end
end

function UILWBagMainView:RefreshItemInfo()
  local itemId = self.itemList[self.curSelectCell].itemId
  local bagItemType = self.typeMap[self.curSelectCell]
  self.itemInfoCount:SetActive(false)
  self.itemInfoNormalGo:SetActive(true)
  self.itemInfoSpecialGo:SetActive(false)
  self.willExpireTime:SetActive(false)
  if bagItemType == BagItemType.Item then
    local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    local item = DataCenter.ItemData:GetItemById(itemId)
    local name_txt = DataCenter.ItemTemplateManager:GetName(itemId)
    local isItemExpired = UIUtil.CheckItemIsExpired(itemId)
    if isItemExpired then
      name_txt = name_txt .. " (" .. Localization:GetString("season_ui_desc041") .. ")"
    end
    if GMUtils.GetBool(GMConst.ShowBagMaster, false) then
      EventManager:GetInstance():Broadcast(EventId.GM_BagMasterSelectionChanged, {
        tab = self.curTab,
        name = name_txt,
        itemId = itemId
      })
    end
    if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
      name_txt = string.format("%s[%s]", name_txt, itemId)
    end
    self.itemInfoName:SetText(name_txt)
    local des_txt = DataCenter.ItemTemplateManager:GetDes(itemId)
    local cur_txt = self.itemInfoDesc:GetText() or ""
    if des_txt ~= cur_txt then
      self.itemInfoDesc:SetText(des_txt)
      self.scrollRectValid = false
      self:RefreshDownArrow()
      if self.descDelayTimer ~= nil then
        self.descDelayTimer:Stop()
        self.descDelayTimer = nil
      end
      self.descDelayTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
        if IsNotNull(self.itemInfoDesc) then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemInfoDesc.transform)
          local viewPortSize = self.itemInfoScroll:GetSizeDelta().y
          local contentSize = self.itemInfoDesc:GetSizeDelta().y
          self.scrollRectValid = viewPortSize < contentSize
          self:RefreshDownArrow()
        end
      end, 3)
    end
    self:SetUseBtnNameText(Localization:GetString("110046"))
    self.rate_btn:SetActive(itemData.drop_info_para > 0)
    if item ~= nil then
      self.maxItemCount = item.count
      if itemData.type == GOODS_TYPE.GOODS_TYPE_134 then
        self.itemInfoCount:SetActive(true)
        local useCount = DataCenter.MasteryManager:GetItemUseCount(itemId)
        self.itemInfoCount:SetLocalText("season_mastery_tips_25", useCount)
      end
      self.showExpireTime = UIUtil.IsShowWillExpired(tonumber(itemId), true)
      if self.showExpireTime then
        self.willExpireTime:SetActive(true)
        local time = UIUtil.GetWillExpireTime(tonumber(itemId))
        self.expireTime = time
        local now = UITimeManager:GetInstance():GetServerSeconds()
        self.willExpireTime:SetText(Localization:GetString("s1_gift_tips_7", UITimeManager:GetInstance():SecondToFmtString(time - now)))
      end
      local isHeroJigsaw = itemData.type == GOODS_TYPE.GOODS_TYPE_98 or itemData.type == GOODS_TYPE.GOODS_TYPE_99
      if isHeroJigsaw then
        self:SetInputText(math.min(HeroUtils.GetJigsawCost(itemId), item.count))
      elseif itemData.type == GOODS_TYPE.GOODS_TYPE_149 then
        self:SetInputText(self.minItemCount)
      elseif itemData.default_useCount == 0 then
        self:SetInputText(self.maxItemCount)
      else
        self:SetInputText(self.minItemCount)
      end
      if itemData.type == GOODS_TYPE.GOODS_TYPE_174 then
        self:LoadSpecialItemInfo(itemData)
      end
      self:SetAddAndDecBtnState()
      local use_btn_active = false
      if itemData.use ~= nil then
        if itemData.use == 1 then
          use_btn_active = true
        end
      else
        local strGoto = itemData.go_to
        if strGoto ~= nil and 0 < string.len(strGoto) and tonumber(strGoto) == 7 then
          use_btn_active = true
        end
      end
      local gotoParaData = itemData:GetGotoParaData()
      if gotoParaData and gotoParaData.type == ItemGotoParaType.Activity and gotoParaData.gotoType and gotoParaData.gotoPara then
        use_btn_active = true
      end
      local isItemExpired = UIUtil.CheckItemIsExpired(checknumber(itemId))
      if isItemExpired then
        use_btn_active = true
      end
      self:SetUseBtnActive(use_btn_active, itemData)
      local type = itemData.type
      local type2 = itemData.type2
      if isItemExpired then
        self:SetUseBtnNameText(Localization:GetString("goods_recovery_btn_name"))
      elseif type == 3 and type2 == 999 then
        self:SetUseBtnNameText(Localization:GetString("110081"))
      else
        self:SetUseBtnNameText(Localization:GetString("110046"))
      end
      local para = itemData.para
      local paras = {}
      if para ~= nil and para ~= "" then
        paras = string.split(para, ";")
      end
      local isNeedOtherBtn = false
      local strOtherText = Localization:GetString("110029")
      if type == 45 or type == 79 then
        strOtherText = Localization:GetString("180057")
        isNeedOtherBtn = true
      elseif type == 13 and paras ~= nil and paras[4] ~= nil then
        if 0 < string.len(paras[4]) then
          isNeedOtherBtn = true
        else
          isNeedOtherBtn = false
        end
      elseif type == 16 and item.para ~= "-1" then
        isNeedOtherBtn = true
      elseif type == 23 and paras ~= nil and paras[4] ~= nil and paras[3] ~= nil and 0 < string.len(paras[4]) and 0 < string.len(paras[3]) then
        isNeedOtherBtn = true
      elseif itemId == "200070" then
        isNeedOtherBtn = true
      elseif itemId == CS.FBDrawActController.Instance.m_outToolId then
        isNeedOtherBtn = true
      elseif type == 160 then
        strOtherText = Localization:GetString("110036")
        isNeedOtherBtn = true
      elseif type == 165 then
        strOtherText = Localization:GetString("110036")
        isNeedOtherBtn = true
      elseif type == GOODS_TYPE.GOODS_TYPE_181 then
        strOtherText = Localization:GetString("110046")
        isNeedOtherBtn = true
      elseif type == GOODS_TYPE.GOODS_TYPE_183 then
        strOtherText = Localization:GetString("110046")
        isNeedOtherBtn = true
      elseif type == GOODS_TYPE.GOODS_TYPE_174 then
        strOtherText = Localization:GetString("110046")
        isNeedOtherBtn = true
      else
        isNeedOtherBtn = false
      end
      if isNeedOtherBtn then
        self:SetUseBtnActive(true, itemData)
        self:SetUseBtnNameText(strOtherText)
      end
      if isHeroJigsaw then
        self:SetInputGoActive(false)
      end
    end
  elseif bagItemType == BagItemType.ResourceItem then
    local name_txt = DataCenter.ResourceItemDataManager:GetName(itemId)
    if GMUtils.GetBool(GMConst.ShowBagMaster, false) then
      EventManager:GetInstance():Broadcast(EventId.GM_BagMasterSelectionChanged, {
        tab = self.curTab,
        name = name_txt,
        resId = itemId
      })
    end
    if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
      name_txt = string.format("%s[%s]", name_txt, itemId)
    end
    self.itemInfoName:SetText(name_txt)
    local des_txt = DataCenter.ResourceItemDataManager:GetDes(itemId)
    self.itemInfoDesc:SetText(des_txt)
    self:SetUseBtnActive(false, {useAll = 0})
  end
end

function UILWBagMainView:OnTabClick(index)
  for i = 1, #UIBagShowTab do
    if self.tabSelectGo[i]:GetActive() and index ~= self.curTab then
      DataCenter.ItemData:SetItemRedDotCountisNot(self.curTab)
    end
    self.tabSelectGo[i]:SetActive(i == index)
    self.tabTitleTxt[i].transform:Set_localPosition(0, i == index and 3 or 0, 0)
  end
  self.cacheSelectCell = 1
  self.curTab = index
  if index ~= UIBagTab.Resource then
    self.total_num_group:SetActive(false)
  end
  self.resourceBar:SetActive(self.curTab == UIBagTab.Special or self.curTab == UIBagTab.Resource)
  self:RefreshList(true)
end

function UILWBagMainView:CheckResourceItemList()
  local resourceItemList, resourceItemMap = self.ctrl:GetItemListByType(UICapacityTableTab.ResourceItem, self.curTab)
  self.itemList = table.mergeArray(resourceItemList, self.itemList)
  self.typeMap = table.mergeArray(resourceItemMap, self.typeMap)
end

function UILWBagMainView:RefreshList(moveScroll)
  self.curSelectCell = self.cacheSelectCell or 1
  self.itemList, self.typeMap = self.ctrl:GetItemListByType(UICapacityTableTab.Item, self.curTab)
  self:CheckResourceItemList()
  local itemCount = #self.itemList
  self.loopGridViewItemHolder:SetActive(0 < itemCount)
  self.noItemTxt:SetActive(itemCount <= 0)
  if self.curTab == UIBagTab.Equip then
    self.equipInfoGo:SetActive(0 < itemCount)
    self.itemInfoGo:SetActive(false)
  else
    self.itemInfoGo:SetActive(0 < itemCount)
    self.equipInfoGo:SetActive(false)
  end
  self.itemSelectFrame:SetActive(false)
  self.useBtn:SetActive(false)
  self:SetInputGoActive(false)
  if 0 < itemCount then
    if itemCount < self.curSelectCell then
      self.curSelectCell = itemCount
    end
    self.loopGridViewItemHolder:SetListItemCount(itemCount)
    self.loopGridViewItemHolder:RefreshAllShownItem()
    if moveScroll then
      self.loopGridViewItemHolder:MovePanelToItemByIndex(self.curSelectCell - 1, 0)
    end
  end
end

function UILWBagMainView:ClearItemCell()
  self.cellItems = {}
  self.compItemContent:RemoveComponents(UILWBagItemShell)
  self.loopGridViewItemHolder:ClearAllItems()
end

function UILWBagMainView:RefreshItemsToCell()
  self:RefreshList()
end

function UILWBagMainView:OnInitMessage()
  self:RefreshItemsToCell()
end

function UILWBagMainView:OnUseBtnClick()
  local flyFromPt = self.itemSelectFrame:GetActive() and self.itemSelectFrame.transform.position or self.useBtn.transform.position
  self.ctrl:OnItemUse(self.itemList[self.curSelectCell], self.curItemCount, flyFromPt, self.typeMap[self.curSelectCell], self.itemList, self.typeMap)
end

function UILWBagMainView:OnRateBtnClick()
  local itemId = self.itemList[self.curSelectCell].itemId
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if itemTemplate then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, itemTemplate.drop_info_para)
  else
    Logger.LogError("OnRateBtnClick: not found " .. tostring(itemId))
  end
end

function UILWBagMainView:SetUseBtnActive(value, itemData)
  self.useBtn:SetActive(value)
  self:SetInputGoActive(false)
  if value then
    local useAll = itemData.useall
    local showInput = useAll ~= nil and useAll == 1
    if showInput then
      local isItemExpired = UIUtil.CheckItemIsExpired(checknumber(itemData.id))
      if isItemExpired then
        showInput = false
      end
    end
    self:SetInputGoActive(showInput)
  end
end

function UILWBagMainView:SetUseBtnNameText(value)
  self.useBtnNameTxt:SetText(value)
end

function UILWBagMainView:ExitResetRed()
  if self.itemList and table.count(self.itemList) > 0 then
    for i = 1, #self.itemList do
      if self.itemList[i].template and self.itemList[i].template.important == 2 then
        DataCenter.ItemData:SetItemRed(self.itemList[i].data.uuid)
      end
    end
    DataCenter.ItemData:SetAllItemRedDotCountisNot()
  end
end

function UILWBagMainView:RedReference(index)
  self.itemList[index].redState = true
end

function UILWBagMainView:OnAddBtnClick()
  self.canSliderChange = false
  local curParam = self.itemList[self.curSelectCell]
  local itemTemplate = curParam.template or DataCenter.ItemTemplateManager:GetItemTemplate(curParam.itemId)
  local p = (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99) and HeroUtils.GetJigsawCost(curParam.itemId) or self.minItemCount
  if self.curItemCount + p <= self.maxItemCount then
    self:SetInputText(self.curItemCount + p)
  end
  self.canSliderChange = true
end

function UILWBagMainView:OnDecBtnClick()
  self.canSliderChange = false
  local curParam = self.itemList[self.curSelectCell]
  local itemTemplate = curParam.template or DataCenter.ItemTemplateManager:GetItemTemplate(curParam.itemId)
  local p = (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99) and HeroUtils.GetJigsawCost(curParam.itemId) or self.minItemCount
  if p < self.curItemCount then
    self:SetInputText(self.curItemCount - p)
  end
  self.canSliderChange = true
end

function UILWBagMainView:SetInputText(value)
  self.curItemCount = value
  self.inputTxt:SetText(value)
  self:RefreshGotTotalNum(self.cellIndex, value)
  self:SetAddAndDecBtnState()
end

function UILWBagMainView:SetAddAndDecBtnState()
  local can_dec = self.curItemCount > self.minItemCount
  local can_add = self.curItemCount < self.maxItemCount
  if can_dec then
    UIGray.SetGray(self.inputDecBtn.transform, false, true)
  else
    UIGray.SetGray(self.inputDecBtn.transform, true, false)
  end
  if can_add then
    UIGray.SetGray(self.inputAddBtn.transform, false, true)
  else
    UIGray.SetGray(self.inputAddBtn.transform, true, false)
  end
  self.inputSlider:SetValueWithoutNotify(self.curItemCount / self.maxItemCount)
end

function UILWBagMainView:SetInputGoActive(value)
  self.inputGo:SetActive(value)
end

function UILWBagMainView:OnInputSliderChanged(value)
  if self.canSliderChange then
    local percent = math.floor(value * self.maxItemCount)
    percent = math.max(self.minItemCount, percent)
    percent = math.min(self.maxItemCount, percent)
    self:SetInputText(percent)
  end
end

function UILWBagMainView:ClearEquipPropScroll()
  self.isEquipScrollInited = false
  self.equipPropContent:RemoveComponents(UIEquipPropertyLineItem)
  self.equipPropContentScroll:DestroyChildNode()
end

function UILWBagMainView:OnInitEquipPropScroll(go, index)
  local item = self.equipPropContent:AddComponent(UIEquipPropertyLineItem, go)
  self.listEquipPropGO[go] = item
end

function UILWBagMainView:OnUpdateEquipPropScroll(go, index)
  local item = self.listEquipPropGO[go]
  local propertyData = self.propertiesDataList[index + 1]
  item:SetActive(propertyData ~= nil)
  if propertyData ~= nil then
    item:SetData(propertyData)
  end
end

function UILWBagMainView:OnDestroyEquipPropScrollItem(go, index)
end

function UILWBagMainView:RefreshEquipInfo(value)
  local equipDatas = self.itemList[self.curSelectCell]
  local equipType = self.typeMap[self.curSelectCell]
  self.equipInfoPowerGo:SetActive(true)
  self.equip_info_des:SetActive(equipType == BagItemType.ResourceItem)
  local name_txt = ""
  local itemId, resId
  if equipType == BagItemType.HeroEquip then
    name_txt = Localization:GetString(equipDatas.config.name)
    self.equipInfoPower:SetText(equipDatas.power)
  elseif equipType == BagItemType.CommonEquip then
    name_txt = equipDatas:GetConfigName()
    self.equipInfoPower:SetText(equipDatas:GetPower())
    itemId = equipDatas.configId
  elseif equipType == BagItemType.ResourceItem then
    self.equipInfoPowerGo:SetActive(false)
    resId = self.itemList[self.curSelectCell].itemId
    local name = DataCenter.ResourceItemDataManager:GetName(resId)
    local desc = DataCenter.ResourceItemDataManager:GetDes(resId)
    name_txt = name
    self.equip_info_des:SetText(desc)
  end
  if GMUtils.GetBool(GMConst.ShowBagMaster, false) then
    EventManager:GetInstance():Broadcast(EventId.GM_BagMasterSelectionChanged, {
      tab = self.curTab,
      name = name_txt,
      itemId = itemId,
      resId = resId
    })
  end
  if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
    name_txt = string.format("%s[%s][%s]", name_txt, equipType, equipDatas.configId or equipDatas.itemId)
  end
  self.equipInfoName:SetText(name_txt)
  local properties = {}
  self.propertiesDataList = {}
  if equipType == BagItemType.HeroEquip then
    properties = equipDatas:GetAllProperty()
    for k, v in pairs(properties) do
      local data = {}
      data.id = k
      data.value = v
      table.insert(self.propertiesDataList, data)
    end
  elseif equipType == BagItemType.CommonEquip then
    properties = equipDatas:GetEffects()
    for k, v in pairs(properties) do
      local data = {}
      data.id = v.key
      data.value = v.value
      table.insert(self.propertiesDataList, data)
    end
  end
  table.sort(self.propertiesDataList, function(a, b)
    local effectATemplate = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(a.id)
    local effectBTemplate = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(b.id)
    return effectATemplate.sequence < effectBTemplate.sequence
  end)
  if not self.isEquipScrollInited then
    self.isEquipScrollInited = true
    local bindFunc11 = BindCallback(self, self.OnInitEquipPropScroll)
    local bindFunc22 = BindCallback(self, self.OnUpdateEquipPropScroll)
    local bindFunc33 = BindCallback(self, self.OnDestroyEquipPropScrollItem)
    self.equipPropContentScroll:Init(bindFunc11, bindFunc22, bindFunc33)
  end
  local dataCount = #self.propertiesDataList
  self.equipPropContentScroll:SetItemCount(dataCount)
  self.equipPropContentScroll:ForceUpdate()
  self.useBtn:SetActive(true)
  if equipType == BagItemType.HeroEquip then
    self.un_equip = equipDatas.heroUuid == nil or equipDatas.heroUuid <= 0
    if not self.un_equip then
      self.equipedHeroUuid = equipDatas.heroUuid
    end
    local canPromote = DataCenter.EquipDataManager:IsPromoteFunctionOpen() and equipDatas:CanStartPromote()
    local canUpgrade = false
    if not canPromote then
      canUpgrade = not equipDatas:IsMaxLevel()
    end
    if self.un_equip then
      local text = EQUIP_TITLE_TXT
      if canPromote then
        text = 110150
      elseif canUpgrade then
        text = 151049
      end
      self.useBtnNameTxt:SetLocalText(text)
      self.useBtnNameTxt:SetLocalPositionXYZ(0, 8.5, 0)
    else
      local text = EQUIPED_TITLE_TXT
      if canPromote then
        text = 110150
      elseif canUpgrade then
        text = 151049
      end
      self.useBtnNameTxt:SetLocalText(text)
      self.useBtnNameTxt:SetLocalPositionXYZ(42, 8.5, 0)
      self.equipedHeroCell:SetData(self.equipedHeroUuid)
      self.equipedHeroCell:DisableRedPoint()
      self.equipedHeroCell:SetActive(true)
    end
  elseif equipType == BagItemType.CommonEquip then
    self.un_equip = not equipDatas:IsBeingWeared()
    if not self.un_equip then
      self.equipedHeroUuid = equipDatas.ownerUid
    end
    if self.un_equip then
      self.useBtnNameTxt:SetLocalText(2000577)
      self.useBtnNameTxt:SetLocalPositionXYZ(0, 8.5, 0)
    else
      self.useBtnNameTxt:SetLocalText(2000577)
      self.useBtnNameTxt:SetLocalPositionXYZ(0, 8.5, 0)
    end
  elseif equipType == BagItemType.ResourceItem then
    self.useBtn:SetActive(false)
  end
end

function UILWBagMainView:OnEquipPromoteWindowExit(equipUuid)
  if self.curTab ~= UIBagTab.Equip then
    return
  end
  if not equipUuid then
    return
  end
  local index
  for i = 1, #self.itemList do
    if self.itemList[i].uuid == equipUuid then
      index = i
      break
    end
  end
  if index ~= nil and index == self.curSelectCell then
    return
  end
  if index ~= nil then
    if self.cellItems[index] and self.cellItems[index].itemScript then
      self.cellItems[index]:OnBtnClick()
    else
      self:ClearAllCellSelected()
      self:CellsCallBack_RefreshData(index)
      self.itemSelectFrame:SetActive(false)
      self.itemSelectFrame.transform:SetParent(self.transform)
    end
    self.loopGridViewItemHolder:MovePanelToItemByIndex(index - 1, 0)
  end
end

function UILWBagMainView:RefreshView()
  self:RefreshList()
end

function UILWBagMainView:OnEquipDetialChangePage(equipUuid)
  if self.curTab ~= UIBagTab.Equip then
    return
  end
  if not equipUuid then
    return
  end
  local euqipData = DataCenter.EquipDataManager:GetEquipByUuid(equipUuid)
  if not euqipData then
    return
  end
  local index
  for i = 1, #self.itemList do
    if self.itemList[i].uuid == equipUuid then
      index = i
      break
    end
  end
  if index ~= nil and index == self.curSelectCell then
    return
  end
  if index ~= nil then
    if self.cellItems[index] and self.cellItems[index].itemScript then
      self.cellItems[index]:OnBtnClick()
    else
      self:ClearAllCellSelected()
      self:CellsCallBack_RefreshData(index)
      self.itemSelectFrame:SetActive(false)
      self.itemSelectFrame.transform:SetParent(self.transform)
    end
    self.loopGridViewItemHolder:MovePanelToItemByIndex(index - 1, 0)
  end
end

function UILWBagMainView:OnEquipDataChange()
  if self.curTab ~= UIBagTab.Equip then
    return
  end
  local equipUuid
  if self.curSelectCell ~= nil then
    equipUuid = self.itemList[self.curSelectCell].uuid
  end
  local prevSelectCell = self.curSelectCell
  self:RefreshList()
  local index
  for i = 1, #self.itemList do
    if self.itemList[i].uuid == equipUuid then
      index = i
      break
    end
  end
  if index ~= nil and prevSelectCell ~= nil and index == prevSelectCell then
    self:RefreshInfo()
    return
  end
  if index ~= nil then
    self.loopGridViewItemHolder:RefreshAllShownItem()
  end
  if index ~= nil then
    if self.cellItems[index] and self.cellItems[index].itemScript then
      self.cellItems[index]:OnBtnClick()
    else
      self:ClearAllCellSelected()
      self:CellsCallBack_RefreshData(index)
      self.itemSelectFrame:SetActive(false)
      self.itemSelectFrame.transform:SetParent(self.transform)
    end
    self.loopGridViewItemHolder:MovePanelToItemByIndex(index - 1, 0)
  end
end

function UILWBagMainView:OnExpiredItemsConvert(msg)
  if not msg then
    return
  end
  if table.IsNullOrEmpty(msg.costItems) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWExpiredItemConvert, {anim = true}, msg)
end

local ResetResourceType = {
  ResourceType.Wood,
  ResourceType.Metal,
  ResourceType.Food,
  ResourceType.FLINT,
  ResourceType.OBSIDIAN,
  ResourceType.Petroleum
}
local ResourceType2FuncUnlockID = {
  [ResourceType.Wood] = LWFunctionUnlockType.MainUI_CoinBar,
  [ResourceType.Metal] = LWFunctionUnlockType.MainUI_MetalBar,
  [ResourceType.Food] = LWFunctionUnlockType.MainUI_FoodBar,
  [ResourceType.Petroleum] = LWFunctionUnlockType.MainUI_PetroleumBar
}

function UILWBagMainView:RefreshResourceCells()
  self:ClearResBarCells()
  if ResetResourceType ~= nil then
    local goItem, theItem
    local inSeason = SeasonUtil.IsInSeason(true)
    local visibleSiblingIndex = 0
    for k, v in ipairs(ResetResourceType) do
      local unlocked = true
      local funcUnlockID = ResourceType2FuncUnlockID[v]
      if funcUnlockID ~= nil then
        unlocked = DataCenter.LWFunctionUnlockManager:CheckCanShow(funcUnlockID)
      end
      if not inSeason and (ResourceType.OBSIDIAN == v or ResourceType.FLINT == v) then
        unlocked = false
      elseif ResourceType.OBSIDIAN == v and LuaEntry.Resource:GetCntByResType(v) == 0 then
        unlocked = false
      elseif ResourceType.FLINT == v and LuaEntry.Resource:GetCntByResType(v) == 0 then
        unlocked = false
      elseif ResourceType.Petroleum == v and 0 < LuaEntry.Resource:GetCntByResType(v) then
        unlocked = true
      end
      if unlocked then
        local param = {}
        param.resourceType = v
        param.iconName = DataCenter.ResourceManager:GetResourceIconByType(v)
        param.showExpandAnimation = false
        param.showExpandParam = false
        local siblingIndex = visibleSiblingIndex
        visibleSiblingIndex = visibleSiblingIndex + 1
        local req = self:GameObjectInstantiateAsync(ResBarCellPath, function(req)
          if req == nil or IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          NameCount = NameCount + 1
          item.name = "res_" .. NameCount
          item:SetActive(true)
          item.transform:SetParent(self.resourceBar.transform, false)
          item.transform:SetSiblingIndex(siblingIndex)
          local cell = self.resourceBar:AddComponent(UIMainResourceProgress, item.name)
          cell:ReInit(param)
          table.insert(self.resBarCellScripts, cell)
        end)
        table.insert(self.resBarCellGoReqs, req)
      end
    end
  end
end

function UILWBagMainView:ResourceUpdatedSignal()
  if self.resBarCellScripts then
    for k, v in pairs(self.resBarCellScripts) do
      if v ~= nil then
        v:Refresh()
      end
    end
  end
end

function UILWBagMainView:Update1000MS()
  self:UpdateWillExpireTime()
end

function UILWBagMainView:UpdateWillExpireTime()
  if self.showExpireTime == true then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if self.expireTime and self.expireTime - now > 0 then
      self.willExpireTime:SetText(Localization:GetString("s1_gift_tips_7", UITimeManager:GetInstance():SecondToFmtString(self.expireTime - now)))
    else
      self.willExpireTime:SetText("")
      self:RefreshInfo()
    end
  end
end

local function RefreshGotTotalNum(self, index, value)
  local active = false
  if index and (self.curTab == UIBagTab.Resource or self.curTab == UIBagTab.Hero) and self.itemList and self.itemList[self.curSelectCell] ~= nil then
    local param = self.itemList[self.curSelectCell]
    local template = param.template or DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
    local txt = ""
    if template and template.type == GOODS_TYPE.GOODS_TYPE_3 or template.type == GOODS_TYPE.GOODS_TYPE_109 then
      active = true
      local num = DataCenter.ItemTemplateManager:GetResGoodsUnitNumByTemplate(template)
      if num then
        txt = string_GetFormattedStr2(num * value)
      end
    end
    if not string_IsNullOrEmpty(txt) then
      self.got_total_num:SetText(txt)
    else
      active = false
    end
  end
  self.total_num_group:SetActive(active)
end

local function RefreshDownArrow(self)
  if self.scrollRectValid then
    local vP = self.itemInfoScroll:GetVerticalNormalizedPosition()
    self.itemInfoArrow:SetActive(0.1 < vP)
  else
    self.itemInfoArrow:SetActive(false)
  end
end

function UILWBagMainView:ClearSpecialItemInfoReq()
  if self.loadSpecialItemInfoReq then
    if self.curSpecialItemScript then
      self.itemInfoSpecialGo:RemoveComponents(self.curSpecialItemScript)
    end
    self:GameObjectDestroy(self.loadSpecialItemInfoReq)
    self.loadSpecialItemInfoReq = nil
  end
end

function UILWBagMainView:LoadSpecialItemInfo(itemData)
  self.itemInfoNormalGo:SetActive(false)
  self.itemInfoSpecialGo:SetActive(true)
  self:ClearSpecialItemInfoReq()
  self.loadSpecialItemInfoReq = self:GameObjectInstantiateAsync(SPECIAL_ITEM_INFO_PATH[itemData.type], function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.itemInfoSpecialGo.transform)
    go.transform:Set_localScale(1, 1, 1)
    self.curSpecialItemScript = require(SCRIPT_PRE_PATH .. SPECIAL_ITEM_INFO_SCRIPT[itemData.type])
    self.specialInfoItem = self.itemInfoSpecialGo:AddComponent(self.curSpecialItemScript, go.name)
    self.specialInfoItem:SetAnchoredPositionXY(0, 0)
    self.specialInfoItem:SetData(itemData)
  end)
end

function UILWBagMainView:ClearAllCellSelected()
  for k, v in pairs(self.cellItems) do
    v:SetSelectState(false)
  end
end

function UILWBagMainView:OnCloseBtnClick()
  self.ctrl:CloseSelf()
end

function UILWBagMainView:ClearResBarCells()
  if table.count(self.resBarCellScripts) > 0 then
    self.resourceBar:RemoveComponents(UIMainResourceProgress)
    self.resBarCellScripts = {}
  end
  if table.count(self.resBarCellGoReqs) then
    for _, req in pairs(self.resBarCellGoReqs) do
      req:Destroy()
    end
    self.resBarCellGoReqs = {}
  end
end

UILWBagMainView.RefreshGotTotalNum = RefreshGotTotalNum
UILWBagMainView.RefreshDownArrow = RefreshDownArrow
return UILWBagMainView
