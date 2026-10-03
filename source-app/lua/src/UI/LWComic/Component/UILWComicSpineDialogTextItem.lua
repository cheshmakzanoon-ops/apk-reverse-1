local UILWComicSpineDialogTextItem = BaseClass("UILWComicSpineDialogTextItem", UIBaseContainer)
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
  self.doTextTween = nil
end

local function OnDestroy(self)
  self:ClearCompsByBook(compBook)
  self.doTextTween = nil
  base.OnDestroy(self)
end

local function SetData(self, dialog)
  self.txtName:SetLocalText(dialog)
end

local function DoText(self, dialog, duration)
  if self.doTextTween then
    self.doTextTween:Kill()
  end
  self.txtName:SetAlpha(0)
  self:SetData(dialog)
  self.doTextTween = self.txtName:DOFade(1, duration / 1000)
end

local function CompleteDoText(self)
  if self.doTextTween then
    self.doTextTween:Complete()
    self.doTextTween = nil
  end
  self.txtName:SetAlpha(1)
end

UILWComicSpineDialogTextItem.OnCreate = OnCreate
UILWComicSpineDialogTextItem.OnDestroy = OnDestroy
UILWComicSpineDialogTextItem.SetData = SetData
UILWComicSpineDialogTextItem.DoText = DoText
UILWComicSpineDialogTextItem.CompleteDoText = CompleteDoText
return UILWComicSpineDialogTextItem
