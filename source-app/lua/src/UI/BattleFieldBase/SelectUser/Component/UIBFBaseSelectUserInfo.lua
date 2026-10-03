local UIBFBaseSelectUserInfo = BaseClass("UIBFBaseSelectUserInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local player_path = "MemberInfoContent/player"
local commander_flag_path = "MemberInfoContent/CommanderFlag"
local name_text_path = "MemberInfoContent/Info/NameText"
local power_text_path = "MemberInfoContent/Info/PowerText"
local commander_path = "MemberInfoContent/Info/Commander"
local checkbox0_path = "MemberInfoContent/Info/Commander/checkbox0/active"
local btn0_path = "MemberInfoContent/Info/Commander/checkbox0/Btn0"
local red_path = "MemberInfoContent/Info/Commander/checkbox0/red"
local checkbox1_path = "MemberInfoContent/checkbox1"
local checkbox2_path = "MemberInfoContent/checkbox2"
local mark_path = "MemberInfoContent/mark"
local mark_text_path = "MemberInfoContent/mark/txt"
local r45_path = "MemberInfoContent/R45"
local disable1_path = "MemberInfoContent/R45/disable1"
local disable2_path = "MemberInfoContent/R45/disable2"
local btn1_path = "MemberInfoContent/checkbox1/Btn1"
local btn2_path = "MemberInfoContent/checkbox2/Btn2"
local member_select_battle_time_content_path = "MemberSelectBattleTimeContent"
local battle_time_img_path = "MemberSelectBattleTimeContent/BattleTimeImg"
local battle_data_text_path = "MemberSelectBattleTimeContent/BattleDataText"
local battle_time_text_path = "MemberSelectBattleTimeContent/BattleTimeText"
local black_path = "Black"
local voice_flag_path = "MemberInfoContent/Info/Commander/VoiceFlag"

function UIBFBaseSelectUserInfo:OnCreate()
  base.OnCreate(self)
  self.isCommanderModuleEnable = self.view.ctrl:IsCommanderModuleEnable()
  self.IsTeamSelectBattleTimeModuleEnable = self.view.ctrl:IsTeamSelectBattleTimeModuleEnable()
  self.curShowBattleTimeIndex = 1
  self.applyStatus = nil
  self.isPrepTime = self.view.ctrl:IsInPrepTime()
  self.hadTeam2 = self.view.ctrl:IsHadTeam2()
  self.black = self:AddComponent(UIBaseComponent, black_path)
  self.black:SetActive(false)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.power_text = self:AddComponent(UIText, power_text_path)
  if self.isCommanderModuleEnable then
    self.btn0 = self:TryAddComponent(UIButton, btn0_path)
    self.red = self:TryAddComponent(UIButton, red_path)
    self.commander_flag = self:TryAddComponent(UIBaseComponent, commander_flag_path)
    self.commander = self:TryAddComponent(UIBaseComponent, commander_path)
    self.checkbox0 = self:TryAddComponent(UIBaseComponent, checkbox0_path)
    if self.btn0 then
      self.btn0:SetOnClick(function()
        if DataCenter.AllianceBaseDataManager:IsR4orR5() then
          local flag = self.checkbox0:GetActive()
          if self:IsUserCanBeCommander() then
            self.checkbox0:SetActive(not flag)
            self:SetOnCommanderValueChanged()
          end
        else
          UIUtil.ShowTipsId("458187")
        end
      end)
    end
  end
  self.checkbox1 = self:AddComponent(UIToggle, checkbox1_path)
  self.imgActive1 = self.checkbox1:AddComponent(UIImage, "active")
  self.checkbox2 = self:AddComponent(UIToggle, checkbox2_path)
  self.imgActive2 = self.checkbox2:AddComponent(UIImage, "active")
  self.btn1 = self:AddComponent(UIButton, btn1_path)
  self.btn2 = self:AddComponent(UIButton, btn2_path)
  self.r45 = self:AddComponent(UIButton, r45_path)
  self.disable1 = self:AddComponent(UIImage, disable1_path)
  self.disable2 = self:AddComponent(UIImage, disable2_path)
  self.mark = self:AddComponent(UICanvasGroup, mark_path)
  self.mark_text = self:AddComponent(UITextMeshProUGUIEx, mark_text_path)
  self.player:SetEnableClickShowInfo(true)
  if self.isPrepTime then
    self.r45:SetActive(true)
    self.checkbox1:SetInteractable(false)
    self.checkbox2:SetInteractable(false)
  elseif DataCenter.AllianceBaseDataManager:IsR4orR5() then
    self.r45:SetActive(false)
    self.checkbox1:SetOnValueChanged(function(_)
      self:SetOnValueChanged()
    end)
    self.checkbox2:SetOnValueChanged(function(_)
      self:SetOnValueChanged()
    end)
    self.btn1:SetOnClick(function()
      local select1 = self.checkbox1:GetIsOn()
      if select1 then
        self.checkbox1:SetIsOn(false)
      else
        local select2 = self.checkbox2:GetIsOn()
        if select2 or self.view.ctrl:IsUserCanJoin(self.data) then
          self:SetBoxOn(1)
        end
      end
    end)
    self.btn2:SetOnClick(function()
      local select2 = self.checkbox2:GetIsOn()
      if select2 then
        self.checkbox2:SetIsOn(false)
      else
        local select1 = self.checkbox1:GetIsOn()
        if select1 or self.view.ctrl:IsUserCanJoin(self.data) then
          self:SetBoxOn(2)
        end
      end
    end)
  else
    self.checkbox1:SetInteractable(false)
    self.checkbox2:SetInteractable(false)
    self.r45:SetActive(true)
    self.r45:SetOnClick(function()
      UIUtil.ShowTipsId("458187")
    end)
  end
  self.member_select_battle_time_content = self:AddComponent(UIBaseContainer, member_select_battle_time_content_path)
  self.battle_time_img = self:AddComponent(UIImage, battle_time_img_path)
  self.battle_data_text = self:AddComponent(UIText, battle_data_text_path)
  self.battle_time_text = self:AddComponent(UIText, battle_time_text_path)
  self.voice_flag = self:TryAddComponent(UIButton, voice_flag_path)
  if self.voice_flag then
    local voiceServiceState = LuaEntry.DataConfig:CheckSwitch("voice_room")
    if voiceServiceState then
      self.voice_flag:SetActive(true)
      self.voice_flag:SetOnClick(function()
        local strTip = Localization:GetString("voice_room_tips1")
        UIUtil.ShowBubbleTips(strTip, self.voice_flag.transform.position, 0, -30, 0, nil, nil)
      end)
    else
      self.voice_flag:SetActive(false)
    end
  end
end

function UIBFBaseSelectUserInfo:SetOnValueChanged()
  if self.checkbox1:GetIsOn() then
    if DragonPlayerState.Main ~= self.data.dragonPlayerState then
      self.data.dragonPlayerState = DragonPlayerState.Main
      self.view:SetPlayerState(self.data.uid, DragonPlayerState.Main)
    end
  elseif self.checkbox2:GetIsOn() then
    if DragonPlayerState.Sub ~= self.data.dragonPlayerState then
      self.data.dragonPlayerState = DragonPlayerState.Sub
      self.view:SetPlayerState(self.data.uid, DragonPlayerState.Sub)
    end
  elseif DragonPlayerState.None ~= self.data.dragonPlayerState and self.data.dragonPlayerState ~= nil then
    self.data.dragonPlayerState = DragonPlayerState.None
    if self.isCommanderModuleEnable then
      self.data.commander = false
      self.commander_flag:SetActive(false)
    end
    self.view:SetPlayerState(self.data.uid, DragonPlayerState.None)
  end
end

function UIBFBaseSelectUserInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattlefieldPlayerListUpdate, self.UpdateData)
  self:AddUIListener(EventId.BattlefieldTeamSelfApplySuccess, self.RefreshSelfApply)
  self:AddUIListener(EventId.BattlefieldRefreshMemberBattleTimeShow, self.OnRefreshDesertBattleMemberBattleTimeShow)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.RefreshBattleTimeShow)
