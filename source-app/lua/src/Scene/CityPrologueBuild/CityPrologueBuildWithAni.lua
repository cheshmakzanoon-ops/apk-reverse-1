local CityPrologueBuildWithAni = BaseClass("CityPrologueBuildWithAni")
local ConfigParse = require("Scene.CityPrologueBuild.CityPrologueBuildParser")
local Resource = CS.GameEntry.Resource
local this_path = "NormalModel"

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
  self.anim = self.transform:Find(""):GetComponent(typeof(CS.SimpleAnimation))
  self.m_parser = ConfigParse.New(self.transform)
  self.animChilds = {}
  local anis = self.transform:Find(this_path):GetComponentsInChildren(typeof(CS.SimpleAnimation))
  if anis then
    for i = 0, anis.Length - 1 do
      self.animChilds[#self.animChilds + 1] = anis[i]
    end
  else
    print("No Animation!!!")
  end
end

local function ComponentDestroy(self)
  self.anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.m_finalCacheState = nil
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
  self:PlayAnimation()
end

local function RefreshState(self)
  if self.anim ~= nil then
    local time = self.anim:GetClipLength(self.param.state)
    if time ~= nil and 0 < time then
      self.anim:Play(self.param.state)
    else
      self.param.state = "Normal"
      RefreshState(self)
    end
  end
end

local function PlaySingleAnimation(self, aniName, queued)
  queued = queued or false
  if self.animChilds == nil then
    return
  end
  for _, v in ipairs(self.animChilds) do
    local time = v:GetClipLength(aniName)
    if time ~= nil and 0 < time then
      if queued then
        v:PlayQueued(aniName)
      else
        v:Play(aniName)
      end
      return
    end
  end
  print("PlaySingleAnimation no aniChilds")
  return
end

local function PlayAnimation(self)
  local aniName = self.param.aniName
  if self.param.modelName ~= "WasteLand_MainBuilding_All" then
    local tmpAniname = ""
    if table.count(tmpAniname) > 0 then
      tmpAniname = aniName[#aniName]
    end
    self:PlayAnimation_Normal(tmpAniname)
  else
    pcall(function()
      if type(aniName) == "string" then
        local tbl = self.m_parser[aniName](self.m_parser)
        self.m_parser:doAction(tbl)
      else
        self:ResetFromCache(aniName)
      end
    end)
  end
end

function CityPrologueBuildWithAni:ResetFromCache(aniName)
  if table.count(aniName) == 0 then
    return
  end
  for _, name in pairs(aniName) do
    local config = self.m_parser[name](self.m_parser)
    self:ParseCache(config)
  end
  self.m_parser:doAction(self.m_finalCacheState)
end

function CityPrologueBuildWithAni:ParseCache(config)
  if self.m_finalCacheState == nil then
    self.m_finalCacheState = config
    return
  end
  self.m_finalCacheState.effect = {}
  local _config_shownode = config.shownode or {}
  local _config_anim = config.anim or {}
  for _, v in pairs(_config_shownode) do
    self:ParseShowNode(v)
  end
  for _, v in pairs(_config_anim) do
    self:ParseAnim(_config_anim)
  end
end

function CityPrologueBuildWithAni:ParseShowNode(shownode_item)
  local shownode = self.m_finalCacheState.shownode
  for _, item in pairs(shownode) do
    if item.node ~= nil and item.node == shownode_item.node then
      item.visible = shownode_item.visible
      return
    end
  end
  shownode[#shownode + 1] = shownode_item
end

function CityPrologueBuildWithAni:ParseAnim(anim_item)
  if self.m_finalCacheState.anim == nil then
    self.m_finalCacheState.anim = {}
  end
  local anim = self.m_finalCacheState.anim
  for _, item in pairs(anim) do
    if item.node ~= nil and item.node == anim_item.node then
      item.name = anim_item.name
      return
    end
  end
  anim[#anim + 1] = anim_item
end

function CityPrologueBuildWithAni:PlayAnimation_Normal(aniName)
  if string.IsNullOrEmpty(aniName) then
    return
  end
  if string.find(aniName, "|") ~= nil then
    local aniArray = string.split(aniName, "|")
    for _, v in ipairs(aniArray) do
      self:PlaySingleAnimation(v)
    end
  else
    local aniArray = string.split(aniName, ";")
    local first = true
    for _, v in ipairs(aniArray) do
      self:PlaySingleAnimation(v, not first)
      first = false
    end
  end
end

CityPrologueBuildWithAni.OnCreate = OnCreate
CityPrologueBuildWithAni.OnDestroy = OnDestroy
CityPrologueBuildWithAni.ComponentDefine = ComponentDefine
CityPrologueBuildWithAni.ComponentDestroy = ComponentDestroy
CityPrologueBuildWithAni.DataDefine = DataDefine
CityPrologueBuildWithAni.DataDestroy = DataDestroy
CityPrologueBuildWithAni.ReInit = ReInit
CityPrologueBuildWithAni.ShowPanel = ShowPanel
CityPrologueBuildWithAni.RefreshState = RefreshState
CityPrologueBuildWithAni.PlayAnimation = PlayAnimation
CityPrologueBuildWithAni.PlaySingleAnimation = PlaySingleAnimation
return CityPrologueBuildWithAni
