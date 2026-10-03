local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local GoddessMummyStateLock = BaseClass("GoddessMummyStateLock", base)
local GoddessMummyStateReady = BaseClass("GoddessMummyStateReady", base)
local GoddessMummyStateWaitHelp = BaseClass("GoddessMummyStateWaitHelp", base)
local GoddessMummyStateSuccess = BaseClass("GoddessMummyStateSuccess", base)
local GoddessMummyStateFail = BaseClass("GoddessMummyStateFail", base)
local UIAllianceGovernmentGoddessMummySkill = BaseClass("UIAllianceGovernmentGoddessMummySkill", base)

function UIAllianceGovernmentGoddessMummySkill:OnCreate()
  base.OnCreate(self)
  self.expand_node = true
  self.theRuleItem = self.transform:Find("Desc/Rule").gameObject
  self.theRuleItem:GameObjectCreatePool()
  self.name = self:AddComponent(UITextMeshProUGUIEx, "Name")
  self.btn_info = self:AddComponent(UIButton, "BtnInfo")
  self.item_icon = self:AddComponent(UIImage, "ImgQuality/ItemIcon")
  self.skill_title = self:AddComponent(UITextMeshProUGUIEx, "Desc/SkillTitle")
  self.skill_desc = self:AddComponent(UITextMeshProUGUIEx, "Desc/SkillDesc")
  self.status_lock520 = self:AddComponent(GoddessMummyStateLock, "StatusLock520")
  self.status_ready610 = self:AddComponent(GoddessMummyStateReady, "StatusReady610")
  self.status_wait666 = self:AddComponent(GoddessMummyStateWaitHelp, "StatusWaitHelp666")
  self.status_success680 = self:AddComponent(GoddessMummyStateSuccess, "StatusSuccess680")
  self.status_fail680 = self:AddComponent(GoddessMummyStateFail, "StatusFail680")
  self.btn_info:SetOnClick(function()
    if self.cfg and not string.IsNullOrEmpty(self.cfg.rule) then
      local title = "season_alliance_government_skill_goddess_02"
      local desc = Localization:GetString(self.cfg.rule)
      UIUtil.ShowDetail(desc, title)
    end
  end)
  self.skill_title:SetActive(false)
  self.layoutRoot = self:AddComponent(UIBaseContainer, "")
  self.layoutDesc = self:AddComponent(UIBaseContainer, "Desc")
  self.expand_btn = self:AddComponent(UIButton, "ExpandBtn")
  self.arrow = self:AddComponent(UIImage, "ExpandBtn/Arrow")
  self.expand_btn:SetOnClick(function()
    self:SwitchExpandMode()
  end)
  self.bgBtn = self:AddComponent(UIButton, "")
  self.bgBtn:SetOnClick(function()
    if not self.expand_node then
      self:SwitchExpandMode()
    end
  end)
end

function UIAllianceGovernmentGoddessMummySkill:OnDestroy()
  self.layoutDesc:RemoveComponents(UITextMeshProUGUIEx)
  self.theRuleItem:GameObjectRecycleAll()
  self.expand_btn = nil
  self.arrow = nil
  self.name = nil
  self.btn_info = nil
  self.item_icon = nil
  self.skill_title = nil
  self.skill_desc = nil
  self.status_lock520 = nil
  self.status_ready610 = nil
  self.status_wait666 = nil
  self.status_succ680 = nil
  self.status_fail680 = nil
  base.OnDestroy(self)
end

function UIAllianceGovernmentGoddessMummySkill:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  self:AddUIListener(EventId.UpdateGoddessMummyState, self.UpdateData)
  self:AddUIListener(EventId.AllianceMember, self.UpdateData)
end

