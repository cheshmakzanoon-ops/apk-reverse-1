local LWUIMonsterInvasionRankView = BaseClass("LWUIMonsterInvasionRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIMonsterInvasionRankItem = require("UI.MonsterInvasion.LWUIMonsterInvasionRank.Component.LWUIMonsterInvasionRankItem")
local txt_title_path = "UICommonPopUpTitle/safearea/TopBar/TextTitle"
local close_btn_path = "UICommonPopUpTitle/safearea/BtnClose"
local return_btn_path = "UICommonPopUpTitle/panel"
local scroll_view_path = "rankObj/ScrollView"
local self_player_item_path = "rankObj/selfPlayerItem"
local ranking_rewards_btn_path = "rankObj/RankingRewardsBtn"
local btn_text_path = "rankObj/RankingRewardsBtn/BtnText"
local txt_empty_path = "rankObj/TxtEmpty"

function LWUIMonsterInvasionRankView:OnCreate()
  base.OnCreate(self)
  self.actId = self:GetUserData()
  SFSNetwork.SendMessage(MsgDefines.ActivityGetRankInfo, self.actId, 1, 100, -1)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(2901013)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.player_rank = self:AddComponent(LWUIMonsterInvasionRankItem, self_player_item_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.showDatalist = {}
  self.empty_txt = self:AddComponent(UIText, txt_empty_path)
  self.ranking_rewards_btn = self:AddComponent(UIButton, ranking_rewards_btn_path)
  self.ranking_rewards_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRewardBtn()
  end)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.btn_text:SetLocalText(302026)
  self:RefreshList()
end

function LWUIMonsterInvasionRankView:OnDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
  self.self_player_item = nil
  self.ranking_rewards_btn = nil
  self.btn_text = nil
  self.txt_empty = nil
  base.OnDestroy(self)
end

function LWUIMonsterInvasionRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonsterInvasionGetRank, self.RefreshList)
end

function LWUIMonsterInvasionRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonsterInvasionGetRank, self.RefreshList)
end

function LWUIMonsterInvasionRankView:RefreshList()
  self:ClearScroll()
  local data = self.ctrl:GetRankData(self.actId)
  if data.selfRankData ~= nil then
    self.player_rank:SetActive(true)
    self.player_rank:SetData(data.selfRankData, true)
  else
    self.player_rank:SetActive(false)
  end
  self.showDatalist = data.rankList
  if self.showDatalist ~= nil and #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
    self.empty_txt:SetActive(false)
  else
    self.player_rank:SetActive(false)
    self.empty_txt:SetLocalText(302187)
    self.empty_txt:SetActive(true)
  end
end

function LWUIMonsterInvasionRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWUIMonsterInvasionRankItem)
  self.showDatalist = {}
end

function LWUIMonsterInvasionRankView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWUIMonsterInvasionRankItem, itemObj)
  cellItem:SetData(self.showDatalist[index], false)
end

function LWUIMonsterInvasionRankView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWUIMonsterInvasionRankItem)
end

function LWUIMonsterInvasionRankView:ClickRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMonsterInvasionReward, {anim = true}, self.actId)
end

function LWUIMonsterInvasionRankView:OnClickMyRank(myRank)
end

return LWUIMonsterInvasionRankView
