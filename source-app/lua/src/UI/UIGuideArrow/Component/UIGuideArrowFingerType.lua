local UIGuideArrowFingerType = BaseClass("UIGuideArrowFingerType", UIBaseContainer)
local base = UIBaseContainer

function UIGuideArrowFingerType:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGuideArrowFingerType:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGuideArrowFingerType:OnEnable()
  base.OnEnable(self)
end

function UIGuideArrowFingerType:OnDisable()
  base.OnDisable(self)
end

function UIGuideArrowFingerType:ComponentDefine()
  self.finger_anim = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
end

function UIGuideArrowFingerType:ComponentDestroy()
  self.finger_anim = nil
end

function UIGuideArrowFingerType:DataDefine()
  self.param = {}
end

function UIGuideArrowFingerType:DataDestroy()
  self.param = nil
end

function UIGuideArrowFingerType:ReInit(param)
  self.param = param
  if param.position ~= nil then
    self:SetPosition(param.position)
  end
  if self.arrowDirection == GuideArrowDirection.LeftDown then
    self.transform:Set_localScale(1, 1, 1)
  elseif self.arrowDirection == GuideArrowDirection.RightDown then
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end
  if self.finger_anim ~= nil then
    if param.animSpeed ~= nil then
      self.finger_anim.speed = param.animSpeed
    else
      self.finger_anim.speed = 1
    end
  end
end

function UIGuideArrowFingerType:PlayUp()
  if self.finger_anim ~= nil then
    self.finger_anim:Play("V_xinshouzhiyin_taiqi_anim", 0, 0)
  end
end

function UIGuideArrowFingerType:PlayDown()
  if self.finger_anim ~= nil then
    self.finger_anim:Play("V_xinshouzhiyin_anxia_anim", 0, 0)
  end
end

function UIGuideArrowFingerType:PlayLoop()
  if self.finger_anim ~= nil then
    self.finger_anim:Play("V_xinshouzhiyin_loop_anim", 0, 0)
  end
end

return UIGuideArrowFingerType
