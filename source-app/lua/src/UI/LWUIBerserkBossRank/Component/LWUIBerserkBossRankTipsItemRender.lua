local base = UIBaseContainer
local LWUIBerserkBossRankTipsItemRender = BaseClass("LWUIBerserkBossRankTipsItemRender", base)
local rankTipsText_path = "RankTipsText"

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
  self.rankTipsText = self:AddComponent(UIText, rankTipsText_path)
end

local function ComponentDestroy(self)
  self.rankTipsText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, des)
  self.rankTipsText:SetText(des)
end

LWUIBerserkBossRankTipsItemRender.OnCreate = OnCreate
LWUIBerserkBossRankTipsItemRender.OnDestroy = OnDestroy
LWUIBerserkBossRankTipsItemRender.OnEnable = OnEnable
LWUIBerserkBossRankTipsItemRender.OnDisable = OnDisable
LWUIBerserkBossRankTipsItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossRankTipsItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossRankTipsItemRender.DataDefine = DataDefine
LWUIBerserkBossRankTipsItemRender.DataDestroy = DataDestroy
LWUIBerserkBossRankTipsItemRender.InitData = InitData
return LWUIBerserkBossRankTipsItemRender
