local Localization = CS.GameEntry.Localization
local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWSeasonFactionDeclareWarS3 = BaseClass("LWSeasonFactionDeclareWarS3", base)
local lastOpenTab = -1
local btn_rank_path = "BottomBar/BtnRank"
local btn_rank_text_path = "BottomBar/BtnRank/BtnRankText"
local btn_history_path = "BottomBar/BtnHistory"
local btn_history_text_path = "BottomBar/BtnHistory/BtnHistoryText"
local btn_history_invite_path = "BottomBar/BtnHistoryInvite"
local btn_history_invite_text_path = "BottomBar/BtnHistoryInvite/BtnHistoryInviteText"
local btn_history_war_path = "BottomBar/BtnHistoryWar"
local btn_history_war_text_path = "BottomBar/BtnHistoryWar/BtnHistoryWarText"
local tab_item4_btn_path = "Tab/TabItem4/TabItem4Btn"
local tab_item1_path = "Tab/TabItem1"
local tab_item2_path = "Tab/TabItem2"
local tab_item3_path = "Tab/TabItem3"
local tab_item4_path = "Tab/TabItem4"
local no_alliance_path = "NoAlliance"
local btn_join_alliance_path = "NoAlliance/BtnJoinAlliance"
local red_point4_path = "Tab/TabItem4/RedPoint4"
local condition1_dark_path = "Tab/TabItem1/Condition1Dark"
local condition1_path = "TabTop/TabItem1/Condition1Select/Condition1"
local condition2_dark_path = "Tab/TabItem2/Condition2Dark"
local condition2_path = "TabTop/TabItem2/Condition2Select/Condition2"
local condition3_dark_path = "Tab/TabItem3/Condition3Dark"
local condition3_path = "TabTop/TabItem3/Condition3Select/Condition3"
local btn_goto_path = "BottomBar/BtnGoto"
local btn_goto_text_path = "BottomBar/BtnGoto/BtnGotoText"
local time_text_tip_path = "TimeTextTip"

function LWSeasonFactionDeclareWarS3:OnCreate()
  base.OnCreate(self)
  SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarInfo)
  self.time_text_tip = self:AddComponent(UITextMeshProUGUIEx, time_text_tip_path)
  self.condition1_dark = self:AddComponent(UITextMeshProUGUIEx, condition1_dark_path)
  self.condition1 = self:AddComponent(UITextMeshProUGUIEx, condition1_path)
  self.condition2_dark = self:AddComponent(UITextMeshProUGUIEx, condition2_dark_path)
  self.condition2 = self:AddComponent(UITextMeshProUGUIEx, condition2_path)
  self.condition3_dark = self:AddComponent(UITextMeshProUGUIEx, condition3_dark_path)
  self.condition3 = self:AddComponent(UITextMeshProUGUIEx, condition3_path)
  self.btn_goto = self:AddComponent(UIButton, btn_goto_path)
  self.btn_goto_text = self:AddComponent(UITextMeshProUGUIEx, btn_goto_text_path)
  self.btn_goto:SetOnClick(function()
    self:Goto()
  end)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.tab_item4 = self:AddComponent(UIToggle, tab_item4_path)
  self.red_point4 = self:AddComponent(UIImage, red_point4_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabClick(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabClick(2)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabClick(3)
    end
  end)
  self.tab_item4:SetOnValueChanged(function(tf)
    if tf then
    end
  end)
  self.tab_item4:SetActive(LuaEntry.Player:IsInAlliance())
  self.btn_history_invite = self:AddComponent(UIButton, btn_history_invite_path)
  self.btn_history_invite_text = self:AddComponent(UITextMeshProUGUIEx, btn_history_invite_text_path)
  self.btn_history_war = self:AddComponent(UIButton, btn_history_war_path)
  self.btn_history_war_text = self:AddComponent(UITextMeshProUGUIEx, btn_history_war_text_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank_text = self:AddComponent(UITextMeshProUGUIEx, btn_rank_text_path)
  self.btn_history = self:AddComponent(UIButton, btn_history_path)
  self.btn_history_text = self:AddComponent(UITextMeshProUGUIEx, btn_history_text_path)
  self.faction_war_root = self:AddComponent(UIBaseComponent, "Bg")
  self.btn_rank_text:SetLocalText("2000234")
  self.btn_rank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank)
  end)
  self.btn_history_text:SetLocalText("season_sever_declare_war_024")
  self.btn_history:SetOnClick(function()
    if LuaEntry.Player:IsInAlliance() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarDeclareHistory)
    else
      UIUtil.ShowTipsId("2010218")
    end
  end)
  self.btn_history_invite_text:SetLocalText("season_s2_faction_war_51")
  self.btn_history_invite:SetOnClick(function()
    if LuaEntry.Player:IsInAlliance() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarInviteHistory)
    else
      UIUtil.ShowTipsId("2010218")
    end
  end)
  self.btn_history_war_text:SetLocalText("season_s2_faction_war_56")
  self.btn_history_war:SetOnClick(function()
    if LuaEntry.Player:IsInAlliance() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarHistory)
    else
      UIUtil.ShowTipsId("2010218")
    end
  end)
  self.tab_item4_btn = self:AddComponent(UIButton, tab_item4_btn_path)
  self.tab_item4_btn:SetOnClick(function()
    local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
    if actInfo and actInfo.currStep ~= nil and actInfo.currStep ~= SeasonFactionDeclareWarStep.declare_before and actInfo.currStep ~= SeasonFactionDeclareWarStep.declare then
      self:OnTabClick(4)
      return
    end
    UIUtil.ShowTipsId("season_s2_faction_war_77")
  end)
  self.contentRoot = self:AddComponent(UIBaseContainer, "Bg")
  self.tabRoot = self:AddComponent(UIBaseContainer, "Tab")
  self.tabTopRoot = self:AddComponent(UIBaseContainer, "TabTop")
  self.BottomBarRoot = self:AddComponent(UIBaseContainer, "BottomBar")
  self.no_alliance = self:AddComponent(UIBaseContainer, no_alliance_path)
  self.btn_join_alliance = self:AddComponent(UIButton, btn_join_alliance_path)
  self.red_point4:SetActive(false)
  self.hasEnterTab4 = Setting:GetPrivateBool("S3EnterTab4", false)
  if not self.hasEnterTab4 then
    local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
    if actInfo and toInt(actInfo.currStep) >= SeasonFactionDeclareWarStep.invite then
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
    end
  end
  self.time_text_tip:SetText("")
  self.condition1_dark:SetLocalText("150212")
  self.condition1:SetLocalText("150212")
  self.condition2_dark:SetText("")
  self.condition2:SetText("")
  self.condition3_dark:SetText("")
  self.condition3:SetText("")
  self:OnDeclareInfoUpdate()
