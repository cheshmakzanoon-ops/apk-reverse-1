local UIActEpidemicScorePointsTipRoot = BaseClass("UIActEpidemicScorePointsTipRoot", UIAsyncContainer)
local base = UIAsyncContainer
local BattlePointTipItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattlePointTipItem")

function UIActEpidemicScorePointsTipRoot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActEpidemicScorePointsTipRoot:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicScorePointsTipRoot:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUIActEpidemicScorePointsTipRoot = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUIActEpidemicScorePointsTipRoot:SetOnClick(function()
    self:OnBtnUIActEpidemicScorePointsTipRootClick()
  end)
  self.compTipBg = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compItem = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function UIActEpidemicScorePointsTipRoot:ComponentDestroy()
  self.viewSkin = nil
  self.btnUIActEpidemicScorePointsTipRoot = nil
  self.compTipBg = nil
  self.compArrow = nil
  self.compItem = nil
end

function UIActEpidemicScorePointsTipRoot:DataDefine()
  self.compItem.gameObject:GameObjectCreatePool()
  self.tipCb = BindCallback(self, self.OnTipCb)
  self.tipCells = {}
end

function UIActEpidemicScorePointsTipRoot:DataDestroy()
  self.compTipBg:RemoveComponents(BattlePointTipItem)
  self.compItem.gameObject:GameObjectRecycleAll()
  self.tipCb = nil
  self.tipCells = nil
end

function UIActEpidemicScorePointsTipRoot:OnAddListener()
  base.OnAddListener(self)
end

function UIActEpidemicScorePointsTipRoot:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActEpidemicScorePointsTipRoot:OnBtnUIActEpidemicScorePointsTipRootClick()
  if self.btnUIActEpidemicScorePointsTipRoot then
    self.btnUIActEpidemicScorePointsTipRoot:SetActive(false)
  end
end

function UIActEpidemicScorePointsTipRoot:OnTipCb(btn, list)
  if table.IsNullOrEmpty(list) then
    return
  end
  self.btnUIActEpidemicScorePointsTipRoot:SetActive(true)
  local l = #list
  local s = #self.tipCells
  local max = math.max(l, s)
  for i = 1, max do
    local item = self.tipCells[i]
    local info = list[i]
    if info then
      if item == nil then
        local obj = self.compItem.gameObject:GameObjectSpawn(self.compTipBg.transform)
        obj.name = "item" .. i
        item = self.compTipBg:AddComponent(BattlePointTipItem, obj.name)
        self.tipCells[i] = item
      end
      item:SetActive(true)
      item:ReInit(info)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compTipBg.rectTransform)
  local btnWorldPos = btn.transform.position
  btnWorldPos.y = btnWorldPos.y - 30
  local tipsBgWidth = 460
  local screenWidth = self.btnUIActEpidemicScorePointsTipRoot.rectTransform.rect.width
  local maxX = screenWidth * 0.5 - tipsBgWidth * 0.5 - 50
  local anchorPos = PosConverse.WorldToAnchoredPosition(btnWorldPos, self.btnUIActEpidemicScorePointsTipRoot.rectTransform)
  local arrowOffset = 0
  if maxX <= anchorPos.x then
    arrowOffset = anchorPos.x - maxX
    anchorPos.x = maxX
  end
  self.compTipBg:SetAnchoredPositionXY(anchorPos.x, anchorPos.y)
  self.compArrow:SetAnchoredPositionXY(arrowOffset, -2)
end

return UIActEpidemicScorePointsTipRoot
