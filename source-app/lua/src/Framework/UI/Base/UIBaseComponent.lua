local UIBaseComponent = BaseClass("UIBaseComponent")
local ResourceManager = CS.GameEntry.Resource
local RectTransformCSType = typeof(CS.UnityEngine.RectTransform)

local function __init(self, holder, var_arg)
  self.view = nil
  self.holder = holder
  self.transform = nil
  self.gameObject = nil
  self.rectTransform = nil
  self.__name = nil
  self.__var_arg = var_arg
  self.activeSelf = false
  self.activeCached = nil
  self.goInstances = nil
  self.initActiveSelf = nil
  self.alreadyLoaded = false
  self.dynamicNodeDict = nil
end

local function Reinit(self, holder, var_arg)
  __init(self, holder, var_arg)
end

local function __delete(self)
  if self.gameObject ~= nil then
    self:OnDestroy()
  else
    self.holder = nil
  end
end

local lua_type = type
local csharp_IsNull = IsNull

local function OnCreate(self)
  local holderTrans = self.holder and self.holder.transform or nil
  if self._class_type == UILayerComponent then
    self.view = nil
  else
    local now_holder = self.holder
    while now_holder ~= nil do
      if now_holder._class_type == UILayerComponent then
        self.view = self
        break
      elseif now_holder.view ~= nil then
        self.view = now_holder.view
        break
      end
      now_holder = now_holder.holder
    end
  end
  local argType = lua_type(self.__var_arg)
  if argType == "string" then
    local obj = holderTrans:Find(self.__var_arg)
    if csharp_IsNull(obj) then
      Logger.LogError("UI Comp Create -> holderTrans:Find(self.__var_arg) is null! " .. self.__var_arg)
    end
    self.gameObject = obj.gameObject
    self.alreadyLoaded = true
  elseif argType == "userdata" then
    self.gameObject = self.__var_arg
    self.alreadyLoaded = true
  else
    error("OnCreate : error params list! " .. argType .. " " .. tostring(self.__var_arg))
  end
  if self.initActiveSelf ~= nil then
    self.gameObject:SetActive(self.initActiveSelf)
    self.initActiveSelf = nil
  end
  self.activeSelf = self.gameObject.activeSelf
  self.__name = self.gameObject.name
end

local function getter_transform(self)
  if self.alreadyLoaded then
    self.transform = self.gameObject.transform
    return self.transform
  end
  return nil
end

local function getter_rectTransform(self)
  if self.alreadyLoaded then
    self.rectTransform = self.gameObject:GetComponent(RectTransformCSType)
    return self.rectTransform
  end
  return nil
end

local function OnEnable(self)
end

local function GetName(self)
  return self.__name
end

local function SetName(self, name, toUnity)
  if self.holder ~= nil and self.holder.OnComponentSetName ~= nil then
    self.holder:OnComponentSetName(self, name)
  end
  self.__name = name
  if toUnity or Config.Debug then
    if IsNull(self.gameObject) then
      Logger.LogError("gameObject null, you maybe have to wait for loading prefab finished!")
      return
    end
    self.gameObject.__name = name
  end
end

local function SetActive(self, active)
  if active then
    if self:GetActiveInHierarchy() then
      return
    end
  elseif not self:GetActiveInHierarchy() then
    if self.gameObject then
      if self.activeSelf ~= false then
        self.gameObject:SetActive(false)
      end
    else
      self:SetInitActiveSelf(false)
    end
    self.activeSelf = false
    return
  end
  self.activeSelf = active
  self.activeCached = active
  if self.gameObject ~= nil then
    self.gameObject:SetActive(active)
    if active then
      self:OnEnable()
    else
      self:OnDisable()
    end
  else
    self:SetInitActiveSelf(active)
    Logger.Log("self.gameObject nil, " .. tostring(__var_arg))
  end
end

local function GetActive(self)
  return self.activeSelf
end