end

function LWSeasonFactionDeclareWarS3:OnDestroy()
  self.condition1_dark = nil
  self.condition1 = nil
  self.condition2_dark = nil
  self.condition2 = nil
  self.condition3_dark = nil
  self.condition3 = nil
  self.btn_rank = nil
  self.btn_rank_text = nil
  self.btn_history = nil
  self.btn_history_text = nil
  self.btn_history_invite = nil
  self.btn_history_invite_text = nil
  self.btn_history_war = nil
  self.btn_history_war_text = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
  self.tab_item4 = nil
  self.btn_goto = nil
  self.btn_goto_text = nil
  base.OnDestroy(self)
end

function LWSeasonFactionDeclareWarS3:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionWarDetailUpdate, self.OnWarDetailUpdate)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceDataUpdated)
  self:AddUIListener(EventId.CloseUI, self.OnCloseUI)
  self:AddUIListener(EventId.LWSeasonFactionDeclareInfoUpdate, self.OnDeclareInfoUpdate)
end

function LWSeasonFactionDeclareWarS3:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionWarDetailUpdate, self.OnWarDetailUpdate)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceDataUpdated)
  self:RemoveUIListener(EventId.CloseUI, self.OnCloseUI)
  self:RemoveUIListener(EventId.LWSeasonFactionDeclareInfoUpdate, self.OnDeclareInfoUpdate)
  base.OnRemoveListener(self)
end

