local UIS0AllianceBossChallengeRecordView = BaseClass("UIS0AllianceBossChallengeRecordView", UIBaseView)
local base = UIBaseView
local UIS0AllianceBossChallengeRecordMember = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossChallengeRecordMember")
local UIS0AllianceLastClearResult = require("UI.UIS0AllianceBoss.Component.UIS0AllianceLastClearResult")
local ANIM_NAME = {
  "UIS0AllianceBossChallengeRecordPopUp_movein",
  "UIS0AllianceBossChallengeRecordPopUp_idle"
}

function UIS0AllianceBossChallengeRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossChallengeRecordView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossChallengeRecordView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnEmpty = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnEmpty:SetOnClick(function()
    self:OnBtnEmptyClick()
  end)
  self.rawImgMonster = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compMVP = self.viewSkin:AddComponent(self, UIS0AllianceBossChallengeRecordMember, 4)
  self.compStrongest = self.viewSkin:AddComponent(self, UIS0AllianceBossChallengeRecordMember, 5)
  self.compMost = self.viewSkin:AddComponent(self, UIS0AllianceBossChallengeRecordMember, 6)
  self.btnNextR = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnNextR:SetOnClick(function()
    self:OnBtnNextRClick()
  end)
  self.btnPreviousL = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPreviousL:SetOnClick(function()
    self:OnBtnPreviousLClick()
  end)
  self.textStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compS0AllianceBossLastClearResult = self.viewSkin:AddComponent(self, UIS0AllianceLastClearResult, 10)
  self.textPreviousScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textPreviousDemage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.anim = self.viewSkin:AddComponent(self, UIAnimator, 13)
end

function UIS0AllianceBossChallengeRecordView:ComponentDestroy()
  self.viewSkin = nil
  self.btnEmpty = nil
  self.rawImgMonster = nil
  self.btnClose = nil
  self.compMVP = nil
  self.compStrongest = nil
  self.compMost = nil
  self.btnNextR = nil
  self.btnPreviousL = nil
  self.textStage = nil
  self.compS0AllianceBossLastClearResult = nil
  self.textPreviousScore = nil
  self.textPreviousDemage = nil
  self.anim = nil
end

function UIS0AllianceBossChallengeRecordView:DataDefine()
  self.moveInTimer = nil
  self.viewDifficulty = nil
end

function UIS0AllianceBossChallengeRecordView:DataDestroy()
  if self.moveInTimer then
    self.moveInTimer:Stop()
    self.moveInTimer = nil
  end
  self.viewDifficulty = nil
end

function UIS0AllianceBossChallengeRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossGetRecordInfo, self.RefreshView)
end

function UIS0AllianceBossChallengeRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossGetRecordInfo, self.RefreshView)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossChallengeRecordView:InitView()
  DataCenter.S0AllianceBossDataManager:ReqGetRecordInfo()
  local _, duration = self.anim:PlayAnimationReturnTime(ANIM_NAME[1])
  if 0 < duration then
    self.moveInTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.anim:Play(ANIM_NAME[2], 0, 0)
      self.moveInTimer:Stop()
      self.moveInTimer = nil
    end, duration)
  else
    self.anim:Play(ANIM_NAME[2], 0, 0)
  end
end

function UIS0AllianceBossChallengeRecordView:RefreshView()
  local mgr = DataCenter.S0AllianceBossDataManager
  local recordList = mgr:GetRecordList()
  if recordList == nil or table.count(recordList) == 0 then
    Logger.LogError("S0AllianceBoss -- no records")
    return
  end
  local result = {}
  for i, v in pairs(recordList) do
    if v and v.mvpInfo then
      result[i] = v
    end
  end
  self.recordList = result
  local param = self:GetUserData()
  local difficulty = param or mgr.curDifficulty
  if difficulty == nil or difficulty == 0 then
    difficulty = mgr.lastDifficultyLevel
  end
  if difficulty > mgr.recordMaxDifficulty then
    difficulty = mgr.recordMaxDifficulty
  end
  self.difficulty = difficulty
  if self.viewDifficulty == nil then
    self.viewDifficulty = self.difficulty
  end
  self.recordMinDifficulty = mgr.recordMinDifficulty
  self.recordMaxDifficulty = mgr.recordMaxDifficulty
  self.bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  self:RefreshCurView(self.viewDifficulty)
  self:RefreshPageBtnState()