end

function UIBFBaseSelectUserInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.BattlefieldPlayerListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.BattlefieldTeamSelfApplySuccess, self.RefreshSelfApply)
  self:RemoveUIListener(EventId.BattlefieldRefreshMemberBattleTimeShow, self.OnRefreshDesertBattleMemberBattleTimeShow)
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.RefreshBattleTimeShow)
  base.OnRemoveListener(self)
end

function UIBFBaseSelectUserInfo:OnDestroy()
  if self.sequence ~= nil then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.applyStatus = nil
  self.player = nil
  self.name_text = nil
  self.power_text = nil
  self.checkbox1 = nil
  self.checkbox2 = nil
  self.mark = nil
  self.mark_text = nil
  self.member_select_battle_time_content = nil
  self.battle_time_img = nil
  self.battle_data_text = nil
  self.battle_time_text = nil
  self.voice_flag = nil
  base.OnDestroy(self)
end

function UIBFBaseSelectUserInfo:ReInit(data, view, userItem, group, powerArmyMode)
  self.data = data
  self.group = group
  self.view = view
  self.userItem = userItem
  self.powerArmyMode = powerArmyMode
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.name)
  self.name_text:SetText(showName)
  self.player:SetHead(data.uid, data.pic, data.picVer or 0)
  self:UpdateData()
