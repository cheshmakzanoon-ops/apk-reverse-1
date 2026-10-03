local UIBFDsbDuelActScheduleSign = BaseClass("UIBFDsbDuelActScheduleSign", UIBaseContainer)
local base = UIBaseContainer
local UIBFDsbDuelActScheduleInfoItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Schedule.UIBFDsbDuelActScheduleInfoItem")
local UIBFDsbDuelActScheduleTimeItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Schedule.UIBFDsbDuelActScheduleTimeItem")
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActScheduleSign:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActScheduleSign:DataDefine()
  self.sTime = 0
  self.eTime = 0
end

function UIBFDsbDuelActScheduleSign:OnDestroy()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActScheduleSign:DataDestroy()
  self.sTime = nil
  self.eTime = nil
end

function UIBFDsbDuelActScheduleSign:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActInfoUpdate, self.OnActInfoUpdate)
  self:AddUIListener(EventId.DsbDuelActSignUpSuccess, self.OnDsbDuelActSignUpSuccess)
  self:AddUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
end

function UIBFDsbDuelActScheduleSign:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActInfoUpdate, self.OnActInfoUpdate)
  self:RemoveUIListener(EventId.DsbDuelActSignUpSuccess, self.OnDsbDuelActSignUpSuccess)
  self:RemoveUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActScheduleSign:OnActInfoUpdate()
  self:ReInit()
end

function UIBFDsbDuelActScheduleSign:OnDsbDuelActSignUpSuccess()
  self:ReInit()
end

function UIBFDsbDuelActScheduleSign:OnDsbDuelActTimePhaseChange(timePhaseIndex)
  self:ReInit()
end

function UIBFDsbDuelActScheduleSign:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnSign = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnSign:SetOnClick(function()
    self:OnBtnSignClick()
  end)
  self.textBtnSign = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compUIBFDsbDuelLimitDi1 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleInfoItem, 3)
  self.compUIBFDsbDuelLimitDi2 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleInfoItem, 4)
  self.compUIBFDsbDuelLimitDi3 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleInfoItem, 5)
  self.compUIBFDsbDuelLimitDi4 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleInfoItem, 6)
  self.textTimeTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTimeDay = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compTimeGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textDay = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textHour = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textMin = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textSec = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compStateDi1 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleTimeItem, 14)
  self.compStateDi2 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleTimeItem, 15)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compUnSignContent = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.textUnSignTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compSignedContent = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.imgAllianceFlag = self.viewSkin:AddComponent(self, UIImage, 20)
  self.textAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textSignTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.compStateDi3 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleTimeItem, 23)
  self.compStateDi4 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleTimeItem, 24)
  self.compStateDi5 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleTimeItem, 25)
  self.compStateDi6 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleTimeItem, 26)
  self.compStateDi8 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleTimeItem, 27)
  self.compStateDi7 = self.viewSkin:AddComponent(self, UIBFDsbDuelActScheduleTimeItem, 28)
  self.btnEditPlayer = self.viewSkin:AddComponent(self, UIButton, 29)
  self.btnEditPlayer:SetOnClick(function()
    self:OnBtnEditPlayerClick()
  end)
  self.textBtnEditPlayer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 30)
  self.compInBattle = self.viewSkin:AddComponent(self, UIBaseContainer, 31)
  self.textRankTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 32)
  self.imgUpIcon = self.viewSkin:AddComponent(self, UIImage, 33)
  self.textText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 34)
  self.textText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 35)
  self.textText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 37)
  self.compCalendarAddBtnContent = self.viewSkin:AddComponent(self, CalendarAddBtnContent, 38)
  self.textUnSignTips:SetLocalText("dsb_duel_interface_1004")
  self.textSignTips:SetLocalText("dsb_duel_interface_1005")
  self.textBtnSign:SetLocalText("dsb_duel_interface_1007")
  self.textBtnEditPlayer:SetLocalText("dsb_duel_interface_1006")
  self.compUIBFDsbDuelLimitDi1:SetData(1)
  self.compUIBFDsbDuelLimitDi2:SetData(2)
  self.compUIBFDsbDuelLimitDi3:SetData(3)
  self.compUIBFDsbDuelLimitDi4:SetData(4)
  self.timeItems = {
    self.compStateDi1,
    self.compStateDi2,
    self.compStateDi3,
    self.compStateDi4,
    self.compStateDi5,
    self.compStateDi6,
    self.compStateDi7,
    self.compStateDi8
  }
end

