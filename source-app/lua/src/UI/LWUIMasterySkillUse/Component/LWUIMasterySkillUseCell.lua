local LWUIMasterySkillUseCell = BaseClass("LWUIMasterySkillUseCell", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUIMasterySkillCell = require("UI.LWUIMastery.Component.LWUIMasterySkillCell")
local learned_content_path = "learnedContent"
local unlearned_content_path = "unlearnedContent"
local use_btn_path = "learnedContent/useBtn"
local btn_txt_path = "learnedContent/useBtn/btnTxt"
local effect_time_txt_path = "learnedContent/effectTimeTxt"
local skill_name_path = "unlearnedContent/skillName"
local passiveLearned_content_path = "passiveLearnedContent"
local passiveSkill_txt_path = "passiveLearnedContent/useBtn/passiveSkillTxt"
local passiveLearned_displayCount_path = "passiveLearnedContent/displayCount"
local passiveLearned_displayCount_txt_path = "passiveLearnedContent/displayCount/displayCountTxt"
local passiveLearned_displayPct_path = "passiveLearnedContent/displayPct"
local passiveLearned_displayPct_image_path = "passiveLearnedContent/displayPct/pctImageBg/pctImage"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rootBtn = self:AddComponent(UIButton, "")
  self.masterySkillCell = self:AddComponent(LWUIMasterySkillCell, "LWUIMasterySkillCell")
  self.learned_content = self:AddComponent(UIBaseContainer, learned_content_path)
  self.unlearned_content = self:AddComponent(UIBaseContainer, unlearned_content_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.btn_txt = self:AddComponent(UIText, btn_txt_path)
  self.effect_time_txt = self:AddComponent(UIText, effect_time_txt_path)
  self.skill_name = self:AddComponent(UIText, skill_name_path)
  self.desc = self:AddComponent(UIText, "desc")
  self.desc:SetActive(false)
  self.use_btn:SetOnClick(function()
    self:OnBtnClickFunc()
  end)
  self.rootBtn:SetOnClick(function()
    self:OnRootBtnClickFunc()
  end)
  self.passiveLearned_content = self:AddComponent(UIBaseContainer, passiveLearned_content_path)
  self.passiveSkill_txt = self:AddComponent(UIText, passiveSkill_txt_path)
  self.passiveLearned_displayCount = self:AddComponent(UIBaseContainer, passiveLearned_displayCount_path)
  self.passiveLearned_displayCount_txt = self:AddComponent(UIText, passiveLearned_displayCount_txt_path)
  self.passiveLearned_displayPct = self:AddComponent(UIBaseContainer, passiveLearned_displayPct_path)
  self.passiveLearned_displayPct_image = self:AddComponent(UIImage, passiveLearned_displayPct_image_path)
  self.passiveSkill_txt:SetLocalText("season_mastery_UI_tips_8")
end

local function ComponentDestroy(self)
  self.rootBtn = nil
  self.masterySkillCell = nil
  self.learned_content = nil
  self.unlearned_content = nil
  self.use_btn = nil
  self.btn_txt = nil
  self.effect_time_txt = nil
  self.skill_name = nil
  self.passiveLearned_content = nil
  self.passiveSkill_txt = nil
  self.passiveLearned_displayCount = nil
  self.passiveLearned_displayCount_txt = nil
  self.passiveLearned_displayPct = nil
  self.passiveLearned_displayPct_image = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
  base.OnRemoveListener(self)
end

local function OnSearchCallBack(self, param)
  if param then
    GoToUtil.MoveToWorldPointAndOpen(param.pointId, nil, param.uuid)
    self.view.ctrl:CloseSelf()
  end
end

local function DataDefine(self)
  self.curState = nil
  self.cdEndTime = 0
  self.effectEndTime = 0
end

local function DataDestroy(self)
  self.showData = nil
  self.curState = nil
  self.cdEndTime = nil
  self.effectEndTime = nil
end

local function SetData(self, showData)
  self.showData = showData
  if IsNotNull(self.gameObject) then
    self:UpdateData()
  end
end

local function UpdateData(self)
  self:SetSkillStateData()
  self:Refresh()
end

local function SetSkillStateData(self)
  if self.showData == nil then
    return
  end
  self.curState = self.showData.skillState
  if self.curState == MasterySkillState.CD then
    self.cdEndTime = self.showData.endTime
    self.effectEndTime = 0
  elseif self.curState == MasterySkillState.Effect then
    self.cdEndTime = 0
    self.effectEndTime = self.showData.endTime
  else
    self.cdEndTime = 0
    self.effectEndTime = 0
  end
  self.desc:SetActive(false)
  if self.showData.skillTemp.active_skills then
    local cur, max = DataCenter.MasteryManager:GetStorageSkillCount(self.showData.skillTemp.id)
    if 1 < max then
      self.desc:SetActive(true)
      self.desc:SetText(string.format("%s/%s", cur, max))
    end
  end
end

local function Refresh(self)
  if self.showData == nil then
    return
  end
  local masteryTemp = self.showData.masteryTemp
  self.masterySkillCell:SetData(masteryTemp.mastery_id)
  self.skill_name:SetLocalText(masteryTemp.name)
  if self.curState ~= MasterySkillState.Locked then
    UIGray.SetGray(self.gameObject.transform, false, true)
    if self.showData.skillTemp.active_skills == false then
      self.learned_content:SetActive(false)
      self.passiveLearned_content:SetActive(true)
      self:RefreshPassiveLearnStateView()
    else
      self.learned_content:SetActive(true)
      self.passiveLearned_content:SetActive(false)
      self:RefreshLearnStateView()
      self:RefreshTimeView()
    end
  else
    UIGray.SetGray(self.gameObject.transform, true, true)
    self.learned_content:SetActive(false)
    self.passiveLearned_content:SetActive(false)
  end
  self.unlearned_content:SetActive(true)
end

local function RefreshLearnStateView(self)
  if self.curState == MasterySkillState.Normal then
    self.use_btn:SetActive(true)
    self.effect_time_txt:SetActive(false)
    UIGray.SetGray(self.use_btn.transform, false, true)
    self.btn_txt:SetLocalText("110046")
  elseif self.curState == MasterySkillState.CD then
    self.use_btn:SetActive(true)
    self.effect_time_txt:SetActive(false)
    UIGray.SetGray(self.use_btn.transform, true, true)
  elseif self.curState == MasterySkillState.Effect then
    self.use_btn:SetActive(false)
    self.effect_time_txt:SetActive(true)
    self.effect_time_txt:SetLocalText(320534)
  end
end

local function RefreshTimeView(self)
  if self.showData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.curState == MasterySkillState.Normal then
  elseif self.curState == MasterySkillState.CD then
    if curTime > self.cdEndTime then
      self.showData.skillState = MasterySkillState.Normal
      self:SetSkillStateData()
      self:RefreshLearnStateView()
    else
      local leftTime = self.cdEndTime - curTime
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.btn_txt:SetText(countDownTimeStr)
    end
  elseif self.curState == MasterySkillState.Effect then
    if curTime > self.effectEndTime then
      self:SetSkillStateData()
      self:RefreshLearnStateView()
    else
      local leftTime = self.effectEndTime - curTime
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.effect_time_txt:SetText(Localization:GetString(320534) .. " " .. countDownTimeStr)
    end
  end
end

local function RefreshPassiveLearnStateView(self)
  local masteryData = DataCenter.MasteryManager:GetData()
  local cur, max = masteryData:GetStorageSkillCount(self.showData.skillTemp.id)
  if self.showData.skillTemp.skill_display_type == 1 then
    self.passiveLearned_displayCount:SetActive(true)
    self.passiveLearned_displayPct:SetActive(false)
    self.passiveLearned_displayCount_txt:SetText(string.format("%d/%d", cur, max))
  elseif self.showData.skillTemp.skill_display_type == 2 then
    self.passiveLearned_displayCount:SetActive(false)
    self.passiveLearned_displayPct:SetActive(true)
    local x = cur / max * 136
    self.passiveLearned_displayPct_image:SetSizeDeltaX(x)
  else
    self.passiveLearned_displayCount:SetActive(false)
    self.passiveLearned_displayPct:SetActive(false)
  end
end

local function OnBtnClickFunc(self)
  if self.showData == nil then
    return
  end
  if self.showData.skillTemp.action == 2 then
    GoToUtil.RequestAllianceMemberBasePoint(AlFindTheNearestMemberType.Normal, "season_mastery_tips_1")
    return
  elseif self.showData.skillTemp.action == 3 then
    GoToUtil.RequestAllianceMemberBasePoint(AlFindTheNearestMemberType.Warrior, "season_mastery_tips_1")
    return
  end
  if self.showData.canntUse then
    UIUtil.ShowTipsId("season_mastery_tips_1")
    return
  end
  if self.curState == MasterySkillState.CD then
    UIUtil.ShowTipsId("100381")
    return
  end
  if self.curState ~= MasterySkillState.Normal then
    return
  end
  local skillTemp = self.showData.skillTemp
  if skillTemp.type == MasterySkill.SeasonResExchange then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryExchangeItem, {anim = true}, skillTemp, self.showData.masteryTemp.mastery_id)
  elseif skillTemp.type == MasterySkill.Whistle then
    SFSNetwork.SendMessage(MsgDefines.FindNearMonster, WorldMonsterSpecialType.S4RunningBoss)
  else
    DataCenter.MasteryManager:SendUseSkillMsg(skillTemp)
  end
end

local function OnRootBtnClickFunc(self)
  if self.showData == nil then
    return
  end
  local param = {}
  param.masteryId = self.showData.masteryTemp.mastery_id
  param.isShowMaxLvl = false
  param.showSkillInfo = false
  param.showShareBtn = true
  param.showTips = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryGetSkill, {anim = true}, param)
