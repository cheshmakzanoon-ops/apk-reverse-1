local BanquetAttackBossLogCard = BaseClass("BanquetAttackBossLogCard", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
end

local function ComponentDestroy(self)
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

function BanquetAttackBossLogCard:SetData(data)
  self.data = data
end

BanquetAttackBossLogCard.OnCreate = OnCreate
BanquetAttackBossLogCard.OnDestroy = OnDestroy
BanquetAttackBossLogCard.OnEnable = OnEnable
BanquetAttackBossLogCard.OnDisable = OnDisable
BanquetAttackBossLogCard.ComponentDefine = ComponentDefine
BanquetAttackBossLogCard.ComponentDestroy = ComponentDestroy
BanquetAttackBossLogCard.DataDefine = DataDefine
BanquetAttackBossLogCard.DataDestroy = DataDestroy
BanquetAttackBossLogCard.OnAddListener = OnAddListener
BanquetAttackBossLogCard.OnRemoveListener = OnRemoveListener
return BanquetAttackBossLogCard
