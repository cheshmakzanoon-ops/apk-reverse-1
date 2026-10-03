local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonHunterMain = BaseClass("SeasonHunterMain", base)
local Localization = CS.GameEntry.Localization
local SeasonHunterSkillItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterSkillItem")
local infoBtn_path = "Root/top/right/IntroBtn"
local rankBtn_path = "Root/top/right/rankBtn"
local honorBtn_path = "Root/top/right/honorBtn"
local rewardBtn_path = "Root/top/right/rewardBtn"
local recordBtn_path = "Root/top/right/recordBtn"
local rewardRed_path = "Root/top/right/rewardBtn/Red"
local name_path = "Root/top/left/Txt_ActName"
local desc_path = "Root/top/left/Txt_ActDesc"
local endTime_path = "Root/top/left/TimeInfoItem/timeBg2/TimeText"
local battleEndTime_path = "Root/bot/battleGroup/TxtTimeEnd"
local txtTips_path = "Root/bot/Btns/TxtTips"
local btnConvert_path = "Root/bot/Btns/BtnConvert"
local btnQuit_path = "Root/bot/Btns/BtnQuit"
local battleGroup_path = "Root/bot/battleGroup"
local btnKill_path = "Root/bot/battleGroup/Btns/Kill"
local textKill_path = "Root/bot/battleGroup/Btns/Kill/TxtKill"
local btnMember_path = "Root/bot/battleGroup/Btns/Member"
local txtMember_path = "Root/bot/battleGroup/Btns/Member/TxtMember"
local btnInfo_path = "Root/bot/battleGroup/Btns/Info"
local normalGroup_path = "Root/bot/normalGroup"
local skillItem1_path = "Root/bot/normalGroup/SeasonHunterSkillItem1"
local skillItem2_path = "Root/bot/normalGroup/SeasonHunterSkillItem2"
local skillItem3_path = "Root/bot/normalGroup/SeasonHunterSkillItem3"

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
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.honorBtn = self:AddComponent(UIButton, honorBtn_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.recordBtn = self:AddComponent(UIButton, recordBtn_path)
  self.rewardRed = self:AddComponent(UIButton, rewardRed_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.endTime = self:AddComponent(UIText, endTime_path)
  self.battleEndTime = self:AddComponent(UIText, battleEndTime_path)
  self.txtTips = self:AddComponent(UIText, txtTips_path)
  self.btnConvert = self:AddComponent(UIButton, btnConvert_path)
  self.btnQuit = self:AddComponent(UIButton, btnQuit_path)
  self.battleGroup = self:AddComponent(UIBaseContainer, battleGroup_path)
  self.btnKill = self:AddComponent(UIButton, btnKill_path)
  self.textKill = self:AddComponent(UIText, textKill_path)
  self.btnMember = self:AddComponent(UIButton, btnMember_path)
  self.txtMember = self:AddComponent(UIText, txtMember_path)
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.normalGroup = self:AddComponent(UIBaseContainer, normalGroup_path)
  self.skillItem1 = self:AddComponent(UIBaseContainer, skillItem1_path)
  self.skillItem2 = self:AddComponent(UIBaseContainer, skillItem2_path)
  self.skillItem3 = self:AddComponent(UIBaseContainer, skillItem3_path)
  self.skillItem1 = self:AddComponent(SeasonHunterSkillItem, skillItem1_path)
  self.skillItem2 = self:AddComponent(SeasonHunterSkillItem, skillItem2_path)
  self.skillItem3 = self:AddComponent(SeasonHunterSkillItem, skillItem3_path)
  self.infoBtn:SetOnClick(function()
    if self.activityData and not table.IsNullOrEmpty(self.activityData.howtoplay) then
      local param = {}
      param.howToPlayList = self.activityData.howtoplay
      param.story = self.activityData.story
      param.defaultTitle = self.activityData.name
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
    end
  end)
  self.rankBtn:SetOnClick(function()
    self:OpenWindow(UIWindowNames.SeasonHunterRank)
  end)
  self.honorBtn:SetOnClick(function()
    self:OpenWindow(UIWindowNames.SeasonHunterHoner)
  end)
  self.rewardBtn:SetOnClick(function()
    self:OpenWindow(UIWindowNames.SeasonHunterReward)
    self.rewardRed:SetActive(false)
  end)
  self.rewardRed:SetOnClick(function()
    self:OpenWindow(UIWindowNames.SeasonHunterReward)
    self.rewardRed:SetActive(false)
  end)
  self.recordBtn:SetOnClick(function()
    self:OpenWindow(UIWindowNames.SeasonHunterHistory)
  end)
  self.btnConvert:SetOnClick(function()
    DataCenter.SeasonHunterManager:JoinBattle()
  end)
  self.btnQuit:SetOnClick(function()
    self:QuitBattle()
  end)
  self.btnKill:SetOnClick(function()
    if self.activityData and not string.IsNullOrEmpty(self.activityData.para_1) then
      local data = DataCenter.LWWorldTipManager:GetDataBySeason(self.activityData.para_1)
      if data ~= nil and table.count(data) > 0 then
        local param = {}
        param.dataWeek = data
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonIntroduction, {anim = false}, param)
      end
    end
  end)
  self.btnMember:SetOnClick(function()
    if self.activityData and not string.IsNullOrEmpty(self.activityData.para_2) then
      local data = DataCenter.LWWorldTipManager:GetDataBySeason(self.activityData.para_2)
      if data ~= nil and table.count(data) > 0 then
        local param = {}
        param.dataWeek = data
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonIntroduction, {anim = false}, param)
      end
    end
  end)
  self.btnInfo:SetOnClick(function()
    self:OpenWindow(UIWindowNames.SeasonHunterBattle)
  end)
  self:CheckRed()
