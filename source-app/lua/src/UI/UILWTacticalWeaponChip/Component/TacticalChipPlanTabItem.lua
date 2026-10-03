local TacticalChipPlanTabItem = BaseClass("TacticalChipPlanTabItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local un_select_flag_path = "unSelectFlag"
local select_flag_path = "selectFlag"
local btn_path = "btn"
local un_select_title_path = "unSelectFlag/unSelectTitle"
local select_title_path = "selectFlag/selectTitle"
local red_dot_path = "RedDot"
local vfx_unlock_path = "vfxUnlock"
local lock_flag_path = "lockFlag"
local AnimationNames = {
  Lock = "V_ui_TacticalChipPlanTabItem_lock",
  Select = "V_ui_TacticalChipPlanTabItem_select",
  UnLock = "V_ui_TacticalChipPlanTabItem_unlock"
}
local DELAY_PLAY_UNLOCK_VFX_FRAME = 36

function TacticalChipPlanTabItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TacticalChipPlanTabItem:OnDestroy()
  if self.vfxTimer then
    self.vfxTimer:Stop()
    self.vfxTimer = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalChipPlanTabItem:OnAddListener()
  base.OnAddListener(self)
end

function TacticalChipPlanTabItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TacticalChipPlanTabItem:TryUnlock()
  if self.isUnlock == true then
    return
  end
  local isUnlock = DataCenter.TacticalChipManager:IsPlanUnlock(self.tabId)
  if isUnlock == true then
    self.animator:Play(AnimationNames.UnLock)
    self.vfxTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
      self.vfx_unlock:Replay()
      self:ForceRefreshUnlockStatus()
    end, DELAY_PLAY_UNLOCK_VFX_FRAME)
    self.isUnlock = isUnlock
  end
end

function TacticalChipPlanTabItem:ForceRefreshUnlockStatus()
  local isUnlock = DataCenter.TacticalChipManager:IsPlanUnlock(self.tabId)
  self.lock_flag:SetActive(not isUnlock)
end

function TacticalChipPlanTabItem:ComponentDefine()
  self.un_select_flag = self:AddComponent(UIBaseContainer, un_select_flag_path)
  self.select_flag = self:AddComponent(UIBaseContainer, select_flag_path)
  self.selectTitle = self:AddComponent(UITextMeshProUGUIEx, select_title_path)
  self.unSelectTitle = self:AddComponent(UITextMeshProUGUIEx, un_select_title_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if self.clickHandler then
      if self.customHolder then
        self.clickHandler(self.customHolder, self)
      else
        self.clickHandler(self.holder, self)
      end
    end
  end)
  self.red_dot = self:TryAddComponent(UIBaseContainer, red_dot_path)
  self:SetRedDotVisible(false)
  self.vfx_unlock = self:AddComponent(UIVfx, vfx_unlock_path)
  self.lock_flag = self:AddComponent(UIImage, lock_flag_path)
  self.animator = self:AddComponent(UIAnimator, "")
end

function TacticalChipPlanTabItem:ComponentDestroy()
  self.un_select_flag = nil
  self.select_flag = nil
  self.selectTitle = nil
  self.unSelectTitle = nil
  self.btn = nil
  self.clickHandler = nil
  self.containPanel = nil
  self.tabId = nil
end

function TacticalChipPlanTabItem:ReInit(param)
  if param == nil then
    Logger.LogError("need param with 'clickHandler' and 'titleId' and 'c")
    return
  end
  self.tabId = param.tabId
  self.title = param.title
  self.clickHandler = param.clickHandler
  self.containPanel = param.containPanel
  self.customHolder = param.customHolder
  self.selectTitle:SetText(param.title)
  self.unSelectTitle:SetText(param.title)
  self.isUnlock = DataCenter.TacticalChipManager:IsPlanUnlock(self.tabId)
  if self.isUnlock == false then
    self.animator:Play(AnimationNames.Lock)
  end
  self.lock_flag:SetActive(not self.isUnlock)
end

function TacticalChipPlanTabItem:RefreshStatus()
  self.isUnlock = DataCenter.TacticalChipManager:IsPlanUnlock(self.tabId)
  self.lock_flag:SetActive(not self.isUnlock)
end

function TacticalChipPlanTabItem:BindUnlockVfx()
  if self.isUnlock == false then
    self.vfx_unlock:PreLoad(VfxAssets.TacticalChipPlanItemUnlock)
  end
end

function TacticalChipPlanTabItem:IsUnlock()
  return self.isUnlock
end

function TacticalChipPlanTabItem:SetSelect(visible)
  self.select_flag:SetActive(visible)
  self.un_select_flag:SetActive(not visible)
  if self.containPanel then
    self.containPanel:SetActive(visible)
  end
  if visible then
    self.animator:Play(AnimationNames.Select)
  end
end

function TacticalChipPlanTabItem:SetRedDotVisible(visible)
  if self.red_dot then
    self.red_dot.gameObject:SetActive(visible)
  end
end

return TacticalChipPlanTabItem
