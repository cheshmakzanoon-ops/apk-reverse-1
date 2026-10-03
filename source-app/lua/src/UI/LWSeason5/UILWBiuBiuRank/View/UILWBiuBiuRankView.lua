local base = UIBaseView
local UILWBiuBiuRankView = BaseClass("UILWBiuBiuRankView", base)
local UILWBiuBiuRankItem = require("UI.LWSeason5.UILWBiuBiuRank.Component.UILWBiuBiuRankItem")
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

function UILWBiuBiuRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
  SFSNetwork.SendMessage(MsgDefines.BiuBiuGetRank, self.rankIndex)
end

function UILWBiuBiuRankView:OnDestroy()
  self:DataDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuRankView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_name_des = self:AddComponent(UIText, text_name_des_path)
  self.text_power_des = self:AddComponent(UIText, text_power_des_path)
  self.text_rank_des = self:AddComponent(UIText, text_rank_des_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.tab_btns = self:AddComponent(UIBaseContainer, tab_btns_path)
  self.text_empty_des = self:AddComponent(UIText, text_empty_des_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.self_data = self:AddComponent(UILWBiuBiuRankItem, self_data_path)
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
  for i = SheepGameRankType.Owner, SheepGameRankType.Language do
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

function UILWBiuBiuRankView:ComponentDestroy()
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

function UILWBiuBiuRankView:DataDefine()
  self.rankIndex = self:GetUserData() or 1
  self.selectIndex = self.rankIndex ~= nil and self.rankIndex or 1
  self.rankConfigId = DataCenter.LWBiuBiuDataManager:GetRankConfigId()
end

function UILWBiuBiuRankView:DataDestroy()
  self.rankIndex = nil
  self.selectIndex = nil
  self.rankList = nil
end

function UILWBiuBiuRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGetBiuBiuRankInfo, self.SeasonGetBiuBiuRankInfoHandle)
  self:AddUIListener(EventId.SeasonGetBiuBiuRankReward, self.OpenRewardWindow)
end

function UILWBiuBiuRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SeasonGetBiuBiuRankInfo, self.SeasonGetBiuBiuRankInfoHandle)
  self:RemoveUIListener(EventId.SeasonGetBiuBiuRankReward, self.OpenRewardWindow)
end

function UILWBiuBiuRankView:OpenRewardWindow()
  local reward = self.ctrl:GetRankRewardList(self.rankIndex)
  if reward and 0 < #reward then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
    return true
  end
  return false
end

function UILWBiuBiuRankView:RequestRewardInfo()
  if not self:OpenRewardWindow() then
    self.ctrl:OpenRewardLogic(self.rankConfigId, self.rankIndex)
  end
end

function UILWBiuBiuRankView:Refresh()
  self:RefreshBar()
  self:RefreshContent()
  self:RefreshRankList()
end

function UILWBiuBiuRankView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILWBiuBiuRankItem)
end

function UILWBiuBiuRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UILWBiuBiuRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.rankList[index], false)
  end
end

function UILWBiuBiuRankView:OnRankItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UILWBiuBiuRankItem)
end

function UILWBiuBiuRankView:SeasonGetBiuBiuRankInfoHandle(data)
  if data.opType == self.rankIndex then
    self:RefreshRankList()
    self:RefreshSelfContent(data)
    self.btn_rank_reward:SetActive(self.ctrl:CheckRewardBtnStat(self.rankIndex))
  end
end

function UILWBiuBiuRankView:RefreshRankList()
  self:ClearScroll()
  local owner
  self.rankList, owner = self.ctrl:GetRankList(self.rankIndex)
  local flag = #self.rankList > 0
  if flag then
    self.scroll_view:SetTotalCount(#self.rankList)
    self.scroll_view:RefillCells()
  end
  self.text_empty_des:SetActive(not flag)
  return owner
end

function UILWBiuBiuRankView:RefreshSelfContent(data)
  local currentData
  for i = 1, #self.rankList do
    if self.rankIndex == SheepGameRankType.Language then
      if self.rankList[i].firstName == Localization:GetLanguageName() then
        currentData = self.rankList[i]
        break
      end
    elseif self.rankList[i].uid == LuaEntry.Player.uid then
      currentData = self.rankList[i]
      break
    end
  end
  if currentData == nil then
    currentData = self.ctrl:GetSelfData(data.owner, self.rankIndex)
  end
  self.self_data:SetActive(currentData ~= nil)
  if currentData ~= nil then
    self.self_data:SetData(currentData, true)
  end
end

function UILWBiuBiuRankView:DoSelectTabIndex(index)
  if DataCenter.LWBiuBiuDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  if index ~= self.selectIndex then
    self.selectIndex = index
  else
    return
  end
  self.rankIndex = self.selectIndex
  self:RefreshBar()
  self:RefreshContent()
  SFSNetwork.SendMessage(MsgDefines.BiuBiuGetRank, self.rankIndex)
end

function UILWBiuBiuRankView:RefreshBar()
  for i = 1, #self.tabs do
    if self.tabs[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function UILWBiuBiuRankView:RefreshContent()
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
end

return UILWBiuBiuRankView
