local base = UIAsyncContainer
local LLRewardTask = BaseClass("LLRewardTask", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local LLRewardTaskItem = require("UI.Landlord.Reward.Component.LLRewardTaskItem")
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/Reward/LLRewardTaskItem.prefab"

function LLRewardTask:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRewardTask:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRewardTask:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compReward = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compBox = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
end

function LLRewardTask:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.compReward = nil
  self.compBox = nil
end

function LLRewardTask:DataDefine()
  self.reqs = {}
  self.items = {}
  self.rewardInfos = {}
end

function LLRewardTask:DataDestroy()
  if self.delayRefresh then
    self.delayRefresh:Stop()
    self.delayRefresh = nil
  end
  self.llProgressComp = nil
  self.reqs = nil
  self.items = nil
  self.rewardInfos = nil
  self.camp = nil
  self.scrollRect = nil
  self.openTargetId = nil
end

function LLRewardTask:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordActBattleInfo, self.RefreshItems)
  self:AddUIListener(EventId.LandlordTaskBoxClick, self.OnBoxClick)
end

function LLRewardTask:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordActBattleInfo, self.RefreshItems)
  self:RemoveUIListener(EventId.LandlordTaskBoxClick, self.OnBoxClick)
  base.OnRemoveListener(self)
end

function LLRewardTask:SetCamp(camp, scrollRect, openTargetId)
  self.camp = camp
  self.scrollRect = scrollRect
  self.openTargetId = openTargetId
  self:RefreshView()
end

function LLRewardTask:UpdateData()
  if self.camp == nil then
    return
  end
  if self.llProgressComp == nil then
    self.llProgressComp = self:LoadComponentAsync(LLConst.CLS_MINIMAP_PROGRESS, LLConst.PREFAB_MINIMAP_PROGRESS, self.compBox, function()
      if self.llProgressComp then
        local _, h1 = self.compBox:GetSizeDeltaXY()
        local _, h2 = self.llProgressComp:GetSizeDeltaXY()
        self.llProgressComp:SetAnchoredPositionXY(0, (h1 - h2) * 0.5 + 15)
      end
    end)
  end
  self.llProgressComp:SetCamp(self.camp, false, false)
  self:RefreshItems()
end

function LLRewardTask:RefreshItems()
  if self.camp == nil then
    return
  end
  self.curStage = ActMgr:GetActCurStage()
  self.rewardInfos = DeepCopy(ActMgr:GetReward(LLConst.RewardType.Week, self.camp))
  table.sort(self.rewardInfos, function(configA, configB)
    local stateA = ActMgr:CheckWeekRewardState(configA, self.camp)
    local stateB = ActMgr:CheckWeekRewardState(configB, self.camp)
    if stateA ~= stateB then
      if stateA == 1 then
        return true
      end
      if stateA == 0 then
        return false
      end
      if stateB == 1 then
        return false
      end
      if stateB == 0 then
        return true
      end
    end
    return configA.id < configB.id
  end)
  self.reqs = self.reqs or {}
  local max = math.max(#self.reqs, #self.rewardInfos)
  for i = 1, max do
    local idx = i
    local info = self.rewardInfos[idx]
    local req = self.reqs[idx]
    local item = self.items[idx]
    if info ~= nil then
      if req == nil then
        self.reqs[idx] = self:GameObjectInstantiateAsync(PREFAB, function(req)
          if req.isError or IsNull(req.gameObject) then
            self.reqs[idx] = nil
            self.items[idx] = nil
            return
          end
          local go = req.gameObject
          go.name = "TaskItem" .. idx
          local tf = go.transform
          tf:SetParent(self.compReward.transform)
          tf:Reset()
          item = self.compReward:AddComponent(LLRewardTaskItem, go.name)
          self.items[idx] = item
          self:RefreshOneItem(idx)
        end)
      elseif item ~= nil then
        self:RefreshOneItem(idx)
      end
    elseif req ~= nil then
      req:Destroy()
      self.reqs[idx] = nil
      self.items[idx] = nil
    end
  end
end

function LLRewardTask:RefreshOneItem(idx)
  local item = self.items[idx]
  local info = self.rewardInfos[idx]
  if item == nil then
    return
  end
  item:SetActive(true)
  item:SetData(info, self.camp, self.curStage)
  if self.delayRefresh then
    self.delayRefresh:Stop()
    self.delayRefresh = nil
  end
  self.delayRefresh = TimerManager:GetInstance():DelayFrameInvoke(function()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compReward.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform.parent)
    self.delayRefresh = nil
    self:ShowTarget()
  end, 3)
end

function LLRewardTask:OnBoxClick(tagetId)
  self.openTargetId = tagetId
  self:ShowTarget()
end

function LLRewardTask:ShowTarget()
  if self.openTargetId == nil then
    return
  end
  for _, v in ipairs(self.items) do
    v:CleanFade()
  end
  local toPos = 1
  for i, v in ipairs(self.rewardInfos) do
    if v.id == self.openTargetId then
      local target = self.items[i]
      target:ShowHigh()
      local space = 10
      local _, h1 = self.compBox:GetSizeDeltaXY()
      local _, h2 = self.textDesc:GetSizeDeltaXY()
      local _, h3 = target:GetSizeDeltaXY()
      local _, h = self:GetSizeDeltaXY()
      local y = h - h1 - space - h2 - space - (h3 + 5) * (i - 1)
      toPos = y / h
      toPos = Mathf.Clamp01(toPos)
      break
    end
  end
  self.scrollRect:AnimVerticalNormalizedPos(toPos, 0.3)
  self.openTargetId = nil
end

return LLRewardTask
