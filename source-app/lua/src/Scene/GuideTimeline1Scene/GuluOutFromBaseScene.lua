local GuluOutFromBaseScene = BaseClass("GuluOutFromBaseScene")
local this_path = ""

function GuluOutFromBaseScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function GuluOutFromBaseScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function GuluOutFromBaseScene:ComponentDefine()
  self.director = self.transform:Find(this_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
end

function GuluOutFromBaseScene:ComponentDestroy()
  self.director = nil
  self.gameObject = nil
  self.transform = nil
end

function GuluOutFromBaseScene:DataDefine()
  self.param = nil
end

function GuluOutFromBaseScene:DataDestroy()
  self.param = nil
  self:SetBuildVisible(true)
end

function GuluOutFromBaseScene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
  self:SetBuildVisible(false)
end

function GuluOutFromBaseScene:ChangeParam(param)
  self:ReInit(param)
end

function GuluOutFromBaseScene:GotoTime(time)
  self.director.time = time
end

function GuluOutFromBaseScene:SetBuildVisible(visible)
  if visible then
    DataCenter.NpcTaskBubbleManager:ShowNpc()
  else
    DataCenter.NpcTaskBubbleManager:HideNpc()
  end
end

return GuluOutFromBaseScene
