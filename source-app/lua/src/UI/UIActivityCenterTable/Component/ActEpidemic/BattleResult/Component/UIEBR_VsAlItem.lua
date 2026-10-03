local base = UIBaseContainer
local UIEBR_VsAlItem = BaseClass("UIEBR_VsAlItem", base)
local flag_path = "flag"
local server_path = "server"
local abbr_path = "abbr"

function UIEBR_VsAlItem:OnCreate()
  base.OnCreate(self)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.server = self:AddComponent(UITextMeshProUGUIEx, server_path)
  self.abbr = self:AddComponent(UITextMeshProUGUIEx, abbr_path)
end

function UIEBR_VsAlItem:OnDestroy()
  self.flag = nil
  self.bg = nil
  self.server = nil
  self.abbr = nil
  base.OnDestroy(self)
end

function UIEBR_VsAlItem:SetData(alInfo)
  if alInfo == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.flag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, alInfo.icon))
  self.server:SetText("#" .. alInfo.serverId)
  self.abbr:SetText("[" .. alInfo.abbr .. "]")
end

return UIEBR_VsAlItem
