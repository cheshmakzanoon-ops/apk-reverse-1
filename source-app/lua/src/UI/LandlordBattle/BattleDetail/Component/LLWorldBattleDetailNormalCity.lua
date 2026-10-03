local base = UIAsyncContainer
local LLWorldBattleDetailNormalCity = BaseClass("LLWorldBattleDetailNormalCity", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local CLS = "UI.LandlordBattle.BattleDetail.Component.LLDetailBigCity"
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldBattleDetailBuildingItem.prefab"

function LLWorldBattleDetailNormalCity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLWorldBattleDetailNormalCity:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLWorldBattleDetailNormalCity:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
end

function LLWorldBattleDetailNormalCity:ComponentDestroy()
  self.viewSkin = nil
end

function LLWorldBattleDetailNormalCity:DataDefine()
  self.items = {}
  self.checkCB = BindCallback(self, self.CheckFinish)
  self.rebuildLayoutTimer = nil
end

function LLWorldBattleDetailNormalCity:DataDestroy()
  if self.rebuildLayoutTimer then
    self.rebuildLayoutTimer:Stop()
    self.rebuildLayoutTimer = nil
  end
  self.view = nil
  self.tabIdx = nil
  self.items = nil
  self.list = nil
  self.subDic = nil
  self.checkCB = nil
end

function LLWorldBattleDetailNormalCity:OnAddListener()
  base.OnAddListener(self)
end

function LLWorldBattleDetailNormalCity:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLWorldBattleDetailNormalCity:SetInfo(view, tabIdx)
  self.view = view
  self.tabIdx = tabIdx
  self:RefreshView()
end

function LLWorldBattleDetailNormalCity:UpdateData()
  if self.tabIdx == nil or self.view == nil then
    return
  end
  local dic = ActMgr:GetDetailList(self.tabIdx)
  if dic == nil then
    self.view:SetEmpty(true)
    return
  end
  local list = dic ~= nil and dic.list or nil
  self.list = {}
  self.subDic = {}
  if not table.IsNullOrEmpty(list) then
    for _, v in ipairs(list) do
      local template = ActMgr:GetCityTemplate(v.cityId)
      if template ~= nil then
        local bCityId = template.belong_city_id
        if bCityId == 0 then
          local p = v:GetPercent()
          local maxP = v.progressMax or 0
          v.curP = maxP == 0 and 0 or p * 1.0 / maxP
          table.insert(self.list, v)
        else
          self.subDic[bCityId] = self.subDic[bCityId] or {}
          table.insert(self.subDic[bCityId], v)
        end
      end
    end
  end
  
  local function sortFunc(a, b)
    local aOver = a.state == LLConst.ZWLBuildingState.OVER
    local bOver = b.state == LLConst.ZWLBuildingState.OVER
    if aOver ~= bOver then
      return bOver
    end
    if a.curP ~= b.curP then
      return a.curP > b.curP
    end
    if a.ownerCampId ~= b.ownerCampId then
      return a.ownerCampId == LLConst.LandLordGroup.FARMER
    end
    return a.cityId < b.cityId
  end
  
  table.sort(self.list, sortFunc)
  local lP = #self.list
  self.view:SetEmpty(lP == 0, true)
  local cnt = math.max(lP, #self.items)
  for i = 1, cnt do
    local data = self.list[i]
    local item = self.items[i]
    if data ~= nil then
      if item == nil then
        item = self:LoadComponentAsync(CLS, PREFAB, self)
        item:SetName("Item_" .. i)
        self.items[i] = item
      end
      item:SetActive(true)
      item:SetData(self.tabIdx, data, self.subDic[data.cityId], self.checkCB)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

function LLWorldBattleDetailNormalCity:CheckFinish()
  if self.rebuildLayoutTimer then
    self.rebuildLayoutTimer:Stop()
    self.rebuildLayoutTimer = nil
  end
  self.rebuildLayoutTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.rebuildLayoutTimer = nil
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform.parent)
  end, 0.5)
end

return LLWorldBattleDetailNormalCity
