local LWMainEpidemicZoneSkill = BaseClass("LWMainEpidemicZoneSkill", UIAsyncContainer)
local base = UIAsyncContainer
local actMgr = DataCenter.ActEpidemicZoneManager
local LWMainEpidemicZoneSkillEffect = require("UI.LWMainEpidemicZoneUI.Component.LWMainEpidemicZoneSkillEffect")
local icon_path = "SkillIcon"
local can_use_path = "SkillIcon/SkillCanUse"
local cd_text_path = "SkillIcon/SkillCDText"
local cd_fill_path = "SkillIcon/SkillCDFill"
local name_path = "SkillName"
local slider_bg_path = "SkillSliderBg"
local slider_path = "SkillSliderBg/SkillSlider"
local num_path = "SkillSliderBg/SkillNum"
local active_path = "SkillActive"
local up_path = "NumUp"
local up_text_path = "NumUp/NumUpText"
local add_path = "NumAdd"
local add_text_path = "NumAdd/NumAddText"
local effect_path = "Effect"
local skill_end_path = "SkillEnd"
local num_text1_path = "SkillEnd/NumText1"
local end_icon2_path = "SkillEnd/EndIcon2"
local num_text2_path = "SkillEnd/NumText2"

function LWMainEpidemicZoneSkill:OnCreate()
  base.OnCreate(self)
  self.skillPointShowLimit = LuaEntry.DataConfig:TryGetNum("YiBianJinQu_battle", "k14", 500)
  self.skill = self:AddComponent(UIButton, "")
  self.skill:SetOnClick(function()
    if ActEpidemicUtils.InBattleGuide() then
      ActEpidemicUtils.ContinueBattleGuide()
      return
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleSkill)
  end)
  self.icon = self:AddComponent(UIButton, icon_path)
  self.icon:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    actMgr:TryUseSkill()
    self:CleanFinger()
  end)
  self.can_use = self:AddComponent(UIImage, can_use_path)
  self.cd_text = self:AddComponent(UITextMeshProUGUIEx, cd_text_path)
  self.cd_fill = self:AddComponent(UIImage, cd_fill_path)
  self.slider_bg = self:AddComponent(UIImage, slider_bg_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.num = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.active = self:AddComponent(UIImage, active_path)
  self.up_root = self:AddComponent(UIBaseContainer, up_path)
  self.up_text = self.transform:Find(up_text_path).gameObject
  self.up_text:GameObjectCreatePool()
  self.add_root = self:AddComponent(UIBaseContainer, add_path)
  self.add_text = self.transform:Find(add_text_path).gameObject
  self.add_text:GameObjectCreatePool()
  self.effect = self:AddComponent(LWMainEpidemicZoneSkillEffect, effect_path)
  self.skill_end = self:AddComponent(UIBaseContainer, skill_end_path)
  self.num_text1 = self:AddComponent(UITextMeshProUGUIEx, num_text1_path)
  self.end_icon2 = self:AddComponent(UIImage, end_icon2_path)
  self.num_text2 = self:AddComponent(UITextMeshProUGUIEx, num_text2_path)
end

function LWMainEpidemicZoneSkill:OnDestroy()
  self:CleanFinger()
  self.add_text:GameObjectRecycleAll()
  if self.skillEndDelay then
    self.skillEndDelay:Stop()
    self.skillEndDelay = nil
  end
  self.skill_end:SetActive(false)
  self.skill = nil
  self.icon = nil
  self.can_use = nil
  self.cd_text = nil
  self.cd_fill = nil
  self.slider_bg = nil
  self.name = nil
  self.slider = nil
  self.num = nil
  self.active = nil
  self.up_root = nil
  self.up_text = nil
  self.add_root = nil
  self.add_text = nil
  self.effect = nil
  self.skill_end = nil
  self.num_text1 = nil
  self.end_icon2 = nil
  self.num_text2 = nil
  base.OnDestroy(self)
end

function LWMainEpidemicZoneSkill:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattleSkillUpdate, self.RefreshSkillShow)
  self:AddUIListener(EventId.EpidemicBattleSkillPointChange, self.RefreshSkillPointChange)
  self:AddUIListener(EventId.EpidemicBattleSkillStatistics, self.RefreshSkillEffect)
end

function LWMainEpidemicZoneSkill:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EpidemicBattleSkillUpdate, self.RefreshSkillShow)
  self:RemoveUIListener(EventId.EpidemicBattleSkillPointChange, self.RefreshSkillPointChange)
  self:RemoveUIListener(EventId.EpidemicBattleSkillStatistics, self.RefreshSkillEffect)
end

