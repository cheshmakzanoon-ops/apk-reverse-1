local AresMissileSkillTarget = BaseClass("AresMissileSkillTarget")
local Localization = CS.GameEntry.Localization
local SuperTextMesh = typeof(CS.SuperTextMesh)
local mark_path = "mark"
local yujing_path = "ModelGo/Normal/yujing"
local baozha_path = "ModelGo/Normal/baozha"
local zidan_path = "ModelGo/Normal/zidan"
local black_area_path = "ModelGo/range/BlackArea"
local fanwei_path = "ModelGo/range/fanwei"
local fanwei_line_path = "ModelGo/range/fanwei/root/line"
local effect_baozha_path = "ModelGo/Normal/baozha/Eff_daditu_zhanshenfeidan_baozha_02"
local alliance_mark_path = "mark/mark/UIAlliance_mark_sanjiao"

function AresMissileSkillTarget:OnCreate(go)
  if go ~= nil then
    self.gameObject = go
    self.transform = go.transform
  end
  self.sequence = nil
  self.hasBlackArea = nil
end

function AresMissileSkillTarget:OnDestroy()
  self:DestroyObject()
end

function AresMissileSkillTarget:DestroyObject()
  self.black_area = nil
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

function AresMissileSkillTarget:ReInit(uuid, data)
  self.uuid = uuid
  self.data = data
  self.serverId = data.serverId
  self.tilePos = SceneUtils.IndexToTilePos(data.pointId, ForceChangeScene.World)
  self.pointId1 = SceneUtils.TileXYToIndex(self.tilePos.x - data.radius, self.tilePos.y - data.radius, ForceChangeScene.World)
  self.pointId2 = SceneUtils.TileXYToIndex(self.tilePos.x + data.radius, self.tilePos.y - data.radius, ForceChangeScene.World)
  self.pointId3 = SceneUtils.TileXYToIndex(self.tilePos.x - data.radius, self.tilePos.y + data.radius, ForceChangeScene.World)
  self.pointId4 = SceneUtils.TileXYToIndex(self.tilePos.x + data.radius, self.tilePos.y + data.radius, ForceChangeScene.World)
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
      self.yujing = self.gameObject.transform:Find(yujing_path)
      self.baozha = self.gameObject.transform:Find(baozha_path)
      self.effect_baozha = self.gameObject.transform:Find(effect_baozha_path)
      self.zidan = self.gameObject.transform:Find(zidan_path)
      self.black_area = self.gameObject.transform:Find(black_area_path)
      self.fanwei = self.gameObject.transform:Find(fanwei_path)
      self.fanwei_line = self.gameObject.transform:Find(fanwei_line_path)
      self.markImage = self.gameObject.transform:Find(alliance_mark_path):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
      self.NameText.text = self.txt_tip
      self.markImage.sortingOrder = 168
      self.mark.gameObject:SetActive(false)
      self.yujing.gameObject:SetActive(false)
      self.baozha.gameObject:SetActive(false)
      self.zidan.gameObject:SetActive(false)
      self.fanwei.gameObject:SetActive(false)
      local cell_count = 2 * data.radius + 1
      local effect_scale = cell_count / 3
      local bao_zha_scale = data.radius / 10
      self.fanwei_line.gameObject.transform:Set_localScale(effect_scale, effect_scale, 1)
      self.baozha.gameObject.transform:Set_localScale(bao_zha_scale, bao_zha_scale, bao_zha_scale)
      if self.effect_baozha then
        if data.radius > 10 then
          local effect_bao_zha_scale = 10 / data.radius
          self.effect_baozha.gameObject.transform:Set_localScale(effect_bao_zha_scale, effect_bao_zha_scale, effect_bao_zha_scale)
        else
          self.effect_baozha.gameObject.transform:Set_localScale(1, 1, 1)
        end
      end
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

