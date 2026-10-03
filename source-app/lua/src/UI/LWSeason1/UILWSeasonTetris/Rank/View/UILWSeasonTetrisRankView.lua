local base = UIBaseView
local UILWSeasonTetrisRankView = BaseClass("UILWSeasonTetrisRankView", base)
local uilwSeasonTetrisRankItem = require("UI.LWSeason1.UILWSeasonTetris.Rank.Component.UILWSeasonTetrisRankItem")
local Localization = CS.GameEntry.Localization
local text_title_path = "Root/TopBar/TextTitle"
local text_name_des_path = "Root/ScrollView/select/nameDes"
local text_power_des_path = "Root/ScrollView/select/powerDes"
local text_rank_des_path = "Root/ScrollView/select/rankDes"
local btn_close_path = "Root/BottomBar/BtnBack"
local tab_btns_path = "Root/tabBtns"
local text_empty_des_path = "emptyDes"
local btn_info_path = "Root/TopBar/InfoBtn"
local self_data_path = "Root/SelfData"
local scroll_view_path = "Root/ScrollView"
local btn_rank_reward_path = "Root/BottomBar/BtnRankReward"
local tab_path = "Root/tabBtns/ConditionBtns/Tab%d"
local tabNameKey = {
  [1] = "393080",
  [2] = "100101"
}

function UILWSeasonTetrisRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
  DataCenter.SeasonTetrisManager:SendGetRank()
end

function UILWSeasonTetrisRankView:OnDestroy()
  self:DataDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonTetrisRankView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_name_des = self:AddComponent(UIText, text_name_des_path)
  self.text_power_des = self:AddComponent(UIText, text_power_des_path)
  self.text_rank_des = self:AddComponent(UIText, text_rank_des_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.tab_btns = self:AddComponent(UIBaseContainer, tab_btns_path)
  self.text_empty_des = self:AddComponent(UIText, text_empty_des_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.self_data = self:AddComponent(uilwSeasonTetrisRankItem, self_data_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.btn_rank_reward = self:AddComponent(UIButton, btn_rank_reward_path)
  self.btn_close:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_rank_reward:SetOnClick(BindCallback(self, self.RequestRewardInfo))
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.tabs = {}
  for i = SeasonTetrisRankType.Owner, SeasonTetrisRankType.Language do
    local tab = {}
    local rootPath = string.format(tab_path, i)
    tab.tab = self:AddComponent(UIBaseContainer, rootPath)
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, "select")
    tab.tab_name = tab.tab:AddComponent(UIText, "activityName")
    local tabKey = tabNameKey[i]
    tab.tab_name:SetText(Localization:GetString(tabKey))
    tab.tab_btn = tab.tab:AddComponent(UIButton, "TypeButton")
    local index = i
    tab.tab_btn:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
end

function UILWSeasonTetrisRankView:ComponentDestroy()
  self.text_title = nil
  self.text_name_des = nil
  self.text_power_des = nil
  self.text_rank_des = nil
  self.btn_close = nil
  self.tab_btns = nil
  self.text_empty_des = nil
  self.btn_info = nil
  self.self_data = nil
  self.scroll_view = nil
  self.btn_rank_reward = nil
end

function UILWSeasonTetrisRankView:DataDefine()
  self.rankIndex = self:GetUserData() or SeasonTetrisRankType.Owner
  self.selectIndex = self.rankIndex ~= nil and self.rankIndex or SeasonTetrisRankType.Owner
  self.rankConfigId = DataCenter.SeasonTetrisManager:GetRankConfigId()
end

function UILWSeasonTetrisRankView:DataDestroy()
  self.rankIndex = nil
  self.selectIndex = nil
  self.rankList = nil
end

function UILWSeasonTetrisRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTetrisGetRankInfo, self.SeasonTetrisGetRankInfoHandle)
  self:AddUIListener(EventId.SeasonTetrisGetRankReward, self.OpenRewardWindow)
end

function UILWSeasonTetrisRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SeasonTetrisGetRankInfo, self.SeasonTetrisGetRankInfoHandle)
  self:RemoveUIListener(EventId.SeasonTetrisGetRankReward, self.OpenRewardWindow)
