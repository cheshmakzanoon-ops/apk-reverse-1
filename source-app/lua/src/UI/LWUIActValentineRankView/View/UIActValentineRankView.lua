local UIActValentineRankView = BaseClass("UIActValentineRankView", UIBaseView)
local M = UIActValentineRankView
local UIActValentineRankItem = require("UI.LWUIActValentineRankView.Component.UIActValentineRankItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local title_text_path = "Root/BG/titleText"
local btn_close_path = "Root/BG/LW_Btn_Close"
local rank_scroll_path = "Root/ScrollRect"
local rank_scroll_Content_path = "Root/ScrollRect/Viewport/Content"
local local_server_tab_path = "Root/TabHolder/TabContent/TabItem1"
local local_server_tab_select_path = "Root/TabHolder/TabContent/TabItem1/TabItemSelect1"
local local_server_tab_unSelect_path = "Root/TabHolder/TabContent/TabItem1/TabItemUnSelect1"
local local_server_tab_text = "Root/TabHolder/TabContent/TabItem1/TabItemText1"
local war_zone_tab_path = "Root/TabHolder/TabContent/TabItem2"
local war_zone_tab_select_path = "Root/TabHolder/TabContent/TabItem2/TabItemSelect2"
local war_zone_tab_unSelect_path = "Root/TabHolder/TabContent/TabItem2/TabItemUnSelect2"
local war_zone_tab_text = "Root/TabHolder/TabContent/TabItem2/TabItemText2"
local self_content_path = "Root/SelfContent"
local reward_node_path = "Root/RewardNode"
local reward_tip_btn = "Root/RewardNode/Tips/TipBtn"
local reward_tip_text = "Root/RewardNode/Tips/TipsText"
local reward_content_path = "Root/RewardNode/RewardContent"
local cross_rank_tip_text_path = "Root/CrossRankTipText"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.activityId = self:GetUserData()
  self:DataDefine()
  self:InitView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:ClearRewards()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.textTitle = self:AddComponent(UIText, title_text_path)
  self.btnLWClose = self:AddComponent(UIButton, btn_close_path)
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.rankScroll = self:AddComponent(UILoopListView2, rank_scroll_path)
  self.rankScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.rankContent = self:AddComponent(UIBaseContainer, rank_scroll_Content_path)
  self.toggle_localServer = self:AddComponent(UIToggle, local_server_tab_path)
  self.toggle_warZone = self:AddComponent(UIToggle, war_zone_tab_path)
  self.toggleSelect_localServer = self:AddComponent(UIBaseContainer, local_server_tab_select_path)
  self.toggleUnSelect_localServer = self:AddComponent(UIBaseContainer, local_server_tab_unSelect_path)
  self.toggleSelect_warZone = self:AddComponent(UIBaseContainer, war_zone_tab_select_path)
  self.toggleUnSelect_warZone = self:AddComponent(UIBaseContainer, war_zone_tab_unSelect_path)
  self.tabText_localServer = self:AddComponent(UIText, local_server_tab_text)
  self.tabText_WarZone = self:AddComponent(UIText, war_zone_tab_text)
  self.toggle_localServer:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(ValentineRankType.SelfServer)
    end
  end)
  self.toggle_warZone:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(ValentineRankType.ZoneServer)
    end
  end)
  self.selfContent = self:AddComponent(UIActValentineRankItem, self_content_path)
  self.rewardNode = self:AddComponent(UIBaseContainer, reward_node_path)
  self.btnRewardTip = self:AddComponent(UIButton, reward_tip_btn)
  self.btnRewardTip:SetOnClick(function()
    self:OnClickRewardTip()
  end)
  self.rewardTipText = self:AddComponent(UIText, reward_tip_text)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.crossRankTipTextObj = self:AddComponent(UIBaseContainer, cross_rank_tip_text_path)
end

function M:ComponentDestroy()
  self.panel = nil
  self.textTitle = nil
  self.btnLWClose = nil
  self.rankScroll = nil
  self.rankContent = nil
  self.toggle_localServer = nil
  self.toggle_warZone = nil
  self.toggleSelect_localServer = nil
  self.toggleUnSelect_localServer = nil
  self.toggleSelect_warZone = nil
  self.toggleUnSelect_warZone = nil
  self.tabText_localServer = nil
  self.tabText_WarZone = nil
  self.selfContent = nil
  self.rewardNode = nil
  self.btnRewardTip = nil
  self.rewardTipText = nil
  self.rewardContent = nil
end

function M:DataDefine()
  self.curChannel = ValentineRankType.SelfServer
  self.curChannelRankArr = {}
  self.itemIndex = 0
  self.rankData = {}
  self.rewardItemList = {}
  DataCenter.ValentineDataManager:RequestRankData(self.curChannel, self.activityId)
end

function M:DataDestroy()
  self.curChannel = nil
  self.curChannelRankArr = nil
  self.itemIndex = nil
  self.rankData = nil
  self.rewardItemList = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineReceiveRankData, self.Refresh)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ValentineReceiveRankData, self.Refresh)
