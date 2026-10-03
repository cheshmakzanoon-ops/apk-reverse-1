local UIStore = BaseClass("UIStore", UIBaseView)
local base = UIBaseView
local UIStoreCell = require("UI.UIStore.Component.UIStoreCell")
local UITypeButton = require("UI.UIStore.Component.UITypeButton")
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local scroll_view_path = "BgGo/MiddleBg/CellList"
local type_cells_content_path = "BgGo/TopBg"
local close_btn_path = "BgGo/CloseBtn"
local item_path = "BgGo/MiddleBg/ItemBg/UIStoreCell"
local item_name_path = "BgGo/MiddleBg/ItemBg/ItemName"
local item_des_path = "BgGo/MiddleBg/ItemBg/ItemDesBg/Viewport/Content/ItemDes"
local item_input_path = "BgGo/MiddleBg/ItemBg/InputField"
local item_add_btn_path = "BgGo/MiddleBg/ItemBg/InputField/AddBtn"
local item_dec_btn_path = "BgGo/MiddleBg/ItemBg/InputField/DecBtn"
local item_own_text_path = "BgGo/MiddleBg/ItemBg/OwnNum"
local item_buy_btn_path = "BgGo/MiddleBg/ItemBg/BuyBtn"
local item_buy_btn_name_path = "BgGo/MiddleBg/ItemBg/BuyBtn/BuyBtnName"
local item_buy_btn_speed_icon_path = "BgGo/MiddleBg/ItemBg/BuyBtn/LayerGo/SpendIcon"
local item_buy_btn_speed_count_path = "BgGo/MiddleBg/ItemBg/BuyBtn/LayerGo/SpendCount"
local cell_go_path = "CellGo"
local type_cell_path = "CellGo/TypeCell"
local type_cell_select_path = "CellGo/TypeCellSelect"
local cell_select_path = "CellGo/ItemCellSelect"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.type_cells_content = self:AddComponent(UIBaseContainer, type_cells_content_path)
  self.type_cells_layout_group = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, type_cells_content_path)
  self.item = self:AddComponent(UIStoreCell, item_path)
  self.item_name = self:AddComponent(UIText, item_name_path)
  self.item_des = self:AddComponent(UIText, item_des_path)
  self.item_input = self:AddComponent(UIInput, item_input_path)
  self.item_add_btn = self:AddComponent(UIButton, item_add_btn_path)
  self.item_dec_btn = self:AddComponent(UIButton, item_dec_btn_path)
  self.item_own_text = self:AddComponent(UIText, item_own_text_path)
  self.item_buy_btn = self:AddComponent(UIButton, item_buy_btn_path)
  self.item_buy_btn_name = self:AddComponent(UIText, item_buy_btn_name_path)
  self.item_buy_btn_speed_icon = self:AddComponent(UIImage, item_buy_btn_speed_icon_path)
  self.item_buy_btn_speed_count = self:AddComponent(UIText, item_buy_btn_speed_count_path)
  self.cell_go = self:AddComponent(UIBaseContainer, cell_go_path)
  self.type_cell = self:AddComponent(UIBaseContainer, type_cell_path).gameObject
  self.type_cell:GameObjectCreatePool()
  self.type_cell_select = self:AddComponent(UIBaseContainer, type_cell_select_path)
  self.cell_select = self:AddComponent(UIBaseContainer, cell_select_path).transform
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
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.item_add_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAddBtnClick()
  end)
  self.item_dec_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDecBtnClick()
  end)
  self.item_buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyBtnClick()
  end)
  self.item_input:SetOnEndEdit(function(value)
    self:InputListener(value)
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.close_btn = nil
  self.type_cells_content = nil
  self.type_cells_layout_group = nil
  self.item = nil
  self.item_name = nil
  self.item_des = nil
  self.item_input = nil
  self.item_add_btn = nil
  self.item_dec_btn = nil
  self.item_own_text = nil
  self.item_buy_btn = nil
  self.item_buy_btn_name = nil
  self.item_buy_btn_speed_icon = nil
  self.item_buy_btn_speed_count = nil
  self.type_cell_select.transform:SetParent(self.cell_go.transform)
  self.cell_select:SetParent(self.cell_go.transform)
  self.cell_go = nil
  self.type_cell = nil
  self.type_cell_select = nil
  self.cell_select = nil
  self.scroll_view = nil
  self.type_cells_layout_group = nil
end

local function DataDefine(self)
  self.curCount = nil
  self.minCount = 1
  self.maxCount = 9999
  self.allList = nil
  self.curBtnType = nil
  self.price = nil
  self.typeButtonCells = {}
  self.freeTypeButtonCells = {}
  self.selectItemNameText = nil
  self.selectItemDesText = nil
  self.selectItemOwnText = nil
  self.buyBtnActive = nil
  self.useBtnActive = nil
  self.buyBtnName = nil
  self.useBtnName = nil
  self.buyBtnSpendCount = nil
  self.maxBtnActive = nil
  self.maxBtnText = nil
  self.inputGoActive = nil
  self.curSelectCell = nil
  self.typeSelectSizeDelta = nil
  self.buyBtnSpendCountColor = nil
end

local function DataDestroy(self)
  self.curCount = nil
  self.minCount = nil
  self.maxCount = nil
  self.allList = nil
  self.curBtnType = nil
  self.price = nil
  self.typeButtonCells = nil
  self.freeTypeButtonCells = nil
  self.selectItemNameText = nil
  self.selectItemDesText = nil
  self.selectItemOwnText = nil
  self.buyBtnActive = nil
  self.useBtnActive = nil
  self.buyBtnName = nil
  self.useBtnName = nil
  self.buyBtnSpendCount = nil
  self.maxBtnActive = nil
  self.maxBtnText = nil
  self.inputGoActive = nil
  self.curSelectCell = nil
  self.typeSelectSizeDelta = nil
  self.buyBtnSpendCountColor = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshSelectCell)
  self:AddUIListener(EventId.UpdateGold, self.RefreshCount)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshSelectCell)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshCount)
