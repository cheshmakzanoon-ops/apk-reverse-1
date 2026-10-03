local base = require("UI.UIRaceEntrance.Component.ActDownloadNodeBase")
local LWUIMigrationRoot = BaseClass("LWUIMigrationRoot", base)
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local Cls_Main = require("UI.LWUIMigration.Component.LWUIMigrationView_Main")
local Cls_List = require("UI.LWUIMigration.Component.LWUIMigrationView_List")
local Cls_Set = require("UI.LWUIMigration.Component.LWUIMigrationView_Set")
local Cls_Market = require("UI.LWUIMigration.Component.LWUIMigrationView_Market")
local Cls_Star = require("UI.LWUIMigration.Component.LWUIMigrationView_Star")
local base_toggle_path = "ScrollRect/Tab/TabItem"
local text_31_path = "ScrollRect/Tab/TabItem3/Text31"
local text_32_path = "ScrollRect/Tab/TabItem3/Select/Text32"
local content_base_path = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_%s.prefab"
local content_keys = {
  "Main",
  "List",
  "Set",
  "Market"
}
local content_keys_star = {
  "Main",
  "List",
  "Set",
  "Market",
  "Star"
}
local content_cls = {
  Cls_Main,
  Cls_List,
  Cls_Set,
  Cls_Market
}
local content_cls_star = {
  Cls_Main,
  Cls_List,
  Cls_Set,
  Cls_Market,
  Cls_Star
}

local function GetContentKeys()
  local mgr = DataCenter.ActMigrationManager
  if mgr and mgr:IsZoneStarEnable() then
    return content_keys_star
  end
  return content_keys
end

local function GetContentClassList()
  local mgr = DataCenter.ActMigrationManager
  if mgr and mgr:IsZoneStarEnable() then
    return content_cls_star
  end
  return content_cls
end

function LWUIMigrationRoot:OnCreate()
  base.OnCreate(self)
  self.requests = {}
  self.contents = {}
  self.toggles = {}
  self.k6 = LuaEntry.DataConfig:TryGetNum("lw_migration", "k6", 4)
  self.center = self:AddComponent(UIBaseContainer, "center")
  local keys = GetContentKeys()
  for i, _ in ipairs(keys) do
    local keyStr = base_toggle_path .. i
    local toggle = self:AddComponent(UIToggle, keyStr)
    toggle:SetOnValueChanged(function(tf)
      self:SetOnValueChanged(i, tf)
    end)
    self.toggles[i] = toggle
    if i == 3 then
      keyStr = keyStr .. "/RedPoint"
      self.red_set = self:AddComponent(UIBaseComponent, keyStr)
      self.text_red_set = self:AddComponent(UIText, keyStr .. "/RedNum")
    end
  end
  self:RefreshTab4()
  self:RefreshTab5_Star()
  local str = Localization:GetString("migration_activity_interface_10003", LuaEntry.Player:GetSourceServerId())
  self.text_31 = self:AddComponent(UIText, text_31_path)
  self.text_31:SetText(str)
  self.text_32 = self:AddComponent(UIText, text_32_path)
  self.text_32:SetText(str)
end

function LWUIMigrationRoot:OnDestroy()
  for _, v in pairs(self.requests) do
    v:Destroy()
    v = nil
  end
  self.memSearchAllianceName = nil
  self:CurContentHide()
  self.requests = {}
  self.contents = {}
  self.toggles = {}
  base.OnDestroy(self)
end

function LWUIMigrationRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationInfoUpdate, self.RefreshData)
  self:AddUIListener(EventId.ActMigrationUITabSel, self.OnTabSel)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.ActMigrationSearchAllianceByName, self.OnSearchAllianceByName)
end

function LWUIMigrationRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationInfoUpdate, self.RefreshData)
  self:RemoveUIListener(EventId.ActMigrationUITabSel, self.OnTabSel)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.ActMigrationSearchAllianceByName, self.OnSearchAllianceByName)
  base.OnRemoveListener(self)
end

function LWUIMigrationRoot:GetActType()
  return EnumActivity.ActMigration.Type
end

function LWUIMigrationRoot:OnEnterNode()
  DataCenter.ActMigrationManager:ReqActInfo(true)
