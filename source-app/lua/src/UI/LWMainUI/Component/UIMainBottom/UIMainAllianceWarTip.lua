local UIMainAllianceWarTip = BaseClass("UIMainAllianceWarTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = "btn"
local red_point_num_path = "RedPointNum"
local text_path = "RedPointNum/Text"
local time_txt_path = "timeTxt"
local war_bubble_tip_path = "warBubbleTip"
local tip_txt_path = "warBubbleTip/tipTxt"
local timeBg = "timeBg"
local showTipTime = 3

function UIMainAllianceWarTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.tipHideTimer = nil
  self:CheckRedPoint()
  self.tipCom:SetActive(false)
end

function UIMainAllianceWarTip:OnDestroy()
  self:DeleteTimer()
  self:DeleteTipTimer()
  self:ComponentDestroy()
  self:StopShareAllianceWarTimer()
  base.OnDestroy(self)
end

function UIMainAllianceWarTip:StopShareAllianceWarTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainAllianceWarTip:OnEnable()
  base.OnEnable(self)
end

function UIMainAllianceWarTip:OnDisable()
  base.OnDisable(self)
end

function UIMainAllianceWarTip:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnJoinClick()
  end)
  self.red_point_num = self:AddComponent(UIBaseContainer, red_point_num_path)
  self.text = self:AddComponent(UIText, text_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.war_bubble_tip = self:AddComponent(UIBaseContainer, war_bubble_tip_path)
  self.tip_txt = self:AddComponent(UIText, tip_txt_path)
  self.timeBgGO = self:AddComponent(UIBaseContainer, timeBg)
  self.red_point_num:SetActive(LuaEntry.Player:GetCurWorldId() == 0)
  self.tipText = self:AddComponent(UITextMeshProUGUIEx, "CommonTIps/bg/tipTxt")
  self.tipBtnText = self:AddComponent(UITextMeshProUGUIEx, "CommonTIps/bg/gotoBtn/gotoTxt")
  self.tipBtn = self:AddComponent(UIButton, "CommonTIps/bg/gotoBtn")
  self.tipCom = self:AddComponent(UIBaseContainer, "CommonTIps")
  self.tipText:SetLocalText("rally_share_guide_notice")
  self.tipBtnText:SetLocalText("390198")
  self.tipBtn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
end

function UIMainAllianceWarTip:OnTipBtnClick()
  self.tipCom:SetActive(false)
  if not self.data or not self.data.uuid then
    return
  end
  local warData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.data.uuid)
  local monster
  if warData then
    monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(warData.targetUid)
  end
  if monster and self:GetIsShowShareAllianceWar(monster) then
    local shareParam = {}
    shareParam.post = PostType.Alliance_War
    shareParam.sid = LuaEntry.Player:GetSelfServerId()
    shareParam.targetUid = self.data.uuid
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
  end
end

function UIMainAllianceWarTip:ComponentDestroy()
  self:DeleteTimer()
  self:DeleteTipTimer()
  self.btn = nil
  self.red_point_num = nil
  self.text = nil
  self.time_txt = nil
  self.war_bubble_tip = nil
  self.tip_txt = nil
  self.timeBgGO = nil
end

function UIMainAllianceWarTip:DeleteTimer()
  if self.tickTimer ~= nil then
    self.tickTimer:Stop()
    self.tickTimer = nil
  end
end

function UIMainAllianceWarTip:StartTimer()
  self.tickTimer = TimerManager:GetInstance():GetTimer(1, self.OnTick, self, false, false, false)
  self.tickTimer:Start()
end

function UIMainAllianceWarTip:DeleteTipTimer()
  if self.tipHideTimer ~= nil then
    self.tipHideTimer:Stop()
    self.tipHideTimer = nil
  end
end

function UIMainAllianceWarTip:OnTick()
  local remainTime = self.waitTime - UITimeManager:GetInstance():GetServerTime()
  if 0 < remainTime then
    self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.time_txt:SetLocalText(390789)
    self:DeleteTimer()
    DataCenter.AllianceWarDataManager:CalculateMainUIRallyTipNum()
  end
end