function LWMainEpidemicZoneSkill:RefreshSkillPointChange(changeValue)
  if changeValue <= 0 then
    return
  end
  self:CheckLastSkillSeq()
  local limit = self.skillPointShowLimit or 0
  self:ShowAnim(changeValue, changeValue < limit, true)
  if changeValue >= limit then
    DataCenter.LWSoundManager:PlaySound(93019, false)
  end
end

function LWMainEpidemicZoneSkill:CheckLastSkillSeq()
  if self._lastSkillSeq and self._lastBasePlay then
    self._lastSkillSeq:Kill()
    self._lastSkillSeq = nil
    self._lastBasePlay()
    self._lastBasePlay = nil
  end
end

local anim_count = 1

function LWMainEpidemicZoneSkill:ShowAnim(value, bSmall, withStay)
  if bSmall and self.epidemicSkillPlaying then
    return
  end
  local parent = bSmall and self.add_root or self.up_root
  local node = bSmall and self.add_text or self.up_text
  if node and parent and parent.transform and value and value ~= 0 then
    local goItem = node:GameObjectSpawn(parent.transform)
    if goItem then
      goItem.name = "anim" .. anim_count
      anim_count = anim_count + 1
      do
        local theItem = parent:AddComponent(UITextMeshProUGUIEx, goItem.name)
        if theItem then
          if 0 < value then
            theItem:SetText("+" .. value)
          else
            theItem:SetText(tostring(value))
          end
          theItem:SetActive(true)
          theItem:SetLocalPositionXYZ(0, 0, 0)
          theItem:SetAlpha(1)
          local icon_img
          
          local function basePlay()
            local sequence = CS.DG.Tweening.DOTween.Sequence()
            sequence:Join(theItem.transform:DOLocalMoveY(100, 1.5))
            sequence:Join(theItem:DOFade(0, 1.5))
            if icon_img ~= nil then
              sequence:Join(icon_img:DOFade(0, 1.5))
            end
            sequence:AppendInterval(1.6)
            sequence:AppendCallback(function()
              if parent ~= nil and not IsNull(parent.gameObject) then
                parent:RemoveComponent(goItem.name, UITextMeshProUGUIEx)
                if parent:GetComponentsCount() == 0 then
                  parent:RemoveAllComponentes()
                end
                goItem:GameObjectRecycle()
              end
            end)
          end
          
          if not bSmall and withStay then
            icon_img = theItem.transform:Find("Icon").gameObject:GetComponent(typeof(CS.UnityEngine.UI.Image))
            icon_img:SetAlpha(1)
            local sequence = CS.DG.Tweening.DOTween.Sequence()
            self._lastSkillSeq = sequence
            self._lastBasePlay = basePlay
            sequence:AppendInterval(2)
            sequence:AppendCallback(function()
              self:CheckLastSkillSeq()
            end)
          else
            basePlay()
          end
        else
          goItem:GameObjectRecycle()
        end
      end
    end
  end
end

function LWMainEpidemicZoneSkill:RefreshSkillShow()
  if self.skill == nil then
    return
  end
  local isObserve = BattleFieldUtil.isObserve
  if isObserve then
    self.curSkillId = 0
    self.skill:SetActive(false)
    return
  end
  local battleInfo = actMgr:GetBattleInfo()
  self.curSkillId = battleInfo.skillId
  local template = actMgr:GetTemplateSkillById(self.curSkillId)
  if template == nil then
    self.curSkillId = 0
    self.skill:SetActive(false)
    return
  end
  self.skill:SetActive(true)
  local eTime = DataCenter.ActEpidemicZoneManager:GetSkillActiveEndTime()
  local skillPlaying = 0 < eTime
  self.epidemicSkillPlaying = skillPlaying
  local bgPath = skillPlaying and "mjc_yibianjinqu_zc_jineng_bg2" or "mjc_yibianjinqu_zc_jineng_bg"
  self.skill:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldEpidemicPath, bgPath))
  if not string.IsNullOrEmpty(template.icon) then
    self.icon:LoadSpriteAsync(template.icon)
  end
  self.name:SetLocalText(template.name)
  self.effect:SetActive(skillPlaying)
  self.active:SetActive(skillPlaying)
  self.slider_bg:SetActive(not skillPlaying)
  if skillPlaying then
    self.can_use:SetActive(false)
    self:RefreshSkillEffect()
    self.cd_text:SetActive(true)
  else
    local curNum = battleInfo.skillPoint or 0
    local maxNum = DataCenter.ActEpidemicZoneManager:FixSkillCost(template)
    local percent = math.min(curNum / maxNum, 1)
    self.slider:SetValue(percent)
    self.num:SetText(curNum .. "/" .. maxNum)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local cdTime = battleInfo.skillCdTime or 0
    local cdFlag = curTime < cdTime
    self.epidemicSkillInCD = cdFlag
    self.cd_text:SetActive(cdFlag)
    self.cd_fill:SetActive(cdFlag)
    local canUse = percent == 1 and not cdFlag
    self.can_use:SetActive(canUse)
    if canUse and not CommonUtil.PlayerPrefsGetBool("_EPIDEMIC_SKILL_GUIDE", false) then
      CommonUtil.PlayerPrefsSetBool("_EPIDEMIC_SKILL_GUIDE", true)
      self.fingerHandle = DataCenter.LWGuideVFXManager:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab", self.OnVfxLoaded, self, 0, GuideVFXPriority.Middle)
    end
  end
  self:Update1000MS()
