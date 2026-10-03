local base = UIBaseContainer
local WorldS1RestCityDefendMonster = BaseClass("WorldS1RestCityDefendMonster", base)
local LWUIBerserkBossEffectItemRender = require("UI.UIWorldPoint.Component.LWUIBerserkBossEffectItemRender")
local worldBossRawImage_path = "TopContent/WorldBossRawImage"
local shareBtn_path = "TopContent/ShareBtn"
local markBtn_path = "TopContent/MarkBtn"
local bossLevelText_path = "TopContent/FX_common_4xp/BossLevelText"
local bossNameText_path = "TopContent/BossNameText"
local hpProgress_path = "TopContent/FX_common_4xp/HpProgress"
local hpProgressText_path = "TopContent/FX_common_4xp/HpProgressText"
local effectTipsText_path = "CenterContent/EffectTipsText"
local effectContent_path = "CenterContent/EffectContent"
local berserkBossEffectObj_path = "CenterContent/EffectContent/LWUIBerserkBossEffectItemRender"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearEffectCells()
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
  self.worldBossRawImage = self:AddComponent(UIRawImage, worldBossRawImage_path)
  self.shareBtn = self:AddComponent(UIButton, shareBtn_path)
  self.markBtn = self:AddComponent(UIButton, markBtn_path)
  self.bossLevelText = self:AddComponent(UIText, bossLevelText_path)
  self.bossNameText = self:AddComponent(UIText, bossNameText_path)
  self.hpProgress = self:AddComponent(UISlider, hpProgress_path)
  self.hpProgressText = self:AddComponent(UIText, hpProgressText_path)
  self.effectTipsText = self:AddComponent(UIText, effectTipsText_path)
  self.effectContent = self:AddComponent(UIBaseContainer, effectContent_path)
  self.berserkBossEffectObj = self:AddComponent(UIBaseContainer, berserkBossEffectObj_path)
  self.shareBtn:SetOnClick(function()
    self.view.ctrl:OnShareClick(self.view.ctrl.serverId, self.pointData.point, self.pointData.name, nil)
  end)
  self.markBtn:SetOnClick(function()
    local realPoint = self.pointData.point * 10 + 1
    self.view.ctrl:OnMarkClick(self.view.ctrl.serverId, realPoint, self.pointData.name, nil, MarkGroup.Personal)
  end)
  self.effectTipsText:SetLocalText("activity_berserkboss_title_15")
  self.effectItem = self.transform:Find(berserkBossEffectObj_path).gameObject
  self.effectItem:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.worldBossRawImage = nil
  self.shareBtn = nil
  self.markBtn = nil
  self.bossLevelText = nil
  self.bossNameText = nil
  self.hpProgress = nil
  self.hpProgressText = nil
  self.effectTipsText = nil
  self.effectContent = nil
  self.berserkBossEffectObj = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshData(self, param)
  self.pointData = param
  if self.pointData == nil then
    return
  end
  self.bossNameText:SetLocalText(self.pointData.name)
  self.bossLevelText:SetText("Lv." .. tostring(self.pointData.level))
  local progressValue = Mathf.Clamp(self.pointData.monsterHpRatio / 100, 0, 1)
  self.hpProgress:SetValue(progressValue)
  self.hpProgressText:SetText(string.GetFormattedStr(self.pointData.curHp) .. " " .. string.format("%.2f", self.pointData.monsterHpRatio) .. "%")
  self:ShowEffectData()
end

local function ShowEffectData(self)
  if self.pointData == nil then
    return
  end
  self:ClearEffectCells()
  local effectList = self.pointData.effectList
  if effectList ~= nil then
    local effectCount = table.count(effectList)
    for i = 1, effectCount do
      local effectData = effectList[i]
      local go = self.effectItem:GameObjectSpawn(self.effectContent.transform)
      go.name = "item_" .. i
      go:SetActive(true)
      local itemRender = self.effectContent:AddComponent(LWUIBerserkBossEffectItemRender, go.name)
      itemRender:InitData(i, effectData)
    end
  end
end

local function ClearEffectCells(self)
  self.effectContent:RemoveComponents(LWUIBerserkBossEffectItemRender)
  self.effectItem:GameObjectRecycleAll()
end

WorldS1RestCityDefendMonster.OnCreate = OnCreate
WorldS1RestCityDefendMonster.OnDestroy = OnDestroy
WorldS1RestCityDefendMonster.OnEnable = OnEnable
WorldS1RestCityDefendMonster.OnDisable = OnDisable
WorldS1RestCityDefendMonster.ComponentDefine = ComponentDefine
WorldS1RestCityDefendMonster.ComponentDestroy = ComponentDestroy
WorldS1RestCityDefendMonster.DataDefine = DataDefine
WorldS1RestCityDefendMonster.DataDestroy = DataDestroy
WorldS1RestCityDefendMonster.RefreshData = RefreshData
WorldS1RestCityDefendMonster.ShowEffectData = ShowEffectData
WorldS1RestCityDefendMonster.ClearEffectCells = ClearEffectCells
return WorldS1RestCityDefendMonster
