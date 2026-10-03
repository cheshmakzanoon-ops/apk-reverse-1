local UIGovernmentServerBattleMainView = BaseClass("UIGovernmentServerBattleMainView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIServerBattleWeekInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleWeekInfo")
local UIServerBattleLastKing = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleLastKing")
local text_title_path = "Root/TopBar/TextTitle"
local root4_path = "Root/Root4"
local root8_path = "Root/Root8"
local rootCamp_path = "Root/Root8Camp"
local root_week_path = "Root/RootWeek"
local root_king_battle_path = "Root/RootKingBattle"
local root_content_path = "Root/Content"
local tab_item1_path = "Root/TopBar/TabScroll/Viewport/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/TabScroll/Viewport/Tab/TabItem2"
local tab_item3_path = "Root/TopBar/TabScroll/Viewport/Tab/TabItem3"
local red_point_path = "Root/TopBar/TabScroll/Viewport/Tab/TabItem3/RedPoint"
local tab_item4_path = "Root/TopBar/TabScroll/Viewport/Tab/TabItem4"
local red_point4_path = "Root/TopBar/TabScroll/Viewport/Tab/TabItem4/RedPoint4"
local btn_reward_path = "Root/BottomBar/BtnReward"
local btn_group_path = "Root/BottomBar/BtnGroup"
local btn_back_path = "Root/BottomBar/BtnBack"
local btn_history_path = "Root/BottomBar/BtnHistory"
local btn_rank_path = "Root/BottomBar/BtnRank"
local lastRequestTime

function UIGovernmentServerBattleMainView:OnCreate()
  base.OnCreate(self)
  self.configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if self.configSchedule then
    self.config = self.configSchedule.configNow
    self.serverBattleType = self.config and self.config.type or ServerBattleType.VS4
  end
  self:ComponentDefine()
  DataCenter.ActivityTipsManager:RecordZoneWarSeenState()
end

function UIGovernmentServerBattleMainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGovernmentServerBattleMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.RefreshTab)
  self:AddUIListener(EventId.CrossKingRoundInfoALLRefresh, self.RefreshTab)
  self:AddUIListener(EventId.CrossKingRoundInfoNowRefresh, self.RefreshTab)
  if self.serverBattleType == ServerBattleType.VSCamp and SeasonUtil.IsInSeasonDarknessMode() then
    self:AddUIListener(EventId.CrossThroneStrategicAreaExchangeInfo, self.RefreshTab)
    self:AddUIListener(EventId.SaveOwnPositionId, self.RefreshTab)
  end
end

function UIGovernmentServerBattleMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.RefreshTab)
  self:RemoveUIListener(EventId.CrossKingRoundInfoALLRefresh, self.RefreshTab)
  self:RemoveUIListener(EventId.CrossKingRoundInfoNowRefresh, self.RefreshTab)
  if self.serverBattleType == ServerBattleType.VSCamp and SeasonUtil.IsInSeasonDarknessMode() then
    self:RemoveUIListener(EventId.CrossThroneStrategicAreaExchangeInfo, self.RefreshTab)
    self:RemoveUIListener(EventId.SaveOwnPositionId, self.RefreshTab)
  end
  base.OnRemoveListener(self)
end