end

local function ReInit(self)
  self:ShowTypeButton()
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIStoreCell)
end

local function OnCreateCell(self, itemObj, index)
  local template = self.allList[self.curBtnType][index]
  local id = template.id
  itemObj.name = id
  local cellItem = self.scroll_view:AddComponent(UIStoreCell, itemObj)
  local param = UIStoreCell.Param.New()
  param.itemId = id
  
  function param.callBack(trans, index)
    self:CellsCallBack(trans, index)
  end
  
  param.index = index
  cellItem:ReInit(param)
  if index == self.curSelectCell then
    self.curSelectCell = nil
    self:CellsCallBack(cellItem.transform, index)
  end
end

local function OnDeleteCell(self, itemObj, index)
  if index == self.curSelectCell then
    self.cell_select:SetParent(self.cell_go.transform)
  end
  self.scroll_view:RemoveComponent(itemObj.name, UIStoreCell)
end

local function ShowCells(self)
  self:ClearScroll()
  local n = #self.allList[self.curBtnType]
  self.scroll_view:SetTotalCount(n)
  self.scroll_view:RefillCells()
end

local function SetAllCellsDestroy(self)
  self:ClearScroll()
  self.type_cell:GameObjectRecycleAll()
end

local function OnAddBtnClick(self)
  if self.curCount < self.maxCount then
    self:SetInputText(self.curCount + 1)
    self:RefreshCount()
  end
end

local function OnDecBtnClick(self)
  if self.curCount > self.minCount then
    self:SetInputText(self.curCount - 1)
    self:RefreshCount()
  end
end

local function OnBuyBtnClick(self)
  self.ctrl:OnItemBuy(self.allList[self.curBtnType][self.curSelectCell].id, self.curCount)
end

local function RefreshCount(self)
  if self.price ~= nil and self.price > 0 then
    local spend = self.curCount * self.price
    self:SetBuyBtnSpendCountText(spend)
    local gold = LuaEntry.Player.gold
    if spend > gold then
      self:SetBuyBtnSpendCountColor(RedColor)
    else
      self:SetBuyBtnSpendCountColor(WhiteColor)
    end
  end
end

local function ShowTypeButton(self)
  self.allList = self.ctrl:GetStoreBtnTypeData()
  for k, v in pairs(self.typeButtonCells) do
    v.gameObject:SetActive(false)
    table.insert(self.freeTypeButtonCells, v)
  end
  self.typeButtonCells = {}
  self:GetCurBtnTypeListData()
  if self.allList ~= nil then
    local keys = table.keys(self.allList)
    table.sort(keys, function(lkey, rkey)
      return lkey < rkey
    end)
    for k1, v1 in ipairs(keys) do
      self:AddOneTypeButtonCells(v1)
    end
    self:SetTypeSelectSize()
  end
end