end

function LWUIMigrationRoot:UpdateData()
  if self.activityId == nil then
    return
  end
  local toTab = DataCenter.ActMigrationManager.jumpToTab
  if toTab ~= nil then
    self:SetToggle(toTab)
    DataCenter.ActMigrationManager.jumpToTab = nil
  elseif DataCenter.ActMigrationManager.jumpToServerId ~= nil then
    self:SetToggle(2)
  else
    self:SetToggle(1)
  end
end

function LWUIMigrationRoot:RefreshTab4()
  self.toggles[4]:SetActive(true)
end

function LWUIMigrationRoot:RefreshTab5_Star()
  local toggle = self.toggles[5]
  if not toggle then
    return
  end
  toggle:SetActive(DataCenter.ActMigrationManager:IsZoneStarEnable())
end

function LWUIMigrationRoot:CurContentHide()
  if self.curContent then
    self.curContent:DoHideSelf()
  end
  self.curContent = nil
  self.curIdx = 0
end

function LWUIMigrationRoot:OnTabSel(info)
  if table.IsNullOrEmpty(info) then
    return
  end
  self.tabExtInfo = info.ext
  self:SetToggle(info.tab)
end

function LWUIMigrationRoot:SetToggle(idx)
  local toggle = self.toggles[idx]
  if toggle ~= nil then
    toggle:SetIsOn(true)
    self:SetOnValueChanged(idx, true)
  end
end

function LWUIMigrationRoot:SetOnValueChanged(idx, tf)
  if not tf then
    return
  end
  if self.curIdx == idx then
    return
  end
  self:CurContentHide()
  local keys = GetContentKeys()
  local key = keys[idx]
  self.curContent = self.contents[key]
  self.curIdx = idx
  if self.curContent ~= nil then
    self:RefreshCur(key)
    return
  end
  if self.requests[key] ~= nil then
    return
  end
  local clsList = GetContentClassList()
  local class = clsList[idx]
  self.requests[key] = self:GameObjectInstantiateAsync(string.format(content_base_path, key), function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      return
    end
    _go.name = key
    local pTF = _go.transform
    pTF:SetParent(self.center.transform)
    pTF:Set_localScale(1, 1, 1)
    local newContent = self.center:AddComponent(class, key)
    local rect = self.center.rectTransform.rect
    newContent.rectTransform:Set_sizeDelta(rect.width, rect.height)
    newContent.rectTransform:ForceUpdateRectTransforms()
    self.contents[key] = newContent
    if self.curIdx == idx then
      self.curContent = newContent
      self:RefreshCur(key)
    else
      newContent:DoHideSelf()
    end
  end)
end

function LWUIMigrationRoot:RefreshCur(key)
  if self.curContent ~= nil then
    self.curContent:SetData(self.tabExtInfo)
    self.tabExtInfo = nil
    if key == "Market" and self.memSearchAllianceName then
      self.curContent:SearchAlliance(self.memSearchAllianceName)
      self.memSearchAllianceName = nil
    end
  end
  self:UpdateRed()
end

function LWUIMigrationRoot:RefreshData()
  if not self:AsyncLoadDone() then
    return
  end
  if self.curContent ~= nil then
    if self.curContent.RefreshData then
      self.curContent:RefreshData()
    else
      self.curContent:SetData()
    end
  end
  self:UpdateRed()
end

function LWUIMigrationRoot:UpdateRed()
  local redNum = DataCenter.ActMigrationManager:GetRedNum()
  self.red_set:SetActive(0 < redNum)
  self.text_red_set:SetText(redNum < 100 and redNum or "99+")
end

function LWUIMigrationRoot:Update1000MS()
  DataCenter.ActMigrationManager:ReqActInfo()
end

function LWUIMigrationRoot:OnPassDay()
  DataCenter.ActMigrationManager:ReqActInfo(true)
  if not self:AsyncLoadDone() then
    return
  end
  self:RefreshTab4()
end

function LWUIMigrationRoot:OnSearchAllianceByName(name)
  if string.IsNullOrEmpty(name) then
    return
  end
  self.memSearchAllianceName = name
  self:SetToggle(4)
end

return LWUIMigrationRoot
