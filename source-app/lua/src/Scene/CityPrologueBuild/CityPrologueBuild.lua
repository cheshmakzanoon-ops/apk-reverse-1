local CityPrologueBuild = BaseClass("CityPrologueBuild")
local this_path = ""

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
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.anim = self.transform:Find(this_path):GetComponent(typeof(CS.SimpleAnimation))
end

local function ComponentDestroy(self)
  self.anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  self:RefreshState()
end

local function ChangeState(self, state)
  if self.param.state ~= state then
    self.param.state = state
    self:RefreshState()
    BuildBoxFinishEffectManager:GetInstance():ShowOneEffect(self.param.modelName, self.param.pointId, BuildTilesSize.Two)
  end
end

local function RefreshState(self)
  if self.anim ~= nil then
    local time = self.anim:GetClipLength(self.param.state)
    if time ~= nil and 0 < time then
      self.anim:Play(self.param.state)
    end
  end
end

function CityPrologueBuild:PlayParticle(ani_name)
end

local function PlayAnimation(self)
end

CityPrologueBuild.OnCreate = OnCreate
CityPrologueBuild.OnDestroy = OnDestroy
CityPrologueBuild.ComponentDefine = ComponentDefine
CityPrologueBuild.ComponentDestroy = ComponentDestroy
CityPrologueBuild.DataDefine = DataDefine
CityPrologueBuild.DataDestroy = DataDestroy
CityPrologueBuild.ReInit = ReInit
CityPrologueBuild.ShowPanel = ShowPanel
CityPrologueBuild.ChangeState = ChangeState
CityPrologueBuild.RefreshState = RefreshState
CityPrologueBuild.PlayAnimation = PlayAnimation
return CityPrologueBuild
