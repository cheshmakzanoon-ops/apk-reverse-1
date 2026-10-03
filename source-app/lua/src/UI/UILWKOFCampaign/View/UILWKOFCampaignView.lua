local UILWKOFCampaignView = BaseClass("UILWKOFCampaignView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWKOFCampaignTeam = require("UI.UILWKOFCampaign.Component.UILWKOFCampaignTeam")
local ResourceManager = CS.GameEntry.Resource
local bgEffPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Eff_ui_LWKOFCampaign_02/Eff_UI_LWKOFCampaign_BG_Loop.prefab"
local bg1_path = "Root/Bg1"
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local battle_btn_path = "Root/BottomBar/BattleBtn"
local battle_btn_text_path = "Root/BottomBar/BattleBtn/BattleBtnText"
local atk_team_slot_area_path = "Root/Middle/AtkPlayer/AtkTeams/AtkTeam%dSlotArea"
local atkPlayerTeamContainer = "Root/Middle/AtkPlayer/AtkTeams"
local atk_team3_path = "Root/Middle/Anim_Atk/AtkTeam3"
local atk_team2_path = "Root/Middle/Anim_Atk/AtkTeam2"
local atk_team1_path = "Root/Middle/Anim_Atk/AtkTeam1"
local switch_btn1_path = "Root/Middle/SwitchBtn1"
local switch_btn2_path = "Root/Middle/SwitchBtn2"
local atk_player_head_path = "Root/Middle/AtkPlayer/AtkPlayerHead"
local atk_player_name_path = "Root/Middle/AtkPlayer/AtkPlayerName"
local atk_player_power_path = "Root/Middle/AtkPlayer/AtkPlayerPower/AtkPowerText"
local atk_player_blood_tip_path = "Root/Middle/AtkPlayer/AtkPlayerBloodTip"
local def_player_head_path = "Root/Middle/DefPlayer/DefPlayerHead"
local def_player_name_path = "Root/Middle/DefPlayer/DefPlayerName"
local def_player_power_path = "Root/Middle/DefPlayer/DefPlayerPower/DefPowerText"
local def_player_blood_tip_path = "Root/Middle/DefPlayer/DefPlayerBloodTip"
local def_team1_path = "Root/Middle/Anim_Atk/DefTeam1"
local def_team2_path = "Root/Middle/Anim_Atk/DefTeam2"
local def_team3_path = "Root/Middle/Anim_Atk/DefTeam3"
local tip_text_path = "Root/Middle/TipText"
local v_s_path = "Root/Middle/VS"
local atk_player_blood_cell_path = "Root/Middle/AtkPlayer/AtkPlayerBloodTip/AtkPlayerBloodCell"
local def_player_blood_cell_path = "Root/Middle/DefPlayer/DefPlayerBloodTip/DefPlayerBloodCell"
local skip_mask_path = "SkipMask"
local anim_atk_path = "Root/Middle/Anim_Atk"
local r_pos003_path = "Root/Middle/Anim_Atk/R_Pos003"
local r_pos002_path = "Root/Middle/Anim_Atk/R_Pos002"
local r_pos001_path = "Root/Middle/Anim_Atk/R_Pos001"
local b_pos003_path = "Root/Middle/Anim_Atk/B_Pos003"
local b_pos002_path = "Root/Middle/Anim_Atk/B_Pos002"
local b_pos001_path = "Root/Middle/Anim_Atk/B_Pos001"
local eff_def_win_path = "Root/Middle/Anim_Atk/Eff_Def_Win"
local eff_atk_win_path = "Root/Middle/Anim_Atk/Eff_Atk_Win"
local eff_u_i_impact_path = "Root/Middle/Anim_Atk/Eff_UI_Impact"
local eff_u_i_card_change_1_2_path = "Root/Middle/Anim_Atk/Eff_UI_Card_Change_1_2"
local eff_u_i_card_change_2_3_path = "Root/Middle/Anim_Atk/Eff_UI_Card_Change_2_3"
local eff_u_i_card_rotate_path = "Root/Middle/Anim_Atk/Eff_UI_Card_Rotate"
local eff_u_i_spark_battle_path = "Root/Middle/Anim_Atk/Eff_UI_Spark_Battle"
local eff_u_i_outline_blue_path = "Root/Middle/Anim_Atk/Eff_UI_Outline_Blue"
local eff_u_i_outline_red_path = "Root/Middle/Anim_Atk/Eff_UI_Outline_Red"
local surprise_mask_path = "Root/Middle/DefPlayer/SurpriseMask"
local surprise_node_path = "Root/Middle/DefPlayer/SurpriseNode"
local surprise_text_path = "Root/Middle/DefPlayer/SurpriseNode/SurpriseText"
local Anim = {
  Default = "Default",
  Change1 = "Change1",
  Change2 = "Change2",
  Impact = "Impact",
  Random = "Random",
  BlueDown = "BlueDown",
  RedDown = "RedDown",
  RedChange1 = "RedChange1",
  RedChange2 = "RedChange2",
  BlueRandom = "BlueRandom"
}

function UILWKOFCampaignView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:Refresh()
  local startBattle = self:GetUserData()
  if startBattle then
    self:OnBattleStart()
  end
end

function UILWKOFCampaignView:OnDestroy()
  self:ClearBattleSequence()
  self:ResetDragAreaPos()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWKOFCampaignView:OnDisable()
  base.OnDisable(self)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
end

function UILWKOFCampaignView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KOFBattleFinish, self.OnBattleFinish)
  self:AddUIListener(EventId.RobTrainTryRefreshView, self.OnRobTrainTryRefreshView)
  self:AddUIListener(EventId.KOFBattleFinishError, self.OnBattleError)
end

