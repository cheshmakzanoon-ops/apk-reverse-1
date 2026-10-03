local UIMainActivityTips = BaseClass("UIMainActivityTips", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TipType = {
  Common = 1,
  AllyDuel = 2,
  SiegeSuccess = 3,
  AllyDuelNew = 4
}
local TipPrefabPath = {
  [TipType.Common] = "Assets/Main/Prefabs/UI/LWMainUI/CommonTIps.prefab",
  [TipType.AllyDuel] = "Assets/Main/Prefabs/UI/LWMainUI/AllyDuelTips.prefab",
  [TipType.SiegeSuccess] = "Assets/Main/Prefabs/UI/LWMainUI/SiegeSuccessTips.prefab",
  [TipType.AllyDuelNew] = "Assets/Main/Prefabs/UI/LWMainUI/AllyDuelNewTips.prefab"
}
local TipScript = {
  [TipType.Common] = require("UI.LWMainUI.Component.UIMainTop.UIMainCommonTips"),
  [TipType.AllyDuel] = require("UI.LWMainUI.Component.UIMainTop.UIMainAllyDuelTips"),
  [TipType.SiegeSuccess] = require("UI.LWMainUI.Component.UIMainTop.UIMainSiegeSuccessTips"),
  [TipType.AllyDuelNew] = require("UI.LWMainUI.Component.UIMainTop.UIMainAllyDuelNewTips")
}

function UIMainActivityTips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainActivityTips:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainActivityTips:OnEnable()
  base.OnEnable(self)
end

function UIMainActivityTips:OnDisable()
  base.OnDisable(self)
  self.meta = nil
end

function UIMainActivityTips:ComponentDefine()
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self.bg:SetActive(false)
  self.tips = {}
  self.reqs = {}
end

function UIMainActivityTips:ComponentDestroy()
  if self.req then
    for _, v in pairs(self.req) do
      v:Destroy()
    end
  end
  self.req = {}
  self.tips = {}
end

function UIMainActivityTips:DataDefine()
end

function UIMainActivityTips:DataDestroy()
  self.meta = nil
  self.countdown = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainActivityTips:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnMainUITipsQueueCreate, self.OnMainUITipsQueueCreate)
  self:AddUIListener(EventId.OnAfterWindowDestroy, self.OnAfterWindowDestroy)
end

function UIMainActivityTips:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnMainUITipsQueueCreate, self.OnMainUITipsQueueCreate)
  self:RemoveUIListener(EventId.OnAfterWindowDestroy, self.OnAfterWindowDestroy)
end

function UIMainActivityTips:OnAfterWindowDestroy()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:CheckShowTips()
  end, 1)
end

function UIMainActivityTips:OnMainUITipsQueueCreate()
  self:CheckShowTips()
end

function UIMainActivityTips:Refresh()
  DataCenter.ActivityTipsManager:OnMainUIRefresh()
  self:CheckShowTips()
end

function UIMainActivityTips:CheckShowTips()
  if not self.view then
    return
  end
  if self.meta then
    return
  end
  if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
    return
  end
  if not DataCenter.UIPopWindowManager:IsQueueEmpty() then
    return
  end
  for i = 1, table.count(MainUITipType) do
    local needShow = DataCenter.ActivityTipsManager:GetNext()
    if not needShow then
      return
    end
    local worldPos = self.view:GetBtnPosByType(needShow.type)
    if worldPos then
      self.transform.position = worldPos
      self.meta = needShow
      self.bg:SetActive(true)
      self:RefreshView()
      self.countdown = 5
      DataCenter.ActivityTipsManager:Dequeue()
      DataCenter.ActivityTipsManager:RecordSeenTip(self.meta)
      return
    else
      DataCenter.ActivityTipsManager:Dequeue()
    end
  end
  self.bg:SetActive(false)
end

function UIMainActivityTips:RefreshView()
  local condition = self.meta.condition
  local tipType = TipType.Common
  if condition == MainUITipCondition.AllyDuel4 or condition == MainUITipCondition.AllyDuel5 then
    if DataCenter.LeagueMatchManager:BNewPop() then
      tipType = TipType.AllyDuelNew
    else
      tipType = TipType.AllyDuel
    end
  elseif condition == MainUITipCondition.CityWarSuccess then
    tipType = TipType.SiegeSuccess
  end
  for _, v in pairs(self.tips) do
    v:SetActive(false)
  end
  if self.tips[tipType] then
    self.tips[tipType]:SetActive(true)
    self.tips[tipType]:Refresh(self.meta)
  elseif not self.reqs[tipType] then
    self.reqs[tipType] = self:GameObjectInstantiateAsync(TipPrefabPath[tipType], function(req)
      local gameObject = req.gameObject
      if IsNull(gameObject) then
        return
      end
      local transform = gameObject.transform
      gameObject:SetActive(true)
      transform:SetParent(self.bg.transform)
      transform:Set_localScale(1, 1, 1)
      local name = gameObject.name
      self.tips[tipType] = self.bg:AddComponent(TipScript[tipType], name)
      self.tips[tipType]:SetAnchoredPositionXY(0, 0)
      if self.meta then
        self.tips[tipType]:Refresh(self.meta)
      end
    end)
  end
end

function UIMainActivityTips:Update1000MS()
  if self.meta and self.countdown and self.countdown > 0 then
    self.countdown = self.countdown - 1
    if self.countdown <= 0 then
      self.meta = nil
      self.bg:SetActive(false)
      self:CheckShowTips()
    end
  end
end

function UIMainActivityTips:InterruptTips()
  self.meta = nil
  self.bg:SetActive(false)
end

function UIMainActivityTips:OnBtnClick()
  DataCenter.ActivityTipsManager:OnBtnClick(self.meta)
end

return UIMainActivityTips
