local UIBagCell = require("UI.UICapacityTable.Component.UIBagCell")
local ResourceItem = require("UI.UICapacityTable.Component.ResourceItem")
local TabCell = require("UI.UICapacityTable.Component.TabCell")
local UICapacityTableView = BaseClass("UICapacityTableView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.UnityEngine.UI.Dropdown.OptionData
local panel_path = "UICommonPopUpTitle/panel"
local this_path = ""
local scrollBg_view_path = "LayerGo/CellListBg"
local scroll_view_path = "LayerGo/CellListBg/CellList"
local content_view_path = "LayerGo/CellListBg/CellList/Viewport/Content"
local package_path = "LayerGo/CellListBg/fullAdvCell"
local package_des_path = "LayerGo/CellListBg/fullAdvCell/Txt_PackageDes"
local package_buy_path = "LayerGo/CellListBg/fullAdvCell/Btn_Buy"
local package_buyDes_path = "LayerGo/CellListBg/fullAdvCell/Btn_Buy/Txt_Buy"
local tab_content_path = "TabContent"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local capacity_des_path = "LayerGo/Rect_Capacity/capacityDes"
local capacity_num_path = "LayerGo/Rect_Capacity/capacityDes/capacityNum"
local capacity_go_path = "LayerGo/Rect_Capacity"
local layout_go_path = "LayerGo"
local itemType_path = "ItemType"
local dropdown_path = "ItemType/Dropdown"
local item_bg_go_path = "ItemBg"
local item_path = "ItemBg/UIBagCell"
local item_name_path = "ItemBg/ItemName"
local item_des_path = "ItemBg/ItemDesBg/Viewport/Content/ItemDes"
local item_input_path = "ItemBg/InputGo/InputField"
local item_add_btn_path = "ItemBg/InputGo/InputField/AddBtn"
local item_add_btn_active_img_path = "ItemBg/InputGo/InputField/AddBtn/AddActiveImage"
local item_add_btn_inactive_img_path = "ItemBg/InputGo/InputField/AddBtn/AddInActiveImage"
local item_dec_btn_path = "ItemBg/InputGo/InputField/DecBtn"
local item_dec_btn_active_img_path = "ItemBg/InputGo/InputField/DecBtn/DecActiveImage"
local item_dec_btn_inactive_img_path = "ItemBg/InputGo/InputField/DecBtn/DecInActiveImage"
local item_max_btn_path = "ItemBg/InputGo/MaxBtn"
local item_max_text_path = "ItemBg/InputGo/MaxBtn/BtnImage/MaxBtnText"
local item_own_text_path = "ItemBg/OwnNum"
local item_use_btn_path = "ItemBg/UseBtn"
local item_use_btn_name_path = "ItemBg/UseBtn/UseBtnName"
local item_input_go_path = "ItemBg/InputGo"
local intro_btn_path = "ItemBg/Intro"
local cell_select_path = "SelectGo"
local empty_text_path = "EmptyText"
local scrollTest_view_path = "ItemListBg/ItemList"
local scrollTestBg_view_path = "ItemListBg"
local contentTest_view_path = "ItemListBg/ItemList/Content"
local extra_effect_path = "LayerGo/Rect_Capacity/capacityDes/capacityNum/UIExtraEffect"
local drop_all_path = "LayerGo/Rect_Capacity/DropAll"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.curCount = nil
  self.minCount = 1
  self.maxCount = 9999
  self.useBtnActive = nil
  self.useBtnName = nil
  self.maxBtnActive = nil
  self.maxBtnText = nil
  self.curSelectCell = nil
  self.redNum = 0
  self.lastCount = 0
  self.selectId = nil
  self.jumpItemID = nil
  self.ctrl:InitData()
  self:ReInit()
end

local function OnDestroy(self)
  DataCenter.ItemManager:SetLastType(self.curType)
  self.dropdown.value = 0
  self.jumpItemID = nil
  self:ExitResetRed()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.tab_content = self:AddComponent(UIBaseContainer, tab_content_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.capacity_des = self:AddComponent(UIText, capacity_des_path)
  self.capacity_num = self:AddComponent(UIText, capacity_num_path)
  self.capacity_go = self:AddComponent(UIBaseContainer, capacity_go_path)
  self.layout_go = self:AddComponent(UIBaseContainer, layout_go_path)
  self.content_view = self.transform:Find(content_view_path):GetComponent(typeof(CS.UnityEngine.UI.GridLayoutGroup))
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scrollBg_view = self:AddComponent(UIImage, scrollBg_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.itemType = self:AddComponent(UIBaseContainer, itemType_path)
  self.dropdown = self.transform:Find(dropdown_path):GetComponent(typeof(CS.UnityEngine.UI.Dropdown))
  self.dropdown.onValueChanged:AddListener(function()
    self:OnValueChange()
  end)
  self:ShowAccount()
  self.itembg = self:AddComponent(UIBaseContainer, item_bg_go_path)
  self.item = self:AddComponent(UIBagCell, item_path)
  self.item_name = self:AddComponent(UIText, item_name_path)
  self.item_des = self:AddComponent(UIText, item_des_path)
  self.item_input = self:AddComponent(UIInput, item_input_path)
  self.item_add_btn = self:AddComponent(UIButton, item_add_btn_path)
  self.item_dec_btn = self:AddComponent(UIButton, item_dec_btn_path)
  self.item_add_btn_active_img = self:AddComponent(UIImage, item_add_btn_active_img_path)
  self.item_add_btn_inactive_img = self:AddComponent(UIImage, item_add_btn_inactive_img_path)
  self.item_dec_btn_active_img = self:AddComponent(UIImage, item_dec_btn_active_img_path)
  self.item_dec_btn_inactive_img = self:AddComponent(UIImage, item_dec_btn_inactive_img_path)
  self.item_add_btn_inactive_img:SetActive(false)
  self.item_dec_btn_inactive_img:SetActive(false)
  self.item_max_btn = self:AddComponent(UIButton, item_max_btn_path)
  self.item_max_text = self:AddComponent(UIText, item_max_text_path)
  self.item_own_text = self:AddComponent(UIText, item_own_text_path)
  self.item_use_btn = self:AddComponent(UIButton, item_use_btn_path)
  self.item_use_btn_name = self:AddComponent(UIText, item_use_btn_name_path)
  self.cell_select = self:AddComponent(UIBaseContainer, cell_select_path)
  self.item_input_go = self:AddComponent(UIBaseContainer, item_input_go_path)
  self.empty_text = self:AddComponent(UIText, empty_text_path)
  self.empty_text:SetLocalText(GameDialogDefine.NO_ANY_GOODS)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickItemRate()
  end)
  self.item_add_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnAddBtnClick()
  end)
  self.item_dec_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnDecBtnClick()
  end)
  self.item_input:SetOnEndEdit(function(value)
    self:InputListener(value)
  end)
  self.item_max_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnMaxBtnClick()
  end)
  self.item_use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUseBtnClick()
  end)
  self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
  self.event_trigger:OnPointerDown(function(eventData)
    DataCenter.ArrowManager:RemoveArrow()
  end)
  self.itemList = {}
  self.model = {}
  self.tabCells = {}
  self.cells = {}
  self.listGO = {}
  self.scrollTest_view = self:AddComponent(UIBaseContainer, scrollTest_view_path)
  self.scrollTestBg_view = self:AddComponent(UIBaseContainer, scrollTestBg_view_path)
  self.contentTest_view = self:AddComponent(GridInfinityScrollView, contentTest_view_path)
  self.extra_effect = self:AddComponent(UIButton, extra_effect_path)
  self.extra_effect:SetOnClick(function()
    self:OnClickOpenCapacityFull(true)
  end)
  self.packageObj = self:AddComponent(UIBaseContainer, package_path)
  self.package_des = self:AddComponent(UIText, package_des_path)
  self.package_buy = self:AddComponent(UIButton, package_buy_path)
  self.package_buyDes = self:AddComponent(UIText, package_buyDes_path)
  self.package_buy:SetOnClick(function()
    self:OnClickJumpToPackBtn()
  end)
  self.drop_all_btn = self:AddComponent(UIButton, drop_all_path)
  self.drop_all_btn:SetOnClick(function()
    self:OnDropAllClick()
  end)
  self.drop_all_btn:SetActive(CS.CommonUtils.IsDebug())