end

function UIS0AllianceBossChallengeRecordView:OnViewIndexChanged(index)
  if index ~= self.viewDifficulty then
    self.viewDifficulty = index
    self:RefreshCurView(index)
    self:RefreshPageBtnState()
  end
end

function UIS0AllianceBossChallengeRecordView:RefreshCurView(index)
  if self.bossDifficultyIds == nil then
    self.bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  end
  local bossId = self.bossDifficultyIds and self.bossDifficultyIds[index]
  if bossId then
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
    if bossTemp then
      self.rawImgMonster:LoadSpriteAuto(bossTemp.record_banner)
    end
  end
  if self.recordList then
    local recordInfo = self.recordList[index]
    if recordInfo == nil then
      Logger.LogError("S0AllianceBoss -- cur difficulty record is nil, difficulty = " .. index)
    else
      self.compMVP:RefreshView(AllianceBossS0RecordMemberFlag.MVP, recordInfo.mvpInfo)
      self.compStrongest:RefreshView(AllianceBossS0RecordMemberFlag.HighestDmg, recordInfo.topDamageInfo)
      self.compMost:RefreshView(AllianceBossS0RecordMemberFlag.MostAlly, recordInfo.maxAttackInfo)
      local passCost = recordInfo.passCost
      if passCost then
        local result = DataCenter.S0AllianceBossDataManager:GetClearResult(passCost)
        if result == AllianceBossS0ClearResult.None then
          Logger.LogError("S0AllianceBoss -- clear result error, result = " .. result)
        else
          self.compS0AllianceBossLastClearResult:Refresh(result)
        end
      else
        Logger.LogError("S0AllianceBoss -- passCost is nil")
      end
      self.textPreviousScore:SetLocalText("s0_alliance_boss_last_stage", recordInfo.difficultyStage)
      local dmgStr = string.GetFormattedStr2(recordInfo.totalDamage)
      self.textPreviousDemage:SetLocalText("s0_alliance_boss_last_damage", dmgStr)
    end
  end
  self.textStage:SetLocalText("s0_alliance_boss_difficulty_level", self.viewDifficulty)
end

function UIS0AllianceBossChallengeRecordView:OnBtnEmptyClick()
  self:OnBtnCloseClick()
end

function UIS0AllianceBossChallengeRecordView:OnBtnCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIS0AllianceBossChallengeRecordView:OnBtnNextRClick()
  if self.viewDifficulty == nil or self.recordList == nil or self.recordMinDifficulty == nil or self.recordMaxDifficulty == nil then
    return
  end
  local curDifficulty = self.viewDifficulty + 1
  if self.viewDifficulty == self.recordMaxDifficulty then
    curDifficulty = self.recordMinDifficulty
  end
  for i = curDifficulty, self.recordMaxDifficulty do
    local record = self.recordList[i]
    if record and record.mvpInfo then
      self:OnViewIndexChanged(i)
      self:RefreshPageBtnState()
      return
    end
  end
end

function UIS0AllianceBossChallengeRecordView:OnBtnPreviousLClick()
  if self.viewDifficulty == nil or self.recordList == nil or self.recordMinDifficulty == nil or self.recordMaxDifficulty == nil then
    return
  end
  local curDifficulty = self.viewDifficulty - 1
  if self.viewDifficulty == self.recordMinDifficulty then
    curDifficulty = self.recordMaxDifficulty
  end
  for i = curDifficulty, self.recordMinDifficulty, -1 do
    local record = self.recordList[i]
    if record and record.mvpInfo then
      self:OnViewIndexChanged(i)
      self:RefreshPageBtnState()
      return
    end
  end
end

function UIS0AllianceBossChallengeRecordView:RefreshPageBtnState()
  self.btnPreviousL:SetActive(self.viewDifficulty ~= self.recordMinDifficulty)
  self.btnNextR:SetActive(self.viewDifficulty ~= self.recordMaxDifficulty)
end

return UIS0AllianceBossChallengeRecordView
