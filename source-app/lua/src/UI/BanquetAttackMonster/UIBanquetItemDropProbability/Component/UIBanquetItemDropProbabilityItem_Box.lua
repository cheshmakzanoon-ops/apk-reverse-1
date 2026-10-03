local base = UIBaseContainer
local UIBanquetItemDropProbabilityItem_Box = BaseClass("UIBanquetItemDropProbabilityItem_Box", base)
local M = UIBanquetItemDropProbabilityItem_Box
local UIBanquetItemDropProbabilityItem_Box_Info = require("UI.BanquetAttackMonster.UIBanquetItemDropProbability.Component.UIBanquetItemDropProbabilityItem_Box_Info")
local UIBanquetItemDropProbabilityItem_Box_Rate = require("UI.BanquetAttackMonster.UIBanquetItemDropProbability.Component.UIBanquetItemDropProbabilityItem_Box_Rate")
local arrow_open_img_path = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png"
local arrow_close_img_path = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png"
local monsterPartMinHeight = 150
local monsterDescMinHeight = 85
local descPartBlankHeight = 60

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.showObjList = {}
  self.isExpandArrow = true
  self.index = 0
  self.compBoxPart:SetActive(false)
  self.compBoxPart.gameObject:GameObjectCreatePool()
  self.compRewardRateShowItem:SetActive(false)
  self.compRewardRateShowItem.gameObject:GameObjectCreatePool()
end

function M:OnDestroy()
  self.isExpandArrow = true
  self.index = 0
  self:ClearAllItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.imgArrow = self:AddComponent(UIImage, "TopBar/arrowImg")
  self.btnArrowImg = self:AddComponent(UIButton, "TopBar/arrowImg")
  self.btnArrowImg:SetOnClick(function()
    self:ExpandArrowShow(not self.isExpandArrow, false)
  end)
  self.textPageName = self:AddComponent(UITextMeshProUGUIEx, "TopBar/PageName")
  self.compBoxPart = self:AddComponent(UIBaseContainer, "boxPart")
  self.compRewardRateShowItem = self:AddComponent(UIBaseContainer, "rewardRateShowItem")
end

function M:ComponentDestroy()
  self.imgArrow = nil
  self.btnArrowImg = nil
  self.textPageName = nil
  self.compBoxPart = nil
  self.compRewardRateShowItem = nil
end

function M:SetItemShow(scrollItemCfg, isExpand, index)
  self.scrollItemCfg = scrollItemCfg
  self.isExpandArrow = isExpand
  self.index = index
  local barRowCfg = self.scrollItemCfg[1]
  self.textPageName:SetLocalText(barRowCfg.type_name)
  self:SetRewardRateShow()
  self:ExpandArrowShow(self.isExpandArrow, true)
end

function M:GetRateShowMap()
  local map = {}
  for i, v in ipairs(self.scrollItemCfg) do
    if map[v.para1] == nil then
      map[v.para1] = {}
    end
    table.insert(map[v.para1], v)
  end
  return map
end

function M:SetRewardRateShow()
  local map = self:GetRateShowMap()
  self:ClearAllItem()
  self.showObjList = {}
  table.walksort(map, function(a, b)
    return a < b
  end, function(k, v)
    local boxItem = self.compBoxPart.gameObject:GameObjectSpawn(self.transform)
    boxItem.name = "compBoxPart" .. k
    local boxObj = self:AddComponent(UIBanquetItemDropProbabilityItem_Box_Info, boxItem.name)
    boxObj:SetActive(true)
    boxObj:SetData(v[1])
    boxObj:SetLocalScaleXYZ(1, 1, 1)
    table.insert(self.showObjList, boxObj)
    for i, itemData in ipairs(v) do
      local rateItem = self.compRewardRateShowItem.gameObject:GameObjectSpawn(self.transform)
      rateItem.name = "compRewardRateShowItem" .. k .. i
      local rateObj = self:AddComponent(UIBanquetItemDropProbabilityItem_Box_Rate, rateItem.name)
      rateObj:SetActive(true)
      rateObj:SetData(itemData)
      rateObj:SetLocalScaleXYZ(1, 1, 1)
      table.insert(self.showObjList, rateObj)
    end
  end)
end

function M:ExpandArrowShow(state, isSkipChangeItemSize)
  self.isExpandArrow = state
  self.view:SetExpandStateByType(self.scrollItemCfg[1].type, self.isExpandArrow)
  if self.isExpandArrow then
    self.imgArrow:LoadSprite(arrow_open_img_path)
  else
    self.imgArrow:LoadSprite(arrow_close_img_path)
  end
  for _, v in pairs(self.showObjList) do
    v:SetActive(self.isExpandArrow)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  if not isSkipChangeItemSize then
    self.view.ScrollLoopListView:OnItemSizeChanged(math.max(0, self.index - 1))
  end
end

function M:ClearAllItem()
  self:RemoveComponents(UIBanquetItemDropProbabilityItem_Box_Info)
  self:RemoveComponents(UIBanquetItemDropProbabilityItem_Box_Rate)
  self.compBoxPart.gameObject:GameObjectRecycleAll()
  self.compRewardRateShowItem.gameObject:GameObjectRecycleAll()
end

return UIBanquetItemDropProbabilityItem_Box
