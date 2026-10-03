local base = UIBaseContainer
local UIOffSeason1RecaptureOtherContent = BaseClass("UIOffSeason1RecaptureOtherContent", UIBaseContainer)
local UIOffSeason1RecaptureCityListItem = require("UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureCityListItem")
local UIOffSeason1RecaptureFeatureItem = require("UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureFeatureItem")
local Localization = CS.GameEntry.Localization
local MAX_LEVEL = 6
local TITLE_HEIGHT = 68
local content_title_root_path = "TitleContent"
local content_title_arrow_icon_path = "TitleContent/ArrowIcon"
local content_title_arrow_icon_select_path = "TitleContent/ArrowIconSelect"
local content_title_member_text_path = "TitleContent/MemberText"

function UIOffSeason1RecaptureOtherContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1RecaptureOtherContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1RecaptureOtherContent:ComponentDefine()
  self.compListContent = self:AddComponent(UIBaseComponent, "ListScroll/ListContent")
  self.cityListItem6 = self:AddComponent(UIOffSeason1RecaptureCityListItem, "ListScroll/ListContent/CityListItem6")
  self.cityListItem1 = self:AddComponent(UIOffSeason1RecaptureCityListItem, "ListScroll/ListContent/CityListItem1")
  self.cityListItem2 = self:AddComponent(UIOffSeason1RecaptureCityListItem, "ListScroll/ListContent/CityListItem2")
  self.cityListItem3 = self:AddComponent(UIOffSeason1RecaptureCityListItem, "ListScroll/ListContent/CityListItem3")
  self.cityListItem4 = self:AddComponent(UIOffSeason1RecaptureCityListItem, "ListScroll/ListContent/CityListItem4")
  self.cityListItem5 = self:AddComponent(UIOffSeason1RecaptureCityListItem, "ListScroll/ListContent/CityListItem5")
  self.scroll_view = self:AddComponent(UIScrollRect, "ListScroll")
  self.content_title_root = self:AddComponent(UIButton, content_title_root_path)
  self.content_title_arrow_icon = self:AddComponent(UIImage, content_title_arrow_icon_path)
  self.content_title_arrow_icon_select = self:AddComponent(UIImage, content_title_arrow_icon_select_path)
  self.content_title_member_text = self:AddComponent(UIText, content_title_member_text_path)
  self.content_title_feature_item = self:AddComponent(UIOffSeason1RecaptureFeatureItem, "TitleContent/FeatureItem")
  self.content_title_root:SetActive(false)
  self.updating = true
  self.topGroupNode = nil
  self.scroll_view:AddValueChangeListener(function(vec)
    self:OnScrollValueChange()
  end)
  self.content_title_root:SetOnClick(function()
    if self.topGroupNode then
      self.updating = true
      self.topGroupNode:OnBtnClick()
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compListContent.rectTransform)
      self.updating = false
      self:OnScrollValueChange()
    end
  end)
end

function UIOffSeason1RecaptureOtherContent:ComponentDestroy()
  self.scroll_view = nil
  self.updating = nil
  self.topGroupNode = nil
  self.content_title_root = nil
  self.content_title_rank_icon = nil
  self.content_title_my_pos_icon = nil
  self.content_title_arrow_icon = nil
  self.content_title_arrow_icon_select = nil
  self.content_title_member_text = nil
  self.content_title_feature_item = nil
  self.compListContent = nil
  self.cityListItem6 = nil
  self.cityListItem1 = nil
  self.cityListItem2 = nil
  self.cityListItem3 = nil
  self.cityListItem4 = nil
  self.cityListItem5 = nil
end

function UIOffSeason1RecaptureOtherContent:DataDefine()
end

function UIOffSeason1RecaptureOtherContent:DataDestroy()
end

function UIOffSeason1RecaptureOtherContent:OnAddListener()
  base.OnAddListener(self)
end

function UIOffSeason1RecaptureOtherContent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIOffSeason1RecaptureOtherContent:Refresh(monsterInfos, showFirstIn)
  self.updating = true
  self.topGroupNode = nil
  self.content_title_root:SetActive(false)
  self.monsterInfos = monsterInfos
  local autoSelectIndex, presidentChooseAutoSelectIndex
  for i = 1, MAX_LEVEL do
    if monsterInfos[i] and 0 < #monsterInfos[i] then
      self["cityListItem" .. i]:SetActive(true)
      local presidentChooseIndex = DataCenter.OffSeason1RecaptureManager:GetPresidentChooseIndexByMonsterLv(i)
      self["cityListItem" .. i]:Refresh(i, monsterInfos[i], presidentChooseIndex)
      if showFirstIn then
        autoSelectIndex = i
        if presidentChooseIndex then
          presidentChooseAutoSelectIndex = i
        end
        self["cityListItem" .. i]:SetSelect(false)
      end
    else
      self["cityListItem" .. i]:SetActive(false)
    end
  end
  if presidentChooseAutoSelectIndex then
    self["cityListItem" .. presidentChooseAutoSelectIndex]:SetSelect(true)
  elseif autoSelectIndex then
    self["cityListItem" .. autoSelectIndex]:SetSelect(true)
    local guideBubbleStr = DataCenter.OffSeason1RecaptureManager:GetBubbleTipStr()
    if guideBubbleStr then
      self["cityListItem" .. autoSelectIndex]:ShowGuideTip(guideBubbleStr)
      DataCenter.OffSeason1RecaptureManager:SaveBubbleTipShown(true)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compListContent.rectTransform)
  local jumpIndex = presidentChooseAutoSelectIndex or autoSelectIndex
  if jumpIndex then
    if jumpIndex < MAX_LEVEL then
      local offsetY = 0
      for i = MAX_LEVEL - 1, jumpIndex, -1 do
        if self["cityListItem" .. i + 1]:GetActive() then
          offsetY = offsetY + TITLE_HEIGHT
        end
      end
      local x, y, z = self.compListContent:GetLocalPositionXYZ()
      self.compListContent:SetLocalPositionXYZ(x, offsetY, z)
    else
      local x, y, z = self.compListContent:GetLocalPositionXYZ()
      self.compListContent:SetLocalPositionXYZ(x, 0, z)
    end
  end
  self.updating = false
  self:OnScrollValueChange()
end

function UIOffSeason1RecaptureOtherContent:OnScrollValueChange()
  if self.updating then
    self.content_title_root:SetActive(false)
    self.topGroupNode = nil
    return
  end
  local topNode
  local top = self.compListContent:GetAnchoredPositionY()
  local lastY = 0
  for i = 1, MAX_LEVEL do
    if self.monsterInfos[i] and 0 < #self.monsterInfos[i] then
      topNode = self["cityListItem" .. i]
      if topNode and topNode:GetActive() then
        local y = topNode:GetAnchoredPositionY() + top
        if 0 < y then
          if i ~= 1 and 0 < lastY + 65 then
            topNode = nil
          end
          break
        end
        lastY = y
      end
      topNode = nil
    end
  end
  if topNode then
    self.content_title_root:SetActive(true)
    self.content_title_arrow_icon:SetActive(topNode.compArrowIcon:GetActive())
    self.content_title_arrow_icon_select:SetActive(topNode.compArrowIconSelect:GetActive())
    self.content_title_member_text:SetText(topNode:GetTextMemberText())
    self.content_title_feature_item:Refresh(topNode.presidentChooseIndex ~= nil, nil)
  else
    self.content_title_root:SetActive(false)
  end
  self.topGroupNode = topNode
end

return UIOffSeason1RecaptureOtherContent