end

function UIBFBaseSelectUserInfo:SetData(data)
  self.applyStatus = nil
  self:ReInit(data, self.view, nil, self.view.curTabIdx, self.view.powerArmyMode)
end

function UIBFBaseSelectUserInfo:SetBoxOn(idx)
  local checkbox = idx == 1 and self.checkbox1 or self.checkbox2
  checkbox:SetIsOn(true)
  if self.hadTeam2 then
    local img = idx == 1 and self.imgActive1 or self.imgActive2
    local group = self.userInfo.team or self.userInfo.group
    if group == 0 then
      group = self.view.curTabIdx
    end
    self.view.ctrl:LoadTeamSprite(img, group)
    img:SetNativeSize()
    img:SetLocalScaleXYZ(0.7, 0.7, 1)
  end
end

function UIBFBaseSelectUserInfo:RefreshSelfApply()
  if not (self.data and self.data.uid) or self.data.uid ~= LuaEntry.Player.uid then
    return
  end
  self:UpdateData()
end

function UIBFBaseSelectUserInfo:UpdateData()
  local oldStatus = self.applyStatus
  local newStatus = self.applyStatus
  self.userInfo = self.view.ctrl:GetPlayerInfoByUID(self.data.uid)
  if self.userInfo ~= nil then
    newStatus = self.userInfo.apply
    self.applyStatus = newStatus
    self.data.dragonPlayerState = self.userInfo.state or DragonPlayerState.None
  end
  if self.userInfo == nil then
    self.userInfo = {
      armyPower = 0,
      power = 0,
      team = 0
    }
  end
  if self.isCommanderModuleEnable then
    self.data.commander = self.view.ctrl:IsCommander(self.userInfo) or false
    self.commander_flag:SetActive(self.data.commander)
    self.checkbox0:SetActive(self.data.commander)
    self.commander:SetActive(true)
  end
  if self.data.dragonPlayerState == DragonPlayerState.Main then
    self:SetBoxOn(1)
    self.disable1:SetActive(false)
    self.disable2:SetActive(self.isPrepTime)
  elseif self.data.dragonPlayerState == DragonPlayerState.Sub then
    self:SetBoxOn(2)
    self.disable1:SetActive(self.isPrepTime)
    self.disable2:SetActive(false)
  else
    self.checkbox1:SetIsOn(false)
    self.checkbox2:SetIsOn(false)
    self.disable1:SetActive(self.isPrepTime)
    self.disable2:SetActive(self.isPrepTime)
  end
  local flag = oldStatus ~= nil and oldStatus ~= newStatus and newStatus == self.group and not self.mark:GetActive() and self.data.uid == LuaEntry.Player:GetUid()
  self:SetMarkShow(flag)
  if self.mark:GetActive() then
    if self.view.ctrl:GetBattlefieldType() == BattleFieldType.Desert then
      self.mark_text:SetLocalText("458004")
    else
      self.mark_text:SetLocalText(self.applyStatus == 1 and "YiBianJinQu_sign_up_tips_2" or "YiBianJinQu_sign_up_tips_3")
    end
  end
  local flag = not self.isPrepTime and self.view.curTabIdx ~= 0 and self.userInfo.team ~= 0 and self.userInfo.group ~= 0 and self.view.curTabIdx ~= self.userInfo.team and self.view.curTabIdx ~= self.userInfo.group
  self.black:SetActive(flag)
  if self.powerArmyMode then
    self.power_text:SetText(Localization:GetString("458134") .. ": " .. string.GetFormattedSeperatorNum(self.userInfo.armyPower))
  else
    self.power_text:SetText(Localization:GetString("458133") .. ": " .. string.GetFormattedSeperatorNum(self.userInfo.power))
  end
  self:RefreshActiveState()
  self:RefreshBattleTimeShow()