end

local function ComponentDestroy(self)
  self.infoBtn = nil
  self.rankBtn = nil
  self.honorBtn = nil
  self.rewardBtn = nil
  self.recordBtn = nil
  self.rewardRed = nil
  self.name = nil
  self.desc = nil
  self.endTime = nil
  self.battleEndTime = nil
  self.txtTips = nil
  self.btnConvert = nil
  self.btnQuit = nil
  self.battleGroup = nil
  self.btnKill = nil
  self.textKill = nil
  self.btnMember = nil
  self.txtMember = nil
  self.btnInfo = nil
  self.normalGroup = nil
  self.skillItem1 = nil
  self.skillItem2 = nil
  self.skillItem3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonHunterGetActivityInfo, self.RefreshView)
  self:AddUIListener(EventId.SeasonHunterBattleStatus, self.RefreshView)
  self:AddUIListener(EventId.LWMasterySkillUp, self.RefreshView)
end

function SeasonHunterMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonHunterGetActivityInfo, self.RefreshView)
  self:RemoveUIListener(EventId.SeasonHunterBattleStatus, self.RefreshView)
  self:RemoveUIListener(EventId.LWMasterySkillUp, self.RefreshView)
  base.OnRemoveListener(self)
end

function SeasonHunterMain:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.name:SetLocalText(data.name)
  self.desc:SetLocalText(data.desc)
  self.StartTime = data.startTime
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.EndTime = DataCenter.SeasonDataManager.nextSeasonStartTime
  else
    self.EndTime = data.endTime
  end
  self:RefreshView()
  self:Update1000MS()
end

function SeasonHunterMain:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.endTime, self.StartTime, self.EndTime)
  end
  if self.BattleEndTime and UIUtil.SetLeftTimeText(self.battleEndTime, nil, self.BattleEndTime) then
    self.BattleEndTime = nil
    self:RefreshView()
  end
  if self.feverTime and UIUtil.SetLeftTimeText(self.txtTips, nil, self.feverTime, "season_s4_activity_1200011_desc16") then
    self.feverTime = nil
    CS.UIGray.SetGray(self.btnQuit.transform, false, true)
  end
end