end

function LWMainEpidemicZoneSkill:RefreshSkillEffect(t)
  local skillId, num1, num2, isEnd = 0, 0, 0, false
  local target
  if t ~= nil then
    skillId = t.skillId
    target = t
    isEnd = t.isEnd
  else
    skillId = self.curSkillId
    target = actMgr:GetBattleInfo()
  end
  num1 = skillId == EpidemicSkillId.Hospital and target.durationRecover or target.durationDamage
  if skillId == EpidemicSkillId.Hospital then
    num2 = target.troopHeal
  elseif skillId == EpidemicSkillId.Judgment then
    num2 = target.arbiterBrokenCount
  else
    num2 = target.troopDamage
  end
  if isEnd then
    if self.skillEndDelay then
      self.skillEndDelay:Stop()
      self.skillEndDelay = nil
    end
    self.skill_end:SetActive(true)
    self.skillEndDelay = TimerManager:GetInstance():DelayInvoke(function()
      if self.skillEndDelay then
        self.skillEndDelay:Stop()
        self.skillEndDelay = nil
      end
      self.skill_end:SetActive(false)
    end, 3)
    local iconName, extr, hex
    if skillId == EpidemicSkillId.Hospital then
      iconName = "wxy_jishashibing_lanbing.png"
      extr = "+"
      hex = "5fef87"
    else
      iconName = skillId == EpidemicSkillId.Judgment and "wxy_jishashibing_hongbing.png" or "wxy_jishashibing_hongbing.png"
      extr = skillId == EpidemicSkillId.Judgment and "" or "-"
      hex = "fb7156"
    end
    self.end_icon2:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldEpidemicPath, iconName))
    self.num_text1:SetText(0 < num1 and extr .. num1 or num1)
    self.num_text1:SetColorHex(hex)
    self.num_text2:SetText(0 < num2 and extr .. num2 or num2)
    self.num_text2:SetColorHex(hex)
  elseif self.effect:GetActive() then
    self.effect:SetShow(skillId, num1, num2)
  end
end

function LWMainEpidemicZoneSkill:CleanFinger()
  if self.fingerHandle ~= nil then
    DataCenter.LWGuideVFXManager:StopCurrent(self.fingerHandle)
    self.fingerHandle = nil
  end
end

function LWMainEpidemicZoneSkill:OnVfxLoaded(handle)
  if handle.isError then
    return
  end
  local transform = handle.gameObject.transform
  transform:SetParent(self.can_use.transform, false)
  transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
end

function LWMainEpidemicZoneSkill:Update1000MS()
  if self.curSkillId == 0 then
    return
  end
  local battleInfo = actMgr:GetBattleInfo()
  if self.curSkillId ~= battleInfo.skillId then
    self:RefreshSkillShow()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local eTime = DataCenter.ActEpidemicZoneManager:GetSkillActiveEndTime()
  local skillPlaying = 0 < eTime
  if self.epidemicSkillPlaying ~= skillPlaying then
    if not skillPlaying then
      actMgr:PrepareBGM(true)
    end
    self:RefreshSkillShow()
    return
  end
  if skillPlaying then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(eTime - curTime)
    self.cd_text:SetText(timeStr)
    return
  end
  local cdTime = battleInfo.skillCdTime or 0
  local cdFlag = curTime < cdTime
  if self.epidemicSkillInCD ~= cdFlag then
    self.epidemicSkillInCD = cdFlag
    self:RefreshSkillShow()
    return
  end
  if cdFlag then
    local template = actMgr:GetTemplateSkillById(self.curSkillId)
    local max = template ~= nil and template.skill_CD or 0
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(cdTime - curTime)
    self.cd_text:SetText(timeStr)
    max = (max or 0) * 1000
    local cur = cdTime - curTime
    self.cd_fill:SetFillAmount(cur / max)
  end
end

return LWMainEpidemicZoneSkill