end

local function ComponentDestroy(self)
  self.tab_content:RemoveComponents(TabCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cell_select.transform:SetParent(self.transform)
  self.cell_select = nil
  self.model = nil
  self.btn = nil
  self.close_btn = nil
  self.tab_content = nil
  self.txt_title = nil
  self.scroll_view = nil
  self.itemList = nil
  self.capacity_go = nil
  self.packageObj = nil
  self.layout_go = nil
  pcall(function()
    self.dropdown.onValueChanged:Clear()
  end)
  self.dropdown = nil
  self.cells = nil
  self.curCount = nil
  self.minCount = nil
  self.maxCount = nil
  self.selectItemOwnText = nil
  self.useBtnActive = nil
  self.useBtnName = nil
  self.maxBtnActive = nil
  self.maxBtnText = nil
  self.curSelectCell = nil
  self.item = nil
  self.item_name = nil
  self.item_des = nil
  self.item_input = nil
  self.item_add_btn = nil
  self.item_dec_btn = nil
  self.item_max_btn = nil
  self.item_max_text = nil
  self.item_own_text = nil
  self.item_use_btn = nil
  self.item_use_btn_name = nil
  self.empty_text = nil
  self.item_input_go = nil
  self.redNum = nil
  self.event_trigger = nil
  self.selectId = nil
  self:ClearItemCell()
  self.contentTest_view = nil
  self.scrollTest_view = nil
  self.extra_effect = nil
  self.drop_all_btn = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  DataCenter.ArrowManager:RemoveArrow()
  base.OnDisable(self)
end

local function ExitResetRed(self)
  if next(self.itemList) then
    for i = 1, #self.itemList do
      if self.itemList[i].template and self.itemList[i].template.important == 2 then
        DataCenter.ItemData:SetItemRed(self.itemList[i].data.uuid)
      end
    end
  end
end

function UICapacityTableView:ClearItemCell()
  self.scrollTest_view:RemoveComponents(ResourceItem)
  self.contentTest_view:DestroyChildNode()
end

function UICapacityTableView:OnInitScroll(go, index)
  local item = self.scrollTest_view:AddComponent(ResourceItem, go)
  self.listGO[go] = item
end

function UICapacityTableView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  go.name = self.itemList[index + 1].itemId
  local param = {}
  local sub = self.itemList[index + 1]
  param = sub
  param.index = index + 1
  
  function param.callBack(trans, index)
    self:CellsCallBack(trans, index)
  end
  
  cellItem:RefreshData(param)
  cellItem:RedDotRefresh(param.redState)
  if index + 1 == self.curSelectCell then
    self.curSelectCell = nil
    self:CellsCallBack(cellItem.transform, index + 1)
  end
end

function UICapacityTableView:OnDestroyScrollItem(go, index)
  if index == self.curSelectCell then
    self.cell_select:SetActive(false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SoldResourceItem, self.RefreshItemState)
  self:AddUIListener(EventId.ResourceUpdated, self.ResourceUpdatedSignal)
  self:AddUIListener(EventId.RefreshBagItems, self.RefreshItemsToCell)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
  self:AddUIListener(EventId.VipDataRefresh, self.VipUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SoldResourceItem, self.RefreshItemState)
  self:RemoveUIListener(EventId.ResourceUpdated, self.ResourceUpdatedSignal)
  self:RemoveUIListener(EventId.RefreshBagItems, self.RefreshItemsToCell)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
  self:RemoveUIListener(EventId.VipDataRefresh, self.VipUpdate)
end

local function RedReference(self, index)
  self.redNum = self.redNum - 1
  self.itemList[index].redState = true
  if self.redNum <= 0 then
    self.tabCells[UICapacityTableTab.Item]:RedRefresh(false)
  end
end

local function ReInit(self)
  local curTypeStr, jumpItemID = self:GetUserData()
  if curTypeStr then
    self.curType = tonumber(curTypeStr)
  else
    local last = DataCenter.ItemManager:GetLastType()
    if last then
      self.curType = last
    else
      self.curType = UICapacityTableTab.Farming
    end
  end
  self.jumpItemID = jumpItemID
  if #self.model <= 0 then
    self:AddOneTabCells(UICapacityTableTab.Farming)
    self:AddOneTabCells(UICapacityTableTab.Item)
  end
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentTest_view:Init(bindFunc1, bindFunc2, bindFunc3)
  self:RefreshList()
end

local function ClearScroll(self)
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(ResourceItem)
end

local function RefreshList(self)
  self:RefreshTitleName()
  self.itembg:SetActive(self.curType == UICapacityTableTab.Item)
  if self.curType == UICapacityTableTab.Item then
    self.curSelectCell = 1
    self.scrollTestBg_view:SetActive(true)
    self.scrollBg_view:SetEnable(false)
    self.scroll_view:SetActive(false)
    self.itemType:SetActive(true)
    self.redNum = self.ctrl:GetTabRedState(UICapacityTableTab.Item)
  else
    self.scrollTestBg_view:SetActive(false)
    self.scroll_view:SetActive(true)
    self.cell_select:SetActive(false)
    self.scroll_view:ResetContentConstraintCount()
    self.scroll_view.rectTransform:Set_sizeDelta(966, 0)
    self.scrollBg_view:SetEnable(true)
    self.itemType:SetActive(false)
    self.curSelectCell = nil
    self.content_view.constraintCount = 6
  end
  if self.curType == UICapacityTableTab.Resource or self.curType == UICapacityTableTab.Item then
    self.capacity_go:SetActive(false)
    self.packageObj:SetActive(false)
  else
    self.capacity_go:SetActive(true)
    self.packageObj:SetActive(true)
    self:RefreshPackage()
    if self.curType == UICapacityTableTab.Farming then
      self.capacity_des:SetLocalText(100505)
    else
      self.capacity_des:SetLocalText(100506)
    end
    self:CheckSlider()
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout_go.rectTransform)
  self:ClearScroll()
  self.itemList = self.view.ctrl:GetItemListByType(self.curType, self.dropdown.value, self.selectId)
  self.lastCount = #self.itemList
  self.itembg:SetActive(false)
  self.empty_text:SetActive(false)
  self:SetData(HeroStationEffectType.StorageLimit)
  for i = 1, #self.itemList do
    if self.itemList[i].itemId == self.jumpItemID then
      self.curSelectCell = i
      break
    end
  end
  self.jumpItemID = nil
  if self.curType == UICapacityTableTab.Item then
    self.scrollTestBg_view:SetActive(0 < self.lastCount)
    self.empty_text:SetActive(0 >= self.lastCount)
    if 0 < self.lastCount then
      self.itembg:SetActive(true)
    end
    if 0 < self.lastCount then
      self.contentTest_view:SetItemCount(self.lastCount)
      self.contentTest_view:MoveItemByIndex(self.curSelectCell - 1, 0)
    end
    return
  end
  if 0 < #self.itemList then
    self.scroll_view:SetTotalCount(#self.itemList)
    self.scroll_view:RefillCells()
    if self.curSelectCell then
      self.scroll_view:ScrollToCell(self.curSelectCell)
    end
  end
end

local function RefreshPackage(self)
  local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
  local isBuy = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  if isBuy or not isAvailable then
    self.packageObj:SetActive(false)
    return
  end
  if isAvailable and not isBuy then
    self.packageObj:SetActive(true)
  end
  self.package_des:SetLocalText(320545)
  self.package_buyDes:SetLocalText(110003)
end

local function OnClickJumpToPackBtn(self)
  EventManager:GetInstance():Broadcast(EventId.MonthCardInfoUpdated)
  self.ctrl:CloseSelf()
  GoToUtil.GoToMonthCard()
end

local function ShowAccount(self)
  for i = 0, 4 do
    self.dropdown.options[i].text = self.ctrl:GetItemTypeName(i)
  end
  self.dropdown.captionText.text = Localization:GetString("150118")
end

local function CheckSlider(self)
  local storageMax = 0
  local curNum = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(self.curType)
  if self.curType == UICapacityTableTab.Farming then
    storageMax = DataCenter.ResourceItemDataManager:GetFreezerStorageMax()
  else
    storageMax = DataCenter.ResourceItemDataManager.warehouseStorageMax
  end
  self.capacity_num:SetText(tostring(curNum) .. "/" .. math.floor(storageMax))
end

local function RefreshItemsToCell(self)
  if self.curType ~= UICapacityTableTab.Item then
    return
  end
  self.itemList = self.view.ctrl:GetItemListByType(self.curType, self.dropdown.value, self.selectId)
  if #self.itemList > 0 then
    self.empty_text:SetActive(false)
    self.contentTest_view:SetItemCount(#self.itemList)
  else
    self.scrollTestBg_view:SetActive(false)
    self.empty_text:SetActive(true)
    self:ItemBgClear()
  end
end

local function OnValueChange(self)
  self.itemList = self.view.ctrl:GetItemListByType(self.curType, self.dropdown.value, self.selectId)
  self.lastCount = #self.itemList
  if #self.itemList > 0 then
    self.itembg:SetActive(true)
    self.contentTest_view:SetItemCount(#self.itemList)
    self.contentTest_view:MoveItemByIndex(0, 0)
    self.scrollTestBg_view:SetActive(true)
    self.empty_text:SetActive(false)
    for i, v in pairs(self.listGO) do
      if v:GetIndex() == 1 then
        self:CellsCallBack(v.transform, 1)
        break
      end
    end
  else
    self.scrollTestBg_view:SetActive(false)
    self.empty_text:SetActive(true)
    self:ItemBgClear()
    self.itembg:SetActive(false)
  end
  self.tabCells[UICapacityTableTab.Item]:RedRefresh(false)
end

local function ItemBgClear(self)
  self.item_name:SetText("")
  self.item:ClearInfo()
  self.item_des:SetText("")
  self.item_input_go:SetActive(false)
  self.item_own_text:SetText("")
  self.item_use_btn:SetActive(false)
end

local function OnAddBtnClick(self)
  local curParam = self.itemList[self.curSelectCell]
  local itemTemplate = curParam.template or DataCenter.ItemTemplateManager:GetItemTemplate(curParam.itemId)
  local p = (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99) and HeroUtils.GetJigsawCost(curParam.itemId) or self.minCount
  if self.curCount + p <= self.maxCount then
    self:SetInputText(self.curCount + p)
  end
end

local function OnDecBtnClick(self)
  local curParam = self.itemList[self.curSelectCell]
  local itemTemplate = curParam.template or DataCenter.ItemTemplateManager:GetItemTemplate(curParam.itemId)
  local p = (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99) and HeroUtils.GetJigsawCost(curParam.itemId) or self.minCount
  if p < self.curCount then
    self:SetInputText(self.curCount - p)
  end
end

local function InputListener(self)
  local temp = self.item_input:GetText()
  if temp ~= nil and temp ~= "" then
    local inputCount = tonumber(temp)
    if inputCount <= self.minCount then
      self:SetInputText(self.minCount)
    elseif inputCount >= self.maxCount then
      self:SetInputText(self.maxCount)
    else
      self:SetInputText(inputCount)
    end
  end
end

local function OnMaxBtnClick(self)
  local curParam = self.itemList[self.curSelectCell]
  local itemTemplate = curParam.template or DataCenter.ItemTemplateManager:GetItemTemplate(curParam.itemId)
  if itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
    local cost = HeroUtils.GetJigsawCost(curParam.itemId)
    local max = cost >= self.maxCount and self.maxCount or self.maxCount // cost * cost
    if self.curCount ~= max then
      self:SetInputText(max)
    end
  elseif self.curCount ~= self.maxCount then
    self:SetInputText(self.maxCount)
  end
end

local function OnUseBtnClick(self)
  self.ctrl:OnItemUse(DataCenter.ItemData:GetItemById(self.itemList[self.curSelectCell].itemId), self.curCount)
end

local function CellsCallBack(self, trans, index)
  if self.curSelectCell ~= index then
    self.curSelectCell = index
    self.cell_select.transform:SetParent(trans:GetChild(0))
    if index == 1 then
      self.cell_select.transform:SetSiblingIndex(8)
    else
      self.cell_select.transform:SetSiblingIndex(8)
    end
    self.cell_select.transform:Set_localPosition(0, 2, 0)
    self.cell_select.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.cell_select:SetActive(true)
    self:RefreshSelectCell()
  else
    self:RefreshSelectCell()
  end
end

local function RefreshSelectCell(self)
  local param = UIBagCell.Param.New()
  param.itemId = self.itemList[self.curSelectCell].itemId
  self.item:ReInit(param)
  local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
  if itemData ~= nil then
    self:SetItemNameText(DataCenter.ItemTemplateManager:GetName(param.itemId))
    self:SetItemDesText(DataCenter.ItemTemplateManager:GetDes(param.itemId))
    local item = DataCenter.ItemData:GetItemById(param.itemId)
    if item ~= nil then
      self:SetItemOwnText(Localization:GetString("130128", item.count))
    else
      self:SetItemOwnText(Localization:GetString("130128", 0))
    end
    self.intro_btn:SetActive(itemData.rate_show ~= "")
    local isHeroJigsaw = itemData.type == GOODS_TYPE.GOODS_TYPE_98 or itemData.type == GOODS_TYPE.GOODS_TYPE_99
    self.item_input:SetInteractable(not isHeroJigsaw)
    if isHeroJigsaw then
      self:SetInputText(math.min(HeroUtils.GetJigsawCost(param.itemId), item.count))
    else
      self:SetInputText(self.minCount)
    end
    self:SetUseBtnNameText(Localization:GetString("110046"))
    self:SetMaxBtnActive(true)
    self:SetMaxBtnText(Localization:GetString("150072"))
    if item ~= nil then
      self.maxCount = item.count
      self:SetAddAndDecBtnState()
      local useAll = itemData.useall
      if useAll ~= nil and useAll == 1 then
        self:SetInputGoActive(true)
      else
        self:SetInputGoActive(false)
      end
      if itemData.use ~= nil then
        if itemData.use ~= 1 then
          self:SetUseBtnActive(false)
        else
          self:SetUseBtnActive(true)
        end
      else
        local strGoto = itemData.go_to
        if strGoto ~= nil and 0 < string.len(strGoto) and tonumber(strGoto) == 7 then
          self:SetUseBtnActive(true)
        else
          self:SetUseBtnActive(false)
        end
      end
      local type = itemData.type
      local type2 = itemData.type2
      if type == 3 and type2 == 999 then
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
      elseif param.itemId == "200070" then
        isNeedOtherBtn = true
      elseif param.itemId == CS.FBDrawActController.Instance.m_outToolId then
        isNeedOtherBtn = true
      else
        isNeedOtherBtn = false
      end
      if isNeedOtherBtn then
        self:SetUseBtnActive(true)
        self:SetUseBtnNameText(strOtherText)
      end
    end
  end
end

local function SetItemNameText(self, value)
  self.item_name:SetText(value)
end

local function SetItemDesText(self, value)
  self.item_des:SetText(value)
end

local function SetItemOwnText(self, value)
  self.item_own_text:SetText(value)
end

local function SetInputText(self, value)
  local currentText = self.item_input:GetText()
  if self.curCount ~= value or currentText ~= tostring(value) then
    self.curCount = value
    self.item_input:SetText(value)
  end
  self:SetAddAndDecBtnState()
end

local function SetAddAndDecBtnState(self)
  self.item_dec_btn:SetInteractable(self.curCount > self.minCount)
  self.item_add_btn:SetInteractable(self.curCount < self.maxCount)
  self.item_add_btn_active_img:SetActive(self.curCount < self.maxCount)
  self.item_add_btn_inactive_img:SetActive(self.curCount >= self.maxCount)
  self.item_dec_btn_active_img:SetActive(self.curCount > self.minCount)
  self.item_dec_btn_inactive_img:SetActive(self.curCount <= self.minCount)
end

local function SetMaxBtnActive(self, value)
  if self.maxBtnActive ~= value then
    self.maxBtnActive = value
    self.item_max_btn.gameObject:SetActive(value)
  end
end

local function SetMaxBtnText(self, value)
  if self.maxBtnText ~= value then
    self.maxBtnText = value
    self.item_max_text:SetText(value)
  end
end

local function SetInputGoActive(self, value)
  if self.inputGoActive ~= value then
    self.inputGoActive = value
    self.item_input_go:SetActive(value)
  end
end

local function SetUseBtnActive(self, value)
  if self.useBtnActive ~= value then
    self.useBtnActive = value
    self.item_use_btn:SetActive(value)
  end
end

local function SetUseBtnNameText(self, value)
  if self.useBtnName ~= value then
    self.useBtnName = value
    self.item_use_btn_name:SetText(value)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  if self.curType == UICapacityTableTab.Item or self.curType == UICapacityTableTab.Farming then
    itemObj.name = tostring(self.itemList[index].itemId)
  elseif self.curType == UICapacityTableTab.Resource then
    itemObj.name = tostring(self.itemList[index].resourceType)
  end
  self.cells[index] = self.scroll_view:AddComponent(ResourceItem, itemObj)
  local param = {}
  param = self.itemList[index]
  param.index = index
  param.constraintCount = self.content_view.constraintCount
  self.cells[index]:RefreshData(param)
  self.cells[index]:RedDotRefresh(true)
end

local function OnItemMoveOut(self, itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, ResourceItem)
end

local function AddOneTabCells(self, tab)
  local param = {}
  param.tabType = tab
  
  function param.callBack(t)
    self:TabCallBack(t)
  end
  
  param.isSelect = tab == self.curType
  self.model[tab] = self:GameObjectInstantiateAsync(UIAssets.CapacityTab, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.tab_content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(tab)
    go.name = nameStr
    self.tabCells[tab] = self.tab_content:AddComponent(TabCell, nameStr)
    self.tabCells[tab]:ReInit(param)
  end)
end

local function TabCallBack(self, tab)
  if self.curType ~= tab then
    if self.curType == UICapacityTableTab.Item then
      self.tabCells[UICapacityTableTab.Item]:RedRefresh(false)
    end
    self.tabCells[tab]:SetSelect(true)
    self.tabCells[self.curType]:SetSelect(false)
    self.curType = tab
    self:RefreshList()
  end
  DataCenter.ArrowManager:RemoveArrow()
end

local function RefreshItemState(self, data)
  if self.curType == UICapacityTableTab.Farming then
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByUuid(data)
    if itemData == nil or itemData.number == 0 then
      self:RefreshList()
      return
    end
  end
  if self.curType == UICapacityTableTab.Farming then
    self:CheckSlider()
    if data ~= nil then
      for k, v in pairs(self.cells) do
        if v.uuid == data then
          v:RefreshNum()
        end
      end
    end
  end
end

local function ResourceUpdatedSignal(self)
  if self.curType == UICapacityTableTab.Resource then
    for k, v in pairs(self.cells) do
      v:RefreshNum()
    end
  end
end

local function RefreshTitleName(self)
  if self.curType == UICapacityTableTab.Resource then
    self.txt_title:SetLocalText(GameDialogDefine.RESOURCE)
  elseif self.curType == UICapacityTableTab.Farming then
    self.txt_title:SetLocalText(GameDialogDefine.CLOD_BUILD)
  elseif self.curType == UICapacityTableTab.Item then
    self.txt_title:SetLocalText(GameDialogDefine.GOODS)
  end
end

local function CheckGuide(self)
  if DataCenter.GuideManager:InGuide() then
    local guideTemplate = DataCenter.GuideManager:GetCurTemplate()
    if guideTemplate ~= nil and guideTemplate.para3 ~= nil and guideTemplate.para3 ~= "" and guideTemplate.type == GuideType.ClickButton then
      self.selectId = guideTemplate.para3
      self:RefreshList()
    end
  end
end

local function RefreshGuideSignal(self)
  self:CheckGuide()
end

local function OnSearchCallBack(self, param)
  if param ~= nil then
    self.ctrl:OnSearchEnd(param.pointId, param.uuid)
  end
end

local function VipUpdate(self, param)
  self.ctrl:VipUpdate(param)
end

local function OnClickOpenCapacityFull()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull, true)
end

local function SetData(self, effectType)
  if not DataCenter.HeroStationManager:Enabled() or effectType == nil then
    self.extra_effect:SetActive(false)
    return
  end
  DataCenter.HeroStationManager:ReCalcSkillAddition()
  self.extra_effect:SetActive(true)
end

local function OnClickItemRate(self)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemList[self.curSelectCell].itemId)
  if goods.rate_show ~= "" then
    local str = string.split(goods.rate_show, "|")
    local list = {}
    for i = 1, #str do
      local item = string.split(str[i], ";")
      local param = {}
      param.names = {}
      param.names[1] = DataCenter.ItemTemplateManager:GetName(item[1]) .. "x" .. item[2]
      param.names[2] = item[3] .. "%"
      table.insert(list, param)
    end
    local titleList = {
      [1] = 100080,
      [2] = 320476
    }
    local title = 320475
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonItemProbability, {anim = true}, list, titleList, title)
  end
