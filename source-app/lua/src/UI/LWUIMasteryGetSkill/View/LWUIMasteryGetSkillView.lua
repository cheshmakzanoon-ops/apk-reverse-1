local LWUIMasteryGetSkillView = BaseClass("LWUIMasteryGetSkillView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIMasterySkillCell = require("UI.LWUIMastery.Component.LWUIMasterySkillCell")
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local info_btn_path = "infoBtn"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local title_text_path = "UICommonMiniPopUpTitle/titleText"
local share_btn_path = "root/ShareBtn"
local eff_ui_saiji_jinengdian_zhengfangxing_dianji_path = "Eff_ui_saiji_jinengdian_zhengfangxing_dianji"
local eff_ui_saiji_jinengdian_lingxing_dianji_path = "Eff_ui_saiji_jinengdian_lingxing_dianji"
local max_hint_path = "root/maxHint"
local root_path = "root"
local bgW = 810
local contentW = 750
local startBgH = 700
local startContentH = 380
local bgOffset = 140
local itemH = 74

function LWUIMasteryGetSkillView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  if param then
    self.masteryId = param.masteryId
    self.isShowMaxLvl = param.isShowMaxLvl
    self.showSkillInfo = param.showSkillInfo
    self.showShareBtn = param.showShareBtn
    self.showLv = param.showLv
    self.showTips = param.showTips
  else
    self.masteryId = 0
  end
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIMasteryGetSkillView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIMasteryGetSkillView:ComponentDefine()
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.common_bg_orange = self:AddComponent(UIBaseContainer, "UICommonMiniPopUpTitle/Common_bg_orange")
  self.common_bg_orange1 = self:AddComponent(UIBaseContainer, "UICommonMiniPopUpTitle/Common_bg_orange1")
  self.nameTxt = self:AddComponent(UIText, "nameTxt")
  self.desTxt = self:AddComponent(UILWScienceDetailDesc, "DesTxt")
  self.curLv = self:AddComponent(UIText, "levelContent/curLv")
  self.arrowImg = self:AddComponent(UIBaseContainer, "levelContent/arrowImg")
  self.nextLv = self:AddComponent(UIText, "levelContent/nextLv")
  self.skillValItem1 = self:AddComponent(UIBaseContainer, "SkillValueContent/skillValItem1")
  self.skillValItem2 = self:AddComponent(UIBaseContainer, "SkillValueContent/skillValItem2")
  self.valNumTxt1 = self:AddComponent(UIText, "SkillValueContent/skillValItem1/valNumTxt1")
  self.valNumTxt2 = self:AddComponent(UIText, "SkillValueContent/skillValItem2/valNumTxt2")
  self.changeBtn = self:AddComponent(UIButton, "root/changeBtn")
  self.changeBtn:SetSafeClickMode(true)
  self.changeBtn:SetOnClick(function()
    self:OnLearnBtnClick()
  end)
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetSafeClickMode(true)
  self.share_btn:SetOnClick(function()
    self:ShareSkillBtn()
  end)
  self.masterySkillCell = self:AddComponent(LWUIMasterySkillCell, "LWUIMasterySkillCell")
  self.numCount = self:AddComponent(UIText, "numCount")
  self.timeCount = self:AddComponent(UIText, "numCount/timeCount")
  self.numCount:SetActive(false)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.max_hint = self:AddComponent(UITextMeshProUGUIEx, max_hint_path)
  self.extraLockText = self:AddComponent(UITextMeshProUGUIEx, "extraLockDesc")
  self.eff_ui_saiji_jinengdian_zhengfangxing_dianji = self:AddComponent(UIBaseContainer, eff_ui_saiji_jinengdian_zhengfangxing_dianji_path)
  self.eff_ui_saiji_jinengdian_lingxing_dianji = self:AddComponent(UIBaseContainer, eff_ui_saiji_jinengdian_lingxing_dianji_path)
  self.eff_ui_saiji_jinengdian_zhengfangxing_dianji:SetActive(false)
  self.eff_ui_saiji_jinengdian_lingxing_dianji:SetActive(false)
  self.skillTips = self:AddComponent(UITextMeshProUGUIEx, "SkillValueContent/skillTips")
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.info_btn:SetActive(false)
end

function LWUIMasteryGetSkillView:ComponentDestroy()
  self.return_btn = nil
  self.close_btn = nil
  self.common_bg_orange = nil
  self.common_bg_orange1 = nil
  self.desTxt = nil
  self.nameTxt = nil
  self.curLv = nil
  self.arrowImg = nil
  self.nextLv = nil
  self.skillValItem1 = nil
  self.skillValItem2 = nil
  self.valNumTxt1 = nil
  self.valNumTxt2 = nil
  self.changeBtn = nil
  self.share_btn = nil
  self.masterySkillCell = nil
  self.eff_ui_saiji_jinengdian_zhengfangxing_dianji = nil
  self.eff_ui_saiji_jinengdian_lingxing_dianji = nil
  self.info_btn = nil
  self.max_hint = nil
  self.root = nil
end

function LWUIMasteryGetSkillView:DataDefine()
end

function LWUIMasteryGetSkillView:DataDestroy()
  self.masteryId = nil
  self.isShowMaxLvl = false
  self.showCurrentLvl = false
end

function LWUIMasteryGetSkillView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWMasterySkillUp, self.OnGetSkillUpMsg)
end

