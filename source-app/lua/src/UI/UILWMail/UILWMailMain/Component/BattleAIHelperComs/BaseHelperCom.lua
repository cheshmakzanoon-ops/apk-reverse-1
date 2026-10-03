local BaseHelperCom = BaseClass("BaseHelperCom", UIBaseContainer)
local base = UIBaseContainer

function BaseHelperCom:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BaseHelperCom:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BaseHelperCom:ComponentDefine()
end

function BaseHelperCom:ComponentDestroy()
end

function BaseHelperCom:SetData(data)
end

function BaseHelperCom:DataDefine()
end

function BaseHelperCom:DataDestroy()
end

function BaseHelperCom:OnEnable()
  base.OnEnable(self)
end

function BaseHelperCom:OnDisable()
  base.OnDisable(self)
end

function BaseHelperCom:OnAddListener()
  base.OnAddListener(self)
end

function BaseHelperCom:OnRemoveListener()
  base.OnRemoveListener(self)
end

return BaseHelperCom
