local base = require("UI.UIRaceEntrance.Component.ActDownloadNodeBase")
local WinterStormActivityMainRoot = BaseClass("WinterStormActivityMainRoot", base)
local WinterStormMainMatchTimeItem = require("UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormMainMatchTimeItem")
local WinterStormMainTimeSignItem = require("UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormMainTimeSignItem")
local WinterStormMainResultItem = require("UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormMainResultItem")
local WinterStormPlayerItem = require("UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormPlayerItem")
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local MyCeil = math.ceil
local MyFloor = math.floor
local title_path = "RightView/Top/title"
local sub_title_path = "RightView/Top/subTitle"
local btn_reward_path = "RightView/Top/BtnListL/BtnReward"
local red_point_btn_reward_path = "RightView/Top/BtnListL/BtnReward/RedPointBtnReward"
local text_btn_reward_path = "RightView/Top/BtnListL/BtnReward/BtnRewardIcon/BtnRewardText"
local btn_info_path = "RightView/Top/BtnListR/BtnInfo"
local btn_rule_path = "RightView/Top/BtnListR/BtnRule"
local text_btn_rule_path = "RightView/Top/BtnListR/BtnRule/BtnRuleIcon/BtnRuleText"
local btn_shop_path = "RightView/Top/BtnListR/BtnShop"
local text_btn_shop_path = "RightView/Top/BtnListR/BtnShop/BtnShopIcon/BtnShopText"
local btn_history_path = "RightView/Top/BtnListR/BtnHistory"
local text_btn_history_path = "RightView/Top/BtnListR/BtnHistory/BtnBtnHistoryIcon/BtnHistoryText"
local btn_achievement_path = "RightView/Top/BtnListR/BtnAchievement"
local bottom_path = "RightView/Bottom"
local text_remain_time_path = "RightView/Bottom/TimeBg/remainTime"
local text_time_title_path = "RightView/Bottom/TimeBg/TimeTitle"
local time_tip_path = "RightView/Bottom/TimeTip"
local text_battle_time_tips_path = "RightView/Bottom/TimeTip/BattleTimeTipsText"
local btn_change_show_time_path = "RightView/Bottom/TimeTip/ChangeShowTimeBtn"
local result_tip_path = "RightView/Bottom/ResultTip"
local text_result_tips_path = "RightView/Bottom/ResultTip/ResultTipsText"
local time_show_path = "RightView/Bottom/TimeShow"
local time_group_path = "RightView/Bottom/TimeShow/TimeGroup"
local cur_sign_path = "RightView/Bottom/TimeShow/CurSign"
local text_time_tip_path = "RightView/Bottom/TimeShow/TimeTipText"
local result_show_path = "RightView/Bottom/ResultShow"
local result_group_path = "RightView/Bottom/ResultShow/ResultGroup"
local fighting_show_path = "RightView/Bottom/FightingShow"
local player_group_path = "RightView/Bottom/FightingShow/PlayerGroup"
local text_fighting_tip_path = "RightView/Bottom/FightingShow/FightingTipText"
local text_empty_tip_path = "RightView/Bottom/EmptyTipText"
local btn_matching_path = "RightView/BottomAttack/BtnMatching"
local text_btn_match_path = "RightView/BottomAttack/BtnMatching/BtnMatchText"
local text_match_tips_path = "RightView/BottomAttack/MathchTipsText"
local btn_start_path = "RightView/BottomAttack/BtnStart"
local text_btn_start_path = "RightView/BottomAttack/BtnStart/StartText"
local start_tips_path = "RightView/BottomAttack/StartTips"
local text_start_tips_path = "RightView/BottomAttack/StartTips/StartTipsText"
local img_sign_sleep_path = "lrb_dongjifengbao_xiaobingzhuangtai01"
local img_sign_nor_path = "lrb_dongjifengbao_xiaobingzhuangtai02"
local img_sign_cur_path = "lrb_dongjifengbao_xiaobingzhuangtai03"
local calendar_add_btn_content_path = "RightView/Bottom/TimeBg/remainTime/CalendarAddBtnContent"

function WinterStormActivityMainRoot:OnCreate()
  base.OnCreate(self)
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  self.hasResult = false
  self.matchWaitTime = LuaEntry.DataConfig:TryGetNum("winter_battle_match", "k1", 60)
  self.sign_eff_obj = nil
  self.req = nil
  self.lastHour = -1
  self.showMatchCD = false
  self.wsInfo = DataCenter.ActWinterStormManager:GetActInfo()
  self:ComponentDefine()
