local MailContentContainer = BaseClass("MailContentContainer", UIBaseContainer)
local base = UIBaseContainer
local MailSystem = require("UI.UIMainNotice.Component.MailSystem")
local _cp_scrollContent = ""
local eMailConfigType = {System_Type = 1}
local eMailConfig = {
  [eMailConfigType.System_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/UIMainNotice/MailSystem.prefab",
    Script = MailSystem
  }
}

function MailContentContainer:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self._scrollContent = self:AddComponent(UIBaseContainer, _cp_scrollContent)
end

function MailContentContainer:DataDefine()
  self._reqlist = {}
end

function MailContentContainer:ShowData(maildata, showReplay, jumpType)
  self:RecycleAll()
  if maildata == nil then
    return false
  end
  local mailConfigType = eMailConfigType.System_Type
  self:ShowContent(maildata, mailConfigType, showReplay, jumpType)
  return true
end

function MailContentContainer:ShowContent(maildata, configType, showReplay, jumpType)
  self:RecycleAll()
  local _mailConfig = eMailConfig[configType]
  if _mailConfig == nil then
    return
  end
  local req = self:GameObjectInstantiateAsync(_mailConfig.Prefab, function(request)
    self:onCreateRoom(request, maildata, configType, showReplay, jumpType)
  end)
  self._reqlist[#self._reqlist + 1] = req
end

function MailContentContainer:OnDestroy()
  self:RecycleAll()
end

function MailContentContainer:RecycleAll()
  for k, v in pairs(self._reqlist) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self._reqlist = {}
  for _, config in pairs(eMailConfig) do
    local component = config.Script
    self._scrollContent:RemoveComponents(component)
  end
end

function MailContentContainer:onCreateRoom(request, maildata, configType, showReplay, jumpType)
  if request.isError then
    return
  end
  local _mailConfig = eMailConfig[configType]
  local prefabName = PathUtil.GetFileNameWithoutExtension(_mailConfig.Prefab)
  local ObjScript = _mailConfig.Script
  local go = request.gameObject
  go.transform:SetParent(self._scrollContent.transform)
  go.transform:SetAsLastSibling()
  go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  NameCount = NameCount + 1
  go.name = prefabName .. "..." .. NameCount
  local temp = self._scrollContent:AddComponent(ObjScript, go.name)
  go:SetActive(true)
  temp:setData(maildata, showReplay, jumpType)
end

return MailContentContainer
