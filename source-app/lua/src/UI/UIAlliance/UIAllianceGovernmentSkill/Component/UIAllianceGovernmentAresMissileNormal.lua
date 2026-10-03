local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

local function GetFactoryMissileCountInfo()
  local timeList = DataCenter.AllianceGovernmentSkillManager.skillTimeList
  local cfg = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigBySkillType(AlOfficialSkillType.MissileFactory)
  if cfg == nil then
    cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(10003)
  end
  if timeList == nil then
    if cfg then
      return {
        skillId = cfg.id,
        leftUseTime = 0
      }, cfg
    end
    return {skillId = 10003, leftUseTime = 0}, cfg
  end
  if timeList then
    for k, v in pairs(timeList) do
      if v and v.skillId then
        local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(v.skillId)
        if skill_cfg ~= nil and skill_cfg.skill_flag == AlOfficialSkillType.MissileFactory then
          return v, skill_cfg
        end
      end
    end
  end
  if cfg then
    return {
      skillId = cfg.id,
      leftUseTime = 0
    }, cfg
  end
  return {skillId = 10003, leftUseTime = 0}, cfg
end

local function _TryPutMissile(cfg, stateData)
  if cfg and stateData then
    local curServerId = LuaEntry.Player:GetSelfServerId()
    local myServerId = LuaEntry.Player:GetSourceServerId()
    local enemyServer = DataCenter.ZoneWarManager:GetFightServerNow()
    math.randomseed(SafeLocalOsTime())
    local x = math.random(475, 549)
    local y = math.random(475, 549)
    local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
    local serverId = enemyServer
    if serverId ~= 0 and serverId ~= curServerId then
      UIUtil.ShowMessage(Localization:GetString("season_alliance_government_skill_27"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        GoToUtil.CloseAllWindows()
        CrossServerUtil.JumpToServerByServerId(serverId, MoveCrossServerType.SeasonBattleDesert, pointId, SeasonCrossCameraHeight)
      end, function()
      end)
      return
    end
    local effect_scope = cfg.effect_scope or 18
    GoToUtil.CloseAllWindows()
    if SceneUtils.GetIsInWorld() then
      BuildingUtils.ShowPutAllianceBuild(BuildingTypes.SEASON_ARES_MISSILE_GLOBAL, effect_scope, pointId, PlaceBuildType.Build)
    else
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), 500, 0.02, function()
        BuildingUtils.ShowPutAllianceBuild(BuildingTypes.SEASON_ARES_MISSILE_GLOBAL, effect_scope, pointId, PlaceBuildType.Build)
      end, curServerId, 0)
    end
  else
    UIUtil.ShowTipsId(320242)
  end
end

local function TryPutMissile(cfg, stateData)
  local officialPos = DataCenter.AllianceGovernmentSkillManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if officialPos ~= LWAlMemberOffcialType.Deputy_Al_Leader then
    UIUtil.ShowTipsId("season_s2_government_skill_tips20")
    return
  end
  if cfg and stateData then
    local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
    local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
    local msg = Localization:GetString("season_s2_government_skill_tips10")
    if 0 < leftTime then
      msg = Localization:GetString("season_s2_government_skill_tips9")
    else
      msg = Localization:GetString("season_s2_government_skill_tips10")
    end
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.AresMissileConfirm, msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      _TryPutMissile(cfg, stateData)
    end, function()
    end, nil, nil, false, nil, nil)
  else
    UIUtil.ShowTipsId(320242)
  end
end

local AresMissileStateNormalLock = BaseClass("AresMissileStateNormalLock", base)
local AresMissileStateNormalReady = BaseClass("AresMissileStateNormalReady", base)
local AresMissileStateNormalWaitHelp = BaseClass("AresMissileStateNormalWaitHelp", base)
local AresMissileStateNormalSuccess = BaseClass("AresMissileStateNormalSuccess", base)
local AresMissileStateNormalFail = BaseClass("AresMissileStateNormalFail", base)
local UIAllianceGovernmentAresMissileNormal = BaseClass("UIAllianceGovernmentAresMissileNormal", base)

