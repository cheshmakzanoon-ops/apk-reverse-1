local UILWWorldTipPage = BaseClass("UILWWorldTipPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWWorldTipPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWWorldTipPage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWWorldTipPage:ComponentDefine()
  self.img = self:AddComponent(UIRawImage, "img")
  self.img:SetAutoSizeFitMode(true)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
end

function UILWWorldTipPage:ComponentDestroy()
  self.img = nil
  self.desc = nil
end

function UILWWorldTipPage:SetData(data)
  if data == nil then
    return
  end
  self.img:SetActive(not string.IsNullOrEmpty(data.banner))
  if not string.IsNullOrEmpty(data.banner) then
    self.img:LoadSpriteAuto(data.banner)
  end
  local params = {}
  if not string.IsNullOrEmpty(data.para_set) then
    local splitStr = string.split(data.para_set, ";")
    for i, v in pairs(splitStr) do
      if not string.IsNullOrEmpty(v) then
        table.insert(params, v)
      end
    end
  end
  if not table.IsNullOrEmpty(params) then
    self.desc:SetText(Localization:GetString(data.long_key, SafeUnpack(params)))
  else
    self.desc:SetText(Localization:GetString(data.long_key))
  end
end

return UILWWorldTipPage
