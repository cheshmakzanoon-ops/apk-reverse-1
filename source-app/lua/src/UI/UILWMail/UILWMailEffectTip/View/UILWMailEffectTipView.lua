local base = UIBaseView
local UILWMailEffectTipView = BaseClass("UILWMailEffectTipView", base)
local MailEffectTipItem = require("UI.UILWMail.UILWMailEffectTip.Component.MailEffectTipItem")
local SCROLL_MAX_HEIGHT = 380

function UILWMailEffectTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UILWMailEffectTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailEffectTipView:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailEffectTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailEffectTipView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.itemScrollContent = self:AddComponent(UIBaseContainer, "Tip/TipBg/Viewport/Content")
  self.upArrow = self:AddComponent(UIImage, "Tip/TipBg/upArrow")
  self.downArrow = self:AddComponent(UIImage, "Tip/TipBg/downArrow")
  self.bg = self:AddComponent(UIBaseComponent, "Tip/TipBg")
  self.itemTemp = self.transform:Find("Tip/TipBg/Viewport/Content/MailEffectTipItem").gameObject
  self.itemTemp:GameObjectCreatePool()
  self.itemTemp:SetActive(false)
end

function UILWMailEffectTipView:ComponentDestroy()
  self.bgMask = nil
  self.itemScrollContent:RemoveComponents(MailEffectTipItem)
  self.itemScrollContent = nil
  self.arrow = nil
  self.bg = nil
  self.itemTemp:GameObjectRecycleAll()
  self.itemTemp = nil
end

function UILWMailEffectTipView:DataDefine()
  self.position, self.meta, self.effectValue1, self.effectValue2, self.otherEffectsRaw1, self.otherEffectsRaw2 = self:GetUserData()
end

function UILWMailEffectTipView:DataDestroy()
end

function UILWMailEffectTipView:Refresh()
  self.itemScrollContent:RemoveComponents(MailEffectTipItem)
  self.itemTemp.gameObject:GameObjectRecycleAll()
  if self:RefreshFromOtherEffectsRawIfNeeded() then
    self:RefreshPosition()
    self:CalScrollHeight()
    return
  end
  self:RefreshLegacyMetaAndDic()
  self:RefreshPosition()
  self:CalScrollHeight()
end

function UILWMailEffectTipView:RefreshFromOtherEffectsRawIfNeeded()
  local tabs1 = self:MergeOtherEffectsByTabType(self.otherEffectsRaw1 or {})
  local tabs2 = self:MergeOtherEffectsByTabType(self.otherEffectsRaw2 or {})
  if not self:HasAnyEffectInMergedTabs(tabs1) and not self:HasAnyEffectInMergedTabs(tabs2) then
    return false
  end
  local allowedPairs = self:BuildAllowedOtherEffectEntries(self.meta)
  local useFilter = next(allowedPairs) ~= nil
  local lastCell
  local tabMap1 = self:BuildMergedTabMap(tabs1)
  local tabMap2 = self:BuildMergedTabMap(tabs2)
  local effectEntries = self:BuildEffectEntriesForTip(tabs1, tabs2, allowedPairs, useFilter)
  if #effectEntries == 0 then
    return false
  end
  local mgr = DataCenter.MailExtraEffectTemplateManager
  for _, entry in ipairs(effectEntries) do
    local tabType = entry.tabType
    local eid = entry.effectId
    local tabP1 = tabMap1[tabType]
    local tabP2 = tabMap2[tabType]
    local passFilter = not useFilter or allowedPairs[tostring(tabType) .. "_" .. tostring(eid)]
    local onEither = self:MergedTabContainsEffectId(tabP1, eid) or self:MergedTabContainsEffectId(tabP2, eid)
    if passFilter and onEither then
      local tpl = mgr:GetTemplateByOtherTabAndEffectId(tabType, eid)
      if tpl then
        local leftValue = self:SumEffectValueInMergedTab(tabP1, eid)
        local rightValue = self:SumEffectValueInMergedTab(tabP2, eid)
        if leftValue ~= 0 or rightValue ~= 0 then
          local descKey, gotoType, gotoParam = self:TipLineDescAndGotoFromTpl(tpl, eid)
          local item = self.itemTemp:GameObjectSpawn(self.itemScrollContent.transform)
          item.name = tostring(tabType) .. "_" .. tostring(eid)
          local cell = self.itemScrollContent:AddComponent(MailEffectTipItem, item.name)
          cell:SetData(descKey, leftValue, rightValue, gotoType, gotoParam)
          lastCell = cell
        end
      end
    end
  end
  if lastCell then
    lastCell:HideLine()
    return true
  end
  return false
end

