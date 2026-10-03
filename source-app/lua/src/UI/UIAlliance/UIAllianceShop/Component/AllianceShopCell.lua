local AllianceShopCell = BaseClass("AllianceShopCell", UIBaseContainer)
local base = UIBaseContainer
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local num_text_path = "clickBtn/NumText"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local btn_path = "clickBtn"
local select_path = "clickBtn/select"
local num_go_path = "clickBtn/NumGo"

local function OnCreate(self)
  base.OnCreate(self)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.select = self:AddComponent(UIImage, select_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function OnBtnClick(self)
  local currentItemId = self.view.ctrl:GetCurrentItemId()
  if self.itemId ~= currentItemId then
    self.view.ctrl:SelectOneItem(self.itemId)
    self.select:SetActive(true)
  end
end

local function SetItemShow(self, ...)
  self.itemId = (...)
  local itemData = self.view.ctrl:GetItemData(self.itemId)
  local currentItemId = self.view.ctrl:GetCurrentItemId()
  self.num_text:SetText(itemData.count)
  if itemData.count == "" then
    self.num_text:SetActive(false)
  else
    self.num_text:SetActive(true)
  end
  self.item_quality:LoadSprite(itemData.itemColor)
  self.item_icon:LoadSprite(itemData.iconName)
  self.flag_text:SetText(itemData.itemFlag)
  self.select:SetActive(currentItemId == self.itemId)
  if self.view.ctrl:GetTab() == 2 then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
    local shopItemData = DataCenter.AllianceShopDataManager:GetAllianceShopOneData(self.itemId)
    local allianceNum = itemTemplate.allianceNum
    if 0 < allianceNum and shopItemData ~= nil then
      allianceNum = allianceNum - tonumber(shopItemData.buyCount)
      if allianceNum < 0 then
        allianceNum = 0
      end
    end
    if 0 < allianceNum or allianceNum == -1 then
      CS.UIGray.SetGray(self.transform, false, true)
    else
      CS.UIGray.SetGray(self.transform, true, true)
    end
  else
    CS.UIGray.SetGray(self.transform, false, true)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CLICK_ALLIANCE_SHOP_ITEM, self.RefreshItemState)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CLICK_ALLIANCE_SHOP_ITEM, self.RefreshItemState)
end

local function RefreshItemState(self, data)
  if self.itemId == data then
    local currentItemId = self.view.ctrl:GetCurrentItemId()
    self.select:SetActive(self.itemId == currentItemId)
  end
end

AllianceShopCell.OnCreate = OnCreate
AllianceShopCell.OnAddListener = OnAddListener
AllianceShopCell.OnBtnClick = OnBtnClick
AllianceShopCell.SetItemShow = SetItemShow
AllianceShopCell.OnRemoveListener = OnRemoveListener
AllianceShopCell.RefreshItemState = RefreshItemState
return AllianceShopCell