local function GetActiveInHierarchy(self)
  local activeCached = self.activeCached
  if activeCached ~= nil then
    return activeCached
  end
  activeCached = self.activeSelf and (self.holder == nil or lua_type(self.holder.GetActiveInHierarchy) == "function" and self.holder:GetActiveInHierarchy())
  self.activeCached = activeCached
  return activeCached
end

local function SetInitActiveSelf(self, active)
  self.initActiveSelf = active
end

local function OnDisable(self)
end

local function __OnFrameworkDestroy(self)
end

local function OnDestroy(self)
  if self.holder ~= nil and self.holder.OnComponentDestroy ~= nil then
    self.holder:OnComponentDestroy(self)
  end
  if self.dynamicNodeDict then
    for _, node in ipairs(self.dynamicNodeDict) do
      if node and type(node.Delete) == "function" then
        pcall(node.Delete, node)
      end
    end
  end
  self.dynamicNodeDict = nil
  self.view = nil
  self.holder = nil
  self.transform = nil
  self.gameObject = nil
  self.rectTransform = nil
  self.__name = nil
  self.alreadyLoaded = false
  if self.goInstances then
    for req, t in pairs(self.goInstances) do
      req:Destroy()
    end
  end
  self:UnBindAllRedPoints()
end

local function GameObjectInstantiateAsync(self, prefabPath, onComplete, property)
  local req = ResourceManager:InstantiateAsync(prefabPath, ObjectPoolTag.Normal, property or AssetLoadPriority.High)
  req:completed("+", function()
    if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() and not req.isUseCache then
      CS.ArabicMirror.MirrorEntry(true, true, req.gameObject)
    end
    if onComplete then
      onComplete(req)
    end
  end)
  if not self.goInstances then
    self.goInstances = {}
  end
  self.goInstances[req] = "InstanceRequest"
  return req
end

local function GameObjectDestroy(self, req)
  if not self.goInstances then
    return
  end
  local t = self.goInstances[req]
  if t == "InstanceRequest" then
    self.goInstances[req] = nil
    req:Destroy()
  end
end

local function DestroyChildNode(childTransform)
  if childTransform == nil then
    return
  end
  local childCnt = childTransform.transform.childCount
  for i = 0, childCnt - 1 do
    local child = childTransform.transform:GetChild(i)
    CS.UnityEngine.GameObject.Destroy(child.gameObject)
  end
end

local function DestroyChildNodeExceptIndex(childTransform, instanceId)
  if childTransform == nil then
    return
  end
  local childCnt = childTransform.transform.childCount
  for i = 0, childCnt - 1 do
    local child = childTransform.transform:GetChild(i)
    if instanceId == nil or child:GetInstanceID() ~= instanceId then
      CS.UnityEngine.GameObject.Destroy(child.gameObject)
    end
  end
end

local function DestroyChildNodeExceptIndices(childTransform, instanceIds)
  if childTransform == nil then
    return
  end
  local childCnt = childTransform.transform.childCount
  for i = 0, childCnt - 1 do
    local child = childTransform.transform:GetChild(i)
    local childId = child:GetInstanceID()
    if string.IsNullOrEmpty(instanceIds) or not instanceIds[childId] then
      CS.UnityEngine.GameObject.Destroy(child.gameObject)
    end
  end
end

local function SetEnabled(self, value)
  if CS.UnityEngine.Application.isEditor then
    UIUtil.ShowTips("[\231\188\150\232\190\145\229\153\168] \230\178\161\230\156\137\229\174\158\231\142\176 SetEnabled \230\150\185\230\179\149\239\188\129")
    Logger.LogWarning("\230\178\161\230\156\137\229\174\158\231\142\176 SetEnabled \230\150\185\230\179\149")
  end
end

local function SetPositionXYZ(self, x, y, z)
  self.rectTransform:Set_position(x, y, z)
end

local function GetPositionXYZ(self)
  return self.rectTransform:Get_position()
end

local function SetPosition(self, v)
  self.rectTransform:Set_position(v.x, v.y, v.z)
end

