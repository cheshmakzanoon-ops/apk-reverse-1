local WorldBookmarkServerListItemCell = BaseClass("WorldBookmarkServerListItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local empty = ""
local active_path = "Active"
local inactive_path = "Inactive"
local tmp_active_path = "Active/TmpActive"
local tmp_inactive_path = "Inactive/TmpInactive"

local function OnCreate(self)
  base.OnCreate(self)
  self.goActive = self.transform:Find(active_path).gameObject
  self.goInactive = self.transform:Find(inactive_path).gameObject
  self.tmp_active = self:AddComponent(UITextMeshProUGUIEx, tmp_active_path)
  self.tmp_inactive = self:AddComponent(UITextMeshProUGUIEx, tmp_inactive_path)
  self.btn = self:AddComponent(UIButton, empty)
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
end

function WorldBookmarkServerListItemCell:Refresh(host, index, serverId, isActive)
  self.host = host
  self.index = index
  self.serverId = serverId
  self.goActive:SetActive(isActive)
  self.goInactive:SetActive(not isActive)
  if serverId == -1 then
    self.tmp_active:SetLocalText(151110)
    self.tmp_inactive:SetLocalText(151110)
  else
    local _ = UIUtil.FormatServerName(serverId)
    self.tmp_active:SetText(_)
    self.tmp_inactive:SetText(_)
  end
end

function WorldBookmarkServerListItemCell:OnClick()
  if self.host then
    self.host:OnClickedServer(self.serverId)
  end
end

WorldBookmarkServerListItemCell.OnCreate = OnCreate
return WorldBookmarkServerListItemCell
