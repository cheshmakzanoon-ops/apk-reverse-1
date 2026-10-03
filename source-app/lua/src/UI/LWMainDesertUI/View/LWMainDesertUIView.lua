local base = require("UI.BattleFieldBase.BattleFieldBaseView")
local LWMainDesertUIView = BaseClass("LWMainDesertUIView", base)
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local LWMainDesertLogPop = require("UI.LWMainDesertUI.Component.LWMainDesertLogPop")
local LWMainDesertNoticeItem = require("UI.LWMainDesertUI.Component.LWMainDesertNoticeItem")
local logPop_path = "safeArea/topLayer/LogPop"
local notice_item_path = "safeArea/NoticeItem"
local field_hospital_path = "safeArea/bottomLayer/LeftBtnLayout/FieldHospitalContent"
local field_hospital_btn_path = "safeArea/bottomLayer/LeftBtnLayout/FieldHospitalContent/FieldHospitalBtn"
local field_hospital_effect_obj_path = "safeArea/bottomLayer/LeftBtnLayout/FieldHospitalContent/FieldHospitalEffectObj"
local treatment_soldier_content_path = "safeArea/bottomLayer/LeftBtnLayout/FieldHospitalContent/TreatmentSoldierContent"
local soldier_image_path = "safeArea/bottomLayer/LeftBtnLayout/FieldHospitalContent/TreatmentSoldierContent/SoldierImage"
local treatment_soldier_num_text_path = "safeArea/bottomLayer/LeftBtnLayout/FieldHospitalContent/TreatmentSoldierContent/TreatmentSoldierNumText"
local guide_btn_path = "safeArea/guidePanel/GuideBtn"
local guide_panel_path = "safeArea/guidePanel"
local guide_tip1_path = "safeArea/guidePanel/TipRoot1"
local guide_tip2_path = "safeArea/guidePanel/TipRoot2"
local guide_tip3_path = "safeArea/guidePanel/TipRoot3"

function LWMainDesertUIView:GetBfType()
  return BattleFieldType.Desert
end

function LWMainDesertUIView:ComponentDefine()
  self.logPop = self:AddComponent(LWMainDesertLogPop, logPop_path)
  self.noticeItem = self:AddComponent(LWMainDesertNoticeItem, notice_item_path)
  self.noticeItem:CleanSeq()
  local cls = "UI.LWMainDesertUI.Component.LWMainDesertCommandOrder"
  local prefab = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BattleMainOrders.prefab"
  self.commandOrder = self:LoadComponentAsync(cls, prefab, self.safeArea, function()
    self.commandOrder:SetSiblingIndex(2)
    self.commandOrder.gameObject.name = "CommandOrder"
    self.commandOrder:SetOffsetMinXY(0, 0)
    self.commandOrder:SetOffsetMaxXY(0, 0)
    self.commandOrder:SetAnchoredPositionXY(0, 0)
    self.commandOrder:ReInit()
  end)
  if self.textLeft then
    self.textLeft:SetLocalText("Desert_strom_commander_1001")
  end
  self.guide_btn = self:AddComponent(UIButton, guide_btn_path)
  self.guide_panel = self:AddComponent(UIImage, guide_panel_path)
  self.guide_tip1 = self:AddComponent(UICanvasGroup, guide_tip1_path)
  self.guide_tip2 = self:AddComponent(UICanvasGroup, guide_tip2_path)
  self.guide_tip3 = self:AddComponent(UICanvasGroup, guide_tip3_path)
  self.guide_panel:SetActive(false)
  self.guide_btn:SetOnClick(function()
    self:OnGuideNextClick()
  end)
  self.field_hospital = self:AddComponent(UIBaseComponent, field_hospital_path)
  self.field_hospital:SetSiblingIndex(2)
  self.field_hospital_btn = self:AddComponent(UIButton, field_hospital_btn_path)
  self.field_hospital_effect_obj = self:AddComponent(UIBaseContainer, field_hospital_effect_obj_path)
  self.field_hospital_effect_particleSystem = self.field_hospital_effect_obj.gameObject:GetComponent(TypeParticleSystem)
  self.field_hospital_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDesertBattleTreatmentSoldier)
  end)
  self.treatment_soldier_content = self:AddComponent(UIBaseComponent, treatment_soldier_content_path)
  self.soldier_image = self:AddComponent(UIImage, soldier_image_path)
  self.treatment_soldier_num_text = self:AddComponent(UIText, treatment_soldier_num_text_path)
  self.treatment_soldier_content:SetActive(false)
  self:RefreshTreatmentSoldierGreenEffect()
  CS.WorldScene.BeginBattlefieldSample("BF_Desert")
