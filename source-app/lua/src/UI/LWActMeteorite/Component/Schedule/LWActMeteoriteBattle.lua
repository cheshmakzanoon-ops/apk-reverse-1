local base = UIBaseContainer
local LWActMeteoriteBattle = BaseClass("LWActMeteoriteBattle", base)
local Localization = CS.GameEntry.Localization
local LWActMeteoriteZoneItem = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteZoneItem")
local LWActMeteoriteZoneInfo = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteZoneInfo")
local LWActMeteoriteBattleServerItem = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteBattleServerItem")
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local smoke_path = "Center/bg/Eff_UI_LWActMeteoriteBattle_Smoke"
local impact_path = "Center/bg/Eff_UI_LWActMeteoriteBattle_Impact"
local impact_eff_path = "Center/bg/Eff_UI_LWActMeteoriteBattle_Impact/Root"
local zone_path = "Center/Zone"
local btn_confirm_path = "Center/BtnConfirm"
local coming_path = "Center/Coming"
local coming_time_text_path = "Center/Coming/ComingTime/ComingTimeText"
local zone_info_path = "Center/ZoneInfo"
local s_out_path = "Center/SOut"
local s_in_path = "Center/SIn"
local o_out_path = "Center/OOut"
local o_out_text_path = "Center/OOut/OOutText"
local o_in_path = "Center/OIn"
local o_in_text_path = "Center/OIn/OInText"
local layout_path = "Middle/Layout"
local server_item_path = "Middle/ServerItem"
local desc_text_path = "Top/DescText"
local time_text_path = "Top/TimeText"
local alliance_text_path = "AllianceText"
local person_text_path = "PersonText"
local calendar_add_btn_content_path = "Center/Coming/CalendarAddBtnContent"