local function GetPosition(self)
  local x, y, z = self.rectTransform:Get_position()
  return Vector3.New(x, y, z)
end

local function SetLocalPositionXYZ(self, x, y, z, skipArabicMirror)
  if not skipArabicMirror and CommonUtil and x then
    x = x * CommonUtil.ArabicAutoMirrorFactor()
  end
  self.rectTransform:Set_localPosition(x, y, z)
end

local function GetLocalPositionXYZ(self, skipArabicMirror)
  local x, y, z = self.rectTransform:Get_localPosition()
  if not skipArabicMirror and CommonUtil and x then
    x = x * CommonUtil.ArabicAutoMirrorFactor()
  end
  return x, y, z
end

local function SetLocalPosition(self, v, skipArabicMirror)
  local pos = DeepCopy(v)
  if not skipArabicMirror and CommonUtil and pos and pos.x then
    pos.x = pos.x * CommonUtil.ArabicAutoMirrorFactor()
  end
  self.rectTransform:Set_localPosition(pos.x, pos.y, pos.z)
end

local function GetLocalPosition(self, skipArabicMirror)
  local x, y, z = self.rectTransform:Get_localPosition()
  if not skipArabicMirror and CommonUtil and x then
    x = x * CommonUtil.ArabicAutoMirrorFactor()
  end
  return Vector3.New(x, y, z)
end

local function SetLocalScaleXYZ(self, x, y, z)
  self.rectTransform:Set_localScale(x, y, z)
end

local function GetLocalScaleXYZ(self)
  return self.rectTransform:Get_localScale()
end

local function SetLocalScale(self, v)
  self.rectTransform:Set_localScale(v.x, v.y, v.z)
end

local function GetLocalScale(self)
  local x, y, z = self.rectTransform:Get_localScale()
  return Vector3.New(x, y, z)
end

local function SetEulerAnglesXYZ(self, x, y, z)
  self.rectTransform:Set_eulerAngles(x, y, z)
end

local function GetEulerAnglesXYZ(self)
  return self.rectTransform:Get_eulerAngles()
end

local function SetEulerAngles(self, v)
  self.rectTransform:Set_eulerAngles(v.x, v.y, v.z)
end

local function GetEulerAngles(self)
  local x, y, z = self.rectTransform:Get_eulerAngles()
  return Vector3.New(x, y, z)
end

local function SetAnchorMinXY(self, x, y)
  self.rectTransform:Set_anchorMin(x, y)
end

local function GetAnchorMinXY(self)
  return self.rectTransform:Get_anchorMin()
end

local function SetAnchorMin(self, v)
  self.rectTransform:Set_anchorMin(v.x, v.y)
end

local function GetAnchorMin(self)
  local x, y = self.rectTransform:Get_anchorMin()
  return Vector2.New(x, y)
end

local function SetAnchorMaxXY(self, x, y)
  self.rectTransform:Set_anchorMax(x, y)
end

local function GetAnchorMaxXY(self)
  return self.rectTransform:Get_anchorMax()
end

local function SetAnchorMax(self, v)
  self.rectTransform:Set_anchorMax(v.x, v.y)
end

local function GetAnchorMax(self)
  local x, y = self.rectTransform:Get_anchorMax()
  return Vector2.New(x, y)
end

local function SetOffsetMaxXY(self, x, y)
  self.rectTransform:Set_offsetMax(x, y)
end

local function GetOffsetMaxXY(self)
  return self.rectTransform:Get_offsetMax()
end

local function SetOffsetMax(self, v)
  self.rectTransform:Set_offsetMax(v.x, v.y)
end

local function GetOffsetMax(self)
  local x, y = self.rectTransform:Get_offsetMax()
  return Vector2.New(x, y)
end

local function SetOffsetMinXY(self, x, y)
  self.rectTransform:Set_offsetMin(x, y)
end

local function GetOffsetMinXY(self)
  return self.rectTransform:Get_offsetMin()
end

local function SetOffsetMin(self, v)
  self.rectTransform:Set_offsetMin(v.x, v.y)