function UIAllianceGovernmentGoddessMummySkill:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateGoddessMummyState, self.UpdateData)
  self:RemoveUIListener(EventId.AllianceMember, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIAllianceGovernmentGoddessMummySkill:SwitchExpandMode()
  self.expand_node = not self.expand_node
  if self.expand_node then
    self.arrow:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_2.png")
  else
    self.arrow:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_1.png")
  end
  self:UpdateData()
end

function UIAllianceGovernmentGoddessMummySkill:UpdateData()
  self.status_lock520:SetActive(false)
  self.status_ready610:SetActive(false)
  self.status_wait666:SetActive(false)
  self.status_success680:SetActive(false)
  self.status_fail680:SetActive(false)
  local cfg = self.cfg
  local stateData = DataCenter.AllianceGovernmentSkillManager:GetSkillActivityData(AlOfficialSkillType.GoddessMummy)
  local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.War_Commander)
  if memberInfo == nil or cfg == nil or stateData == nil then
  elseif self.expand_node then
    local currStep = toInt(stateData.currStep)
    local furnaceObj = stateData.furnaceObj
    local joinAct = stateData.joinAct
    if joinAct ~= true or currStep < SeasonFactionDeclareWarStep.battle_before then
      self.status_lock520:SetActive(true)
      self.status_lock520:ReInit(cfg, stateData, nil)
    else
      local now = UITimeManager:GetInstance():GetServerTime()
      local serverData = DataCenter.AllianceGovernmentSkillManager:GetUsedSkillStateDataByType(AlOfficialSkillType.GoddessMummy)
      if serverData then
        if serverData.state == 0 and now < serverData.chantOverTime then
          self.status_wait666:SetActive(true)
          self.status_wait666:ReInit(cfg, stateData, serverData)
        elseif serverData.state == 1 or serverData.state == 2 then
          self.status_fail680:SetActive(true)
          self.status_fail680:ReInit(cfg, stateData, serverData)
        else
          self.status_success680:SetActive(true)
          self.status_success680:ReInit(cfg, stateData, serverData)
        end
      else
        self.status_ready610:SetActive(true)
        self.status_ready610:ReInit(cfg, stateData, nil)
      end
    end
  end
  if cfg ~= nil then
    self.name:SetLocalText(cfg.name)
    if not string.IsNullOrEmpty(cfg.skill_icon) then
      self.item_icon:LoadSprite(cfg.skill_icon)
    end
  end
  self.layoutDesc:RemoveComponents(UITextMeshProUGUIEx)
  self.theRuleItem:GameObjectRecycleAll()
  if cfg ~= nil and self.expand_node and not string.IsNullOrEmpty(cfg.effect_desc) then
    local goItem, theItem
    local desc_list = string.split(cfg.effect_desc, "|")
    local param_list = string.split(cfg.effect_desc_num, "|")
    for k, v in ipairs(desc_list) do
      goItem = self.theRuleItem:GameObjectSpawn(self.layoutDesc.transform)
      goItem.name = "item_" .. k
      goItem:SetActive(true)
      theItem = self.layoutDesc:AddComponent(UITextMeshProUGUIEx, goItem.name)
      if string.IsNullOrEmpty(param_list[k]) then
        theItem:SetLocalText(v)
      else
        theItem:SetLocalText(v, table.unpack(string.split(param_list[k], ";")))
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutDesc.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutRoot.transform)
end

function UIAllianceGovernmentGoddessMummySkill:ReInit()
  local cfg
  local skillList = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigsByOfficial(LWAlMemberOffcialType.War_Commander)
  if skillList then
    for _, v in ipairs(skillList) do
      if v and v.skill_flag == AlOfficialSkillType.GoddessMummy then
        cfg = v
      end
    end
  end
  self.cfg = cfg
  if cfg then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillDetail, cfg.id)
    self.name:SetLocalText(cfg.name)
    self.skill_desc:SetLocalText(cfg.desc)
  end
  self:UpdateData()
end

function GoddessMummyStateLock:OnCreate()
  base.OnCreate(self)
  self.sendRefreshRequest = false
  self.tipsLock = self:AddComponent(UITextMeshProUGUIEx, "bg/tipsLock")
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, "bg/time")
end

