local OtherBuildBubbleTip = BaseClass("OtherBuildBubbleTip")
local bg_path = "Go/Bg"
local trigger_path = "Go/Trigger"
local icon_path = "Go/Bg/Icon"
local icon_go_path = "Go"
local PositionDelta4 = Vector3.New(0.3, 0, -0.8)
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble"
}

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  if not self.isDefined then
    if self.param.model == UIAssets.BuildStateIcon then
      self.icon_go = self.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
      self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
      self.bg_color = self.transform:Find(bg_path):GetComponent(typeof(CS.SpriteMeshRenderer))
      self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
      self.bg_color:Set_color_a(1.0)
      self.icon_sprite:Set_color_a(1.0)
      
      function self.bg.onPointerClick()
        self:OnClick()
      end
    end
    self.isDefined = true
  end
end

local function ComponentDestroy(self)
  self.bg.onPointerClick = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.isDefined = nil
  self.animationAlreadyShow = false
  self.isClickCd = nil
end

local function DataDestroy(self)
  self.param = nil
  self.isDefined = nil
  self.animationAlreadyShow = nil
  self.isClickCd = nil
end

local function ReInit(self, param)
  self.param = param
  self:ComponentDefine()
  self:ShowBubble()
end

local function ShowBubble(self)
  self.state = nil
  if self.param.bgName ~= nil then
    self.bg_color.gameObject:SetActive(true)
    self.bg_color:LoadSprite(self.param.bgName)
  else
    self.bg_color.gameObject:SetActive(false)
  end
  if self.param.iconName ~= nil then
    self.icon_sprite.gameObject:SetActive(true)
    self.icon_sprite:LoadSprite(self.param.iconName)
  else
    self.icon_sprite.gameObject:SetActive(false)
  end
  if self.param.bgScale ~= nil and self.bg_color ~= nil then
    local v = self.param.bgScale
    self.bg_color.transform:Set_localScale(v.x, v.y, v.z)
  end
  if self.param.iconScale ~= nil and self.icon_sprite ~= nil then
    local v = self.param.iconScale
    self.icon_sprite.transform:Set_localScale(v.x, v.y, v.z)
  end
  if self.icon_go ~= nil and self.animationAlreadyShow == false then
    self.animationAlreadyShow = true
    self.icon_go:Play(AnimName.Enter)
    self.icon_go:PlayQueued(AnimName.Normal)
  end
  if self.param.pointId ~= nil then
    self:UpdatePosition(self.param.pointId)
  end
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    self.index = index
    local modelVec = Vector3.New(0, self.param.modelHeight, 0)
    if self.param.tileX == BuildTilesSize.Two and self.param.buildBubbleType == BuildBubbleType.PastureProduct then
      self:SetPosition(SceneUtils.TileIndexToWorld(index) + PositionDelta4 + modelVec)
    else
      self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + modelVec)
    end
  end
end

local function SetPosition(self, value)
  if type(value) ~= "table" then
    local t = 0
  end
  self.transform:Set_position(value.x, value.y, value.z)
end

local function OnClick(self)
  if not CS.SceneManager.World:CanUseInput() then
    return
  end
  if self.isClickCd then
    return
  end
  if self.param.callback ~= nil then
    self.param.callback(self.param)
    self.isClickCd = true
    self.cdTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.isClickCd = false
      self.cdTimer = nil
    end, 0.5)
  end
end

OtherBuildBubbleTip.OnCreate = OnCreate
OtherBuildBubbleTip.OnDestroy = OnDestroy
OtherBuildBubbleTip.ComponentDefine = ComponentDefine
OtherBuildBubbleTip.ComponentDestroy = ComponentDestroy
OtherBuildBubbleTip.DataDefine = DataDefine
OtherBuildBubbleTip.DataDestroy = DataDestroy
OtherBuildBubbleTip.ReInit = ReInit
OtherBuildBubbleTip.ShowBubble = ShowBubble
OtherBuildBubbleTip.UpdatePosition = UpdatePosition
OtherBuildBubbleTip.SetPosition = SetPosition
OtherBuildBubbleTip.OnClick = OnClick
return OtherBuildBubbleTip
