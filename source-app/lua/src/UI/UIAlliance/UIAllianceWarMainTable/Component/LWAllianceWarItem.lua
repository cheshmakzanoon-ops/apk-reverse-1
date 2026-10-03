local LWAllianceWarItem = BaseClass("LWAllianceWarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWAllianceWarPlayerItem = require("UI.UIAlliance.UIAllianceWarMainTable.Component.LWAllianceWarPlayerItem")
local LWAllianceWarPlayerHead = require("UI.UIAlliance.UIAllianceWarMainTable.Component.LWAllianceWarPlayerHead")
local AllianceWarMemberShow = {
  ownerName = "",
  leader = false,
  cancel = false,
  status = MarchStatus.DEFAULT,
  endTime = 0,
  startTime = 0
}
local OnePlayerData = DataClass("OnePlayerData", AllianceWarMemberShow)
local show_btn_path = "team_holder/showBtn"
local hide_btn_path = "team_holder/hideBtn"
local cancel_btn_path = "team_holder/cancelBtn"
local left_name_path = "team_holder/leftHead/nameTxt"
local left_playerHead_path = "team_holder/leftHead/UIPlayerHead"
local time_txt_path = "team_holder/leftHead/timeTxt"
local right_name_path = "team_holder/rightHead/rNameTxt"
local right_playerHead_path = "team_holder/rightHead/rHeadIcon"
local right_pos_txt_path = "team_holder/rightHead/posTxt"
local player_head_path = "team_holder/playerHeadHolder/playerHead/player"
local player_head_txt_ptah = "team_holder/playerNumTxt"
local player_join_btn_path = "team_holder/playerHeadHolder/playerJoinBtn"
local join_holder_path = "join_holder"
local join_btn_path = "join_holder/joinBtn"
local join_txt_path = "join_holder/joinTxt"
local member_holder_path = "member_holder"
local member_path = "member_holder/member"
local t_bg_path = "team_holder/t_bg"
local l_bg_path = "team_holder/leftHead/l_bg"
local defense_tex_path = "team_holder/rightHead/defenseTex"
local defense_img_path = "team_holder/rightHead/defenseTex/defenseImg"
local j_bg_path = "join_holder/j_bg"
local attack_mini_icon = "Assets/Main/Sprites/UI/UILWAlliance/lyp_tongmengjijie_jingong.png"
local defence_mini_icon = "Assets/Main/Sprites/UI/UILWAlliance/lyp_tongmengjijie_fangshou.png"
local attack_bg1 = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_tiao_1.png"
local defence_bg1 = "Assets/Main/Sprites/UI/UILWAlliance/lyp_tongmengjijie_tiao.png"
local hp_path = "team_holder/hp"
local hp_slier_path = "team_holder/hp/back/slider"
local hp_text_path = "team_holder/hp/back/hpDes"
local r_lv_txt_path = "team_holder/rightHead/rLVTxt"
local new_icon_path = "team_holder/newIcon"

function LWAllianceWarItem:OnCreate()
  base.OnCreate(self)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancel_btn:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.show_btn = self:AddComponent(UIButton, show_btn_path)
  self.show_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.show_btn:SetActive(true)
  self.hide_btn = self:AddComponent(UIButton, hide_btn_path)
  self.hide_btn:SetOnClick(function()
    self:OnHideClick()
  end)
  self.hide_btn:SetActive(false)
  self.left_name = self:AddComponent(UIText, left_name_path)
  self.left_playerHead = self:AddComponent(UICommonHead, left_playerHead_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.right_name = self:AddComponent(UIText, right_name_path)
  self.right_playerHead = self:AddComponent(UIImage, right_playerHead_path)
  self.right_pos_txt = self:AddComponent(UIText, right_pos_txt_path)
  self.right_pos_btn = self:AddComponent(UIButton, right_pos_txt_path)
  self.right_pos_btn:SetOnClick(function()
    self:JumpToRightPointId()
  end)
  self.player_head_list = {}
  for i = 1, 4 do
    self.player_head_list[i] = self:AddComponent(LWAllianceWarPlayerHead, player_head_path .. i)
  end
  self.player_head_txt = self:AddComponent(UIText, player_head_txt_ptah)
  self.join_holder = self:AddComponent(UIBaseContainer, join_holder_path)
  self.join_holder:SetActive(false)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(function()
    self:OnJoinClick()
  end)
  self.join_txt = self:AddComponent(UIText, join_txt_path)
  self.join_txt:SetText(Localization:GetString("110007"))
  self.member_holder = self:AddComponent(UIBaseContainer, member_holder_path)
  self.member_holder:SetActive(false)
  self.member_list = {}
  self._timer_alliance = nil
  
  function self._timer_action(temp)
    self:UpdateSlider()
  end
  
  self.t_bg = self:AddComponent(UIImage, t_bg_path)
  self.l_bg = self:AddComponent(UIImage, l_bg_path)
  self.defense_tex = self:AddComponent(UIText, defense_tex_path)
  self.defense_img = self:AddComponent(UIImage, defense_img_path)
  self.buffIcon = self:AddComponent(UIImage, "team_holder/rightHead/buffTxt/buffIcon")
  self.buffTxt = self:AddComponent(UIText, "team_holder/rightHead/buffTxt")
  self.starNumTxt = self:AddComponent(UIText, "team_holder/rightHead/activityStar")
  self.starIcon = self:AddComponent(UIImage, "team_holder/rightHead/activityStar/starIcon")
  self.j_bg = self:AddComponent(UIImage, j_bg_path)
  self.hp_obj = self:AddComponent(UIBaseContainer, hp_path)
  self.hp_obj:SetActive(false)
  self.hp_slider = self:AddComponent(UIBaseContainer, hp_slier_path)
  self.hp_des_text = self:AddComponent(UIText, hp_text_path)
  self.hp_slider_size = self.hp_slider:GetSizeDelta()
  self.shareBtn = self:AddComponent(UIButton, "team_holder/leftHead/shareBtn")
  self.shareBtn:SetOnClick(function()
    if self:GetIsCanShare() then
      if not self.shareParam then
        self:GetShareParam()
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, self.shareParam)
    end
  end)
  self.r_lv_txt = self:AddComponent(UIText, r_lv_txt_path)
  self.newIconGO = self.transform:Find(new_icon_path).gameObject
  self.newIconGO:SetActive(false)
  self.lightOnBtn = self:TryAddComponent(UIButton, "team_holder/leftHead/lightOn")
  if self.lightOnBtn then
    self.lightOnBtn:SetOnClick(function()
      UIUtil.ShowTipsId("season4_tips121")
    end)
    self.lightOnBtn:SetActive(false)
  end
end

function LWAllianceWarItem:GetShareParam()
  self.shareParam = {}
  self.shareParam.post = PostType.Alliance_War
  self.shareParam.targetUid = self.uuid
end

function LWAllianceWarItem:OnRecycle()
end

function LWAllianceWarItem:OnDestroy()
  self.uuid = nil
  self.dateUpdateTime = nil
  self.cancel_btn = nil
  self.show_btn = nil
  self.hide_btn = nil
  self.left_name = nil
  self.left_playerHead = nil
  self.time_txt = nil
  self.right_name = nil
  self.right_playerHead = nil
  self.right_pos_txt = nil
  self.player_head_list = nil
  self.player_head_txt = nil
  self.join_holder = nil
  self.join_btn = nil
  self.member_holder = nil
  if self._timer_alliance ~= nil then
    self._timer_alliance:Stop()
    self._timer_alliance = nil
  end
  self.t_bg = nil
  self.l_bg = nil
  self.defense_tex = nil
  self.defense_img = nil
  self.j_bg = nil
  self.shareBtn = nil
  self.r_lv_txt = nil
  self.playerList = nil
  self.member_list = nil
  if self.hp_obj then
    self.hp_obj:SetActive(false)
  end
  if self.hp_slider_size and self.hp_slider then
    self.hp_slider:SetSizeDelta(self.hp_slider_size)
  end
  self.hp_obj = nil
  self.hp_slider_size = nil
  self.hp_slider = nil
  self.hp_des_text = nil
  base.OnDestroy(self)
end

function LWAllianceWarItem:OnEnable()
  base.OnEnable(self)
  self.waitRallyLimitCallback = false
end

function LWAllianceWarItem:OnDisable()
  self.waitRallyLimitCallback = false
  base.OnDisable(self)
end

function LWAllianceWarItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceJoinRallyLimit, self.OnJoinRallyLimit)
end

function LWAllianceWarItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceJoinRallyLimit, self.OnJoinRallyLimit)
end

function LWAllianceWarItem:JumpToRightPointId()
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if self.dataInfo ~= nil and self.dataInfo.rightPointId ~= nil and self.dataInfo.rightPointId ~= 0 then
    local uuid = self.uuid
    GoToUtil.CloseAllWindows()
    local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
    local rightPos = SceneUtils.TileIndexToWorld(self.dataInfo.rightPointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(rightPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, info.server, info.worldId, info.worldType)
  end
end

function LWAllianceWarItem:OnJoinClick()
  if CrossServerUtil:NeedIntercept("world_tip10005", self.dataInfo.serverId, true) then
    return
  end
  if BattleFieldUtil.InBattleField(BattleFieldType.Desert) and BattleFieldUtil.isObserve then
    UIUtil.ShowTipsId("Desert_strom_tips1041")
  elseif self:CheckCanJoin() then
    if not SeasonUtil.CanJoinWar(self.dataInfo.fixedSoldierType, true) then
      return
    end
    if LuaEntry.DataConfig:CheckSwitch("alliance_rallyNoRewardTips_swich") then
      self:TryJoinAllianceRallyWar()
    else
      self:JoinAllianceRallyWar(false)
    end
  else
    UIUtil.ShowTipsId(120226)
  end
end

function LWAllianceWarItem:OnCancelClick()
  MarchUtil.CancelRallyByLeader(self.uuid)
end

function LWAllianceWarItem:OnShowClick()
  self.show_btn:SetActive(false)
  self.hide_btn:SetActive(true)
  self.join_holder:SetActive(self:CheckCanJoin())
  self.member_holder:SetActive(true)
  if self.uuid then
    self.view.expandItem[self.uuid] = true
  end
  self:RefreshMembers()
  self.view:ForceRebuildLayoutAlliance()
end

function LWAllianceWarItem:OnHideClick()
  self.show_btn:SetActive(true)
  self.hide_btn:SetActive(false)
  self.join_holder:SetActive(false)
  self.member_holder:SetActive(false)
  if self.uuid then
    self.view.expandItem[self.uuid] = false
  end
  self.view:ForceRebuildLayoutAlliance()
end

function LWAllianceWarItem:RefreshMembers()
  if not self.playerList then
    return
  end
  for i = 1, 5 do
    local player = self.playerList[i]
    local memberCell = self.member_list[i]
    if player then
      if not memberCell then
        memberCell = self:AddComponent(LWAllianceWarPlayerItem, member_path .. i)
        self.member_list[i] = memberCell
      end
      memberCell:SetActive(true)
      local uuid = player.uuid
      local playerData = player.playerData
      memberCell:RefreshData(self.uuid, uuid, playerData, self.dataInfo.isAttack)
    elseif memberCell then
      memberCell:SetActive(false)
    else
      local tran = self.transform:Find(member_path .. i)
      if tran then
        tran.gameObject:SetActive(false)
      end
    end
  end
end

function LWAllianceWarItem:RefreshWaitTimeout()
  if self.timeoutTag then
    return
  end
  if not self.dataInfo then
    return
  end
  if not self.player_head_list then
    return
  end
  if self.dataInfo.waitTime and self.dataInfo.waitTime > 9527 and UITimeManager:GetInstance():GetServerTime() > self.dataInfo.waitTime then
    self.timeoutTag = true
    for i, head in pairs(self.player_head_list) do
      if head then
        head:RefreshTimeoutState()
      end
    end
  end
end

function LWAllianceWarItem:RefreshData(data)
  local uuid = data and data.uuid
  local isNew = data and data.isNew
  local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
  local expand = self.view.expandItem[uuid] or false
  if uuid then
    self.show_btn:SetActive(not expand)
    self.hide_btn:SetActive(expand)
    self.join_holder:SetActive(expand and self:CheckCanJoin())
    self.member_holder:SetActive(expand)
  end
  if isNew then
    self.newIconGO:SetActive(true)
  else
    self.newIconGO:SetActive(false)
  end
  if self.uuid == uuid and self.dateUpdateTime then
    local change = self.view.ctrl:HasChange(uuid, self.dateUpdateTime)
    if not change then
      return
    end
  end
  if self.uuid ~= uuid then
    self.timeoutTag = nil
  end
  self.uuid = uuid
  self.isUpdate = false
  self.dataInfo = self.view.ctrl:GetWarItemData(self.uuid, true)
  self.dateUpdateTime = self.dataInfo.updateTime
  if self.lightOnBtn then
    self.lightOnBtn:SetActive(not sunrise and self.dataInfo.teamHasLight)
  end
  for i, head in pairs(self.player_head_list) do
    head:RefreshData(nil, self.dataInfo.serverId, uuid, self.dataInfo.monsterSpecialType, self.dataInfo.fixedSoldierType, i)
    head:SetRallyMonsterId(self.dataInfo.targetUid)
  end
  if self.dataInfo.createTime == 0 then
    return
  end
  self.buffTxt:SetActive(false)
  self.starNumTxt:SetActive(false)
  local starIconPath = "Assets/Main/Sprites/UI/LWUITacticalWeapon/lrb_wurenjixinpian_zhujiemian_star02.png"
  if self.dataInfo.monsterSpecialType == WorldMonsterSpecialType.AllyDrill or self.dataInfo.monsterSpecialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.dataInfo.monsterSpecialType == WorldMonsterSpecialType.AllyDrillRoadHog or self.dataInfo.monsterSpecialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
    if self.dataInfo.leaderRank and self.dataInfo.leaderRank >= 4 then
      self.buffTxt:SetActive(true)
      local r4, r5 = DataCenter.AllyDrillDataManager:GetBuffValue()
      if 0 < self.dataInfo.leaderOffical then
        self.buffIcon:LoadSprite(LWAlMemberOffcialParam[self.dataInfo.leaderOffical].SmallIcon)
        self.buffTxt:SetLocalText(2010336, r5)
      else
        if self.dataInfo.leaderRank == 5 then
          self.buffTxt:SetLocalText(2010336, r5)
        else
          self.buffTxt:SetLocalText(2010336, r4)
        end
        self.buffIcon:LoadSprite(LWAlMemberRankParam[self.dataInfo.leaderRank].Icon)
      end
    end
  elseif self.dataInfo.monsterSpecialType == WorldMonsterSpecialType.IndividualChallengeBoss or self.dataInfo.monsterSpecialType == WorldMonsterSpecialType.AllyChallengeBoss then
    local difficulty = DataCenter.ActivityKillZombieManager:GetDifficultyByMonsterId(self.dataInfo.targetContentId)
    if difficulty then
      self.starNumTxt:SetActive(true)
      local relDifficultyInLevel = DataCenter.ActivityKillZombieManager.GetRelDifficultyInLevel(difficulty)
      self.starNumTxt:SetText(relDifficultyInLevel)
      local difficultyLevel = DataCenter.ActivityKillZombieManager.GetDifficultyLevel(difficulty)
      if 0 < difficultyLevel then
        starIconPath = "Assets/Main/Sprites/UI/LWUITacticalWeapon/lrb_wurenjixinpian_zhujiemian_star01.png"
      end
    end
  end
  self.starIcon:LoadSprite(starIconPath)
  self.cancel_btn:SetActive(self.dataInfo.cancel and self.view.ctrl:GetInMarchState(self.uuid) == false)
  self.left_name:SetText(self.dataInfo.leftName)
  self.left_playerHead:SetData(self.dataInfo.attackUid, self.dataInfo.attackIcon, self.dataInfo.ownerIconVer, nil, self.dataInfo.ownerHeadBg)
  self.left_playerHead:SetEnableClickShowInfo(true)
  self.right_name:SetText(self.dataInfo.rightName)
  if not string.IsNullOrEmpty(self.dataInfo.rightLv) then
    self.r_lv_txt:SetText(self.dataInfo.rightLv)
  else
    self.r_lv_txt:SetText("")
  end
  if self.dataInfo.rightHead ~= nil then
    self.right_playerHead:LoadSpriteAuto(self.dataInfo.rightHead)
    self.right_playerHead:SetAspectSize(180)
  end
  if self.dataInfo.type == AllianceTeamType.ATTACK_CITY or self.dataInfo.type == AllianceTeamType.ATTACK_EPIDEMIC_CITY or self.dataInfo.isSeasonPlayerBuilding then
    local scale = self.dataInfo.rightHeadScale or 0.7
    self.right_playerHead.transform:Set_localScale(scale, scale, scale)
  else
    self.right_playerHead.transform:Set_localScale(1, 1, 1)
  end
  self.right_pos_txt:SetLocalText(455097, self.dataInfo.rightDistance)
  self.player_head_txt:SetText(Localization:GetString("390139") .. " (" .. self.dataInfo.canJoinNum .. "/" .. self.dataInfo.assemblyMarchMax .. ")")
  if self.dataInfo.rightHead == nil or string.IsNullOrEmpty(self.dataInfo.rightName) then
    local worldCityData
    local serverId = LuaEntry.Player:GetCurServerId()
    if self.dataInfo.targetContentId and self.dataInfo.serverId then
      serverId = self.dataInfo.serverId
      worldCityData = DataCenter.AllianceCityTemplateManager:GetTemplate(self.dataInfo.targetContentId, serverId)
    else
      worldCityData = DataCenter.AllianceCityTemplateManager:GetCityDataByPointIndex(self.dataInfo.rightPointId)
    end
    if worldCityData then
      if SeasonUtil.InSeasonBigMapMode(serverId) then
        local msg = ""
        if worldCityData:IsThroneCity() or worldCityData:IsCrossZoneOutpostCity() or worldCityData:IsCanon() then
          msg = worldCityData:GetName()
        else
          msg = Localization:GetString("science_condition", worldCityData.level, worldCityData:GetName())
        end
        self.right_name:SetText("#" .. serverId .. " " .. msg)
      elseif worldCityData:IsThroneCity() or worldCityData:IsThroneCityBattery() or worldCityData:IsMissileFactory() then
        self.right_name:SetText(worldCityData:GetName())
      else
        self.right_name:SetLocalText("science_condition", worldCityData.level, worldCityData:GetName())
      end
      local iconPath = worldCityData:GetIconPath(false)
      self.right_playerHead:LoadSprite(iconPath)
      self.right_playerHead:SetNativeSize()
    end
  end
  local isContainRole = self:RefreshWarPlayerData()
  if expand then
    self:RefreshMembers()
  end
  if self.dataInfo.isAttack then
    self.defense_img:LoadSprite(defence_mini_icon)
    self.defense_tex:SetLocalText(130066)
    self.t_bg:LoadSprite(attack_bg1)
    self.l_bg:SetColor(LWALAttackLbgColor)
    self.j_bg:SetColor(LWALAttackJbgColor)
    self.t_bg:SetColor(Color.white)
  else
    self.defense_img:LoadSprite(attack_mini_icon)
    self.defense_tex:SetLocalText(100150)
    self.t_bg:LoadSprite(defence_bg1)
    self.j_bg:SetColor(LWALDefenseJbgColor)
    if isContainRole then
      self.t_bg:SetColor(LWALBGColor)
      self.l_bg:SetColor(LWALBGColor1)
    else
      self.t_bg:SetColor(Color.white)
      self.l_bg:SetColor(LWALDefenseLbgColor)
    end
  end
  if self.dataInfo.fixedSoldierType == SoldierType.Mummy then
    self:ShowMummyBg(true)
    self.l_bg:SetColorRGBA(0, 0, 0, 0)
    self.left_playerHead:ShowMummyIcon()
  else
    self:ShowMummyBg(false)
    self.t_bg:SetColorRGBA(1, 1, 1, 1)
  end
  self:UpdateSlider()
  self:AddAllianceTimer()
  if self.dataInfo.bossHP and self.dataInfo.bossHP < 100 then
    self.hp_obj:SetActive(true)
    local per = self.dataInfo.bossHP / 100
    self.hp_slider:SetSizeDeltaXY(self.hp_slider_size.x * per, self.hp_slider_size.y)
    self.hp_des_text:SetText(self.dataInfo.bossHP .. "%")
  else
    self.hp_obj:SetActive(false)
  end
  self:RefreshBossShareBtn()
end

function LWAllianceWarItem:ShowMummyBg(showIt)
  if showIt and self.theMummyBg == nil then
    local effectPrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/Component/LWAlWarItemMummyBg.prefab"
    self.theMummyBg = self:LoadComponentAsync(UIAsyncContainer, effectPrefabPath, self.t_bg)
  end
  if self.theMummyBg ~= nil then
    self.theMummyBg:SetActive(showIt)
  end
end

function LWAllianceWarItem:GetIsCanShare()
  if self.dataInfo.type == AllianceTeamType.ATTACK_BOSS then
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.dataInfo.targetUid)
    if monster.special == WorldMonsterSpecialType.RunningMonster or monster.special == WorldMonsterSpecialType.MonsterInvasionBoss or monster.special == WorldMonsterSpecialType.AllyChallengeBoss or monster.special == WorldMonsterSpecialType.CityStrongholdBOSS or monster.special == WorldMonsterSpecialType.SuperRunningBoss or monster.special == WorldMonsterSpecialType.CityGhostBoss then
      return true
    end
  end
