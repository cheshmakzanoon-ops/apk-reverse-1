local DesertBattleMainIdle = BaseClass("DesertBattleMainIdle", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.ActDragonManager
local UITimeMgr = UITimeManager:GetInstance()
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")

function DesertBattleMainIdle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DesertBattleMainIdle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DesertBattleMainIdle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBattleTime = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textBattleTimeTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnChangeShowTime = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnChangeShowTime:SetOnClick(function()
    self:OnBtnChangeShowTimeClick()
  end)
  self.compCalendarAddBtnContent = self.viewSkin:AddComponent(self, CalendarAddBtnContent, 4)
  self.textBattleTimeData = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textBattleTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
end

function DesertBattleMainIdle:ComponentDestroy()
  self.viewSkin = nil
  self.compBattleTime = nil
  self.textBattleTimeTips = nil
  self.btnChangeShowTime = nil
  self.compCalendarAddBtnContent = nil
  self.textBattleTimeData = nil
  self.textBattleTime = nil
  self.textTips = nil
end

function DesertBattleMainIdle:DataDefine()
  self.effTips = self.textTips.transform:Find("VFX_activity_desert_text"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.effTips.gameObject:SetActive(false)
  self.signLimit = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k2", 32)
  self.maxNumMain = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  self.playedEff = false
end

function DesertBattleMainIdle:DataDestroy()
  self.mainComp = nil
end

function DesertBattleMainIdle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonBattleTimes, self.ShowBattleTime)
  self:AddUIListener(EventId.GetDagonPlayerList, self.UpdatePlayerList)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnDesertBattleChangeShowLocalTime)
end

function DesertBattleMainIdle:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonBattleTimes, self.ShowBattleTime)
  self:RemoveUIListener(EventId.GetDagonPlayerList, self.UpdatePlayerList)
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnDesertBattleChangeShowLocalTime)
  base.OnRemoveListener(self)
end

function DesertBattleMainIdle:OnBtnChangeShowTimeClick()
  self.isShowLocalTime = not self.isShowLocalTime
  BattleFieldUtil.SetShowLocalTime(self.isShowLocalTime)
end

function DesertBattleMainIdle:SetMain(comp)
  self.mainComp = comp
end

function DesertBattleMainIdle:UpdateData()
  self.textTips:SetLocalText("Desert_strom_tips1024", self.signLimit)
  local actInfo = self.actInfo
  if self.mainComp == nil or self.mainComp:CheckDsbAct() or actInfo == nil or actInfo.stopSignUpTime == nil or actInfo.actEndTime ~= nil or not LuaEntry.Player:IsInAlliance() then
    self:SetCompBattleTime(false)
    return
  end
  local curTime = UITimeMgr:GetServerTime()
  local groupInfo = self.dragonInfo
  local signUp = groupInfo ~= nil and groupInfo.signUp or 0
  if curTime <= actInfo.stopSignUpTime then
    self.battleTime = ActMgr:GetBattleTimeInfo()
    if table.IsNullOrEmpty(self.battleTime) then
      ActMgr:SendGetBattleTime()
    end
    self:ShowBattleTime()
    self:UpdatePlayerList()
  elseif signUp == ActMgr.SignUpState.NoSignUp then
    self:SetCompBattleTime(false)
  end
end

function DesertBattleMainIdle:SetCompBattleTime(flag)
  self.compBattleTime:SetActive(flag)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function DesertBattleMainIdle:UpdatePlayerList()
  if self.mainComp == nil or self.mainComp:CheckDsbAct() then
    return
  end
  local groupInfo = self.dragonInfo
  local battlePeriod = groupInfo ~= nil and groupInfo.battlePeriod or 0
  if battlePeriod ~= 0 then
    local maxNumMain = self.maxNumMain
    local curNumMain = ActMgr:GetCurNumByState(DragonPlayerState.Main, self.curTabIdx)
    local isMainBattleMember = ActMgr:SelfIsBattleMember(DragonPlayerState.Main, self.curTabIdx)
    local mainStr = Localization:GetString("458128", " " .. curNumMain .. "/" .. maxNumMain)
    if isMainBattleMember then
      self.textTips:SetText(mainStr .. Localization:GetString("458284"))
      local eff = self.effTips
      if not self.playedEff and eff and not eff.gameObject.activeSelf then
        eff.gameObject:SetActive(true)
        eff:Simulate(0)
        eff:Play()
        self.playedEff = true
        if eff.main ~= nil then
          do
            local seq = CS.DG.Tweening.DOTween.Sequence()
            seq:AppendInterval(eff.main.duration)
            
            function seq.onComplete()
              if eff then
                eff.gameObject:SetActive(false)
                eff:Stop()
              end
            end
          end
        end
      end
    else
      self.textTips:SetText(mainStr)
    end
  else
    self.textTips:SetLocalText("Desert_strom_tips1024", self.signLimit)
  end
