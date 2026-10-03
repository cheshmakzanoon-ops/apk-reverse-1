local base = UIAsyncContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local GuardianTowerLock = BaseClass("GuardianTowerLock", UIBaseContainer)
local GuardianTowerReady = BaseClass("GuardianTowerReady", UIBaseContainer)
local UIAllianceGovernmentGuardianTowerSkill = BaseClass("UIAllianceGovernmentGuardianTowerSkill", UIAsyncContainer)

function UIAllianceGovernmentGuardianTowerSkill:OnCreate()
  base.OnCreate(self)
  self.expand_node = true
  self.theRuleItem = self.transform:Find("Desc/Rule").gameObject
  self.theRuleItem:GameObjectCreatePool()
  self.name = self:AddComponent(UITextMeshProUGUIEx, "Name")
  self.btn_info = self:AddComponent(UIButton, "BtnInfo")
  self.item_icon = self:AddComponent(UIImage, "ImgQuality/ItemIcon")
  self.skill_title = self:AddComponent(UITextMeshProUGUIEx, "Desc/SkillTitle")
  self.skill_desc = self:AddComponent(UITextMeshProUGUIEx, "Desc/SkillDesc")
  self.status_lock520 = self:AddComponent(GuardianTowerLock, "StatusLock520")
  self.status_ready610 = self:AddComponent(GuardianTowerReady, "StatusReady610")
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

function UIAllianceGovernmentGuardianTowerSkill:OnDestroy()
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
  base.OnDestroy(self)
end

function UIAllianceGovernmentGuardianTowerSkill:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  self:AddUIListener(EventId.UpdateGuardianTowerSkillState, self.UpdateData)
  self:AddUIListener(EventId.LWSeasonFactionWarDetailUpdate, self.UpdateData)
  self:AddUIListener(EventId.AllianceMember, self.UpdateData)
end

function UIAllianceGovernmentGuardianTowerSkill:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateGuardianTowerSkillState, self.UpdateData)
  self:RemoveUIListener(EventId.LWSeasonFactionWarDetailUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.AllianceMember, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIAllianceGovernmentGuardianTowerSkill:SwitchExpandMode()
  self.expand_node = not self.expand_node
  if self.expand_node then
    self.arrow:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_2.png")
  else
    self.arrow:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_1.png")
  end
  self:UpdateData()
end

function UIAllianceGovernmentGuardianTowerSkill:UpdateData()
  if self.status_lock520 == nil or self.status_ready610 == nil then
    return
  end
  self.status_lock520:SetActive(false)
  self.status_ready610:SetActive(false)
  local cfg = self.cfg
  local stateData = DataCenter.AllianceGovernmentSkillManager:GetSkillActivityData(AlOfficialSkillType.GuardianTower)
  local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Al_Ambassadoe)
  if memberInfo == nil or cfg == nil then
  elseif self.expand_node and stateData then
    local currStep = toInt(stateData.currStep)
    local joinAct = stateData.joinAct
    if joinAct ~= true or currStep < SeasonFactionDeclareWarStep.battle_before then
      self.status_lock520:SetActive(true)
      self.status_lock520:ReInit(cfg, stateData, nil)
    else
      local serverData, coolOverTime = DataCenter.AllianceGovernmentSkillManager:GetUsedSkillStateDataByType(AlOfficialSkillType.GuardianTower)
      self.status_ready610:SetActive(true)
      self.status_ready610:ReInit(cfg, stateData, serverData, coolOverTime)
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

function UIAllianceGovernmentGuardianTowerSkill:ReInit()
  local cfg
  local skillList = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigsByOfficial(LWAlMemberOffcialType.Al_Ambassadoe)
  if skillList then
    for _, v in ipairs(skillList) do
      if v and v.skill_flag == AlOfficialSkillType.GuardianTower then
        cfg = v
      end
    end
  end
  self.cfg = cfg
  if cfg then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillDetail, cfg.id)
  end
  self:UpdateData()
end

function GuardianTowerLock:OnCreate()
  base.OnCreate(self)
  self.sendRefreshRequest = false
  self.bg = self:AddComponent(UIImage, "bg")
  self.tips = self:AddComponent(UITextMeshProUGUIEx, "bg/tips")
  self.go_btn = self:AddComponent(UIButton, "GoBtn")
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "GoBtn/BtnText")
  self.go_btn:SetOnClick(function()
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    if theStoveCenter ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.TryJumpToWorld({
        action = "Jump",
        pointId = theStoveCenter.pointId,
        server = theStoveCenter.srcServerId,
        worldId = 0
      })
    else
      UIUtil.ShowTipsId("avatar_tips006")
    end
  end)
end

function GuardianTowerLock:OnDestroy()
  self.tips = nil
  self.go_btn = nil
  self.btn_text = nil
  self.bg = nil
  base.OnDestroy(self)
end

function GuardianTowerLock:ReInit(cfg, stateData, skillEffectData)
  local currStep = toInt(stateData.currStep)
  local joinAct = stateData.joinAct
  local hasBattle = stateData.hasBattle
  self.cfg = cfg
  self.stateData = stateData
  self.skillEffectData = skillEffectData
  self.endTime = nil
  self.btn_text:SetLocalText("110088")
  self.bg:SetActive(true)
  if joinAct ~= true or hasBattle ~= true and currStep == SeasonFactionDeclareWarStep.battle then
    self.tips:SetLocalText("season_alliance_government_skill_26")
  else
    self.endTime = toInt(stateData.currBattleStartTime or stateData.battleStartTime or stateData.nextBattleTime)
    self:Update1000MS()
  end
