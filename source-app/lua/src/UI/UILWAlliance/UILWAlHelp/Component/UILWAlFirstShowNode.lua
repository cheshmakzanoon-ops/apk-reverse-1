local UILWAlFirstShowNode = BaseClass("UILWAlFirstShowNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.UILWAlliance.UILWAlHelp.Component.AllianceFirstShowTips"
local PrefabPath = "Assets/Main/Prefabs/UI/UILWAllianceBuildingTips/AllianceFirstShowTips.prefab"

function UILWAlFirstShowNode:OnCreate()
  self.isShow = false
  base.OnCreate(self)
end

function UILWAlFirstShowNode:OnDestroy()
  self.isShow = nil
  if self.firstShowTips then
    self:RemoveAsyncComponent(self.firstShowTips)
    self.firstShowTips = nil
  end
  if self.firstShowTipsScaleTween then
    self.firstShowTipsScaleTween:Kill()
    self.firstShowTipsScaleTween = nil
  end
  base.OnDestroy(self)
end

function UILWAlFirstShowNode:OnEnable()
  base.OnEnable(self)
end

function UILWAlFirstShowNode:OnDisable()
  base.OnDisable(self)
end

function UILWAlFirstShowNode:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlFirstShowNode:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlFirstShowNode:OnRefreshShow()
  if not LuaEntry.Player:IsFirstJoinAlliance() then
    self:TrySetShow(false)
    return
  end
  if LuaEntry.Player.AllianceFirstShowTips then
    self:TrySetShow(false)
    return
  end
  self:TrySetShow(true)
end

function UILWAlFirstShowNode:TrySetShow(bool)
  if bool then
    self.holder:TrySetShow(MainAlBubbleType.FirstShow, true)
  elseif self.isShow and self.firstShowTips and IsNotNull(self.firstShowTips.gameObject) then
    self.firstShowTipsScaleTween = DOTween.Sequence()
    self.firstShowTipsScaleTween:Append(self.firstShowTips:OnPlayHideAnim())
    self.firstShowTipsScaleTween:AppendInterval(0.5)
    
    function self.firstShowTipsScaleTween.onComplete()
      self.firstShowTipsScaleTween = nil
      if not bool and self then
        self:SetShow(false)
      end
      if self and self.holder then
        self.holder:TrySetShow(MainAlBubbleType.FirstShow, false)
      end
    end
  else
    if not bool then
      self:SetShow(false)
    end
    self.holder:TrySetShow(MainAlBubbleType.FirstShow, false)
  end
end

function UILWAlFirstShowNode:SetShow(bool)
  if bool then
    if self.firstShowTips == nil then
      self.firstShowTips = self:LoadComponentAsync(LuaPath, PrefabPath)
    end
    if self.firstShowTips ~= nil then
      self.firstShowTips:SetActive(true)
    end
    self.isShow = true
  else
    if self.firstShowTips then
      self:RemoveAsyncComponent(self.firstShowTips)
      self.firstShowTips = nil
    end
    if self.firstShowTipsScaleTween then
      self.firstShowTipsScaleTween:Kill()
      self.firstShowTipsScaleTween = nil
    end
    self.isShow = false
  end
end

return UILWAlFirstShowNode
