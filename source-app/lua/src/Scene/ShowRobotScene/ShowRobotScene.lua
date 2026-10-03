local ShowRobotScene = BaseClass("ShowRobotScene")
local name_text_path = "XS_wurenji_timeline/VFX_xinshou_liangxiang_wurenji/ziti_da/ziti_01"
local name_text_outline_path = "XS_wurenji_timeline/VFX_xinshou_liangxiang_wurenji/ziti_da/ziti_02"
local des_text_path = "XS_wurenji_timeline/VFX_xinshou_liangxiang_wurenji/liaotiankuang/ziti"
local all_timeline_path = "XS_wurenji_timeline"

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
  self.name_text = self.transform:Find(name_text_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.name_text_outline = self.transform:Find(name_text_outline_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.des_text = self.transform:Find(des_text_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
end

local function ComponentDestroy(self)
  self.name_text = nil
  self.name_text_outline = nil
  self.director = nil
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
  self.name_text.text = param.nameDes
  self.name_text_outline.text = param.nameDes
  self.des_text.text = param.des
end

local function GotoTime(self, time)
  self.director.time = time
end

ShowRobotScene.OnCreate = OnCreate
ShowRobotScene.OnDestroy = OnDestroy
ShowRobotScene.ComponentDefine = ComponentDefine
ShowRobotScene.ComponentDestroy = ComponentDestroy
ShowRobotScene.DataDefine = DataDefine
ShowRobotScene.DataDestroy = DataDestroy
ShowRobotScene.ReInit = ReInit
ShowRobotScene.GotoTime = GotoTime
return ShowRobotScene
