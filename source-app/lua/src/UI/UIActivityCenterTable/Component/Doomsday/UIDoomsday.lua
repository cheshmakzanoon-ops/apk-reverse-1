local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIDoomsday = BaseClass("UIDoomsday", base)
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local BossItem = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayBossItem")

local function __UpdateGuardian(self)
  if not self.vo or not self.vo.guardian then
    self.txtName:SetText("")
    self.txtKill:SetText("")
    self.head:SetHead(nil, "Assets/Main/Sprites/UI/LWPVPArena/lrb_jingjichang_touxiang_kong.png")
  else
    self.txtName:SetText(self.vo.guardian.nameStr)
    self.txtKill:SetLocalText("doomsday_activity_tips1002", string.GetFormattedStr(self.vo.guardian.killPoint))
    self.head:SetHeadAndFrame(self.vo.guardian.uid, self.vo.guardian.pic, self.vo.guardian.picVer, false, self.vo.guardian.headSkinId, self.vo.guardian.headSkinET)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutG1.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutG2.transform)
end

local function __UpdateBosses(self, resetScrollPos)
  local tab = self.currTab or "alliance"
  local bosses = {}
  if self.vo then
    bosses = tab == "alliance" and self.vo.allianceBosses or self.vo.theaterBosses
  end
  table.sort(bosses, function(a, b)
    local a_special = tonumber(GetTableData(TableName.Monster, a.monsterId, "special"))
    local b_special = tonumber(GetTableData(TableName.Monster, b.monsterId, "special"))
    if a_special == WorldMonsterSpecialType.SuperRunningBoss and b_special ~= WorldMonsterSpecialType.SuperRunningBoss then
      return true
    elseif a_special ~= WorldMonsterSpecialType.SuperRunningBoss and b_special == WorldMonsterSpecialType.SuperRunningBoss then
      return false
    end
    if a.refreshTime and b.refreshTime then
      return a.refreshTime < b.refreshTime
    end
  end)
  self.contentBosses:RemoveComponents(BossItem)
  self.itemBoss:GameObjectRecycleAll()
  self.bossItems = {}
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  for i, boss in ipairs(bosses) do
    local remainTime = boss.refreshTime and boss.refreshTime - serverTime or 0
    if 0 < remainTime then
      local itemLbl = "item_" .. i
      local newItem = self.itemBoss:GameObjectSpawn(self.contentBosses.transform)
      newItem.name = itemLbl
      newItem:SetActive(true)
      local itemComp = self.contentBosses:AddComponent(BossItem, itemLbl)
      itemComp:Refresh(boss)
      table.insert(self.bossItems, itemComp)
    end
  end
  self.txtEmpty:SetActive(#self.bossItems <= 0)
  if resetScrollPos then
    self.scrollBosses:SetHorizontalNormalizedPosition(0)
  end
end

local function __UpdateTabs(self)
  local allianceBosses = self.vo and self.vo.allianceBosses or {}
  local theaterBosses = self.vo and self.vo.theaterBosses or {}
  self.txtAllianceOn:SetText(Localization:GetString("doomsday_activity_tips1003") .. "(" .. #allianceBosses .. ")")
  self.txtAllianceOff:SetText(Localization:GetString("doomsday_activity_tips1003") .. "(" .. #allianceBosses .. ")")
  self.txtThreaterOn:SetText(Localization:GetString("doomsday_activity_tips1004") .. "(" .. #theaterBosses .. ")")
  self.txtThreaterOff:SetText(Localization:GetString("doomsday_activity_tips1004") .. "(" .. #theaterBosses .. ")")
end

local function __UpdateRedDot(self, count)
  self.dotReward:SetActive(0 < count)
end

local function __OnTick(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local remainEndTime = self.vo and self.vo.endTime and self.vo.endTime - serverTime or 0
  if 0 < remainEndTime then
    self.txtEndTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainEndTime))
  else
    self.txtEndTime:SetText("00:00:00")
  end
  local remainBossTime = self.vo and self.vo.bossTime and self.vo.bossTime - serverTime or 0
  local time = self.appendTime * 60 * 1000
  if 0 < remainBossTime then
    if 0 < remainEndTime and remainBossTime == time and not self.reachBossTime then
      SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayMainInfo)
      self.reachBossTime = true
    else
      self.reachBossTime = nil
    end
  elseif 0 < remainEndTime and not self.reachBossTime then
    SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayMainInfo)
    self.reachBossTime = true
  end
  if self.bossItems then
    local needRefreshBosses = false
    for _, bossItem in pairs(self.bossItems) do
      needRefreshBosses = needRefreshBosses or bossItem:OnTick()
    end
    if needRefreshBosses then
      __UpdateBosses(self)
      SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayMainInfo)
    end
  end
end

local function __RefreshView(self, vo)
  self.vo = vo
  __UpdateGuardian(self)
  __UpdateBosses(self)
  __UpdateTabs(self)
  __OnTick(self)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.top.transform)
