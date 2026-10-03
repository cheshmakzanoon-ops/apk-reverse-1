local base = UIAsyncContainer
local LLRuleStage = BaseClass("LLRuleStage", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local CLS = "UI.Landlord.Rule.Component.LLRuleStageItem"
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/Rule/LLRuleStageItem.prefab"

function LLRuleStage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRuleStage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRuleStage:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 1)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compItemContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.imgProgressBg = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgProgress = self.viewSkin:AddComponent(self, UIImage, 5)
end

function LLRuleStage:ComponentDestroy()
  self.viewSkin = nil
  self.scrollRect = nil
  self.compContent = nil
  self.compItemContent = nil
  self.imgProgressBg = nil
  self.imgProgress = nil
end

function LLRuleStage:DataDefine()
  self.itemList = {}
  local curStageInfo = ActMgr:GetActCurStageInfo()
  self.curIdx = curStageInfo ~= nil and curStageInfo.idx or 2
  self.compContent:SetAnchoredPositionXY(0, 0)
end

function LLRuleStage:DataDestroy()
  self.itemList = nil
  self.guideList = nil
end

function LLRuleStage:OnAddListener()
  base.OnAddListener(self)
end

function LLRuleStage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRuleStage:SetInfo(idx, subIdx)
  self.idx = idx
  self.subIdx = subIdx
  self.guideList = ActMgr:GetGuide(self.idx)
  self:RefreshView()
end

function LLRuleStage:UpdateData()
  if self.guideList == nil then
    return
  end
  local cnt = 0
  for i, guide in ipairs(self.guideList) do
    local item = self.itemList[i]
    if item == nil then
      item = self:LoadComponentAsync(CLS, PREFAB, self.compItemContent, function()
        item:SetName("Item_" .. i)
        item:SetData(guide, self.curIdx)
        cnt = cnt + 1
        self:CheckFinish(cnt)
      end)
      self.itemList[i] = item
    elseif item:AsyncLoadDone() then
      item:SetData(guide, self.curIdx)
      cnt = cnt + 1
      self:CheckFinish(cnt)
    end
  end
end

function LLRuleStage:CheckFinish(cnt)
  local count = #self.guideList
  if cnt ~= count then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compItemContent.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollRect.transform)
  local h = 0
  local jumpPosY = 0
  for i, item in ipairs(self.itemList) do
    if i < count then
      h = h + item.rectTransform.rect.height + 10
    end
    if i + 1 == self.curIdx then
      jumpPosY = h
    end
  end
  self.imgProgressBg:SetSizeDeltaXY(37, h)
  self.imgProgressBg:SetAnchoredPositionXY(15, -80)
  self.imgProgress:SetSizeDeltaXY(37, jumpPosY)
  local scrollH = self.scrollRect.rectTransform.rect.height
  local contentH = self.compItemContent.rectTransform.rect.height
  local maxJump = math.max(0, contentH - scrollH)
  if jumpPosY > maxJump then
    jumpPosY = maxJump
  end
  self.compContent:SetAnchoredPositionXY(0, jumpPosY)
end

return LLRuleStage