end

local function OnDropAllClick(self)
  UIUtil.ShowMessage(Localization:GetString("128004", Localization:GetString("100375")), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    for _, v in ipairs(self.itemList) do
      local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v.itemId)
      if itemData and itemData.number > 0 then
        SFSNetwork.SendMessage(MsgDefines.SoldResourceItem, itemData.uuid, itemData.number)
      end
    end
  end)
end

UICapacityTableView.OnCreate = OnCreate
UICapacityTableView.OnDestroy = OnDestroy
UICapacityTableView.OnEnable = OnEnable
UICapacityTableView.OnDisable = OnDisable
UICapacityTableView.ComponentDefine = ComponentDefine
UICapacityTableView.ComponentDestroy = ComponentDestroy
UICapacityTableView.OnAddListener = OnAddListener
UICapacityTableView.OnRemoveListener = OnRemoveListener
UICapacityTableView.ReInit = ReInit
UICapacityTableView.ClearScroll = ClearScroll
UICapacityTableView.RefreshList = RefreshList
UICapacityTableView.OnItemMoveIn = OnItemMoveIn
UICapacityTableView.OnItemMoveOut = OnItemMoveOut
UICapacityTableView.AddOneTabCells = AddOneTabCells
UICapacityTableView.TabCallBack = TabCallBack
UICapacityTableView.CheckSlider = CheckSlider
UICapacityTableView.RefreshItemState = RefreshItemState
UICapacityTableView.ResourceUpdatedSignal = ResourceUpdatedSignal
UICapacityTableView.RefreshTitleName = RefreshTitleName
UICapacityTableView.RefreshItemsToCell = RefreshItemsToCell
UICapacityTableView.OnValueChange = OnValueChange
UICapacityTableView.ShowAccount = ShowAccount
UICapacityTableView.OnAddBtnClick = OnAddBtnClick
UICapacityTableView.OnDecBtnClick = OnDecBtnClick
UICapacityTableView.InputListener = InputListener
UICapacityTableView.OnMaxBtnClick = OnMaxBtnClick
UICapacityTableView.OnUseBtnClick = OnUseBtnClick
UICapacityTableView.CellsCallBack = CellsCallBack
UICapacityTableView.RefreshSelectCell = RefreshSelectCell
UICapacityTableView.SetItemNameText = SetItemNameText
UICapacityTableView.SetItemDesText = SetItemDesText
UICapacityTableView.SetItemOwnText = SetItemOwnText
UICapacityTableView.SetInputText = SetInputText
UICapacityTableView.SetAddAndDecBtnState = SetAddAndDecBtnState
UICapacityTableView.SetMaxBtnActive = SetMaxBtnActive
UICapacityTableView.SetMaxBtnText = SetMaxBtnText
UICapacityTableView.SetInputGoActive = SetInputGoActive
UICapacityTableView.SetUseBtnActive = SetUseBtnActive
UICapacityTableView.SetUseBtnNameText = SetUseBtnNameText
UICapacityTableView.ItemBgClear = ItemBgClear
UICapacityTableView.RedReference = RedReference
UICapacityTableView.CheckGuide = CheckGuide
UICapacityTableView.RefreshGuideSignal = RefreshGuideSignal
UICapacityTableView.OnSearchCallBack = OnSearchCallBack
UICapacityTableView.VipUpdate = VipUpdate
UICapacityTableView.OnClickOpenCapacityFull = OnClickOpenCapacityFull
UICapacityTableView.SetData = SetData
UICapacityTableView.RefreshPackage = RefreshPackage
UICapacityTableView.OnClickJumpToPackBtn = OnClickJumpToPackBtn
UICapacityTableView.OnClickItemRate = OnClickItemRate
UICapacityTableView.ExitResetRed = ExitResetRed
UICapacityTableView.OnDropAllClick = OnDropAllClick
return UICapacityTableView
