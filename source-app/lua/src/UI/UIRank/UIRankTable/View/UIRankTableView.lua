local UIRankTableView = BaseClass("UIRankTableView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RankSimpleItem = require("UI.UIRank.UIRankTable.Component.RankSimpleItem")
local text_title_path = "Root/TopBar/TextTitle"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local condition1_path = "Root/TopBar/Tab/TabItem1/Condition1Select/Condition1"
local condition2_path = "Root/TopBar/Tab/TabItem2/Condition2Select/Condition2"
local condition2_dark_path = "Root/TopBar/Tab/TabItem2/Condition2Dark"
local condition1_dark_path = "Root/TopBar/Tab/TabItem1/Condition1Dark"
local btn_back_path = "Root/BottomBar/BtnBack"
local rank_simple_item_path = "Root/RankSimpleItem"
local content_path = "Root/DataList/Viewport/Content"
local scroll_view_path = "Root/DataList"
local item_al_path = "Root/DataList/Viewport/Content/ItemAL"
local title_al_path = "Root/DataList/Viewport/Content/ItemAL/flower/titleAL"
local content_al_path = "Root/DataList/Viewport/Content/ItemAL/contentAL"
local item_player_path = "Root/DataList/Viewport/Content/ItemPlayer"
local title_player_path = "Root/DataList/Viewport/Content/ItemPlayer/flower/titlePlayer"
local content_player_path = "Root/DataList/Viewport/Content/ItemPlayer/contentPlayer"
local info_btn_path = "Root/TopBar/InfoBtn"
local refresh_btn_path = "Root/BottomBar/RefreshBtn"
local empty_text_path = "Root/DataList/Viewport/EmptyText"

function UIRankTableView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  if param then
    self.serverId = toInt(param)
  elseif BattleFieldUtil.InBattleField() then
    self.serverId = LuaEntry.Player:GetSelfServerId()
  else
    self.serverId = LuaEntry.Player:GetCurServerId()
  end
  self.typeList = nil
  self.empty_text = self:AddComponent(UIText, empty_text_path)
  self.empty_text:SetLocalText(100231)
  self.empty_text:SetActive(true)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.condition1 = self:AddComponent(UIText, condition1_path)
  self.condition2 = self:AddComponent(UIText, condition2_path)
  self.condition1_dark = self:AddComponent(UIText, condition1_dark_path)
  self.condition2_dark = self:AddComponent(UIText, condition2_dark_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseAll))
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.content:SetActive(false)
  self.item_al = self:AddComponent(UIBaseContainer, item_al_path)
  self.title_al = self:AddComponent(UIText, title_al_path)
  self.content_al = self:AddComponent(UIBaseContainer, content_al_path)
  self.item_player = self:AddComponent(UIBaseContainer, item_player_path)
  self.title_player = self:AddComponent(UIText, title_player_path)
  self.content_player = self:AddComponent(UIBaseContainer, content_player_path)
  self.theItem = self.transform:Find(rank_simple_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.text_title:SetLocalText("390040")
  self.condition1:SetLocalText("451030")
  self.condition1_dark:SetLocalText("451030")
  self.condition2:SetLocalText("451031")
  self.condition2_dark:SetLocalText("451031")
  self.title_al:SetLocalText("393081")
  self.title_player:SetLocalText("393080")
  self.refresh_btn:SetOnClick(function()
    if self.flagGlobal ~= nil and CS.CommonUtils.IsDebug() then
      SFSNetwork.SendMessage(MsgDefines.GetRankPreviewMessage, self.flagGlobal, self.serverId)
    end
  end)
  self.info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, {
      activityRulesStr = Localization:GetString("451037")
    })
  end)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(2)
    end
  end)
  self.buttonListInType = {}
  self.tab_item1:SetIsOn(true)
  if self.activeTabIndex == nil then
    self:SelectTab(1)
  end
end

function UIRankTableView:SelectTab(tabIndex)
  if tabIndex == 2 then
    self.flagGlobal = 1
    DataCenter.RankDataManager:fetchPreviewRankData(1, self.serverId)
  else
    self.flagGlobal = 0
    DataCenter.RankDataManager:fetchPreviewRankData(0, self.serverId)
  end
  self.activeTabIndex = tabIndex
  if DataCenter.RankDataManager:HasPreviewRankData(self.flagGlobal, self.serverId) then
    self.empty_text:SetActive(false)
    self:InitItem(tabIndex)
  else
    self.empty_text:SetLocalText(100231)
    self.empty_text:SetActive(true)
    self.content:SetActive(false)
  end
end

function UIRankTableView:InitItem(tabIndex)
  if self.typeList ~= nil then
    return
  end
  local goItem, theItem, theParent
  local typeList = self.ctrl:GetRankTypeList()
  local theItemList = self.theItemList or {}
  for _, v in ipairs(typeList) do
    local NodeName = "item_" .. v.type
    theItem = theItemList[NodeName]
    if theItem == nil then
      if v.type == RankingTypeServer.KILL_ALLIANCE or v.type == RankingTypeServer.POWER_ALLIANCE then
        theParent = self.content_al
      else
        theParent = self.content_player
      end
      goItem = self.theItem:GameObjectSpawn(theParent.transform)
      goItem.name = NodeName
      goItem:SetActive(true)
      theItem = theParent:AddComponent(RankSimpleItem, NodeName)
      theItem:SetActive(true)
      theItem:InitByType(v, self.serverId)
      theItemList[NodeName] = theItem
      self.buttonListInType[v.type] = theItem
    end
    theItem:RefreshData(tabIndex, self.flagGlobal, self.serverId)
  end
  self.empty_text:SetActive(false)
  self.content:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_player.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.item_player.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_al.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.item_al.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.scroll_view:SetVerticalNormalizedPosition(1.0)
  self.activeTabIndex = tabIndex
  self.typeList = typeList
  self.theItemList = theItemList
end

function UIRankTableView:OnDestroy()
  self.typeList = nil
  self.content_al:RemoveComponents(RankSimpleItem)
  self.content_player:RemoveComponents(RankSimpleItem)
  self.theItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function UIRankTableView:OnRefresh()
  if DataCenter.RankDataManager:HasPreviewRankData(self.flagGlobal, self.serverId) then
    if self.typeList == nil then
      self:InitItem(self.activeTabIndex)
    else
      local theItemList = self.theItemList or {}
      for _, theItem in pairs(theItemList) do
        theItem:RefreshData(self.activeTabIndex, self.flagGlobal, self.serverId)
      end
    end
  else
    self.empty_text:SetLocalText(110534)
    self.empty_text:SetActive(true)
    self.content:SetActive(false)
  end
end

function UIRankTableView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateRankPreview, self.OnRefresh)
end

function UIRankTableView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateRankPreview, self.OnRefresh)
end

return UIRankTableView