end

LWUIMasterySkillUseCell.OnCreate = OnCreate
LWUIMasterySkillUseCell.OnDestroy = OnDestroy
LWUIMasterySkillUseCell.ComponentDefine = ComponentDefine
LWUIMasterySkillUseCell.ComponentDestroy = ComponentDestroy
LWUIMasterySkillUseCell.DataDefine = DataDefine
LWUIMasterySkillUseCell.DataDestroy = DataDestroy
LWUIMasterySkillUseCell.OnAddListener = OnAddListener
LWUIMasterySkillUseCell.OnRemoveListener = OnRemoveListener
LWUIMasterySkillUseCell.OnSearchCallBack = OnSearchCallBack
LWUIMasterySkillUseCell.SetData = SetData
LWUIMasterySkillUseCell.SetSkillStateData = SetSkillStateData
LWUIMasterySkillUseCell.UpdateData = UpdateData
LWUIMasterySkillUseCell.Refresh = Refresh
LWUIMasterySkillUseCell.RefreshTimeView = RefreshTimeView
LWUIMasterySkillUseCell.OnBtnClickFunc = OnBtnClickFunc
LWUIMasterySkillUseCell.OnRootBtnClickFunc = OnRootBtnClickFunc
LWUIMasterySkillUseCell.RefreshLearnStateView = RefreshLearnStateView
LWUIMasterySkillUseCell.RefreshPassiveLearnStateView = RefreshPassiveLearnStateView
return LWUIMasterySkillUseCell