function UIMainAllianceWarTip:CheckRedPoint()
  local redNum = DataCenter.AllianceWarDataManager:GetMainUIRallyTipNum()
  local dataNum = DataCenter.AllianceWarDataManager:GetShowListDataCount()
  self:SetActive(0 < dataNum)
  self.text:SetText(redNum)
  self.war_bubble_tip:SetActive(false)
  if redNum == 0 and BattleFieldUtil.InBattleField() then
    self:SetActive(0 < table.count(DataCenter.AllianceWarDataManager.AllianceWarList))
  end
  self.waitTime = 0
  self:DeleteTimer()
  if 0 < redNum then
    self.timeBgGO:SetActive(true)
    self.red_point_num:SetActive(not BattleFieldUtil.InBattleField())
    local theOldestCanJoinRallyUuid = DataCenter.AllianceWarDataManager:GetOldestCanJoinRallyUuid()
    if not string.IsNullOrEmpty(theOldestCanJoinRallyUuid) then
      local warData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(theOldestCanJoinRallyUuid)
      if warData then
        self.waitTime = warData.waitTime
        self:StartTimer()
      end
    end
    self:OnTick()
  else
    self.time_txt:SetText("")
    self.text:SetText("")
    self.timeBgGO:SetActive(false)
    self.red_point_num:SetActive(false)
  end
end

local function GetTargetName(oneData)
  if oneData.type == AllianceTeamType.ATTACK_BOSS then
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(oneData.targetUid)
    return Localization:GetString("300665", monster.level) .. Localization:GetString(monster.name)
  elseif oneData.type == AllianceTeamType.ATTACK_AL_CITY then
    local name = oneData.targetName
    if name == nil or name == "" then
      name = GetTableData(TableName.WorldCity, oneData.targetContentId, "name")
      name = Localization:GetString(name)
    end
    local lv = GetTableData(TableName.WorldCity, oneData.targetContentId, "level")
    return "[" .. oneData.targetAllianceAbbr .. "]" .. Localization:GetString("310161", name, lv)
  elseif oneData.type == AllianceTeamType.ATTACK_CITY then
    if string.IsNullOrEmpty(oneData.targetAllianceAbbr) then
      return oneData.targetName
    else
      return "[" .. oneData.targetAllianceAbbr .. "]" .. oneData.targetName
    end
  elseif oneData.type == AllianceTeamType.ATTACK_EPIDEMIC_CITY then
    if string.IsNullOrEmpty(oneData.targetAllianceAbbr) then
      return oneData.targetName
    else
      return "[" .. oneData.targetAllianceAbbr .. "]" .. oneData.targetName
    end
  end
  return ""
end

local function GetTipContent(data)
  local ret = ""
  local oneData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(data.uuid)
  if oneData == nil then
    return ret
  end
  local self_uid = LuaEntry.Player.uid
  local tartgetName = GetTargetName(oneData)
  if oneData.attackUid == self_uid then
    ret = Localization:GetString("455098", tartgetName)
  else
    ret = Localization:GetString("390802", oneData.attackName, tartgetName)
  end
  return ret
end

function UIMainAllianceWarTip:GetIsShowShareAllianceWar(monster)
  if not monster then
    return
  end
  if monster.special == WorldMonsterSpecialType.MonsterInvasionBoss or monster.special == WorldMonsterSpecialType.RunningMonster or monster.special == WorldMonsterSpecialType.AllyChallengeBoss or monster.special == WorldMonsterSpecialType.SuperRunningBoss then
    return true
  end
  return monster.initiative_share
end

function UIMainAllianceWarTip:ShowShareTip(data)
  self.tipCom:SetActive(false)
  if not data then
    return
  end
  local warData
  warData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(data.uuid)
  if warData and warData.type == AllianceTeamType.ATTACK_BOSS then
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(warData.targetUid)
    if self:GetIsShowShareAllianceWar(monster) and warData.leaderMarch and warData.leaderMarch.ownerUid == LuaEntry.Player.uid then
      self:StopShareAllianceWarTimer()
      self.tipCom:SetActive(true)
      self.timer = TimerManager:GetInstance():GetTimer(showTipTime, function()
        self.tipCom:SetActive(false)
      end, self, false, false, false)
      self.timer:Start()
    end
  end
end

function UIMainAllianceWarTip:RefreshTip(data)
  self:CheckRedPoint()
  if self:GetActive() == false then
    return
  end
  self.data = data
  self:ShowShareTip(data)
  self.war_bubble_tip:SetActive(true)
  self.tip_txt:SetText(GetTipContent(data))
  self:DeleteTipTimer()
  self.tipHideTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.war_bubble_tip:SetActive(false)
    self.tipHideTimer = nil
  end, 5)
end

function UIMainAllianceWarTip:OnJoinClick()
  self:DeleteTipTimer()
  self.war_bubble_tip:SetActive(false)
  DataCenter.AllianceWarDataManager:OpenALWarMain(true, AllianceWarTabType.Rally, nil, "FromMainUI")
end

return UIMainAllianceWarTip
