local base = UIBaseView
local UIEpidemicBattleSkillView = BaseClass("UIEpidemicBattleSkillView", base)
local Resource = CS.GameEntry.Resource
local BattlePopBase = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleBase.BattlePopBase")
local panel_path = "panel"
local battle_pop_base_path = "BattlePopBase"
local toggle_base_path = "Root/TogView/Content/Toggle"
local center_path = "Root/Center"
local PrefabBase = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/%s.prefab"
local contents_info = {
  {
    key = "cure",
    class = "UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattleSkillCur",
    prefab = "BattleSkillCur"
  },
  {
    key = "list",
    class = "UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattleSkillList",
    prefab = "BattleSkillList"
  }
}

function UIEpidemicBattleSkillView:OnCreate()
  base.OnCreate(self)
  self.curIdx = 0
  self.contents = {}
  self.toggles = {}
  self.requests = {}
  local closeCb = BindCallback(self.ctrl, self.ctrl.CloseSelf)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(closeCb)
  self.battle_pop_base = self:AddComponent(BattlePopBase, battle_pop_base_path)
  self.battle_pop_base:ReInit("YiBianJinQu_skill_detail_tips_1", closeCb)
  for i = 1, 2 do
    local tBasePath = toggle_base_path .. i
    local toggle = self:AddComponent(UIToggle, tBasePath)
    if i == 1 then
      toggle:SetIsOn(true)
    end
    toggle:SetOnValueChanged(function(tf)
      if tf then
        self:SetOnValueChanged(i)
      end
    end)
    self.toggles[i] = toggle
  end
  self.center = self:AddComponent(UIBaseContainer, center_path)
  self:SetOnValueChanged(1)
end

function UIEpidemicBattleSkillView:OnDestroy()
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

function UIEpidemicBattleSkillView:SetOnValueChanged(idx)
  if idx == 2 then
    local bFightGod = DataCenter.ActEpidemicZoneManager:BCurSelfArbiter()
    if bFightGod then
      UIUtil.ShowTipsId("YiBianJinQu_skill_detail_tips_3")
      self.toggles[1]:SetIsOn(true)
      self:SetOnValueChanged(1)
      return
    end
  end
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

function UIEpidemicBattleSkillView:UpdateData()
  if self.curContent ~= nil then
    self.curContent:UpdateData()
    self.preValue = nil
  else
    self.toggles[1]:SetIsOn(true)
    self:SetOnValueChanged(1)
  end
end

return UIEpidemicBattleSkillView
