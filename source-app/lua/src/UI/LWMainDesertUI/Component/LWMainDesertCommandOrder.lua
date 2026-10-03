local LWMainDesertCommandOrder = BaseClass("LWMainDesertCommandOrder", UIAsyncContainer)
local base = UIAsyncContainer
local LWMainDesertCommandOrderItem = require("UI.LWMainDesertUI.Component.LWMainDesertCommandOrderItem")
local black_path = "black"
local bg_path = "bg"
local btn_set_path = "bg/SetBtn"
local text_empty_path = "bg/EmptyText"
local item_base_path = "bg/Layout/Item"
local tip_box_path = "TipBox"
local text_tip_box_path = "TipBox/DescText"

function LWMainDesertCommandOrder:OnCreate()
  base.OnCreate(self)
  self.baseActive = false
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self.black:SetActive(false)
    self:ShowCommandOrder()
  end)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.btn_set = self:AddComponent(UIButton, btn_set_path)
  self.btn_set:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleCommander)
  end)
  self.text_empty = self:AddComponent(UIBaseComponent, text_empty_path)
  self.items = {}
  for i = 1, 3 do
    local item = self:AddComponent(LWMainDesertCommandOrderItem, item_base_path .. i)
    item:ReInit(i, self)
    self.items[i] = item
  end
  self.tip_box = self:AddComponent(UIBaseComponent, tip_box_path)
  self.text_tip_box = self:AddComponent(UIText, text_tip_box_path)
end

function LWMainDesertCommandOrder:OnDestroy()
  self:CleanTipBox()
  self.lastNewOrderTime = nil
  base.OnDestroy(self)
end

function LWMainDesertCommandOrder:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonCommandOrderShow, self.ShowCommandOrder)
  self:AddUIListener(EventId.DragonCommandOrderUpdate, self.Refresh)
  self:AddUIListener(EventId.GetDagonPlayerList, self.Refresh)
end

function LWMainDesertCommandOrder:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonCommandOrderShow, self.ShowCommandOrder)
  self:RemoveUIListener(EventId.DragonCommandOrderUpdate, self.Refresh)
  self:RemoveUIListener(EventId.GetDagonPlayerList, self.Refresh)
  base.OnRemoveListener(self)
end

function LWMainDesertCommandOrder:ReInit()
  self.black:SetActive(false)
  self.bg:SetActive(false)
  self:CleanTipBox()
  self:CheckCommandOrderTip()
end

function LWMainDesertCommandOrder:Refresh()
  if self.bg:GetActive() then
    self:ShowCommandOrder()
  end
  self:CheckCommandOrderTip()
end

function LWMainDesertCommandOrder:OnShowChange()
  local active = not self.bg:GetActive()
  self.black:SetActive(false)
  self.bg:SetActive(active)
  local mgr = DataCenter.ActDragonManager
  if active then
    self:ShowCommandOrder()
  else
    for i = 1, 3 do
      local order = mgr:GetOrderByIndex(i)
      if order then
        order.bNew = false
      end
    end
    self:CheckCommandOrderTip()
  end
end

function LWMainDesertCommandOrder:ShowCommandOrder(info)
  local mgr = DataCenter.ActDragonManager
  self:CleanTipBox()
  self.bg:SetActive(true)
  self.black:SetActive(info ~= nil)
  local empty = true
  for i, item in ipairs(self.items) do
    local order = mgr:GetOrderByIndex(i)
    if order ~= nil then
      item:SetOrderShow(order, info)
      empty = false
    else
      item:HideOrder()
    end
    self.text_empty:SetActive(empty)
  end
end

function LWMainDesertCommandOrder:CleanTipBox()
  if self.animTimer then
    self.animTimer:Stop()
  end
  self.animTimer = nil
  if self.tip_timer then
    self.time_timer:Stop()
    self.time_timer = nil
  end
  self.anim:Enable(false)
  self.tip_box:SetActive(false)
end

function LWMainDesertCommandOrder:PlayTipAnim(name, cb)
  if self.animTimer then
    self.animTimer:Stop()
  end
  self.animTimer = nil
  self.tip_box:SetActive(true)
  self.anim:Enable(true)
  local ret, time = self.anim:PlayAnimationReturnTime(name)
  if ret then
    self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.animTimer then
        self.animTimer:Stop()
      end
      self.animTimer = nil
      self.anim:Enable(false)
      if cb then
        cb()
      end
    end, time)
  end
end

function LWMainDesertCommandOrder:CheckCommandOrderTip()
  self:CleanTipBox()
  local mgr = DataCenter.ActDragonManager
  if self.bg:GetActive() or BattleFieldUtil.isObserve then
    return
  end
  local empty = true
  local flag = false
  local myUid = LuaEntry.Player:GetUid()
  for i = 1, 3 do
    local order = mgr:GetOrderByIndex(i)
    if order ~= nil then
      empty = false
      if not order.hadJoin and order.commander ~= myUid then
        flag = true
      end
    end
  end
  if flag then
    if self.lastNewOrderTime == nil or self.lastNewOrderTime < mgr:GetLastNewOrderTime() then
      self.lastNewOrderTime = mgr:GetLastNewOrderTime()
    else
      flag = false
    end
  end
  if flag then
    self.text_tip_box:SetLocalText("Desert_strom_commander_1003")
    self:PlayTipAnim("BattleMainOrdersTipBoxIn", function()
      self.time_timer = TimerManager:GetInstance():DelayInvoke(function()
        self:PlayTipAnim("BattleMainOrdersTipBoxOut", function()
          self:CleanTipBox()
        end)
      end, 5)
    end)
  elseif empty and mgr:IsSelfCommander() then
    self.text_tip_box:SetLocalText("Desert_strom_commander_1034")
    self:PlayTipAnim("BattleMainOrdersTipBoxIn", function()
      self.time_timer = TimerManager:GetInstance():DelayInvoke(function()
        self:PlayTipAnim("BattleMainOrdersTipBoxOut", function()
          self:CleanTipBox()
        end)
      end, 5)
    end)
  end
end

function LWMainDesertCommandOrder:TryExec(idx)
  local mgr = DataCenter.ActDragonManager
  local order = mgr:GetOrderByIndex(idx)
  if order == nil then
    return
  end
  if not BattleFieldUtil.isObserve then
    if not order.hadJoin and order.commander ~= LuaEntry.Player:GetUid() then
      DataCenter.ActDragonManager:SendCommandOrderExec(idx)
    end
    order.hadJoin = true
    order.bNew = false
  end
  self:GoToPoint(order.point)
  self:ShowCommandOrder()
end

function LWMainDesertCommandOrder:GoToPoint(point)
  if not point then
    return
  end
  local v2 = SceneUtils.IndexToTilePos(point)
  local willPos = SceneUtils.TileToWorld(v2, ForceChangeScene.World)
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoDragonPos(willPos, CS.SceneManager.World.InitZoom, 0.02, function()
    UIUtil.ShowTipsId("Desert_strom_commander_1036")
  end, LuaEntry.Player:GetCurServerId(), LuaEntry.Player:GetCurWorldId(), LuaEntry.Player:GetCurWorldType())
end

return LWMainDesertCommandOrder