function UIAllianceGovernmentAresMissileNormal:OnCreate()
  base.OnCreate(self)
  self.expand_node = false
  self.theRuleItem = self.transform:Find("Desc/Rule").gameObject
  self.theRuleItem:GameObjectCreatePool()
  self.name = self:AddComponent(UITextMeshProUGUIEx, "Name")
  self.btn_info = self:AddComponent(UIButton, "BtnInfo")
  self.item_icon = self:AddComponent(UIImage, "ImgQuality/ItemIcon")
  self.skill_title = self:AddComponent(UITextMeshProUGUIEx, "Desc/SkillTitle")
  self.skill_desc = self:AddComponent(UITextMeshProUGUIEx, "Desc/SkillDesc")
  self.status_lock520 = self:AddComponent(AresMissileStateNormalLock, "StatusLock520")
  self.status_ready610 = self:AddComponent(AresMissileStateNormalReady, "StatusReady610")
  self.status_wait666 = self:AddComponent(AresMissileStateNormalWaitHelp, "StatusWaitHelp666")
  self.status_success680 = self:AddComponent(AresMissileStateNormalSuccess, "StatusSuccess680")
  self.status_fail680 = self:AddComponent(AresMissileStateNormalFail, "StatusFail680")
  self.btn_info:SetOnClick(function()
    if self.cfg and not string.IsNullOrEmpty(self.cfg.rule) then
      local title = self.cfg.name
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

function UIAllianceGovernmentAresMissileNormal:OnDestroy()
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

function UIAllianceGovernmentAresMissileNormal:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  self:AddUIListener(EventId.UpdateAresMissileState, self.UpdateData)
  self:AddUIListener(EventId.AllianceMember, self.UpdateData)
end

function UIAllianceGovernmentAresMissileNormal:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateAresMissileState, self.UpdateData)
  self:RemoveUIListener(EventId.AllianceMember, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIAllianceGovernmentAresMissileNormal:SwitchExpandMode()
  self.expand_node = not self.expand_node
  if self.expand_node then
    self.arrow:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_2.png")
  else
    self.arrow:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_1.png")
  end
  self:UpdateData()
end

function UIAllianceGovernmentAresMissileNormal:UpdateData()
  self.status_lock520:SetActive(false)
  self.status_ready610:SetActive(false)
  self.status_wait666:SetActive(false)
  self.status_success680:SetActive(false)
  self.status_fail680:SetActive(false)
  local cfg = self.cfg
  local stateData = self.timeInfo
  local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Deputy_Al_Leader)
  if memberInfo == nil or cfg == nil then
  elseif self.expand_node then
    if self.timeInfo == nil or self.leftUseTime == 0 then
      self.status_lock520:SetActive(true)
      self.status_lock520:ReInit(cfg, stateData, nil)
    else
      local now = UITimeManager:GetInstance():GetServerTime()
      local serverData = DataCenter.AllianceGovernmentSkillManager:GetUsedSkillStateDataByType(AlOfficialSkillType.MissileFactory)
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
  else
    self.name:SetLocalText("season_alliance_government_skill_41_name")
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

function UIAllianceGovernmentAresMissileNormal:ReInit()
  local timeInfo, cfg = GetFactoryMissileCountInfo()
  if timeInfo then
    self.leftUseTime = toInt(timeInfo.leftUseTime)
  else
    self.leftUseTime = 0
  end
  self.timeInfo = timeInfo
  self.cfg = cfg
  if cfg then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillDetail, cfg.id)
  end
  self:UpdateData()
end

function AresMissileStateNormalLock:OnCreate()
  base.OnCreate(self)
  self.sendRefreshRequest = false
  self.tips = self:AddComponent(UITextMeshProUGUIEx, "bg/tips")
  self.go_btn = self:AddComponent(UIButton, "GoBtn")
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "GoBtn/BtnText")
  self.go_btn:SetOnClick(function()
    local myServerId = LuaEntry.Player:GetSourceServerId()
    local enemyServer = DataCenter.ZoneWarManager:GetFightServerNow()
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(601, enemyServer)
    if cityTemplate ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.TryJumpToWorld({
        action = "Jump",
        pointId = cityTemplate:GetPointId(),
        server = enemyServer,
        worldId = 0
      })
    else
      UIUtil.ShowTipsId("avatar_tips006")
    end
  end)
end

function AresMissileStateNormalLock:OnDestroy()
  self.tips = nil
  self.go_btn = nil
  self.btn_text = nil
  base.OnDestroy(self)
end

function AresMissileStateNormalLock:Update1000MS()
end

function AresMissileStateNormalLock:ReInit(cfg, stateData, skillEffectData)
  self.cfg = cfg
  self.stateData = stateData
  self.tips:SetLocalText("season_activity_1000086_tips03")
  self.btn_text:SetLocalText("season_s2_ice_supplies_21")
end

