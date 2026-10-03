local LimitedTimeFeastMethodItem = BaseClass("LimitedTimeFeastMethodItem", UIBaseContainer)
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
local go_bg_path = "GoBg"

function LimitedTimeFeastMethodItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LimitedTimeFeastMethodItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LimitedTimeFeastMethodItem:ComponentDefine()
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
  self.goBg = self:AddComponent(UIImage, go_bg_path)
end

function LimitedTimeFeastMethodItem:ComponentDestroy()
  self.nameText = nil
  self.go_btn = nil
  self.go_btn_text = nil
  self.icon = nil
  self.descText = nil
  self.recommendIcon = nil
  self.recommoned_text = nil
  self.limited_time_mark = nil
  self.limited_time_mark_text = nil
  self.goBg = nil
end

function LimitedTimeFeastMethodItem:DataDefine()
end

function LimitedTimeFeastMethodItem:DataDestroy()
end

function LimitedTimeFeastMethodItem:SetData(data, activityId)
  self.data = data
  self.activityId = activityId
  self:RefreshShow()
  self:RefreshBg()
end

function LimitedTimeFeastMethodItem:RefreshShow()
  if not self.data then
    return
  end
  if not string.IsNullOrEmpty(self.data.icon) then
    self.icon:SetActive(true)
    local iconPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.UILimitedTimeFeast, self.data.icon)
    self.icon:LoadSpriteAsyncWithCallback(iconPath, function()
      self.icon:SetNativeSize()
    end)
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
  local isPass = self.data:CheckClientConditionPass()
  if isPass then
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
  else
    self.descText:SetLocalText("drop_way_alert_desc1")
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

function LimitedTimeFeastMethodItem:OnGoClick()
  if not self.data then
    return
  end
  local isPass = self.data:CheckClientConditionPass()
  if not isPass then
    UIUtil.ShowTipsId("drop_way_alert_desc2")
    return
  end
  self.data:TryGotoFunc()
end

function LimitedTimeFeastMethodItem:RefreshBg()
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityData == nil then
    return
  end
  local showTemp = activityData:GetShowConfigTemp()
  if showTemp == nil or string.IsNullOrEmpty(showTemp.pic_spec3) then
    return
  end
  self.goBg:LoadSprite(string.format(LoadPath.UILimitedTimeFeastFestival, showTemp.pic_spec3))
end

return LimitedTimeFeastMethodItem