end

function M:OnBtnLWCloseClick()
  self.ctrl.CloseSelf()
end

function M:InitView()
  self.textTitle:SetLocalText("activity_99136_51")
  self.rewardTipText:SetLocalText("activity_99136_54")
  self.tabText_localServer:SetLocalText("activity_99136_52")
  self.tabText_WarZone:SetLocalText("activity_99136_56")
  self.toggleSelect_localServer:SetActive(true)
  self.toggleUnSelect_localServer:SetActive(false)
  self.toggleSelect_warZone:SetActive(false)
  self.toggleUnSelect_warZone:SetActive(true)
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.curChannelRankArr then
    return nil
  end
  local rankData = self.curChannelRankArr[index]
  local item = loopScroll:NewListViewItem("ItemContent")
  local script = self.rankContent:GetComponent(item.gameObject.name, UIActValentineRankItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.rankContent:AddComponent(UIActValentineRankItem, objectName)
  end
  script:SetActive(true)
  script:SetData(rankData, self.activityId, self.curChannel)
  return item
end

function M:OnTabChanged(tab)
  self.toggleSelect_localServer:SetActive(tab == ValentineRankType.SelfServer)
  self.toggleUnSelect_localServer:SetActive(tab ~= ValentineRankType.SelfServer)
  self.toggleSelect_warZone:SetActive(tab == ValentineRankType.ZoneServer)
  self.toggleUnSelect_warZone:SetActive(tab ~= ValentineRankType.ZoneServer)
  self.curChannel = tab
  DataCenter.ValentineDataManager:RequestRankData(tab, self.activityId)
end

function M:Refresh()
  self.rankData = DataCenter.ValentineDataManager:GetRankData(self.curChannel)
  self.curChannelRankArr = self.rankData.rankArr
  if self.rankScroll == nil or #self.curChannelRankArr == 0 then
    self.rankScroll:SetActive(false)
  else
    self.rankScroll:SetActive(true)
    self.rankScroll:SetListItemCount(#self.curChannelRankArr, false, false)
    self.rankScroll:RefreshAllShownItem()
  end
  if self.curChannel == ValentineRankType.SelfServer then
    self.rankScroll:SetSizeDeltaXY(730, 650)
    self.selfContent:SetActive(true)
    self:SetSelfContent()
    self.rewardNode:SetActive(true)
    self.crossRankTipTextObj:SetActive(false)
    self:InitRewardItem()
  else
    self.rankScroll:SetSizeDeltaXY(730, 830)
    self.selfContent:SetActive(false)
    self.rewardNode:SetActive(false)
    self.crossRankTipTextObj:SetActive(true)
  end
end

function M:ClearScroll()
  self.rankContent:RemoveComponents(UIActValentineRankItem)
  self.rankScroll:ClearAllItems()
end

function M:SetSelfContent()
  local selfRankData = {}
  local owner = self.rankData.owner
  selfRankData.score = owner.score
  selfRankData.rank = owner.rank
  selfRankData.name = LuaEntry.Player:GetName()
  selfRankData.abbr = LuaEntry.Player:IsInAlliance() and LuaEntry.Player:GetAllianceAbbr() or ""
  selfRankData.uid = LuaEntry.Player:GetUid()
  selfRankData.pic = LuaEntry.Player:GetPic()
  selfRankData.picVer = LuaEntry.Player:GetPicVer()
  selfRankData.gender = LuaEntry.Player:GetGender()
  selfRankData.isSelf = true
  self.selfContent:SetData(selfRankData, self.activityId)
end

function M:OnClickRewardTip()
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = Localization:GetString("activity_99136_55")
  param.isLocal = true
  param.alignObject = self.btnRewardTip
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function M:ClearRewards()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardItemList then
    for _, req in ipairs(self.rewardItemList) do
      self:GameObjectDestroy(req)
    end
  end
  self.rewardItemList = {}
end

function M:InitRewardItem()
  self:ClearRewards()
  if not (self.rankData and self.rankData.firstReward) or type(self.rankData.firstReward) ~= "table" or table.length(self.rankData.firstReward) == 0 then
    self.rewardContent:SetActive(false)
    self.rewardTipText:SetLocalText("activity_99136_rankend")
    return
  end
  local firstReward = self.rankData.firstReward
  for i, item in ipairs(firstReward) do
    local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req == nil then
        return
      end
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local rewardName = "item_" .. i
      obj.name = rewardName
      obj:SetActive(true)
      obj.transform:SetParent(self.rewardContent.transform)
      obj.transform:Set_localScale(0.7, 0.7, 1)
      obj.transform:Set_sizeDelta(97, 102)
      obj.transform:Set_pivot(0, 1)
      local cell = self.rewardContent:AddComponent(UICommonResItem, rewardName)
      local param = {}
      param.itemId = item.value.id
      param.count = item.value.num
      param.rewardType = item.type
      cell:ReInit(param)
    end)
    table.insert(self.rewardItemList, req)
  end
end

return UIActValentineRankView
