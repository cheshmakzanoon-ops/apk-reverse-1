local UIDecorationIconCell = BaseClass("UIDecorationIconCell", UIBaseContainer)
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

local function ComponentDefine(self)
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

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.parentType = nil
end

local function DataDestroy(self)
  self.parentType = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, data, currentSelect, parentType)
  self.data = data
  self.currentSelect = currentSelect
  self.parentType = parentType
  self:RefreshView()
end

local function RefreshView(self)
  self.select_effect:SetActive(self.data.id == self.currentSelect)
  local needSetNativeSize = self.data.type == DecorationType.DecorationType_Emoji
  if self.data.type == DecorationType.DecorationType_Emoji and self.data.customVariable and tonumber(self.data.customVariable) > 0 then
    local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(self.data.customVariable))
    self.icon:LoadSpriteAsyncWithCallback(string.format(ChatStickerCoverPath, strickerTmp.name), function()
      if needSetNativeSize and self.icon then
        self.icon:SetNativeSize()
      end
    end)
  else
    self.icon:LoadSpriteAsyncWithCallback(self.data.icon, function()
      if needSetNativeSize and self.icon then
        self.icon:SetNativeSize()
      end
    end)
  end
  if self.data.type == DecorationType.DecorationType_Emoji then
    self.item_bg:LoadSprite("Assets/Main/Sprites/UI/LWUIWorldStickers/ljq_daditubiaoqing_qipao_06.png")
  else
    self.item_bg:LoadSprite(self.data.colorBg)
  end
  self.unlock_effect:SetActive(not self.data.isUnlock)
  self.in_use:SetActive(self.data.inUse)
  self.red_point:SetActive(self.data.showRedPoint)
  self.new:SetActive(self.data.showNew)
  if self.parentType == UIDecorationIconCellParentType.UIDecorationIconCell and self.icon_gotoDecorationShop then
    local showJumpToDecorationShop = DataCenter.DecorationDataManager:GetIfShowJumpToDecorationShop(self.data.id, self.data.type)
    self.icon_gotoDecorationShop:SetActive(showJumpToDecorationShop)
  end
end

local function ClickBtn(self)
  EventManager:GetInstance():Broadcast(EventId.DecorationIconSelect, self.data.id)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
  base.OnRemoveListener(self)
end

local function OnSelectEvent(self, decorationId)
  self.currentSelect = decorationId
  self.select_effect:SetActive(self.data.id == self.currentSelect)
end

UIDecorationIconCell.OnSelectEvent = OnSelectEvent
UIDecorationIconCell.OnCreate = OnCreate
UIDecorationIconCell.OnDestroy = OnDestroy
UIDecorationIconCell.OnEnable = OnEnable
UIDecorationIconCell.OnDisable = OnDisable
UIDecorationIconCell.ComponentDefine = ComponentDefine
UIDecorationIconCell.ComponentDestroy = ComponentDestroy
UIDecorationIconCell.DataDefine = DataDefine
UIDecorationIconCell.DataDestroy = DataDestroy
UIDecorationIconCell.ReInit = ReInit
UIDecorationIconCell.RefreshView = RefreshView
UIDecorationIconCell.ClickBtn = ClickBtn
UIDecorationIconCell.OnAddListener = OnAddListener
UIDecorationIconCell.OnRemoveListener = OnRemoveListener
return UIDecorationIconCell