function GoddessMummyStateLock:OnDestroy()
  self.tipsLock = nil
  self.time_txt = nil
  base.OnDestroy(self)
end

function GoddessMummyStateLock:Update1000MS()
  if self.endTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - now
    if 0 < remainTime then
      self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.time_txt:SetText("")
      self.time_txt:SetActive(false)
      self.tipsLock:SetLocalText("season_alliance_government_skill_goddess_10")
      self.endTime = nil
      if self.cfg and not self.sendRefreshRequest then
        self.sendRefreshRequest = true
        SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillDetail, self.cfg.id)
      end
    end
  end
end

function GoddessMummyStateLock:ReInit(cfg, stateData, skillEffectData)
  local currStep = toInt(stateData.currStep)
  local joinAct = stateData.joinAct
  local hasBattle = stateData.hasBattle
  self.cfg = cfg
  self.stateData = stateData
  if joinAct ~= true or hasBattle ~= true and currStep == SeasonFactionDeclareWarStep.battle then
    self.tipsLock:SetLocalText("season_alliance_government_skill_26")
    self.time_txt:SetActive(false)
  else
    self.endTime = toInt(stateData.currBattleStartTime or stateData.battleStartTime or stateData.nextBattleTime)
    self.tipsLock:SetLocalText("458012")
    self.time_txt:SetActive(true)
    self:Update1000MS()
  end
end

function GoddessMummyStateReady:OnCreate()
  base.OnCreate(self)
  self.sendRefreshRequest = false
  self.put_btn_text = self:AddComponent(UITextMeshProUGUIEx, "PutBtn/PutBtnText")
  self.put_btn_text:SetLocalText("season_alliance_government_skill_goddess_UI_1")
  self.put_btn = self:AddComponent(UIButton, "PutBtn")
  self.put_btn:SetOnClick(function()
    local officialPos = DataCenter.AllianceGovernmentSkillManager:GetOfficialPosByUid(LuaEntry.Player.uid)
    if officialPos ~= LWAlMemberOffcialType.War_Commander then
      UIUtil.ShowTipsId("season_s3_government_skill_tips20")
      return
    end
    local seasonType = SeasonUtil.GetSeasonType()
    local defenderAllianceId = DataCenter.SeasonFactionWarDataManager.defenderAllianceId
    if defenderAllianceId then
      local mainBuildId = SeasonUtil.GetSeasonMilitaryCenterId(seasonType)
      if defenderAllianceId == LuaEntry.Player.allianceId then
        if SeasonUtil.SeasonHasMummyYardBuild(seasonType) then
          UIUtil.ShowTipsId("season_alliance_government_skill_goddess_39")
        end
        return
      end
      if DataCenter.SeasonFactionWarDataManager:CanAssistAllianceBuild(mainBuildId, defenderAllianceId) then
        if SeasonUtil.SeasonHasMummyYardBuild(seasonType) then
          UIUtil.ShowTipsId("season_alliance_government_skill_goddess_39")
        end
        return
      end
    end
    local stateData = self.stateData
    if stateData then
      local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
      local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
      local msg = Localization:GetString("season_s3_government_skill_tips9")
      if 0 < leftTime then
        msg = Localization:GetString("season_s3_government_skill_tips9")
      else
        msg = Localization:GetString("season_s3_government_skill_tips9")
      end
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.GoddessMummyConfirm, msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:TryPutMissile()
      end, function()
      end, nil, nil, false, nil, nil)
    else
      UIUtil.ShowTipsId(120018)
    end
  end)
  self.bg_tipsReady = self:AddComponent(UITextMeshProUGUIEx, "bg/tipsReady")
end

function GoddessMummyStateReady:OnDestroy()
  self.put_btn = nil
  base.OnDestroy(self)
end

