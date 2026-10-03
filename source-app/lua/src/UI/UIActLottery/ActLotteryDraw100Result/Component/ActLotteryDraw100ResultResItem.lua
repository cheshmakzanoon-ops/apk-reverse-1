local ActLotteryDraw100ResultResItem = BaseClass("ActLotteryDraw100ResultResItem", UIBaseContainer)
local root_path = "Root"
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
  self.commonResItem = self:AddComponent(UICommonResItem, "Root/UICommonResItem")
  self.root = self:AddComponent(UIBaseContainer, root_path)
end

local function ComponentDestroy(self)
  self.commonResItemObj = nil
  self.root = nil
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

function ActLotteryDraw100ResultResItem:SetData(itemData)
  self.commonResItem:ReInit(itemData)
end

function ActLotteryDraw100ResultResItem:SetShowHideState(isShow)
  if not self.root then
    return
  end
  self.root:SetActive(isShow)
end

ActLotteryDraw100ResultResItem.OnCreate = OnCreate
ActLotteryDraw100ResultResItem.OnDestroy = OnDestroy
ActLotteryDraw100ResultResItem.OnEnable = OnEnable
ActLotteryDraw100ResultResItem.OnDisable = OnDisable
ActLotteryDraw100ResultResItem.ComponentDefine = ComponentDefine
ActLotteryDraw100ResultResItem.ComponentDestroy = ComponentDestroy
ActLotteryDraw100ResultResItem.DataDefine = DataDefine
ActLotteryDraw100ResultResItem.DataDestroy = DataDestroy
ActLotteryDraw100ResultResItem.OnAddListener = OnAddListener
ActLotteryDraw100ResultResItem.OnRemoveListener = OnRemoveListener
return ActLotteryDraw100ResultResItem
