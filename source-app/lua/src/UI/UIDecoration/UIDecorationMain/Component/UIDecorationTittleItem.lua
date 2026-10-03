local UIDecorationTittleItem = BaseClass("UIDecorationTittleItem", UIBaseContainer)
local base = UIBaseContainer
local select_effect_path = "select"
local icon_path = "icon"
local btn_path = "selectBtn"
local red_point_path = "redPoint"
local new_path = "newItem"
local txt_title_path = "icon/txtTitle"
local in_use_path = "in_use_img"
local imgLock_path = "imgLock"

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
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickBtn()
  end)
  self.red_point = self:AddComponent(UIBaseContainer, red_point_path)
  self.new = self:AddComponent(UIBaseContainer, new_path)
  self.txtTitle = self:AddComponent(UIText, txt_title_path)
  self.in_use = self:AddComponent(UIText, in_use_path)
  self.imgLock = self:AddComponent(UIBaseContainer, imgLock_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, data, currentSelect)
  self.data = data
  self.currentSelect = currentSelect
  self:RefreshView()
end

local function RefreshView(self)
  local defaultId = DataCenter.DecorationDataManager:GetDefaultSkinIdByType(self.data.type)
  self.txtTitle:SetActive(self.data.id == defaultId)
  self.select_effect:SetActive(self.data.id == self.currentSelect)
  self.icon:LoadSprite(self.data.img)
  if self.data.isUnlock then
    self.icon:SetColor(Color32.New(1, 1, 1, 1))
  else
    self.icon:SetColor(Color32.New(0.35294117647058826, 0.35294117647058826, 0.35294117647058826, 1.0))
  end
  self.red_point:SetActive(self.data.showRedPoint)
  self.new:SetActive(self.data.showNew)
  self.txtTitle:SetLocalText(self.data.name)
  self.in_use:SetActive(self.data.inUse)
  self.imgLock:SetActive(not self.data.isUnlock)
end

local function ClickBtn(self)
  EventManager:GetInstance():Broadcast(EventId.DecorationIconSelect, self.data.id)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
end

local function OnRemoveListener(self)
  self:AddUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
  base.OnRemoveListener(self)
end

local function OnSelectEvent(self, decorationId)
  self.currentSelect = decorationId
  self.select_effect:SetActive(self.data.id == self.currentSelect)
end

UIDecorationTittleItem.OnSelectEvent = OnSelectEvent
UIDecorationTittleItem.OnCreate = OnCreate
UIDecorationTittleItem.OnDestroy = OnDestroy
UIDecorationTittleItem.OnEnable = OnEnable
UIDecorationTittleItem.OnDisable = OnDisable
UIDecorationTittleItem.ComponentDefine = ComponentDefine
UIDecorationTittleItem.ComponentDestroy = ComponentDestroy
UIDecorationTittleItem.DataDefine = DataDefine
UIDecorationTittleItem.DataDestroy = DataDestroy
UIDecorationTittleItem.ReInit = ReInit
UIDecorationTittleItem.RefreshView = RefreshView
UIDecorationTittleItem.ClickBtn = ClickBtn
UIDecorationTittleItem.OnAddListener = OnAddListener
UIDecorationTittleItem.OnRemoveListener = OnRemoveListener
return UIDecorationTittleItem
