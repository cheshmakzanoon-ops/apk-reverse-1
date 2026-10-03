local UIActGiftGivingDropPanelItem = BaseClass("UIActGiftGivingDropPanelItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local name_txt_path = "Txt_Name"
local go_btn_path = "GoBtn"
local go_btn_text_path = "GoBtn/GoBtnText"
local icon_path = "Icon"
local desc_txt_path = "TextScroll/ViewPort/Txt_Desc"
local recommendIcon_path = "RecommendBg"
local recommoned_text_path = "RecommendBg/RecommonedText"
local limited_time_mark_path = "LimitedTimeMark"
local limited_time_mark_text_path = "LimitedTimeMark/LimitedTimeMarkText"

function UIActGiftGivingDropPanelItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActGiftGivingDropPanelItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActGiftGivingDropPanelItem:ComponentDefine()
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.go_btn_text = self:AddComponent(UIText, go_btn_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.descText = self:AddComponent(UIText, desc_txt_path)
  self.recommendIcon = self:AddComponent(UIImage, recommendIcon_path)
  self.recommoned_text = self:AddComponent(UITextMeshProUGUIEx, recommoned_text_path)
  self.limited_time_mark = self:AddComponent(UIImage, limited_time_mark_path)
  self.limited_time_mark_text = self:AddComponent(UITextMeshProUGUIEx, limited_time_mark_text_path)
  self.limited_time_mark_text:SetText(Localization:GetString("activity_dropway10_desc1"))
  self.limited_time_mark:SetActive(false)
end

function UIActGiftGivingDropPanelItem:ComponentDestroy()
  self.nameText = nil
  self.go_btn = nil
  self.go_btn_text = nil
  self.icon = nil
  self.descText = nil
  self.recommendIcon = nil
  self.recommoned_text = nil
  self.limited_time_mark = nil
  self.limited_time_mark_text = nil
end

function UIActGiftGivingDropPanelItem:DataDefine()
end

function UIActGiftGivingDropPanelItem:DataDestroy()
end

function UIActGiftGivingDropPanelItem:SetData(data, activityId)
  self.data = data
  self.activityId = activityId
  self:RefreshShow()
end

function UIActGiftGivingDropPanelItem:RefreshShow()
  if not self.data then
    return
  end
  if not string.IsNullOrEmpty(self.data.icon) then
    self.icon:SetActive(true)
    self.icon:LoadSprite(string.format(LoadPath.UILimitedTimeFeast, self.data.icon))
    self.icon:SetNativeSize()
  else
    self.icon:SetActive(false)
  end
  self.nameText:SetLocalText(self.data.name)
  local dropItemName = ""
  if self.data.drop_show and #self.data.drop_show > 0 then
    local dropItemId = self.data.drop_show[1].id
    if dropItemId then
      local goodsTemp = DataCenter.ItemTemplateManager:GetItemTemplate(dropItemId)
      if goodsTemp then
        dropItemName = Localization:GetString(goodsTemp.name)
      end
    end
  end
  local dropWayInfo = DataCenter.ActLimitedTimeFeastData:GetDropInfoById(tonumber(self.activityId), self.data.id)
  if dropWayInfo then
    local itemInfoCSArray = dropWayInfo:GetItemInfoCSArray()
    if itemInfoCSArray then
      local desc = Localization:GetString(self.data.desc, dropItemName, itemInfoCSArray)
      self.descText:SetText(desc)
    else
      self.descText:SetLocalText(self.data.desc, dropItemName)
    end
  else
    self.descText:SetLocalText(self.data.desc, dropItemName)
  end
  self.go_btn:SetActive(self.data.showGoto ~= 0)
  if self.data.extra_display == 1 then
    self.recommendIcon:SetActive(true)
    self.limited_time_mark:SetActive(false)
    self.recommoned_text:SetLocalText(self.data.extra_desc)
  elseif self.data.extra_display == 2 then
    self.recommendIcon:SetActive(false)
    self.limited_time_mark:SetActive(true)
    self.limited_time_mark_text:SetLocalText(self.data.extra_desc)
  else
    self.recommendIcon:SetActive(false)
    self.limited_time_mark:SetActive(false)
  end
end

function UIActGiftGivingDropPanelItem:OnGoClick()
  if not self.data then
    return
  end
  self.data:TryGotoFunc()
  if self.view and self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

return UIActGiftGivingDropPanelItem
