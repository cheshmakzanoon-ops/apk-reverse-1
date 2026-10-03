local LWUIWorldBossRankView = BaseClass("LWUIWorldBossRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIWorldBossRankItem = require("UI.LWUIWorldBossRank.Component.LWUIWorldBossRankItem")
local txt_title_path = "UICommonPopUpTitle/safearea/TopBar/TextTitle"
local close_btn_path = "UICommonPopUpTitle/safearea/BtnClose"
local return_btn_path = "UICommonPopUpTitle/panel"
local scroll_view_path = "bossRankObj/ScrollView"
local self_player_item_path = "bossRankObj/selfPlayerItem"
local ranking_rewards_btn_path = "bossRankObj/RankingRewardsBtn"
local btn_text_path = "bossRankObj/RankingRewardsBtn/BtnText"
local txt_empty_path = "bossRankObj/TxtEmpty"
local txt_season_tip_path = "bossRankObj/txt_SeasonTip"

function LWUIWorldBossRankView:OnCreate()
  base.OnCreate(self)
  self.actId = self:GetUserData()
  self:ReqRankInfo()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(456006)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.player_rank = self:AddComponent(LWUIWorldBossRankItem, self_player_item_path)
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
  self.txt_season_tip = self:AddComponent(UITextMeshProUGUIEx, txt_season_tip_path)
  local isVail = DataCenter.LWSeasonBossLoginDataManager:IsVail()
  if isVail then
    self.ScrollView:SetSizeDeltaXY(700, 680)
    self.ScrollView:SetAnchoredPositionXY(0, 370)
  else
    self.ScrollView:SetSizeDeltaXY(700, 790)
    self.ScrollView:SetAnchoredPositionXY(0, 480)
  end
  self.txt_season_tip:SetActive(DataCenter.LWSeasonBossLoginDataManager:IsVail())
end

function LWUIWorldBossRankView:OnDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
  self.self_player_item = nil
  self.ranking_rewards_btn = nil
  self.btn_text = nil
  self.txt_empty = nil
  self.txt_season_tip = nil
  base.OnDestroy(self)
end

function LWUIWorldBossRankView:OnEnable()
  base.OnEnable(self)
  self:RefreshList()
end

function LWUIWorldBossRankView:OnDisable()
  base.OnDisable(self)
end

function LWUIWorldBossRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnActBossRankRefresh, self.RefreshList)
  self:AddUIListener(EventId.WorldBossInitActivityData, self.ReqRankInfo)
end

function LWUIWorldBossRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnActBossRankRefresh, self.RefreshList)
  self:RemoveUIListener(EventId.WorldBossInitActivityData, self.ReqRankInfo)
end

function LWUIWorldBossRankView:RefreshList()
  self:ClearScroll()
  local data = self.ctrl:GetBossRankData(self.actId)
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

function LWUIWorldBossRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWUIWorldBossRankItem)
  self.showDatalist = {}
end

function LWUIWorldBossRankView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWUIWorldBossRankItem, itemObj)
  cellItem:SetData(self.showDatalist[index], false)
end

function LWUIWorldBossRankView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWUIWorldBossRankItem)
end

function LWUIWorldBossRankView:ClickRewardBtn()
  if DataCenter.LWSeasonBossLoginDataManager:IsVail() then
    local reward = DataCenter.ActBossDataManager:GetRewardsDataByActId(self.actId, 1)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldBossReward, {anim = true}, self.actId)
end

function LWUIWorldBossRankView:OnClickMyRank(myRank)
  if 0 < myRank then
    self.ScrollView:ScrollToCell(myRank, 0.1)
  else
    local dataList = DataCenter.ActBossDataManager:GetActBossDataList()
    if dataList ~= nil then
      for k, v in pairs(dataList) do
        local pos = v.startPos
        local serverId = v.serverId
        local worldPointPos = SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World)
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2, nil, serverId, 0)
        return
      end
    end
    UIUtil.ShowTipsId(302243)
  end
end

function LWUIWorldBossRankView:ReqRankInfo()
  if self.actId then
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankInfo, self.actId, 1, 100, -1)
  end
end

return LWUIWorldBossRankView
