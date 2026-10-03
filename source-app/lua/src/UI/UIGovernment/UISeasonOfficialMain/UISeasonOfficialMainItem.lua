local UISeasonOfficialMainItem = BaseClass("UISeasonOfficialMainItem", UIAsyncContainer)
local base = UIAsyncContainer

function UISeasonOfficialMainItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.icon = self:AddComponent(UIImage, "Icon")
  self.text = self:AddComponent(UIText, "Text")
  self.red_pot = self:AddComponent(UIImage, "RedPot")
  self.btn:SetOnClick(function()
    self:OnCellClick()
  end)
end

function UISeasonOfficialMainItem:OnDestroy()
  self.data = nil
  base.OnDestroy(self)
end

function UISeasonOfficialMainItem:SetData(data)
  self.data = data
end

function UISeasonOfficialMainItem:UpdateData()
  if self.data then
    self.icon:LoadSprite(self.data.Icon)
    self.text:SetLocalText(self.data.LangKey)
    self.icon:SetNativeSize()
  end
end

function UISeasonOfficialMainItem:OnCellClick()
  if self.view and self.data and self.data.Action and type(self.data.Action) == "function" then
    self.data.Action(self.view)
  end
end

return UISeasonOfficialMainItem