end

function WinterStormActivityMainRoot:OnDestroy()
  if not IsNull(self.sign_eff_obj) then
    self.sign_eff_obj:Destroy()
    self.sign_eff_obj = nil
  end
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.lastHour = -1
  self.showMatchCD = false
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WinterStormActivityMainRoot:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.sub_title = self:AddComponent(UIText, sub_title_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.red_point_btn_reward = self:AddComponent(UIImage, red_point_btn_reward_path)
  self.red_point_btn_reward:SetActive(false)
  self.text_btn_reward = self:AddComponent(UIText, text_btn_reward_path)
  self.text_btn_reward:SetLocalText("winter_battlefield_interface_tips1002")
  self.btn_reward:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.btn_rule = self:AddComponent(UIButton, btn_rule_path)
  self.text_btn_rule = self:AddComponent(UIText, text_btn_rule_path)
  self.text_btn_rule:SetLocalText("winter_battlefield_interface_tips1003")
  self.btn_rule:SetOnClick(function()
    self:RuleBtnClick()
  end)
  self.btn_shop = self:AddComponent(UIButton, btn_shop_path)
  self.text_btn_shop = self:AddComponent(UIText, text_btn_shop_path)
  self.text_btn_shop:SetLocalText("458009")
  self.btn_shop:SetOnClick(function()
    self:ShopBtnClick()
  end)
  self.btn_history = self:AddComponent(UIButton, btn_history_path)
  self.text_btn_history = self:AddComponent(UIText, text_btn_history_path)
  self.text_btn_history:SetLocalText("winter_battlefield_interface_tips1005")
  self.btn_history:SetOnClick(function()
    self:HistoryBtnClick()
  end)
  self.btn_achievement = self:AddComponent(UIButton, btn_achievement_path)
  self.btn_achievement:SetOnClick(function()
    self:AchievementBtnClick()
  end)
  self.bottomRtf = self.transform:Find(bottom_path):GetComponent(typeof(CS.UnityEngine.RectTransform))
  self.text_remain_time = self:AddComponent(UIText, text_remain_time_path)
  self.text_time_title = self:AddComponent(UIText, text_time_title_path)
  self.time_tip = self:AddComponent(UIBaseContainer, time_tip_path)
  self.time_tip:SetActive(false)
  self.text_battle_time_tips = self:AddComponent(UIText, text_battle_time_tips_path)
  self.btn_change_show_time = self:AddComponent(UIButton, btn_change_show_time_path)
  self.btn_change_show_time:SetOnClick(function()
    self:ChangeShowTimeBtnClick()
  end)
  self.result_tip = self:AddComponent(UIBaseContainer, result_tip_path)
  self.result_tip:SetActive(false)
  self.text_result_tips = self:AddComponent(UIText, text_result_tips_path)
  self.text_result_tips:SetLocalText("winter_battlefield_interface_tips1015")
  self.time_show = self:AddComponent(UIBaseContainer, time_show_path)
  self.time_show:SetActive(false)
  local matchTimeItems = {}
  for i = 0, 2 do
    local name = "WinterStormMainMatchTimeItem" .. i
    local item = self.time_show:AddComponent(WinterStormMainMatchTimeItem, name)
    matchTimeItems[i + 1] = item
  end
  self.matchTimeItems = matchTimeItems
  self.time_group = self:AddComponent(UIBaseContainer, time_group_path)
  local timeSignItems = {}
  for i = 0, 23 do
    local name = "WinterStormMainTimeSignItem" .. i
    local item = self.time_group:AddComponent(WinterStormMainTimeSignItem, name)
    item:SetStatus(0)
    timeSignItems[i + 1] = item
  end
  self.timeSignItems = timeSignItems
  self.cur_sign = self:AddComponent(UIImage, cur_sign_path)
  self.text_time_tip = self:AddComponent(UIText, text_time_tip_path)
  self.text_time_tip:SetLocalText("winter_battlefield_interface_tips1014")
  self.result_show = self:AddComponent(UIBaseContainer, result_show_path)
  self.result_show:SetActive(false)
  self.result_group = self:AddComponent(UIBaseContainer, result_group_path)
  local resultItems = {}
  for i = 0, 2 do
    local name = "WinterStormMainResultItem" .. i
    local item = self.result_group:AddComponent(WinterStormMainResultItem, name)
    resultItems[i + 1] = item
  end
  self.resultItems = resultItems
  self.fighting_show = self:AddComponent(UIBaseContainer, fighting_show_path)
  self.fighting_show:SetActive(false)
  self.player_group = self:AddComponent(UIBaseContainer, player_group_path)
  local playerItems = {}
  for i = 0, 3 do
    local name = "WinterStormPlayerItem" .. i
    local item = self.player_group:AddComponent(WinterStormPlayerItem, name)
    playerItems[i + 1] = item
  end
  self.playerItems = playerItems
  self.text_fighting_tip = self:AddComponent(UIText, text_fighting_tip_path)
  self.text_fighting_tip:SetLocalText("winter_battlefield_interface_tips1010")
  self.text_empty_tip = self:AddComponent(UIText, text_empty_tip_path)
  self.text_empty_tip:SetActive(false)
  self.btn_matching = self:AddComponent(UIButton, btn_matching_path)
  self.btn_matching:SetOnClick(function()
    self:MatchingBtnClick()
  end)
  self.text_btn_match = self:AddComponent(UIText, text_btn_match_path)
  self.text_match_tips = self:AddComponent(UIText, text_match_tips_path)
  self.btn_start = self:AddComponent(UIButton, btn_start_path)
  self.btn_start:SetOnClick(function()
    self:StartBtnClick()
  end)
  self.text_btn_start = self:AddComponent(UIText, text_btn_start_path)
  self.start_tips = self:AddComponent(UIBaseContainer, start_tips_path)
  self.text_start_tips = self:AddComponent(UIText, text_start_tips_path)
  self.calendar_add_btn_content = self:AddComponent(CalendarAddBtnContent, calendar_add_btn_content_path)
end

function WinterStormActivityMainRoot:ComponentDestroy()
  self.title = nil
  self.sub_title = nil
  self.btn_info = nil
  self.btn_reward = nil
  self.red_point_btn_reward = nil
  self.text_btn_reward = nil
  self.btn_rule = nil
  self.text_btn_rule = nil
  self.btn_shop = nil
  self.text_btn_shop = nil
  self.btn_history = nil
  self.text_btn_history = nil
  self.text_remain_time = nil
  self.text_time_title = nil
  self.time_tip = nil
  self.text_battle_time_tips = nil
  self.btn_change_show_time = nil
  self.result_tip = nil
  self.text_result_tips = nil
  self.time_show = nil
  self.matchTimeItems = {}
  self.time_group = nil
  self.timeSignItems = {}
  self.cur_sign = nil
  self.text_time_tip = nil
  self.result_show = nil
  self.result_group = nil
  self.resultItems = {}
  self.fighting_show = nil
  self.fighting_top = nil
  self.player_group = nil
  self.playerItems = {}
  self.text_fighting_tip = nil
  self.text_empty_tip = nil
  self.btn_matching = nil
  self.text_btn_match = nil
  self.text_match_tips = nil
  self.btn_start = nil
  self.text_btn_start = nil
  self.calendar_add_btn_content = nil
end

function WinterStormActivityMainRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshView)
  self:AddUIListener(EventId.WinterStormInfoRefresh, self.RefreshView)
  self:AddUIListener(EventId.WinterStormMatchRefresh, self.RefreshView)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.WinterStormChangeShowLocalTime)