end

local function GetOffsetMin(self)
  local x, y = self.rectTransform:Get_offsetMin()
  return Vector2.New(x, y)
end

local function SetAnchoredPosition(self, value, skipArabicMirror)
  local pos = DeepCopy(value)
  if not skipArabicMirror and CommonUtil and pos and pos.x then
    pos.x = pos.x * CommonUtil.ArabicAutoMirrorFactor()
  end
  self.rectTransform:Set_anchoredPosition(pos.x, pos.y)
end

local function SetAnchoredPositionXY(self, x, y, skipArabicMirror)
  if not skipArabicMirror and CommonUtil and x then
    x = x * CommonUtil.ArabicAutoMirrorFactor()
  end
  self.rectTransform:Set_anchoredPosition(x, y)
end

local function GetAnchoredPosition(self, skipArabicMirror)
  local x, y = self.rectTransform:Get_anchoredPosition()
  if not skipArabicMirror and CommonUtil and x then
    x = x * CommonUtil.ArabicAutoMirrorFactor()
  end
  return Vector2.New(x, y)
end

local function GetAnchoredPositionX(self, skipArabicMirror)
  local x, y = self.rectTransform:Get_anchoredPosition()
  if not skipArabicMirror and CommonUtil and x then
    x = x * CommonUtil.ArabicAutoMirrorFactor()
  end
  return x
end

local function GetAnchoredPositionY(self)
  local x, y = self.rectTransform:Get_anchoredPosition()
  return y
end

local function GetSizeDelta(self)
  if not self.rectTransform then
    Logger.LogError(string.format("__UIException__ GetSizeDelta exception! rect transform is null. alreadyLoaded = %s", self.alreadyLoaded))
    return Vector2.zero
  end
  local x, y = self.rectTransform:Get_sizeDelta()
  return Vector2.New(x, y)
end

function UIBaseComponent:GetSizeDeltaXY()
  local x, y = self.rectTransform:Get_sizeDelta()
  return x, y
end

local function SetSizeDelta(self, value)
  self.rectTransform:Set_sizeDelta(value.x, value.y)
end

function UIBaseComponent:SetSizeDeltaXY(x, y)
  self.rectTransform:Set_sizeDelta(x, y)
end

function UIBaseComponent:SetAsFirstSibling()
  self.transform:SetAsFirstSibling()
end

function UIBaseComponent:SetAsLastSibling()
  self.transform:SetAsLastSibling()
end

function UIBaseComponent:SetSiblingIndex(index)
  self.transform:SetSiblingIndex(index)
end

function UIBaseComponent:SetPivotXY(x, y)
  if not self.rectTransform then
    return
  end
  if not x or not y then
    return
  end
  self.rectTransform:Set_pivot(x, y)
end

function UIBaseComponent:SetPivotMiddle()
  if not self.rectTransform then
    return
  end
  self.rectTransform:Set_pivot(0.5, 0.5)
end

function UIBaseComponent:SetSizeDeltaY(y)
  local x = self:GetSizeDelta().x
  self.rectTransform:Set_sizeDelta(x, y)
end

function UIBaseComponent:SetSizeDeltaX(x)
  local y = self:GetSizeDelta().y
  self.rectTransform:Set_sizeDelta(x, y)
end

function UIBaseComponent:LoadComponentAsync(luaClassOrPath, prefabPath, parent, callback, callback_param, var_arg)
  local ret
  local result, errorMsg = pcall(function()
    local theParent = parent or self
    if theParent ~= nil and luaClassOrPath ~= nil then
      local transform = theParent.transform
      if IsNotNull(transform) then
        local luaClass = luaClassOrPath
        if type(luaClass) == "string" then
          luaClass = require(luaClassOrPath)
        end
        if luaClass ~= nil then
          ret = luaClass.New(self, transform, prefabPath, callback, callback_param, var_arg)
          if self.dynamicNodeDict == nil then
            self.dynamicNodeDict = {}
          end
          table.insert(self.dynamicNodeDict, ret)
        end
      end
    end
  end)
  if result == false then
    Logger.LogError("AsyncLoadComponent fail, error = " .. errorMsg)
  end
  return ret
