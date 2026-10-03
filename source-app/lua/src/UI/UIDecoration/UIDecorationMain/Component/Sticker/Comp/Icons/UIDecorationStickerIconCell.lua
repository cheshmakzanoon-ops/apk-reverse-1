local UIDecorationStickerIconCell = BaseClass("UIDecorationStickerIconCell", UIBaseContainer)
local base = UIBaseContainer
local select_effect_path = "select"
local icon_path = "icon"
local btn_path = ""
local unlock_effect_path = "cover"
local in_use_path = "in_use_img"
local red_point_path = "redPoint"
local new_path = "newItem"
local item_bg_path = "Cell_BG/ItemBgColor"
local icon_gotoDecorationShop_path = "icon_gotoDecorationShop"

function UIDecorationStickerIconCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickerIconCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickerIconCell:ComponentDefine()
  self.select_effect = self:AddComponent(UIBaseContainer, select_effect_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:ClickBtn()
  end)
  self.unlock_effect = self:AddComponent(UIBaseContainer, unlock_effect_path)
  self.in_use = self:AddComponent(UIText, in_use_path)
  self.red_point = self:AddComponent(UIBaseContainer, red_point_path)
  self.new = self:AddComponent(UIBaseContainer, new_path)
  self.item_bg = self:AddComponent(UIImage, item_bg_path)
  local gotoDecoration = self.transform:Find(icon_gotoDecorationShop_path)
  if not IsNull(gotoDecoration) then
    self.icon_gotoDecorationShop = self:AddComponent(UIImage, icon_gotoDecorationShop_path)
    self.icon_gotoDecorationShop:SetActive(false)
  end
end

function UIDecorationStickerIconCell:ComponentDestroy()
end

function UIDecorationStickerIconCell:DataDefine()
  self.parentType = nil
end

function UIDecorationStickerIconCell:DataDestroy()
  self.parentType = nil
end

function UIDecorationStickerIconCell:OnEnable()
  base.OnEnable(self)
end

function UIDecorationStickerIconCell:OnDisable()
  base.OnDisable(self)
end

function UIDecorationStickerIconCell:ReInit(data, currentSelect, parentType)
  self.data = data
  self.currentSelect = currentSelect
  self.parentType = parentType
  self:RefreshView()
end

function UIDecorationStickerIconCell:RefreshView()
  self.select_effect:SetActive(self.data.id == self.currentSelect)
  if self.data.customVariable and tonumber(self.data.customVariable) > 0 then
    local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(self.data.customVariable))
    self.icon:LoadSprite(string.format(ChatStickerCoverPath, strickerTmp.name))
  else
    self.icon:LoadSprite(self.data.icon)
  end
  self.item_bg:LoadSprite("Assets/Main/Sprites/UI/LWUIWorldStickers/ljq_daditubiaoqing_qipao_06.png")
  self.icon:SetNativeSize()
  self.unlock_effect:SetActive(not self.data.isUnlock)
  self.in_use:SetActive(self.data.inUse)
  self.red_point:SetActive(self.data.showRedPoint)
  self.new:SetActive(self.data.showNew)
  if self.parentType == UIDecorationIconCellParentType.UIDecorationIconCell and self.icon_gotoDecorationShop then
    local showJumpToDecorationShop = DataCenter.DecorationDataManager:GetIfShowJumpToDecorationShop(self.data.id, self.data.type)
    self.icon_gotoDecorationShop:SetActive(showJumpToDecorationShop)
  end
end

function UIDecorationStickerIconCell:ClickBtn()
  EventManager:GetInstance():Broadcast(EventId.DecorationStickerIconSelect, self.data.id)
end

function UIDecorationStickerIconCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationStickerIconSelect, self.OnSelectEvent)
end

function UIDecorationStickerIconCell:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorationStickerIconSelect, self.OnSelectEvent)
  base.OnRemoveListener(self)
end

function UIDecorationStickerIconCell:OnSelectEvent(decorationId)
  self.currentSelect = decorationId
  self.select_effect:SetActive(self.data.id == self.currentSelect)
end

return UIDecorationStickerIconCell
