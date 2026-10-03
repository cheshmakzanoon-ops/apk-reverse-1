local base = UIBaseContainer
local LWUICommonActivityRulesPicGuidePanelComponent = BaseClass("LWUICommonActivityRulesPicGuidePanelComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LWUICommonActivityRulesPicGuideItemComponent = require("UI/ActivityCommon/LWUICommonActivityRules/PicGuide/LWUICommonActivityRulesPicGuideItemComponent")

function LWUICommonActivityRulesPicGuidePanelComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICommonActivityRulesPicGuidePanelComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICommonActivityRulesPicGuidePanelComponent:ComponentDefine()
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.btnMoveNext = self:AddComponent(UIButton, "MoveNextBtn")
  self.btnMoveNext:SetOnClick(function()
    self:OnBtnMoveNextClick()
  end)
  self.compScrollView = self:AddComponent(UIBaseComponent, "ScrollView")
end

function LWUICommonActivityRulesPicGuidePanelComponent:ComponentDestroy()
  self:ClearItems()
  self.compContent = nil
  self.btnMoveNext = nil
  self.compScrollView = nil
end

function LWUICommonActivityRulesPicGuidePanelComponent:DataDefine()
  self.items = {}
  self.reqs = {}
end

function LWUICommonActivityRulesPicGuidePanelComponent:DataDestroy()
  self.items = nil
  self.reqs = nil
end

function LWUICommonActivityRulesPicGuidePanelComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUICommonActivityRulesPicGuidePanelComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICommonActivityRulesPicGuidePanelComponent:RefreshByActivityShowConfigTemplate(template)
  self.guideIdList = {}
  if template and not string.IsNullOrEmpty(template.pic_guide) then
    self.guideIdList = string.string2array_num_oneSep(template.pic_guide, "|")
  end
  self:Refresh()
end

function LWUICommonActivityRulesPicGuidePanelComponent:RefreshByPicGuideIdList(idList)
  self.guideIdList = idList
  self:Refresh()
end

function LWUICommonActivityRulesPicGuidePanelComponent:Refresh()
  if table.IsNullOrEmpty(self.guideIdList) then
    return
  end
  self:ClearItems()
  for i, v in ipairs(self.guideIdList) do
    self.reqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/Common/CommonActivityRules/LWUICommonActivityRulesPicGuideItem.prefab", function(request)
      if request.isError or self.compContent == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "item_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compContent:AddComponent(LWUICommonActivityRulesPicGuideItemComponent, go.name)
      cell:ReInit(v, i ~= #self.guideIdList)
      self.items[i] = cell
      if i == #self.guideIdList and self.compContent then
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
        self:RefreshMoveNextBtn()
      end
    end)
  end
end

function LWUICommonActivityRulesPicGuidePanelComponent:RefreshMoveNextBtn()
  local scrollSize = self.compScrollView:GetSizeDelta()
  local layoutSize = self.compContent:GetSizeDelta()
  local layoutPos = self.compContent:GetAnchoredPosition()
  local isArrowShow = false
  if layoutSize.y > scrollSize.y and layoutPos.y < layoutSize.y - scrollSize.y - 10 then
    isArrowShow = true
  end
  self.btnMoveNext:SetActive(isArrowShow)
end

function LWUICommonActivityRulesPicGuidePanelComponent:ClearItems()
  self.compContent:RemoveComponents(LWUICommonActivityRulesPicGuideItemComponent)
  if self.reqs and next(self.reqs) then
    for k, v in pairs(self.reqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqs = {}
  self.items = {}
end

function LWUICommonActivityRulesPicGuidePanelComponent:OnBtnMoveNextClick()
  local scrollSize = self.compScrollView:GetSizeDelta()
  local layoutSize = self.compContent:GetSizeDelta()
  local layoutPos = self.compContent:GetAnchoredPosition()
  local maxPos = 0
  if layoutSize.y > scrollSize.y then
    maxPos = layoutSize.y - scrollSize.y - 10
  end
  if maxPos <= layoutPos.y then
    return
  end
  local curIndex = 0
  local curH = 0
  local curItemH = 0
  for i, item in ipairs(self.items) do
    local itemSize = item:GetSizeDelta()
    if layoutPos.y < curH + itemSize.y - 10 then
      curIndex = i
      curItemH = itemSize.y
      break
    end
    curH = curH + itemSize.y
  end
  local needToPos = curH + curItemH
  if maxPos < needToPos then
    needToPos = maxPos
  end
  self.compContent:SetAnchoredPositionXY(0, needToPos)
end

return LWUICommonActivityRulesPicGuidePanelComponent