function LWUIMasteryGetSkillView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWMasterySkillUp, self.OnGetSkillUpMsg)
  base.OnRemoveListener(self)
end

function LWUIMasteryGetSkillView:ReInit()
  self:Refresh()
end

function LWUIMasteryGetSkillView:Update1000MS()
  if self.endTime then
    local time = self.endTime - UITimeManager:GetInstance():GetServerTime()
    if time < 0 then
      self:Refresh()
    else
      self.timeCount:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
    end
  end
end

function LWUIMasteryGetSkillView:Refresh()
  self.timeCount:SetText("")
  self.numCount:SetActive(false)
  self.info_btn:SetActive(false)
  self.masterySkillCell:SetData(self.masteryId)
  self.endTime = nil
  local skillId = DataCenter.MasteryManager:GetCurSkillIdByMasteryId(self.masteryId)
  local cur, max, ts = DataCenter.MasteryManager:GetStorageSkillCount(skillId)
  if 0 < max then
    self.numCount:SetActive(true)
    self.numCount:SetText(string.format("%s/%s", cur, max))
    if ts then
      if ts >= MANY_YEARS_LATER then
        if cur <= 0 then
          self.timeCount:SetLocalText("season_mastery_s4_tips_10")
        end
      else
        self.endTime = ts
      end
    else
      self.timeCount:SetLocalText("season_mastery_s2_landmine_3")
    end
    self:Update1000MS()
  end
  local skillMeta = DataCenter.MasteryManager:GetSkillTemplate(skillId)
  if skillMeta and skillMeta:IsLandMineSkill() then
    self.info_btn:SetActive(true)
  end
  local shareBtnShow = self.showShareBtn and not self.showLv
  self.share_btn:SetActive(shareBtnShow)
  self.canUpTip = DataCenter.MasteryManager:IsSkillCanUpByMasteryId(self.masteryId)
  local lvOneTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(self.masteryId)
  self.nameTxt:SetLocalText(lvOneTemp.name)
  local desKey = ""
  local numType = EffectLocalType.PositivePercent
  desKey, numType = lvOneTemp:GetDesc()
  local masteryData = DataCenter.MasteryManager:GetData()
  local curLv = masteryData:GetCurLvByMasteryId(self.masteryId)
  local showNextInfo = true
  if self.showLv then
    self.canUpTip = MasterySkillCannotUpResaon.None
    local lvl = lvOneTemp.max_lv
    showNextInfo = self.showLv == 0
    if lvl > self.showLv then
      curLv = self.showLv
    else
      curLv = lvl
      self.isShowMaxLvl = true
      self.canUpTip = MasterySkillCannotUpResaon.MaxLv
      showNextInfo = false
    end
  end
  local showSkillInfo = self.showSkillInfo and 0 < curLv
  local showMaxHint = self.canUpTip == MasterySkillCannotUpResaon.MaxLv
  self.max_hint:SetActive(showMaxHint)
  local showBtn = true
  local showTip = false
  self.skillTips:SetActive(false)
  showTip = false
  
  local function ProcessDesc(desc)
    local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#EF6B00"))
    modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
    return modifiedText
  end
  
  if self.isShowMaxLvl == true or self.canUpTip == MasterySkillCannotUpResaon.MaxLv or showSkillInfo == true then
    local lvl = lvOneTemp.max_lv
    if showSkillInfo then
      lvl = curLv
    end
    local temp = DataCenter.MasteryManager:GetTempByGroupIdAndLevel(self.masteryId, lvl)
    self.curLv:SetLocalText("season_mastery_163", lvl)
    self.arrowImg:SetActive(false)
    self.nextLv:SetText("")
    local curValue = CommonUtil.GetValueWithLocalType(temp.des_value, numType)
    self.valNumTxt1:SetText(curValue)
    self.skillValItem2:SetActive(false)
    showNextInfo = false
    showBtn = false
    local descStr = ""
    if temp.skill == 0 then
      descStr = Localization:GetString(desKey, curValue)
    else
      local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(temp.skill)
      descStr = skillTemp:GetDescStr()
    end
    descStr = ProcessDesc(descStr)
    self.desTxt:SetText(descStr)
  else
    self.skillTips:SetActive(false)
    local targetLv = curLv + 1
    local curLvTemp, nextLvtemp
    if 0 < curLv then
      curLvTemp = DataCenter.MasteryManager:GetTempByGroupIdAndLevel(self.masteryId, curLv)
    end
    nextLvtemp = DataCenter.MasteryManager:GetTempByGroupIdAndLevel(self.masteryId, targetLv)
    self.curLv:SetLocalText("season_mastery_163", curLv)
    self.arrowImg:SetActive(showNextInfo)
    self.nextLv:SetText(showNextInfo and targetLv or "")
    local curValue = CommonUtil.GetValueWithLocalType(curLvTemp and curLvTemp.des_value or 0, numType)
    self.valNumTxt1:SetText(curValue)
    self.valNumTxt2:SetText(CommonUtil.GetValueWithLocalType(nextLvtemp.des_value, numType))
    self.skillValItem2:SetActive(showNextInfo)
    showBtn = not self.showLv
    if self.canUpTip == MasterySkillCannotUpResaon.None or self.showSkillInfo then
      CS.UIGray.SetGray(self.changeBtn.transform, false, true)
    else
      CS.UIGray.SetGray(self.changeBtn.transform, true, true)
    end
    local targetTemp = curLvTemp
    if targetTemp == nil then
      targetTemp = nextLvtemp
    end
    local descStr = ""
    if targetTemp.skill == 0 then
      local targetValue = CommonUtil.GetValueWithLocalType(targetTemp.des_value, numType)
      descStr = Localization:GetString(desKey, targetValue)
    else
      local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(targetTemp.skill)
      descStr = skillTemp:GetDescStr()
    end
    descStr = ProcessDesc(descStr)
    self.desTxt:SetText(descStr)
  end
  self.changeBtn:SetActive(showBtn)
  if self.canUpTip == MasterySkillCannotUpResaon.ExtraLock then
    self.extraLockText:SetLocalText(lvOneTemp.extra_condition_desc[1], lvOneTemp.extra_condition_desc[2])
  else
    self.extraLockText:SetText()
  end
  local bgH = startBgH + itemH
  local contentH = startContentH + itemH
  if showBtn or showMaxHint or shareBtnShow then
  else
    bgH = bgH - bgOffset
  end
  local count = 0
  if showNextInfo then
    count = count + 1
  end
  if showTip then
    count = count + 1
  end
  if self.canUpTip == MasterySkillCannotUpResaon.ExtraLock then
    count = count + 1
  end
  if 0 < count then
    bgH = bgH + count * itemH
    contentH = contentH + count * itemH
  end
  self.common_bg_orange:SetSizeDeltaXY(bgW, bgH)
  self.common_bg_orange1:SetSizeDeltaXY(contentW, contentH)
  self.root:SetSizeDeltaXY(contentW, bgH)
