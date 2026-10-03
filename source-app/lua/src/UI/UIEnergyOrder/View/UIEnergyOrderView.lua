local UIEnergyOrder = BaseClass("UIEnergyOrder", UIBaseView)
local base = UIBaseView
local UIEnergyOrderItem = require("UI.UIEnergyOrder.Component.UIEnergyOrderItem")
local Localization = CS.GameEntry.Localization
local root_path = "Root"
local panel_path = "Root/Panel"
local normal_path = "Root/Normal"
local close_path = "Root/Normal/Close"
local title_path = "Root/Normal/Left/TitleBg/Title"
local desc_path = "Root/Normal/Left/Desc"
local count_path = "Root/Normal/Left/Count"
local scroll_view_path = "Root/Normal/ScrollView"
local buy_btn_path = "Root/Normal/Left/BuyBtn"
local buy_text_path = "Root/Normal/Left/BuyBtn/BuyText"
local submit_btn_path = "Root/Normal/Left/SubmitBtn"
local submit_text_path = "Root/Normal/Left/SubmitBtn/SubmitText"
local delete_path = "Root/Normal/Left/Delete"
local wait_path = "Root/Wait"
local close2_path = "Root/Wait/UICommonMiniPopUpTitle/CloseBtn"
local wait_time_path = "Root/Wait/WaitTime"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  local energySlider = UIUtil.GetUIMainEnergySlider()
  energySlider:SetRefreshDelay(2)
  base.OnEnable(self)
  self.active = true
  self:ReInit()
end

local function OnDisable(self)
  local energySlider = UIUtil.GetUIMainEnergySlider()
  energySlider:SetRefreshDelay(0)
  self.active = false
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.canvas_group = self:AddComponent(UICanvasGroup, root_path)
  self.panel_btn = self:AddComponent(UIButton, panel_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.normal_go = self:AddComponent(UIBaseContainer, normal_path)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close2_btn = self:AddComponent(UIButton, close2_path)
  self.close2_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UIText, title_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc_text:SetLocalText(134008)
  self.count_text = self:AddComponent(UIText, count_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn:SetOnClick(function()
    self:OnBuyClick()
  end)
  self.buy_text = self:AddComponent(UIText, buy_text_path)
  self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
  self.submit_btn:SetOnClick(function()
    self:OnSubmitClick()
  end)
  self.submit_text = self:AddComponent(UIText, submit_text_path)
  self.submit_text:SetLocalText(100427)
  self.delete_btn = self:AddComponent(UIButton, delete_path)
  self.delete_btn:SetOnClick(function()
    self:OnDeleteClick()
  end)
  self.wait_go = self:AddComponent(UIBaseContainer, wait_path)
  self.wait_time_text = self:AddComponent(UIText, wait_time_path)
end

local function ComponentDestroy(self)
  self.panel_btn = nil
  self.canvas_group = nil
  self.normal_go = nil
  self.close_btn = nil
  self.close2_btn = nil
  self.title_text = nil
  self.desc_text = nil
  self.count_text = nil
  self.scroll_view = nil
  self.buy_btn = nil
  self.buy_text = nil
  self.submit_btn = nil
  self.submit_text = nil
  self.delete_btn = nil
  self.wait_go = nil
  self.wait_time_text = nil
end

local function DataDefine(self)
  self.index = 0
  self.active = true
  self.data = nil
  self.needList = {}
  self.count = 0
  self.timer = nil
end

local function DataDestroy(self)
  self.index = nil
  self.active = nil
  self.data = nil
  self.needList = nil
  self.count = nil
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.EnergyOrderRefresh, self.OnEnergyOrderRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EnergyOrderRefresh, self.OnEnergyOrderRefresh)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIEnergyOrderItem, itemObj)
  item:SetData(self.needList[index])
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIEnergyOrderItem)
end