local function AddOneTypeButtonCells(self, id)
  if #self.freeTypeButtonCells > 0 then
    local temp = table.remove(self.freeTypeButtonCells)
    if temp ~= nil then
      local param = UITypeButton.Param.New()
      param.id = id
      param.name = self.ctrl:GetBtnTypeName(id)
      
      function param.callBack(trans, id)
        self:TypeButtonCallBack(trans, id)
      end
      
      if self.curBtnType == id then
        param.needClick = true
        self.curBtnType = nil
      else
        param.needClick = false
      end
      temp.gameObject:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.type_cells_content.transform)
      temp.transform:SetAsLastSibling()
      self.typeButtonCells[id] = temp
    end
  else
    local temp = self.type_cell:GameObjectSpawn(self.type_cells_content.transform)
    temp.name = tostring(id)
    self.typeButtonCells[id] = self.type_cells_content:AddComponent(UITypeButton, temp.name)
    local param = UITypeButton.Param.New()
    param.id = id
    param.name = self.ctrl:GetBtnTypeName(id)
    
    function param.callBack(trans, id)
      self:TypeButtonCallBack(trans, id)
    end
    
    if self.curBtnType == id then
      param.needClick = true
      self.curBtnType = nil
    else
      param.needClick = false
    end
    temp.gameObject:SetActive(true)
    self.typeButtonCells[id]:ReInit(param)
  end
end

local function GetCurBtnTypeListData(self)
  if self.curBtnType == nil then
    if self.allList ~= nil then
      if self.allList[UIBagBtnType.Hot] ~= nil then
        self.curBtnType = UIBagBtnType.Hot
        return self.allList[UIBagBtnType.Hot]
      elseif self.allList[UIBagBtnType.War] ~= nil then
        self.curBtnType = UIBagBtnType.War
        return self.allList[UIBagBtnType.War]
      elseif self.allList[UIBagBtnType.Buff] ~= nil then
        self.curBtnType = UIBagBtnType.Buff
        return self.allList[UIBagBtnType.Buff]
      elseif self.allList[UIBagBtnType.Resource] ~= nil then
        self.curBtnType = UIBagBtnType.Resource
        return self.allList[UIBagBtnType.Resource]
      elseif self.allList[UIBagBtnType.Other] ~= nil then
        self.curBtnType = UIBagBtnType.Other
        return self.allList[UIBagBtnType.Other]
      end
    end
  elseif self.allList[self.curBtnType] ~= nil then
    return self.allList[self.curBtnType]
  else
    self.curBtnType = nil
    return self:GetCurBtnTypeListData()
  end
end

local function TypeButtonCallBack(self, trans, id)
  if self.curBtnType ~= id then
    self.type_cell_select.transform:SetParent(trans)
    self.type_cell_select.transform:SetAsFirstSibling()
    self.type_cell_select.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.type_cell_select.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    if self.curSelectCell == nil or self.curBtnType ~= nil then
      self.curSelectCell = 1
    end
    self:SetTypeSelect(self.curBtnType, false)
    self:SetTypeSelect(id, true)
    self.curBtnType = id
    self:ShowCells()
  end
end

local function SetTypeSelect(self, id, value)
  local temp = self.typeButtonCells[id]
  if temp ~= nil then
    temp:SetSelect(value)
  end
end

local function CellsCallBack(self, trans, index)
  if self.curSelectCell ~= index then
    self.curSelectCell = index
    self.cell_select:SetParent(trans)
    self.cell_select:SetAsFirstSibling()
    self.cell_select:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.cell_select:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self:RefreshSelectCell()
  end
end

local function RefreshSelectCell(self)
  local param = UIStoreCell.Param.New()
  param.itemId = self.allList[self.curBtnType][self.curSelectCell].id
  self.item:ReInit(param)
  self.price = nil
  local itemData = self.allList[self.curBtnType][self.curSelectCell]
  if itemData ~= nil then
    self:SetItemNameText(DataCenter.ItemTemplateManager:GetName(param.itemId))
    self:SetItemDesText(DataCenter.ItemTemplateManager:GetDes(param.itemId))
    local item = DataCenter.ItemData:GetItemById(param.itemId)
    if item ~= nil then
      self:SetItemOwnText(Localization:GetString("100100") .. item.count)
    else
      self:SetItemOwnText(Localization:GetString("100100") .. "0")
    end
    self.price = itemData.price
    self:SetInputText(self.minCount)
    self:SetBuyBtnNameText(Localization:GetString("110027"))
    self:SetSpendIconImage(CS.ResourceUtils.GetResourceImagePath(ResourceType.Gold))
    self:RefreshCount()
    self.maxCount = 9999
  end
end

local function SetItemNameText(self, value)
  if self.selectItemNameText ~= value then
    self.selectItemNameText = value
    self.item_name:SetText(value)
  end
end

