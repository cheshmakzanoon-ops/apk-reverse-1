local MoveCityAllianceSkillEff = BaseClass("MoveCityAllianceSkillEff")

function MoveCityAllianceSkillEff:OnCreate(go)
  self.gameObject = go.gameObject
  self.transform = go.gameObject.transform
  local TypeLine = typeof(CS.WorldMapEpidemicLine)
  self.line = self.transform:GetComponent(TypeLine)
end

function MoveCityAllianceSkillEff:OnDestroy()
  self.gameObject = nil
  self.transform = nil
  self.line = nil
end

function MoveCityAllianceSkillEff:SetShow(pointInfo, pointId, serverId)
  local ePos = SceneUtils.TileIndexToWorld(pointInfo.pointId, ForceChangeScene.World, pointInfo.serverId)
  self.transform.localPosition = ePos
  self.gameObject:SetActive(true)
  if self.line then
    local sPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
    local mPos = {
      x = (sPos.x + ePos.x) / 2,
      y = 10,
      z = (sPos.z + ePos.z) / 2
    }
    self.line:ShowLine(ePos, sPos, mPos, 0)
  end
end

function MoveCityAllianceSkillEff:HideSelf()
  if IsNull(self.gameObject) then
    return
  end
  self.gameObject:SetActive(false)
  if self.line then
    self.line:HideLine()
  end
end

return MoveCityAllianceSkillEff
