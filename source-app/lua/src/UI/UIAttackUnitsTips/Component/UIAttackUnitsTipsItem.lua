local UIAttackUnitsTipsItem = BaseClass("UIAttackUnitsTipsItem", UIBaseContainer)
local UIUnitHeadItem = require("UI.UIAttackUnitsTips.Component.UIUnitHeadItem")
local unit_head_item_path = "HeadListRoot/UnitHeadItem"
local base = UIBaseContainer
local bgImages = {
  [AttackerBossType.Aisilla] = "Assets/Main/TextureEx/LWUIAttackUnits/ljq_sangshiruqin_s2_jineng_02.png",
  [AttackerBossType.ZoneMobilizationBoss] = "Assets/Main/TextureEx/LWUIAttackUnits/zyf_jiluofu_jineng_tishitiao.png"
}
local EffectBule_Path = "BgImg/Eff_ui_zone_hengtiao_blue"
local EffectRed_Path = "BgImg/Eff_ui_zone_hengtiao_red"
local head_list_root_path = "HeadListRoot"

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
  self.head_list_root = self:AddComponent(UIBaseContainer, head_list_root_path)
  self.bgImg = self:AddComponent(UIRawImage, "BgImg")
  self.itemGo = self.transform:Find(unit_head_item_path).gameObject
  self.itemGo:SetActive(false)
  self.itemGo:GameObjectCreatePool()
  self.effectBule = self:AddComponent(UIBaseContainer, EffectBule_Path)
  self.effectRed = self:AddComponent(UIBaseContainer, EffectRed_Path)
  self.effect = {
    [AttackerBossType.Aisilla] = self.effectBule,
    [AttackerBossType.ZoneMobilizationBoss] = self.effectRed
  }
end

local function ComponentDestroy(self)
  self.head_list_root:RemoveComponents(UIUnitHeadItem)
  self.head_list_root = nil
  self.bgImg = nil
  self.itemGo:GameObjectRecycleAll()
  self.itemGo = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshView(self, param)
  if param then
    if param.targetList then
      local targetList = param.targetList
      local count = #targetList
      count = math.min(count, 6)
      for i = 1, count do
        local value = targetList[i]
        local go = self.itemGo:GameObjectSpawn(self.head_list_root.transform)
        go.name = "item_" .. i
        local item = self.head_list_root:AddComponent(UIUnitHeadItem, go.name)
        item:SetActive(true)
        item:Refresh(value)
      end
    end
    if param.bossType then
      for k, v in pairs(self.effect) do
        v:SetActive(k == param.bossType)
      end
    end
  end
end

UIAttackUnitsTipsItem.OnCreate = OnCreate
UIAttackUnitsTipsItem.OnDestroy = OnDestroy
UIAttackUnitsTipsItem.OnEnable = OnEnable
UIAttackUnitsTipsItem.OnDisable = OnDisable
UIAttackUnitsTipsItem.ComponentDefine = ComponentDefine
UIAttackUnitsTipsItem.ComponentDestroy = ComponentDestroy
UIAttackUnitsTipsItem.DataDefine = DataDefine
UIAttackUnitsTipsItem.DataDestroy = DataDestroy
UIAttackUnitsTipsItem.OnAddListener = OnAddListener
UIAttackUnitsTipsItem.OnRemoveListener = OnRemoveListener
UIAttackUnitsTipsItem.RefreshView = RefreshView
return UIAttackUnitsTipsItem
