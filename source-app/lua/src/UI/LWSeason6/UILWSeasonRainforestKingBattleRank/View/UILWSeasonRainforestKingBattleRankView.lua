local UILWSeasonRainforestKingBattleRankView = BaseClass("UILWSeasonRainforestKingBattleRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RankItem = require("UI.LWSeason6.UILWSeasonRainforestKingBattleRank.Component.UILWSeasonRainforestKingBattleRankItem")
local text_title_path = "safeArea/TopBar/TextTitle"
local btn_back_white_path = "safeArea/BottomBar/BtnBackWhite"
local my_ally_toggle_path = "safeArea/BottomBar/MyAllyToggle"
local rank_item_path = "safeArea/panelContainer/RankItem"
local content_path = "safeArea/panelContainer/ScrollView/Viewport/Content"
local scroll_view_path = "safeArea/panelContainer/ScrollView"
local obj_no_value_path = "safeArea/panelContainer/ScrollView/NoValue"
local p_btn_help1_path = "safeArea/TopBar/p_btn_help1"

function UILWSeasonRainforestKingBattleRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.text_title:SetLocalText("season_s6_activity_1200116_desc16")
  self.my_ally_toggle:SetActive(true)
  self:RefreshRankList()
  SFSNetwork.SendMessage(MsgDefines.FetchRainforestKingBattleRankInfo)
end

function UILWSeasonRainforestKingBattleRankView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingBattleRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RainforestKingBattleRankUpdate, self.RefreshRankList)
end

function UILWSeasonRainforestKingBattleRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.RainforestKingBattleRankUpdate, self.RefreshRankList)
  base.OnRemoveListener(self)
end

function UILWSeasonRainforestKingBattleRankView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.closeBtn = self:AddComponent(UIButton, btn_back_white_path)
  self.my_ally_toggle = self:AddComponent(UIToggle, my_ally_toggle_path)
  self.rank_item = self:AddComponent(RankItem, rank_item_path)
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
  self.p_btn_help = self:AddComponent(UIButton, p_btn_help1_path)
  self.p_btn_help:SetOnClick(function()
    local title = "season_s6_activity_1200116_desc16"
    local desc = Localization:GetString("season_s6_activity_1200116_desc18")
    UIUtil.ShowDetail(desc, title, nil, true, true)
  end)
end

function UILWSeasonRainforestKingBattleRankView:ComponentDestroy()
  self:ClearItemCell()
  self.text_title = nil
  self.p_btn_help = nil
end

local theRankListCache, theMyRankCache

function UILWSeasonRainforestKingBattleRankView:RefreshRankList(rankData)
  self:ClearItemCell()
  local rankList
  if rankData == nil then
    rankList = theRankListCache
  else
    theRankListCache = rankData.ranks
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

function UILWSeasonRainforestKingBattleRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RankItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index])
  end
end

function UILWSeasonRainforestKingBattleRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RankItem)
end

function UILWSeasonRainforestKingBattleRankView:ClearItemCell()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RankItem)
end

function UILWSeasonRainforestKingBattleRankView:RefreshSelfContent()
  local myUid = LuaEntry.Player.uid
  local hasMyData = false
  for index, v in ipairs(self.rankList) do
    if v.uid == myUid then
      hasMyData = true
      theMyRankCache = v
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

return UILWSeasonRainforestKingBattleRankView