end

function UILWSeasonTetrisRankView:OpenRewardWindow()
  local reward = self.ctrl:GetRankRewardList(self.rankIndex)
  if reward and 0 < #reward then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
    return true
  end
  return false
end

function UILWSeasonTetrisRankView:RequestRewardInfo()
  if not self:OpenRewardWindow() then
    self.ctrl:OpenRewardLogic(self.rankConfigId, self.rankIndex)
  end
end

function UILWSeasonTetrisRankView:Refresh()
  self:RefreshBar()
  self:RefreshContent()
  self:RefreshRankList()
end

function UILWSeasonTetrisRankView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(uilwSeasonTetrisRankItem)
end

function UILWSeasonTetrisRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(uilwSeasonTetrisRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.rankList[index], false)
  end
end

function UILWSeasonTetrisRankView:OnRankItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, uilwSeasonTetrisRankItem)
end

function UILWSeasonTetrisRankView:SeasonTetrisGetRankInfoHandle(data)
  self:RefreshRankList()
  self:RefreshSelfContent()
  self.btn_rank_reward:SetActive(self.ctrl:CheckRewardBtnStat(self.rankIndex))
end

function UILWSeasonTetrisRankView:RefreshRankList()
  self:ClearScroll()
  local owner
  self.rankList, owner = self.ctrl:GetTetrisRankList(self.rankIndex)
  local flag = #self.rankList > 0
  if flag then
    self.scroll_view:SetTotalCount(#self.rankList)
    self.scroll_view:RefillCells()
  end
  self.text_empty_des:SetActive(not flag)
  return owner
end

function UILWSeasonTetrisRankView:RefreshSelfContent()
  local data = DataCenter.SeasonTetrisManager:GetRankData(self.rankIndex)
  local currentData
  local curLangLoc = Localization:GetString(SuportedLanguagesLocalName[SuportedServerLanguagesLocalName[Localization:GetLanguageName()] or ""] or "")
  for i = 1, #self.rankList do
    if self.rankIndex == SeasonTetrisRankType.Language then
      if self.rankList[i].firstName == curLangLoc then
        currentData = self.rankList[i]
        break
      end
    elseif self.rankList[i].uid == LuaEntry.Player.uid then
      currentData = self.rankList[i]
      break
    end
  end
  if currentData == nil and data ~= nil and data.owner ~= nil then
    currentData = self.ctrl:GetSelfData(data.owner, self.rankIndex)
  end
  self.self_data:SetActive(currentData ~= nil)
  if currentData ~= nil then
    self.self_data:SetData(currentData, true)
  end
end

function UILWSeasonTetrisRankView:DoSelectTabIndex(index)
  if index ~= self.selectIndex then
    self.selectIndex = index
  else
    return
  end
  self.rankIndex = self.selectIndex
  self:RefreshBar()
  self:RefreshContent()
end

function UILWSeasonTetrisRankView:RefreshBar()
  for i = 1, #self.tabs do
    if self.tabs[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function UILWSeasonTetrisRankView:RefreshContent()
  self.btn_rank_reward:SetActive(self.ctrl:CheckRewardBtnStat(self.rankIndex))
  self.descInfo = self.ctrl:GetActivityDescription(self.rankIndex)
  self.btn_info:SetActive(not string.IsNullOrEmpty(self.descInfo.desc))
  self.btn_info:SetOnClick(function()
    if not string.IsNullOrEmpty(self.descInfo.desc) then
      local param = {}
      param.activityRulesStr = self.descInfo.desc
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end
  end)
  self.text_title:SetLocalText(self.descInfo.title)
  self.text_rank_des:SetLocalText(361013)
  self.text_name_des:SetLocalText(self.descInfo.content1)
  self.text_power_des:SetLocalText(self.descInfo.content2)
  self:RefreshRankList()
  self:RefreshSelfContent()
end

return UILWSeasonTetrisRankView