function UILWKOFCampaignView:OnRemoveListener()
  self:RemoveUIListener(EventId.KOFBattleFinish, self.OnBattleFinish)
  self:RemoveUIListener(EventId.RobTrainTryRefreshView, self.OnRobTrainTryRefreshView)
  self:RemoveUIListener(EventId.KOFBattleFinishError, self.OnBattleError)
  base.OnRemoveListener(self)
end

function UILWKOFCampaignView:ComponentDefine()
  self.bg1 = self:AddComponent(UIBaseContainer, bg1_path)
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.battle_btn = self:AddComponent(UIButton, battle_btn_path)
  self.battle_btn_text = self:AddComponent(UITextMeshProUGUIEx, battle_btn_text_path)
  self.switch_btn1 = self:AddComponent(UIButton, switch_btn1_path)
  self.switch_btn2 = self:AddComponent(UIButton, switch_btn2_path)
  self.atk_player_head = self:AddComponent(UICommonHead, atk_player_head_path)
  self.atk_player_name = self:AddComponent(UITextMeshProUGUIEx, atk_player_name_path)
  self.atk_player_power = self:AddComponent(UITextMeshProUGUIEx, atk_player_power_path)
  self.atk_player_blood_tip = self:AddComponent(UIImage, atk_player_blood_tip_path)
  self.def_player_head = self:AddComponent(UICommonHead, def_player_head_path)
  self.def_player_name = self:AddComponent(UITextMeshProUGUIEx, def_player_name_path)
  self.def_player_power = self:AddComponent(UITextMeshProUGUIEx, def_player_power_path)
  self.def_player_blood_tip = self:AddComponent(UIImage, def_player_blood_tip_path)
  self.def_team1 = self:AddComponent(UILWKOFCampaignTeam, def_team1_path)
  self.def_team2 = self:AddComponent(UILWKOFCampaignTeam, def_team2_path)
  self.def_team3 = self:AddComponent(UILWKOFCampaignTeam, def_team3_path)
  self.defPlayerTeamItems = {
    self.def_team1,
    self.def_team2,
    self.def_team3
  }
  self.btn_back:SetOnClick(function()
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Exit()
  end)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.v_s = self:AddComponent(UIRawImage, v_s_path)
  self.battle_btn_text:SetText(Localization:GetString("500210"))
  self.slotAreas = {}
  self.slotPos = {}
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  self.atk_team3 = self:AddComponent(UILWKOFCampaignTeam, atk_team3_path)
  self.atk_team2 = self:AddComponent(UILWKOFCampaignTeam, atk_team2_path)
  self.atk_team1 = self:AddComponent(UILWKOFCampaignTeam, atk_team1_path)
  self.slotAreasContainer = self:AddComponent(UIBaseContainer, atkPlayerTeamContainer)
  self.atkPlayerTeamItems = {
    self.atk_team1,
    self.atk_team2,
    self.atk_team3
  }
  for i = 1, 3 do
    local slotArea = self:AddComponent(UIEventTrigger, string.format(atk_team_slot_area_path, i))
    slotArea:OnPointerClick(function()
      if not self.isInDragMode then
        self:EditTeamIndex(i)
      end
    end)
    table.insert(self.slotAreas, slotArea)
  end
  self.switch_btn1:SetOnClick(function()
    self:OnSwitchBtn1Click()
  end)
  self.switch_btn2:SetOnClick(function()
    self:OnSwitchBtn2Click()
  end)
  self.battle_btn:SetSafeClickMode(true)
  self.battle_btn:SetOnClick(function()
    self:OnBattleStart()
  end)
  self.atkPlayerBloodTipCells = {}
  for i = 1, 3 do
    local cell = self:AddComponent(UIImage, atk_player_blood_cell_path .. i)
    table.insert(self.atkPlayerBloodTipCells, cell)
  end
  self.defPlayerBloodTipCells = {}
  for i = 1, 3 do
    local cell = self:AddComponent(UIImage, def_player_blood_cell_path .. i)
    table.insert(self.defPlayerBloodTipCells, cell)
  end
  self.skip_mask = self:AddComponent(UIButton, skip_mask_path)
  self.skip_mask:SetOnClick(function()
    self:OnSkipMaskClick()
  end)
  self.anim_atk = self:AddComponent(UIBaseContainer, anim_atk_path)
  self.anim = self.anim_atk.transform:GetComponent(typeof(CS.SimpleAnimation))
  self.r_pos003 = self:AddComponent(UIBaseContainer, r_pos003_path)
  self.r_pos002 = self:AddComponent(UIBaseContainer, r_pos002_path)
  self.r_pos001 = self:AddComponent(UIBaseContainer, r_pos001_path)
  self.b_pos003 = self:AddComponent(UIBaseContainer, b_pos003_path)
  self.b_pos002 = self:AddComponent(UIBaseContainer, b_pos002_path)
  self.b_pos001 = self:AddComponent(UIBaseContainer, b_pos001_path)
  self.eff_def_win = self:AddComponent(UIBaseContainer, eff_def_win_path)
  self.eff_atk_win = self:AddComponent(UIBaseContainer, eff_atk_win_path)
  self.eff_u_i_impact = self:AddComponent(UIBaseContainer, eff_u_i_impact_path)
  self.eff_u_i_card_change_1_2 = self:AddComponent(UIBaseContainer, eff_u_i_card_change_1_2_path)
  self.eff_u_i_card_change_2_3 = self:AddComponent(UIBaseContainer, eff_u_i_card_change_2_3_path)
  self.eff_u_i_card_rotate = self:AddComponent(UIBaseContainer, eff_u_i_card_rotate_path)
  self.eff_u_i_spark_battle = self:AddComponent(UIBaseContainer, eff_u_i_spark_battle_path)
  self.eff_u_i_outline_blue = self:AddComponent(UIBaseContainer, eff_u_i_outline_blue_path)
  self.eff_u_i_outline_red = self:AddComponent(UIBaseContainer, eff_u_i_outline_red_path)
  self.surprise_mask = self:AddComponent(UIImage, surprise_mask_path)
  self.surprise_node = self:AddComponent(UIImage, surprise_node_path)
  self.surprise_text = self:AddComponent(UITextMeshProUGUIEx, surprise_text_path)
  self.surprise_text:SetText(Localization:GetString("alliance_train_044"))
  self:ResetAnimState()
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.atk_team1.transform:SetParent(self.r_pos001.transform)
    self.atk_team1.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.atk_team1.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.atk_team2.transform:SetParent(self.r_pos002.transform)
    self.atk_team2.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.atk_team2.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.atk_team3.transform:SetParent(self.r_pos003.transform)
    self.atk_team3.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.atk_team3.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.def_team1.transform:SetParent(self.b_pos001.transform)
    self.def_team1.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.def_team1.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.def_team2.transform:SetParent(self.b_pos002.transform)
    self.def_team2.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.def_team2.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.def_team3.transform:SetParent(self.b_pos003.transform)
    self.def_team3.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.def_team3.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  else
    self.atk_team1.transform:SetParent(self.b_pos001.transform)
    self.atk_team1.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.atk_team1.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.atk_team2.transform:SetParent(self.b_pos002.transform)
    self.atk_team2.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.atk_team2.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.atk_team3.transform:SetParent(self.b_pos003.transform)
    self.atk_team3.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.atk_team3.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.def_team1.transform:SetParent(self.r_pos001.transform)
    self.def_team1.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.def_team1.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.def_team2.transform:SetParent(self.r_pos002.transform)
    self.def_team2.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.def_team2.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.def_team3.transform:SetParent(self.r_pos003.transform)
    self.def_team3.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.def_team3.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end
  self:LoadBgEffect()
  local time = 0
  self.maskLastClick = time