function AresMissileStateNormalReady:OnCreate()
  base.OnCreate(self)
  self.sendRefreshRequest = false
  self.txt_count = self:AddComponent(UITextMeshProUGUIEx, "TxtCount")
  self.put_btn = self:AddComponent(UIButton, "PutBtn")
  self.put_btn:SetOnClick(function()
    TryPutMissile(self.cfg, self.timeInfo)
  end)
  self.tips = self:AddComponent(UITextMeshProUGUIEx, "bg/tips")
end

function AresMissileStateNormalReady:OnDestroy()
  self.put_btn = nil
  self.txt_count = nil
  base.OnDestroy(self)
end

function AresMissileStateNormalReady:Update1000MS()
end

function AresMissileStateNormalReady:ReInit(cfg, stateData, skillEffectData)
  local timeInfo = stateData
  if timeInfo then
    self.leftUseTime = toInt(timeInfo.leftUseTime)
  else
    self.leftUseTime = 0
  end
  self.cfg = cfg
  self.timeInfo = timeInfo
  self.stateData = stateData
  self.skillEffectData = skillEffectData
  self.tips:SetLocalText("season_activity_1000086_tips22")
  CS.UIGray.SetGray(self.put_btn.transform, self.leftUseTime == 0, self.leftUseTime > 0)
  self.txt_count:SetLocalText("season_activity_1000086_tips01", self.leftUseTime)
end

function AresMissileStateNormalWaitHelp:OnCreate()
  base.OnCreate(self)
  self.sendRefreshRequest = false
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, "bg/timeTxt")
  self.pos_txt = self:AddComponent(UITextMeshProUGUIEx, "posTxt")
  self.pos_txt:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.pos_txt, eventData)
  end)
  self.help_btn = self:AddComponent(UIButton, "HelpBtn")
  self.help_me_btn = self:AddComponent(UIButton, "HelpMeBtn")
  self.help_btn:SetOnClick(function()
    GoToUtil.DoPlayerAssistance(self.serverId, 0, self.startPos)
  end)
  self.help_me_btn:SetOnClick(function()
    local share_param = {}
    share_param.skillType = AlOfficialSkillType.MissileFactory
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

function AresMissileStateNormalWaitHelp:OnDestroy()
  self.time_txt = nil
  self.pos_txt = nil
  self.help_btn = nil
  self.help_me_btn = nil
  base.OnDestroy(self)
end

function AresMissileStateNormalWaitHelp:Update1000MS()
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

function AresMissileStateNormalWaitHelp:ReInit(cfg, stateData, skillEffectData)
  local timeInfo = stateData
  if timeInfo then
    self.leftUseTime = toInt(timeInfo.leftUseTime)
  else
    self.leftUseTime = 0
  end
  self.cfg = cfg
  self.timeInfo = timeInfo
  self.stateData = stateData
  self.skillEffectData = skillEffectData
  self.serverId = skillEffectData.serverId
  self.startPos = skillEffectData.startPos
  self.targetPos = skillEffectData.targetPos
  self.chantOverTime = skillEffectData.chantOverTime
  self.pos_txt:SetText(UIUtil.MakeJumpLink(skillEffectData.startPos, skillEffectData.serverId))
end

function AresMissileStateNormalSuccess:OnCreate()
  base.OnCreate(self)
  self.succ_tips = self:AddComponent(UITextMeshProUGUIEx, "bg/succ_tips")
  self.view_btn = self:AddComponent(UIButton, "BtnList/ViewBtn")
  self.next_tips = self:AddComponent(UITextMeshProUGUIEx, "bg2/next_tips")
  self.next_time = self:AddComponent(UITextMeshProUGUIEx, "bg2/next_time")
  self.skill_desc = self:AddComponent(UITextMeshProUGUIEx, "SkillDesc")
  self.thumbs_up_bg = self:AddComponent(UIButton, "ThumbsUpBg")
  self.thumbs_up_num = self:AddComponent(UITextMeshProUGUIEx, "ThumbsUpBg/ThumbsUpNum")
  self.view_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGovernmentSkillHurtList, {anim = true}, AlOfficialSkillType.MissileFactory)
  end)
  self.thumbs_up_bg:SetOnClick(function()
    local thumbsUpNumNow = toInt(self.thumbsUpNum)
    local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Deputy_Al_Leader)
    if memberInfo == nil then
    else
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      InteractiveUtil.TryThumbsUp(memberInfo.uid, InteractiveUtil.ThumbsUpType.GoodJobAresMissile, "10003", function(msg)
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
  self.txt_count = self:AddComponent(UITextMeshProUGUIEx, "TxtCount")
  self.put_btn = self:AddComponent(UIButton, "BtnList/PutBtn")
  self.put_btn:SetOnClick(function()
    TryPutMissile(self.cfg, self.timeInfo)
  end)
end

function AresMissileStateNormalSuccess:OnDestroy()
  self.succ_tips = nil
  self.view_btn = nil
  self.next_tips = nil
  self.next_time = nil
  self.skill_desc = nil
  self.thumbs_up_bg = nil
  self.thumbs_up_num = nil
  base.OnDestroy(self)
end

function AresMissileStateNormalSuccess:Update1000MS()
end

function AresMissileStateNormalSuccess:OnAddListener()
  base.OnAddListener(self)
end

function AresMissileStateNormalSuccess:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AresMissileStateNormalSuccess:OnThumbsUpNumUpdate()
end

function AresMissileStateNormalSuccess:ReInit(cfg, stateData, skillEffectData)
  local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Deputy_Al_Leader)
  self.thumbs_up_bg:SetActive(memberInfo ~= nil)
  local timeInfo = stateData
  if timeInfo then
    self.leftUseTime = toInt(timeInfo.leftUseTime)
  else
    self.leftUseTime = 0
  end
  self.cfg = cfg
  self.stateData = stateData
  self.timeInfo = timeInfo
  self.thumbsUpNum = toInt(skillEffectData.thumbsUpNum)
  self.succ_tips:SetLocalText("140057", "")
  if skillEffectData.result then
    self.skill_desc:SetLocalText("season_activity_1000086_tips20", table.count(skillEffectData.result.beAttackUserList))
  else
    self.skill_desc:SetLocalText("season_activity_1000086_tips20", "0")
  end
  self.nextBattleTime = toInt(stateData.nextBattleTime)
  self.next_tips:SetLocalText("456018", "")
  self.next_time:SetActive(true)
  self.thumbs_up_num:SetText(self.thumbsUpNum)
  CS.UIGray.SetGray(self.put_btn.transform, self.leftUseTime == 0, self.leftUseTime > 0)
  self.txt_count:SetLocalText("season_activity_1000086_tips01", self.leftUseTime)