end

function LWMainDesertUIView:ComponentDestroy()
  self:StopTreatmentSoldierSequence()
  self.field_hospital_effect_obj = nil
  self.field_hospital_effect_particleSystem = nil
  self.field_hospital_btn = nil
  self.treatment_soldier_content = nil
  self.soldier_image = nil
  self.treatment_soldier_num_text = nil
end

function LWMainDesertUIView:OnBattleInfoReady()
  local testFlag = BattleFieldUtil.BTestJump()
  if not testFlag then
    self.battle_info:SetMain(true)
  end
  self:CheckGuide()
end

function LWMainDesertUIView:OnMiniMapReady()
  self:CheckGuide()
end

function LWMainDesertUIView:DoBtnGo()
  if not self:IsCurWatchIdx() then
    local myGroup = DataCenter.ActDragonManager:GetMyGroup()
    local groupIdx = myGroup ~= nil and myGroup.group or 0
    local logStr = string.format("[LWMainDesertUIView] DoBtnGo click not IsCurWatchIdx, groupIdx=%s | observeIdx=%s", groupIdx, BattleFieldUtil.ObserveIdx())
    Logger.LogWarning(logStr)
  end
  DataCenter.ActDragonManager:TryEnterBattlefield(0)
end

function LWMainDesertUIView:DoBtnLeft()
  if self.commandOrder and self.commandOrder:AsyncLoadDone() then
    self.commandOrder:OnShowChange()
  end
end

function LWMainDesertUIView:IsCurWatchIdx()
  local myGroup = DataCenter.ActDragonManager:GetMyGroup()
  if myGroup and myGroup.group == BattleFieldUtil.ObserveIdx() then
    return true
  end
  return false
end

function LWMainDesertUIView:CheckEnterShow()
  if BattleFieldUtil.isObserve then
    return
  end
  local time = CommonUtil.PlayerPrefsGetString(TipEnterDragonWorld, "")
  if not string.IsNullOrEmpty(time) then
    self:CheckGuide()
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleEnterTip, {anim = true}, BindCallback(self, self.CheckGuide))
end

function LWMainDesertUIView:GetEndSec()
  local groupInfo = DataCenter.ActDragonManager:GetCurGroup()
  local timeInfo = groupInfo ~= nil and groupInfo.timeInfo or nil
  local endTime = timeInfo ~= nil and timeInfo.endTime or 0
  local secs, delta = math.modf(endTime / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  return secs
end

function LWMainDesertUIView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonGuideStart, self.OnDragonGuideStart)
  self:AddUIListener(EventId.GetDesertBattleTreatmentSoldierNum, self.RefreshTreatmentSoldierCountShow)
end

function LWMainDesertUIView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonGuideStart, self.OnDragonGuideStart)
  self:RemoveUIListener(EventId.GetDesertBattleTreatmentSoldierNum, self.RefreshTreatmentSoldierCountShow)
  base.OnRemoveListener(self)
end

function LWMainDesertUIView:CheckGuide()
  local topDone = self.battle_info and self.battle_info:AsyncLoadDone()
  local miniMapDone = self.mini_map and self.mini_map:AsyncLoadDone()
  if not topDone or not miniMapDone then
    return
  end
  local key = "DesertWelcome_" .. LuaEntry.Player.uid
  local time = Setting:GetString(key, "")
  local todayOpened = Config.IsPC()
  if time ~= nil and time ~= "" then
    todayOpened = true
  end
  if not todayOpened then
    Setting:SetString(key, tostring(UITimeManager:GetInstance():GetServerSeconds()))
    self.guide_panel:SetActive(true)
    self.guide_panel:SetLocalPositionXYZ(0, 0, 0)
    self.guide_panel:SetSizeDeltaXY(2000, 3000)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertWelcome)
  end
end

function LWMainDesertUIView:OnDragonGuideStart()
  if BattleFieldUtil.isObserve then
    return
  end
  self.guide_tip1:SetAlpha(0)
  self.guide_tip1:SetActive(true)
  self.inGuideAnim = true
  self.theGuideIndex = 0
  DOTween.Sequence():Append(self.guide_panel.transform:DOMove(self.battle_info.transform.position + Vector3.New(0, -49, 0), 0.7)):Join(self.guide_panel.transform:DOSizeDelta(Vector2.New(750, 180), 0.7)):AppendInterval(0.1):Append(self.guide_tip1:FadeIn(0.3)):AppendCallback(function()
    self.theGuideIndex = 1
    self.inGuideAnim = false
  end)
