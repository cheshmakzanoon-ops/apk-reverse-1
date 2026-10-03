local base = UIBaseContainer
local DiggingUseItem = BaseClass("DiggingUseItem", base)
local icon_path = "Icon"
local num_path = "ItemNumText"
local btn_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.num = self:AddComponent(UIText, num_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  if self.num.unity_tmpro then
    self.num.unity_tmpro.richText = true
  end
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
end

local function ComponentDestroy(self)
  self.icon = nil
  self.num = nil
  self.btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function DiggingUseItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefresh)
end

function DiggingUseItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefresh)
  base.OnRemoveListener(self)
end

function DiggingUseItem:ReInit(itemId)
  self.itemId = itemId or 0
  local config = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  if not config then
    self:SetActive(false)
    return
  end
  if not string.IsNullOrEmpty(config.icon) then
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, config.icon))
  end
  self:OnRefresh()
  self:SetActive(true)
end

function DiggingUseItem:OnRefresh()
  local count = DataCenter.ItemData:GetItemCount(self.itemId)
  self.num:SetText(string.GetFormattedGoldNum(count or 0))
end

function DiggingUseItem:OnClick()
  if CS.SDKManager.IS_UNITY_EDITOR() then
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, tostring(self.itemId), 100)
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  LWResourceLackUtil:GotoGoodsItemLack(self.itemId, 1)
end

DiggingUseItem.OnCreate = OnCreate
DiggingUseItem.OnDestroy = OnDestroy
DiggingUseItem.OnEnable = OnEnable
DiggingUseItem.OnDisable = OnDisable
DiggingUseItem.ComponentDefine = ComponentDefine
DiggingUseItem.ComponentDestroy = ComponentDestroy
DiggingUseItem.DataDefine = DataDefine
DiggingUseItem.DataDestroy = DataDestroy
return DiggingUseItem