end

function DesertBattleMainIdle:ShowBattleTime()
  local curTime = UITimeMgr:GetServerTime()
  local actInfo = self.actInfo
  if actInfo == nil or actInfo.stopSignUpTime == nil or curTime >= actInfo.stopSignUpTime then
    self:SetCompBattleTime(false)
    return
  end
  local groupInfo = self.dragonInfo
  local signUp = groupInfo ~= nil and groupInfo.signUp or 0
  if signUp == ActMgr.SignUpState.NoSignUp then
    self:SetCompBattleTime(false)
    return
  end
  self.battleTime = ActMgr:GetBattleTimeInfo()
  if self.battleTime == nil then
    self:SetCompBattleTime(false)
    return
  end
  local battlePeriod = groupInfo ~= nil and groupInfo.battlePeriod or 0
  for _, v in ipairs(self.battleTime) do
    if v ~= nil and v.battlePeriod == battlePeriod then
      self:SetCompBattleTime(true)
      self.curBattleTimeInfo = v
      self:RefreshBattleTimeShow()
      break
    end
  end
end

function DesertBattleMainIdle:OnDesertBattleChangeShowLocalTime()
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  self:RefreshBattleTimeShow()
end

function DesertBattleMainIdle:RefreshBattleTimeShow()
  if not self.curBattleTimeInfo then
    return
  end
  local startTime = self.curBattleTimeInfo.startTime or 0
  local endTime = self.curBattleTimeInfo.endTime or 0
  local tipKey, dataStr, timeStr
  if self.isShowLocalTime then
    tipKey = "Desert_strom_tips1001"
    dataStr = UITimeMgr:GetTimeToLocalYMD(math.modf(startTime))
    local startTimeLocalStr = UITimeMgr:ConvertServerTimeToLocalTime(startTime, true, true)
    local endTimeLocalStr = UITimeMgr:ConvertServerTimeToLocalTime(endTime, true, true)
    timeStr = startTimeLocalStr .. " ~ " .. endTimeLocalStr
  else
    tipKey = "Desert_strom_tips1002"
    dataStr = UITimeMgr:GetTimeToMD(math.modf(startTime / 1000))
    local startTimeStr = UITimeMgr:TimeStampToTimeForServerSimple(startTime, true)
    local endTimeStr = UITimeMgr:TimeStampToTimeForServerSimple(endTime, true)
    timeStr = startTimeStr .. " ~ " .. endTimeStr
  end
  self.textBattleTimeTips:SetLocalText(tipKey)
  self.textBattleTimeData:SetText(string.format("%s: %s", Localization:GetString("Desert_strom_tips1017"), dataStr))
  self.textBattleTime:SetText(timeStr)
  if 0 < startTime then
    startTime = toInt(startTime / 1000)
  end
  if 0 < endTime then
    endTime = toInt(endTime / 1000)
  end
  self.compCalendarAddBtnContent:SetDataWithDefautValue(5, startTime, endTime)
end

local function getter_curTabIdx(self)
  return self.mainComp ~= nil and self.mainComp.curTabIdx or 0
end

local function getter_actInfo(self)
  return self.mainComp ~= nil and self.mainComp.actInfo
end

local function getter_dragonInfo(self)
  return self.mainComp ~= nil and self.mainComp.dragonInfo
end

DesertBattleMainIdle.getters.curTabIdx = getter_curTabIdx
DesertBattleMainIdle.getters.actInfo = getter_actInfo
DesertBattleMainIdle.getters.dragonInfo = getter_dragonInfo
return DesertBattleMainIdle