end

function WinterStormActivityMainRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshView)
  self:RemoveUIListener(EventId.WinterStormInfoRefresh, self.RefreshView)
  self:RemoveUIListener(EventId.WinterStormMatchRefresh, self.RefreshView)
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.WinterStormChangeShowLocalTime)
  base.OnRemoveListener(self)
end

function WinterStormActivityMainRoot:GetActType()
  return EnumActivity.ActWinterStorm.Type
end

function WinterStormActivityMainRoot:OnEnterNode()
  self:CheckSendGetInfo()
end

function WinterStormActivityMainRoot:WinterStormChangeShowLocalTime()
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  UIUtil.ShowTipsId(self.isShowLocalTime == true and "winter_battlefield_tips1003" or "winter_battlefield_tips1004")
  self:UpdateTimeShow()
end

function WinterStormActivityMainRoot:UpdateData()
  if self.activityId == nil then
    return
  end
  self.title:SetLocalText(self.activityData.bannerTittle or "")
  self.sub_title:SetLocalText(self.activityData.bannerDes or "")
  local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local mgr = DataCenter.ActWinterStormManager
  self.wsInfo = mgr:GetActInfo()
  local status = -1
  self.hasResult = false
  if self.wsInfo ~= nil then
    if self.wsInfo.noticeEndTime ~= nil and curSeconds < self.wsInfo.noticeEndTime then
      self.text_time_title:SetLocalText("winter_battlefield_interface_tips1006")
      status = 0
    elseif self.wsInfo.battleEndTime ~= nil and curSeconds < self.wsInfo.battleEndTime then
      status = 1
      local msTime = mgr:GetMatchStartTime()
      if msTime ~= nil and msTime ~= 0 then
        status = 2
      elseif self.wsInfo.state ~= nil and self.wsInfo.state == 3 then
        status = 3
      end
      local redCnt = mgr:GetTotalRedCount()
      self.red_point_btn_reward:SetActive(0 < redCnt)
    else
      status = 4
      self.text_time_title:SetLocalText("winter_battlefield_interface_tips1009")
      self.hasResult = not table.IsNullOrEmpty(self.wsInfo.mvp)
    end
  end
  self.curStatus = status
  local timeFlag = status == 0 or status == 1 or status == 2
  self.text_time_title:SetActive(timeFlag or status == 3)
  self.time_tip:SetActive(timeFlag)
  self.result_tip:SetActive(status == 4)
  self.time_show:SetActive(timeFlag)
  self.fighting_show:SetActive(status == 3)
  self.result_show:SetActive(status == 4 and self.hasResult)
  self.text_empty_tip:SetActive(status == 4 and not self.hasResult)
  local bCanFlag = self:UpdateTimeShow()
  if status == 1 or status == 2 or status == 3 then
    if self.curFightSTime ~= nil then
      local curSec = UITimeManager:GetInstance():GetServerSeconds()
      if curSec < self.curFightSTime then
        self.text_time_title:SetLocalText("winter_battlefield_interface_tips1071")
      else
        self.text_time_title:SetLocalText("winter_battlefield_interface_tips1072")
      end
    else
      self.text_time_title:SetLocalText("winter_battlefield_interface_tips1007")
    end
  end
  self:UpdateFightingShow()
  self:UpdateResultShow()
  local matchingStatus = DataCenter.ActWinterStormManager:CheckMatchingShow()
  self.btn_start:SetActive(status == 0 or status == 1 or status == 3 or matchingStatus == 2)
  self.btn_matching:SetActive(status == 2 and matchingStatus ~= 2)
  self.text_match_tips:SetActive(status == 2 and matchingStatus ~= 2)
  local btnStartBStr = status == 3 and "winter_battlefield_interface_tips1038" or "winter_battlefield_interface_tips1011"
  if matchingStatus == 2 then
    btnStartBStr = "winter_battlefield_interface_tips1018"
    CS.UIGray.SetGray(self.btn_start.transform, true, false)
    self.showMatchCD = false
    self.start_tips:SetActive(false)
  elseif timeFlag then
    local canFlag = status == 1 and bCanFlag
    if canFlag then
      local cdTime = self.wsInfo ~= nil and self.wsInfo.matchCDTime or 0
      local curSec = UITimeManager:GetInstance():GetServerSeconds()
      canFlag = cdTime <= curSec
      self.showMatchCD = not canFlag
    else
      self.showMatchCD = false
    end
    CS.UIGray.SetGray(self.btn_start.transform, not canFlag, canFlag)
    self.start_tips:SetActive(canFlag or self.showMatchCD)
    if canFlag then
      self.text_start_tips:SetLocalText("winter_battlefield_tips1005")
    elseif self.showMatchCD then
      btnStartBStr = nil
      self.text_start_tips:SetLocalText("winter_battlefield_tips1064")
    end
  else
    CS.UIGray.SetGray(self.btn_start.transform, false, true)
    self.showMatchCD = false
    self.start_tips:SetActive(false)
  end
  if btnStartBStr then
    self.text_btn_start:SetLocalText(btnStartBStr)
  end
  self:Update1000MS()
  self:ShowCalendatBtnContent()
