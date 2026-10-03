local base = UIBaseContainer
local LWUIBerserkBossDamageStatisticsItemRender = BaseClass("LWUIBerserkBossDamageStatisticsItemRender", base)
local Localization = CS.GameEntry.Localization
local desText_path = "HorLayout/DesText"
local valueText_path = "HorLayout/ValueText"

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
  self.desText = self:AddComponent(UIText, desText_path)
  self.valueText = self:AddComponent(UIText, valueText_path)
end

local function ComponentDestroy(self)
  self.desText = nil
  self.valueText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, index, data)
  self.damageData = data
  self.itemIndex = index
  self.valueText:SetText(string.GetFormattedStr2(self.damageData.score))
  if self.damageData.bossUuid == 0 then
    self.desText:SetLocalText("activity_berserkboss_title_12")
  else
    local monsterName = DataCenter.LWBerserkBossManager:GetBerserkBossNameByBossUuid(self.damageData.bossUuid)
    self.desText:SetLocalText("activity_berserkboss_title_11", Localization:GetString(monsterName))
  end
end

LWUIBerserkBossDamageStatisticsItemRender.OnCreate = OnCreate
LWUIBerserkBossDamageStatisticsItemRender.OnDestroy = OnDestroy
LWUIBerserkBossDamageStatisticsItemRender.OnEnable = OnEnable
LWUIBerserkBossDamageStatisticsItemRender.OnDisable = OnDisable
LWUIBerserkBossDamageStatisticsItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossDamageStatisticsItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossDamageStatisticsItemRender.DataDefine = DataDefine
LWUIBerserkBossDamageStatisticsItemRender.DataDestroy = DataDestroy
LWUIBerserkBossDamageStatisticsItemRender.InitData = InitData
return LWUIBerserkBossDamageStatisticsItemRender
