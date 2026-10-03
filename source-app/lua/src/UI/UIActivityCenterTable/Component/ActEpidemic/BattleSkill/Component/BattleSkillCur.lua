local base = UIBaseContainer
local BattleSkillCur = BaseClass("BattleSkillCur", base)
local BattleSkillCell = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattleSkillCell")
local actMgr = DataCenter.ActEpidemicZoneManager
local Localization = CS.GameEntry.Localization
local cell_path = "BattleSkillCell"
local preview_path = "Preview"
local use_btn_path = "UseBtn"
local text_path = "UseBtn/Text"
local active_path = "Active"
local remain_text_path = "Active/RemainText"
local tip_text_path = "TipText"

function BattleSkillCur:OnCreate()
  base.OnCreate(self)
  self.endTime = 0
  self.template = nil
  self.cell = self:AddComponent(BattleSkillCell, cell_path)
  self.preview = self:AddComponent(UIRawImage, preview_path)
  self.preview_btn = self:AddComponent(UIButton, preview_path)
  self.preview_btn:SetOnClick(BindCallback(self, self.OnClickBtnPreview))
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(BindCallback(self, self.OnClickBtnUse))
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.active = self:AddComponent(UIBaseContainer, active_path)
  self.remain_text = self:AddComponent(UITextMeshProUGUIEx, remain_text_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  local bLord = DataCenter.ActEpidemicZoneManager:GetCurRole() == EpidemicZoneRole.Lord
  local types = bLord and {
    EpidemicZoneSkillType.LordActive
  } or {
    EpidemicZoneSkillType.FarmerActive
  }
  local dataList = DataCenter.ActEpidemicZoneManager:GetTemplateSkillIds(types)
  self.skillListSize = #dataList
end

function BattleSkillCur:OnDestroy()
  self.preview = nil
  self.preview_btn = nil
  self.use_btn = nil
  self.text = nil
  self.active = nil
  self.remain_text = nil
  self.tip_text = nil
  self.endTime = 0
  self.template = nil
  base.OnDestroy(self)
end

function BattleSkillCur:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattleSkillUpdate, self.UpdateData)
end

function BattleSkillCur:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicBattleSkillUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function BattleSkillCur:UpdateData()
  local battleInfo = actMgr:GetBattleInfo()
  local skillId = battleInfo.skillId
  self.skillId = skillId
  if skillId == 0 then
    return
  end
  self.cell:UpdateData(skillId)
  self.template = actMgr:GetTemplateSkillById(skillId)
  local bFightGod = DataCenter.ActEpidemicZoneManager:BCurSelfArbiter()
  if bFightGod then
    self.tip_text:SetLocalText("YiBianJinQu_skill_detail_tips_3")
  else
    self.tip_text:SetLocalText("YiBianJinQu_skill_detail_tips_2", self.skillListSize)
  end
  self.preview:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicTexture2Path, self.template.example_preview))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local sTime = battleInfo.activeStartTime or 0
  local eTime = battleInfo.activeEndTime or 0
  if curTime >= sTime and curTime < eTime then
    self.use_btn:SetActive(false)
    self.active:SetActive(true)
    self.endTime = eTime
    self:Update1000MS()
  else
    self.use_btn:SetActive(true)
    self.active:SetActive(false)
    local endTime = battleInfo.skillCdTime
    if curTime < endTime then
      self.endTime = endTime
      CS.UIGray.SetGray(self.use_btn.transform, true, false)
      self:Update1000MS()
    else
      self.endTime = 0
      CS.UIGray.SetGray(self.use_btn.transform, false, true)
      self.text:SetLocalText(450018)
    end
  end
end

function BattleSkillCur:OnClickBtnPreview()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  actMgr:PreviewSkill(self.skillId)
end

function BattleSkillCur:OnClickBtnUse()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  actMgr:TryUseSkill()
  self.view.ctrl:CloseSelf()
end

function BattleSkillCur:Update1000MS()
  if self.endTime and self.endTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = math.max(self.endTime - curTime, 0)
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    if self.active:GetActive() then
      self.remain_text:SetText(string.format("%s: %s", Localization:GetString("YiBianJinQu_battle_tips_6"), timeStr))
    else
      self.text:SetLocalText("120397", timeStr)
      if remainTime == 0 then
        self:UpdateData()
      end
    end
  end
end

return BattleSkillCur
