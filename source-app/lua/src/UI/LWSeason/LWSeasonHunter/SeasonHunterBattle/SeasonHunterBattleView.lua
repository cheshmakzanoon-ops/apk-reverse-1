local base = UIBaseView
local SeasonHunterBattle = BaseClass("SeasonHunterBattle", base)
local SeasonHunterServerItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterServerItem")
local Localization = CS.GameEntry.Localization
local btnBack_path = "Root/Common_img_title/CloseBtn"
local btnClose_path = "panel"
local myInfo_path = "Root/MiddleContent/MyInfo"
local emptyText_path = "Root/MiddleContent/EmptyText"
local killText_path = "Root/MiddleContent/MyInfo/killText"
local rankText_path = "Root/MiddleContent/MyInfo/rankText"
local durationTime_path = "Root/MiddleContent/MyInfo/durationTime"
local leftText_path = "Root/MiddleContent/BattleInfo/leftRoot/leftText"
local deadText_path = "Root/MiddleContent/BattleInfo/deadRoot/deadText"
local leftTime_path = "Root/MiddleContent/BattleInfo/leftTime"
local serverList_path = "Root/MiddleContent/BattleInfo/ServerList"
local hunterServerItem_path = "Root/MiddleContent/BattleInfo/ServerList/HunterServerItem"
local movecity_path = "Root/MiddleContent/BattleInfo/movecity"
local movecity_btn_path = "Root/MiddleContent/BattleInfo/movecity/movecityBtn"
local btnRank_path = "Root/MiddleContent/rankBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.SeasonHunterGetActivityInfo)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.myInfo = self:AddComponent(UIBaseContainer, myInfo_path)
  self.emptyText = self:AddComponent(UIBaseContainer, emptyText_path)
  self.killText = self:AddComponent(UIText, killText_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.durationTime = self:AddComponent(UIText, durationTime_path)
  self.leftText = self:AddComponent(UIText, leftText_path)
  self.deadText = self:AddComponent(UIText, deadText_path)
  self.leftTime = self:AddComponent(UIText, leftTime_path)
  self.serverList = self:AddComponent(UIBaseContainer, serverList_path)
  self.hunterServerItem = self:AddComponent(UIBaseContainer, hunterServerItem_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.serverObj = self.hunterServerItem.gameObject
  self.serverObj:GameObjectCreatePool()
  self.serverObj:SetActive(false)
  self.movecity = self:AddComponent(UITextMeshProUGUIEx, movecity_path)
  self.movecity:SetActive(false)
  self.movecity_btn = self:AddComponent(UIButton, movecity_btn_path)
  self.movecity_btn:SetOnClick(function()
    local content = Localization:GetString("season_mastery_s4_tips_18")
    UIUtil.ShowBubbleTips(content, self.movecity_btn.transform.position, 25, -25, 0)
  end)
  self.btnRank = self:AddComponent(UIButton, btnRank_path)
  self.btnRank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonHunterRank, {anim = true})
  end)
end

local function ComponentDestroy(self)
  self.serverList:RemoveComponents(SeasonHunterServerItem)
  self.serverObj:GameObjectRecycleAll()
  self.btnBack = nil
  self.btnClose = nil
  self.myInfo = nil
  self.emptyText = nil
  self.killText = nil
  self.rankText = nil
  self.durationTime = nil
  self.leftText = nil
  self.deadText = nil
  self.leftTime = nil
  self.serverList = nil
  self.hunterServerItem = nil
  self.movecity = nil
  self.movecity_btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonHunterGetActivityInfo, self.RefreshView)
  self:AddUIListener(EventId.SeasonHunterBattleStatus, self.RefreshView)
end

function SeasonHunterBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonHunterGetActivityInfo, self.RefreshView)
  self:RemoveUIListener(EventId.SeasonHunterBattleStatus, self.RefreshView)
  base.OnRemoveListener(self)
end

function SeasonHunterBattle:RefreshView()
  local isBegin = DataCenter.SeasonHunterManager:IsBattleBegin()
  local isInBattle = DataCenter.SeasonHunterManager:IsInBattle()
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  if isInBattle then
    local value = string.GetFormattedSeperatorNum(math.floor(tonumber(battleInfo.score or 0)))
    self.killText:SetText(Localization:GetString("season_s4_activity_1200011_desc18", value))
    self.rankText:SetText(Localization:GetString("season_s4_activity_1200011_desc19", battleInfo.matchRank))
    self.durationTime:SetText("")
    self.myInfo:SetActive(true)
    self.emptyText:SetActive(false)
  else
    self.myInfo:SetActive(false)
    self.emptyText:SetActive(true)
  end
  self.leftText:SetText(battleInfo.wolfNum)
  self.deadText:SetText(battleInfo.wolfNumOut)
  self.leftTime:SetText("")
  self.endTime = isBegin and battleInfo.endTime
  self.joinTime = isInBattle and battleInfo.joinTime
  self.serverInfoList = battleInfo.serverInfoList
  self:Update1000MS()
  self:RefreshServerList()
end

function SeasonHunterBattle:Update1000MS()
  if not self.endTime then
    return
  end
  if UIUtil.SetLeftTimeText(self.leftTime, nil, self.endTime, "season_s4_activity_1200011_desc22") then
    self.endTime = nil
    return
  end
  if self.joinTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(curTime - self.joinTime)
    self.durationTime:SetText(Localization:GetString("season_s4_activity_1200011_desc23", showTime))
  end
  self:RefreshMoveCityText()
end

function SeasonHunterBattle:RefreshMoveCityText()
  self.movecity:SetActive(false)
  if DataCenter.SeasonHunterManager:IsInBattle() then
    local skillTemp = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.WerewolfMoveCity)
    if skillTemp then
      local cur, max, ts = DataCenter.MasteryManager:GetStorageSkillCount(skillTemp.id)
      local now = UITimeManager:GetInstance():GetServerTime()
      local countdown = 0
      if ts then
        countdown = math.max(0, math.ceil((ts - now) / 1000))
      end
      self.movecity:SetActive(true)
      self.movecity:SetLocalText("season_mastery_s4_tips_15", cur, max, countdown)
    end
  end
end

function SeasonHunterBattle:RefreshServerList()
  self.serverList:RemoveComponents(SeasonHunterServerItem)
  self.serverObj:GameObjectRecycleAll()
  if not self.serverInfoList then
    return
  end
  local parent = self.serverList.transform
  for i, v in ipairs(self.serverInfoList) do
    local goItem = self.serverObj:GameObjectSpawn(parent)
    goItem.name = string.format("SeasonHunterServerItem_%d", i)
    local theItem = self.serverList:AddComponent(SeasonHunterServerItem, goItem.name)
    theItem:ReInit(i, v)
  end
end

SeasonHunterBattle.OnCreate = OnCreate
SeasonHunterBattle.OnDestroy = OnDestroy
SeasonHunterBattle.OnEnable = OnEnable
SeasonHunterBattle.OnDisable = OnDisable
SeasonHunterBattle.ComponentDefine = ComponentDefine
SeasonHunterBattle.ComponentDestroy = ComponentDestroy
SeasonHunterBattle.DataDefine = DataDefine
SeasonHunterBattle.DataDestroy = DataDestroy
return SeasonHunterBattle
