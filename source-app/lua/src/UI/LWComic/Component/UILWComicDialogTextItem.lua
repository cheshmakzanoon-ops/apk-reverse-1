local UILWComicDialogTextItem = BaseClass("UILWComicDialogTextItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "",
    name = "txtName",
    type = UIText
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
end

local function OnDestroy(self)
  self:ClearCompsByBook(compBook)
  base.OnDestroy(self)
end

local function SetData(self, dialog)
  self.txtName:SetLocalText(dialog)
end

UILWComicDialogTextItem.OnCreate = OnCreate
UILWComicDialogTextItem.OnDestroy = OnDestroy
UILWComicDialogTextItem.SetData = SetData
return UILWComicDialogTextItem