end

function UIBaseComponent:RemoveAsyncComponent(luaClass)
  if self.dynamicNodeDict ~= nil and luaClass ~= nil and luaClass.instanceOf ~= nil and luaClass:instanceOf("UIAsyncContainer") then
    for index, cache in ipairs(self.dynamicNodeDict) do
      if cache == luaClass and type(cache.Delete) == "function" then
        pcall(cache.Delete, cache)
        pcall(function()
          table.remove(self.dynamicNodeDict, index)
        end)
        break
      end
    end
  end
end

local function __OnRedPointCallBack(self, count, userData, redPointNode)
  if not userData then
    return
  end
  if userData.nodeComp and not IsNull(userData.nodeComp) then
    userData.nodeComp:SetActive(0 < count)
  end
  if userData.textComp and not IsNull(userData.textComp) then
    if count <= 0 then
      userData.textComp:SetText("")
    else
      userData.textComp:SetText(tostring(count))
    end
  end
end

function UIBaseComponent:BindRedPointUI(nodeComp, textComp, pathList)
  local node = DataCenter.RedPointManager:GetChild(pathList)
  if not node then
    local pathStr = table.concat(pathList, "/")
    if GMUtils.GetBool(GMConst.LogRedPointInfo, false) then
      Logger.LogError("UIBaseComponent:BindRedPointUI -> redPointNode is nil! CompName:" .. tostring(self:GetName()) .. ", Path:" .. pathStr)
    else
      Logger.LogWarning("UIBaseComponent:BindRedPointUI -> redPointNode is nil! CompName:" .. tostring(self:GetName()) .. ", Path:" .. pathStr)
    end
    __OnRedPointCallBack(self, 0, {nodeComp = nodeComp, textComp = textComp}, nil)
    return
  end
  return self:BindRedPointNode(__OnRedPointCallBack, node, {nodeComp = nodeComp, textComp = textComp})
end

function UIBaseComponent:BindRedPoint(callback, pathList, userData_)
  local node = DataCenter.RedPointManager:GetChild(pathList)
  return self:BindRedPointNode(callback, node, userData_)
end

function UIBaseComponent:BindRedPointNode(callback, redPointNode, userData_)
  if not redPointNode then
    if GMUtils.GetBool(GMConst.LogRedPointInfo, false) then
      Logger.LogWarning("UIBaseComponent:BindRedPointNode -> redPointNode is nil! CompName:" .. tostring(self:GetName()))
    end
    return
  end
  redPointNode:Bind(self, callback, userData_)
  if not self.redPointBindings then
    self.redPointBindings = {}
  end
  self.redPointBindings[redPointNode] = callback
  return redPointNode
end

function UIBaseComponent:UnBindRedPoint(pathList)
  local node = DataCenter.RedPointManager:GetChild(pathList)
  self:UnBindRedPointNode(node)
end

function UIBaseComponent:UnBindRedPointNode(redPointNode)
  if not redPointNode then
    return
  end
  if not self.redPointBindings then
    return
  end
  local callback = self.redPointBindings[redPointNode]
  if callback then
    redPointNode:UnBind(self)
    self.redPointBindings[redPointNode] = nil
  end
end

function UIBaseComponent:UnBindAllRedPoints()
  if not self.redPointBindings then
    return
  end
  for node, callback in pairs(self.redPointBindings) do
    if node then
      node:UnBind(self)
    end
  end
  self.redPointBindings = nil
end

