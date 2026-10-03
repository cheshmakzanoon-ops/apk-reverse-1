local base = UIBaseView
local UIEpidemicBattleSkillPointView = BaseClass("UIEpidemicBattleSkillPointView", base)
local actMgr = DataCenter.ActEpidemicZoneManager
local BattlePopBase = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleBase.BattlePopBase")
local BattlePointFilterItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattlePointFilterItem")
local BattlePointGroup = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattlePointGroup")
local BattlePointTipItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattlePointTipItem")
local panel_path = "panel"
local battle_pop_base_path = "BattlePopBase"
local desc_text_path = "Root/DescText"
local tip_text_path = "Root/TipText"
local content_path = "Root/ScrollView/Content"
local group_path = "Root/Group"
local item_path = "Root/Item"
local arr_img_path = "Root/Filter/ArrImg"
local filter_text_path = "Root/Filter/FilterText"
local filter_btn_path = "Root/Filter/FilterBtn"
local filter_content_path = "Root/Filter/FilterContent"
local filter_cell_path = "Root/Filter/FilterCell"
local tip_root_path = "TipRoot"
local tip_bg_path = "TipRoot/TipBg"
local tip_arrow_path = "TipRoot/TipBg/arrow"
local tip_item_path = "TipRoot/Item"
local IMG_UP_PATH = "cfm_tongyong_anniu_xiao_1.png"
local IMG_DOWN_PATH = "cfm_tongyong_anniu_xiao_2.png"
local FILTER_KEYS = {
  "YiBianJinQu_role_name_1",
  "YiBianJinQu_role_name_2",
  "YiBianJinQu_role_name_3"
}

function UIEpidemicBattleSkillPointView:OnCreate()
  base.OnCreate(self)
  self.groupCells = {}
  self.filterCells = {}
  self.tipCells = {}
  self.prefabIndex = 0
  local closeCb = BindCallback(self.ctrl, self.ctrl.CloseSelf)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(closeCb)
  self.battle_pop_base = self:AddComponent(BattlePopBase, battle_pop_base_path)
  self.battle_pop_base:ReInit("YiBianJinQu_skill_charge_tips_1", closeCb)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.group = self.transform:Find(group_path).gameObject
  self.group:GameObjectCreatePool()
  self.item = self.transform:Find(item_path).gameObject
  self.item:GameObjectCreatePool()
  self.arr_img = self:AddComponent(UIImage, arr_img_path)
  self.filter_text = self:AddComponent(UITextMeshProUGUIEx, filter_text_path)
  self.filter_btn = self:AddComponent(UIButton, filter_btn_path)
  self.filter_btn:SetOnClick(function()
    self:OnBtnFilterClick()
  end)
  self.filter_content = self:AddComponent(UIBaseContainer, filter_content_path)
  self.filter_cell = self.transform:Find(filter_cell_path).gameObject
  self.filter_cell:GameObjectCreatePool()
  self.tip_root = self:AddComponent(UIButton, tip_root_path)
  self.tip_root:SetOnClick(function()
    self.tip_root:SetActive(false)
  end)
  self.tip_bg = self:AddComponent(UIBaseContainer, tip_bg_path)
  self.tip_arrow = self:AddComponent(UIImage, tip_arrow_path)
  self.tip_item = self.transform:Find(tip_item_path).gameObject
  self.tip_item:GameObjectCreatePool()
  self.tipCb = BindCallback(self, self.TipCb)
  self:ReInit()
end

function UIEpidemicBattleSkillPointView:OnDestroy()
  self.prefabIndex = 0
  self:ClearGroup()
  self:ClearFilter()
  self:ClearTip()
  self.panel = nil
  self.close_btn = nil
  self.title_text = nil
  self.desc_text = nil
  self.tip_text = nil
  self.content = nil
  self.item = nil
  self.arr_img = nil
  self.cur_text = nil
  self.filter_btn = nil
  self.filter_content = nil
  self.filter_cell = nil
  self.tip_root = nil
  self.tip_bg = nil
  self.tip_item = nil
  self.tipCb = nil
  base.OnDestroy(self)
end

function UIEpidemicBattleSkillPointView:OnBtnFilterClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.filterShow = not self.filterShow
  self:RefreshFilterSel()
end