function UILWMailEffectTipView:MergeOtherEffectsByTabType(raw)
  if raw == nil then
    return {}
  end
  local byType = {}
  for _, tab in pairs(raw) do
    if tab then
      local tt = tonumber(tab.tabType)
      if tt and tt ~= 0 then
        if not byType[tt] then
          byType[tt] = {
            tabType = tt,
            effects = {}
          }
        end
        local dst = byType[tt].effects
        if tab.effects then
          for _, eff in ipairs(tab.effects) do
            if eff then
              dst[#dst + 1] = eff
            end
          end
        end
      end
    end
  end
  local list = {}
  for _, merged in pairs(byType) do
    list[#list + 1] = merged
  end
  return list
end

function UILWMailEffectTipView:BuildAllowedOtherEffectEntries(meta)
  local allowedPairs = {}
  if meta and meta.effectEntries then
    for _, entry in ipairs(meta.effectEntries) do
      local tabType = entry and tonumber(entry.tabType)
      local effectId = entry and tonumber(entry.effectId)
      if tabType and tabType ~= 0 and effectId and effectId ~= 0 then
        local pairKey = tostring(tabType) .. "_" .. tostring(effectId)
        if not allowedPairs[pairKey] then
          allowedPairs[pairKey] = true
        end
      end
    end
  end
  return allowedPairs
end

function UILWMailEffectTipView:SumEffectValueInMergedTab(mergedTab, eid)
  if mergedTab == nil or mergedTab.effects == nil then
    return 0
  end
  local target = tonumber(eid)
  local s = 0
  for _, eff in ipairs(mergedTab.effects) do
    if eff and tonumber(eff.id) == target then
      s = s + (tonumber(eff.val) or 0)
    end
  end
  return s
end

function UILWMailEffectTipView:BuildMergedTabMap(mergedTabs)
  local map = {}
  if mergedTabs == nil then
    return map
  end
  for _, tab in ipairs(mergedTabs) do
    local tt = tab and tonumber(tab.tabType)
    if tt and tt ~= 0 then
      map[tt] = tab
    end
  end
  return map
end

function UILWMailEffectTipView:HasAnyEffectInMergedTabs(tabs)
  for _, tab in ipairs(tabs) do
    if tab and tab.effects and #tab.effects > 0 then
      return true
    end
  end
  return false
end

function UILWMailEffectTipView:MergedTabContainsEffectId(mergedTab, eid)
  local target = tonumber(eid)
  if not (mergedTab ~= nil and mergedTab.effects ~= nil and target) or target == 0 then
    return false
  end
  for _, eff in ipairs(mergedTab.effects) do
    if eff and tonumber(eff.id) == target then
      return true
    end
  end
  return false
end

function UILWMailEffectTipView:TipLineDescAndGotoFromTpl(tpl, eid)
  local desc = tpl.effectName and tpl.effectName[1]
  if string.IsNullOrEmpty(desc) then
    desc = DataCenter.EffectNumberTemplateManager:GetEffectNumberDesc(eid)
  end
  if string.IsNullOrEmpty(desc) then
    desc = tostring(eid)
  end
  local gotoType, gotoParam = 0, 0
  if tpl.gotoType and tpl.gotoType[1] then
    gotoType = tonumber(tpl.gotoType[1]) or 0
    if tpl.gotoParam and tpl.gotoParam[1] ~= nil then
      gotoParam = tonumber(tpl.gotoParam[1]) or 0
    end
  end
  return desc, gotoType, gotoParam
end

function UILWMailEffectTipView:BuildEffectEntriesForTip(tabs1, tabs2, allowedPairs, useFilter)
  local list = {}
  if useFilter and self.meta and self.meta.effectEntries then
    for _, entry in ipairs(self.meta.effectEntries) do
      local tabType = entry and tonumber(entry.tabType)
      local effectId = entry and tonumber(entry.effectId)
      if tabType and tabType ~= 0 and effectId and effectId ~= 0 then
        list[#list + 1] = {tabType = tabType, effectId = effectId}
      end
    end
    return list
  end
  local seen = {}
  
  local function collectIdsFromTabs(tabs)
    for _, tab in ipairs(tabs) do
      local tabType = tab and tonumber(tab.tabType) or 0
      if tab and tab.effects then
        for _, eff in ipairs(tab.effects) do
          local effectId = eff and tonumber(eff.id)
          if tabType ~= 0 and effectId and effectId ~= 0 then
            local pairKey = tostring(tabType) .. "_" .. tostring(effectId)
            if (not useFilter or allowedPairs[pairKey]) and not seen[pairKey] then
              seen[pairKey] = true
              list[#list + 1] = {tabType = tabType, effectId = effectId}
            end
          end
        end
      end
    end
  end
  
  collectIdsFromTabs(tabs1 or {})
  collectIdsFromTabs(tabs2 or {})
  table.sort(list, function(a, b)
    if a.tabType ~= b.tabType then
      return a.tabType < b.tabType
    end
    return a.effectId < b.effectId
  end)
  return list
end

function UILWMailEffectTipView:RefreshLegacyMetaAndDic()
  local lastCell
  for i = 1, table.length(self.meta.effectId) do
    local effectId = self.meta.effectId[i]
    local leftValue = self.effectValue1[effectId] or 0
    local rightValue = self.effectValue2[effectId] or 0
    if leftValue ~= 0 or rightValue ~= 0 then
      local item = self.itemTemp:GameObjectSpawn(self.itemScrollContent.transform)
      item.name = tostring(i)
      local cell = self.itemScrollContent:AddComponent(MailEffectTipItem, item.name)
      cell:SetData(self.meta.effectName[i], leftValue, rightValue, self.meta.gotoType[i], self.meta.gotoParam[i])
      lastCell = cell
    end
  end
  if lastCell then
    lastCell:HideLine()
  end
end

function UILWMailEffectTipView:RefreshPosition()
  local localPos = self.closeBtn.transform:InverseTransformPoint(self.position)
  local isUp = localPos.y > 0
  if isUp then
    self.bg:SetPivotXY(0.5, 1)
    self.upArrow:SetActive(true)
    self.downArrow:SetActive(false)
    self.bg:SetPosition(self.position + Vector3(0, -30, 0))
  else
    self.bg:SetPivotXY(0.5, 0)
    self.upArrow:SetActive(false)
    self.downArrow:SetActive(true)
    self.bg:SetPosition(self.position + Vector3(0, 30, 0))
  end
end

function UILWMailEffectTipView:CalScrollHeight()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemScrollContent.transform)
  local contentHeight = self.itemScrollContent.rectTransform.sizeDelta.y
  local height = math.min(contentHeight, SCROLL_MAX_HEIGHT)
  self.bg.rectTransform:Set_sizeDelta(self.bg.rectTransform.sizeDelta.x, height)
end

return UILWMailEffectTipView