function GoddessMummyStateReady:TryPutMissile()
  local stateData = self.stateData
  if stateData then
    local currStep = toInt(stateData.currStep)
    local furnaceObj = stateData.furnaceObj
    local joinAct = stateData.joinAct
    local hasBattle = stateData.hasBattle
    if not (hasBattle and joinAct) or furnaceObj == nil then
      UIUtil.ShowTipsId("season_alliance_government_skill_26")
      return
    end
    if currStep == SeasonFactionDeclareWarStep.battle_after then
      UIUtil.ShowTipsId("season_alliance_government_skill_28")
      return
    end
    local pointId = toInt(furnaceObj.pointId or LuaEntry.Player:GetMainWorldPos())
    local serverId = toInt(furnaceObj.serverId)
    if serverId ~= 0 and serverId ~= LuaEntry.Player:GetSelfServerId() then
      UIUtil.ShowMessage(Localization:GetString("season_alliance_government_skill_27"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        GoToUtil.CloseAllWindows()
        CrossServerUtil.JumpToServerByServerId(serverId, MoveCrossServerType.SeasonBattleDesert, pointId, SeasonCrossCameraHeight)
      end, function()
      end)
      return
    end
    local effect_scope = self.cfg.effect_scope or 18
    GoToUtil.CloseAllWindows()
    if SceneUtils.GetIsInWorld() then
      BuildingUtils.ShowPutAllianceBuild(BuildingTypes.GODDESS_MUMMY_TARGET, effect_scope, pointId, PlaceBuildType.Build)
    else
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), 500, 0.02, function()
        BuildingUtils.ShowPutAllianceBuild(BuildingTypes.GODDESS_MUMMY_TARGET, effect_scope, pointId, PlaceBuildType.Build)
      end, LuaEntry.Player:GetSelfServerId(), 0)
    end
  else
    UIUtil.ShowTipsId(120018)
  end
end

function GoddessMummyStateReady:Update1000MS()
end

function GoddessMummyStateReady:ReInit(cfg, stateData, skillEffectData)
  self.cfg = cfg
  self.stateData = stateData
  self.skillEffectData = skillEffectData
  local currStep = toInt(stateData.currStep)
  local furnaceObj = stateData.furnaceObj
  local joinAct = stateData.joinAct
  local hasBattle = stateData.hasBattle
  if not (hasBattle and joinAct) or furnaceObj == nil then
    self.bg_tipsReady:SetLocalText("season_alliance_government_skill_26")
    CS.UIGray.SetGray(self.put_btn.transform, true, false)
  elseif currStep == SeasonFactionDeclareWarStep.battle_after then
    self.bg_tipsReady:SetLocalText("season_alliance_government_skill_28")
    CS.UIGray.SetGray(self.put_btn.transform, true, false)
  else
    self.bg_tipsReady:SetLocalText("season_alliance_government_skill_goddess_11")
    CS.UIGray.SetGray(self.put_btn.transform, false, true)
  end
end

function GoddessMummyStateWaitHelp:OnCreate()
  base.OnCreate(self)
  self.sendRefreshRequest = false
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, "bg/timeTxt")
  self.pos_txt = self:AddComponent(UITextMeshProUGUIEx, "posTxt")
  self.pos_txt:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.pos_txt, eventData)
  end)
  self.help_btn = self:AddComponent(UIButton, "HelpBtn")
  self.icon_goddess = self:AddComponent(UIImage, "icon")
  self.player_name = self:AddComponent(UITextMeshProUGUIEx, "NameBg/PlayerName")
  self.player_name:SetLocalText("season_alliance_government_skill_goddess_02")
  self.bg_tipsHelp = self:AddComponent(UITextMeshProUGUIEx, "bg/tipsHelp")
  self.bg_tipsHelp:SetLocalText("season_alliance_government_skill_goddess_09")
  self.help_me_btn = self:AddComponent(UIButton, "HelpMeBtn")
  self.help_btn:SetOnClick(function()
    GoToUtil.DoPlayerAssistance(self.serverId, 0, self.startPos)
  end)
  self.help_me_btn:SetOnClick(function()
    local share_param = {}
    share_param.skillType = AlOfficialSkillType.GoddessMummy
    share_param.sid = self.serverId
    share_param.worldId = 0
    share_param.postType = PostType.HelpMePutAresMissile
    share_param.startPos = self.startPos
    share_param.targetPos = self.targetPos
    share_param.chantOverTime = self.chantOverTime
    if self.startPos == 0 then
      share_param.startPos = LuaEntry.Player:GetMainWorldPos()
    end
    local chatData = {}
    chatData.roomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
    chatData.post = PostType.HelpMePutAresMissile
    chatData.param = share_param
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
  end)
  self.help_me_btn:SetSafeClickMode(true)
  self.help_me_btn:SetSafeClickModeTime(10)
