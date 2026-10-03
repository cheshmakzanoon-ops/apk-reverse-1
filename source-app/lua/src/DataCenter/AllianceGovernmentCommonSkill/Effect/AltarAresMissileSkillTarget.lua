local AllianceBaseSkillTarget = require("DataCenter.AllianceSkill.AllianceBaseSkillTarget")
local base = AllianceBaseSkillTarget
local AltarAresMissileSkillTarget = BaseClass("AltarAresMissileSkillTarget", base)
local Localization = CS.GameEntry.Localization
local SuperTextMesh = typeof(CS.SuperTextMesh)
local mark_path = "mark"
local baozha1_path = "ModelGo/Normal/action/baozha1"
local baozha2_path = "ModelGo/Normal/action/baozha2"
local black_area_path = "ModelGo/range/BlackArea"
local fanwei_path = "ModelGo/range/fanwei"
local fanwei_line_path = "ModelGo/range/fanwei/root/line"
local alliance_mark_path = "mark/mark/UIAlliance_mark_sanjiao"

function AltarAresMissileSkillTarget:Init()
  self.sequence = nil
  self.hasBlackArea = nil
  local data = self.data
  if self.gameObject then
    self.mark = self.gameObject.transform:Find(mark_path)
    if self.mark == nil then
      self.black_area = self.gameObject.transform:Find(black_area_path)
      if self.drawBlackArea then
        self.black_area.gameObject:SetActive(false)
      else
        local black_area_scale = 2.25 * (data.radius * 2 + 1)
        self.black_area.gameObject.transform:Set_localScale(black_area_scale, black_area_scale, 1)
      end
      self:ShowBlackArea()
    else
      self.txt_tip = Localization:GetString("season_s2_government_skill_tips11")
      self.CityLabel = self.gameObject.transform:Find("ModelGo/CityLabel")
      if self.CityLabel then
        self.NameLabel = self.gameObject.transform:Find("ModelGo/CityLabel/NameLabel")
        if self.NameLabel ~= nil then
          self.NameText = self.NameLabel.transform:Find("NameText"):GetComponent(SuperTextMesh)
        end
      end
      local fireEffect = self.unityConfig:GetSkillEffectByTags("fire")
      local actionEffect = self.gameObject.transform:Find(fireEffect.Path)
      self.actionGo = actionEffect.gameObject
      self.actionTimeLine = actionEffect:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
      self.actionGo:SetActive(false)
      self.baozha1 = self.gameObject.transform:Find(baozha1_path)
      self.baozha2 = self.gameObject.transform:Find(baozha2_path)
      self.black_area = self.gameObject.transform:Find(black_area_path)
      self.fanwei = self.gameObject.transform:Find(fanwei_path)
      self.fanwei_line = self.gameObject.transform:Find(fanwei_line_path)
      self.markImage = self.gameObject.transform:Find(alliance_mark_path):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
      self.NameText.text = self.txt_tip
      self.markImage.sortingOrder = 168
      self.mark.gameObject:SetActive(false)
      self.fanwei.gameObject:SetActive(false)
      local cell_count = 2 * data.radius + 1
      local effect_scale = cell_count / 3
      local bao_zha_scale = data.radius / 10
      self.fanwei_line.gameObject.transform:Set_localScale(effect_scale, effect_scale, 1)
      self.baozha1.gameObject.transform:Set_localScale(bao_zha_scale, bao_zha_scale, bao_zha_scale)
      self.baozha2.gameObject.transform:Set_localScale(bao_zha_scale, bao_zha_scale, bao_zha_scale)
      self.black_area.gameObject:SetActive(false)
      if not self.drawBlackArea then
        local black_area_scale = 2.25 * cell_count
        self.black_area.gameObject.transform:Set_localScale(black_area_scale, black_area_scale, black_area_scale)
      end
    end
  end
  local inBigWorld = SeasonUtil.InSeasonBigMapMode(self.serverId)
  if self.black_area and inBigWorld then
    local have, meshRenderer = self.black_area.gameObject:TryGetComponent(typeof(CS.UnityEngine.MeshRenderer))
    if have then
      meshRenderer.sortingOrder = 1
    end
  end
  local theWorld = CS.SceneManager.World
  if theWorld ~= nil then
    self:Update(theWorld)
  end
end

function AltarAresMissileSkillTarget:Clear()
  self:DestroyObject()
  self.actionTimeLine = nil
  self.actionGo = nil
end

function AltarAresMissileSkillTarget:DestroyObject()
  if not IsNull(self.sequence) then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self:HideBlackArea()
end

