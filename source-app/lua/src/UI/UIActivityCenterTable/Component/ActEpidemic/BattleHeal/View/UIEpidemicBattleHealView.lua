local UIEpidemicBattleHealView = BaseClass("UIEpidemicBattleHealView", UIBaseView)
local base = UIBaseView
local Resource = CS.GameEntry.Resource
local BattlePopBase = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleBase.BattlePopBase")
local panel_path = "panel"
local battle_pop_base_path = "BattlePopBase"
local toggle_base_path = "Root/TogView/Content/Toggle"
local center_path = "Root/Center"
local PrefabBase = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/%s.prefab"
local contents_info = {
  {
    key = "super",
    class = "UI.UIActivityCenterTable.Component.ActEpidemic.BattleHeal.Component.UIEBH_Super",
    prefab = "BattleHealSuper"
  },
  {
    key = "basic",
    class = "UI.UIActivityCenterTable.Component.ActEpidemic.BattleHeal.Component.UIEBH_Basic",
    prefab = "BattleHealBasic"
  },
  {
    key = "safe",
    class = "UI.UIActivityCenterTable.Component.ActEpidemic.BattleHeal.Component.UIEBH_Safe",
    prefab = "BattleHealSafe"
  }
}

function UIEpidemicBattleHealView:OnCreate()
  base.OnCreate(self)
  self.curIdx = 0
  self.contents = {}
  self.toggles = {}
  self.requests = {}
  local targetIdx = self:GetUserData() or 1
  local closeCb = BindCallback(self.ctrl, self.ctrl.CloseSelf)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(closeCb)
  self.battle_pop_base = self:AddComponent(BattlePopBase, battle_pop_base_path)
  self.battle_pop_base:ReInit(135120, closeCb)
  for i = 1, 3 do
    local tBasePath = toggle_base_path .. i
    local tb = {}
    local toggle = self:AddComponent(UIToggle, tBasePath)
    if i == targetIdx then
      toggle:SetIsOn(true)
    end
    toggle:SetOnValueChanged(function(tf)
      if tf then
        self:SetOnValueChanged(i)
      end
    end)
    tb.toggle = toggle
    local red = toggle:AddComponent(UIBaseComponent, "Red" .. i)
    red:SetActive(false)
    tb.red = red
    self.toggles[i] = tb
  end
  self.center = self:AddComponent(UIBaseContainer, center_path)
  self:SetOnValueChanged(targetIdx)
  self:UpdateRed()
end

function UIEpidemicBattleHealView:OnDestroy()
  for _, v in pairs(self.requests) do
    v:Destroy()
    v = nil
  end
  self.panel = nil
  self.close_btn = nil
  self.title_text = nil
  self.center = nil
  self.curContent = nil
  self.curIdx = 0
  self.contents = {}
  self.toggles = {}
  self.requests = {}
  base.OnDestroy(self)
end

function UIEpidemicBattleHealView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattleCureUpdate, self.UpdateRed)
  self:AddUIListener(EventId.InstantCureFinish, self.UpdateRed)
  self:AddUIListener(EventId.HospitalUpdate, self.UpdateRed)
end

function UIEpidemicBattleHealView:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicBattleCureUpdate, self.UpdateRed)
  self:RemoveUIListener(EventId.InstantCureFinish, self.UpdateRed)
  self:RemoveUIListener(EventId.HospitalUpdate, self.UpdateRed)
  base.OnRemoveListener(self)
end

function UIEpidemicBattleHealView:SetOnValueChanged(idx)
  if self.curIdx == idx then
    return
  end
  if self.curContent ~= nil then
    self.curContent:SetActive(false)
  end
  local info = contents_info[idx]
  local key = info.key
  self.curContent = self.contents[key]
  self.curIdx = idx
  if self.curContent ~= nil then
    self.curContent:SetActive(true)
    self:UpdateData()
    return
  end
  if self.requests[key] ~= nil then
    return
  end
  local request = Resource:InstantiateAsync(string.format(PrefabBase, info.prefab))
  self.requests[key] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      return
    end
    CommonUtil.CallAutoArabicMirrorManually(req)
    _go.name = key
    local pTF = _go.transform
    pTF:SetParent(self.center.transform)
    pTF:Set_localScale(1, 1, 1)
    pTF:Set_localPosition(0, 0, 0)
    local classScript = require(info.class)
    local newContent = self.center:AddComponent(classScript, key)
    self.contents[key] = newContent
    _go:SetActive(self.curIdx == idx)
    if self.curIdx == idx then
      self.curContent = newContent
      newContent:SetActive(true)
      self:UpdateData()
    end
  end)
end

function UIEpidemicBattleHealView:UpdateData()
  if self.curContent ~= nil then
    self.curContent:UpdateData()
    self.preValue = nil
  else
    self.toggles[1].toggle:SetIsOn(true)
    self:SetOnValueChanged(1)
  end
end

function UIEpidemicBattleHealView:UpdateRed()
  local red = self.toggles[1].red
  red:SetActive(DataCenter.ActEpidemicZoneManager:CheckCureRed())
  red = self.toggles[2].red
  local showHospitalEffect, _ = BattleFieldUtil.CheckHospitalEffState()
  red:SetActive(showHospitalEffect)
end

return UIEpidemicBattleHealView
