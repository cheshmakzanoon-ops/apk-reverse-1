local UILWSeasonOutpostRankS5v2View = BaseClass("UILWSeasonOutpostRankS5v2View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OutpostRankItem = require("UI.LWSeason5.UILWSeasonOutpostRankS5v2.Component.UILWSeasonOutpostRankS5v2Item")
local OutpostRankTitle = require("UI.LWSeason5.UILWSeasonOutpostRankS5v2.Component.UILWSeasonOutpostRankS5v2Title")
local text_title_path = "safeArea/TopBar/TextTitle"
local btn_back_white_path = "safeArea/BottomBar/BtnBackWhite"
local my_ally_toggle_path = "safeArea/BottomBar/MyAllyToggle"
local rank_item_path = "safeArea/panelContainer/RankItem"
local content_path = "safeArea/panelContainer/ScrollView/Viewport/Content"
local scroll_view_path = "safeArea/panelContainer/ScrollView"
local obj_no_value_path = "safeArea/panelContainer/ScrollView/NoValue"
local btn_go_path = "safeArea/BottomBar/BtnGo"
local reward_tip_path = "safeArea/BottomBar/BtnGo/RewardTip"

function UILWSeasonOutpostRankS5v2View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.text_title:SetLocalText("war_zone_outpost_22")
  self.my_ally_toggle:SetActive(true)
  self:RefreshRankList()
  SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleRank)
end

function UILWSeasonOutpostRankS5v2View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostRankS5v2View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostBattleRankRefresh, self.RefreshRankList)
end

function UILWSeasonOutpostRankS5v2View:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostBattleRankRefresh, self.RefreshRankList)
  base.OnRemoveListener(self)
end

function UILWSeasonOutpostRankS5v2View:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.closeBtn = self:AddComponent(UIButton, btn_back_white_path)
  self.my_ally_toggle = self:AddComponent(UIToggle, my_ally_toggle_path)
  self.rank_item = self:AddComponent(OutpostRankItem, rank_item_path)
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
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.reward_tip = self:AddComponent(OutpostRankTitle, reward_tip_path)
  self.btn_go:SetOnClick(function()
    self.reward_tip:SetActive(true)
    self.reward_tip:ReInit()
  end)
  self.reward_tip:SetOnClick(function()
    self.reward_tip:SetActive(false)
  end)
  self.reward_tip:SetActive(false)
end

function UILWSeasonOutpostRankS5v2View:ComponentDestroy()
  self:ClearItemCell()
  self.text_title = nil
  self.btn_go = nil
  self.reward_tip = nil
end

local theRankListCache, theMyRankCache

function UILWSeasonOutpostRankS5v2View:RefreshRankList(rankData)
  self:ClearItemCell()
  local rankList
  if rankData == nil then
    rankList = theRankListCache
  else
    theRankListCache = rankData.rankArr
    theMyRankCache = rankData.owner
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

function UILWSeasonOutpostRankS5v2View:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(OutpostRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index])
  end
end

function UILWSeasonOutpostRankS5v2View:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, OutpostRankItem)
end

function UILWSeasonOutpostRankS5v2View:ClearItemCell()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(OutpostRankItem)
end

function UILWSeasonOutpostRankS5v2View:RefreshSelfContent()
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

return UILWSeasonOutpostRankS5v2View
