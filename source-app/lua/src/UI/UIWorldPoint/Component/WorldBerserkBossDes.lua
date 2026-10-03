local base = UIAsyncContainer
local WorldBerserkBossDes = BaseClass("WorldBerserkBossDes", base)
local LWUIBerserkBossEffectItemRender = require("UI.UIWorldPoint.Component.LWUIBerserkBossEffectItemRender")
local LWUIBerserkBossAllianceRankItemRender = require("UI.UIWorldPoint.Component.LWUIBerserkBossAllianceRankItemRender")
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
local rankingTipsText_path = "BottomContent/RankingTipsText"
local rankingContent_path = "BottomContent/RankingContent"
local berserkBossAllianceRankObj_path = "BottomContent/RankingContent/LWUIBerserkBossAllianceRankItemRender"
local timeText_path = "TimeContent/TimeText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearEffectCells()
  self:ClearAllianceRankCells()
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
  self.rankingTipsText = self:AddComponent(UIText, rankingTipsText_path)
  self.rankingContent = self:AddComponent(UIBaseContainer, rankingContent_path)
  self.berserkBossAllianceRankObj = self:AddComponent(UIBaseContainer, berserkBossAllianceRankObj_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.shareBtn:SetOnClick(function()
    self.view.ctrl:OnShareClick(self.view.ctrl.serverId, self.pointData.point, self.pointData.name, nil)
  end)
  self.markBtn:SetOnClick(function()
    local realPoint = self.pointData.point * 10 + 1
    self.view.ctrl:OnMarkClick(self.view.ctrl.serverId, realPoint, self.pointData.name, nil, MarkGroup.Personal)
  end)
  self.effectItem = self.transform:Find(berserkBossEffectObj_path).gameObject
  self.effectItem:GameObjectCreatePool()
  self.rankItem = self.transform:Find(berserkBossAllianceRankObj_path).gameObject
  self.rankItem:GameObjectCreatePool()
  self.effectTipsText:SetLocalText("activity_berserkboss_title_15")
  self.rankingTipsText:SetLocalText("activity_berserkboss_title_16")
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
  self.rankingTipsText = nil
  self.rankingContent = nil
  self.berserkBossAllianceRankObj = nil
  self.timeText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function Update1000MS(self)
  if self.pointData == nil then
    return
  end
  self:RefreshBossStatusTime()
end

local function RefreshData(self, param)
  self.pointData = param
  if self.pointData == nil then
    return
  end
  self.bossNameText:SetLocalText(self.pointData.name)
  local berserkBossTemplate = DataCenter.LWActivityBerserkBossTemplateManager:GetTemplate(self.pointData.berserkBossConfigId)
  if berserkBossTemplate ~= nil then
    self.worldBossRawImage:LoadSpriteAuto(berserkBossTemplate.img)
    self.bossLevelText:SetText("Lv." .. tostring(berserkBossTemplate.level))
  end
  local progressValue = Mathf.Clamp(self.pointData.monsterHpRatio / 100, 0, 1)
  self.hpProgress:SetValue(progressValue)
  self.hpProgressText:SetText(string.GetFormattedStr(self.pointData.curHp) .. " " .. string.format("%.2f", self.pointData.monsterHpRatio) .. "%")
  self:RefreshBossStatusTime()
  self:ShowEffectData()
  self:ShowAllianceRankData()
end

local function RefreshBossStatusTime(self)
  if self.pointData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = self.pointData.endTime - curTime
  if surplusTime <= 0 then
    self.view.ctrl:CloseSelf()
  elseif self.timeText then
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
  end
end

local function ShowEffectData(self)
  if self.pointData == nil then
    return
  end
  self:ClearEffectCells()
  local berserkBossTemplate = DataCenter.LWActivityBerserkBossTemplateManager:GetTemplate(self.pointData.berserkBossConfigId)
  if berserkBossTemplate ~= nil then
    local effectList = berserkBossTemplate:GetEffectDataList()
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

local function ShowAllianceRankData(self)
  self:ClearAllianceRankCells()
  local rankList = DataCenter.LWBerserkBossManager:GetBerserkBossAllianceDamageRankList()
  local count = table.count(rankList)
  local maxValue = 0
  if 0 < count then
    table.sort(rankList, function(a, b)
      return a.rank < b.rank
    end)
    maxValue = rankList[1].score
  end
  for i = 1, count do
    local rankData = rankList[i]
    local go = self.rankItem:GameObjectSpawn(self.rankingContent.transform)
    go.name = "item_" .. i
    go:SetActive(true)
    local itemRender = self.rankingContent:AddComponent(LWUIBerserkBossAllianceRankItemRender, go.name)
    itemRender:InitData(rankData, maxValue)
  end
end

local function ClearAllianceRankCells(self)
  self.rankingContent:RemoveComponents(LWUIBerserkBossAllianceRankItemRender)
  self.rankItem:GameObjectRecycleAll()
end

WorldBerserkBossDes.OnCreate = OnCreate
WorldBerserkBossDes.OnDestroy = OnDestroy
WorldBerserkBossDes.OnEnable = OnEnable
WorldBerserkBossDes.OnDisable = OnDisable
WorldBerserkBossDes.ComponentDefine = ComponentDefine
WorldBerserkBossDes.ComponentDestroy = ComponentDestroy
WorldBerserkBossDes.DataDefine = DataDefine
WorldBerserkBossDes.DataDestroy = DataDestroy
WorldBerserkBossDes.Update1000MS = Update1000MS
WorldBerserkBossDes.RefreshData = RefreshData
WorldBerserkBossDes.RefreshBossStatusTime = RefreshBossStatusTime
WorldBerserkBossDes.ShowEffectData = ShowEffectData
WorldBerserkBossDes.ClearEffectCells = ClearEffectCells
WorldBerserkBossDes.ShowAllianceRankData = ShowAllianceRankData
WorldBerserkBossDes.ClearAllianceRankCells = ClearAllianceRankCells
return WorldBerserkBossDes
