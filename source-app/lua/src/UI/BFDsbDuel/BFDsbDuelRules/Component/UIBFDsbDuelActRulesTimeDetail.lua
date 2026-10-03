local base = UIBaseContainer
local UIBFDsbDuelActRulesTimeDetail = BaseClass("UIBFDsbDuelActRulesTimeDetail", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelActRulesTimeDetailItem = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesTimeDetailItem")

function UIBFDsbDuelActRulesTimeDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActRulesTimeDetail:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesTimeDetail:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compScrollView = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compProgressBg = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compProgressImg = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compItemContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function UIBFDsbDuelActRulesTimeDetail:ComponentDestroy()
  self:ClearItems()
  self.viewSkin = nil
  self.compScrollView = nil
  self.compContent = nil
  self.compProgressBg = nil
  self.compProgressImg = nil
  self.compItemContent = nil
end

function UIBFDsbDuelActRulesTimeDetail:DataDefine()
end

function UIBFDsbDuelActRulesTimeDetail:DataDestroy()
end

function UIBFDsbDuelActRulesTimeDetail:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActRulesTimeDetail:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesTimeDetail:ClearItems()
  self.compItemContent:RemoveComponents(UIBFDsbDuelActRulesTimeDetailItem)
  if not table.IsNullOrEmpty(self.reqList) then
    for k, v in ipairs(self.reqList) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqList = {}
end

local BASE_H = 270

function UIBFDsbDuelActRulesTimeDetail:UpdateData(templateList)
  self:ClearItems()
  local count = 0
  local curIndex = BattlefieldDsbDuelUtils.ActInfo:GetCurrentBigPhaseIndex()
  if curIndex >= BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.Group then
    curIndex = curIndex - 1
  end
  if not table.IsNullOrEmpty(templateList) then
    count = #templateList
    for k, v in ipairs(templateList) do
      local idx = k
      self.reqList[k] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Rules/UIBFDsbDuelActRulesTimeDetailItem.prefab", function(req)
        if req.isError then
          return
        end
        local go = req.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compItemContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "item" .. idx
        local cell = self.compItemContent:AddComponent(UIBFDsbDuelActRulesTimeDetailItem, go.name)
        cell:SetData(templateList[idx], curIndex)
      end)
    end
  end
  self.compProgressBg:SetAnchoredPositionXY(40, -90)
  self.compProgressBg:SetSizeDeltaXY(37, math.max(0, BASE_H * (count - 1)))
  self.compProgressImg:SetSizeDeltaXY(37, math.max(0, BASE_H * (curIndex - 1)))
end

return UIBFDsbDuelActRulesTimeDetail