end

function WinterStormActivityMainRoot:ShowCalendatBtnContent()
  local tMgr = UITimeManager:GetInstance()
  local curSec = tMgr:GetServerSeconds()
  if self.calendarBtnNextRefreshTime ~= nil and not (curSec >= self.calendarBtnNextRefreshTime) then
    return
  end
  self.calendar_add_btn_content:SetActive(false)
  if self.wsInfo == nil then
    return
  end
  local startTime = 0
  local endTime = 0
  local nextBattleTime = DataCenter.ActWinterStormManager:GetNextBattleTime()
  if 0 < nextBattleTime and curSec <= nextBattleTime then
    startTime = nextBattleTime
    endTime = nextBattleTime
  else
    self.calendarBtnNextRefreshTime = curSec + 3600
  end
  if 0 < startTime and 0 < endTime then
    self.calendarBtnNextRefreshTime = startTime
    self.calendar_add_btn_content:SetActive(true)
    self.calendar_add_btn_content:SetDataWithDefautValue(8, startTime, endTime, CalendarSourcePath.Activity)
  end
end

function WinterStormActivityMainRoot:Update1000MS()
  local tMgr = UITimeManager:GetInstance()
  local curSec = tMgr:GetServerSeconds()
  self.wsInfo = DataCenter.ActWinterStormManager:GetActInfo()
  if self.wsInfo == nil then
    return
  end
  local endTime = 0
  local stopSend = false
  local trySendData = false
  if self.wsInfo.noticeEndTime ~= nil and curSec <= self.wsInfo.noticeEndTime then
    endTime = self.wsInfo.noticeEndTime
  elseif self.wsInfo.battleEndTime ~= nil and curSec < self.wsInfo.battleEndTime then
    if self.curFightSTime ~= nil then
      if curSec < self.curFightSTime then
        endTime = self.curFightSTime
      else
        endTime = self.curFightETime
      end
    else
      endTime = self.wsInfo.battleEndTime
    end
    local tmpDate = tMgr:TimeSecToServerDate(curSec)
    if 0 > self.lastHour then
      self.lastHour = tmpDate.hour
    end
    if self.lastHour ~= tmpDate.hour then
      self.lastHour = tmpDate.hour
      trySendData = true
    end
    if self.curStatus == 2 then
      local msTime = DataCenter.ActWinterStormManager:GetMatchStartTime()
      if msTime ~= nil and msTime ~= 0 then
        local remainTime = curSec - msTime
        local txt = tMgr:SecondToFmtStringWithoutDay(remainTime)
        self.text_btn_match:SetText(Localization:GetString("winter_battlefield_tips1002") .. "\n" .. txt)
        local bNum = MyCeil(remainTime / self.matchWaitTime)
        if bNum <= 0 then
          bNum = 1
        end
        local pTime = self.matchWaitTime * bNum
        self.text_match_tips:SetLocalText("winter_battlefield_interface_tips1057", MyFloor(pTime / 60) .. "m")
      end
    elseif self.showMatchCD then
      local cdTime = self.wsInfo.matchCDTime or 0
      local remainTime = cdTime - curSec
      if 0 < remainTime then
        local txt = tMgr:SecondToFmtStringWithoutDay(remainTime)
        self.text_btn_start:SetText(Localization:GetString("winter_battlefield_interface_tips1011") .. "\n" .. txt)
      else
        self:RefreshView()
        return
      end
    end
  else
    stopSend = true
    endTime = self.wsInfo.actEndTime or 0
  end
  if 0 < endTime then
    local remainTime = endTime - curSec
    if 0 < remainTime or stopSend then
      remainTime = remainTime < 0 and 0 or remainTime
      local txt = tMgr:SecondToFmtString(remainTime)
      self.text_remain_time:SetText(txt)
    else
      trySendData = true
    end
  end
  if trySendData then
    self:CheckSendGetInfo()
  end
  self:ShowCalendatBtnContent()
