local TreasureDetectRewardIconBubble = BaseClass("TreasureDetectRewardIconBubble")

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
  self.tween = self.transform:Find("Transform/tween")
  self.headIcon = self.transform:Find("Transform/tween/HeadIcon"):GetComponent(typeof(CS.UIPlayerHead))
  self.foreground = self.transform:Find("Transform/tween/HeadIcon/Foreground"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.nameTxt = self.transform:Find("Transform/tween/nameBg/name"):GetComponent(typeof(CS.SuperTextMesh))
end

local function ComponentDestroy(self)
  self.tween = nil
  self.headIcon = nil
  self.foreground = nil
  self.nameTxt = nil
end

local function DataDefine(self)
  self.param = nil
  self.curPosition = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
end

local function ReInit(self, param, bUuid)
  self.param = param
  self.bUuid = bUuid
  self:ShowPanel()
end

local function ShowPanel(self)
  local data = self.param.operator
  self.headIcon:SetData(data.uid, data.headPic, tonumber(data.headPicVer), false)
  local showTxt = string.format("[%s]%s", data.abbr, data.name)
  self.nameTxt.text = showTxt
  self.tween:DOKill()
  local startPos = Vector3.New(0, -2, 0)
  self.tween.localPosition = startPos
  self.tween:DOLocalMoveY(0, 2)
end

local function OnLodChange(self, lod)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(lod < 3)
  end
end

TreasureDetectRewardIconBubble.OnCreate = OnCreate
TreasureDetectRewardIconBubble.OnDestroy = OnDestroy
TreasureDetectRewardIconBubble.ComponentDefine = ComponentDefine
TreasureDetectRewardIconBubble.ComponentDestroy = ComponentDestroy
TreasureDetectRewardIconBubble.DataDefine = DataDefine
TreasureDetectRewardIconBubble.DataDestroy = DataDestroy
TreasureDetectRewardIconBubble.ReInit = ReInit
TreasureDetectRewardIconBubble.ShowPanel = ShowPanel
TreasureDetectRewardIconBubble.OnLodChange = OnLodChange
return TreasureDetectRewardIconBubble
