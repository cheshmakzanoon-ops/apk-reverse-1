local TruckNameLabel = BaseClass("TruckNameLabel")

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.headIcon = self.transform:Find("Transform/Head/icon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.headFrame = self.transform:Find("Transform/Head/frame"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_name = self.transform:Find("Transform/name"):GetComponent(typeof(CS.SuperTextMesh))
end

local function ComponentDestroy(self)
  self.headIcon = nil
  self.headFrame = nil
  self.player_name = nil
end

local function SetName(self, marchInfo)
  if not string.IsNullOrEmpty(marchInfo.ownerName) then
    if not string.IsNullOrEmpty(marchInfo.allianceAbbr) then
      self.player_name.text = "[" .. marchInfo.allianceAbbr .. "] " .. marchInfo.ownerName
    else
      self.player_name.text = marchInfo.ownerName
    end
  else
    self.player_name.text = ""
  end
  local camp = DataCenter.WorldTroopLineManager:GetCamp(marchInfo)
  local nameColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.name)
  self.player_name.color32 = nameColor
end

local function ShowIcon(self, state)
end

local function UpdateDisplayMode(self, marchUuid)
end

TruckNameLabel.OnCreate = OnCreate
TruckNameLabel.OnDestroy = OnDestroy
TruckNameLabel.ComponentDefine = ComponentDefine
TruckNameLabel.ComponentDestroy = ComponentDestroy
TruckNameLabel.SetName = SetName
TruckNameLabel.ShowIcon = ShowIcon
TruckNameLabel.UpdateDisplayMode = UpdateDisplayMode
return TruckNameLabel
