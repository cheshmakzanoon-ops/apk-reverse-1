local UIDesertBattleOrderGroup = BaseClass("UIDesertBattleOrderGroup", UIBaseContainer)
local base = UIBaseContainer
local UIDesertBattleOrderItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.Component.UIDesertBattleOrderItem")

function UIDesertBattleOrderGroup:OnCreate()
  base.OnCreate(self)
  self.curIdx = 1
  self.cb = BindCallback(self, self.OnClickItem)
  self.deleteBtn = self:AddComponent(UIButton, "BtnDelete")
  self.deleteBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if BattleFieldUtil.isObserve then
      UIUtil.ShowTipsId("Desert_strom_commander_1035")
      return
    end
    local mgr = DataCenter.ActDragonManager
    if mgr:IsSelfCommander() then
      mgr:SendCommandOrderDel(self.curIdx, true)
    else
      UIUtil.ShowTipsId("Desert_strom_commander_1027")
    end
  end)
  self.text_tip = self:AddComponent(UIText, "TipText")
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "Content")
  self.theItem = self.transform:Find("Item").gameObject
  self.theItem:GameObjectCreatePool()
end

function UIDesertBattleOrderGroup:OnDestroy()
  self.curIdx = 1
  self.cb = nil
  self.content:RemoveComponents(UIDesertBattleOrderItem)
  self.theItem:GameObjectRecycleAll()
  self.items = {}
  base.OnDestroy(self)
end

function UIDesertBattleOrderGroup:OnClickItem(idx)
  local item = self.items[self.curIdx]
  if item then
    item:SetSelect(false)
  end
  self.curIdx = idx
  self:RefreshSelfTip()
end

function UIDesertBattleOrderGroup:RefreshSelfTip()
  local order = DataCenter.ActDragonManager:GetOrderByIndex(self.curIdx)
  local haveOrder = order ~= nil
  local bSelf = haveOrder and LuaEntry.Player:GetUid() == order.commander
  self.text_tip:SetActive(haveOrder and not bSelf)
  CS.UIGray.SetGray(self.deleteBtn.transform, not haveOrder, haveOrder)
end

function UIDesertBattleOrderGroup:UpdateData()
  for i = 1, 3 do
    local item = self.items[i]
    if item == nil then
      local goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = "Item" .. i
      item = self.content:AddComponent(UIDesertBattleOrderItem, goItem.name)
      item:SetActive(true)
      self.items[i] = item
    end
    item:ReInit(i, self.curIdx, self.cb)
  end
  self:RefreshSelfTip()
end

return UIDesertBattleOrderGroup
