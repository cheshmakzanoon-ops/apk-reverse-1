local GuideTimeline3Scene = BaseClass("GuideTimeline3Scene")

function GuideTimeline3Scene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function GuideTimeline3Scene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function GuideTimeline3Scene:ComponentDefine()
end

function GuideTimeline3Scene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function GuideTimeline3Scene:DataDefine()
  self.param = nil
end

function GuideTimeline3Scene:DataDestroy()
  self.param = nil
end

function GuideTimeline3Scene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
end

function GuideTimeline3Scene:ChangeParam(param)
  self:ReInit(param)
end

function GuideTimeline3Scene:GotoTime(time)
end

return GuideTimeline3Scene