end

function GoddessMummyStateWaitHelp:OnDestroy()
  self.time_txt = nil
  self.pos_txt = nil
  self.help_btn = nil
  self.help_me_btn = nil
  base.OnDestroy(self)
end

function GoddessMummyStateWaitHelp:Update1000MS()
  if self.chantOverTime ~= nil and self.chantOverTime ~= 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.chantOverTime - now
    if 0 < remainTime then
      self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.time_txt:SetText("00:00:00")
      self.chantOverTime = 0
      if self.cfg and not self.sendRefreshRequest then
        self.sendRefreshRequest = true
        SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillDetail, self.cfg.id)
      end
    end
  end
end

function GoddessMummyStateWaitHelp:ReInit(cfg, stateData, skillEffectData)
  self.cfg = cfg
  self.stateData = stateData
  self.skillEffectData = skillEffectData
  self.serverId = skillEffectData.serverId
  self.startPos = skillEffectData.startPos
  self.targetPos = skillEffectData.targetPos
  self.chantOverTime = skillEffectData.chantOverTime
  self.pos_txt:SetText(UIUtil.MakeJumpLink(skillEffectData.startPos, skillEffectData.serverId))
  self.icon_goddess:LoadSprite(DataCenter.AllianceGovernmentSkillManager:GetSkillBigIconBySkillType(AlOfficialSkillType.GoddessMummy))
end

function GoddessMummyStateSuccess:OnCreate()
  base.OnCreate(self)
  self.succ_tips = self:AddComponent(UITextMeshProUGUIEx, "bg/succ_tips")
  self.view_btn = self:AddComponent(UIButton, "ViewBtn")
  self.next_tips = self:AddComponent(UITextMeshProUGUIEx, "bg2/next_tips")
  self.next_time = self:AddComponent(UITextMeshProUGUIEx, "bg2/next_time")
  self.skill_desc = self:AddComponent(UITextMeshProUGUIEx, "SkillDesc")
  self.thumbs_up_bg = self:AddComponent(UIButton, "ThumbsUpBg")
  self.thumbs_up_num = self:AddComponent(UITextMeshProUGUIEx, "ThumbsUpBg/ThumbsUpNum")
  self.view_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGovernmentSkillHurtList, {anim = true}, AlOfficialSkillType.GoddessMummy)
  end)
  self.thumbs_up_bg:SetOnClick(function()
    local thumbsUpNumNow = toInt(self.thumbsUpNum)
    local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.War_Commander)
    if memberInfo == nil then
    else
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      InteractiveUtil.TryThumbsUp(memberInfo.uid, InteractiveUtil.ThumbsUpType.GoodJobGoddessMummy, "10002", function(msg)
        if msg and msg.targetThumbsUpNum and self.thumbs_up_num then
          local thumbsUpNumNew = toInt(msg.targetThumbsUpNum)
          local add_count = thumbsUpNumNew - thumbsUpNumNow
          if 0 < add_count then
            self.thumbsUpNum = thumbsUpNumNew
            self.thumbs_up_num:SetText(thumbsUpNumNew)
          end
        end
      end)
    end
  end)
