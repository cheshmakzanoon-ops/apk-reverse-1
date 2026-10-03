local base = UIBaseContainer
local LWSeasonUpgradeLogItemRenderer = BaseClass("LWSeasonUpgradeLogItemRenderer", base)
local tmpTitle_path = "tmpTitle"
local tmpDetail_path = "tmpDetail"

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
  self.tmpTitle = self:AddComponent(UIText, tmpTitle_path)
  self.tmpDetail = self:AddComponent(UITextMeshProUGUIEx, tmpDetail_path)
  self.tmpDetail:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.tmpDetail, eventData)
  end)
end

local function ComponentDestroy(self)
  self.tmpTitle = nil
  self.tmpDetail = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWSeasonUpgradeLogItemRenderer:ReInit(scroller, index, data)
  if not data then
    return
  end
  self.tmpTitle:SetText(data.dateString)
  self.tmpDetail:SetLocalText(data.update_description)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  scroller:OnItemSizeChanged(index)
end

LWSeasonUpgradeLogItemRenderer.OnCreate = OnCreate
LWSeasonUpgradeLogItemRenderer.OnDestroy = OnDestroy
LWSeasonUpgradeLogItemRenderer.OnEnable = OnEnable
LWSeasonUpgradeLogItemRenderer.OnDisable = OnDisable
LWSeasonUpgradeLogItemRenderer.ComponentDefine = ComponentDefine
LWSeasonUpgradeLogItemRenderer.ComponentDestroy = ComponentDestroy
LWSeasonUpgradeLogItemRenderer.DataDefine = DataDefine
LWSeasonUpgradeLogItemRenderer.DataDestroy = DataDestroy
return LWSeasonUpgradeLogItemRenderer