end

function WinterStormActivityMainRoot:CheckSendGetInfo()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastInfoRequestTime == nil or curTime - self.lastInfoRequestTime > 3000 then
    DataCenter.ActWinterStormManager:ReqActInfo()
    self.lastInfoRequestTime = curTime
  end
end

function WinterStormActivityMainRoot:UpdateTimeShow()
  self.curFightSTime = nil
  self.curFightETime = nil
  if self.curStatus ~= 0 and self.curStatus ~= 1 and self.curStatus ~= 2 then
    return false
  end
  self.text_battle_time_tips:SetLocalText(self.isShowLocalTime == true and "winter_battlefield_interface_tips1012" or "winter_battlefield_interface_tips1013")
  if self.wsInfo == nil then
    return false
  end
  local tMgr = UITimeManager:GetInstance()
  local curSec = tMgr:GetServerSeconds()
  local dateCur = tMgr:TimeSecToServerDate(curSec)
  local battleBeginTime = self.wsInfo.battleBeginTime
  local dateBattle = tMgr:TimeSecToServerDate(battleBeginTime)
  local hourTime = 3600
  local dayTime = hourTime * 24
  while dateCur.month == dateBattle.month and dateCur.day > dateBattle.day do
    battleBeginTime = battleBeginTime + dayTime
    dateBattle = tMgr:TimeSecToServerDate(battleBeginTime)
  end
  local k4 = self.wsInfo.battleK4
  local k5 = self.wsInfo.battleK5
  for _, item in ipairs(self.timeSignItems) do
    item:SetStatus(0)
  end
  local bHasCur = false
  for i = 1, 3 do
    local time = k4[i]
    local mtItem = self.matchTimeItems[i]
    if time == nil then
      if mtItem ~= nil then
        mtItem:SetActive(false)
      end
    else
      local time1 = battleBeginTime + time * hourTime
      local time2 = time1 + k5 * hourTime
      local bCur = false
      if self.curStatus ~= 0 then
        if curSec >= time1 and curSec < time2 then
          bCur = true
          bHasCur = true
          self.curFightSTime = time1
          self.curFightETime = time2
        elseif curSec < time1 and (not self.curFightSTime or time1 < self.curFightSTime) then
          self.curFightSTime = time1
          self.curFightETime = time2
        end
      end
      local date1 = tMgr:TimeSecToServerDate(time1)
      for j = 1, k5 do
        local tsItem = self.timeSignItems[date1.hour + j]
        if tsItem ~= nil then
          tsItem:SetStatus(bCur and 2 or 1)
        end
      end
      local posX = 0
      local fixX = 0
      local stItem = self.timeSignItems[date1.hour + 1]
      if stItem ~= nil then
        local w = stItem.rectTransform.rect.width
        posX = stItem.transform.position.x + w * (k5 - 1) * 0.5 * CommonUtil.ArabicAutoMirrorFactor()
        if #k4 == 3 then
          if i == 1 then
            fixX = w * k5 * 0.1
          elseif i == 2 then
            fixX = -w * k5 * 0.1
          elseif i == 3 then
            fixX = -w * k5 * 0.1
          end
        end
        posX = posX - fixX * CommonUtil.ArabicAutoMirrorFactor()
      end
      if mtItem ~= nil then
        mtItem:SetActive(true)
        local mtPos = mtItem.transform.position
        mtPos.x = posX
        mtItem.transform.position = mtPos
        if self.isShowLocalTime == true then
          date1 = tMgr:TimeSecToLocalDate(time1)
        end
        local date2 = self.isShowLocalTime == true and tMgr:TimeSecToLocalDate(time2) or tMgr:TimeSecToServerDate(time2)
        mtItem:SetTime(bCur, date1, date2)
        mtItem:SetFixX(fixX)
      end
    end
  end
  local newX = 0
  if self.curStatus == 0 then
    local stItem = self.timeSignItems[1]
    if stItem ~= nil then
      newX = stItem.transform.position.x
    end
  else
    local stItem = self.timeSignItems[dateCur.hour + 1]
    if stItem ~= nil then
      newX = stItem.transform.position.x
    end
  end
  self:UpdateSignEff(bHasCur)
  local curSignPos = self.cur_sign.transform.position
  curSignPos.x = newX
  self.cur_sign.transform.position = curSignPos
  return bHasCur
