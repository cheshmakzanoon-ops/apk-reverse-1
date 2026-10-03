local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIActCalendarBubbleTipsView = BaseClass("UIActCalendarBubbleTipsView", base)
local HorizontalLayoutGroup = typeof(CS.UnityEngine.UI.HorizontalLayoutGroup)
local Alignment_Change_Limit = 4
local Localization = CS.GameEntry.Localization
local ActCalendarTipsRewardItem = require("UI.ActCalendar.Component.ActCalendarTipsRewardItem")
local DESC_PREFERRED_HEIGHT = 70

function UIActCalendarBubbleTipsView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTimeDuration = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRewardTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compRewardListContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compGoBtnNode = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textGoBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textDescLayoutElement = self:AddComponent(UILayoutElement, "Root/ImgBg/Content/desc")
end

function UIActCalendarBubbleTipsView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textTimeDuration = nil
  self.textRewardTitle = nil
  self.compRewardListContent = nil
  self.compGoBtnNode = nil
  self.btnGo = nil
  self.textGoBtn = nil
  base.ComponentDestroy(self)
end

function UIActCalendarBubbleTipsView:DataDefine()
  self.itemReqs = {}
end

function UIActCalendarBubbleTipsView:DataDestroy()
  self:_clearList()
end

function UIActCalendarBubbleTipsView:OnAddListener()
  base.OnAddListener(self)
end

function UIActCalendarBubbleTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActCalendarBubbleTipsView:RefreshShow()
  base.RefreshShow(self)
  if not self.param then
    return
  end
  self.data = self.param.customData
  if not self.data then
    return
  end
  self:_setTitle()
  self:_setDesc()
  self:_setTimeDuration()
  self:_setRewardRootLayout()
  self:_setReward()
  self:_setControlStatus()
end

function UIActCalendarBubbleTipsView:_setTitle()
  self.textTitle:SetLocalText(self.data.name)
end

function UIActCalendarBubbleTipsView:_setDesc()
  self.textDesc:SetLocalText(self.data.calendarDes)
  local preferredHeight = self.textDesc:GetHeight()
  if preferredHeight < DESC_PREFERRED_HEIGHT then
    self.textDescLayoutElement:SetPreferredHeight(preferredHeight)
  else
    self.textDescLayoutElement:SetPreferredHeight(DESC_PREFERRED_HEIGHT)
  end
end

function UIActCalendarBubbleTipsView:_setTimeDuration()
  local startTime = self.data.beginTime * 1000
  local endTime = self.data.endTime * 1000
  local startTimeFormat = self:_getTimeFormat(startTime)
  local endTimeFormat = self:_getTimeFormat(endTime)
  local result = string.format("%s-%s", startTimeFormat, endTimeFormat)
  self.textTimeDuration:SetText(result)
end

function UIActCalendarBubbleTipsView:_getTimeFormat(timestamp)
  local x, y, z, hour, min, sec = UITimeManager:GetInstance():GetServerDate(timestamp)
  local formatStr = string.format("%d/%d/%d %02d:%02d:%02d", x, y, z, hour, min, sec)
  return formatStr
end

function UIActCalendarBubbleTipsView:_setRewardRootLayout()
  if not self.data or not self.data.propsList then
    return
  end
  local layout = self.compRewardListContent.transform:GetComponent(HorizontalLayoutGroup)
  if #self.data.propsList > Alignment_Change_Limit then
    if CommonUtil.IsArabic() and CommonUtil.GetAutoArabicMirrorSwitch() then
      layout.childAlignment = CS.UnityEngine.TextAnchor.UpperRight
      self.compRewardListContent:SetAnchorMaxXY(1, 1)
      self.compRewardListContent:SetAnchorMinXY(1, 1)
      self.compRewardListContent:SetPivotXY(1, 1)
    else
      layout.childAlignment = CS.UnityEngine.TextAnchor.UpperLeft
      self.compRewardListContent:SetAnchorMaxXY(0, 1)
      self.compRewardListContent:SetAnchorMinXY(0, 1)
      self.compRewardListContent:SetPivotXY(0, 1)
    end
  else
    self.compRewardListContent:SetAnchorMaxXY(0.5, 0.5)
    self.compRewardListContent:SetAnchorMinXY(0.5, 0.5)
    self.compRewardListContent:SetPivotMiddle()
    layout.childAlignment = CS.UnityEngine.TextAnchor.MiddleCenter
  end
  self.compRewardListContent:SetAnchoredPositionXY(0, 0)
end

function UIActCalendarBubbleTipsView:_setReward()
  if not self.data or not self.data.propsList then
    return
  end
  self:_clearList()
  self.itemReqs = {}
  if self.data.propsList then
    for i, v in ipairs(self.data.propsList) do
      table.insert(self.itemReqs, self:_createRewardItem(v, i))
    end
  end
end

function UIActCalendarBubbleTipsView:_setControlStatus()
  if not self.data then
    return
  end
  local curServerTime = UITimeManager:GetInstance():GetServerTime()
  local isEventOpen = curServerTime >= self.data:GetBegin() and curServerTime <= self.data:GetEnd()
  self.compGoBtnNode:SetActive(isEventOpen)
end

function UIActCalendarBubbleTipsView:_createRewardItem(data, index)
  return self:GameObjectInstantiateAsync(UIAssets.ActCalendarTipsRewardItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local name = "rewardItem_" .. index
    go.name = name
    go.transform:SetParent(self.compRewardListContent.transform)
    local cell = self.compRewardListContent:AddComponent(ActCalendarTipsRewardItem, name)
    cell:SetLocalScaleXYZ(1, 1, 1)
    cell:SetData(data)
  end)
end

function UIActCalendarBubbleTipsView:_clearList()
  self.compRewardListContent:RemoveComponents(ActCalendarTipsRewardItem)
  if self.itemReqs then
    for i, v in ipairs(self.itemReqs) do
      if v then
        v:Destroy()
      end
    end
  end
  self.itemReqs = nil
end

function UIActCalendarBubbleTipsView:OnBtnGoClick()
  GoToUtil.GoToByTypeAndParam(QuestGoType.GoActUI, {
    self.data.aid
  })
end

return UIActCalendarBubbleTipsView
