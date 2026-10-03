local AllianceFirstShowTips = BaseClass("AllianceFirstShowTips", UIAsyncContainer)
local base = UIAsyncContainer

function AllianceFirstShowTips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceFirstShowTips:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceFirstShowTips:OnClickClose()
  self.showTime = nil
  LuaEntry.Player.AllianceFirstShowTips = true
  EventManager:GetInstance():Broadcast(EventId.RefreshMainAlEvent)
end

function AllianceFirstShowTips:ComponentDefine()
  self.animator = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
  self.canvasGroup = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.bg1 = self:AddComponent(UIButton, "root/bg1")
  self.bg1:SetOnClick(function()
    self:OnClickClose()
  end)
  self.root = self:AddComponent(UIBaseComponent, "root")
end

function AllianceFirstShowTips:OnPlayHideAnim()
  self.animator:Play("V_ui_llianceFirstShowTips_out", 0, 0)
end

function AllianceFirstShowTips:ComponentDestroy()
end

function AllianceFirstShowTips:DataDefine()
  self.showTime = 3
end

function AllianceFirstShowTips:DataDestroy()
end

function AllianceFirstShowTips:OnEnable()
  base.OnEnable(self)
end

function AllianceFirstShowTips:OnDisable()
  base.OnDisable(self)
end

function AllianceFirstShowTips:OnAddListener()
  base.OnAddListener(self)
end

function AllianceFirstShowTips:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceFirstShowTips:Update100MS()
  if not self.showTime then
    return
  end
  if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
    self.root:SetActive(false)
    return
  end
  self.root:SetActive(true)
  self.showTime = self.showTime - 0.1
  if self.showTime <= 0 then
    self:OnClickClose()
  end
end

return AllianceFirstShowTips