end

function LWAllianceWarItem:RefreshBossShareBtn()
  self.shareBtn:SetActive(self:GetIsCanShare())
end

function LWAllianceWarItem:RefreshWarPlayerData()
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.uuid)
  self.playerList = {}
  if info ~= nil then
    local uuid_list = {}
    local inTheTeam = false
    local selfUid = LuaEntry.Player.uid
    local index = 1
    local showJoin = self:CheckCanJoin()
    if info.leaderMarch ~= nil then
      table.insert(uuid_list, info.leaderMarch.uuid)
      inTheTeam = selfUid == info.leaderMarch.ownerUid
    end
    table.insertto(uuid_list, table.keys(info.memberList))
    local count = #uuid_list
    for i = 1, count do
      local uuid = uuid_list[i]
      local playerData = self:GetPlayerItemData(uuid)
      self.playerList[i] = {uuid = uuid, playerData = playerData}
      inTheTeam = inTheTeam or selfUid == playerData.ownerUid
      if uuid ~= info.leaderMarch.uuid then
        self.player_head_list[index]:RefreshData(playerData, self.dataInfo.serverId, self.uuid, self.dataInfo.monsterSpecialType, self.dataInfo.fixedSoldierType, index)
        self.player_head_list[index]:SetRallyMonsterId(self.dataInfo.targetUid)
        index = index + 1
      end
    end
    if showJoin then
      for i = index, 4 do
        self.player_head_list[i]:SetJoinActive(true)
      end
    else
      for i = index, 4 do
        self.player_head_list[i]:SetEmpty()
      end
    end
    return inTheTeam
  end
  return false