function SeasonHunterMain:RefreshView()
  if not self.activityData then
    return
  end
  local isBegin = DataCenter.SeasonHunterManager:IsBattleBegin()
  local isInBattle = DataCenter.SeasonHunterManager:IsInBattle()
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  self.battleGroup:SetActive(isBegin)
  self.normalGroup:SetActive(not isBegin)
  self.feverTime = nil
  self.banTime = nil
  if isBegin then
    self.BattleEndTime = battleInfo.endTime
    self.btnConvert:SetActive(not isInBattle)
    self.btnQuit:SetActive(isInBattle)
    self.textKill:SetText(battleInfo.score or 0)
    self.txtMember:SetText(battleInfo.wolfNum)
    if isInBattle then
      local feverParam, leftTime = DataCenter.StatusManager:WarFeverStatu()
      self.feverTime = feverParam and leftTime or nil
      local isFever = self.feverTime and self.feverTime > 0 and true or false
      if isFever then
        self.feverTime = self.feverTime + UITimeManager:GetInstance():GetServerTime()
      end
      CS.UIGray.SetGray(self.btnQuit.transform, isFever, not isFever)
      self.txtTips:SetLocalText("season_s4_activity_1200011_desc14")
    else
      self.banTime = DataCenter.SeasonHunterManager:GetBanTimeStamp()
      self:RefreshBanTime()
    end
    return
  end
  self.skillItem1:ReInit(1, "season_s4_activity_1200011_desc73", "season_s4_activity_1200011_desc70")
  self.skillItem2:ReInit(2, "season_s4_activity_1200011_desc74", "season_s4_activity_1200011_desc71")
  self.skillItem3:ReInit(3, "season_s4_activity_1200011_desc75", "season_s4_activity_1200011_desc72")
  if UITimeManager:GetInstance():GetNowWeekdayIndex() == 6 then
    self.btnConvert:SetActive(false)
    self.btnQuit:SetActive(false)
    self.txtTips:SetLocalText("season_s4_activity_1200011_tips13")
    return
  end
  self.btnConvert:SetActive(true)
  self.btnQuit:SetActive(false)
  self.txtTips:SetLocalText("season_s4_activity_1200011_tips01")
end

function SeasonHunterMain:OpenWindow(name, ...)
  UIManager:GetInstance():OpenWindow(name, {anim = true}, ...)
end

function SeasonHunterMain:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.endTime, self.StartTime, self.EndTime)
  end
  if self.BattleEndTime and UIUtil.SetLeftTimeText(self.battleEndTime, nil, self.BattleEndTime) then
    self.BattleEndTime = nil
    self:RefreshView()
  end
  if self.feverTime then
    if UIUtil.SetLeftTimeText(self.txtTips, nil, self.feverTime, "season_s4_activity_1200011_desc16") then
      self.feverTime = nil
      CS.UIGray.SetGray(self.btnQuit.transform, false, true)
    end
  elseif self.banTime then
    self:RefreshBanTime()
  end
end

function SeasonHunterMain:RefreshBanTime()
  if UIUtil.SetLeftTimeText(self.txtTips, nil, self.banTime, "season_s4_activity_1200011_desc15") then
    self.banTime = nil
    self.txtTips:SetLocalText("season_s4_activity_1200011_desc67")
  end
end

function SeasonHunterMain:QuitBattle()
  local feverParam = DataCenter.StatusManager:WarFeverStatu()
  self.feverTime = feverParam and feverParam.feverTime
  if self.feverTime and self.feverTime > 0 then
    return
  end
  UIUtil.ShowConfirmNew({
    contentText = Localization:GetString("season_s4_activity_1200011_desc17"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        SFSNetwork.SendMessage(MsgDefines.QuitWolf)
      end
    }
  })
end

function SeasonHunterMain:SeasonHunterGetActivityInfo()
  self:RefreshView()
end

function SeasonHunterMain:CheckRed()
  local clickTime = UIUtil.GetActiveCount(DataCenter.SeasonDataManager:GetSeasonStartTime(), "HunterRewardView", false)
  self.rewardRed:SetActive(clickTime <= 0)
end

SeasonHunterMain.OnCreate = OnCreate
SeasonHunterMain.OnDestroy = OnDestroy
SeasonHunterMain.OnEnable = OnEnable
SeasonHunterMain.OnDisable = OnDisable
SeasonHunterMain.ComponentDefine = ComponentDefine
SeasonHunterMain.ComponentDestroy = ComponentDestroy
SeasonHunterMain.DataDefine = DataDefine
SeasonHunterMain.DataDestroy = DataDestroy
return SeasonHunterMain