end

function UILWKOFCampaignView:DataDefine()
end

function UILWKOFCampaignView:ComponentDestroy()
  self:ClearBgEffect()
  self.def_team1.transform:SetParent(self.anim_atk.transform)
  self.def_team2.transform:SetParent(self.anim_atk.transform)
  self.def_team3.transform:SetParent(self.anim_atk.transform)
  self.atk_team1.transform:SetParent(self.anim_atk.transform)
  self.atk_team2.transform:SetParent(self.anim_atk.transform)
  self.atk_team3.transform:SetParent(self.anim_atk.transform)
  self.bg1 = nil
  self.text_title = nil
  self.btn_back = nil
  self.battle_btn = nil
  self.battle_btn_text = nil
  self.switch_btn1 = nil
  self.switch_btn2 = nil
  self.atk_player_head = nil
  self.atk_player_name = nil
  self.atk_player_power = nil
  self.atk_player_blood_tip = nil
  self.def_player_head = nil
  self.def_player_name = nil
  self.def_player_power = nil
  self.def_player_blood_tip = nil
  self.tip_text = nil
  self.v_s = nil
  self.skip_mask = nil
  self.atk_team3 = nil
  self.atk_team2 = nil
  self.atk_team1 = nil
  self.anim = nil
  self.anim_atk = nil
  self.def_team1 = nil
  self.def_team2 = nil
  self.def_team3 = nil
  self.r_pos003 = nil
  self.r_pos002 = nil
  self.r_pos001 = nil
  self.b_pos003 = nil
  self.b_pos002 = nil
  self.b_pos001 = nil
  self.eff_def_win = nil
  self.eff_atk_win = nil
  self.eff_u_i_impact = nil
  self.eff_u_i_card_change_1_2 = nil
  self.eff_u_i_card_change_2_3 = nil
  self.eff_u_i_card_rotate = nil
  self.eff_u_i_spark_battle = nil
  self.eff_u_i_outline_blue = nil
  self.eff_u_i_outline_red = nil
  self.surprise_mask = nil
  self.surprise_node = nil
  self.surprise_text = nil
  self.slotAreasContainer = nil
end

function UILWKOFCampaignView:DataDestroy()
end

function UILWKOFCampaignView:ReInit()
  self:PlayAnim(Anim.Default)
end

function UILWKOFCampaignView:LoadBgEffect()
  if self.bgEffReq then
    return
  end
  self.bgEffReq = ResourceManager:InstantiateAsync(bgEffPath)
  self.bgEffReq:completed("+", function(request)
    if self.bg1 == nil then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local transform = go.transform
    transform:SetParent(self.bg1.transform)
    transform:Set_offsetMin(0, 0)
    transform:Set_offsetMax(0, 0)
    local scaleX = CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1
    transform:Set_localScale(scaleX, 1, 1)
  end)
end

function UILWKOFCampaignView:ClearBgEffect()
  if self.bgEffReq then
    self.bgEffReq:Destroy()
    self.bgEffReq = nil
  end
end