end

function WinterStormActivityMainRoot:UpdateSignEff(bHasCur)
  local signPath = ""
  local e_path = ""
  if self.curStatus == 0 then
    signPath = img_sign_sleep_path
  elseif bHasCur == true then
    signPath = img_sign_cur_path
  else
    signPath = img_sign_nor_path
  end
  self.cur_sign:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterPath, signPath))
  if string.IsNullOrEmpty(e_path) then
    if not IsNull(self.sign_eff_obj) then
      self.sign_eff_obj:Destroy()
      self.sign_eff_obj = nil
    end
  elseif IsNull(self.sign_eff_obj) and self.req == nil then
    self.req = Resource:InstantiateAsync(e_path)
    self.req:completed("+", function(req)
      local _go = req.gameObject
      if _go == nil then
        return
      end
      _go.transform:SetParent(self.cur_sign.transform)
      _go.transform:Set_localPosition(50 * CommonUtil.ArabicAutoMirrorFactor(), -10, 0)
      _go.transform:Set_localScale(100, 100, 100)
      self.sign_eff_obj = _go
    end)
  end
end

function WinterStormActivityMainRoot:UpdateFightingShow()
  if self.curStatus ~= 3 or self.wsInfo == nil then
    return
  end
  if self.fighting_top == nil then
    self.fighting_top = DataCenter.ActWinterStormManager:CreateBattleInfoAsync(self, self.fighting_show, -15, function()
      self:UpdateFightingShow()
    end)
    return
  end
  if not self.fighting_top:AsyncLoadDone() then
    return
  end
  local marchResults = self.wsInfo.marchResult
  local team = {}
  local mySide = 0
  if marchResults ~= nil then
    mySide = marchResults:GetMySide()
    team = marchResults:GetTeamList(mySide == 1)
  end
  local selfUid = LuaEntry.Player:GetUid()
  local idx = 1
  for _, teamArr in ipairs(team) do
    local v = self.playerItems[idx]
    if v ~= nil and teamArr.uid ~= selfUid then
      idx = idx + 1
      v:SetPlayer(teamArr)
    end
  end
  local numCL, numCR = 0, 0
  local otherSide = 0
  if mySide ~= 0 then
    otherSide = mySide == 2 and 1 or 2
  end
  local battleScore = self.wsInfo.battleScore
  for side, score in pairs(battleScore) do
    if side == mySide then
      numCL = numCL + score
    elseif side == otherSide then
      numCR = numCR + score
    end
  end
  self.fighting_top:UpdateNum(numCL, numCR, mySide)
