local UIAsyncNode = BaseClass("UIAsyncNode")
local ResourceManager = CS.GameEntry.Resource

function UIAsyncNode:__init(name, transform, prefabPath, callback, callback_param)
  local request = ResourceManager:InstantiateAsync(prefabPath)
  request:completed("+", function()
    if request.isError or transform == nil or IsNull(transform) then
      return
    end
    local go = request.gameObject
    go.name = name
    go:SetActive(self.goIsActive == nil or self.goIsActive == true)
    go.transform:SetParent(transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localRotation(0, 0, 0, 1)
    self.gameObject = go
    self.transform = go.transform
    self:OnCreate()
    if go.activeSelf then
      self:OnEnable()
    end
    self:UpdateData()
    EventManager:GetInstance():BroadcastDeferred(EventId.UIAsyncLoadDynamicPrefabFinish)
    if callback ~= nil and type(callback) == "function" then
      CommonUtil.ProtectCall(function()
        callback(go, self, callback_param)
      end)
    end
  end)
  self.addListenerCount = 0
  self.request = request
end

function UIAsyncNode:__delete()
  if self.gameObject ~= nil then
    self:OnDisable()
    self:OnDestroy()
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.gameObject = nil
  self.transform = nil
end

function UIAsyncNode:OnCreate()
end

function UIAsyncNode:OnEnable()
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  if self.Update or self.Update100MS or self.Update1000MS then
    function self.__update_handle()
      if type(self.Update100MS) == "function" then
        self.__time_update_100ms = (self.__time_update_100ms or 0) + Time.unscaledDeltaTime
        
        if self.__time_update_100ms >= 0.1 then
          self.__time_update_100ms = self.__time_update_100ms % 0.1
          self:Update100MS()
        end
      end
      if type(self.Update1000MS) == "function" then
        self.__time_update_1000ms = (self.__time_update_1000ms or 0) + Time.unscaledDeltaTime
        if self.__time_update_1000ms >= 1 then
          self.__time_update_1000ms = self.__time_update_1000ms % 1
          self:Update1000MS()
        end
      end
      if type(self.Update) == "function" then
        self:Update()
      end
    end
    
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  end
  self:OnAddListener()
end

function UIAsyncNode:OnDisable()
  if self.addListenerCount and self.addListenerCount > 0 then
    self:OnRemoveListener()
  end
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
end

function UIAsyncNode:OnAddListener()
  self.addListenerCount = self.addListenerCount + 1
end

function UIAsyncNode:OnRemoveListener()
  self.addListenerCount = self.addListenerCount - 1
end

function UIAsyncNode:OnDestroy()
end

function UIAsyncNode:UpdateData()
end

function UIAsyncNode:AsyncLoadDone()
  return GameObjectIsValid(self.gameObject)
end

function UIAsyncNode:SetActive(active)
  self.goIsActive = active
  if IsNotNull(self.gameObject) then
    self.gameObject:SetActive(active)
  end
end

return UIAsyncNode