end

function AresMissileStateNormalFail:OnCreate()
  base.OnCreate(self)
  self.fail_tips = self:AddComponent(UITextMeshProUGUIEx, "bg/fail_tips")
  self.next_tips = self:AddComponent(UITextMeshProUGUIEx, "bg2/next_tips")
  self.next_time = self:AddComponent(UITextMeshProUGUIEx, "bg2/next_time")
  self.player_head = self:AddComponent(UICommonHead, "info/UIPlayerHead")
  self.skill_desc = self:AddComponent(UITextMeshProUGUIEx, "info/SkillDesc")
  self.player_head:SetEnableClickShowInfo(true, true)
  self.txt_count = self:AddComponent(UITextMeshProUGUIEx, "TxtCount")
  self.put_btn = self:AddComponent(UIButton, "PutBtn")
  self.put_btn:SetOnClick(function()
    TryPutMissile(self.cfg, self.timeInfo)
  end)
end

function AresMissileStateNormalFail:OnDestroy()
  self.fail_tips = nil
  self.next_tips = nil
  self.next_time = nil
  self.player_head = nil
  self.skill_desc = nil
  base.OnDestroy(self)
end

function AresMissileStateNormalFail:Update1000MS()
end

function AresMissileStateNormalFail:ReInit(cfg, stateData, skillEffectData)
  local timeInfo = stateData
  if timeInfo then
    self.leftUseTime = toInt(timeInfo.leftUseTime)
  else
    self.leftUseTime = 0
  end
  self.cfg = cfg
  self.timeInfo = timeInfo
  self.fail_tips:SetLocalText("140058", "")
  if skillEffectData.state == 2 and skillEffectData.result and skillEffectData.result.interruptUser then
    local user = skillEffectData.result.interruptUser
    local interruptUser = UIUtil.FormatServerAllianceName(user.serverId, user.abbr, user.name)
    self.player_head:SetActive(true)
    self.player_head:ParseHeadInfo(user)
    self.skill_desc:SetLocalText("season_activity_1000086_tips17", interruptUser)
  else
    self.player_head:SetActive(false)
    self.skill_desc:SetLocalText("season_activity_1000086_tips18", "")
  end
  self.nextBattleTime = toInt(stateData.nextBattleTime)
  self.next_tips:SetLocalText("456018", "")
  self.next_time:SetActive(true)
  CS.UIGray.SetGray(self.put_btn.transform, self.leftUseTime == 0, self.leftUseTime > 0)
  self.txt_count:SetLocalText("season_activity_1000086_tips01", self.leftUseTime)
end

return UIAllianceGovernmentAresMissileNormal
