local UIKingBattleRankView = BaseClass("UIKingBattleRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local KingBattleRankItem = require("UI.LWSeason5.KingBattle.Component.UIKingBattleRankItem")
local OutpostRankTitle = require("UI.LWSeason5.UILWSeasonOutpostRankS5v2.Component.UILWSeasonOutpostRankS5v2Title")
local text_title_path = "safeArea/TopBar/TextTitle"
local btn_back_white_path = "safeArea/BottomBar/BtnBackWhite"
local my_ally_toggle_path = "safeArea/BottomBar/MyAllyToggle"
local rank_item_path = "safeArea/panelContainer/RankItem"
local content_path = "safeArea/panelContainer/ScrollView/Viewport/Content"
local scroll_view_path = "safeArea/panelContainer/ScrollView"
local obj_no_value_path = "safeArea/panelContainer/ScrollView/NoValue"
local info_btn_path = "safeArea/TopBar/InfoBtn"
local reward_btn_path = "safeArea/BottomBar/BtnRankReward"

function UIKingBattleRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.text_title:SetLocalText("season_s5_activity_1200067_rank_name")
  self.my_ally_toggle:SetActive(true)
  self:RefreshRankList()
  SFSNetwork.SendMessage(MsgDefines.CenterThronePersonScoreRank)
end

function UIKingBattleRankView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIKingBattleRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.NineNationKingBattleRankRefresh, self.RefreshRankList)
  self:AddUIListener(EventId.CenterThroneActivityRewardShow, self.OpenRewardWindow)
end

function UIKingBattleRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.NineNationKingBattleRankRefresh, self.RefreshRankList)
  self:RemoveUIListener(EventId.CenterThroneActivityRewardShow, self.OpenRewardWindow)
  base.OnRemoveListener(self)
end

function UIKingBattleRankView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.closeBtn = self:AddComponent(UIButton, btn_back_white_path)
  self.my_ally_toggle = self:AddComponent(UIToggle, my_ally_toggle_path)
  self.rank_item = self:AddComponent(KingBattleRankItem, rank_item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.my_ally_toggle:SetIsOn(false)
  self.my_ally_toggle:SetOnValueChanged(function(tf)
    self:RefreshRankList()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.obj_no_value = self:AddComponent(UIBaseComponent, obj_no_value_path)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("season_s5_activity_1200067_rank_desc"), nil, nil, true, true)
  end)
  self.btnReward = self:AddComponent(UIButton, reward_btn_path)
  self.btnReward:SetOnClick(function()
    if not self:OpenRewardWindow() then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, 487)
    end
  end)
end

function UIKingBattleRankView:ComponentDestroy()
  self:ClearItemCell()
  self.text_title = nil
  self.btn_go = nil
  self.reward_tip = nil
end

local theRankListCache, theMyRankCache

function UIKingBattleRankView:RefreshRankList(rankData)
  self:ClearItemCell()
  local rankList
  if rankData == nil then
    rankList = theRankListCache
  else
    theRankListCache = rankData.ranks
    local playerUid = LuaEntry.Player.uid
    for i, v in ipairs(theRankListCache) do
      if v.uid == playerUid then
        theMyRankCache = v
        break
      end
    end
    rankList = theRankListCache
  end
  local dataCount = 0
  self.rankList = {}
  if rankList ~= nil and 0 < #rankList then
    self.my_ally_toggle:SetActive(true)
    if self.my_ally_toggle:GetIsOn() then
      self.rankList = {}
      if LuaEntry.Player:IsInAlliance() then
        local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        local myAllianceId = allianceBase.uid
        local myAbbr = allianceBase.abbr
        table.walk(rankList, function(k, v)
          if myAbbr ~= nil and myAbbr ~= "" and v.abbr == myAbbr then
            table.insert(self.rankList, v)
          elseif myAllianceId ~= nil and v.allianceId ~= nil and tostring(myAllianceId) == tostring(v.allianceId) then
            table.insert(self.rankList, v)
          end
        end)
      end
    else
      self.rankList = rankList
    end
    dataCount = #self.rankList
    if 0 < dataCount then
      table.sort(self.rankList, function(a, b)
        return a.rank < b.rank
      end)
      self.ScrollView:SetTotalCount(dataCount)
      self.ScrollView:RefillCells()
    end
  else
    self.my_ally_toggle:SetActive(false)
  end
  self.obj_no_value:SetActive(dataCount <= 0)
  self:RefreshSelfContent()
end

function UIKingBattleRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(KingBattleRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index])
  end
end

function UIKingBattleRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, KingBattleRankItem)
end

function UIKingBattleRankView:ClearItemCell()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(KingBattleRankItem)
end

function UIKingBattleRankView:RefreshSelfContent()
  local myUid = LuaEntry.Player.uid
  local hasMyData = false
  for index, v in ipairs(self.rankList) do
    if v.uid == myUid then
      hasMyData = true
      self.rank_item:ReInit(index, v, true)
      break
    end
  end
  if not hasMyData and theMyRankCache ~= nil then
    hasMyData = true
    self.rank_item:ReInit(theMyRankCache.rank, theMyRankCache, true)
  end
  self.rank_item:SetActive(hasMyData)
end

function UIKingBattleRankView:OpenRewardWindow()
  local reward = DataCenter.SeasonNineKingManager:GetRewardList()
  if not table.IsNullOrEmpty(reward) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
    return true
  end
  return false
end

return UIKingBattleRankView
