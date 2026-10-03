local WinterStormMainResultItem = BaseClass("WinterStormMainResultItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function WinterStormMainResultItem:OnCreate()
  base.OnCreate(self)
  self.img = self:AddComponent(UIRawImage, "Img")
  self.btn = self:AddComponent(UIButton, "Img")
  self.btn:SetOnClick(BindCallback(self, self.OnClickMvpBtn))
  self.text = self:AddComponent(UIText, "TipsText")
end

function WinterStormMainResultItem:OnDestroy()
  self.img = nil
  self.text = nil
  base.OnDestroy(self)
end

function WinterStormMainResultItem:OnClickMvpBtn()
  if not string.IsNullOrEmpty(self.mvpDesc) then
    UIUtil.ShowBubbleTips(self.mvpDesc, self.btn.transform.position, 0, -30, 0)
  end
end

function WinterStormMainResultItem:ReInit(info)
  self.img:LoadSpriteAsyncWithCallback(info.icon, function()
    if self.img then
      self.img:SetNativeSize()
    end
  end)
  local name = Localization:GetString(info.name)
  self.text:SetText(name .. ": \195\151" .. info.num)
  self.mvpDesc = Localization:GetString(info.desc, info.score)
end

return WinterStormMainResultItem