end

local function __SelectTab(self, tab)
  if not self.vo then
    return
  end
  if self.currTab == tab then
    return
  end
  self.currTab = tab
  self.tabAllianceOn:SetActive(tab == "alliance")
  self.tabThreaterOn:SetActive(tab == "threater")
  __UpdateBosses(self, true)
end

local function __ShowRules(self)
  if not self.vo then
    return
  end
  local params = {}
  params.activityId = self.vo.activityId
  if self.newRuleStr then
    params.activityRulesStr = Localization:GetString(self.newRuleStr)
  else
    params.activityRulesStr = self.vo.ruleStr
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, params)
end

local function __ShowDetails(self, tab)
  if not self.vo then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDoomsdayDetails, {anim = true}, tab)
end

local function __DelSingleBoss(self, bossId)
  if not self.vo then
    return
  end
  for i, boss in ipairs(self.vo.allianceBosses) do
    if boss.monsterId == bossId then
      table.remove(self.vo.allianceBosses, i)
      if self.currTab == "alliance" then
        __UpdateBosses(self)
      end
      return
    end
  end
  for i, boss in ipairs(self.vo.theaterBosses) do
    if boss.monsterId == bossId then
      table.remove(self.vo.theaterBosses, i)
      if self.currTab == "threater" then
        __UpdateBosses(self)
      end
      return
    end
  end
end