function LWSeasonFactionDeclareWarS3:Goto()
  local mgr = DataCenter.SeasonFactionWarDataManager
  local actInfo = mgr:GetDeclareWarActInfo()
  if actInfo then
    self.currStep = actInfo.currStep
    self.stepEndTime = actInfo.stepEndTime
    if self.currStep == SeasonFactionDeclareWarStep.declare then
      if 1 == DataCenter.SeasonFactionWarDataManager.attackCampId then
        self:OnTabClick(3)
      elseif 2 == DataCenter.SeasonFactionWarDataManager.attackCampId then
        self:OnTabClick(2)
      end
    elseif self.currStep == SeasonFactionDeclareWarStep.invite then
      self:OnTabClick(4)
    elseif self.currStep == SeasonFactionDeclareWarStep.battle_before or self.currStep == SeasonFactionDeclareWarStep.battle then
      local warInfo = mgr.warInfo
      if warInfo == nil then
        self:OnTabClick(4)
      elseif warInfo.vsInfo and warInfo.s3BuildInfo and warInfo.vsInfo.defence and warInfo.vsInfo.attack then
        local warServerId = warInfo.s3BuildInfo.allianceServer
        local warPointId = warInfo.s3BuildInfo.pointId
        if warPointId == nil or warServerId == nil then
          self:OnTabClick(4)
          return
        end
        if warServerId == LuaEntry.Player:GetSelfServerId() then
          GoToUtil.TryJumpToWorld({
            action = "Jump",
            pointId = warPointId,
            server = warServerId,
            worldId = 0
          })
          return
        end
        local tilePos = SceneUtils.IndexToTilePos(warPointId, ForceChangeScene.World)
        math.randomseed(SafeLocalOsTime())
        local x = math.random(tilePos.x - 7, tilePos.x + 7)
        local y = math.random(tilePos.y - 7, tilePos.y + 7)
        if x >= WorldTileCount or y >= WorldTileCount or x <= 0 or y <= 0 then
          CrossServerUtil.JumpToServerByServerId(warServerId, MoveCrossServerType.SeasonBattleDesert, warPointId, SeasonCrossCameraHeight)
        else
          local newPointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
          CrossServerUtil.JumpToServerByServerId(warServerId, MoveCrossServerType.SeasonBattleDesert, newPointId, SeasonCrossCameraHeight)
        end
      else
        self:OnTabClick(4)
      end
    end
  end
end

function LWSeasonFactionDeclareWarS3:OnDeclareInfoUpdate()
  if 1 == DataCenter.SeasonFactionWarDataManager.attackCampId then
    self.condition2_dark:SetLocalText("season_s2_faction_war_05")
    self.condition2:SetLocalText("season_s2_faction_war_05")
    self.condition3_dark:SetLocalText("season_s2_faction_war_06")
    self.condition3:SetLocalText("season_s2_faction_war_06")
  elseif 2 == DataCenter.SeasonFactionWarDataManager.attackCampId then
    self.condition2_dark:SetLocalText("season_s2_faction_war_06")
    self.condition2:SetLocalText("season_s2_faction_war_06")
    self.condition3_dark:SetLocalText("season_s2_faction_war_05")
    self.condition3:SetLocalText("season_s2_faction_war_05")
  else
    self.condition2_dark:SetLocalText("season_s2_faction_war_03")
    self.condition2:SetLocalText("season_s2_faction_war_03")
    self.condition3_dark:SetLocalText("season_s2_faction_war_04")
    self.condition3:SetLocalText("season_s2_faction_war_04")
  end
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local mgr = DataCenter.SeasonFactionWarDataManager
  local actInfo = mgr:GetDeclareWarActInfo()
  if actInfo then
    self.round = actInfo.round
    self.currStep = actInfo.currStep
    self.stepEndTime = actInfo.stepEndTime
  end
  if actInfo and hasAlliance and self.activeTab == 1 then
    if self.currStep == SeasonFactionDeclareWarStep.declare then
      self.btn_goto:SetActive(true)
      self.btn_goto_text:SetLocalText("season_s2_faction_war_02")
    elseif self.currStep == SeasonFactionDeclareWarStep.invite then
      self.btn_goto:SetActive(true)
      self.btn_goto_text:SetLocalText("season_s2_ppt_week_4_tittle32")
    elseif self.currStep == SeasonFactionDeclareWarStep.battle_before or self.currStep == SeasonFactionDeclareWarStep.battle then
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
      self.btn_goto:SetActive(true)
      self.btn_goto_text:SetLocalText("season_s2_government_skill_tips12")
    else
      self.btn_goto:SetActive(false)
    end
  else
    self.btn_goto:SetActive(false)
  end
end

function LWSeasonFactionDeclareWarS3:OnCloseUI(name)
  local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
  if actInfo then
    if name == UIWindowNames.UILWSeasonFactionWarDeclareDlg and actInfo.currStep == SeasonFactionDeclareWarStep.declare then
      if self.activeTab == 2 then
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, 1)
      elseif self.activeTab == 3 then
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, 2)
      end
    elseif name == UIWindowNames.UILWSeasonFactionWarInviteDlg and actInfo.currStep == SeasonFactionDeclareWarStep.invite and self.activeTab == 4 then
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
    end
  end