function UILWKOFCampaignView:Refresh()
  self.opponentData = DataCenter.LWKOFBattleManager.opponentData
  if not self.opponentData then
    return
  end
  self.opponentPlayerInfo = self.opponentData.playerInfo
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(self.opponentPlayerInfo.headSkinId, self.opponentPlayerInfo.headSkinET, false)
  self.def_player_head:SetData(self.opponentPlayerInfo.uid, self.opponentPlayerInfo.pic, self.opponentPlayerInfo.picver, nil, headFramePath)
  local name = UIUtil.FormatServerAllianceName(self.opponentPlayerInfo.srcServer, self.opponentPlayerInfo.abbr, self.opponentPlayerInfo.name)
  self.def_player_name:SetText(name)
  self.def_player_power:SetText(string.GetFormattedStr(self.opponentData.power))
  self.opponentDefTeams = {}
  for i = 1, 3 do
    local defenceTeam = DataCenter.LWKOFBattleManager:GetOpponentDefenceTeam(i)
    table.insert(self.opponentDefTeams, defenceTeam)
  end
  local selfUid = LuaEntry.Player.uid
  local selfPic = LuaEntry.Player.pic
  local selfPicVer = LuaEntry.Player.picVer
  local headFrame = LuaEntry.Player:GetHeadBgImg()
  self.atk_player_head:SetData(selfUid, selfPic, selfPicVer, nil, headFrame)
  local selfAllianceAbbr
  if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    selfAllianceAbbr = data.abbr
  end
  name = UIUtil.FormatServerAllianceName(LuaEntry.Player:GetSourceServerId(), selfAllianceAbbr, LuaEntry.Player.name)
  self.atk_player_name:SetText(name)
  local myPower = DataCenter.LWKOFBattleManager:GetAtkTeamPower()
  self.atk_player_power:SetText(string.GetFormattedStr(myPower))
  self.atkTeams = {}
  for i = 1, 3 do
    local atkTeam = DataCenter.LWKOFBattleManager:GetAtkTeamByIndex(i)
    table.insert(self.atkTeams, atkTeam)
  end
  for i = 1, 3 do
    local defTeam = self.opponentDefTeams[i]
    local atkTeam = self.atkTeams[i]
    local atkTeamPower = 0
    local defTeamPower = 0
    if atkTeam then
      atkTeamPower = atkTeam:GetTotalCapacity()
    end
    if defTeam then
      defTeamPower = defTeam.power
    end
    if defTeam then
      local heroesUuid = defTeam:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = defTeam:GetHeroDataByUuid(uuid)
        heroesData[index] = heroData
      end
      local dominatorData = defTeam:GetDominatorData()
      if dominatorData then
        heroesData[ArmyFormationSlot.Dominator] = dominatorData
      end
      local teamPowerColor = atkTeamPower <= defTeamPower and "#FF7676" or "#FFFFFF"
      local teamPowerStr = string.format("<color=%s>%s</color>", teamPowerColor, string.GetFormattedStr(defTeamPower))
      self.defPlayerTeamItems[i]:SetData(heroesData, teamPowerStr, i)
    else
      self.defPlayerTeamItems[i]:SetData(nil, nil, i)
    end
    if atkTeam then
      local heroesUuid = atkTeam:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = {}
        heroData.heroUuid = uuid
        heroesData[index] = heroData
      end
      local dominatorUuid = atkTeam:GetLocalDominatorUuid()
      if dominatorUuid and 0 < dominatorUuid then
        local heroData = {}
        heroData.heroUuid = dominatorUuid
        heroesData[ArmyFormationSlot.Dominator] = heroData
      end
      self.atkPlayerTeamItems[i]:SetData(heroesData, string.GetFormattedStr(atkTeamPower), i)
    else
      self.atkPlayerTeamItems[i]:SetData(nil, nil, i)
    end
  end
end

function UILWKOFCampaignView:EditTeamIndex(index)
  self.ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.KOFBattleSwitchTeam, index)
end

function UILWKOFCampaignView:OnBeginDragHeroSlot(eventData, index)
  if self.dragingIndex then
    return
  end
  self.isInDragMode = true
  self.dragingIndex = index
  self.lastDragPosX = eventData.position.x
  self.lastDragPosY = eventData.position.y
  self.slotAreas[index].transform:SetAsFirstSibling()
end

function UILWKOFCampaignView:ResetDragAreaPos()
end

function UILWKOFCampaignView:SwitchTeamSlot(fromIndex, toIndex)
  DataCenter.LWKOFBattleManager:SwitchAtkTeam(fromIndex, toIndex)
end

function UILWKOFCampaignView:OnDragEndHeroSlot(eventData, index)
  if self.isInDragMode and self.dragingIndex == index then
    if self.toSwitchIndex then
      self:SwitchTeamSlot(self, self.dragingIndex, self.toSwitchIndex)
      self:Refresh()
    end
    self:ResetDragAreaPos()
    self.isInDragMode = false
    self.dragingIndex = nil
    self.toSwitchIndex = nil
    self.lastDragPosX = nil
    self.lastDragPosY = nil
  end
end

function UILWKOFCampaignView:OnDragHeroSlot(eventData, index)
  if self.isInDragMode and self.dragingIndex == index then
    local curPosX = eventData.position.x
    local curPosY = eventData.position.y
    self.lastDragPosX = curPosX
    self.lastDragPosY = curPosY
    local uiPos = PosConverse.ScreenToUIPos(self.slotAreasContainer.rectTransform, Vector2.New(curPosX, curPosY))
    self.slotAreas[index].transform.localPosition = Vector3.New(uiPos.x, uiPos.y)
    self.atkPlayerTeamItems[index].transform.localPosition = Vector3.New(uiPos.x, uiPos.y)
    local areaCenterPos = PosConverse.UIWorldToScreenPos(self.slotAreas[index].transform.position)
    local pos = Vector2.New(areaCenterPos.x, areaCenterPos.y)
    local rtScreenPos = pos
    if rtScreenPos.x < -8 or rtScreenPos.x > self.screenWidth + 8 then
      self:OnDragEndHeroSlot(eventData, self.dragingIndex)
      return
    end
    if rtScreenPos.y < -8 or rtScreenPos.y > self.screenHeight + 8 then
      self:OnDragEndHeroSlot(eventData, self.dragingIndex)
      return
    end
  end
end

function UILWKOFCampaignView:SlotMoveToIndex(index, dstIndex, time)
  local animTime = time or 0.2
  if animTime <= 0 then
    local slot = self.atkPlayerTeamItems[index]
    if slot then
      slot.transform.position = self.slotPos[dstIndex]
    end
  else
    local slot = self.atkPlayerTeamItems[index]
    if slot then
      local pos = self.slotPos[dstIndex]
      slot.transform:DOMove(pos, animTime)
    end
  end
end

function UILWKOFCampaignView:OnPointerEnterHeroSlot(eventData, index)
  if not self.isInDragMode then
    return
  end
  if self.isInDragMode and self.dragingIndex == index then
    return
  end
  if self.toSwitchIndex then
    return
  end
  self.toSwitchIndex = index
  self:SlotMoveToIndex(self.toSwitchIndex, self.dragingIndex)
