local base = UIBaseContainer
local LWActMeteoriteZoneItem = BaseClass("LWActMeteoriteZoneItem", base)
local di_path = "Di"
local desc_text_path = "DescText"

function LWActMeteoriteZoneItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetInteractable(false)
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  self.di = self:AddComponent(UIImage, di_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
end

function LWActMeteoriteZoneItem:OnDestroy()
  self.icon = nil
  self.di = nil
  self.desc_text = nil
  self.idx = 0
  self.cb = nil
  base.OnDestroy(self)
end

function LWActMeteoriteZoneItem:SetData(meteorite)
  if meteorite == nil then
    self:SetActive(false)
    return
  end
  self.serverId = meteorite.serverId
  self:SetActive(true)
  local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(meteorite.cfgId)
  if itemCfg ~= nil then
    self.icon:LoadSpriteAuto(string.format(LoadPath.ItemPath, itemCfg.icon))
  end
  local sPath = meteorite.serverId == LuaEntry.Player:GetSelfServerId() and "lrb_zhouliuhuodong_zhanqu_lan.png" or "lrb_zhouliuhuodong_zhanqu_hong.png"
  self.di:LoadSpriteAuto(string.format(LoadPath.LWActMeteoriteBattlePath, sPath))
  self.desc_text:SetText("#" .. meteorite.serverId)
end

function LWActMeteoriteZoneItem:SetCb(idx, cb)
  self.idx = idx
  self.cb = cb
  self.btn:SetInteractable(self.cb ~= nil)
end

function LWActMeteoriteZoneItem:OnClick()
  if self.cb then
    self.cb(self.idx)
  end
end

return LWActMeteoriteZoneItem