end

function LWSeasonFactionDeclareWarS3:OnWarDetailUpdate()
  if not self.hasEnterTab4 then
    local warInfo = DataCenter.SeasonFactionWarDataManager.warInfo
    if warInfo then
      if warInfo.vsInfo and warInfo.s3BuildInfo and warInfo.vsInfo.defence and warInfo.vsInfo.attack then
        self.red_point4:SetActive(true)
      elseif warInfo.inviteList and table.count(warInfo.inviteList) > 0 then
        self.red_point4:SetActive(true)
      end
    end
  end
end

function LWSeasonFactionDeclareWarS3:OnAllianceDataUpdated()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  if hasAlliance and self.no_alliance:GetActive() then
    self.no_alliance:SetActive(false)
    self:OnTabClick(lastOpenTab)
  end
end

function LWSeasonFactionDeclareWarS3:OnTabClick(tabIndex)
  local prefabPath
  if self.activityData == nil then
    if self.faction_war_tab1 then
      self.faction_war_tab1:SetActive(false)
    end
    if self.faction_war_tab2 then
      self.faction_war_tab2:SetActive(false)
    end
    if self.faction_war_tab3 then
      self.faction_war_tab3:SetActive(false)
    end
    if self.faction_war_tab4 then
      self.faction_war_tab4:SetActive(false)
    end
    self.btn_rank:SetActive(false)
    self.btn_history:SetActive(false)
    self.btn_history_invite:SetActive(false)
    self.btn_history_war:SetActive(false)
    self.btn_goto:SetActive(false)
    return
  end
  self.activeTab = tabIndex
  if self.faction_war_tab1 then
    self.faction_war_tab1:SetActive(tabIndex == 1)
  end
  if self.faction_war_tab2 then
    self.faction_war_tab2:SetActive(tabIndex == 2)
  end
  if self.faction_war_tab3 then
    self.faction_war_tab3:SetActive(tabIndex == 3)
  end
  if self.faction_war_tab4 then
    self.faction_war_tab4:SetActive(tabIndex == 4)
  end
  if tabIndex == 1 then
    self:OnDeclareInfoUpdate()
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarInfo)
    self.tab_item1:SetIsOn(true)
    if self.faction_war_tab1 == nil then
      local LWSeasonFactionDeclareWarS3Tab1 = "UI.LWSeason3.UILWFactionWar.Component.LWSeasonFactionDeclareWarS3Tab1"
      prefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/FactionDeclareWar/FactionWarTab1.prefab"
      self.faction_war_tab1 = UIBaseComponent.LoadComponentAsync(self, LWSeasonFactionDeclareWarS3Tab1, prefabPath, self.faction_war_root)
    end
    self.faction_war_tab1:UpdateData()
  elseif tabIndex == 2 then
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, 1)
    self.tab_item2:SetIsOn(true)
    self.btn_goto:SetActive(false)
    if self.faction_war_tab2 == nil then
      local LWSeasonFactionDeclareWarS3Tab2 = "UI.LWSeason3.UILWFactionWar.Component.LWSeasonFactionDeclareWarS3Tab2"
      prefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/FactionDeclareWar/FactionWarTab2.prefab"
      self.faction_war_tab2 = UIBaseComponent.LoadComponentAsync(self, LWSeasonFactionDeclareWarS3Tab2, prefabPath, self.faction_war_root)
    end
    self.faction_war_tab2:UpdateData()
  elseif tabIndex == 3 then
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, 2)
    self.tab_item3:SetIsOn(true)
    self.btn_goto:SetActive(false)
    if self.faction_war_tab3 == nil then
      local LWSeasonFactionDeclareWarS3Tab3 = "UI.LWSeason3.UILWFactionWar.Component.LWSeasonFactionDeclareWarS3Tab3"
      prefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/FactionDeclareWar/FactionWarTab3.prefab"
      self.faction_war_tab3 = UIBaseComponent.LoadComponentAsync(self, LWSeasonFactionDeclareWarS3Tab3, prefabPath, self.faction_war_root)
    end
    self.faction_war_tab3:UpdateData()
  elseif tabIndex == 4 then
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
    self.tab_item4:SetIsOn(true)
    self.btn_goto:SetActive(false)
    if self.faction_war_tab4 == nil then
      local LWSeasonFactionDeclareWarS3Tab4 = "UI.LWSeason3.UILWFactionWar.Component.LWSeasonFactionDeclareWarS3Tab4"
      prefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/FactionDeclareWar/FactionWarTab4.prefab"
      self.faction_war_tab4 = UIBaseComponent.LoadComponentAsync(self, LWSeasonFactionDeclareWarS3Tab4, prefabPath, self.faction_war_root)
    end
    self.faction_war_tab4:UpdateData()
    self.red_point4:SetActive(false)
    self.hasEnterTab4 = true
    Setting:SetPrivateBool("S3EnterTab4", true)
  end
  self.btn_rank:SetActive(tabIndex == 1)
  self.btn_history:SetActive(tabIndex == 2 or tabIndex == 3)
  self.btn_history_invite:SetActive(tabIndex == 4)
  self.btn_history_war:SetActive(tabIndex ~= 1 and 1 < toInt(self.round))
  self:Update1000MS()
  lastOpenTab = tabIndex