end

function GuardianTowerLock:Update1000MS()
  if self.endTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - now
    if 0 < remainTime then
      self.tips:SetText(string.format([[
%s
%s]], Localization:GetString("458012"), UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
    else
      self.bg:SetActive(false)
      self.endTime = nil
      if self.cfg and not self.sendRefreshRequest then
        self.sendRefreshRequest = true
        SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillDetail, self.cfg.id)
      end
    end
  end
end

function GuardianTowerReady:OnCreate()
  base.OnCreate(self)
  self.sendRefreshRequest = false
  self.bg = self:AddComponent(UIImage, "bg")
  self.tips = self:AddComponent(UITextMeshProUGUIEx, "bg/tips")
  self.put_btn = self:AddComponent(UIButton, "PutBtn")
  self.put_btn_text = self:AddComponent(UITextMeshProUGUIEx, "PutBtn/PutBtnText")
  self.put_btn:SetOnClick(function()
    if self.error_tips then
      UIUtil.ShowTipsId(self.error_tips)
      return
    end
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    if theStoveCenter ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.TryJumpToWorld({
        action = "Jump",
        pointId = theStoveCenter.pointId,
        server = theStoveCenter.srcServerId,
        worldId = 0
      })
    else
      UIUtil.ShowTipsId("avatar_tips006")
    end
  end)
end

function GuardianTowerReady:OnDestroy()
  self.bg = nil
  self.tips = nil
  self.put_btn = nil
  self.put_btn_text = nil
  base.OnDestroy(self)
end

function GuardianTowerReady:Update1000MS()
  if self.coolOverTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.coolOverTime - now
    if 0 < remainTime then
      self.tips:SetLocalText("zombieRush_tips_03", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.coolOverTime = nil
      self.bg:SetActive(false)
      self.btn_text:SetLocalText("challenge_zombie_btn02")
      if self.cfg and not self.sendRefreshRequest then
        self.sendRefreshRequest = true
        SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillDetail, self.cfg.id)
      end
      CS.UIGray.SetGray(self.put_btn.transform, false, true)
    end
  elseif self.effectOverTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.effectOverTime - now
    if 0 < remainTime then
      self.tips:SetLocalText("alliance_government_10005_23", math.ceil(remainTime / 1000))
    else
      self.effectOverTime = nil
      self.bg:SetActive(false)
      self.btn_text:SetLocalText("challenge_zombie_btn02")
      if self.cfg and not self.sendRefreshRequest then
        self.sendRefreshRequest = true
        SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillDetail, self.cfg.id)
      end
      CS.UIGray.SetGray(self.put_btn.transform, false, true)
    end
  end
end

function GuardianTowerReady:ReInit(cfg, stateData, skillEffectData, coolOverTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  local factionMgr = DataCenter.SeasonFactionWarDataManager
  local defenderAllianceId = factionMgr.defenderAllianceId
  local is_defender = defenderAllianceId == LuaEntry.Player.allianceId
  local is_ambassadoe = false
  local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Al_Ambassadoe)
  if memberInfo ~= nil and memberInfo.uid == LuaEntry.Player.uid then
    is_ambassadoe = true
  end
  self.coolOverTime = nil
  self.effectOverTime = nil
  self.error_tips = nil
  self.cfg = cfg
  self.stateData = stateData
  self.skillEffectData = skillEffectData
  if not is_defender then
    self.error_tips = "alliance_government_10005_21"
    self.bg:SetActive(true)
    self.tips:SetLocalText(self.error_tips)
    self.put_btn_text:SetLocalText("decoration_skill_desc5")
    CS.UIGray.SetGray(self.put_btn.transform, true, true)
    return
  end
  if not is_ambassadoe then
    self.error_tips = "alliance_government_10005_22"
    self.bg:SetActive(true)
    self.tips:SetLocalText(self.error_tips)
    self.put_btn_text:SetLocalText("decoration_skill_desc5")
    CS.UIGray.SetGray(self.put_btn.transform, true, true)
    return
  end
  if skillEffectData == nil then
    if now < toInt(coolOverTime) then
      self.coolOverTime = toInt(coolOverTime)
      self.bg:SetActive(true)
      self.put_btn_text:SetLocalText("110088")
      CS.UIGray.SetGray(self.put_btn.transform, false, true)
      self:Update1000MS()
    else
      self.bg:SetActive(true)
      self.tips:SetLocalText("alliance_government_10005_10")
      self.put_btn_text:SetLocalText("challenge_zombie_btn02")
      CS.UIGray.SetGray(self.put_btn.transform, false, true)
    end
  else
    if coolOverTime == nil then
      coolOverTime = toInt(skillEffectData.coolOverTime)
    end
    local effectOverTime = toInt(skillEffectData.effectOverTime)
    if now < effectOverTime then
      self.effectOverTime = effectOverTime
      self.bg:SetActive(true)
      self.put_btn_text:SetLocalText("110088")
      CS.UIGray.SetGray(self.put_btn.transform, false, true)
      self:Update1000MS()
    elseif now < coolOverTime then
      self.coolOverTime = coolOverTime
      self.bg:SetActive(true)
      self.put_btn_text:SetLocalText("110088")
      CS.UIGray.SetGray(self.put_btn.transform, false, true)
      self:Update1000MS()
    else
      self.bg:SetActive(true)
      self.tips:SetLocalText("alliance_government_10005_10")
      self.put_btn_text:SetLocalText("challenge_zombie_btn02")
      CS.UIGray.SetGray(self.put_btn.transform, false, true)
    end
  end
end

return UIAllianceGovernmentGuardianTowerSkill
