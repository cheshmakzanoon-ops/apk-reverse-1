local base = UIBaseContainer
local LWSeasonBossLoginRecordItemRender = BaseClass("LWSeasonBossLoginRecordItemRender", base)
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local bg_path = "Bg"
local timeText_path = "NormalContent/TimeText"
local damageText_path = "NormalContent/DamageText"
local expandBtn_path = "NormalContent/ExpandBtn"
local expandStateMark_path = "NormalContent/ExpandBtn/ExpandStateMark"
local closeStateMark_path = "NormalContent/ExpandBtn/CloseStateMark"
local expandContent_path = "ExpandContent"
local heroContent_path = "ExpandContent/HeroContent"
local uiHeroCellObj_path = "ExpandContent/UIHeroCellSmall"
local playBtn_path = "NormalContent/PlayBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveHero()
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
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.damageText = self:AddComponent(UIText, damageText_path)
  self.expandBtn = self:AddComponent(UIButton, expandBtn_path)
  self.expandStateMark = self:AddComponent(UIBaseContainer, expandStateMark_path)
  self.closeStateMark = self:AddComponent(UIBaseContainer, closeStateMark_path)
  self.expandContent = self:AddComponent(UIBaseContainer, expandContent_path)
  self.heroContent = self:AddComponent(UIBaseContainer, heroContent_path)
  self.uiHeroCellObj = self:AddComponent(UIBaseContainer, uiHeroCellObj_path)
  self.playBtn = self:AddComponent(UIButton, playBtn_path)
  self.playBtn:SetOnClick(function()
    self:PlayBtnClick()
  end)
  self.expandBtn:SetOnClick(function()
    self:ExpandBtnClick()
  end)
  self.heroCellObj = self.transform:Find(uiHeroCellObj_path).gameObject
  self.heroCellObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.bg = nil
  self.timeText = nil
  self.damageText = nil
  self.expandBtn = nil
  self.expandStateMark = nil
  self.closeStateMark = nil
  self.expandContent = nil
  self.heroContent = nil
  self.uiHeroCellObj = nil
  self.playBtn = nil
  self.heroCellObj = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.battleReportData = nil
  self.expandState = false
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.battleReportData = nil
  self.expandState = nil
end

local function InitData(self, index, data)
  self.itemIndex = index
  self.battleReportData = data
  self:SetExpandState(false)
  if self.battleReportData then
    local _strTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.battleReportData.time)
    self.timeText:SetText(_strTime)
    self.damageText:SetText(string.GetFormattedSeperatorNum(self.battleReportData.damage))
    self:RemoveHero()
    self:ShowHero()
  end
end

local function SetExpandState(self, expand)
  self.expandState = expand
  self.bg:SetActive(expand)
  self.expandContent:SetActive(expand)
  self.expandStateMark:SetActive(expand)
  self.closeStateMark:SetActive(not expand)
end

local function ShowHero(self)
  for i = 1, table.count(self.battleReportData.heroList) do
    local armyHeroInfo = self.battleReportData.heroList[i]
    local goObj = self.heroCellObj:GameObjectSpawn(self.heroContent.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.heroContent:AddComponent(UIHeroCellSmall, goObj.name)
    itemRender:InitWithConfigId(armyHeroInfo.heroId, armyHeroInfo.heroQuality, armyHeroInfo.heroLevel, armyHeroInfo.rankLv, armyHeroInfo.weaponLevel, armyHeroInfo.awakenLv, armyHeroInfo.heroSkinId)
  end
end

local function RemoveHero(self)
  self.heroContent:RemoveComponents(UIHeroCellSmall)
  self.heroCellObj:GameObjectRecycleAll()
end

local function ExpandBtnClick(self)
  self:SetExpandState(not self.expandState)
end

local function PlayBtnClick(self)
  local isAddressMode = false
  local address = ""
  if self.battleReportData then
    isAddressMode = BattleReportUtil.IsAddressMode(self.battleReportData.reportAddress)
    address = self.battleReportData.reportAddress or ""
  end
  BattleReportUtil.Create(self.battleReportData.reportId, PVEEnterType.Default, true, isAddressMode, address, BattleReportPreviewEnterType.ActWorldBossBattleRecord)
end

LWSeasonBossLoginRecordItemRender.OnCreate = OnCreate
LWSeasonBossLoginRecordItemRender.OnDestroy = OnDestroy
LWSeasonBossLoginRecordItemRender.OnEnable = OnEnable
LWSeasonBossLoginRecordItemRender.OnDisable = OnDisable
LWSeasonBossLoginRecordItemRender.ComponentDefine = ComponentDefine
LWSeasonBossLoginRecordItemRender.ComponentDestroy = ComponentDestroy
LWSeasonBossLoginRecordItemRender.DataDefine = DataDefine
LWSeasonBossLoginRecordItemRender.DataDestroy = DataDestroy
LWSeasonBossLoginRecordItemRender.InitData = InitData
LWSeasonBossLoginRecordItemRender.SetExpandState = SetExpandState
LWSeasonBossLoginRecordItemRender.ShowHero = ShowHero
LWSeasonBossLoginRecordItemRender.RemoveHero = RemoveHero
LWSeasonBossLoginRecordItemRender.ExpandBtnClick = ExpandBtnClick
LWSeasonBossLoginRecordItemRender.PlayBtnClick = PlayBtnClick
return LWSeasonBossLoginRecordItemRender
