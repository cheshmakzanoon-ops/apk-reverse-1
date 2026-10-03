local LLScorePointsTipRoot = BaseClass("LLScorePointsTipRoot", UIAsyncContainer)
local base = UIAsyncContainer
local LLScorePointsTipItem = require("UI.LandlordBattle.NineBoxes.Component.LLScorePointsTipItem")

function LLScorePointsTipRoot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLScorePointsTipRoot:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLScorePointsTipRoot:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLLScorePointsTipRoot = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLLScorePointsTipRoot:SetOnClick(function()
    self:OnBtnLLScorePointsTipRootClick()
  end)
  self.compTipBg = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compItem = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function LLScorePointsTipRoot:ComponentDestroy()
  self.viewSkin = nil
  self.btnLLScorePointsTipRoot = nil
  self.compTipBg = nil
  self.compArrow = nil
  self.compItem = nil
end

function LLScorePointsTipRoot:DataDefine()
  self.compItem.gameObject:GameObjectCreatePool()
  self.tipCb = BindCallback(self, self.OnTipCb)
  self.tipCells = {}
end

function LLScorePointsTipRoot:DataDestroy()
  self.compTipBg:RemoveComponents(LLScorePointsTipItem)
  self.compItem.gameObject:GameObjectRecycleAll()
  self.tipCb = nil
  self.tipCells = nil
  self.btn = nil
  self.list = nil
end

function LLScorePointsTipRoot:OnAddListener()
  base.OnAddListener(self)
end

function LLScorePointsTipRoot:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLScorePointsTipRoot:OnBtnLLScorePointsTipRootClick()
  if self.btnLLScorePointsTipRoot then
    self.btnLLScorePointsTipRoot:SetActive(false)
  end
end

function LLScorePointsTipRoot:OnTipCb(btn, list)
  self.list = list
  self.targetBtn = btn
  self:RefreshView()
end

function LLScorePointsTipRoot:UpdateData()
  if table.IsNullOrEmpty(self.list) then
    return
  end
  self.btnLLScorePointsTipRoot:SetActive(true)
  local l = #self.list
  local s = #self.tipCells
  local max = math.max(l, s)
  for i = 1, max do
    local item = self.tipCells[i]
    local xmlId = self.list[i]
    if xmlId then
      if item == nil then
        local obj = self.compItem.gameObject:GameObjectSpawn(self.compTipBg.transform)
        obj.name = "item" .. i
        item = self.compTipBg:AddComponent(LLScorePointsTipItem, obj.name)
        self.tipCells[i] = item
      end
      item:SetActive(true)
      item:ReInit(xmlId)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compTipBg.rectTransform)
  local btnWorldPos = self.targetBtn.transform.position
  btnWorldPos.y = btnWorldPos.y + 20
  local tipsBgWidth = 460
  local screenWidth = self.btnLLScorePointsTipRoot.rectTransform.rect.width
  local maxX = (screenWidth - tipsBgWidth) * 0.5 - 50
  local minX = -maxX
  local anchorPos = PosConverse.WorldToAnchoredPosition(btnWorldPos, self.btnLLScorePointsTipRoot.rectTransform)
  local arrowOffset = 0
  if maxX <= anchorPos.x then
    arrowOffset = anchorPos.x - maxX
    anchorPos.x = maxX
  elseif minX >= anchorPos.x then
    arrowOffset = anchorPos.x - minX
    anchorPos.x = minX
  end
  self.compTipBg:SetAnchoredPositionXY(anchorPos.x, anchorPos.y, true)
  local aY = self.compArrow:GetAnchoredPositionY()
  self.compArrow:SetAnchoredPositionXY(arrowOffset, aY, true)
end

return LLScorePointsTipRoot