UIBaseComponent.__init = __init
UIBaseComponent.Reinit = Reinit
UIBaseComponent.__delete = __delete
UIBaseComponent.OnCreate = OnCreate
UIBaseComponent.OnEnable = OnEnable
UIBaseComponent.GetName = GetName
UIBaseComponent.SetName = SetName
UIBaseComponent.SetActive = SetActive
UIBaseComponent.SetInitActiveSelf = SetInitActiveSelf
UIBaseComponent.GetActive = GetActive
UIBaseComponent.GetActiveInHierarchy = GetActiveInHierarchy
UIBaseComponent.OnDisable = OnDisable
UIBaseComponent.OnDestroy = OnDestroy
UIBaseComponent.__OnFrameworkDestroy = __OnFrameworkDestroy
UIBaseComponent.GameObjectInstantiateAsync = GameObjectInstantiateAsync
UIBaseComponent.GameObjectDestroy = GameObjectDestroy
UIBaseComponent.DestroyChildNode = DestroyChildNode
UIBaseComponent.DestroyChildNodeExceptIndex = DestroyChildNodeExceptIndex
UIBaseComponent.DestroyChildNodeExceptIndices = DestroyChildNodeExceptIndices
UIBaseComponent.SetEnabled = SetEnabled
UIBaseComponent.SetAnchoredPosition = SetAnchoredPosition
UIBaseComponent.SetAnchoredPositionXY = SetAnchoredPositionXY
UIBaseComponent.GetAnchoredPosition = GetAnchoredPosition
UIBaseComponent.GetAnchoredPositionX = GetAnchoredPositionX
UIBaseComponent.GetAnchoredPositionY = GetAnchoredPositionY
UIBaseComponent.GetSizeDelta = GetSizeDelta
UIBaseComponent.SetSizeDelta = SetSizeDelta
UIBaseComponent.SetPosition = SetPosition
UIBaseComponent.GetPosition = GetPosition
UIBaseComponent.SetPositionXYZ = SetPositionXYZ
UIBaseComponent.GetPositionXYZ = GetPositionXYZ
UIBaseComponent.SetLocalPosition = SetLocalPosition
UIBaseComponent.GetLocalPosition = GetLocalPosition
UIBaseComponent.SetLocalPositionXYZ = SetLocalPositionXYZ
UIBaseComponent.GetLocalPositionXYZ = GetLocalPositionXYZ
UIBaseComponent.SetLocalScale = SetLocalScale
UIBaseComponent.GetLocalScale = GetLocalScale
UIBaseComponent.SetLocalScaleXYZ = SetLocalScaleXYZ
UIBaseComponent.GetLocalScaleXYZ = GetLocalScaleXYZ
UIBaseComponent.SetEulerAngles = SetEulerAngles
UIBaseComponent.GetEulerAngles = GetEulerAngles
UIBaseComponent.SetEulerAnglesXYZ = SetEulerAnglesXYZ
UIBaseComponent.GetEulerAnglesXYZ = GetEulerAnglesXYZ
UIBaseComponent.SetAnchorMin = SetAnchorMin
UIBaseComponent.GetAnchorMin = GetAnchorMin
UIBaseComponent.SetAnchorMinXY = SetAnchorMinXY
UIBaseComponent.GetAnchorMinXY = GetAnchorMinXY
UIBaseComponent.SetAnchorMax = SetAnchorMax
UIBaseComponent.GetAnchorMax = GetAnchorMax
UIBaseComponent.SetAnchorMaxXY = SetAnchorMaxXY
UIBaseComponent.GetAnchorMaxXY = GetAnchorMaxXY
UIBaseComponent.SetOffsetMaxXY = SetOffsetMaxXY
UIBaseComponent.GetOffsetMaxXY = GetOffsetMaxXY
UIBaseComponent.SetOffsetMax = SetOffsetMax
UIBaseComponent.GetOffsetMax = GetOffsetMax
UIBaseComponent.SetOffsetMinXY = SetOffsetMinXY
UIBaseComponent.GetOffsetMinXY = GetOffsetMinXY
UIBaseComponent.SetOffsetMin = SetOffsetMin
UIBaseComponent.GetOffsetMin = GetOffsetMin
UIBaseComponent.getters.transform = getter_transform
UIBaseComponent.getters.rectTransform = getter_rectTransform
return UIBaseComponent