end

function LWSeasonFactionDeclareWarS3:Update1000MS()
  if (self.activeTab == 2 or self.activeTab == 3) and self.currStep and self.stepEndTime then
    local txt
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.stepEndTime - curTime
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    local attackCampId = DataCenter.SeasonFactionWarDataManager.attackCampId
    if myCampId == attackCampId then
      txt = "season_s2_activity_1000040_tips02"
    else
      txt = "season_s2_activity_1000040_tips03"
    end
    if self.currStep == SeasonFactionDeclareWarStep.declare then
      deltaTime = deltaTime + self.timeStepInvite + self.timeStepBattleBefore
    elseif self.currStep == SeasonFactionDeclareWarStep.invite then
      deltaTime = deltaTime + self.timeStepBattleBefore
    elseif self.currStep == SeasonFactionDeclareWarStep.battle_before then
    else
      txt = nil
    end
    if txt == nil or deltaTime <= 0 then
      self.time_text_tip:SetText("")
    else
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.time_text_tip:SetLocalText(txt, showTime)
    end
  else
    self.time_text_tip:SetText("")
  end
end

function LWSeasonFactionDeclareWarS3:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actData then
    local para_7 = actData.para_7
    local para_8 = actData.para_8
    DataCenter.SeasonFactionWarDataManager.actData = actData
    DataCenter.SeasonFactionWarDataManager:InitLevelGroup(para_7, para_8)
    DataCenter.SeasonFactionWarDataManager.DeclareWarActivityData = actData
    local step1, step2, step3 = string.match(actData.para_1, "([^|]+)|([^|]+)|([^|]+)")
    self.timeStepDeclare = toInt(step1 or 86400) * 1000
    self.timeStepInvite = toInt(step2 or 43200) * 1000
    self.timeStepBattleBefore = toInt(step3 or 3600) * 1000
    self.activityData = actData
  end
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  if hasAlliance then
    self.BottomBarRoot:SetActive(true)
    self.contentRoot:SetActive(true)
    self.tabRoot:SetActive(true)
    self.tabTopRoot:SetActive(true)
    self.no_alliance:SetActive(false)
    local mgr = DataCenter.SeasonFactionWarDataManager
    local actInfo = mgr:GetDeclareWarActInfo()
    if actInfo and toInt(actInfo.currStep) >= SeasonFactionDeclareWarStep.invite then
      if 0 < lastOpenTab then
        self:OnTabClick(lastOpenTab)
      else
        self:OnTabClick(4)
      end
    elseif 0 < lastOpenTab and lastOpenTab ~= 4 then
      self:OnTabClick(lastOpenTab)
    else
      self:OnTabClick(1)
    end
    if actInfo then
      self.round = actInfo.round
    end
  else
    self.btn_rank:SetActive(false)
    self.BottomBarRoot:SetActive(false)
    self.contentRoot:SetActive(false)
    self.tabRoot:SetActive(false)
    self.tabTopRoot:SetActive(false)
    self.no_alliance:SetActive(true)
    self.btn_join_alliance:SetOnClick(function()
      if LuaEntry.Player:IsInSourceServer() then
        if LuaEntry.Player:IsFirstJoinAlliance() == true then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
        end
      else
        UIUtil.ShowTipsId("season_tips166")
      end
    end)
  end
end

return LWSeasonFactionDeclareWarS3