end

function LWAllianceWarItem:AddAllianceTimer()
  if self._timer_alliance == nil then
    self._timer_alliance = TimerManager:GetInstance():GetTimer(1, self._timer_action, self, false, false, false)
    self._timer_alliance:Start()
  end
end

function LWAllianceWarItem:UpdateSlider()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  local dialog = "141032"
  self.isJoin = curTime < self.dataInfo.waitTime
  self:RefreshWaitTimeout()
  if curTime < self.dataInfo.marchTime then
    dialog = self:CheckHasMarchMember() and "match_assemble_status02" or "match_assemble_status01"
    self.isUpdate = true
    deltaTime = self.dataInfo.marchTime - curTime
  else
    self.isUpdate = false
    self.isJoin = false
  end
  if self.isUpdate then
    self.time_txt:SetText(string.format([[
%s
%s]], Localization:GetString(dialog), UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
    if self.hide_btn:GetActive() then
      self.join_holder:SetActive(self:CheckCanJoin() and self.isJoin)
    end
  else
    if 0 < deltaTime then
      self.time_txt:SetText(string.format([[
%s
%s]], Localization:GetString(dialog), UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
    else
      self.time_txt:SetLocalText(dialog)
    end
    if self.hide_btn:GetActive() then
      self.join_holder:SetActive(false)
    end
    self.cancel_btn:SetActive(false)
  end
end

function LWAllianceWarItem:GetPlayerItemData(marchUuid)
  local oneData = OnePlayerData.New()
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.uuid)
  local selfUid = LuaEntry.Player.uid
  if info ~= nil then
    if info.memberList[marchUuid] ~= nil then
      local data = info.memberList[marchUuid]
      oneData.ownerName = data.ownerName
      oneData.status = data.status
      oneData.endTime = data.endTime
      oneData.startTime = data.startTime
      oneData.leader = false
      oneData.cancel = data.ownerUid == selfUid or info.attackUid == selfUid
      oneData.ownerUid = data.ownerUid
      oneData.teamUuid = data.teamUuid
      oneData.attackUid = info.attackUid
      oneData.ownerIcon = data.ownerIcon
      oneData.ownerIconVer = data.ownerIconVer
      oneData.headBg = data:GetHeadBgImg()
    elseif info.leaderMarch ~= nil and info.leaderMarch.uuid == marchUuid then
      local data = info.leaderMarch
      oneData.ownerName = data.ownerName
      oneData.status = data.status
      oneData.endTime = data.endTime
      oneData.startTime = data.startTime
      oneData.leader = true
      oneData.cancel = data.ownerUid == selfUid
      oneData.ownerUid = data.ownerUid
      oneData.teamUuid = data.teamUuid
      oneData.attackUid = info.attackUid
      oneData.ownerIcon = data.ownerIcon
      oneData.ownerIconVer = data.ownerIconVer
      oneData.headBg = data:GetHeadBgImg()
    end
  end
  return oneData
end

function LWAllianceWarItem:CheckHasMarchMember()
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.uuid)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if info ~= nil and info.memberList ~= nil then
    for k, v in pairs(info.memberList) do
      if v.status == MarchStatus.MOVING and curTime < v.endTime then
        return true
      end
    end
  end
  return false
end

function LWAllianceWarItem:CheckCanJoin()
  return DataCenter.AllianceWarDataManager:CheckJoinAllianceWar(self.uuid)
end

function LWAllianceWarItem:TryJoinAllianceRallyWar()
  if not DataCenter.AllianceWarDataManager:CheckIsPopRewardLimitMonster(self.dataInfo.targetUid) then
    self:JoinAllianceRallyWar(false)
    return
  end
  local canShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.AllianceJoinRallyLimit)
  if not canShow then
    self:JoinAllianceRallyWar(false)
    return
  end
  local need_callback, isLimit = DataCenter.AllianceWarDataManager:GetWarRallyRewardIsLimit(self.dataInfo.monsterSpecialType, self.dataInfo.targetUid, self.uuid)
  if not need_callback then
    self:JoinAllianceRallyWar(isLimit)
  else
    self:SetWaitRallyLimitCallback(true)
  end
end

function LWAllianceWarItem:JoinAllianceRallyWar(isLimit)
  if isLimit then
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.AllianceJoinRallyLimit, {
      contentText = CS.GameEntry.Localization:GetString("alliance_rally_desc_full"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          self.view.ctrl:OnJoinClick(self.uuid, self.dataInfo.monsterSpecialType)
        end
      }
    })
  else
    self.view.ctrl:OnJoinClick(self.uuid, self.dataInfo.monsterSpecialType)
  end
end

function LWAllianceWarItem:SetWaitRallyLimitCallback(isWait)
  self.waitRallyLimitCallback = isWait
end

function LWAllianceWarItem:OnJoinRallyLimit(param)
  if param.uuid == self.uuid and self.waitRallyLimitCallback then
    self.waitRallyLimitCallback = false
    self:JoinAllianceRallyWar(param.isLimit)
  end
end

return LWAllianceWarItem
