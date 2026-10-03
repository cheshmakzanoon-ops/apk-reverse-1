local ServerBattleRankView = BaseClass("ServerBattleRankView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local ServerBattleRankItem = require("UI.UIGovernment.ServerBattleRank.Component.ServerBattleRankItem")
local ServerBattleRankTab2 = require("UI.UIGovernment.ServerBattleRank.Component.ServerBattleRankTab2")
local btn_back_white_path = "safeArea/BottomBar/BtnBackWhite"
local my_ally_toggle_path = "safeArea/BottomBar/MyAllyToggle"
local info_btn_path = "safeArea/TopBar/InfoBtn"
local rank_item_path = "safeArea/panelContainer/RankItem"
local content_path = "safeArea/panelContainer/ScrollView/Viewport/Content"
local scroll_view_path = "safeArea/panelContainer/ScrollView"
local tab_item1_path = "safeArea/TopBar/Tab/TabItem1"
local tab_item2_path = "safeArea/TopBar/Tab/TabItem2"
local panel_container_path = "safeArea/panelContainer"
local panel_container2_path = "safeArea/panelContainer2"
local obj_no_value_path = "safeArea/panelContainer/ScrollView/NoValue"
local lastActiveTab = 1

function ServerBattleRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.CrossKingPersonScoreRank)
end

function ServerBattleRankView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ServerBattleRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossKingPersonScoreRankRefresh, self.RefreshRankList)
  self:AddUIListener(EventId.CrossKingServerRewardPreviewInfoRefresh, self.RefreshPreviewInfo)
end

function ServerBattleRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.CrossKingPersonScoreRankRefresh, self.RefreshRankList)
  self:RemoveUIListener(EventId.CrossKingServerRewardPreviewInfoRefresh, self.RefreshPreviewInfo)
  base.OnRemoveListener(self)
end

function ServerBattleRankView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, btn_back_white_path)
  self.my_ally_toggle = self:AddComponent(UIToggle, my_ally_toggle_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.rank_item = self:AddComponent(ServerBattleRankItem, rank_item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.info_btn:SetOnClick(function()
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
  self.panel_container1 = self:AddComponent(UIBaseContainer, panel_container_path)
  self.panel_container2 = self:AddComponent(ServerBattleRankTab2, panel_container2_path)
  self.obj_no_value = self:AddComponent(UIBaseComponent, obj_no_value_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self.my_ally_toggle:SetActive(true)
      self.panel_container1:SetActive(true)
      self.panel_container2:SetActive(false)
      self:RefreshRankList()
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self.my_ally_toggle:SetActive(false)
      self.panel_container1:SetActive(false)
      self.panel_container2:SetActive(true)
      self.panel_container2:ReInit()
    end
  end)
  local param = self:GetUserData()
  if param then
    lastActiveTab = toInt(param)
    if lastActiveTab < 1 or 2 < lastActiveTab then
      lastActiveTab = 1
    end
  end
  if lastActiveTab == 1 then
    self.tab_item1:SetIsOn(true)
  elseif lastActiveTab == 2 then
    self.tab_item2:SetIsOn(true)
  end
  if self.tab_item1:GetIsOn() then
    self.my_ally_toggle:SetActive(true)
    self.panel_container1:SetActive(true)
    self.panel_container2:SetActive(false)
    self:RefreshRankList()
  else
    self.my_ally_toggle:SetActive(false)
    self.panel_container1:SetActive(false)
    self.panel_container2:SetActive(true)
    self.panel_container2:ReInit()
  end
end

function ServerBattleRankView:ComponentDestroy()
  self:ClearItemCell()
  self.panel_container2:DeInit()
end

function ServerBattleRankView:RefreshPreviewInfo()
  if self.panel_container2 then
    self.panel_container2:ReInit()
  end
end

function ServerBattleRankView:RefreshRankList()
  self:ClearItemCell()
  local rankList = DataCenter.ZoneWarManager:GetPersonScoreRank()
  self.rankList = rankList
  if 0 < #rankList then
    if self.my_ally_toggle:GetIsOn() then
      self.rankList = {}
      if LuaEntry.Player:IsInAlliance() then
        local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        local myAllianceId = allianceBase.uid
        table.walk(rankList, function(k, v)
          if myAllianceId ~= nil and v.allianceId ~= nil and tostring(myAllianceId) == tostring(v.allianceId) then
            table.insert(self.rankList, v)
          end
        end)
      end
    else
      self.rankList = rankList
    end
    if 0 < #self.rankList then
      table.sort(self.rankList, function(a, b)
        return a.rank < b.rank
      end)
      self.ScrollView:SetTotalCount(#self.rankList)
      self.ScrollView:RefillCells()
    end
  end
  self:RefreshSelfContent()
  self.obj_no_value:SetActive(0 >= #self.rankList)
end

function ServerBattleRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(ServerBattleRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index])
  end
end

function ServerBattleRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, ServerBattleRankItem)
end

function ServerBattleRankView:ClearItemCell()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(ServerBattleRankItem)
end

function ServerBattleRankView:RefreshSelfContent()
  local myUid = LuaEntry.Player.uid
  local hasMyData = false
  for index, v in ipairs(self.rankList) do
    if v.uid == myUid then
      hasMyData = true
      self.rank_item:ReInit(index, v, true)
      break
    end
  end
  self.rank_item:SetActive(hasMyData)
end

return ServerBattleRankView
