local GuideTimeline2Scene = BaseClass("GuideTimeline2Scene")
local this_path = ""

function GuideTimeline2Scene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function GuideTimeline2Scene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function GuideTimeline2Scene:ComponentDefine()
  self.director = self.transform:Find(this_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
end

function GuideTimeline2Scene:ComponentDestroy()
  self.director = nil
  self.gameObject = nil
  self.transform = nil
end

function GuideTimeline2Scene:DataDefine()
  self.param = nil
end

function GuideTimeline2Scene:DataDestroy()
  self.param = nil
  self:SetPlayerVisible(true)
end

function GuideTimeline2Scene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
  self:SetPlayerVisible(false)
  self:SetTriggerVisible(self.param.hideTriggerList)
end

function GuideTimeline2Scene:ChangeParam(param)
  self:ReInit(param)
end

function GuideTimeline2Scene:GotoTime(time)
  self.director.time = time
end

function GuideTimeline2Scene:SetPlayerVisible(visible)
  local player = DataCenter.BattleLevel:GetPlayer()
  if player ~= nil then
    player:SetVisible(visible)
  end
end

function GuideTimeline2Scene:SetTriggerVisible(hideTriggerList)
  if hideTriggerList ~= nil then
    for k, v in ipairs(hideTriggerList) do
      DataCenter.BattleLevel:SetOneTriggerVisible(v, false)
    end
  end
end

return GuideTimeline2Scene