function AltarAresMissileSkillTarget:TryPlayAnim()
  if self.sequence or self.data == nil or self.uuid == nil or self.NameText == nil or self.mark == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.data.activeTime - now
  if remainTime < 500 then
    self.NameText.text = ""
    self.CityLabel.gameObject:SetActive(false)
    self.mark.gameObject:SetActive(false)
    self.actionGo:SetActive(false)
    self.fanwei.gameObject:SetActive(false)
    self:ShowBlackArea()
    local sequence = DOTween.Sequence()
    sequence:AppendInterval(0.01)
    sequence:AppendCallback(function()
      self:ShowBlackArea()
    end)
    sequence:Play()
    self.sequence = sequence
  elseif remainTime <= 1000 then
    self.NameText.text = ""
    self.CityLabel.gameObject:SetActive(false)
    self.mark.gameObject:SetActive(false)
    local fireEffect = self.unityConfig:GetSkillEffectByTags("fire")
    if self:CanPlayEffect(fireEffect) then
      self.actionGo:SetActive(true)
      self.actionTimeLine.time = 2580.001097872808
      self.actionTimeLine:Evaluate()
      self.actionTimeLine:Play()
    end
    self.fanwei.gameObject:SetActive(true)
    self:HideBlackArea()
    local sequence = DOTween.Sequence()
    sequence:AppendInterval(0.01)
    sequence:AppendCallback(function()
      local meta = DataCenter.AllianceGovernmentSkillManager:GetAresMissileSkillConfig()
      if meta and meta.skill_vibrate then
        ShakeUtil.TryDoVibration(meta.skill_vibrate)
      end
      if meta and meta.skill_shake then
        ShakeUtil.DoCameraShake(meta.skill_shake)
      end
    end)
    sequence:AppendInterval(2)
    sequence:AppendCallback(function()
      self.fanwei.gameObject:SetActive(false)
      self:ShowBlackArea()
    end)
    sequence:Play()
    self.sequence = sequence
    DataCenter.LWSoundManager:PlaySound(40002, false)
  elseif remainTime <= 3500 then
    self:HideBlackArea()
    local fireEffect = self.unityConfig:GetSkillEffectByTags("fire")
    if self:CanPlayEffect(fireEffect) then
      self.actionGo:SetActive(true)
      self.actionTimeLine.time = 0
      self.actionTimeLine:Evaluate()
      self.actionTimeLine:Play()
    end
    local sequence = DOTween.Sequence()
    sequence:AppendInterval(0.005)
    sequence:AppendCallback(function()
      DataCenter.LWSoundManager:PlaySound(40002, false)
    end)
    sequence:AppendInterval(remainTime * 0.001)
    sequence:AppendCallback(function()
      self.mark.gameObject:SetActive(false)
      self.CityLabel.gameObject:SetActive(false)
      local meta = DataCenter.AllianceGovernmentSkillManager:GetAresMissileSkillConfig()
      if meta and meta.skill_vibrate then
        ShakeUtil.TryDoVibration(meta.skill_vibrate)
      end
      if meta and meta.skill_shake then
        ShakeUtil.DoCameraShake(meta.skill_shake)
      end
    end)
    sequence:AppendInterval(4)
    sequence:AppendCallback(function()
      self.fanwei.gameObject:SetActive(false)
      self:ShowBlackArea()
    end)
    sequence:Play()
    self.sequence = sequence
  else
    self.mark.gameObject:SetActive(true)
    self.fanwei.gameObject:SetActive(true)
    self.CityLabel.gameObject:SetActive(true)
  end
end

function AltarAresMissileSkillTarget:OnTickSec(theWorld)
  if not self:TickAoi(theWorld) then
    return
  end
  if self.data == nil or self.uuid == nil then
    if self.NameText then
      self.NameText.text = ""
    end
    self:DestroyObject()
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.uuid and self.data and now >= self.data.overTime then
    self:DestroyObject()
    DataCenter.AllianceSkillManager:RemoveOneWarEffect(self.uuid)
    return
  end
  if self.NameText and self.txt_tip and not IsNull(self.NameLabel) then
    local remainTime = self.data.activeTime - now
    self.NameText.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
  end
  if self.sequence == nil then
    self:TryPlayAnim()
  end
end

function AltarAresMissileSkillTarget:LodChange()
  if self.NameText and not IsNull(self.NameLabel) then
    if self.theLod > 4 then
      self.NameLabel.transform:Set_localScale(0, 0, 0)
    else
      self.NameLabel.transform:Set_localScale(0.5, 0.5, 0.5)
    end
  end
  if self.hasBlackArea and self.theLod <= 5 and not self.drawBlackArea then
    self.black_area.gameObject:SetActive(true)
  else
    self.black_area.gameObject:SetActive(false)
  end
end

function AltarAresMissileSkillTarget:ShowBlackArea()
  if self.hasBlackArea or not self.data then
    return
  end
  self.hasBlackArea = true
  if self.drawBlackArea then
    CS.SceneManager.World:ShowBlackArea(self.data.pointId, self.data.radius, self.data.radius)
  else
    self.black_area.gameObject:SetActive(true)
  end
end

function AltarAresMissileSkillTarget:HideBlackArea()
  if not self.hasBlackArea or not self.data then
    return
  end
  self.hasBlackArea = nil
  if self.drawBlackArea then
    CS.SceneManager.World:HideBlackArea(self.data.pointId, self.data.radius, self.data.radius)
  elseif not IsNull(self.black_area) then
    self.black_area.gameObject:SetActive(false)
  end
end

function AltarAresMissileSkillTarget:NeedDisplayMode()
  return true
end

function AltarAresMissileSkillTarget:DoDisplayMode()
  if self.actionGo then
    self.actionGo:SetActive(false)
  end
end

return AltarAresMissileSkillTarget
