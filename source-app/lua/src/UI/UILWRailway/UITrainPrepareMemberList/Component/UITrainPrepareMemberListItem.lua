local UITrainPrepareMemberListItem = BaseClass("UITrainPrepareMemberListItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local head_icon_path = "PlayerBtn/UIPlayerHead"
local txt_name_path = "Txt_Name"
local txt_level_path = "Txt_Level"

function UITrainPrepareMemberListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITrainPrepareMemberListItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainPrepareMemberListItem:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.head_icon = self:AddComponent(UICommonHead, head_icon_path)
  self.head_icon:SetEnableClickShowInfo(true, true)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
end

function UITrainPrepareMemberListItem:ComponentDestroy()
  self.bg = nil
  self.bg_icon = nil
  self.head_icon = nil
  self.txt_name = nil
  self.txt_level = nil
end

function UITrainPrepareMemberListItem:DataDefine()
end

function UITrainPrepareMemberListItem:DataDestroy()
end

function UITrainPrepareMemberListItem:OnAddListener()
  base.OnAddListener(self)
end

function UITrainPrepareMemberListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITrainPrepareMemberListItem:SetItem(logInfo)
  self.playerUid = nil
  if logInfo == nil then
    return
  end
  local name = UIUtil.FormatAllianceAndName(logInfo.abbr, logInfo.name)
  self.txt_name:SetText(name)
  local logInfoUid = logInfo.uid
  self.playerUid = logInfoUid
  self.head_icon:SetHeadAndFrame(logInfo.uid, logInfo.headPic, logInfo.headPicVer, false, logInfo.headSkinId, logInfo.headSkinET)
  self.txt_level:SetText("Lv." .. (logInfo.level or 1))
end

return UITrainPrepareMemberListItem
