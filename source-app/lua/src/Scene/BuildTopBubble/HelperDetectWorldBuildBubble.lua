local HelperDetectWorldBuildBubble = BaseClass("HelperDetectWorldBuildBubble")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer

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
  self.headIcon = self.transform:Find("Transform/HeadIcon"):GetComponent(typeof(CS.UIPlayerHead))
  self.foreground = self.transform:Find("Transform/Foreground"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
end

local function ComponentDestroy(self)
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
  local data = self.param.helpInfo
  local activityHeadIcon = DataCenter.ActivityListDataManager:GetActivityRadarHeadIcon(false)
  self.headIcon:SetData(data.uid, activityHeadIcon and activityHeadIcon or data.pic, tonumber(data.picVer), false)
  self.headIcon:SetCustomLoadCallback(function()
    if self.headIcon ~= nil and self.headIcon.transform ~= nil and not IsNull(self.headIcon.transform) then
      local icon = self.headIcon.transform:GetComponent(typeof(SpriteRenderer))
      if not IsNull(icon) then
        icon:Set_size(1, 1)
      end
    end
  end)
end

local function OnLodChange(self, lod)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(lod < 3)
  end
end

HelperDetectWorldBuildBubble.OnCreate = OnCreate
HelperDetectWorldBuildBubble.OnDestroy = OnDestroy
HelperDetectWorldBuildBubble.ComponentDefine = ComponentDefine
HelperDetectWorldBuildBubble.ComponentDestroy = ComponentDestroy
HelperDetectWorldBuildBubble.DataDefine = DataDefine
HelperDetectWorldBuildBubble.DataDestroy = DataDestroy
HelperDetectWorldBuildBubble.ReInit = ReInit
HelperDetectWorldBuildBubble.ShowPanel = ShowPanel
HelperDetectWorldBuildBubble.OnLodChange = OnLodChange
return HelperDetectWorldBuildBubble
