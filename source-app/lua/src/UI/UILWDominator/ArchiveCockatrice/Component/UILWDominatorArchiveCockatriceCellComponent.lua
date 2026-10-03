local base = UIBaseContainer
local UILWDominatorArchiveCockatriceCellComponent = BaseClass("UILWDominatorArchiveCockatriceCellComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorArchiveCockatriceCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorArchiveCockatriceCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorArchiveCockatriceCellComponent:ReInit(template, uuid, index)
  self.template = template
  self.uuid = uuid
  self.index = index
  if self.template == nil then
    return
  end
  self.imgIcon:LoadSprite(self.template.button_pic)
  self.textName:SetText(Localization:GetString(self.template.button_key))
  local state = DataCenter.DominatorManager:GetArchiveState(self.uuid, self.template.id)
  if state == DominatorArchiveState.Locked then
    self.compLock:SetActive(true)
    self.imgIcon:SetActive(false)
    self.compEffect:SetActive(false)
    self.anim:Play("box_unOpen", 0, 0)
    self.compRed:SetActive(false)
  elseif state == DominatorArchiveState.CanUnlock then
    self.compLock:SetActive(false)
    self.imgIcon:SetActive(true)
    self.compEffect:SetActive(true)
    self.anim:Play("box_open", 0, 0)
    self.compRed:SetActive(true)
  elseif state == DominatorArchiveState.Unlocked then
    self.compLock:SetActive(false)
    self.imgIcon:SetActive(true)
    self.compEffect:SetActive(false)
    self.anim:Play("box_unOpen", 0, 0)
    self.compRed:SetActive(false)
  end
  local numIconPath = self:GetNumImagePath(self.index)
  if not string.IsNullOrEmpty(numIconPath) then
    self.compLockNum:LoadSprite(numIconPath)
  end
end

function UILWDominatorArchiveCockatriceCellComponent:ComponentDefine()
  self.btnArchiveCell = self:AddComponent(UIButton, "")
  self.btnArchiveCell:SetOnClick(function()
    self:OnBtnArchiveCellClick()
  end)
  self.btnArchiveCell:SetSafeClickMode(true)
  self.anim = self:AddComponent(UIAnimator, "Content")
  self.compEffect = self:AddComponent(UIBaseContainer, "Effect")
  self.imgIcon = self:AddComponent(UIImage, "Content/Icon")
  self.textName = self:AddComponent(UIText, "Content/NameText")
  self.compLock = self:AddComponent(UIBaseContainer, "Content/Lock")
  self.compLockNum = self:AddComponent(UIImage, "Content/Lock/LockNum")
  self.compRed = self:AddComponent(UIBaseContainer, "Content/Red")
end

function UILWDominatorArchiveCockatriceCellComponent:ComponentDestroy()
  self.btnArchiveCell = nil
  self.anim = nil
  self.imgIcon = nil
  self.textName = nil
  self.compLock = nil
  self.compLockNum = nil
  self.compEffect = nil
  self.compRed = nil
end

function UILWDominatorArchiveCockatriceCellComponent:DataDefine()
end

function UILWDominatorArchiveCockatriceCellComponent:DataDestroy()
end

function UILWDominatorArchiveCockatriceCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorArchiveCockatriceCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorArchiveCockatriceCellComponent:OnBtnArchiveCellClick()
  if self.template and self.uuid then
    local state = DataCenter.DominatorManager:GetArchiveState(self.uuid, self.template.id)
    if state == DominatorArchiveState.Unlocked then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorArchiveDetailCockatrice, {anim = true}, self.template.id)
    elseif state == DominatorArchiveState.CanUnlock then
      DataCenter.DominatorManager:SendUnlockArchiveMessage(self.uuid, self.template.id)
    elseif state == DominatorArchiveState.Locked and self.template.type == 1 then
      UIUtil.ShowTips(self.template:GetLockedTipsText())
    end
  end
end

function UILWDominatorArchiveCockatriceCellComponent:GetNumImagePath(index)
  if index == 1 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorArchiveCockatrice/wxy_zhuzai_zhanying_weijiesuo1.png"
  elseif index == 2 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorArchiveCockatrice/wxy_zhuzai_zhanying_weijiesuo2.png"
  elseif index == 3 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorArchiveCockatrice/wxy_zhuzai_zhanying_weijiesuo3.png"
  elseif index == 4 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorArchiveCockatrice/wxy_zhuzai_zhanying_weijiesuo4.png"
  elseif index == 5 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorArchiveCockatrice/wxy_zhuzai_zhanying_weijiesuo5.png"
  elseif index == 6 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorArchiveCockatrice/wxy_zhuzai_zhanying_weijiesuo6.png"
  end
end

return UILWDominatorArchiveCockatriceCellComponent
