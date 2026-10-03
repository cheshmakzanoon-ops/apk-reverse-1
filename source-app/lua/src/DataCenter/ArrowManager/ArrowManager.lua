local ArrowManager = BaseClass("ArrowManager")
local ResourceManager = CS.GameEntry.Resource
local ParamData = {
  arrowType,
  positionType,
  position,
  pointId,
  uuid
}

local function __init(self)
  self.param = nil
  self.fingerParam = nil
end

local function __delete(self)
  self.param = nil
  self.fingerParam = nil
end

local function ShowArrow(self, param)
  if self.fingerArrowObj then
    self.fingerArrowObj:Destroy()
    self.fingerArrowObj = nil
  end
  if param.position ~= nil then
    self.param = param
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIArrow) then
      EventManager:GetInstance():Broadcast(EventId.RefreshArrow)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIArrow, {anim = true, playEffect = false})
    end
    EventManager:GetInstance():Broadcast(EventId.ArrowShow)
  end
end

local function RemoveArrow(self)
  self.param = nil
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIArrow) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArrow)
  end
end

local function GetArrowParam(self)
  return self.param
end

local function ShowFingerArrow(self, param)
  if self.fingerArrowObj then
    self.fingerArrowObj:Destroy()
    self.fingerArrowObj = nil
  end
  self.fingerParam = param
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIArrow) then
    EventManager:GetInstance():Broadcast(EventId.RefreshArrow)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFingerArrow, {anim = true, playEffect = false})
  end
end

local function ShowWorldFingerArrow(self, pos)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIArrow) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArrow)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFingerArrow) then
    if param and param.id == param.guidId then
      return
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFingerArrow)
    self.fingerParam = nil
  end
  if not self.fingerArrowObj then
    self.fingerArrowObj = ResourceManager:InstantiateAsync(UIAssets.WorldFingerArrow)
    self.fingerArrowObj:completed("+", function()
      if self.fingerArrowObj.isError then
        return
      end
      self.fingerArrowObj.gameObject:SetActive(true)
      self.fingerArrowObj.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.fingerArrowObj.gameObject.transform.position = pos
    end)
  else
    self.fingerArrowObj.gameObject.transform.position = pos
  end
end

local function RemoveWorldFingerArrow(self)
  if self.fingerArrowObj then
    self.fingerArrowObj:Destroy()
    self.fingerArrowObj = nil
  end
end

local function RemoveFingerArrow(self, isQuest)
  local param = self.fingerParam
  if isQuest then
    param = nil
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFingerArrow) then
    if param and param.id ~= nil and param.id == param.guidId then
      return
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFingerArrow)
    self.fingerParam = nil
  end
end

local function GetFingerArrowParam(self)
  return self.fingerParam
end

local function CloseAllArrow(self)
  self:RemoveArrow()
  self:RemoveFingerArrow()
  self:RemoveWorldFingerArrow()
end

ArrowManager.__init = __init
ArrowManager.__delete = __delete
ArrowManager.ShowArrow = ShowArrow
ArrowManager.RemoveArrow = RemoveArrow
ArrowManager.GetArrowParam = GetArrowParam
ArrowManager.ShowFingerArrow = ShowFingerArrow
ArrowManager.RemoveFingerArrow = RemoveFingerArrow
ArrowManager.GetFingerArrowParam = GetFingerArrowParam
ArrowManager.ShowWorldFingerArrow = ShowWorldFingerArrow
ArrowManager.RemoveWorldFingerArrow = RemoveWorldFingerArrow
ArrowManager.CloseAllArrow = CloseAllArrow
return ArrowManager