local function SetItemDesText(self, value)
  if self.selectItemDesText ~= value then
    self.selectItemDesText = value
    self.item_des:SetText(value)
  end
end

local function SetItemOwnText(self, value)
  if self.selectItemOwnText ~= value then
    self.selectItemOwnText = value
    self.item_own_text:SetText(value)
  end
end

local function SetBuyBtnNameText(self, value)
  if self.buyBtnName ~= value then
    self.buyBtnName = value
    self.item_buy_btn_name:SetText(value)
  end
end

local function SetBuyBtnSpendCountText(self, value)
  if self.buyBtnSpendCount ~= value then
    self.buyBtnSpendCount = value
    self.item_buy_btn_speed_count:SetText(value)
  end
end

local function SetBuyBtnSpendCountColor(self, value)
  if self.buyBtnSpendCountColor ~= value then
    self.buyBtnSpendCountColor = value
    self.item_buy_btn_speed_count:SetColor(value)
  end
end

local function SetSpendIconImage(self, imageName)
  self.item_buy_btn_speed_icon:LoadSprite(imageName)
end

local function SetInputText(self, value)
  if self.curCount ~= value then
    self.curCount = value
    self.item_input:SetText(value)
  end
end

local function InputListener(self)
  local temp = self.item_input:GetText()
  if temp ~= nil and temp ~= "" then
    local inputCount = tonumber(temp)
    if inputCount < self.minCount then
      self:SetInputText(self.minCount)
    elseif inputCount > self.maxCount then
      self:SetInputText(self.maxCount)
    else
      self:SetInputText(inputCount)
    end
    self:RefreshCount()
  end
end

local function SetTypeSelectSize(self)
  local n = table.count(self.allList)
  local padding = self.type_cells_layout_group:GetPadding()
  local spacing = self.type_cells_layout_group:GetSpacing()
  local width = (self.type_cells_content.rectTransform.sizeDelta.x - padding.left - padding.right - (n - 1) * spacing) / n
  local height = self.type_cells_content.rectTransform.sizeDelta.y - padding.top - padding.bottom
  self:SetTypeSelectSizeDelta(Vector2.New(width, height))
end

local function SetTypeSelectSizeDelta(self, value)
  if self.typeSelectSizeDelta ~= value then
    self.typeSelectSizeDelta = value
    self.type_cell_select.rectTransform.sizeDelta = value
  end
end

UIStore.OnCreate = OnCreate
UIStore.OnDestroy = OnDestroy
UIStore.OnEnable = OnEnable
UIStore.OnDisable = OnDisable
UIStore.ComponentDefine = ComponentDefine
UIStore.ComponentDestroy = ComponentDestroy
UIStore.DataDefine = DataDefine
UIStore.DataDestroy = DataDestroy
UIStore.OnAddListener = OnAddListener
UIStore.OnRemoveListener = OnRemoveListener
UIStore.ReInit = ReInit
UIStore.OnDeleteCell = OnDeleteCell
UIStore.ShowCells = ShowCells
UIStore.OnCreateCell = OnCreateCell
UIStore.ClearScroll = ClearScroll
UIStore.SetAllCellsDestroy = SetAllCellsDestroy
UIStore.OnAddBtnClick = OnAddBtnClick
UIStore.OnDecBtnClick = OnDecBtnClick
UIStore.OnBuyBtnClick = OnBuyBtnClick
UIStore.RefreshCount = RefreshCount
UIStore.GetCurBtnTypeListData = GetCurBtnTypeListData
UIStore.TypeButtonCallBack = TypeButtonCallBack
UIStore.AddOneTypeButtonCells = AddOneTypeButtonCells
UIStore.ShowTypeButton = ShowTypeButton
UIStore.CellsCallBack = CellsCallBack
UIStore.RefreshSelectCell = RefreshSelectCell
UIStore.InputListener = InputListener
UIStore.SetItemNameText = SetItemNameText
UIStore.SetItemDesText = SetItemDesText
UIStore.SetItemOwnText = SetItemOwnText
UIStore.SetBuyBtnNameText = SetBuyBtnNameText
UIStore.SetBuyBtnSpendCountText = SetBuyBtnSpendCountText
UIStore.SetSpendIconImage = SetSpendIconImage
UIStore.SetInputText = SetInputText
UIStore.SetTypeSelectSize = SetTypeSelectSize
UIStore.SetTypeSelectSizeDelta = SetTypeSelectSizeDelta
UIStore.SetBuyBtnSpendCountColor = SetBuyBtnSpendCountColor
UIStore.SetTypeSelect = SetTypeSelect
return UIStore
