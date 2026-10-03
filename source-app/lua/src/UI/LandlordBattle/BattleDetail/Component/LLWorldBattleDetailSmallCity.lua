local base = UIAsyncContainer
local LLWorldBattleDetailSmallCity = BaseClass("LLWorldBattleDetailSmallCity", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local LLDetailSmallTop = require("UI.LandlordBattle.BattleDetail.Component.LLDetailSmallTop")
local LLDetailSmallGrid = require("UI.LandlordBattle.BattleDetail.Component.LLDetailSmallGrid")

function LLWorldBattleDetailSmallCity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLWorldBattleDetailSmallCity:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLWorldBattleDetailSmallCity:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compTopItem = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compGridItem = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
end

function LLWorldBattleDetailSmallCity:ComponentDestroy()
  self.viewSkin = nil
  self.compTopItem = nil
  self.compGridItem = nil
end

function LLWorldBattleDetailSmallCity:DataDefine()
  self.clickCb = BindCallback(self, self.ShowGrid)
  self.tops = {}
  self.grids = {}
  self.compTopItem:SetActive(false)
  self.topItem = self.compTopItem.gameObject
  self.topItem:GameObjectCreatePool()
  self.compGridItem:SetActive(false)
  self.gridItem = self.compGridItem.gameObject
  self.gridItem:GameObjectCreatePool()
  local k4 = LuaEntry.DataConfig:TryGetStr("zonewar_landlord", "k4")
  self.percents = string.string2array_i_oneSep(k4, ",")
  local last = self.percents[#self.percents]
  if last ~= nil and last ~= 0 then
    table.insert(self.percents, 1)
    table.insert(self.percents, 0)
  end
end

function LLWorldBattleDetailSmallCity:DataDestroy()
  self:RemoveComponents(LLDetailSmallTop)
  self:RemoveComponents(LLDetailSmallGrid)
  self.topItem:GameObjectRecycleAll()
  self.gridItem:GameObjectRecycleAll()
  self.tops = nil
  self.grids = nil
  self.clickCb = nil
  self.view = nil
  self.tabIdx = nil
end

function LLWorldBattleDetailSmallCity:OnAddListener()
  base.OnAddListener(self)
end

function LLWorldBattleDetailSmallCity:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLWorldBattleDetailSmallCity:SetInfo(view, tabIdx)
  self.view = view
  self.tabIdx = tabIdx
  self.waitReset = true
  self:RefreshView()
end

function LLWorldBattleDetailSmallCity:UpdateData()
  if self.tabIdx == nil or self.view == nil then
    return
  end
  local dic = ActMgr:GetDetailList(self.tabIdx)
  if dic == nil then
    self.view:SetEmpty(true)
    return
  end
  local list = dic.list or nil
  if table.IsNullOrEmpty(list) then
    self.view:SetEmpty(true, true)
    return
  end
  local tmpD = {}
  for _, v in ipairs(list) do
    local progress = v:GetPercent()
    local max = v.progressMax or 0
    local curP = max == 0 and 0 or progress * 100.0 / max
    v.curP = curP
    for i, p in ipairs(self.percents) do
      if curP < 100 and p < curP and p ~= 0 or curP == 0 and p == 1 or 100 <= curP and p == 0 then
        tmpD[i] = tmpD[i] or {}
        table.insert(tmpD[i], v)
        break
      end
    end
  end
  
  local function sortFunc(a, b)
    if a.curP ~= b.curP then
      return a.curP > b.curP
    end
    if a.ownerCampId ~= b.ownerCampId then
      return a.ownerCampId == LLConst.LandLordGroup.FARMER
    end
    return a.cityId < b.cityId
  end
  
  for _, _list in pairs(tmpD) do
    table.sort(_list, sortFunc)
  end
  local tmpL = table.keys(tmpD)
  table.sort(tmpL, function(a, b)
    return a < b
  end)
  local lP = #tmpL
  self.view:SetEmpty(lP == 0)
  local lTop = #self.tops
  local cnt = math.max(lP, lTop)
  for i = 1, cnt do
    local idx = tmpL[i]
    local top = self.tops[i]
    local grid = self.grids[i]
    if idx ~= nil then
      if top == nil then
        local obj = self.topItem:GameObjectSpawn(self.transform)
        obj.name = "Top_" .. i
        top = self:AddComponent(LLDetailSmallTop, obj.name)
        self.tops[i] = top
      end
      top:SetInfo(self.percents[idx], i, self.clickCb, self.waitReset)
      if grid == nil then
        local obj = self.gridItem:GameObjectSpawn(self.transform)
        obj.name = "Grid_" .. i
        grid = self:AddComponent(LLDetailSmallGrid, obj.name)
        self.grids[i] = grid
      end
      grid:SetList(tmpD[idx])
      if self.waitReset then
        grid:SetShow(i == 1)
      end
    elseif top ~= nil then
      top:SetActive(false)
      if grid ~= nil then
        grid:SetShow(false)
      end
    end
  end
  self.waitReset = false
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function LLWorldBattleDetailSmallCity:ShowGrid(index, bShow)
  local grid = self.grids[index]
  if grid ~= nil then
    grid:SetShow(bShow)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  end
end

return LLWorldBattleDetailSmallCity
