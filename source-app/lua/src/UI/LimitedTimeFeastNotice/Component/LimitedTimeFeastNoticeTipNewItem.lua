local LimitedTimeFeastNoticeTipNewItem = BaseClass("LimitedTimeFeastNoticeTipNewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local tip_txt_path = "TipTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
  self.root = self:AddComponent(UIBaseContainer, "")
end

local function ComponentDestroy(self)
  self.tip_txt = nil
end

local function SetData(self, param, scroll_view, index)
  self.param = param
  self.scroll_view = scroll_view
  self.index = index
  self.tip_txt:SetLocalText(self.param.text)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
end

LimitedTimeFeastNoticeTipNewItem.OnCreate = OnCreate
LimitedTimeFeastNoticeTipNewItem.OnDestroy = OnDestroy
LimitedTimeFeastNoticeTipNewItem.ComponentDefine = ComponentDefine
LimitedTimeFeastNoticeTipNewItem.ComponentDestroy = ComponentDestroy
LimitedTimeFeastNoticeTipNewItem.SetData = SetData
return LimitedTimeFeastNoticeTipNewItem
