local AllianceBaseSkillTarget = require("DataCenter.AllianceSkill.AllianceBaseSkillTarget")
local base = AllianceBaseSkillTarget
local AltarGoddessMummySkillTarget = BaseClass("AltarGoddessMummySkillTarget", AllianceBaseSkillTarget)
local Localization = CS.GameEntry.Localization
local SuperTextMesh = typeof(CS.SuperTextMesh)
local mark_path = "mark"
local fanwei_line_path = "ModelGo/range/fanwei/root/line"
local alliance_mark_path = "mark/mark/UIAlliance_mark_sanjiao"

function AltarGoddessMummySkillTarget:Init()
  self.sequence = nil
  if self.gameObject then
    self.mark = self.gameObject.transform:Find(mark_path)
    if self.mark then
      self.txt_tip = Localization:GetString("season_s3_government_skill_tips11")
      self.CityLabel = self.gameObject.transform:Find("ModelGo/CityLabel")
      if self.CityLabel then
        self.NameLabel = self.gameObject.transform:Find("ModelGo/CityLabel/NameLabel")
        if self.NameLabel ~= nil then
          self.NameText = self.NameLabel.transform:Find("NameText"):GetComponent(SuperTextMesh)
        end
      end
      self.fanwei_line = self.gameObject.transform:Find(fanwei_line_path)
      self.markImage = self.gameObject.transform:Find(alliance_mark_path):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
      self.NameText.text = self.txt_tip
      self.markImage.sortingOrder = 168
      local cell_count = 2 * self.data.radius + 1
      local effect_scale = cell_count / 3
      self.fanwei_line.gameObject.transform:Set_localScale(effect_scale, effect_scale, 1)
    end
  end
  local theWorld = CS.SceneManager.World
  if theWorld ~= nil then
    self:Update(theWorld)
  end
  local startPointId = self.senderPointId
  local endPointId = self:GetPointId()
  local worldStartPos = SceneUtils.TileIndexToWorld(startPointId, ForceChangeScene.World, self.serverId)
  local endStartPos = SceneUtils.TileIndexToWorld(endPointId, ForceChangeScene.World, self.serverId)
  local distance = Vector3.Distance(worldStartPos, endStartPos)
  local speed = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), self.skillConfig.skill_para7, "speed")
  self.troopTime = distance / (speed * TileSize) * 1000
  self.allTime = self.skillConfig.pre_time * 1000
  self.attackInv = self.skillConfig.skill_para6 * 1000
  self.activeFx = self.allTime - self.skillConfig.during_time * 1000
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.data.activeTime - now
  local firstAttackTime = self.attackInv + self.troopTime - 1000
  if firstAttackTime < self.allTime - remainTime then
    self.needToRefreshAttack = false
    self:CacAttackEffectTimes()
  else
    self.needToRefreshAttack = true
  end
end

function AltarGoddessMummySkillTarget:Clear()
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
  if self.setNextTimer then
    self.setNextTimer:Stop()
    self.setNextTimer = nil
  end
end

function AltarGoddessMummySkillTarget:OnTickSec(theWorld)
  if not self:TickAoi(theWorld) then
    return
  end
  if self.data == nil or self.uuid == nil then
    if self.NameText then
      self.NameText.text = ""
    end
    self:Clear()
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.uuid and self.data and now >= self.data.overTime then
    self:Clear()
    DataCenter.AllianceSkillManager:RemoveOneWarEffect(self.uuid)
    return
  end
  if self.needToRefreshAttack then
    local remainTime = self.data.activeTime - now
    if self.allTime - remainTime > self.attackInv + self.troopTime - 1000 then
      self.needToRefreshAttack = false
      self:CacAttackEffectTimes()
    end
  end
  if self.NameText and self.txt_tip and not IsNull(self.NameLabel) then
    local remainTime = self.data.activeTime - now
    if remainTime < 0 then
      self.NameText.text = ""
    else
      self.NameText.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    end
  end
end

function AltarGoddessMummySkillTarget:LodChange()
  if self.NameText and not IsNull(self.NameLabel) then
    if self.theLod > 4 then
      self.NameLabel.transform:Set_localScale(0, 0, 0)
    else
      self.NameLabel.transform:Set_localScale(0.5, 0.5, 0.5)
    end
  end
end

function AltarGoddessMummySkillTarget:CacAttackEffectTimes()
  self.attackTimes = {}
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.data.activeTime - now
  for attackIndex = -50, 50 do
    local attackTime = self.data.activeTime - self.activeFx + self.attackInv * attackIndex + self.troopTime
    if self.allTime - remainTime > self.attackInv - 1000 and now < attackTime and now < self.data.activeTime and 0 < attackTime then
      table.insert(self.attackTimes, attackTime)
    end
  end
  if 0 < table.count(self.attackTimes) then
    for index, v in ipairs(self.attackTimes) do
      self:SetTimeAction("attack" .. index, v, BindCallback(self, self.PlayerAttackEffect))
    end
  end
end

function AltarGoddessMummySkillTarget:PlayerAttackEffect()
  local flyEndEffect = self.unityConfig:GetSkillEffectByTags("flyEnd")
  self:PlaySkillEffBySelfPoint(flyEndEffect.Path, flyEndEffect.Duration, self.effectGo or nil, true, true, nil, flyEndEffect)
end

function AltarGoddessMummySkillTarget:NeedDisplayMode()
  return true
end

return AltarGoddessMummySkillTarget