function UIEpidemicBattleSkillPointView:ClearGroup()
  self.content:RemoveComponents(BattlePointGroup)
  self.group:GameObjectRecycleAll()
  self.item:GameObjectRecycleAll()
  self.groupCells = {}
end

function UIEpidemicBattleSkillPointView:ClearFilter()
  self.filter_content:RemoveComponents(BattlePointFilterItem)
  self.filter_cell:GameObjectRecycleAll()
  self.filterCells = {}
end

function UIEpidemicBattleSkillPointView:ClearTip()
  self.tip_bg:RemoveComponents(BattlePointFilterItem)
  self.tip_item:GameObjectRecycleAll()
  self.tipCells = {}
end

function UIEpidemicBattleSkillPointView:ReInit()
  self:ClearGroup()
  self:ClearFilter()
  self.myRole = actMgr:GetCurRole() + 1
  if actMgr:BCurSelfArbiter() then
    self.myRole = 1
  end
  self.filterIdx = 0
  self.filterShow = false
  self.filterCb = BindCallback(self, self.OnFilterItemClick)
  self:OnFilterItemClick(self.myRole)
end

function UIEpidemicBattleSkillPointView:OnFilterItemClick(idx)
  self.filterShow = false
  self:RefreshFilterSel(self.myRole)
  if idx == self.filterIdx then
    return
  end
  self.filterIdx = idx
  self.filter_text:SetLocalText(FILTER_KEYS[idx])
  self:RefreshTypes()
end

function UIEpidemicBattleSkillPointView:RefreshFilterSel()
  self.arr_img:LoadSpriteAuto(string.format(LoadPath.LWCommonPath, self.filterShow and IMG_UP_PATH or IMG_DOWN_PATH))
  self.filter_content:SetActive(self.filterShow)
  if not self.filterShow then
    return
  end
  for i = 1, 3 do
    local obj = self.filterCells[i]
    if obj == nil then
      local item = self.filter_cell:GameObjectSpawn(self.filter_content.transform)
      item.name = "item" .. i
      obj = self.filter_content:AddComponent(BattlePointFilterItem, item.name)
      obj:SetActive(true)
      obj:SetData(i, self.filterCb)
      table.insert(self.filterCells, obj)
    end
    obj:ReInit(self.filterIdx, FILTER_KEYS[i])
  end
end

function UIEpidemicBattleSkillPointView:RefreshTypes()
  local templates = actMgr:GetTemplateScoreTypes(self.filterIdx)
  self.templates = templates
  local l = #templates
  if l == 0 then
    self:ClearGroup()
  else
    for i = 1, l do
      local obj = self.group:GameObjectSpawn(self.content.transform)
      obj.name = "group" .. i
      local item = self.content:AddComponent(BattlePointGroup, obj.name)
      self.groupCells[i] = item
      item:SetActive(true)
      item:ReInit(templates[i], self.item, self.tipCb)
    end
  end
end

function UIEpidemicBattleSkillPointView:TipCb(btn, list)
  if table.IsNullOrEmpty(list) then
    return
  end
  self.tip_root:SetActive(true)
  local l = #list
  local s = #self.tipCells
  local max = math.max(l, s)
  for i = 1, max do
    local item = self.tipCells[i]
    local info = list[i]
    if info then
      if item == nil then
        local obj = self.tip_item:GameObjectSpawn(self.tip_bg.transform)
        obj.name = "item" .. i
        item = self.tip_bg:AddComponent(BattlePointTipItem, obj.name)
        self.tipCells[i] = item
      end
      item:SetActive(true)
      item:ReInit(info)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip_bg.rectTransform)
  local btnWorldPos = btn.transform.position
  btnWorldPos.y = btnWorldPos.y - 30
  local tipsBgWidth = 460
  local screenWidth = self.tip_root.rectTransform.rect.width
  local maxX = screenWidth * 0.5 - tipsBgWidth * 0.5 - 50
  local anchorPos = PosConverse.WorldToAnchoredPosition(btnWorldPos, self.tip_root.rectTransform)
  local arrowOffset = 0
  if maxX <= anchorPos.x then
    arrowOffset = anchorPos.x - maxX
    anchorPos.x = maxX
  end
  self.tip_bg:SetAnchoredPositionXY(anchorPos.x, anchorPos.y)
  self.tip_arrow:SetAnchoredPositionXY(arrowOffset, -2)
end

return UIEpidemicBattleSkillPointView
