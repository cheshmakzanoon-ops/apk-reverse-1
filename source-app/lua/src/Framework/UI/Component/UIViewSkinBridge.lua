local UIViewSkinBridge = BaseClass("UIViewSkinBridge", UIBaseComponent)
local base = UIBaseComponent
local CSScriptViewSkin = typeof(CS.ViewSkinProPropertyRecorder)

local function OnCreate(self)
  base.OnCreate(self)
  self.viewSkin = self.transform:GetComponent(CSScriptViewSkin)
  self.viewSkinProperties = nil
  if IsNull(self.viewSkin) then
    self.viewSkin = nil
    if self.transform then
      Logger.LogError("UIViewSkinBridge viewSkin is nil" .. self.transform.name)
    end
  else
    self.viewSkinProperties = {}
    self.viewSkin:FillLua(self.viewSkinProperties)
  end
end

local function OnDestroy(self)
  self.viewSkin = nil
  self.viewSkinProperties = nil
  base.OnDestroy(self)
end

function UIViewSkinBridge:GetSingleProperty(index)
  if not self.viewSkinProperties then
    return nil
  end
  if index <= 0 then
    return nil
  end
  return self.viewSkinProperties[index]
end

local AGGRESSIVE_ADD_COMPONENT = true

function UIViewSkinBridge:AddComponent(context, targetCls, index)
  if not self.viewSkin then
    return nil
  end
  if index <= 0 then
    return nil
  end
  local csComp = self:GetSingleProperty(index)
  if AGGRESSIVE_ADD_COMPONENT then
    return context:AddComponent(targetCls, csComp.gameObject, csComp)
  elseif not IsNull(csComp) then
    return context:AddComponent(targetCls, csComp.gameObject, csComp)
  end
  return nil
end

UIViewSkinBridge.OnCreate = OnCreate
UIViewSkinBridge.OnDestroy = OnDestroy
return UIViewSkinBridge
