local EpidemicEffect = BaseClass("EpidemicEffect")
local Localization = CS.GameEntry.Localization

function EpidemicEffect:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    self.leave = self.transform:Find("Leave"):GetComponent(typeof(CS.TMPro.TextMeshPro))
    self.arbiter = self.transform:Find("Arbiter")
  end
end

function EpidemicEffect:OnDestroy()
  self.gameObject = nil
  self.transform = nil
  self.leave = nil
  self.bUuid = nil
end

function EpidemicEffect:ReInit(uuid)
  self.bUuid = uuid
  if IsNull(self.gameObject) then
    return
  end
  if self.bUuid == nil then
    self.gameObject:SetActive(false)
    return
  end
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.bUuid)
  if info == nil then
    self.gameObject:SetActive(false)
    return
  end
  cast(info, typeof(CS.BuildPointInfo))
  local bLeave, bArbiter, bFix = false, false, false
  local quarantineLeave = info.quarantineLeave or 0
  if 0 < quarantineLeave then
    bLeave = true
    self.leave.text = Localization:GetString("YiBianJinQu_battle_tips_2")
  else
    local arbiterUid = DataCenter.ActEpidemicZoneManager:GetBattleInfo().arbiterUid
    if info.ownerUid == arbiterUid then
      bArbiter = true
    end
  end
  self.gameObject:SetActive(bLeave or bArbiter or bFix)
  self.leave.gameObject:SetActive(bLeave)
  self.arbiter.gameObject:SetActive(bArbiter)
end

return EpidemicEffect
