local UITacticalEquipUpgradeResultView = BaseClass("UITacticalEquipUpgradeResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TacticalEquipStaticAttriItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipStaticAttriItem")
local TacticalEquipItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:PlayUpgradeSound()
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
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/titleBg/titleText")
  self.compAttributeNode = self:AddComponent(UIBaseContainer, "Root/AttributeNode")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compNextEquipItem = self:AddComponent(TacticalEquipItem, "Root/equips/nextEquipItem")
  self.compCurEquipItem = self:AddComponent(TacticalEquipItem, "Root/equips/curEquipItem")
end

local function ComponentDestroy(self)
  self.compAttributeNode:RemoveComponents(TacticalEquipStaticAttriItem)
  self.textTitle = nil
  self.compAttributeNode = nil
  self.btnPanel = nil
  self.compNextEquipItem = nil
  self.compCurEquipItem = nil
  self:StopUpgradeSound()
end

local function DataDefine(self)
  self.attributeReqs = {}
end

local function DataDestroy(self)
  for i, v in ipairs(self.attributeReqs) do
    if v then
      v:Destroy()
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UITacticalEquipUpgradeResultView:ReInit()
  self.config, self.nextConfig = self:GetUserData()
  if not self.config or not self.nextConfig then
    self.ctrl:CloseSelf()
    return
  end
  self.compCurEquipItem:SetConfigData(self.config)
  self.compNextEquipItem:SetConfigData(self.nextConfig)
  self:RefreshAttributes()
end

function UITacticalEquipUpgradeResultView:RefreshItem(configId, item)
  local param = UICommonResItem.Param.New()
  param.rewardType = RewardType.CommonEquip
  param.itemId = configId
  param.count = 1
  item:ReInit(param)
  item:SetActive(true)
  item:SetItemCountActive(false)
end

function UITacticalEquipUpgradeResultView:RefreshAttributes()
  local effectList = DataCenter.CommonEquipDataManager:GetAttributePairsDataList(self.nextConfig.baseEffect)
  for i, v in ipairs(effectList) do
    table.insert(self.attributeReqs, self:CreateAttributeItem(v, i))
  end
end

function UITacticalEquipUpgradeResultView:CreateAttributeItem(data, index)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalEquipStaticAttriItemV, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compAttributeNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go:SetActive(true)
    local name = "attribute_" .. tostring(index)
    go.name = name
    local cell = self.compAttributeNode:AddComponent(TacticalEquipStaticAttriItem, name)
    data.index = index
    cell:SetData(data)
  end)
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

function UITacticalEquipUpgradeResultView:PlayUpgradeSound()
  self:StopUpgradeSound()
  self.playingUpgradeSoundId = DataCenter.LWSoundManager:PlaySound(62304, false)
end

function UITacticalEquipUpgradeResultView:StopUpgradeSound()
  if self.playingUpgradeSoundId then
    DataCenter.LWSoundManager:StopSound(self.playingUpgradeSoundId)
    self.playingUpgradeSoundId = nil
  end
end

UITacticalEquipUpgradeResultView.OnCreate = OnCreate
UITacticalEquipUpgradeResultView.OnDestroy = OnDestroy
UITacticalEquipUpgradeResultView.OnEnable = OnEnable
UITacticalEquipUpgradeResultView.OnDisable = OnDisable
UITacticalEquipUpgradeResultView.ComponentDefine = ComponentDefine
UITacticalEquipUpgradeResultView.ComponentDestroy = ComponentDestroy
UITacticalEquipUpgradeResultView.DataDefine = DataDefine
UITacticalEquipUpgradeResultView.DataDestroy = DataDestroy
UITacticalEquipUpgradeResultView.OnAddListener = OnAddListener
UITacticalEquipUpgradeResultView.OnRemoveListener = OnRemoveListener
UITacticalEquipUpgradeResultView.OnBtnPanelClick = OnBtnPanelClick
return UITacticalEquipUpgradeResultView
