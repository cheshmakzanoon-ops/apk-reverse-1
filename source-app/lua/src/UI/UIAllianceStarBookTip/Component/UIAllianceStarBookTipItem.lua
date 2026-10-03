local UIAllianceStarBookTipItem = BaseClass("UIAllianceStarBookTipItem", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTip = self:AddComponent(UIText, "TipText")
  self.textScore = self:AddComponent(UIText, "ScoreText")
end

local function ComponentDestroy(self)
  self.textTip = nil
  self.textScore = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

function UIAllianceStarBookTipItem:SetData(tipInfo)
  self.textTip:SetLocalText(tipInfo.dialogId)
  self.textScore:SetText("+" .. tipInfo.score)
end

UIAllianceStarBookTipItem.OnCreate = OnCreate
UIAllianceStarBookTipItem.OnDestroy = OnDestroy
UIAllianceStarBookTipItem.OnEnable = OnEnable
UIAllianceStarBookTipItem.OnDisable = OnDisable
UIAllianceStarBookTipItem.ComponentDefine = ComponentDefine
UIAllianceStarBookTipItem.ComponentDestroy = ComponentDestroy
UIAllianceStarBookTipItem.DataDefine = DataDefine
UIAllianceStarBookTipItem.DataDestroy = DataDestroy
UIAllianceStarBookTipItem.OnAddListener = OnAddListener
UIAllianceStarBookTipItem.OnRemoveListener = OnRemoveListener
return UIAllianceStarBookTipItem
