local base = UIBaseView
local LWUIGiftHistoryView = BaseClass("LWUIGiftHistoryView", base)
local LWUIGiftHistoryContentView = require("UI.LWPlayerInfo.UILWGiftSystem.GiftHistory.Component.LWUIGiftHistoryContentView")
local closeBtn_path = "panel"

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
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.content = self:AddComponent(LWUIGiftHistoryContentView, "LWUIGiftHistoryContent")
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

local function ComponentDestroy(self)
  self.closeBtn = nil
end

local function DataDefine(self)
  self.list = {}
  local data = self:GetUserData() or {}
  self.targetUid = data.targetUid
  self.itemId = data.itemId
  self.startIndex = 1
end

local function DataDestroy(self)
  self.list = {}
  self.targetUid = nil
  self.itemId = nil
  self.startIndex = 1
end

LWUIGiftHistoryView.OnCreate = OnCreate
LWUIGiftHistoryView.OnDestroy = OnDestroy
LWUIGiftHistoryView.OnEnable = OnEnable
LWUIGiftHistoryView.OnDisable = OnDisable
LWUIGiftHistoryView.ComponentDefine = ComponentDefine
LWUIGiftHistoryView.ComponentDestroy = ComponentDestroy
LWUIGiftHistoryView.DataDefine = DataDefine
LWUIGiftHistoryView.DataDestroy = DataDestroy
return LWUIGiftHistoryView