end

function LWUIMasteryGetSkillView:OnGetSkillUpMsg()
  self:Refresh()
  local masteryTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(self.masteryId)
  if masteryTemp then
    local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(masteryTemp.skill)
    if masteryTemp.skill == 0 or skillTemp.active_skills == false then
      self.eff_ui_saiji_jinengdian_zhengfangxing_dianji:SetActive(false)
      self.eff_ui_saiji_jinengdian_zhengfangxing_dianji:SetActive(true)
    else
      self.eff_ui_saiji_jinengdian_lingxing_dianji:SetActive(false)
      self.eff_ui_saiji_jinengdian_lingxing_dianji:SetActive(true)
    end
  end
end

function LWUIMasteryGetSkillView:OnLearnBtnClick()
  if self.canUpTip == MasterySkillCannotUpResaon.None then
    local masteryData = DataCenter.MasteryManager:GetData()
    local curLv = masteryData:GetCurLvByMasteryId(self.masteryId)
    local targetLv = curLv + 1
    local learnList = {
      [1] = {
        group = self.masteryId,
        level = targetLv
      }
    }
    local curPlanIndex = DataCenter.MasteryManager:GetCurPlanIndex()
    SFSNetwork.SendMessage(MsgDefines.MasteryLearn, learnList, curPlanIndex)
  elseif self.showSkillInfo then
    local masteryData = DataCenter.MasteryManager:GetData()
    local masteryId = self.masteryId
    self.ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasterySkillUse)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIMasterySkillPanel) then
      EventManager:GetInstance():Broadcast(EventId.LWMasterySkillJump, masteryId)
    else
      local params = {}
      params.tabType = MasteryTabType.MasterSkillTab
      params.data = {
        homeId = masteryData.home_id,
        jumpMasteryId = masteryId
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, params)
    end
  else
    local tipId = ""
    if self.canUpTip == MasterySkillCannotUpResaon.needHomeLv then
      tipId = "season_tips162"
    elseif self.canUpTip == MasterySkillCannotUpResaon.needSkillLv then
      tipId = "season_tips163"
    elseif self.canUpTip == MasterySkillCannotUpResaon.needCost then
      tipId = "season_tips161"
    elseif self.canUpTip == MasterySkillCannotUpResaon.homeDiff then
      tipId = "season_tips164"
    elseif self.canUpTip == MasterySkillCannotUpResaon.seasonDisable then
      tipId = "season_mastery_tips_11"
    elseif self.canUpTip == MasterySkillCannotUpResaon.DesignerLock then
      tipId = "season_mastery_s2_tips_17"
    elseif self.canUpTip == MasterySkillCannotUpResaon.ExtraLock then
      local lvOneTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(self.masteryId)
      UIUtil.ShowTips(Localization:GetString(lvOneTemp.extra_condition_desc[1], lvOneTemp.extra_condition_desc[2]))
      return
    end
    UIUtil.ShowTipsId(tipId)
  end
end

function LWUIMasteryGetSkillView:ShareSkillBtn()
  local share_param = {}
  local masteryData = DataCenter.MasteryManager:GetData()
  local curLv = masteryData:GetCurLvByMasteryId(self.masteryId)
  share_param.configId = self.masteryId
  share_param.lv = curLv
  share_param.postType = PostType.MasterySkillShare
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function LWUIMasteryGetSkillView:OnClickInfoBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILandmineList, {anim = true}, self.info_btn.transform.position)
end

return LWUIMasteryGetSkillView
