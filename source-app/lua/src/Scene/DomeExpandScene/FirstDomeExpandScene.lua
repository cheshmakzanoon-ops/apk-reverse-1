local FirstDomeExpandScene = BaseClass("FirstDomeExpandScene")
local SignalType = {Hide = 1, Show = 2}

function FirstDomeExpandScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function FirstDomeExpandScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function FirstDomeExpandScene:ComponentDefine()
end

function FirstDomeExpandScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function FirstDomeExpandScene:DataDefine()
  DataCenter.GuideManager:SetNoShowUIMain(true)
  CS.SceneManager.World:SetTouchInputControllerEnable(false)
  self.param = nil
  self.index = 1
end

function FirstDomeExpandScene:DataDestroy()
  DataCenter.GuideManager:SetNoShowUIMain(false)
  CS.SceneManager.World:SetTouchInputControllerEnable(true)
  if self.index == SignalType.Show then
    CS.SceneManager.World:ReInitObject()
    DataCenter.LandLockManager:RefreshAll()
  end
  self.param = nil
  self.index = 1
end

function FirstDomeExpandScene:ReInit(param)
  self.index = 1
  self.param = param
  self.transform.position = self.param.pos
  GoToUtil.CloseAllWindows()
end

function FirstDomeExpandScene:ChangeParam(param)
  self:ReInit(param)
end

function FirstDomeExpandScene:GuideTimelineMarkerSignal()
  if self.index == SignalType.Hide then
    CS.SceneManager.World:ClearReInitObject()
    DataCenter.LandLockManager:DestroyAll()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false}, {})
  elseif self.index == SignalType.Show then
    CS.SceneManager.World:ReInitObject()
    DataCenter.LandLockManager:RefreshAll()
  end
  self.index = self.index + 1
end

return FirstDomeExpandScene
