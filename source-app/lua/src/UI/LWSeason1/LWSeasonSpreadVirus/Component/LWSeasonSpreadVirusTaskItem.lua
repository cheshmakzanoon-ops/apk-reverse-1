local base = UIBaseContainer
local LWSeasonSpreadVirusTaskItem = BaseClass("LWSeasonSpreadVirusTaskItem", base)
local Localization = CS.GameEntry.Localization
local img_Icon_path = "Icon"
local btn_GoBtn_path = "GoBtn"
local img_RecommendBg_path = "RecommendBg"
local txt_RecommonedText_path = "RecommendBg/RecommonedText"
local img_LimitedTimeMark_path = "LimitedTimeMark"
local txt_LimitedTimeMarkText_path = "LimitedTimeMark/LimitedTimeMarkText"
local txt_Txt_Name_path = "Txt_Name"
local txt_Txt_Desc_path = "TextScroll/ViewPort/Txt_Desc"

function LWSeasonSpreadVirusTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonSpreadVirusTaskItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonSpreadVirusTaskItem:ComponentDefine()
  self.img_Icon = self:AddComponent(UIImage, img_Icon_path)
  self.btn_GoBtn = self:AddComponent(UIButton, btn_GoBtn_path)
  self.img_RecommendBg = self:AddComponent(UIImage, img_RecommendBg_path)
  self.txt_RecommonedText = self:AddComponent(UIText, txt_RecommonedText_path)
  self.img_LimitedTimeMark = self:AddComponent(UIImage, img_LimitedTimeMark_path)
  self.txt_LimitedTimeMarkText = self:AddComponent(UIText, txt_LimitedTimeMarkText_path)
  self.txt_Txt_Name = self:AddComponent(UIText, txt_Txt_Name_path)
  self.txt_Txt_Desc = self:AddComponent(UIText, txt_Txt_Desc_path)
  self.btn_GoBtn:SetOnClick(function()
    self:OnGoClick()
  end)
end

function LWSeasonSpreadVirusTaskItem:ComponentDestroy()
  self.img_Icon = nil
  self.btn_GoBtn = nil
  self.img_RecommendBg = nil
  self.txt_RecommonedText = nil
  self.img_LimitedTimeMark = nil
  self.txt_LimitedTimeMarkText = nil
  self.txt_Txt_Name = nil
  self.txt_Txt_Desc = nil
end

function LWSeasonSpreadVirusTaskItem:SetData(data, activityId)
  self.data = data
  self.activityId = activityId
  self:RefreshShow()
end

function LWSeasonSpreadVirusTaskItem:RefreshShow()
  if not self.data then
    return
  end
  if not string.IsNullOrEmpty(self.data.icon) then
    self.img_Icon:SetActive(true)
    self.img_Icon:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath("Assets/Main/SeasonRes/S1/Sprites/S1_Pre_Activity/%s", self.data.icon))
    self.img_Icon:SetNativeSize()
  else
    self.img_Icon:SetActive(false)
  end
  self.txt_Txt_Name:SetLocalText(self.data.name)
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
      self.txt_Txt_Desc:SetText(desc)
    else
      self.txt_Txt_Desc:SetLocalText(self.data.desc, dropItemName)
    end
  else
    self.txt_Txt_Desc:SetLocalText(self.data.desc, dropItemName)
  end
  self.btn_GoBtn:SetActive(self.data.showGoto ~= 0)
  if self.data.extra_display == 1 then
    self.img_RecommendBg:SetActive(true)
    self.img_LimitedTimeMark:SetActive(false)
    self.txt_RecommonedText:SetLocalText(self.data.extra_desc)
  elseif self.data.extra_display == 2 then
    self.img_RecommendBg:SetActive(false)
    self.img_LimitedTimeMark:SetActive(true)
    self.txt_LimitedTimeMarkText:SetLocalText(self.data.extra_desc)
  else
    self.img_RecommendBg:SetActive(false)
    self.img_LimitedTimeMark:SetActive(false)
  end
end

function LWSeasonSpreadVirusTaskItem:OnGoClick()
  if not self.data then
    return
  end
  self.data:TryGotoFunc()
end

return LWSeasonSpreadVirusTaskItem