function UIGovernmentServerBattleMainView:ComponentDefine()
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point4 = self:AddComponent(UIImage, red_point4_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("801407")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.root_week = self:AddComponent(UIServerBattleWeekInfo, root_week_path)
  self.root_king_battle = self:AddComponent(UIServerBattleLastKing, root_king_battle_path)
  self.root_content = self:AddComponent(UIBaseContainer, root_content_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.tab_item4 = self:AddComponent(UIToggle, tab_item4_path)
  self.btn_group = self:AddComponent(UIButton, btn_group_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_history = self:AddComponent(UIButton, btn_history_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:ShowTab(1, false)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:ShowTab(2, false)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:ShowTab(3, false)
    end
  end)
  self.tab_item4:SetOnValueChanged(function(tf)
    if tf then
      self:ShowTab(4, false)
    end
  end)
  self.btn_group:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerGroup, {anim = true}, JumpServerMode.CrossServerKing)
  end)
  self.btn_reward:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleRewardDetail)
  end)
  self.btn_history:SetOnClick(function()
    if self.serverBattleType == ServerBattleType.VS8 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleHistoryV8)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleHistory)
    end
  end)
  self.btn_rank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleRank, {anim = true}, 2)
  end)
  local selectIndex = self:RefreshTab()
  self.root_week:SetActive(false)
  self.root_king_battle:SetActive(false)
  local tab = self["tab_item" .. selectIndex]
  if tab then
    tab:SetIsOn(true)
  end
  if self.activeTab ~= selectIndex then
    self:ShowTab(selectIndex, false)
  end
  local mgr = DataCenter.ZoneWarManager
  if mgr:GetCrossKingRoundInfoALL() == nil then
    SFSNetwork.SendMessage(MsgDefines.CrossKingRoundInfoALL)
  end
  if mgr.vsScoreList == nil or mgr.vsScoreMVP == nil or lastRequestTime == nil or Time.time - lastRequestTime > 10 then
    lastRequestTime = Time.time
    SFSNetwork.SendMessage(MsgDefines.CrossKingScoreData)
  end
  mgr:GetPersonScoreRank()
  SFSNetwork.SendMessage(MsgDefines.CrossKingRoundInfoNow)
  SFSNetwork.SendMessage(MsgDefines.CrossKingFightInfo)
end

function UIGovernmentServerBattleMainView:ComponentDestroy()
  self.root4 = nil
  self.root8 = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
  self.btn_reward = nil
  self.btn_back = nil
  self.btn_history = nil
  self.activeTab = nil
end

function UIGovernmentServerBattleMainView:RefreshTab()
  local mgr = DataCenter.ZoneWarManager
  self.tab_item2:SetActive(mgr:GetCrossKingRoundInfoNow() ~= nil)
  self.tab_item3:SetActive(mgr:GetCrossKingFightInfo() ~= nil and mgr:GetCrossKingRoundInfoALL() ~= nil)
  self.red_point:SetActive(DataCenter.ZoneWarManager:HasRedPoint())
  if self.serverBattleType == ServerBattleType.VSCamp and SeasonUtil.IsInSeasonDarknessMode() then
    self.tab_item1:SetActive(false)
    self.tab_item4:SetActive(true)
    self.red_point4:SetActive(DataCenter.CampWarManager:HasRedPoint())
    return 4
  end
  self.tab_item1:SetActive(true)
  self.tab_item4:SetActive(false)
  return 1
end

function UIGovernmentServerBattleMainView:UpdateData()
  if self.configSchedule == nil then
    self.configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
    if self.configSchedule then
      self.config = self.configSchedule.configNow
      if self.config then
        self.serverBattleType = ServerBattleType.VSCamp
        self:ShowTab(self.activeTab, true)
      else
        self.serverBattleType = ServerBattleType.VS4
      end
    end
  end
  self.red_point:SetActive(DataCenter.ZoneWarManager:HasRedPoint())
end