end

function UIBFBaseSelectUserInfo:SetMarkShow(flag)
  if self.sequence ~= nil then
    self.sequence:Kill()
    self.sequence = nil
  end
  if flag and not self.isPrepTime then
    self.mark:SetAlpha(0)
    self.mark:SetActive(true)
    self.mark:SetLocalScaleXYZ(10, 10, 10)
    self.view:FocusTo(self.data.uid)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:AppendInterval(0.2)
    sequence:Join(self.mark:FadeIn(0.24))
    sequence:Join(self.mark.transform:DOScale(ResetScale, 0.24))
    self.sequence = sequence
  else
    if self.view.ctrl:GetBattlefieldType() == BattleFieldType.Desert then
      self.mark:SetActive(self.applyStatus and self.applyStatus == 1 and not self.isPrepTime)
    else
      self.mark:SetActive(self.applyStatus and self.applyStatus == self.group and not self.isPrepTime)
    end
    self.mark:SetAlpha(1)
    self.mark:SetLocalScaleXYZ(1, 1, 1)
  end
end

function UIBFBaseSelectUserInfo:OnRefreshDesertBattleMemberBattleTimeShow()
  self:ShowSelectBattleTime(true)
end

function UIBFBaseSelectUserInfo:SetShowBattleTime(showBattleTimeData)
  local isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  local isEqual
  if self.IsTeamSelectBattleTimeModuleEnable then
    local battlePeriod = self.view.ctrl:GetTeamBattlePeriod(self.view.curTabIdx)
    isEqual = battlePeriod == showBattleTimeData.battlePeriod
  else
    isEqual = true
  end
  self.battle_time_img:SetColor(isEqual and DesertBattleBattleTimeBgGreenColor or DesertBattleBattleTimeBgYellowColor)
  if isShowLocalTime then
    local dataStr = Localization:GetString("Desert_strom_tips1001") .. ": " .. UITimeManager:GetInstance():GetTimeToLocalYMD(math.modf(showBattleTimeData.startTime))
    self.battle_data_text:SetText(dataStr)
    local startTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(showBattleTimeData.startTime, true, true)
    local endTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(showBattleTimeData.endTime, true, true)
    self.battle_time_text:SetText(startTimeLocalStr .. " ~ " .. endTimeLocalStr)
  else
    local dataStr = Localization:GetString("Desert_strom_tips1002") .. ": " .. UITimeManager:GetInstance():GetTimeToMD(math.modf(showBattleTimeData.startTime / 1000))
    self.battle_data_text:SetText(dataStr)
    local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(showBattleTimeData.startTime, true)
    local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(showBattleTimeData.endTime, true)
    self.battle_time_text:SetText(startTimeStr .. " ~ " .. endTimeStr)
  end