function UIBFDsbDuelActScheduleSign:ComponentDestroy()
  self.viewSkin = nil
  self.btnSign = nil
  self.textBtnSign = nil
  self.compUIBFDsbDuelLimitDi1 = nil
  self.compUIBFDsbDuelLimitDi2 = nil
  self.compUIBFDsbDuelLimitDi3 = nil
  self.compUIBFDsbDuelLimitDi4 = nil
  self.textTimeTip = nil
  self.textTimeDay = nil
  self.compTimeGroup = nil
  self.textDay = nil
  self.textHour = nil
  self.textMin = nil
  self.textSec = nil
  self.compStateDi1 = nil
  self.compStateDi2 = nil
  self.btnInfo = nil
  self.compUnSignContent = nil
  self.textUnSignTips = nil
  self.compSignedContent = nil
  self.imgAllianceFlag = nil
  self.textAllianceName = nil
  self.textSignTips = nil
  self.compStateDi3 = nil
  self.compStateDi4 = nil
  self.compStateDi5 = nil
  self.compStateDi6 = nil
  self.compStateDi8 = nil
  self.compStateDi7 = nil
  self.btnEditPlayer = nil
  self.textBtnEditPlayer = nil
  self.compInBattle = nil
  self.textRankTxt = nil
  self.imgUpIcon = nil
  self.textText1 = nil
  self.textText2 = nil
  self.textText3 = nil
  self.rawImgBg = nil
  self.compCalendarAddBtnContent = nil
  self.timeItems = nil
end

function UIBFDsbDuelActScheduleSign:OnBtnSignClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  local sign = actInfo ~= nil and actInfo:IsRegistered() or false
  if not DataCenter.AllianceBaseDataManager:IsR5() then
    UIUtil.ShowTipsId("dsb_duel_tips_1001")
    return
  elseif string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    UIUtil.ShowTipsId("dsb_duel_tips_1003")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActSignUpSuccess, {anim = true})
end

function UIBFDsbDuelActScheduleSign:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRules, {anim = true})
end

function UIBFDsbDuelActScheduleSign:OnBtnEditPlayerClick()
  EventManager:GetInstance():Broadcast(EventId.DsbDuelActBattleMainToggleChange, BattlefieldDsbConst.BF_DSB_MAIN_VIEW_TOGGLE_INDEX.EditBattle)
end

function UIBFDsbDuelActScheduleSign:SetCountDownTime()
  local day, hour, min, sec = 0, 0, 0, 0
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if serverTime < self.eTime and serverTime > self.sTime then
    local remainTime = self.eTime - serverTime
    day, hour, min, sec = UITimeManager:GetInstance():MilliSecondToFmtFormat(remainTime)
  end
  self.textDay:SetText(string.format("%02dd", day))
  self.textHour:SetText(string.format("%02d", hour))
  self.textMin:SetText(string.format("%02d", min))
  self.textSec:SetText(string.format("%02d", sec))
end

function UIBFDsbDuelActScheduleSign:Update1000MS()
  self:SetCountDownTime()
end

function UIBFDsbDuelActScheduleSign:RefreshBattleStatistic()
  local teamA = BattlefieldDsbDuelUtils.ActInfo:GetTeamInfo(BattlefieldDsbConst.TeamType.A)
  self.compInBattle:SetActive(BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase() and teamA)
  if BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase() and teamA then
    self.imgUpIcon:SetActive(teamA.lastRank ~= 0 and teamA.lastRank ~= teamA.rank2)
    self.imgUpIcon:LoadSpriteAuto(teamA.lastRank > teamA.rank2 and string.format(LoadPath.LWBattleFieldDsbDuelPath, "FX_xiangqing_common_jiantou1_icon.png") or string.format(LoadPath.LWBattleFieldDsbDuelPath, "FX_xiangqing_common_jiantou2_icon.png"))
    self.textRankTxt:SetText(Localization:GetString("city_war_main_UI_09") .. string.GetFormattedStr(teamA.rank2 == 0 and teamA.lastRank or teamA.rank2))
    self.textText1:SetText(string.GetFormattedStr(teamA.score == 0 and teamA.lastScore or teamA.score))
    self.textText2:SetText(string.GetFormattedStr(teamA.smallScore == 0 and teamA.lastSmallScore or teamA.smallScore))
    self.textText3:SetText(string.GetFormattedStr(teamA.power == 0 and teamA.lastPower or teamA.power))
  end
end