end

function GoddessMummyStateSuccess:OnDestroy()
  self.succ_tips = nil
  self.view_btn = nil
  self.next_tips = nil
  self.next_time = nil
  self.skill_desc = nil
  self.thumbs_up_bg = nil
  self.thumbs_up_num = nil
  base.OnDestroy(self)
end

function GoddessMummyStateSuccess:Update1000MS()
  if self.nextBattleTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.nextBattleTime - now
    if 0 < remainTime then
      self.next_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.next_time:SetText("00:00:00")
    end
  end
end

function GoddessMummyStateSuccess:OnAddListener()
  base.OnAddListener(self)
end

function GoddessMummyStateSuccess:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GoddessMummyStateSuccess:OnThumbsUpNumUpdate()
end

function GoddessMummyStateSuccess:ReInit(cfg, stateData, skillEffectData)
  local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.War_Commander)
  self.thumbs_up_bg:SetActive(memberInfo ~= nil)
  self.cfg = cfg
  self.thumbsUpNum = toInt(skillEffectData.thumbsUpNum)
  self.succ_tips:SetLocalText("140057", "")
  if skillEffectData.result then
    self.skill_desc:SetLocalText("season_alliance_government_skill_goddess_05", table.count(skillEffectData.result.beAttackUserList))
  else
    self.skill_desc:SetLocalText("season_alliance_government_skill_goddess_05", "0")
  end
  self.nextBattleTime = toInt(stateData.nextBattleTime)
  self.next_tips:SetLocalText("456018", "")
  self.next_time:SetActive(true)
  self.thumbs_up_num:SetText(self.thumbsUpNum)
  self:Update1000MS()
end

function GoddessMummyStateFail:OnCreate()
  base.OnCreate(self)
  self.fail_tips = self:AddComponent(UITextMeshProUGUIEx, "bg/fail_tips")
  self.next_tips = self:AddComponent(UITextMeshProUGUIEx, "bg2/next_tips")
  self.next_time = self:AddComponent(UITextMeshProUGUIEx, "bg2/next_time")
  self.player_head = self:AddComponent(UICommonHead, "info/UIPlayerHead")
  self.skill_desc = self:AddComponent(UITextMeshProUGUIEx, "info/SkillDesc")
  self.player_head:SetEnableClickShowInfo(true, true)
end

function GoddessMummyStateFail:OnDestroy()
  self.fail_tips = nil
  self.next_tips = nil
  self.next_time = nil
  self.player_head = nil
  self.skill_desc = nil
  base.OnDestroy(self)
end

function GoddessMummyStateFail:Update1000MS()
  if self.nextBattleTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.nextBattleTime - now
    if 0 < remainTime then
      self.next_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.next_time:SetText("00:00:00")
    end
  end
end

function GoddessMummyStateFail:ReInit(cfg, stateData, skillEffectData)
  self.cfg = cfg
  self.fail_tips:SetLocalText("140058", "")
  if skillEffectData.state == 2 and skillEffectData.result and skillEffectData.result.interruptUser then
    local user = skillEffectData.result.interruptUser
    local interruptUser = UIUtil.FormatServerAllianceName(user.serverId, user.abbr, user.name)
    self.player_head:SetActive(true)
    self.player_head:ParseHeadInfo(user)
    self.skill_desc:SetLocalText("season_alliance_government_skill_goddess_34", interruptUser)
  else
    self.player_head:SetActive(false)
    self.skill_desc:SetLocalText("season_alliance_government_skill_goddess_22", "")
  end
  self.nextBattleTime = toInt(stateData.nextBattleTime)
  self.next_tips:SetLocalText("456018", "")
  self.next_time:SetActive(true)
  self:Update1000MS()
end

return UIAllianceGovernmentGoddessMummySkill
