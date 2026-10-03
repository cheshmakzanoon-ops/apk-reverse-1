local MailHeroItem_UserInfo = BaseClass("MailHeroItem_UserInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local _cp_uiplayerhead = "UIPlayerHead/HeadIcon"
local _cp_txtAbbr = "objName/txtAbbr"
local _cp_txtName = "objName/txtName"

function MailHeroItem_UserInfo:OnCreate()
  base.OnCreate(self)
  self._uiPlayerHead = self:AddComponent(UIPlayerHead, _cp_uiplayerhead)
  self._txtAbbr = self:AddComponent(UIText, _cp_txtAbbr)
  self._txtName = self:AddComponent(UIText, _cp_txtName)
end

function MailHeroItem_UserInfo:SetData(memberInfo)
  local uid = memberInfo:GetUserId()
  local alAbbr = memberInfo.alAbbr or ""
  local name = memberInfo.name or ""
  local pic = memberInfo.pic or ""
  local picVer = memberInfo.picVer or 0
  self._uiPlayerHead:SetData(uid, pic, picVer)
  local strAlAbbr = ""
  if not string.IsNullOrEmpty(alAbbr) then
    strAlAbbr = "[" .. alAbbr .. "]"
  end
  self._txtAbbr:SetText(strAlAbbr)
  self._txtName:SetText(name)
end

return MailHeroItem_UserInfo
