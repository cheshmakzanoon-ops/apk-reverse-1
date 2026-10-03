local UIJungleTrialRankView = BaseClass("UIJungleTrialRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonRankItem = require("UI.UICommonRank.UICommonRankItem")

function UIJungleTrialRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIJungleTrialRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIJungleTrialRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textToday = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.scrollViewScrollView = self.viewSkin:AddComponent(self, UIScrollView, 4)
  self.textRankDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textPowerDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textNameDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compSelfRank = self.viewSkin:AddComponent(self, UICommonRankItem, 8)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textButton = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textEmptyTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.scrollViewScrollView:SetFixedItemSize(750, 135)
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.textTitle:SetLocalText("season6_piranha_activity_name")
  self.textRankDes:SetLocalText("302043")
  self.textPowerDes:SetLocalText("season6_piranha_activity_TrialValue")
  self.textNameDes:SetLocalText("100184")
end

function UIJungleTrialRankView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textToday = nil
  self.scrollViewScrollView = nil
  self.textRankDes = nil
  self.textPowerDes = nil
  self.textNameDes = nil
  self.compSelfRank = nil
  self.btnBack = nil
  self.btnReward = nil
  self.textButton = nil
  self.textEmptyTxt = nil
end

function UIJungleTrialRankView:DataDefine()
  DataCenter.JungleTrialDataManager:FetchRankData()
end

function UIJungleTrialRankView:DataDestroy()
end

function UIJungleTrialRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.JungleTrialRankRefresh, self.Refresh)
  self:AddUIListener(EventId.JungleTrialRankRewardRefresh, self.OpenRewardWindow)
end

function UIJungleTrialRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.JungleTrialRankRefresh, self.Refresh)
  self:RemoveUIListener(EventId.JungleTrialRankRewardRefresh, self.OpenRewardWindow)
  base.OnRemoveListener(self)
end

function UIJungleTrialRankView:Refresh()
  self:ClearScroll()
  self.ranksData, self.myRankData = DataCenter.JungleTrialDataManager:GetRankData()
  if #self.ranksData > 0 then
    self.scrollViewScrollView:SetTotalCount(#self.ranksData)
    self.scrollViewScrollView:RefillCells()
    self.textEmptyTxt:SetActive(false)
  else
    self.textEmptyTxt:SetActive(true)
  end
  self.compSelfRank:SetItemShow(self.myRankData, true, CommonRankType.PERSONAL)
  self.textToday:SetLocalText("season6_piranha_activity_kill_count", DataCenter.JungleTrialDataManager:GetTodayKill())
  local data = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.JungleTrial.Type)
  self.textDesc:SetLocalText("season6_piranha_activity_rank_desc", data and data.para_2 or 5)
end

function UIJungleTrialRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewScrollView:AddComponent(UICommonRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.ranksData[index], false, CommonRankType.PERSONAL)
  end
end

function UIJungleTrialRankView:OnRankItemMoveOut(itemObj, index)
  self.scrollViewScrollView:RemoveComponent(itemObj.name, UICommonRankItem)
end

function UIJungleTrialRankView:ClearScroll()
  self.scrollViewScrollView:ClearCells()
  self.scrollViewScrollView:RemoveComponents(UICommonRankItem)
end

function UIJungleTrialRankView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIJungleTrialRankView:OnBtnRewardClick()
  if not self:OpenRewardWindow() then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, 489)
  end
end

function UIJungleTrialRankView:OpenRewardWindow()
  local reward = DataCenter.JungleTrialDataManager:GetRankRewardList()
  if reward and 0 < #reward then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
    return true
  end
  return false
end

return UIJungleTrialRankView
