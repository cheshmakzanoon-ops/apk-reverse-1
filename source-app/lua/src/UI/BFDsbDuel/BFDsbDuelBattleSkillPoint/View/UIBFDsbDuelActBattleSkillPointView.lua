local base = UIBaseView
local UIBFDsbDuelActBattleSkillPointView = BaseClass("UIBFDsbDuelActBattleSkillPointView", base)
local BattlePopBase = require("UI.BFDsbDuel.BFDsbDuelBattleSkillPoint.Component.BattlePopBase")
local BattlePointTipItem = require("UI.BFDsbDuel.BFDsbDuelBattleSkillPoint.Component.BattlePointTipItem")
local BattlePointItem = require("UI.BFDsbDuel.BFDsbDuelBattleSkillPoint.Component.BattlePointItem")
local panel_path = "panel"
local battle_pop_base_path = "BattlePopBase"
local desc_text_path = "Root/DescText"
local tip_text_path = "Root/TipText"
local content_path = "Root/ScrollView/Content"
local item_path = "Root/Item"
local tip_root_path = "TipRoot"
local tip_bg_path = "TipRoot/TipBg"
local tip_arrow_path = "TipRoot/TipBg/arrow"
local tip_item_path = "TipRoot/Item"

function UIBFDsbDuelActBattleSkillPointView:OnCreate()
  base.OnCreate(self)
  self.itemCells = {}
  self.tipCells = {}
  self.prefabIndex = 0
  local closeCb = BindCallback(self.ctrl, self.ctrl.CloseSelf)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(closeCb)
  self.battle_pop_base = self:AddComponent(BattlePopBase, battle_pop_base_path)
  self.battle_pop_base:ReInit("dsb_duel_interface_1064", closeCb)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item = self.transform:Find(item_path).gameObject
  self.item:GameObjectCreatePool()
  self.tip_root = self:AddComponent(UIButton, tip_root_path)
  self.tip_root:SetOnClick(function()
    self.tip_root:SetActive(false)
  end)
  self.tip_bg = self:AddComponent(UIBaseContainer, tip_bg_path)
  self.tip_arrow = self:AddComponent(UIImage, tip_arrow_path)
  self.tip_item = self.transform:Find(tip_item_path).gameObject
  self.tip_item:GameObjectCreatePool()
  self.tipCb = BindCallback(self, self.TipCb)
  self.desc_text:SetLocalText("dsb_duel_interface_1065")
  self:ReInit()
end

function UIBFDsbDuelActBattleSkillPointView:OnDestroy()
  self.prefabIndex = 0
  self:ClearItem()
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
  self.tip_root = nil
  self.tip_bg = nil
  self.tip_item = nil
  self.tipCb = nil
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattleSkillPointView:ClearItem()
  self.content:RemoveComponents(BattlePointItem)
  self.item:GameObjectRecycleAll()
  self.itemCells = {}
end

function UIBFDsbDuelActBattleSkillPointView:ClearTip()
  self.tip_bg:RemoveComponents(BattlePointTipItem)
  self.tip_item:GameObjectRecycleAll()
  self.tipCells = {}
end

function UIBFDsbDuelActBattleSkillPointView:ReInit()
  self:ClearItem()
  self:RefreshTypes()
end

function UIBFDsbDuelActBattleSkillPointView:RefreshTypes()
  local templates = BattlefieldDsbDuelUtils.ActInfo:GetTemplateScoreTypes() or {}
  self.templates = templates
  local l = #templates
  if l == 0 then
    self:ClearItem()
  else
    local idx = 1
    for i = 1, l do
      local template = templates[i]
      for k, v in ipairs(template.showIds) do
        local obj = self.item:GameObjectSpawn(self.content.transform)
        obj.name = "item" .. v
        local item = self.content:AddComponent(BattlePointItem, obj.name)
        self.itemCells[idx] = item
        idx = idx + 1
        item:SetActive(true)
        item:ReInit(v, template.icon, self.tipCb)
      end
    end
  end
end

function UIBFDsbDuelActBattleSkillPointView:TipCb(btn, list)
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

return UIBFDsbDuelActBattleSkillPointView