function AresMissileSkillTarget:TryPlayAnim()
  if self.sequence or self.data == nil or self.uuid == nil or self.NameText == nil or self.mark == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.data.activeTime - now
  if remainTime < 500 then
    self.NameText.text = ""
    self.CityLabel.gameObject:SetActive(false)
    self.mark.gameObject:SetActive(false)
    self.yujing.gameObject:SetActive(false)
    self.baozha.gameObject:SetActive(false)
    self.zidan.gameObject:SetActive(false)
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
    self.yujing.gameObject:SetActive(false)
    self.baozha.gameObject:SetActive(false)
    self.zidan.gameObject:SetActive(false)
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
      self.baozha.gameObject:SetActive(true)
    end)
    sequence:AppendInterval(3)
    sequence:AppendCallback(function()
      self:ShowBlackArea()
    end)
    sequence:AppendInterval(4)
    sequence:AppendCallback(function()
      self.fanwei.gameObject:SetActive(false)
      self.baozha.gameObject:SetActive(false)
    end)
    sequence:Play()
    self.sequence = sequence
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.s2_ares_missile_explosion, false)
  elseif remainTime <= 4000 then
    self.yujing.gameObject:SetActive(true)
    self.baozha.gameObject:SetActive(false)
    self.zidan.gameObject:SetActive(false)
    self:HideBlackArea()
    local sequence = DOTween.Sequence()
    sequence:AppendInterval(0.005)
    local fly_time = remainTime * 0.001
    sequence:AppendCallback(function()
      self.zidan.gameObject:SetActive(true)
      self.zidan.transform:DOKill()
      self.zidan.transform:Set_localPosition(0, 99, 0)
      self.zidan.transform:DOLocalMoveY(9, fly_time):SetEase(CS.DG.Tweening.Ease.InQuad)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.s2_ares_missile_explosion, false)
    end)
    sequence:AppendInterval(fly_time)
    sequence:AppendCallback(function()
      self.zidan.transform:DOKill()
      self.zidan.gameObject:SetActive(false)
      self.mark.gameObject:SetActive(false)
      self.CityLabel.gameObject:SetActive(false)
      self.yujing.gameObject:SetActive(false)
      self.baozha.gameObject:SetActive(true)
      local meta = DataCenter.AllianceGovernmentSkillManager:GetAresMissileSkillConfig()
      if meta and meta.skill_vibrate then
        ShakeUtil.TryDoVibration(meta.skill_vibrate)
      end
      if meta and meta.skill_shake then
        ShakeUtil.DoCameraShake(meta.skill_shake)
      end
    end)
    sequence:AppendInterval(3)
    sequence:AppendCallback(function()
      self.fanwei.gameObject:SetActive(false)
      self:ShowBlackArea()
    end)
    sequence:AppendInterval(4)
    sequence:AppendCallback(function()
      self.fanwei.gameObject:SetActive(false)
      self.baozha.gameObject:SetActive(false)
    end)
    sequence:Play()
    self.sequence = sequence
  else
    self.mark.gameObject:SetActive(true)
    self.fanwei.gameObject:SetActive(true)
    self.CityLabel.gameObject:SetActive(true)
  end
end

function AresMissileSkillTarget:Update(theWorld)
  if self.request == nil or theWorld == nil or theWorld.IsOutOfLWAoi == nil then
    self:DestroyObject()
    return
  end
  if theWorld ~= nil and self.data ~= nil and self.uuid ~= nil and self.tilePos ~= nil and self.data.radius then
    local tilePos = SceneUtils.WorldToTile(theWorld.CurTarget)
    if (math.abs(tilePos.x - self.tilePos.x) > self.data.radius or math.abs(tilePos.y - self.tilePos.y) > self.data.radius) and theWorld:IsOutOfLWAoi(self.pointId1, self.serverId) and theWorld:IsOutOfLWAoi(self.pointId2, self.serverId) and theWorld:IsOutOfLWAoi(self.pointId3, self.serverId) and theWorld:IsOutOfLWAoi(self.pointId4, self.serverId) then
      self:DestroyObject()
      DataCenter.AllianceSkillManager:RemoveOneWarEffect(self.uuid)
      return
    end
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

function AresMissileSkillTarget:OnLodChange(lod)
  if self.NameText and not IsNull(self.NameLabel) then
    if 4 < lod then
      self.NameLabel.transform:Set_localScale(0, 0, 0)
    else
      self.NameLabel.transform:Set_localScale(0.5, 0.5, 0.5)
    end
  end
  self.theLod = toInt(lod)
  if IsNotNull(self.black_area) then
    if self.hasBlackArea and self.theLod <= 5 and not self.drawBlackArea then
      self.black_area.gameObject:SetActive(true)
    else
      self.black_area.gameObject:SetActive(false)
    end
  end
end

function AresMissileSkillTarget:ShowBlackArea()
  if self.hasBlackArea or not self.data then
    return
  end
  self.hasBlackArea = true
  if self.drawBlackArea then
    CS.SceneManager.World:ShowBlackArea(self.data.pointId, self.data.radius, self.data.radius)
  elseif IsNotNull(self.black_area) then
    self.black_area.gameObject:SetActive(true)
  end
end

function AresMissileSkillTarget:HideBlackArea()
  if not self.hasBlackArea or not self.data then
    return
  end
  self.hasBlackArea = nil
  if self.drawBlackArea then
    CS.SceneManager.World:HideBlackArea(self.data.pointId, self.data.radius, self.data.radius)
  elseif IsNotNull(self.black_area) then
    self.black_area.gameObject:SetActive(false)
  end
end

return AresMissileSkillTarget