function UIBFDsbDuelActScheduleSign:ReInit()
  self.sTime, self.eTime = BattlefieldDsbDuelUtils.ActInfo:GetCurrentBigPhaseStartEndTime()
  self:SetCountDownTime()
  self.textTimeDay:SetText(self:GetTimeToMD(self.sTime / 1000) .. "~" .. self:GetTimeToMD(self.eTime / 1000))
  self:InitTimeItems()
  self.rawImgBg:LoadSpriteAuto(BattlefieldDsbDuelUtils.ActInfo:IsRegistered() and "Assets/Main/TextureEx/BF_Dsb_Duel/lrb_daluandou_02_banner.png" or "Assets/Main/TextureEx/BF_Dsb_Duel/lrb_daluandou_01_banner.png")
  self.compUnSignContent:SetActive(not BattlefieldDsbDuelUtils.ActInfo:IsRegistered())
  self.compSignedContent:SetActive(BattlefieldDsbDuelUtils.ActInfo:IsRegistered())
  self.textSignTips:SetActive(not BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase())
  self:RefreshBattleStatistic()
  if BattlefieldDsbDuelUtils.ActInfo:IsRegistered() then
    self:RefreshSignedContent()
  else
    DataCenter.RankDataManager:GetAllianceRankListByType(0, RankingTypeServer.POWER_ALLIANCE, LuaEntry.Player:GetCurServerId())
  end
  local bigPhaseIndex = BattlefieldDsbDuelUtils.ActInfo:GetCurrentBigPhaseIndex()
  local curDayIndex, totalDayIndex
  if bigPhaseIndex >= BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMin and bigPhaseIndex <= BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMax then
    curDayIndex = BattlefieldDsbDuelUtils.ActInfo:GetBattleWeek()
    totalDayIndex = BattlefieldDsbDuelUtils.ActInfo:GetTotalBattleWeekNum()
  else
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    curDayIndex = (serverTime - self.sTime) // (OneDayTime * 1000) + 1
    totalDayIndex = math.max((self.eTime - self.sTime) // (OneDayTime * 1000), 1)
  end
  local key
  if bigPhaseIndex >= BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMin and bigPhaseIndex <= BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMax then
    key = "dsb_duel_phase_name_1003"
  elseif bigPhaseIndex == BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.SignUp then
    key = "dsb_duel_phase_name_1001"
  elseif bigPhaseIndex == BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.Group then
    key = "dsb_duel_phase_name_1002"
  elseif bigPhaseIndex == BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.Result then
    key = "dsb_duel_phase_name_1004"
  end
  self.textTimeTip:SetLocalText(key, curDayIndex, totalDayIndex)
  self.btnSign:SetActive(not BattlefieldDsbDuelUtils.ActInfo:IsRegistered() and BattlefieldDsbDuelUtils.ActInfo:IsInSignUpPhase())
  self:ShowCalendatBtnContent()
end

function UIBFDsbDuelActScheduleSign:ShowCalendatBtnContent()
  if BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase() then
    self.compCalendarAddBtnContent:SetActive(true)
    local startTime = toInt(self.eTime / 1000)
    local endTime = toInt(self.eTime / 1000)
    self.compCalendarAddBtnContent:SetDataWithDefautValue(14, startTime, endTime, CalendarSourcePath.Activity)
  else
    self.compCalendarAddBtnContent:SetActive(false)
  end
end

function UIBFDsbDuelActScheduleSign:RefreshSignedContent()
  local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local flagIcon = allianceBaseData.icon
  self.imgAllianceFlag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, flagIcon))
  self.textAllianceName:SetText(LuaEntry.Player:GetFullAllianceName())
end

function UIBFDsbDuelActScheduleSign:InitTimeItems()
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  if not actInfo then
    return
  end
  local totalCount = #self.timeItems
  local curIndex = self:GetCurrentPhaseIndex()
  for i = 1, totalCount do
    if self.timeItems[i] then
      self.timeItems[i]:ReInit(i, curIndex, totalCount)
    end
  end
end

function UIBFDsbDuelActScheduleSign:GetCurrentPhaseIndex()
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  if not actInfo then
    return 0
  end
  if actInfo:IsInSignUpPhase() then
    return 1
  elseif actInfo:IsInGroupPhase() then
    return 2
  elseif actInfo:IsInBattlePhase() then
    return 2 + actInfo:GetBattleWeek()
  elseif actInfo:IsInResultShowPhase() then
    return 2 + BattlefieldDsbDuelUtils.ActInfo:GetTotalBattleWeekNum() + 1
  end
  return 0
end

function UIBFDsbDuelActScheduleSign:GetTimeToMD(second)
  local format = UITimeManager:GetInstance():TimeSecToServerDate(second)
  local format_time = string.format("%0d/%0d", format.month, format.day)
  return format_time
end

return UIBFDsbDuelActScheduleSign
