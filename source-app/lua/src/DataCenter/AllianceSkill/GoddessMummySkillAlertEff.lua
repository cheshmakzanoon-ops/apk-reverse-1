local GoddessMummySkillAlertEff = BaseClass("GoddessMummySkillAlertEff")
local Localization = CS.GameEntry.Localization
local SuperTextMesh = typeof(CS.SuperTextMesh)
local mark_path = "mark"
local fanwei_line_path = "ModelGo/range/fanwei/root/line"
local alliance_mark_path = "mark/mark/UIAlliance_mark_sanjiao"

function GoddessMummySkillAlertEff:OnCreate(go)
  if go ~= nil then
    self.gameObject = go
    self.transform = go.transform
  end
  self.sequence = nil
end

function GoddessMummySkillAlertEff:OnDestroy()
  self:DestroyObject()
end

function GoddessMummySkillAlertEff:DestroyObject()
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
end

function GoddessMummySkillAlertEff:ReInit(uuid, data)
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
      local cell_count = 2 * data.radius + 1
      local effect_scale = cell_count / 3
      self.fanwei_line.gameObject.transform:Set_localScale(effect_scale, effect_scale, 1)
    end
  end
  local theWorld = CS.SceneManager.World
  if theWorld ~= nil then
    self:Update(theWorld)
  end
end

function GoddessMummySkillAlertEff:Update(theWorld)
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
    if remainTime < 0 then
      self.NameText.text = ""
    else
      self.NameText.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    end
  end
end

function GoddessMummySkillAlertEff:OnLodChange(lod)
  if self.NameText and not IsNull(self.NameLabel) then
    if 4 < lod then
      self.NameLabel.transform:Set_localScale(0, 0, 0)
    else
      self.NameLabel.transform:Set_localScale(0.5, 0.5, 0.5)
    end
  end
  self.theLod = toInt(lod)
end

return GoddessMummySkillAlertEff
