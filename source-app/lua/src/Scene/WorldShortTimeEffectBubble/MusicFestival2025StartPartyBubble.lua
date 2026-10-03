local MusicFestival2025StartPartyBubble = BaseClass("MusicFestival2025StartPartyBubble")
local Localization = CS.GameEntry.Localization

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.tween = self.transform:Find("Transform/Root")
  self.headIcon = self.transform:Find("Transform/Root/HeadIcon"):GetComponent(typeof(CS.UIPlayerHead))
  self.descTxt = self.transform:Find("Transform/Root/Desc"):GetComponent(typeof(CS.SuperTextMesh))
end

local function ComponentDestroy(self)
  self.tween = nil
  self.headIcon = nil
  self.descTxt = nil
end

local function DataDefine(self)
  self.param = nil
  self.curPosition = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
end

local function ReInit(self, param)
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  local data = self.param
  self.headIcon:SetData(data.uid, data.headPic, tonumber(data.headPicVer), false)
  self.descTxt.text = Localization:GetString("activity_concert_1")
  self.tween:DOKill()
  local startPos = Vector3.New(0, -0.1, 0)
  self.tween.localPosition = startPos
  self.tween:DOLocalMoveY(1.9, 2)
end

local function OnLodChange(self, lod)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(lod < 3)
  end
end

MusicFestival2025StartPartyBubble.OnCreate = OnCreate
MusicFestival2025StartPartyBubble.OnDestroy = OnDestroy
MusicFestival2025StartPartyBubble.ComponentDefine = ComponentDefine
MusicFestival2025StartPartyBubble.ComponentDestroy = ComponentDestroy
MusicFestival2025StartPartyBubble.DataDefine = DataDefine
MusicFestival2025StartPartyBubble.DataDestroy = DataDestroy
MusicFestival2025StartPartyBubble.ReInit = ReInit
MusicFestival2025StartPartyBubble.ShowPanel = ShowPanel
MusicFestival2025StartPartyBubble.OnLodChange = OnLodChange
return MusicFestival2025StartPartyBubble
