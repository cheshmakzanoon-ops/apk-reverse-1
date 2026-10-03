local base = UIBaseContainer
local UIBFDsbDuelActRulesGroupRulesDetail = BaseClass("UIBFDsbDuelActRulesGroupRulesDetail", UIBaseContainer)
local UIBFDsbDuelActRulesGroupRulesDetailItem1 = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesGroupRulesDetailItem1")
local UIBFDsbDuelActRulesGroupRulesDetailItem2 = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesGroupRulesDetailItem2")
local Localization = CS.GameEntry.Localization
local groupRulesDetailItem1PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Rules/UIBFDsbDuelActRulesGroupRulesDetailItem1.prefab"
local groupRulesDetailItem2PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Rules/UIBFDsbDuelActRulesGroupRulesDetailItem2.prefab"

function UIBFDsbDuelActRulesGroupRulesDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActRulesGroupRulesDetail:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesGroupRulesDetail:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.scrollRectScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 2)
end

function UIBFDsbDuelActRulesGroupRulesDetail:ComponentDestroy()
  self:ClearAllItems()
  self.viewSkin = nil
  self.compContent = nil
  self.scrollRectScrollView = nil
  self.dataList = nil
end

function UIBFDsbDuelActRulesGroupRulesDetail:DataDefine()
  self.dataList = {}
end

function UIBFDsbDuelActRulesGroupRulesDetail:DataDestroy()
  self.dataList = nil
end

function UIBFDsbDuelActRulesGroupRulesDetail:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActRulesGroupRulesDetail:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesGroupRulesDetail:UpdateData(dataList)
  if not dataList then
    return
  end
  self.dataList = dataList
  self:RefreshList()
end

function UIBFDsbDuelActRulesGroupRulesDetail:ClearAllItems()
  if self.itemReqs then
    for k, v in ipairs(self.itemReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.itemReqs = {}
  self.compContent:RemoveComponents(UIBFDsbDuelActRulesGroupRulesDetailItem1)
  self.compContent:RemoveComponents(UIBFDsbDuelActRulesGroupRulesDetailItem2)
  self.itemList = {}
end

function UIBFDsbDuelActRulesGroupRulesDetail:RefreshList()
  self:ClearAllItems()
  if not table.IsNullOrEmpty(self.dataList) then
    for i, data in ipairs(self.dataList) do
      local prefabPath, script
      if data.sub_type == BattlefieldDsbConst.BF_DSB_GUIDE_TYPE2_SUBTYPE.OnlyPicture then
        prefabPath = groupRulesDetailItem1PrefabPath
        script = UIBFDsbDuelActRulesGroupRulesDetailItem1
      elseif data.sub_type == BattlefieldDsbConst.BF_DSB_GUIDE_TYPE2_SUBTYPE.PicAndText then
        prefabPath = groupRulesDetailItem2PrefabPath
        script = UIBFDsbDuelActRulesGroupRulesDetailItem2
      else
        Logger.LogError("UIBFDsbDuelActRulesGroupRulesDetail.InitItem: sub_type error")
        goto lbl_49
      end
      local idx = i
      local req = self:GameObjectInstantiateAsync(prefabPath, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "item" .. idx
        item:SetActive(true)
        item.transform:SetParent(self.compContent.transform)
        item.transform:Set_localScale(1, 1, 1)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = self.compContent:AddComponent(script, item.name)
        cell:SetData(data, idx)
        table.insert(self.itemList, cell)
        if idx == self.view.extParam then
          TimerManager:GetInstance():DelayInvoke(function()
            self.compContent:SetAnchoredPositionXY(0, self:GetJumpContentY(idx))
          end, 0.2)
        end
      end)
      table.insert(self.itemReqs, req)
      ::lbl_49::
    end
  end
end

function UIBFDsbDuelActRulesGroupRulesDetail:GetJumpContentY(jumpIndex)
  return 423 * (jumpIndex - 1)
end

return UIBFDsbDuelActRulesGroupRulesDetail