end

function LWMainDesertUIView:OnGuideNextClick()
  if self.inGuideAnim then
    return
  end
  if self.theGuideIndex == 1 then
    self.inGuideAnim = true
    self.guide_tip1:FadeOut(0.1)
    self.guide_tip2:SetAlpha(0)
    self.guide_tip2:SetActive(true)
    DOTween.Sequence():Append(self.guide_panel.transform:DOMove(self.mini_map.bgBtn.transform.position, 0.7)):Join(self.guide_panel.transform:DOSizeDelta(Vector2.New(250, 110), 0.7)):AppendInterval(0.1):Append(self.guide_tip2:FadeIn(0.3)):AppendCallback(function()
      self.guide_tip1:SetActive(false)
      self.theGuideIndex = 2
      self.inGuideAnim = false
    end)
  elseif self.theGuideIndex == 2 then
    self.inGuideAnim = true
    self.guide_tip2:FadeOut(0.1)
    self.guide_tip3:SetAlpha(0)
    self.guide_tip3:SetActive(true)
    DOTween.Sequence():Append(self.guide_panel.transform:DOMove(self.btnHospital.transform.position, 0.7)):Join(self.guide_panel.transform:DOSizeDelta(Vector2.New(140, 140), 0.7)):AppendInterval(0.1):Append(self.guide_tip3:FadeIn(0.3)):AppendCallback(function()
      self.guide_tip2:SetActive(false)
      self.theGuideIndex = 3
      self.inGuideAnim = false
    end)
  else
    self.inGuideAnim = false
    self.guide_tip3:SetActive(false)
    self.guide_panel:SetActive(false)
  end
end

function LWMainDesertUIView:RefreshTreatmentSoldierGreenEffect()
  local showGlowGreenCondition = DataCenter.DragonBuildTemplateManager:GetItemValue("k16")
  local treatmentFinishSoldierCount = DataCenter.ActDragonManager:GetTreatmentFinishSoldierNum()
  if showGlowGreenCondition <= treatmentFinishSoldierCount then
    self.field_hospital_effect_particleSystem:Play()
    self.field_hospital_effect_obj:SetActive(true)
  else
    self.field_hospital_effect_particleSystem:Stop()
    self.field_hospital_effect_obj:SetActive(false)
  end
end

function LWMainDesertUIView:RefreshTreatmentSoldierCountShow(addNum)
  base.OnHospitalUpdate(self)
  self:StopTreatmentSoldierSequence()
  self:RefreshTreatmentSoldierGreenEffect()
  if 0 < addNum then
    self.treatment_soldier_content:SetActive(true)
    self.treatment_soldier_num_text:SetText("+" .. tostring(addNum))
    self.treatment_soldier_num_text:SetAlpha(1)
    self.treatment_soldier_num_text:SetLocalPositionXYZ(0, 15, 0)
    self.treatment_soldier_num_text:SetLocalScaleXYZ(1, 1, 1)
    self.soldier_image:SetAlpha(1)
    self.treatmentSoldierSequence = DOTween.Sequence()
    self.treatmentSoldierSequence:Append(self.treatment_soldier_num_text:DOFade(0, 1))
    self.treatmentSoldierSequence:Join(self.treatment_soldier_num_text.transform:DOLocalMoveY(50, 1))
    self.treatmentSoldierSequence:Join(self.treatment_soldier_num_text.transform:DOScale(Vector3.New(1.1, 1.1, 1.1), 1))
    self.treatmentSoldierSequence:Join(self.soldier_image:DOFade(0, 1.2))
    self.treatmentSoldierSequence:OnComplete(function()
      self.treatment_soldier_content:SetActive(false)
    end)
  elseif self.treatment_soldier_content:GetActive() then
    self.treatment_soldier_content:SetActive(false)
  end
end

function LWMainDesertUIView:StopTreatmentSoldierSequence()
  if self.treatmentSoldierSequence ~= nil then
    self.treatmentSoldierSequence:Kill()
    self.treatmentSoldierSequence = nil
  end
end

return LWMainDesertUIView