end

function UILWKOFCampaignView:OnPointerExitHeroSlot(eventData, index)
  if not self.isInDragMode then
    return
  end
  if self.isInDragMode and self.dragingIndex == index then
    return
  end
  if self.toSwitchIndex ~= index then
    return
  end
  self:SlotMoveToIndex(self, self.toSwitchIndex, self.toSwitchIndex)
  self.toSwitchIndex = nil
end

function UILWKOFCampaignView:OnBattleStart()
  local needBlock = DataCenter.LWKOFBattleManager:StartBattle()
  if needBlock then
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 4)
  end
end

function UILWKOFCampaignView:OnBattleError()
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
end

function UILWKOFCampaignView:OnBattleFinish(msg)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  self:PlayBattle(msg)
end

function UILWKOFCampaignView:OnRobTrainTryRefreshView(uuid)
  if self.opponentData and self.opponentData.trainData and self.opponentData.trainData.uuid == uuid then
    self:Refresh()
  end
end

function UILWKOFCampaignView:ResetAnimState()
  self:ClearBattleSequence()
  self.switch_btn1:SetActive(true)
  self.switch_btn2:SetActive(true)
  self.battle_btn:SetActive(true)
  for k, v in pairs(self.slotAreas) do
    v:SetActive(true)
  end
  for k, v in pairs(self.defPlayerBloodTipCells) do
    v:SetActive(true)
    v:SetLocalScaleXYZ(1, 1, 1)
    v:SetAlpha(1)
  end
  for k, v in pairs(self.atkPlayerBloodTipCells) do
    v:SetActive(true)
    v:SetLocalScaleXYZ(1, 1, 1)
    v:SetAlpha(1)
  end
  self.skip_mask:SetActive(false)
  for i = 1, 3 do
    self.atkPlayerTeamItems[i]:SetLocalScaleXYZ(1, 1, 1)
    self.atkPlayerTeamItems[i]:SetGray(false)
    self.defPlayerTeamItems[i]:SetLocalScaleXYZ(1, 1, 1)
    self.defPlayerTeamItems[i]:SetGray(false)
  end
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  self:ResetDragAreaPos()
  self.v_s:SetActive(false)
  self.eff_atk_win:SetActive(false)
  self.eff_def_win:SetActive(false)
  self.eff_u_i_impact:SetActive(false)
  self.eff_u_i_card_change_1_2:SetActive(false)
  self.eff_u_i_card_change_2_3:SetActive(false)
  self.eff_u_i_card_rotate:SetActive(false)
  self.eff_u_i_spark_battle:SetActive(false)
  self.eff_u_i_outline_blue:SetActive(false)
  self.eff_u_i_outline_red:SetActive(false)
  self.surprise_mask:SetActive(false)
  self.surprise_node:SetActive(false)
end

