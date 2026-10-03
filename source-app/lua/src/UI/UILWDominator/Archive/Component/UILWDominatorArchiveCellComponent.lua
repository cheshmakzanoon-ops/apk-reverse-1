local base = UIBaseContainer
local UILWDominatorArchiveCellComponent = BaseClass("UILWDominatorArchiveCellComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorArchiveCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorArchiveCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorArchiveCellComponent:ReInit(template, uuid)
  self.template = template
  self.uuid = uuid
  if self.template == nil then
    return
  end
  self.imgIcon:LoadSprite(self.template.button_pic)
  self.textName:SetText(Localization:GetString(self.template.button_key))
  local state = DataCenter.DominatorManager:GetArchiveState(self.uuid, self.template.id)
  if state == DominatorArchiveState.Locked then
    self.compLock:SetActive(true)
    self.compGray:SetActive(true)
    self.imgIcon:SetGrayNotRecursively(true)
    self.compEffect:SetActive(false)
    self.anim:Play("box_unOpen", 0, 0)
    self.compRed:SetActive(false)
  elseif state == DominatorArchiveState.CanUnlock then
    self.compLock:SetActive(false)
    self.compGray:SetActive(false)
    self.imgIcon:SetGrayNotRecursively(false)
    self.compEffect:SetActive(true)
    self.anim:Play("box_open", 0, 0)
    self.compRed:SetActive(true)
  elseif state == DominatorArchiveState.Unlocked then
    self.compLock:SetActive(false)
    self.compGray:SetActive(false)
    self.imgIcon:SetGrayNotRecursively(false)
    self.compEffect:SetActive(false)
    self.anim:Play("box_unOpen", 0, 0)
    self.compRed:SetActive(false)
  end
end

function UILWDominatorArchiveCellComponent:ComponentDefine()
  self.btnArchiveCell = self:AddComponent(UIButton, "")
  self.btnArchiveCell:SetOnClick(function()
    self:OnBtnArchiveCellClick()
  end)
  self.btnArchiveCell:SetSafeClickMode(true)
  self.anim = self:AddComponent(UIAnimator, "Content")
  self.compEffect = self:AddComponent(UIBaseContainer, "Effect")
  self.imgIcon = self:AddComponent(UIImage, "Content/Icon")
  self.textName = self:AddComponent(UIText, "Content/NameText")
  self.compLock = self:AddComponent(UIBaseContainer, "Lock")
  self.compGray = self:AddComponent(UIBaseContainer, "Content/Icon/Gray")
  self.compRed = self:AddComponent(UIBaseContainer, "Content/Red")
end

function UILWDominatorArchiveCellComponent:ComponentDestroy()
  self.btnArchiveCell = nil
  self.anim = nil
  self.imgIcon = nil
  self.textName = nil
  self.compLock = nil
  self.compGray = nil
  self.compEffect = nil
  self.compRed = nil
end

function UILWDominatorArchiveCellComponent:DataDefine()
end

function UILWDominatorArchiveCellComponent:DataDestroy()
end

function UILWDominatorArchiveCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorArchiveCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorArchiveCellComponent:OnBtnArchiveCellClick()
  if self.template and self.uuid then
    local state = DataCenter.DominatorManager:GetArchiveState(self.uuid, self.template.id)
    if state == DominatorArchiveState.Unlocked then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorArchiveDetail, {anim = true}, self.template.id)
    elseif state == DominatorArchiveState.CanUnlock then
      DataCenter.DominatorManager:SendUnlockArchiveMessage(self.uuid, self.template.id)
    elseif state == DominatorArchiveState.Locked and self.template.type == 1 then
      UIUtil.ShowTips(self.template:GetLockedTipsText())
    end
  end
end

return UILWDominatorArchiveCellComponent
