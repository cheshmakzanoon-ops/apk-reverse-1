local SecondMigrateScene = BaseClass("SecondMigrateScene")
local all_timeline_path = "XS_yimin_timeline_master_mov/XS_yimin_timelin_mov"
local timeline_go_path = "XS_yimin_timeline_master_mov"
local StartTime = 8.0

local function OnCreate(self, go)
  if go ~= nil then
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
  self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
  self.timeline_go = self.transform:Find(timeline_go_path)
end

local function ComponentDestroy(self)
  self.director = nil
  self.timeline_go = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.transform.position = self.param.pos
  self.director.time = StartTime
  self.director:Play()
end

SecondMigrateScene.OnCreate = OnCreate
SecondMigrateScene.OnDestroy = OnDestroy
SecondMigrateScene.ComponentDefine = ComponentDefine
SecondMigrateScene.ComponentDestroy = ComponentDestroy
SecondMigrateScene.DataDefine = DataDefine
SecondMigrateScene.DataDestroy = DataDestroy
SecondMigrateScene.ReInit = ReInit
return SecondMigrateScene
