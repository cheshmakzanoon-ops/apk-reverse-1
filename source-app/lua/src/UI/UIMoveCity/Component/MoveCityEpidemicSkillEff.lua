local MoveCityEpidemicSkillEff = BaseClass("MoveCityEpidemicSkillEff")

function MoveCityEpidemicSkillEff:OnCreate(go)
  self.gameObject = go.gameObject
  self.transform = go.gameObject.transform
  local UnityAnimator = typeof(CS.UnityEngine.Animator)
  local TypeSpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)
  local UnityTextMeshPro = typeof(CS.TMPro.TextMeshPro)
  local TypeLine = typeof(CS.WorldMapEpidemicLine)
  self.animator = self.gameObject:GetComponent(UnityAnimator)
  self.text1 = self.transform:Find("Item1/EffectText1"):GetComponent(UnityTextMeshPro)
  self.icon2 = self.transform:Find("Item2/EffectIcon2"):GetComponent(TypeSpriteRenderer)
  self.text2 = self.transform:Find("Item2/EffectText2"):GetComponent(UnityTextMeshPro)
  self.text3 = self.transform:Find("Item3/EffectText3"):GetComponent(UnityTextMeshPro)
  self.line = self.transform:GetComponent(TypeLine)
  self.playState = 0
end

function MoveCityEpidemicSkillEff:OnDestroy()
  self:CleanTimer()
  self.gameObject = nil
  self.transform = nil
  self.animator = nil
  self.text1 = nil
  self.text2 = nil
  self.icon2 = nil
  self.text3 = nil
  self.playState = 0
end

function MoveCityEpidemicSkillEff:CleanTimer()
  if self.inTimer ~= nil then
    self.inTimer:Stop()
    self.inTimer = nil
  end
end

function MoveCityEpidemicSkillEff:PlayAnimator(bIn)
  if self.animator == nil then
    return
  end
  local animName = bIn and "V_ui_BattleFieldEpidemicSkillTip_in" or "V_ui_BattleFieldEpidemicSkillTip_idle"
  if bIn then
    self.playState = 1
    local duration = 0
    local clips = self.animator.runtimeAnimatorController.animationClips
    for i = 0, clips.Length - 1 do
      if string.endswith(clips[i].name, animName) then
        duration = clips[i].length
        self.animator:Play(animName, 0, 0)
        break
      end
    end
    if 0 < duration then
      self.inTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.inTimer = nil
        self.showIn = true
        self:PlayAnimator()
      end, duration)
    end
  else
    self.playState = 2
    self.animator:Play(animName, 0, 0)
  end
end

function MoveCityEpidemicSkillEff:SetShow(skillId, pointId, fPointId)
  if self.playState == 0 then
    self:PlayAnimator(true)
  elseif self.playState == 1 then
    self:PlayAnimator()
  end
  local template = DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(skillId)
  local iconName, extr, hex, num1, num2, num3, colorType, bInSafe
  if skillId == EpidemicSkillId.Hospital then
    iconName = "wxy_jishashibing_lanbing.png"
    extr = "+"
    num1 = string.formatDecimalDown(template.cureHole / template.effPartTime, 0) .. "/s"
    num2 = string.formatDecimalDown(template.cureSolider / template.effPartTime, 0) .. "/s"
    hex = "5fef87"
    colorType = 1
    bInSafe = false
  else
    iconName = "wxy_jishashibing_hongbing.png"
    extr = "-"
    if template.damageHole ~= nil then
      num1 = string.formatDecimalDown(template.damageHole / template.effPartTime, 0) .. "/s"
    end
    if template.damageHoleBorn ~= nil then
      if num1 == nil then
        num1 = template.damageHoleBorn
      else
        num3 = template.damageHoleBorn
      end
    end
    if template.damageSolider ~= nil then
      num2 = string.formatDecimalDown(template.damageSolider / template.effPartTime, 0) .. "/s"
    end
    hex = "fb7156"
    colorType = 0
    bInSafe = DataCenter.ActEpidemicZoneManager:CheckTargetInSafeArea(fPointId)
  end
  self.icon2:LoadSprite("Assets/Main/Sprites/UI/UILWWorld/" .. iconName)
  local color = UIUtil.HexToColor(hex)
  self.text1.text = num1 ~= 0 and extr .. num1 or num1
  self.text1.color = color
  if num2 ~= nil then
    self.text2.text = num2 ~= 0 and extr .. num2 or num2
    self.text2.color = color
    self.text2.gameObject.transform.parent.gameObject:SetActive(true)
  else
    self.text2.gameObject.transform.parent.gameObject:SetActive(false)
  end
  if num3 ~= nil then
    self.text3.text = num3 ~= 0 and extr .. num3 or num3
    self.text3.color = color
    self.text3.gameObject.transform.parent.gameObject:SetActive(true)
  else
    self.text3.gameObject.transform.parent.gameObject:SetActive(false)
  end
  local ePos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  self.transform.localPosition = ePos
  self.gameObject:SetActive(true)
  if self.line then
    if bInSafe then
      self.line:HideLine()
    else
      local sPos = SceneUtils.TileIndexToWorld(fPointId, ForceChangeScene.World)
      local mPos = {
        x = (sPos.x + ePos.x) / 2,
        y = 10,
        z = (sPos.z + ePos.z) / 2
      }
      self.line:ShowLine(ePos, sPos, mPos, colorType)
    end
  end
end

function MoveCityEpidemicSkillEff:HideSelf()
  if IsNull(self.gameObject) then
    return
  end
  self.playState = 0
  self.gameObject:SetActive(false)
  if self.line then
    self.line:HideLine()
  end
end

return MoveCityEpidemicSkillEff