local compBook = {
  {
    path = "root/top",
    name = "top",
    type = UIBaseContainer
  },
  {
    path = "root/top/nodeTime/txtTime",
    name = "txtEndTime",
    type = UIText,
    text = ""
  },
  {
    path = "root/txtRefresh",
    name = "txtBossTime",
    type = UIText,
    text = ""
  },
  {
    path = "root/right/btnIntro",
    name = "btnIntro",
    type = UIButton,
    onClick = function(self)
      __ShowRules(self)
    end
  },
  {
    path = "root/right/btnRank",
    name = "btnRank",
    type = UIButton,
    onClick = function(self)
      __ShowDetails(self, "rank")
    end
  },
  {
    path = "root/right/btnReward",
    name = "btnReward",
    type = UIButton,
    onClick = function(self)
      __ShowDetails(self, "achieve")
    end
  },
  {
    path = "root/right/btnReward/dotReward",
    name = "dotReward",
    type = nil,
    active = false
  },
  {
    path = "root/bottom/guardian/layout",
    name = "layoutG1",
    type = UIBaseContainer
  },
  {
    path = "root/bottom/guardian/layout/info",
    name = "layoutG2",
    type = UIBaseContainer
  },
  {
    path = "root/bottom/guardian/layout/head",
    name = "head",
    type = UICommonHead
  },
  {
    path = "root/bottom/guardian/layout/info/txtName",
    name = "txtName",
    type = UIText,
    text = ""
  },
  {
    path = "root/bottom/guardian/layout/info/txtKill",
    name = "txtKill",
    type = UIText,
    text = ""
  },
  {
    path = "root/bottom/tabs/layout/tab1",
    name = "tabAlliance",
    type = UIButton,
    onClick = function(self)
      __SelectTab(self, "alliance")
    end
  },
  {
    path = "root/bottom/tabs/layout/tab2",
    name = "tabThreater",
    type = UIButton,
    onClick = function(self)
      __SelectTab(self, "threater")
    end
  },
  {
    path = "root/bottom/tabs/layout/tab1/tab1_On",
    name = "tabAllianceOn",
    type = nil,
    active = true
  },
  {
    path = "root/bottom/tabs/layout/tab2/tab2_On",
    name = "tabThreaterOn",
    type = nil,
    active = false
  },
  {
    path = "root/bottom/tabs/layout/tab1/tab1_On/txtTab1_On",
    name = "txtAllianceOn",
    type = UIText
  },
  {
    path = "root/bottom/tabs/layout/tab2/tab2_On/txtTab2_On",
    name = "txtThreaterOn",
    type = UIText
  },
  {
    path = "root/bottom/tabs/layout/tab1/txtTab1_Off",
    name = "txtAllianceOff",
    type = UIText
  },
  {
    path = "root/bottom/tabs/layout/tab2/txtTab2_Off",
    name = "txtThreaterOff",
    type = UIText
  },
  {
    path = "root/bottom/txtEmpty",
    name = "txtEmpty",
    type = UIText,
    textKey = "doomsday_activity_tips1006",
    active = true
  },
  {
    path = "root/bottom/monsters",
    name = "scrollBosses",
    type = UIScrollRect
  },
  {
    path = "root/bottom/monsters/Viewport/Content",
    name = "contentBosses",
    type = UIBaseContainer
  },
  {
    path = "root/bottom/monsters/itemMonster",
    name = "itemBoss",
    type = nil,
    active = false
  },
  {
    path = "bg/image",
    name = "imageBg",
    type = UIRawImage
  }
}

function UIDoomsday:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.timer = TimerManager:GetInstance():GetTimer(1, __OnTick, self, false, false, false)
  self.timer:Start()
  self:InitDatas(self)
  __RefreshView(self, nil)
  SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayMainInfo)
end

function UIDoomsday:InitDatas(self)
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("running_boss_willy")
  if configOpenState then
    local result = DataCenter.LWDoomsdayManager:OnGetSuperBossActivityInfo()
    if result ~= nil and result.season then
      local nowSeason = SeasonUtil.GetSeason()
      local nowSeasonDay = SeasonUtil.GetSeasonDay()
      if result.season == nowSeason and nowSeasonDay >= result.days or nowSeason > result.season then
        self.newRuleStr = result.ruleStr
        self.imageBg:LoadSprite(result.resourcePath)
      end
    end
  end
  self.appendTime = LuaEntry.DataConfig:TryGetNum("running_monster", "k8", 0)
end

function UIDoomsday:OnDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.vo = nil
  self.newRuleStr = nil
  self.appendTime = nil
end

function UIDoomsday:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.head:SetEnableClickShowInfo(true, true)
  self.itemBoss:GameObjectCreatePool()
  self.bossItems = {}
  self.txtBossTime:SetActive(false)
end

function UIDoomsday:ComponentDestroy()
  self.contentBosses:RemoveComponents(BossItem)
  self.itemBoss:GameObjectRecycleAll()
  self.bossItems = nil
  self:ClearCompsByBook(compBook)
end

function UIDoomsday:OnAddListener()
  base.OnAddListener(self)
  self.notiBook = {}
  Notifier.AddListener("UIDoomsday.Refresh", __RefreshView, self, self.notiBook)
  Notifier.AddListener("UIDoomsday.RefreshReddot", __UpdateRedDot, self, self.notiBook)
  Notifier.AddListener("UIDoomsday.DelSingleBoss", __DelSingleBoss, self, self.notiBook)
end

function UIDoomsday:OnRemoveListener()
  Notifier.RemoveListenerByBook(self.notiBook)
  base.OnRemoveListener(self)
end

return UIDoomsday