function UILWKOFCampaignView:PlayBattle(msg)
  self.battleMsg = msg
  self.isWin = msg.isWin
  self.switch_btn1:SetActive(false)
  self.switch_btn2:SetActive(false)
  self.battle_btn:SetActive(false)
  self.skip_mask:SetActive(true)
  local battleArray = msg.battleArr
  local battleCount = #battleArray
  local battleQueue = {}
  local defNo = 0
  local atkNo = 0
  local defDefaultArray = msg.defTeamNo
  self.defDefaultArray = defDefaultArray
  self.defDefaultMap = {}
  for i, v in ipairs(defDefaultArray) do
    if 0 < v then
      self.defDefaultMap[v] = i
    end
  end
  local defTeamIndex = 1
  self.finialAtkLoseNoMap = {}
  self.finialDefLoseNoMap = {}
  self.atkKillMap = {}
  self.defKillMap = {}
  if battleCount == 0 and self.isWin then
    self.finialDefLoseNoMap[1] = true
    self.finialDefLoseNoMap[2] = true
    self.finialDefLoseNoMap[3] = true
    self.atkKillMap[1] = 3
    table.insert(battleQueue, {
      1,
      3,
      1
    })
    self.battleQueue = battleQueue
    self.maskLastClick = 0
    self:SkipBattleAnim()
    return
  end
  for i, v in ipairs(battleArray) do
    local atkTeam = v.ownerTeam
    local defTeam = v.otherTeam
    if 0 < #defTeam and 0 < #atkTeam then
      local atkTeamNo = atkTeam[1].teamNo
      local defTeamNo = defTeam[1].teamNo
      table.insert(battleQueue, {atkTeamNo, defTeamNo})
      if defNo ~= defTeamNo then
        defNo = defTeamNo
        if i == battleCount then
          local attackResult = self.isWin and 1 or 0
          battleQueue[#battleQueue][3] = attackResult
          battleQueue[#battleQueue][4] = i
          if self.isWin then
            self.finialDefLoseNoMap[defNo] = true
            if self.atkKillMap[atkTeamNo] then
              self.atkKillMap[atkTeamNo] = self.atkKillMap[atkTeamNo] + 1
            else
              self.atkKillMap[atkTeamNo] = 1
            end
          else
            self.finialAtkLoseNoMap[atkTeamNo] = true
            if self.defKillMap[defNo] then
              self.defKillMap[defNo] = self.defKillMap[defNo] + 1
            else
              self.defKillMap[defNo] = 1
            end
          end
        end
        if 1 < i then
          battleQueue[#battleQueue - 1][3] = 1
          battleQueue[#battleQueue - 1][4] = i - 1
          local lastDefNo = battleQueue[#battleQueue - 1][2]
          self.finialDefLoseNoMap[lastDefNo] = true
          local lastAtkNo = battleQueue[#battleQueue - 1][1]
          if self.atkKillMap[lastAtkNo] then
            self.atkKillMap[lastAtkNo] = self.atkKillMap[lastAtkNo] + 1
          else
            self.atkKillMap[lastAtkNo] = 1
          end
        end
        local defIndex = self.defDefaultMap[defTeamNo]
        if defIndex == defTeamIndex then
          defTeamIndex = defTeamIndex + 1
        elseif defIndex > defTeamIndex then
          for j = defTeamIndex, defIndex - 1 do
            local tmpDefNo = self.defDefaultArray[j]
            local value = {
              atkTeamNo,
              tmpDefNo,
              1
            }
            local count = #battleQueue
            table.insert(battleQueue, count, value)
            self.finialDefLoseNoMap[tmpDefNo] = true
            if self.atkKillMap[atkTeamNo] then
              self.atkKillMap[atkTeamNo] = self.atkKillMap[atkTeamNo] + 1
            else
              self.atkKillMap[atkTeamNo] = 1
            end
          end
          defTeamIndex = defIndex + 1
        end
      elseif atkNo ~= atkTeamNo then
        atkNo = atkTeamNo
        if i == battleCount then
          local attackResult = self.isWin and 1 or 0
          battleQueue[#battleQueue][3] = attackResult
          battleQueue[#battleQueue][4] = i
          if not self.isWin then
            self.finialAtkLoseNoMap[atkNo] = true
            if self.defKillMap[defNo] then
              self.defKillMap[defNo] = self.defKillMap[defNo] + 1
            else
              self.defKillMap[defNo] = 1
            end
          else
            self.finialDefLoseNoMap[defNo] = true
            if self.atkKillMap[atkTeamNo] then
              self.atkKillMap[atkTeamNo] = self.atkKillMap[atkTeamNo] + 1
            else
              self.atkKillMap[atkTeamNo] = 1
            end
          end
        end
        if 1 < i then
          battleQueue[#battleQueue - 1][3] = 0
          battleQueue[#battleQueue - 1][4] = i - 1
          local lastAtkNo = battleQueue[#battleQueue - 1][1]
          self.finialAtkLoseNoMap[lastAtkNo] = true
          local lastDefNo = battleQueue[#battleQueue - 1][2]
          if self.defKillMap[lastDefNo] then
            self.defKillMap[lastDefNo] = self.defKillMap[lastDefNo] + 1
          else
            self.defKillMap[lastDefNo] = 1
          end
        end
      end
    end
  end
  if defTeamIndex <= 3 and self.isWin then
    local last = battleQueue[#battleQueue]
    local atkTeamNo = last[1]
    for j = defTeamIndex, 3 do
      local defTeamNo = self.defDefaultArray[j]
      local value = {
        atkTeamNo,
        defTeamNo,
        1
      }
      table.insert(battleQueue, value)
      self.finialDefLoseNoMap[defTeamNo] = true
    end
  end
  self.battleQueue = battleQueue
  local startTeamChange = msg.randomDefence or false
  self:ClearBattleSequence()
  if self.opponentData ~= nil and self.opponentData.trainData ~= nil and self.opponentData.isTruckQuickRob then
    self.maskLastClick = 0
    self:SkipBattleAnim()
    return
  end
  self.atkLoseNo = {}
  self.defLoseNo = {}
  local defRemainBlood = 3
  local atkRemainBlood = 3
  self.battleSequence = CS.DG.Tweening.DOTween.Sequence()
  if startTeamChange then
    self.surprise_mask:SetActive(true)
    self.surprise_node:SetActive(true)
    self.battleSequence:AppendInterval(1)
    self.battleSequence:AppendCallback(function()
      self.surprise_mask:SetActive(false)
      self.surprise_node:SetActive(false)
      local animName = CommonUtil.IsArabicAutoMirrorOpen() and Anim.BlueRandom or Anim.Random
      self:PlayAnim(animName)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_team_random, false)
    end)
    self.battleSequence:AppendInterval(0.6)
    self.battleSequence:AppendCallback(function()
      for i = 1, 3 do
        local no = defDefaultArray[i] or 0
        if 0 < no then
          self:SetDefTeam(i, no)
        end
      end
    end)
    self.battleSequence:AppendInterval(0.6)
    self.battleSequence:AppendCallback(function()
      self.v_s:SetActive(true)
      self.eff_u_i_spark_battle:SetActive(true)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_vs, false)
    end)
  else
    self.v_s:SetActive(true)
    self.eff_u_i_spark_battle:SetActive(true)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_vs, false)
  end
  self.battleSequence:AppendInterval(1)
  for i, v in ipairs(self.battleQueue) do
    self.battleSequence:AppendCallback(function()
      self:PlayAnim(Anim.Impact)
    end)
    self.battleSequence:AppendInterval(0.4)
    self.battleSequence:AppendCallback(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_team_fight, false)
    end)
    self.battleSequence:AppendInterval(0.7)
    self.battleSequence:AppendCallback(function()
      local isWin = v[3] == 1
      if isWin then
        self.defPlayerTeamItems[1]:SetGray(true)
        self.defLoseNo[v[2]] = true
      else
        self.atkPlayerTeamItems[1]:SetGray(true)
        self.atkLoseNo[v[1]] = true
      end
    end)
    self.battleSequence:AppendInterval(0.1)
    self.battleSequence:AppendCallback(function()
      local isWin = v[3] == 1
      if isWin then
        local eff = self.eff_atk_win
        eff:SetActive(false)
        eff:SetActive(true)
      else
        local eff = self.eff_def_win
        eff:SetActive(false)
        eff:SetActive(true)
      end
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_team_victory, false)
    end)
    self.battleSequence:AppendInterval(1)
    self.battleSequence:AppendCallback(function()
      local bloodCell
      local isWin = v[3] == 1
      if isWin then
        bloodCell = self.defPlayerBloodTipCells[defRemainBlood]
        defRemainBlood = defRemainBlood - 1
      else
        bloodCell = self.atkPlayerBloodTipCells[atkRemainBlood]
        atkRemainBlood = atkRemainBlood - 1
      end
      if bloodCell then
        bloodCell.transform:DOScale(Vector3(1.6, 1.6, 1), 0.1)
        bloodCell.unity_image:DOFade(0, 0.1)
      end
      if i < #self.battleQueue then
        if isWin then
          local animName = CommonUtil.IsArabicAutoMirrorOpen() and Anim.BlueDown or Anim.RedDown
          self:PlayAnim(animName)
        else
          local animName = CommonUtil.IsArabicAutoMirrorOpen() and Anim.RedDown or Anim.BlueDown
          self:PlayAnim(animName)
        end
      end
    end)
    if i < #self.battleQueue then
      self.battleSequence:AppendInterval(0.75)
    end
    self.battleSequence:AppendCallback(function()
      if i < #self.battleQueue then
        local next = i + 1
        local nextQueue = self.battleQueue[next]
        local isWin = v[3] == 1
        if isWin then
          local nextNo = nextQueue[2]
          local nextIndex = self.defDefaultMap[nextNo]
          local nextIndex2 = nextIndex + 1
          if 3 < nextIndex2 then
            nextIndex2 = nextIndex2 - 3
          end
          local nextIndex3 = nextIndex + 2
          if 3 < nextIndex3 then
            nextIndex3 = nextIndex3 - 3
          end
          self:SetDefTeam(1, nextNo, true)
          self:SetDefTeam(2, self.defDefaultArray[nextIndex2], true)
          self:SetDefTeam(3, self.defDefaultArray[nextIndex3], true)
          local eff = self.eff_u_i_outline_red
          eff:SetActive(false)
          eff:SetActive(true)
        else
          local nextNo = nextQueue[1]
          local nextIndex = nextNo
          local nextIndex2 = nextIndex + 1
          if 3 < nextIndex2 then
            nextIndex2 = nextIndex2 - 3
          end
          local nextIndex3 = nextIndex + 2
          if 3 < nextIndex3 then
            nextIndex3 = nextIndex3 - 3
          end
          self:SetAtkTeam(1, nextNo, true)
          self:SetAtkTeam(2, nextIndex2, true)
          self:SetAtkTeam(3, nextIndex3, true)
          local eff = self.eff_u_i_outline_blue
          eff:SetActive(false)
          eff:SetActive(true)
        end
      end
      self:PlayAnim(Anim.Default)
    end)
    self.battleSequence:AppendInterval(0.5)
  end
  self.battleSequence:AppendCallback(function()
    DataCenter.LWKOFBattleManager:OpenBattleResultView(self.battleMsg, self.finialAtkLoseNoMap, self.finialDefLoseNoMap, self.atkKillMap, self.defKillMap)
  end)
end

function UILWKOFCampaignView:OnSkipMaskClick()
  local time = Time.realtimeSinceStartup
  if time - self.maskLastClick < 0.5 then
    self.maskLastClick = 0
    self:SkipBattleAnim()
  end
  self.maskLastClick = time
end

function UILWKOFCampaignView:SkipBattleAnim()
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  self:ClearBattleSequence()
  self.switch_btn1:SetActive(false)
  self.switch_btn2:SetActive(false)
  self.battle_btn:SetActive(false)
  self.skip_mask:SetActive(false)
  self.eff_atk_win:SetActive(false)
  self.eff_def_win:SetActive(false)
  self.eff_u_i_impact:SetActive(false)
  self.eff_u_i_card_change_1_2:SetActive(false)
  self.eff_u_i_card_change_2_3:SetActive(false)
  self.eff_u_i_card_rotate:SetActive(false)
  self.eff_u_i_spark_battle:SetActive(false)
  self.eff_u_i_outline_blue:SetActive(false)
  self.eff_u_i_outline_red:SetActive(false)
  self.surprise_mask:SetActive(false)
  self.surprise_node:SetActive(false)
  self:PlayAnim(Anim.Default)
  if not self.battleQueue then
    return
  end
  local battleCount = #self.battleQueue
  if battleCount < 1 then
    return
  end
  for i = 1, 3 do
    self.atkPlayerTeamItems[i]:SetLocalScaleXYZ(1, 1, 1)
    self.defPlayerTeamItems[i]:SetLocalScaleXYZ(1, 1, 1)
  end
  self:ResetDragAreaPos()
  local finialQueue = self.battleQueue[battleCount]
  local finialDefNo = finialQueue[2]
  local finialDefIndex = self.defDefaultMap[finialDefNo]
  local finialDefIndex2 = finialDefIndex + 1
  if 3 < finialDefIndex2 then
    finialDefIndex2 = finialDefIndex2 - 3
  end
  local finialDefIndex3 = finialDefIndex + 2
  if 3 < finialDefIndex3 then
    finialDefIndex3 = finialDefIndex3 - 3
  end
  self:SetDefTeam(1, finialDefNo, true, true)
  self:SetDefTeam(2, self.defDefaultArray[finialDefIndex2], true, true)
  self:SetDefTeam(3, self.defDefaultArray[finialDefIndex3], true, true)
  local defLoseCount = table.count(self.finialDefLoseNoMap)
  local defBlood = 3
  for i = 1, defLoseCount do
    local bloodCell = self.defPlayerBloodTipCells[defBlood]
    defBlood = defBlood - 1
    bloodCell.transform:DOScale(Vector3(1.6, 1.6, 1), 0.1)
    bloodCell.unity_image:DOFade(0, 0.1)
  end
  local finialAtkNo = finialQueue[1]
  local finialAtkIndex = finialAtkNo
  local finialAtkIndex2 = finialAtkIndex + 1
  if 3 < finialAtkIndex2 then
    finialAtkIndex2 = finialAtkIndex2 - 3
  end
  local finialAtkIndex3 = finialAtkIndex + 2
  if 3 < finialAtkIndex3 then
    finialAtkIndex3 = finialAtkIndex3 - 3
  end
  self:SetAtkTeam(1, finialAtkNo, true, true)
  self:SetAtkTeam(2, finialAtkIndex2, true, true)
  self:SetAtkTeam(3, finialAtkIndex3, true, true)
  local atkLoseCount = table.count(self.finialAtkLoseNoMap)
  local atkBlood = 3
  for i = 1, atkLoseCount do
    local bloodCell = self.atkPlayerBloodTipCells[atkBlood]
    atkBlood = atkBlood - 1
    bloodCell.transform:DOScale(Vector3(1.6, 1.6, 1), 0.1)
    bloodCell.unity_image:DOFade(0, 0.1)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 4)
  self.battleSequence = CS.DG.Tweening.DOTween.Sequence()
  self.battleSequence:AppendInterval(0.5)
  self.battleSequence:AppendCallback(function()
    DataCenter.LWKOFBattleManager:OpenBattleResultView(self.battleMsg, self.finialAtkLoseNoMap, self.finialDefLoseNoMap, self.atkKillMap, self.defKillMap)
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
  end)
end

function UILWKOFCampaignView:SetAtkTeam(index, teamNo, setGray, setFinialGray)
  if 0 < teamNo then
    local atkTeam = self.atkTeams[teamNo]
    if atkTeam then
      local atkTeamPower = atkTeam:GetTotalCapacity()
      local heroesUuid = atkTeam:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = {}
        heroData.heroUuid = uuid
        heroesData[index] = heroData
      end
      local dominatorUuid = atkTeam:GetLocalDominatorUuid()
      if dominatorUuid and 0 < dominatorUuid then
        local heroData = {}
        heroData.heroUuid = dominatorUuid
        heroesData[ArmyFormationSlot.Dominator] = heroData
      end
      self.atkPlayerTeamItems[index]:SetData(heroesData, string.GetFormattedStr(atkTeamPower), teamNo)
    else
      self.atkPlayerTeamItems[index]:SetData(nil, nil, teamNo)
    end
    if setFinialGray then
      local lose = self.finialAtkLoseNoMap[teamNo]
      if lose then
        self.atkPlayerTeamItems[index]:SetGray(true)
      end
      return
    end
    if setGray then
      local lose = self.atkLoseNo[teamNo]
      if lose then
        self.atkPlayerTeamItems[index]:SetGray(true)
      end
    end
  end
end

function UILWKOFCampaignView:RefreshAtkTeamHp(index, heroes)
  if not self.battleQueue then
    return
  end
  self.atkPlayerTeamItems[index]:RefreshHp(heroes)
end

function UILWKOFCampaignView:SetDefTeam(index, teamNo, setGray, setFinialGray)
  if 0 < teamNo then
    local defTeam = self.opponentDefTeams[teamNo]
    if defTeam then
      local defTeamPower = defTeam.power
      local heroesUuid = defTeam:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = defTeam:GetHeroDataByUuid(uuid)
        heroesData[index] = heroData
      end
      local dominatorData = defTeam:GetDominatorData()
      if dominatorData then
        heroesData[ArmyFormationSlot.Dominator] = dominatorData
      end
      self.defPlayerTeamItems[index]:SetData(heroesData, string.GetFormattedStr(defTeamPower), teamNo)
    else
      self.defPlayerTeamItems[index]:SetData(nil, nil, teamNo)
    end
  end
  if setFinialGray then
    local lose = self.finialDefLoseNoMap[teamNo]
    if lose then
      self.defPlayerTeamItems[index]:SetGray(true)
    end
    return
  end
  if setGray then
    local lose = self.defLoseNo[teamNo]
    if lose then
      self.defPlayerTeamItems[index]:SetGray(true)
    end
  end
end

function UILWKOFCampaignView:RefreshDefTeamHp(index, heroes)
  if not self.battleQueue then
    return
  end
  self.defPlayerTeamItems[index]:RefreshHp(heroes)
end

function UILWKOFCampaignView:ClearBattleSequence()
  if self.battleSequence then
    self.battleSequence:Kill()
    self.battleSequence = nil
  end
end

function UILWKOFCampaignView:OnSwitchBtn1Click()
  if self.anim then
    self:Refresh()
    DataCenter.LWKOFBattleManager:SwitchAtkTeam(1, 2)
    local animName = CommonUtil.IsArabicAutoMirrorOpen() and Anim.RedChange1 or Anim.Change1
    self:PlayAnim(animName)
    self:ClearBattleSequence()
    self.eff_u_i_card_change_2_3:SetActive(false)
    self.battleSequence = CS.DG.Tweening.DOTween.Sequence()
    self.battleSequence:AppendInterval(0.28)
    self.battleSequence:AppendCallback(function()
      self:Refresh()
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_change_position, false)
  else
    DataCenter.LWKOFBattleManager:SwitchAtkTeam(1, 2)
    self:Refresh()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_change_position, false)
  end
end

function UILWKOFCampaignView:OnSwitchBtn2Click()
  if self.anim then
    self:Refresh()
    DataCenter.LWKOFBattleManager:SwitchAtkTeam(2, 3)
    local animName = CommonUtil.IsArabicAutoMirrorOpen() and Anim.RedChange2 or Anim.Change2
    self:PlayAnim(animName)
    self:ClearBattleSequence()
    self.eff_u_i_card_change_1_2:SetActive(false)
    self.battleSequence = CS.DG.Tweening.DOTween.Sequence()
    self.battleSequence:AppendInterval(0.28)
    self.battleSequence:AppendCallback(function()
      self:Refresh()
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_change_position, false)
  else
    DataCenter.LWKOFBattleManager:SwitchAtkTeam(2, 3)
    self:Refresh()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.battle_change_position, false)
  end
end

function UILWKOFCampaignView:PlayAnim(name)
  if self.anim then
    self.anim:Rewind(name)
    self.anim:Play(name)
  end
end

return UILWKOFCampaignView