local function ShowScroll(self)
  self.scroll_view:SetTotalCount(#self.needList)
  if #self.needList > 0 then
    self.scroll_view:RefillCells()
  end
end

local function TimerAction(self)
  if self.index ~= nil then
    local restTime = math.max(DataCenter.EnergyOrderManager:GetOrderRestTime(self.index), 0)
    local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
    self.wait_time_text:SetText(Localization:GetString("134015") .. "\n" .. restTimeStr)
  end
end

local function ReInit(self)
  local bUuid = self:GetUserData()
  self.index = DataCenter.EnergyOrderManager:GetIndexByBuildUuid(bUuid)
  self:Refresh()
end

local function Refresh(self)
  local data = DataCenter.EnergyOrderManager:GetOrderData(self.index)
  if data == nil then
    return
  end
  self.data = data
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  if data.state == PurchaseOrderState.NORMAL then
    self.normal_go:SetActive(true)
    self.wait_go:SetActive(false)
    self.needList = DataCenter.EnergyOrderManager:GetOrderNeedList(self.data.orderId)
    self:ShowScroll()
    local rewards = self.data.rewardArr or self.data.reward
    for _, v in ipairs(rewards) do
      if v.type == RewardType.FORMATION_STAMINA or v.type == RewardType.PVE_STAMINA then
        self.count = v.value
        break
      end
    end
    self.count_text:SetText("+" .. self.count)
    local needDiamond = self:GetNeedDiamond()
    if 0 < needDiamond then
      self.buy_btn:SetActive(true)
      self.submit_btn:SetActive(false)
      self.buy_text:SetText(needDiamond)
    else
      self.buy_btn:SetActive(false)
      self.submit_btn:SetActive(true)
    end
  else
    self.normal_go:SetActive(false)
    self.wait_go:SetActive(true)
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
    self.timer:Start()
    self:TimerAction()
  end
end

local function GetNeedDiamond(self)
  local diamond = 0
  for _, need in ipairs(self.needList) do
    local _, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(need.itemId, need.count)
    diamond = diamond + diamondNum
  end
  return diamond
end

local function FlyReward(self)
  local icon = DataCenter.RewardManager:GetPicByType(RewardType.PVE_STAMINA)
  local num = Mathf.Clamp(self.count, 1, 20)
  local pos = UIUtil.GetEnergyIconPos(true)
  UIUtil.DoFlyCustom(icon, nil, num, self.submit_btn.transform.position, pos)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Hero_Skill, false)
  self.ctrl:CloseSelf()
end

local function OnBuyClick(self)
  local needDiamond = self:GetNeedDiamond()
  if needDiamond <= LuaEntry.Player.gold then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.EnergyOrderManager:SendFinish(self.data.uuid)
      self:FlyReward()
    end)
  else
    GoToUtil.GotoPayTips(needDiamond)
  end
end

local function OnSubmitClick(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_trigger_finish, false)
  DataCenter.EnergyOrderManager:SendFinish(self.data.uuid)
  self:FlyReward()
end

local function OnDeleteClick(self)
  UIUtil.ShowMessage(Localization:GetString("134014"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    DataCenter.EnergyOrderManager:SendDelete(self.data.uuid)
    self.ctrl:CloseSelf()
  end)
end

local function OnEnergyOrderRefresh(self)
  self:Refresh()
end

UIEnergyOrder.OnCreate = OnCreate
UIEnergyOrder.OnDestroy = OnDestroy
UIEnergyOrder.OnEnable = OnEnable
UIEnergyOrder.OnDisable = OnDisable
UIEnergyOrder.ComponentDefine = ComponentDefine
UIEnergyOrder.ComponentDestroy = ComponentDestroy
UIEnergyOrder.DataDefine = DataDefine
UIEnergyOrder.DataDestroy = DataDestroy
UIEnergyOrder.OnAddListener = OnAddListener
UIEnergyOrder.OnRemoveListener = OnRemoveListener
UIEnergyOrder.OnCreateCell = OnCreateCell
UIEnergyOrder.OnDeleteCell = OnDeleteCell
UIEnergyOrder.ShowScroll = ShowScroll
UIEnergyOrder.TimerAction = TimerAction
UIEnergyOrder.ReInit = ReInit
UIEnergyOrder.Refresh = Refresh
UIEnergyOrder.GetNeedDiamond = GetNeedDiamond
UIEnergyOrder.FlyReward = FlyReward
UIEnergyOrder.OnBuyClick = OnBuyClick
UIEnergyOrder.OnSubmitClick = OnSubmitClick
UIEnergyOrder.OnDeleteClick = OnDeleteClick
UIEnergyOrder.OnEnergyOrderRefresh = OnEnergyOrderRefresh
return UIEnergyOrder