end

function WinterStormActivityMainRoot:UpdateResultShow()
  if self.curStatus ~= 4 then
    return
  end
  if self.hasResult then
    local mvp = self.wsInfo ~= nil and self.wsInfo.mvp or {}
    for i, v in ipairs(self.resultItems) do
      local data = mvp[i]
      if data then
        v:SetActive(true)
        v:ReInit(data)
      else
        v:SetActive(false)
      end
    end
  else
    self.text_empty_tip:SetLocalText("winter_battlefield_tips1011")
  end
end

function WinterStormActivityMainRoot:InfoBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleDetail, BattleFieldType.WinterStorm)
end

function WinterStormActivityMainRoot:RewardBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormTaskS0)
end

function WinterStormActivityMainRoot:RuleBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertRules, {anim = true}, BattleFieldType.WinterStorm)
end

function WinterStormActivityMainRoot:ShopBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.HonorShop)
end

function WinterStormActivityMainRoot:HistoryBtnClick()
  DataCenter.ActWinterStormManager:SendLogInfo()
end

function WinterStormActivityMainRoot:AchievementBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormAchievement)
end

function WinterStormActivityMainRoot:ChangeShowTimeBtnClick()
  self.isShowLocalTime = not self.isShowLocalTime
  BattleFieldUtil.SetShowLocalTime(self.isShowLocalTime)
end

function WinterStormActivityMainRoot:MatchingBtnClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastMatchingBtnClickTime == nil or curTime - self.lastMatchingBtnClickTime > 3000 then
    DataCenter.ActWinterStormManager:SendMatchCancel()
    self.lastMatchingBtnClickTime = curTime
  end
end

function WinterStormActivityMainRoot:StartBtnClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastStartBtnClickTime == nil or curTime - self.lastStartBtnClickTime > 3000 then
    if self.curStatus == 3 then
      DataCenter.ActWinterStormManager:TryEnterBattlefield()
    else
      DataCenter.ActWinterStormManager:SendMatch()
    end
    self.lastStartBtnClickTime = curTime
  end
end

return WinterStormActivityMainRoot
