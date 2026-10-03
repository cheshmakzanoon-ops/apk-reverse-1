local base = UIBaseContainer
local BountyHunterMainRewardShowComponent = BaseClass("BountyHunterMainRewardShowComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function BountyHunterMainRewardShowComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BountyHunterMainRewardShowComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BountyHunterMainRewardShowComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compMainRewardShowContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.resItemReqs = {}
end

function BountyHunterMainRewardShowComponent:ComponentDestroy()
  self:ClearRewards()
  self.viewSkin = nil
  self.compMainRewardShowContent = nil
end

function BountyHunterMainRewardShowComponent:DataDefine()
end

function BountyHunterMainRewardShowComponent:DataDestroy()
end

function BountyHunterMainRewardShowComponent:OnAddListener()
  base.OnAddListener(self)
end

function BountyHunterMainRewardShowComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BountyHunterMainRewardShowComponent:SetRewards(rewards)
  self:ClearRewards()
  if not table.IsNullOrEmpty(rewards) then
    local totalCount = #rewards
    for i, v in ipairs(rewards) do
      self.resItemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compMainRewardShowContent.transform)
        go.name = i
        local cell = self.compMainRewardShowContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(v)
        cell.rectTransform:Set_localScale(0.6, 0.6, 0.6)
        cell.rectTransform:Set_sizeDelta(150, 150)
        if CommonUtil.IsArabicAutoMirrorOpen() then
          cell.rectTransform:Set_pivot(1, 1)
        else
          cell.rectTransform:Set_pivot(0, 1)
        end
        if i == totalCount then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compMainRewardShowContent.rectTransform)
          self.compMainRewardShowContent:SetActive(false)
          self.compMainRewardShowContent:SetActive(true)
        end
      end)
    end
  end
end

function BountyHunterMainRewardShowComponent:Show()
  self:SetActive(true)
end

function BountyHunterMainRewardShowComponent:Hide()
  self:SetActive(false)
end

function BountyHunterMainRewardShowComponent:ClearRewards()
  if self.resItemReqs then
    for i, v in ipairs(self.resItemReqs) do
      v:Destroy()
    end
  end
  self.resItemReqs = {}
  self.compMainRewardShowContent:RemoveAllComponentes(UICommonResItem)
end

return BountyHunterMainRewardShowComponent
