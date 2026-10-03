local ShowBusinessPlaneArriveScene = BaseClass("ShowBusinessPlaneArriveScene")
local name_text_path = "XS_huoyunfeiji_timeline/cam03/XS_huoyunfeiji@_camera03/XS_huoyunfeiji_camera/VFX_xinshou_liangxiang_huoyunfeiji/ziti_da/ziti_01"
local name_text_outline_path = "XS_huoyunfeiji_timeline/cam03/XS_huoyunfeiji@_camera03/XS_huoyunfeiji_camera/VFX_xinshou_liangxiang_huoyunfeiji/ziti_da/ziti_02"

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
end

local function ComponentDestroy(self)
  self.name_text = nil
  self.name_text_outline = nil
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
  self.name_text.text = param.des
  self.name_text_outline.text = param.des
end

ShowBusinessPlaneArriveScene.OnCreate = OnCreate
ShowBusinessPlaneArriveScene.OnDestroy = OnDestroy
ShowBusinessPlaneArriveScene.ComponentDefine = ComponentDefine
ShowBusinessPlaneArriveScene.ComponentDestroy = ComponentDestroy
ShowBusinessPlaneArriveScene.DataDefine = DataDefine
ShowBusinessPlaneArriveScene.DataDestroy = DataDestroy
ShowBusinessPlaneArriveScene.ReInit = ReInit
return ShowBusinessPlaneArriveScene