function LWActMeteoriteBattle:OnCreate()
  base.OnCreate(self)
  self.servers = {}
  self.curTimeText = nil
  self.endTime = nil
  self.meteorite = nil
  self.smoke = self:AddComponent(UIBaseComponent, smoke_path)
  self.impact = self:AddComponent(UIBaseComponent, impact_path)
  self.impact_eff = self:AddComponent(UISimpleAnimation, impact_eff_path)
  self.zone = self:AddComponent(LWActMeteoriteZoneItem, zone_path)
  self.btn_confirm = self:AddComponent(UIButton, btn_confirm_path)
  self.btn_confirm:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    DataCenter.ActMeteoriteBattleManager:DoPointJump()
  end)
  self.coming = self:AddComponent(UIBaseComponent, coming_path)
  self.coming_time_text = self:AddComponent(UITextMeshProUGUIEx, coming_time_text_path)
  self.zone_info = self:AddComponent(LWActMeteoriteZoneInfo, zone_info_path)
  self.s_out = self:AddComponent(UIBaseComponent, s_out_path)
  self.s_in = self:AddComponent(UIBaseComponent, s_in_path)
  self.o_out = self:AddComponent(UIButton, o_out_path)
  self.o_out:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local strTip = Localization:GetString("yuntieBattle_tips_1013", self.o_out_text:GetText())
    UIUtil.ShowBubbleTips(strTip, self.o_out.transform.position, 0, -30, 0)
  end)
  self.o_out_text = self:AddComponent(UITextMeshProUGUIEx, o_out_text_path)
  self.o_in = self:AddComponent(UIButton, o_in_path)
  self.o_in:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local strTip = Localization:GetString("yuntieBattle_tips_1013", self.o_in_text:GetText())
    UIUtil.ShowBubbleTips(strTip, self.o_in.transform.position, 0, 30, 0, nil, nil, {reversal = true})
  end)
  self.o_in_text = self:AddComponent(UITextMeshProUGUIEx, o_in_text_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.server_item = self.transform:Find(server_item_path).gameObject
  self.server_item:GameObjectCreatePool()
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.alliance_text = self:AddComponent(UITextMeshProUGUIEx, alliance_text_path)
  self.person_text = self:AddComponent(UITextMeshProUGUIEx, person_text_path)
  self.calendar_add_btn_content = self:AddComponent(CalendarAddBtnContent, calendar_add_btn_content_path)
end

function LWActMeteoriteBattle:OnDestroy()
  self:CleanTimer()
  self.server_item:GameObjectRecycleAll()
  for _, v in ipairs(self.layout.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.smoke = nil
  self.impact = nil
  self.impact_eff = nil
  self.zone = nil
  self.btn_confirm = nil
  self.coming = nil
  self.coming_time_text = nil
  self.zone_info = nil
  self.s_out = nil
  self.s_in = nil
  self.o_out = nil
  self.o_out_text = nil
  self.o_in = nil
  self.o_in_text = nil
  self.layout = nil
  self.server_item = nil
  self.desc_text = nil
  self.time_text = nil
  self.alliance_text = nil
  self.person_text = nil
  self.calendar_add_btn_content = nil
  self.servers = {}
  self.curTimeText = nil
  self.endTime = nil
  self.meteorite = nil
  base.OnDestroy(self)
end

function LWActMeteoriteBattle:CleanTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.delayTimer2 then
    self.delayTimer2:Stop()
    self.delayTimer2 = nil
  end
end

function LWActMeteoriteBattle:SetData()
  local actMgr = DataCenter.ActMeteoriteBattleManager
  local actInfo = actMgr:GetActInfo()
  local servers = actInfo ~= nil and actInfo.servers or {}
  for i, sId in ipairs(servers) do
    local co = self.servers[i]
    if co == nil then
      local goItem = self.server_item:GameObjectSpawn(self.layout.transform)
      goItem.name = "server" .. i
      goItem:SetActive(true)
      co = self.layout:AddComponent(LWActMeteoriteBattleServerItem, goItem.name)
      self.servers[i] = co
    end
    co:SetData(sId)
  end
  self.endTime = actInfo ~= nil and actInfo.stageEndTime or 0
  local meteorite = actMgr:GetCurMeteoriteInfo()
  self.meteorite = meteorite
  self.zone:SetData(meteorite)
  local _stage = actInfo and actInfo.stage
  if _stage == MeteoriteState.REST then
    local _ = Localization:GetString("yuntieBattle_interface_1041")
    self.person_text:SetText(string.format("%s: %s", Localization:GetString("yuntieBattle_interface_1002"), _))
    self.alliance_text:SetText(string.format("%s: %s", Localization:GetString("yuntieBattle_interface_1003"), _))
  else
    local aRank = actInfo ~= nil and actInfo.myAllianceRank or 0
    local aStr = Localization:GetString("yuntieBattle_interface_1003")
    if 0 < aRank then
      self.alliance_text:SetText(aStr .. ": " .. aRank)
    else
      self.alliance_text:SetText(aStr .. ": " .. Localization:GetString("361054"))
    end
    local pRank = actInfo ~= nil and actInfo.myRank or 0
    local pStr = Localization:GetString("yuntieBattle_interface_1002")
    if 0 < pRank then
      self.person_text:SetText(pStr .. ": " .. pRank)
    else
      self.person_text:SetText(pStr .. ": " .. Localization:GetString("361054"))
    end
  end
  local bGRAB = actInfo ~= nil and actInfo.stage == MeteoriteState.GRAB
  local myArea = actInfo ~= nil and actInfo.myArea or 0
  self.coming:SetActive(not bGRAB)
  self.zone_info:SetActive(bGRAB)
  self.s_out:SetActive(bGRAB and myArea == 2)
  self.s_in:SetActive(bGRAB and myArea == 1)
  local blackLandAllianceMember = actInfo ~= nil and actInfo.blackLandAllianceMember or 0
  self.o_in:SetActive(bGRAB and 0 < blackLandAllianceMember)
  local yellowLandAllianceMember = actInfo ~= nil and actInfo.yellowLandAllianceMember or 0
  self.o_out:SetActive(bGRAB and 0 < yellowLandAllianceMember)
  self.desc_text:SetActive(bGRAB)
  self.time_text:SetActive(bGRAB)
  if bGRAB then
    self.zone_info:SetData(meteorite, 2)
    if 0 < blackLandAllianceMember then
      self.o_in_text:SetText(blackLandAllianceMember)
    end
    if 0 < yellowLandAllianceMember then
      self.o_out_text:SetText(yellowLandAllianceMember)
    end
    self.curTimeText = self.time_text
    self:PlayGrabEffShow(false)
    local stageId = actMgr:GetCurStageId()
    local sTime = actMgr:GetStageTime(stageId)
    local signTime = CommonUtil.PlayerPrefsGetInt("_METEORITE_UI_GRAB_EFF_SHOW", 0)
    local playEnter = sTime > signTime
    self:PlayGrabEffShow(playEnter)
    if playEnter then
      CommonUtil.PlayerPrefsSetInt("_METEORITE_UI_GRAB_EFF_SHOW", sTime)
    end
  else
    self.curTimeText = self.coming_time_text
    self.smoke:SetActive(false)
    self.impact:SetActive(false)
  end
  self:Update1000MS()
  self:ShowCalendatBtnContent()
end

function LWActMeteoriteBattle:ShowCalendatBtnContent()
  local actMgr = DataCenter.ActMeteoriteBattleManager
  local actInfo = actMgr:GetActInfo()
  if actInfo ~= nil and actInfo.stage == MeteoriteState.PREVIEW and self.endTime > 0 then
    self.calendar_add_btn_content:SetActive(true)
    local startTime = toInt(self.endTime)
    local endTime = toInt(self.endTime)
    self.calendar_add_btn_content:SetDataWithDefautValue(6, startTime, endTime, CalendarSourcePath.Activity)
  else
    self.calendar_add_btn_content:SetActive(false)
  end
end

function LWActMeteoriteBattle:PlayGrabEffShow(bEnter)
  self:CleanTimer()
  self.impact:SetActive(bEnter)
  if bEnter then
    self.smoke:SetActive(false)
    local flag, time = self.impact_eff:PlayAnimationReturnTime("Default")
    if flag then
      self.delayTimer2 = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayTimer2 then
          self.delayTimer2:Stop()
          self.delayTimer2 = nil
        end
        self.smoke:SetActive(true)
      end, time)
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:PlayGrabEffShow(false)
    end, 8)
  else
    self.smoke:SetActive(true)
  end
end

function LWActMeteoriteBattle:Update1000MS()
  if self.curTimeText == nil or self.endTime == nil or self.endTime == 0 then
    return
  end
  local timeMgr = UITimeManager:GetInstance()
  local remainTime = self.endTime - timeMgr:GetServerSeconds()
  if 0 < remainTime then
    self.curTimeText:SetText(timeMgr:SecondToFmtString(remainTime))
  else
    self.curTimeText:SetText(timeMgr:SecondToFmtString(0))
    self.endTime = 0
    DataCenter.ActMeteoriteBattleManager:ReqGetActInfo()
  end
end

return LWActMeteoriteBattle
