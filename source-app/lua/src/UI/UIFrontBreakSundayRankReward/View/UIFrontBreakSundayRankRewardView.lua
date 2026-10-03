local UIFrontBreakSundayRankRewardItem = require("UI.UIFrontBreakSundayRankReward.Component.UIFrontBreakSundayRankRewardItem")
local UIFrontBreakSundayRankRewardView = BaseClass("UIFrontBreakSundayRankRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local rank_scroll_view_path = "mainObj/MiddleBg/rankScrollView"
local tab_partServer_off_path = "mainObj/tabs/tabPartOne/tabPartOne_off"
local txt_tab_partServer_off_path = "mainObj/tabs/tabPartOne/tabPartOne_off/txtTabPartOne_off"
local tab_partServer_on_path = "mainObj/tabs/tabPartOne/tabPartOne_on"
local txt_tab_partServer_on_path = "mainObj/tabs/tabPartOne/tabPartOne_on/txtTabPartOne_on"
local tab_partTop_off_path = "mainObj/tabs/tabPartTwo/tabPartTwo_off"
local txt_tab_partTop_off_path = "mainObj/tabs/tabPartTwo/tabPartTwo_off/txtTabPartTwo_off"
local tab_partTop_on_path = "mainObj/tabs/tabPartTwo/tabPartTwo_on"
local txt_tab_partTop_on_path = "mainObj/tabs/tabPartTwo/tabPartTwo_on/txtTabPartTwo_on"
local rankRewardTypes = {TopRank = 2, SerRank = 0}

function UIFrontBreakSundayRankRewardView:OnCreate()
  base.OnCreate(self)
  local defaultSelectRankType = self:GetUserData() or rankRewardTypes.SerRank
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText(302026)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tab_partServer_off = self:AddComponent(UIButton, tab_partServer_off_path)
  self.txt_tab_partServer_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_partServer_off_path)
  self.tab_partServer_on = self:AddComponent(UIImage, tab_partServer_on_path)
  self.txt_tab_partServer_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_partServer_on_path)
  self.tab_partTop_off = self:AddComponent(UIButton, tab_partTop_off_path)
  self.txt_tab_partTop_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_partTop_off_path)
  self.tab_partTop_on = self:AddComponent(UIImage, tab_partTop_on_path)
  self.txt_tab_partTop_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_partTop_on_path)
  local partServerTabKey = Localization:GetString("activity_breakthrough_tips_40")
  self.txt_tab_partServer_off:SetText(partServerTabKey)
  self.txt_tab_partServer_on:SetText(partServerTabKey)
  local partTopTabKey = Localization:GetString("activity_breakthrough_tips_41")
  self.txt_tab_partTop_off:SetText(partTopTabKey)
  self.txt_tab_partTop_on:SetText(partTopTabKey)
  self.tab_partServer_off:SetOnClick(function()
    self:SwitchTab(rankRewardTypes.SerRank)
  end)
  self.tab_partTop_off:SetOnClick(function()
    self:SwitchTab(rankRewardTypes.TopRank)
  end)
  self.tabsOn = {
    [rankRewardTypes.TopRank] = self.tab_partTop_on,
    [rankRewardTypes.SerRank] = self.tab_partServer_on
  }
  self.tabsOff = {
    [rankRewardTypes.TopRank] = self.tab_partTop_off,
    [rankRewardTypes.SerRank] = self.tab_partServer_off
  }
  self.showRewardDatasList = {}
  self.ScrollView = self:AddComponent(UIScrollView, rank_scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self:SwitchTab(defaultSelectRankType)
end

function UIFrontBreakSundayRankRewardView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIFrontBreakSundayRankRewardItem)
end

function UIFrontBreakSundayRankRewardView:RefreshList()
  self:ClearScroll()
  if #self.showRewardDatasList > 0 then
    self.ScrollView:SetTotalCount(#self.showRewardDatasList)
    self.ScrollView:RefillCells()
  else
  end
end

function UIFrontBreakSundayRankRewardView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIFrontBreakSundayRankRewardItem, itemObj)
  cellItem:SetData(self.showRewardDatasList[index])
end

function UIFrontBreakSundayRankRewardView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIFrontBreakSundayRankRewardItem)
end

function UIFrontBreakSundayRankRewardView:OnDestroy()
  self:ClearScroll()
  self.ScrollView = nil
  self.showRewardDatasList = nil
  self.panel = nil
  self.text_title = nil
  self.btn_close = nil
  self.toggle1 = nil
  self.tab1_text = nil
  self.tab12_text = nil
  self.toggle2 = nil
  self.tab2_text = nil
  self.tab22_text = nil
  self.txt_empty = nil
  self.rank_scroll_view = nil
  self.rankType = nil
  base.OnDestroy(self)
end

function UIFrontBreakSundayRankRewardView:SwitchTab(type)
  self.rankType = type
  for k, v in pairs(self.tabsOn) do
    v:SetActive(k == type)
  end
  for k, v in pairs(self.tabsOff) do
    v:SetActive(k ~= type)
  end
  SFSNetwork.SendMessage(MsgDefines.FrontBreakSundayGetRankRewardInfo, self.rankType)
end

function UIFrontBreakSundayRankRewardView:OnEnable()
  base.OnEnable(self)
end

function UIFrontBreakSundayRankRewardView:OnDisable()
  base.OnDisable(self)
end

function UIFrontBreakSundayRankRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FrontBreakSundayGetRankReward, self.UpdateRankRewardData)
end

function UIFrontBreakSundayRankRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.FrontBreakSundayGetRankReward, self.UpdateRankRewardData)
end

function UIFrontBreakSundayRankRewardView:UpdateRankRewardData(msg)
  if not msg then
    return
  end
  if msg.type ~= self.rankType then
    return
  end
  self.showRewardDatasList = msg.rewards or {}
  self:RefreshList()
end

return UIFrontBreakSundayRankRewardView
