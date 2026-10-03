local base = UIBaseContainer
local UIChatViewPinList_v2 = BaseClass("UIChatViewPinList_v2", base)
local compBook = {}

function UIChatViewPinList_v2:OnCreate()
  base.OnCreate(self)
  self.pinDatas = nil
  self.items = {}
  self:ComponentDefine()
end

function UIChatViewPinList_v2:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self:ReleaseAllPinResHandls()
  self.items = nil
end

function UIChatViewPinList_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIChatViewPinList_v2:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatViewPinList_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatPinUpdate, self.OnChatPinUpdate)
  self:AddUIListener(EventId.APP_APPLICATION_PAUSE, self.OnChatPinUpdate)
  self:AddUIListener(EventId.AllianceNoticeUpdate, self.OnChatPinUpdate)
end

function UIChatViewPinList_v2:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatPinUpdate, self.OnChatPinUpdate)
  self:RemoveUIListener(EventId.AllianceNoticeUpdate, self.OnChatPinUpdate)
  self:RemoveUIListener(EventId.APP_APPLICATION_PAUSE, self.OnChatPinUpdate)
  base.OnRemoveListener(self)
end

function UIChatViewPinList_v2:OnLoadObject(obj, data)
  obj:SetActive(true)
  obj.transform:SetParent(self.transform)
  obj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  obj.transform:SetAsLastSibling()
  local nameStr = tostring(NameCount)
  obj.name = nameStr
  data.__compName = nameStr
  NameCount = NameCount + 1
  local pinComp = self:AddComponent(data:GetPrefabClass(), nameStr)
  pinComp:ReInit(data, false, true)
end

function UIChatViewPinList_v2:AsyncLoad(pinData)
  local handle = self:GameObjectInstantiateAsync(pinData:GetPrefabPath(), function(request)
    if request.isError then
      return
    end
    self:OnLoadObject(request.gameObject, pinData)
  end)
  table.insert(self.pinResHandles, handle)
end

function UIChatViewPinList_v2:UpdatePins(room)
  if not room or room:isPrivateChat() and self.pinDatas and table.count(self.pinDatas) > 0 and self.pinDatas[1].uid == room:GetPrivateUser() then
    return
  end
  self:ReleaseAllPinResHandls()
  self.pinResHandles = {}
  self.pinDatas = DataCenter.LWChatPinManager:GetAllPinData(room)
  table.removebyfunc(self.pinDatas, function(pinData)
    if pinData.type == ChatPinMessageType.AllianceGatherMember or pinData.type == ChatPinMessageType.AllianceGatherLeader then
      return true
    end
  end)
  local obj
  for _, pinData in pairs(self.pinDatas) do
    self:AsyncLoad(pinData)
  end
end

function UIChatViewPinList_v2:ReleaseAllPinResHandls()
  if self.pinDatas and self.components then
    for _, pinData in pairs(self.pinDatas) do
      self:RemoveComponents(pinData:GetPrefabClass())
    end
    self.pinDatas = nil
  end
  if self.pinResHandles then
    for _, handle in pairs(self.pinResHandles) do
      handle:Destroy()
    end
    self.pinResHandles = nil
  end
  if self.items then
    for i, item in pairs(self.items) do
      item:GameObjectRecycleAll()
    end
  end
end

function UIChatViewPinList_v2:OnChatPinUpdate()
  self:UpdatePins(self.view:GetSelectedRoom())
end

return UIChatViewPinList_v2