end

function UIBFBaseSelectUserInfo:RefreshActiveState()
  local flag = self.view.curTabIdx == 0 or self.view.curTabIdx == self.userInfo.team or self.view.curTabIdx == self.userInfo.group
  if self.isCommanderModuleEnable then
    local redFlag = DataCenter.AllianceBaseDataManager:IsR4orR5()
    local comCountA = self.view.ctrl:GetCurCommanderNum(1)
    local comCountB = self.view.ctrl:GetCurCommanderNum(2)
    local comCount = comCountA + comCountB
    if self.isPrepTime then
      if self.userInfo.group == 1 then
        redFlag = redFlag and comCountA == 0
      else
        redFlag = redFlag and comCountB == 0
      end
      self.red:SetActive(redFlag and flag)
    else
      self.red:SetActive(comCount == 0 and redFlag and flag)
    end
  end
end

function UIBFBaseSelectUserInfo:SetOnCommanderValueChanged()
  local flag = self.checkbox0:GetActive()
  if self.data.commander ~= flag then
    local success = self.view:SetPlayerCommander(self.data.uid, flag)
    if success then
      self.data.commander = flag
      self.commander_flag:SetActive(flag)
    else
      UIUtil.ShowTipsId("Desert_strom_commander_1025")
      self.checkbox0:SetActive(not flag)
    end
  end
end

function UIBFBaseSelectUserInfo:IsUserCanBeCommander()
  if not self.checkbox1:GetIsOn() and not self.checkbox2:GetIsOn() then
    UIUtil.ShowTipsId("Desert_strom_commander_1028")
    return false
  end
  return true
end

function UIBFBaseSelectUserInfo:RefreshBattleTimeShow()
  local filterBattleTimeData = self.view.ctrl:GetFilterBattleTimeData()
  if filterBattleTimeData ~= nil then
    self:ShowFilterBattleTime()
  else
    self:ShowSelectBattleTime(false)
  end
end

function UIBFBaseSelectUserInfo:ShowSelectBattleTime(changeIndex)
  local battlePeriodList = self.userInfo.selectBattlePeriodList or self.userInfo.chooseTimeList
  if not table.IsNullOrEmpty(battlePeriodList) and not self.isPrepTime and self.userInfo and self.userInfo.apply ~= 0 then
    self.member_select_battle_time_content:SetActive(true)
    if changeIndex then
      local maxValue = table.count(battlePeriodList)
      self.curShowBattleTimeIndex = self.curShowBattleTimeIndex + 1
      if maxValue < self.curShowBattleTimeIndex then
        self.curShowBattleTimeIndex = 1
      end
    end
    local battlePeriod = battlePeriodList[self.curShowBattleTimeIndex]
    local showBattleTimeData = self.view.ctrl:GetBattleTimeInfo(battlePeriod)
    if self.IsTeamSelectBattleTimeModuleEnable and battlePeriod == nil or showBattleTimeData == nil then
      self.member_select_battle_time_content:SetActive(false)
      return
    end
    self:SetShowBattleTime(showBattleTimeData)
  else
    self.member_select_battle_time_content:SetActive(false)
  end
end

function UIBFBaseSelectUserInfo:ShowFilterBattleTime()
  if not self.isPrepTime and self.userInfo and self.userInfo.apply ~= 0 then
    self.member_select_battle_time_content:SetActive(true)
    local showBattleTimeData = self.view.ctrl:GetFilterBattleTimeData()
    self:SetShowBattleTime(showBattleTimeData)
  else
    self.member_select_battle_time_content:SetActive(false)
  end
end

return UIBFBaseSelectUserInfo
