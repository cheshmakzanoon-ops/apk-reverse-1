local UIGroceryStoreCell = BaseClass("UIGroceryStoreCell", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local normal_path = "CellGo/Normal_Go"
local normal_item_icon_path = "CellGo/Normal_Go/Item_Icon"
local normal_money_text_path = "CellGo/Normal_Go/MoneyText"
local normal_can_send_icon_path = "CellGo/Complete_Hint_Icon"
local monster_path = "CellGo/Monster_Go"
local monster_lv_path = "CellGo/Monster_Level"
local monster_item_icon_path = "CellGo/Monster_Go/Item_Icon_Monster"
local monster_money_text_path = "CellGo/Monster_Level/MonsterMoneyText"
local monster_can_send_icon_path = "CellGo/Monster_Complete_Hint_Icon"
local select_effect_path = "CellGo/Select_Effect"
local select_effect_complete_path = "CellGo/Select_Effect_Complete"
local complete_path = "CellGo/Complete_Go"
local complete_item_icon_grey_path = "CellGo/Complete_Go/Item_Icon_Grey"
local complete_text_path = "CellGo/Complete_Go/Complete_Text"
local delete_path = "CellGo/Delete_Go_New"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.normal = self:AddComponent(UIBaseContainer, normal_path)
  self.normal_item_icon = self:AddComponent(UIImage, normal_item_icon_path)
  self.normal_money_text = self:AddComponent(UIText, normal_money_text_path)
  self.normal_can_send_icon = self:AddComponent(UIImage, normal_can_send_icon_path)
  self.normal_can_send_icon:SetActive(false)
  self.monster = self:AddComponent(UIBaseContainer, monster_path)
  self.monster_lv = self:AddComponent(UIBaseContainer, monster_lv_path)
  self.monster_item_icon = self:AddComponent(UIImage, monster_item_icon_path)
  self.monster_money_text = self:AddComponent(UIText, monster_money_text_path)
  self.monster_can_send_icon = self:AddComponent(UIImage, monster_can_send_icon_path)
  self.monster_can_send_icon:SetActive(false)
  self.complete = self:AddComponent(UIBaseContainer, complete_path)
  self.complete_item_icon_grey = self:AddComponent(UIImage, complete_item_icon_grey_path)
  self.complete_text = self:AddComponent(UIText, complete_text_path)
  self.delete_new = self:AddComponent(UIBaseContainer, delete_path)
  self.select_effect = self:AddComponent(UIImage, select_effect_path)
  self.select_effect:SetActive(false)
  self.select_effect_complete = self:AddComponent(UIImage, select_effect_complete_path)
  self.select_effect_complete:SetActive(false)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view:OnCellSelect(self:GetDataIndex())
    DataCenter.GuideManager:HasClick(self.btn.gameObject)
  end)
  self.complete_text:SetLocalText(170008)
end

local function ComponentDestroy(self)
  self.normal = nil
  self.normal_item_icon = nil
  self.normal_money_text = nil
  self.normal_can_send_icon = nil
  self.monster = nil
  self.monster_lv = nil
  self.monster_item_icon = nil
  self.monster_money_text = nil
  self.monster_can_send_icon = nil
  self.complete = nil
  self.complete_item_icon_grey = nil
  self.complete_text = nil
  self.btn = nil
  self.delete_new = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  if self.param == nil then
    return
  end
  self.normal_can_send_icon:SetActive(false)
  if self.param.isDelete == true then
    self.complete:SetActive(false)
    self.normal:SetActive(false)
    self.monster:SetActive(false)
    self.monster_lv:SetActive(false)
    self.delete_new:SetActive(true)
  elseif self.param.isSend == true then
    self.complete:SetActive(true)
    self.normal:SetActive(false)
    self.monster:SetActive(false)
    self.monster_lv:SetActive(false)
    self.delete_new:SetActive(false)
    self.complete_item_icon_grey:LoadSprite(self.param.icon)
  else
    self.complete:SetActive(false)
    self.delete_new:SetActive(false)
    if self.param.productType == OrderItemType.ORDER_ITEM_TYPE_MONSTER then
      self.normal:SetActive(false)
      self.monster:SetActive(true)
      self.monster_lv:SetActive(true)
      self.monster_can_send_icon:SetActive(self.param.canSend)
      self.monster_item_icon:LoadSprite(self.param.icon)
      self.monster_money_text:SetLocalText(300665, tostring(self.param.productId))
    else
      self.normal:SetActive(true)
      self.monster:SetActive(false)
      self.monster_lv:SetActive(false)
      self.normal_can_send_icon:SetActive(self.param.canSend)
      self.normal_item_icon:LoadSprite(self.param.icon)
      if self.param.productType == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
        self.normal_money_text:SetLocalText(300665, tostring(self.param.productId))
      else
        self.normal_money_text:SetText("x" .. string.GetFormattedSeperatorNum(self.param.needNum))
      end
    end
  end
end

local function GetDataIndex(self)
  if self.param ~= nil then
    return self.param.dataIndex
  end
  return -1
end

local function SetSelectDataIndex(self, dataIndex)
  local showSelect = self.param ~= nil and self.param.dataIndex == dataIndex
  self.select_effect:SetActive(showSelect and not self.param.isSend)
  self.select_effect_complete:SetActive(showSelect and self.param.isSend)
end

local function GetGuideObject(self)
  return self.btn.gameObject
end

UIGroceryStoreCell.OnCreate = OnCreate
UIGroceryStoreCell.OnDestroy = OnDestroy
UIGroceryStoreCell.OnDisable = OnDisable
UIGroceryStoreCell.ReInit = ReInit
UIGroceryStoreCell.ComponentDefine = ComponentDefine
UIGroceryStoreCell.DataDefine = DataDefine
UIGroceryStoreCell.ComponentDestroy = ComponentDestroy
UIGroceryStoreCell.DataDestroy = DataDestroy
UIGroceryStoreCell.OnEnable = OnEnable
UIGroceryStoreCell.GetDataIndex = GetDataIndex
UIGroceryStoreCell.SetSelectDataIndex = SetSelectDataIndex
UIGroceryStoreCell.GetGuideObject = GetGuideObject
return UIGroceryStoreCell