function UIGovernmentServerBattleMainView:ShowTab(tabIndex, force)
  local mgr = DataCenter.ZoneWarManager
  if self.activeTab == tabIndex and not force then
    return
  end
  if self.config == nil then
    self.activeTab = tabIndex
    return
  end
  if self.root4 == nil and tabIndex == 1 then
    self.text_title:SetLocalText(self.config.name or "801407")
    if self.serverBattleType == ServerBattleType.VS8 then
      local UIServerBattleZoneListV8 = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneListV8")
      self.root8 = self:AddComponent(UIServerBattleZoneListV8, root8_path)
      self.root4 = self:AddComponent(UIBaseComponent, root4_path)
      self.root4:SetActive(false)
      self.rootCamp = self:AddComponent(UIBaseComponent, rootCamp_path)
      self.rootCamp:SetActive(false)
    elseif self.serverBattleType == ServerBattleType.VSCamp then
      local UIServerBattleZoneListV8Camp = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneListV8Camp")
      self.rootCamp = self:AddComponent(UIServerBattleZoneListV8Camp, rootCamp_path)
      self.root8 = self:AddComponent(UIBaseComponent, root8_path)
      self.root8:SetActive(false)
      self.root4 = self:AddComponent(UIBaseComponent, root4_path)
      self.root4:SetActive(false)
    else
      local UIServerBattleZoneList = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneList")
      self.root4 = self:AddComponent(UIServerBattleZoneList, root4_path)
      self.root8 = self:AddComponent(UIBaseComponent, root8_path)
      self.root8:SetActive(false)
      self.rootCamp = self:AddComponent(UIBaseComponent, rootCamp_path)
      self.rootCamp:SetActive(false)
    end
  end
  self.btn_reward:SetActive(tabIndex == 1)
  self.btn_history:SetActive(tabIndex == 1 and (self.serverBattleType == ServerBattleType.VS4 or self.serverBattleType == ServerBattleType.VS8))
  self.btn_group:SetActive(tabIndex == 1 and (self.serverBattleType == ServerBattleType.VS8 or self.serverBattleType == ServerBattleType.VSCamp))
  self.btn_rank:SetActive(tabIndex == 3)
  if self.root4 then
    self.root4:SetActive(tabIndex == 1 and self.serverBattleType == ServerBattleType.VS4)
  end
  if self.root8 then
    self.root8:SetActive(tabIndex == 1 and self.serverBattleType == ServerBattleType.VS8)
  end
  if self.rootCamp then
    self.rootCamp:SetActive(tabIndex == 1 and self.serverBattleType == ServerBattleType.VSCamp)
  end
  self.root_week:SetActive(tabIndex == 2)
  self.root_king_battle:SetActive(tabIndex == 3)
  self.root_content:SetActive(tabIndex == 4)
  if tabIndex == 1 then
    if self.serverBattleType == ServerBattleType.VS8 then
      self.root8:ReInit(self.configSchedule, self.config, self.serverBattleType)
    elseif self.serverBattleType == ServerBattleType.VSCamp then
      self.rootCamp:ReInit(self.configSchedule, self.config, self.serverBattleType)
    else
      self.root4:ReInit(self.configSchedule, self.config, self.serverBattleType)
    end
    self.root_week:DeInit()
  elseif tabIndex == 2 then
    self.root_week:ReInit(self.configSchedule, self.config, self.serverBattleType)
  elseif tabIndex == 3 then
    self.root_king_battle:ReInit(self.configSchedule, self.config, self.serverBattleType)
    self.root_week:DeInit()
  elseif tabIndex == 4 then
    self:RefreshCampSelect()
    self.root_week:DeInit()
  end
  self.red_point:SetActive(DataCenter.ZoneWarManager:HasRedPoint())
  self.activeTab = tabIndex
end

function UIGovernmentServerBattleMainView:RefreshCampSelect()
  SFSNetwork.SendMessage(MsgDefines.CrossThroneGetStrategicAreaOverview)
  DataCenter.CampWarManager:RequestAreaExchangeInfo()
  if self.root_camp_select then
    self.root_camp_select:ReInit(self.configSchedule, self.config, self.serverBattleType)
    return
  end
  local UIServerBattleCampSelect = require("UI.LWSeason.LWSeasonCampWar.UIServerBattleCampSelect")
  local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/CampSelection/RootCampSelect.prefab"
  if not self.campSelectReq then
    self.campSelectReq = self:GameObjectInstantiateAsync(prefabPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.root_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.root_camp_select = self:AddComponent(UIServerBattleCampSelect, string.format("%s/%s", root_content_path, go.name))
      self.root_camp_select:SetAnchoredPositionXY(0, 0)
      self.root_camp_select:SetSizeDeltaXY(0, 0)
      self.root_camp_select:ReInit(self.configSchedule, self.config, self.serverBattleType)
    end)
  end
end

local grayBg = "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg01.png"
local blueBg = "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg02.png"
local redBg = "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difang_fuwuqibg.png"

function UIGovernmentServerBattleMainView:UpdateStatus(bgNode, txtNode, txt, status)
  if status == 0 then
    txtNode:SetColorRGBA(1, 1, 1, 1)
    bgNode:LoadSprite(grayBg)
  elseif status == 2 then
    txtNode:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    bgNode:LoadSprite(blueBg)
  elseif status == 1 then
    txtNode:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    bgNode:LoadSprite(redBg)
  else
    txtNode:SetColorRGBA(1, 1, 1, 1)
    bgNode:LoadSprite(grayBg)
  end
  txtNode:SetText(txt)
end

return UIGovernmentServerBattleMainView
