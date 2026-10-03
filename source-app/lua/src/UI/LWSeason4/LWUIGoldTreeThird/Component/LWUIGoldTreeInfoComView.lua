local Localization = CS.GameEntry.Localization
local LWUIGTInfoItemComView = require("UI.LWSeason4.LWUIGoldTreeThird.Component.LWUIGTInfoItemComView")
local LWUIGoldTreeInfoComView = BaseClass("LWUIGoldTreeInfoComView", UIBaseContainer)
local base = UIBaseContainer
local LWUIGoldTreeInfoComAuto = require("UI.LWSeason4.LWUIGoldTreeThird.Auto.LWUIGoldTreeInfoComAuto")

function LWUIGoldTreeInfoComView:OnCreate()
  base.OnCreate(self)
  self.binder = LWUIGoldTreeInfoComAuto.New()
  self.binder:bind(self)
  self.g_bottom.toggle_toggle:SetOnValueChanged(BindCallback(self, self.ClickHideName))
  self.btn_panel:SetOnClick(BindCallback(self, self.ClickMask))
  self.btn_closebtn:SetOnClick(BindCallback(self, self.ClickMask))
  self.g_top.btn_info:SetActive(false)
  self.g_center.sv_scrollview:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.g_center.sv_scrollview:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function LWUIGoldTreeInfoComView:OnDestroy()
  self.g_center.sv_scrollview:ClearCells()
  self.g_center.sv_scrollview:RemoveComponents(LWUIGTInfoItemComView)
  self.binder:unbind(self)
  self.binder = nil
  base.OnDestroy(self)
end

function LWUIGoldTreeInfoComView:OnAddListener()
  self:AddUIListener(EventId.GoldTreeTreeHideName, self.OnGoldTreeTreeHideName)
  self:AddUIListener(EventId.GoldTreeThirdError, self.OnGoldTreeThirdError)
  self:AddUIListener(EventId.GoldTreeThirdGetCardData, self.OnGoldTreeThirdGetCardData)
  base.OnAddListener(self)
end

function LWUIGoldTreeInfoComView:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldTreeTreeHideName, self.OnGoldTreeTreeHideName)
  self:RemoveUIListener(EventId.GoldTreeThirdError, self.OnGoldTreeThirdError)
  self:RemoveUIListener(EventId.GoldTreeThirdGetCardData, self.OnGoldTreeThirdGetCardData)
  base.OnRemoveListener(self)
end

function LWUIGoldTreeInfoComView:OnGoldTreeTreeHideName()
  self.req = false
  self:RefreshUI()
end

function LWUIGoldTreeInfoComView:OnGoldTreeThirdError()
  self.req = false
end

function LWUIGoldTreeInfoComView:OnGoldTreeThirdGetCardData()
  local lotteryPoolData = DataCenter.SeasonGoldTreeThirdManager:GetCurrentLotteryPoolData()
  self.data = lotteryPoolData
  self.poolData = self.data[self.index].list
  self:RefreshUI()
end

function LWUIGoldTreeInfoComView:SetData(data, index, history)
  self.index = index
  self.data = data
  self.poolData = self.data[index].list
  self.history = history
  self:RefreshUI()
end

function LWUIGoldTreeInfoComView:ClickMask()
  if self.view:GetName() == UIWindowNames.LWUIGoldTreeRecord then
    EventManager:GetInstance():Broadcast(EventId.LWUIGoldTreeRecordESC)
  else
    EventManager:GetInstance():Broadcast(EventId.LWUIGoldTreeThirdESC)
  end
end

function LWUIGoldTreeInfoComView:ClickHideName()
  if self.req then
    return
  end
  self.req = true
  local nameHide = DataCenter.SeasonGoldTreeThirdManager:GetNameHide()
  DataCenter.SeasonGoldTreeThirdManager:RequestGoldTreeHideName(not nameHide)
end

function LWUIGoldTreeInfoComView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.g_center.content:AddComponent(LWUIGTInfoItemComView, itemObj)
  cellItem:ReInit(self.poolData[index], self.history)
end

function LWUIGoldTreeInfoComView:OnDeleteCell(itemObj, index)
  self.g_center.content:RemoveComponent(itemObj.name, LWUIGTInfoItemComView)
end

function LWUIGoldTreeInfoComView:RefreshUI()
  local maxCount = 0
  for k, v in ipairs(self.poolData) do
    maxCount = maxCount + #v.stageArr
  end
  self.title_text:SetLocalText("season_golden_tree_phase_third_UI_33", self.index)
  self.g_top.txt_cardType:SetLocalText("season_golden_tree_phase_third_UI_23", self.index, maxCount)
  local config = DataCenter.SeasonGoldTreeThirdManager:GetGoldTreeThirdConfig()
  local value = config:GetPrizePool(self.data.poolCount, self.index) / 100.0
  self.g_top.txt_rewardCount:SetText(math.ceil(self.data.allReward * value))
  local nameHide = DataCenter.SeasonGoldTreeThirdManager:GetNameHide()
  local nameHideKey = nameHide and "season_golden_tree_phase_third_UI_13" or "season_golden_tree_phase_third_UI_14"
  self.g_bottom.txt_Toggle:SetLocalText(nameHideKey)
  self.g_bottom.toggle_toggle:SetIsOnWithoutNotify(nameHide)
  self.g_bottom.txt_Toggle:SetActive(not self.history)
  self.g_bottom.toggle_toggle:SetActive(not self.history)
  self.g_center.sv_scrollview:SetTotalCount(#self.poolData)
  self.g_center.sv_scrollview:RefillCells()
end

return LWUIGoldTreeInfoComView
