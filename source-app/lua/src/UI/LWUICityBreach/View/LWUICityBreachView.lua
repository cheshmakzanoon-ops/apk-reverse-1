local LWUICityBreachView = BaseClass("LWUICityBreachView", UIBaseView)
local base = UIBaseView
local DesAssistanceCell = require("UI.LWUICityBreach.Component.DesAssistanceCell")

function LWUICityBreachView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWUICityBreachView:ComponentDefine()
  self.timeInfoText = self:AddComponent(UIText, "panel/BG/Bg/timeInfo")
  self.comfortText = self:AddComponent(UIText, "panel/BG/Bg/comfortText")
  self.rewardList = self:AddComponent(UIScrollView, "panel/BG/Bg/list/rewardList")
  self.receiveBtn = self:AddComponent(UIButton, "panel/BG/Bg/receive")
  self.allActtackCell = self:AddComponent(DesAssistanceCell, "panel/BG/Bg/allActtackCell")
  self.attackCell = self:AddComponent(DesAssistanceCell, "panel/BG/Bg/attackCell")
  self.winCell = self:AddComponent(DesAssistanceCell, "panel/BG/Bg/winCell")
  self.receiveBtnText = self:AddComponent(UIText, "panel/BG/Bg/receive/Go")
  self.assistanceCell = self:AddComponent(DesAssistanceCell, "panel/BG/Bg/assistanceCell")
  self.rewardList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.rewardList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.receiveBtn:SetOnClick(function()
    self.ctrl:CloseSelf(self.param.uuid)
  end)
  self.cells = {
    allActtack = self.allActtackCell,
    acttack = self.attackCell,
    win = self.winCell,
    assistance = self.assistanceCell
  }
  for i, v in pairs(self.cells) do
    v:SetActive(false)
  end
end

function LWUICityBreachView:CloseView()
end

function LWUICityBreachView:ComponentDestroy()
  self.panelCloseBtn = nil
  self.timeInfoText = nil
  self.comfortText = nil
  self.rewardList = nil
  self.timeInfoText = nil
  self.receiveBtn = nil
  self.cells = nil
end

function LWUICityBreachView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.rewardList:AddComponent(UICommonResItem, itemObj)
  item:ReInit(self.param.rewardList[index])
end

function LWUICityBreachView:OnDeleteCell(itemObj, index)
  self.rewardList:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWUICityBreachView:ClearScroll()
  self.rewardList:ClearCells()
  self.rewardList:RemoveComponents(UICommonResItem)
end

function LWUICityBreachView:ShowScroll()
  self:ClearScroll()
  local count = #self.param.rewardList
  self.rewardList:SetTotalCount(count)
  if 0 < count then
    self.rewardList:RefillCells()
  end
end

function LWUICityBreachView:ReInit()
  self.param = self:GetUserData()
  local count
  if self.param and self.param.defUsers then
    count = #self.param.defUsers
  end
  if count and 1 <= count then
    self.receiveBtnText:SetLocalText(800573)
  else
    self.receiveBtnText:SetLocalText(801339)
  end
  self.param = self.ctrl.GetViewInfo(self.param)
  if self.param.timeInfoText then
    self.timeInfoText:SetText(self.param.timeInfoText)
  end
  if self.param.comfortText then
    self.comfortText:SetActive(true)
    self.comfortText:SetText(self.param.comfortText)
  else
    self.param.comfortText:SetActive(false)
  end
  for i, v in pairs(self.param.acttackInfoList) do
    if self.cells[v.type] then
      self.cells[v.type]:SetActive(true)
      self.cells[v.type]:ReInit(v)
    end
  end
  if self.param.rewardList and #self.param.rewardList > 0 then
    self:ShowScroll()
  end
end

function LWUICityBreachView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICityBreachView:OnEnable()
  base.OnEnable(self)
end

function LWUICityBreachView:OnDisable()
  base.OnDisable(self)
end

function LWUICityBreachView:DataDefine()
  self.param = nil
end

function LWUICityBreachView:DataDestroy()
  self.param = nil
end

return LWUICityBreachView
