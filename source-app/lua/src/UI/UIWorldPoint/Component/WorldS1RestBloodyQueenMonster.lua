local base = UIBaseContainer
local WorldS1RestBloodyQueenMonster = BaseClass("WorldS1RestBloodyQueenMonster", base)
local worldBossRawImage_path = "TopContent/WorldBossRawImage"
local shareBtn_path = "TopContent/ShareBtn"
local markBtn_path = "TopContent/MarkBtn"
local bossLevelText_path = "TopContent/FX_common_4xp/BossLevelText"
local bossNameText_path = "TopContent/BossNameText"
local hpProgress_path = "TopContent/FX_common_4xp/HpProgress"
local hpProgressText_path = "TopContent/FX_common_4xp/HpProgressText"
local effectTipsText_path = "CenterContent/EffectTipsText"
local effectDesText_path = "CenterContent/EffectDesBg/EffectDesText"
local scoreTipsText_path = "CenterContent/ScoreTipsText"

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
  self.worldBossRawImage = self:AddComponent(UIRawImage, worldBossRawImage_path)
  self.shareBtn = self:AddComponent(UIButton, shareBtn_path)
  self.markBtn = self:AddComponent(UIButton, markBtn_path)
  self.bossLevelText = self:AddComponent(UIText, bossLevelText_path)
  self.bossNameText = self:AddComponent(UIText, bossNameText_path)
  self.hpProgress = self:AddComponent(UISlider, hpProgress_path)
  self.hpProgressText = self:AddComponent(UIText, hpProgressText_path)
  self.effectTipsText = self:AddComponent(UIText, effectTipsText_path)
  self.effectDesText = self:AddComponent(UIText, effectDesText_path)
  self.scoreTipsText = self:AddComponent(UIText, scoreTipsText_path)
  self.shareBtn:SetOnClick(function()
    self.view.ctrl:OnShareClick(self.view.ctrl.serverId, self.pointData.point, self.pointData.name, nil)
  end)
  self.markBtn:SetOnClick(function()
    local realPoint = self.pointData.point * 10 + 1
    self.view.ctrl:OnMarkClick(self.view.ctrl.serverId, realPoint, self.pointData.name, nil, MarkGroup.Personal)
  end)
  self.effectTipsText:SetLocalText("activity_berserkboss_title_15")
  self.scoreTipsText:SetActive(false)
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
  self.scoreTipsText = nil
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
  self.hpProgressText:SetText(string.format("%.2f", self.pointData.monsterHpRatio) .. "%")
  self.effectDesText:SetLocalText(self.pointData.monsterTemplate.desc)
  if self.pointData.special == WorldMonsterSpecialType.S1RestBloodyQueenGunner then
    self.scoreTipsText:SetActive(true)
    self.scoreTipsText:SetLocalText("300644", string.GetFormattedSeperatorNum(self.pointData.monsterTemplate.recommend_power))
  else
    self.scoreTipsText:SetActive(false)
  end
end

WorldS1RestBloodyQueenMonster.OnCreate = OnCreate
WorldS1RestBloodyQueenMonster.OnDestroy = OnDestroy
WorldS1RestBloodyQueenMonster.OnEnable = OnEnable
WorldS1RestBloodyQueenMonster.OnDisable = OnDisable
WorldS1RestBloodyQueenMonster.ComponentDefine = ComponentDefine
WorldS1RestBloodyQueenMonster.ComponentDestroy = ComponentDestroy
WorldS1RestBloodyQueenMonster.DataDefine = DataDefine
WorldS1RestBloodyQueenMonster.DataDestroy = DataDestroy
WorldS1RestBloodyQueenMonster.RefreshData = RefreshData
return WorldS1RestBloodyQueenMonster
