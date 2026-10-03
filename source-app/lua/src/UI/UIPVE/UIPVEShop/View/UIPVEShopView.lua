local UIPVEShopView = BaseClass("UIPVEShopView", UIBaseView)
local base = UIBaseView
local UIPVEShopCell = require("UI.UIPVE.UIPVEShop.Component.UIPVEShopCell")
local buff_list_go_path = "UIPVEShopPosGo/BuffListGo"
local guide_go_path = "GuideGo"

function UIPVEShopView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIPVEShopView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPVEShopView:ComponentDefine()
  self.buff_list_go = self:AddComponent(UIBaseContainer, buff_list_go_path)
  self.guide_go = self:AddComponent(UIBaseContainer, guide_go_path)
end

function UIPVEShopView:ComponentDestroy()
  self.buff_list_go = nil
  self.guide_go = nil
end

function UIPVEShopView:DataDefine()
  self.curPos = Vector3.New(0, 0, 0)
  self.list = {}
  self.param = {}
  self.isInGuide = false
end

function UIPVEShopView:DataDestroy()
  DataCenter.BattleLevel:SetArrowVisibleById(self.param.triggerPosId, true)
  self.curPos = nil
  self.list = nil
  self.param = {}
  self.isInGuide = false
end

function UIPVEShopView:OnEnable()
  base.OnEnable(self)
  self.isInGuide = DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.OpenBuyBuffShop, tostring(self.param.triggerId))
  if self.isInGuide then
    self:RefreshGuideSignal()
  end
end

function UIPVEShopView:OnDisable()
  base.OnDisable(self)
end

function UIPVEShopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PveFinishOneTrigger, self.OnPveFinishOneTriggerSignal)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.SetPveBuyBuffSShopEffectVisible, self.SetPveBuyBuffSShopEffectVisibleSignal)
end

function UIPVEShopView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PveFinishOneTrigger, self.OnPveFinishOneTriggerSignal)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.SetPveBuyBuffSShopEffectVisible, self.SetPveBuyBuffSShopEffectVisibleSignal)
end

function UIPVEShopView:ReInit()
  self.param = self:GetUserData()
  if self.param.buffTriggerList ~= nil then
    for k, v in ipairs(self.param.buffTriggerList) do
      local triggerId = self:GetShowTriggerId(k)
      if triggerId ~= nil then
        do
          local param = {}
          param.id = triggerId
          param.index = k
          self:GameObjectInstantiateAsync(UIAssets.UIPVEShopCell, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.buff_list_go.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(triggerId)
            go.name = nameStr
            local model = self.buff_list_go:AddComponent(UIPVEShopCell, nameStr)
            model:ReInit(param)
            self.list[k] = model
          end)
        end
      end
    end
  end
  DataCenter.BattleLevel:SetArrowVisibleById(self.param.triggerPosId, false)
  self.guide_go:SetActive(false)
  self:RefreshGuideSignal()
end

function UIPVEShopView:OnPveFinishOneTriggerSignal()
  self:Refresh()
end

function UIPVEShopView:Refresh()
  local canShow = false
  for k, v in pairs(self.list) do
    local triggerId = self:GetShowTriggerId(k)
    if triggerId ~= nil then
      v:Refresh(triggerId)
      canShow = true
    else
      v:SetActive(false)
    end
  end
  if not canShow then
    self.ctrl:CloseSelf()
    DataCenter.BattleLevel:RefreshBuildShop(self.param.id)
  end
end

function UIPVEShopView:GetShowTriggerId(index)
  if self.param.buffTriggerList ~= nil and self.param.buffTriggerList[index] ~= nil then
    local list = self.param.buffTriggerList[index]
    for k, v in ipairs(list) do
      local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(v)
      if trigger ~= nil and not trigger:IsTriggerOK() then
        return v
      end
    end
  end
end

function UIPVEShopView:GetWaitMovePosition()
  if self.param.wait_move_pos == nil then
    return self.param.buff_pos
  end
  return self.param.wait_move_pos
end

function UIPVEShopView:GetWorldPosition()
  return self.param.buff_pos
end

function UIPVEShopView:GetId()
  return self.param.id
end

function UIPVEShopView:GetTriggerPosId()
  return self.param.triggerPosId
end

function UIPVEShopView:RefreshGuideSignal()
  if DataCenter.GuideManager:InGuide() then
    if self.isInGuide then
      self.buff_list_go:SetActive(true)
    else
      self.buff_list_go:SetActive(false)
    end
  else
    self.buff_list_go:SetActive(true)
    self.guide_go:SetActive(false)
  end
end

function UIPVEShopView:SetPveBuyBuffSShopEffectVisibleSignal(param)
  if param ~= nil then
    local visible = tonumber(param)
    if visible == GuideSetNormalVisible.Show then
      self.guide_go:SetActive(true)
    elseif visible == GuideSetNormalVisible.Hide then
      self.guide_go:SetActive(false)
      self.isInGuide = false
    end
  end
end

return UIPVEShopView
