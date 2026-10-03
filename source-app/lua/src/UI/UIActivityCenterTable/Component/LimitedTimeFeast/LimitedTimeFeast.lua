local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LimitedTimeFeast = BaseClass("LimitedTimeFeast", base)
local Localization = CS.GameEntry.Localization
local LimitedTimeFeastMethodItem = require("UI.UIActivityCenterTable.Component.LimitedTimeFeast.LimitedTimeFeastMethodItem")
local ActBannerEffectContent = require("UI.UIActivityCenterTable.Component.LimitedTimeFeast.ActBannerEffectContent")
local intro_btn_path = "rect/ActivityTopGo/IntroBtn"
local txt_act_name_path = "rect/ActivityTopGo/Txt_ActName"
local txt_act_extra_path = "rect/ActivityTopGo/Txt_ActExtra"
local openTime_path = "rect/ActivityTopGo/TimeBg/openTime"
local banner_path = "rect/RawImage"
local scroll_view_path = "rect/CenterGo/Scroll View"
local jumpBtn_path = "rect/ActivityTopGo/jumpBtn"
local jumpBtnText_path = "rect/ActivityTopGo/jumpBtn/jumpBtnTxt"
local getItem_path = "rect/ActivityTopGo/LimitedTimeGet/LimitedTimeGetItem/UICommonResItem"
local getItem1_path = "rect/ActivityTopGo/LimitedTimeGet/LimitedTimeGetItem/UICommonResItem1"
local getItem2_path = "rect/ActivityTopGo/LimitedTimeGet/LimitedTimeGetItem/UICommonResItem2"
local act_banner_effect_content_path = "rect/ActBannerEffectContent"

function LimitedTimeFeast:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LimitedTimeFeast:ComponentDefine()
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.intro_btn2 = self:AddComponent(UIButton, "rect/ActivityTopGo/Txt_ActExtra/IntroBtn2")
  self.intro_btn2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIUtil.ShowBubbleTips(Localization:GetString("snow_season_drop_UI3"), self.intro_btn2.transform.position, 0, -20, 0)
  end)
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_act_extra = self:AddComponent(UIText, txt_act_extra_path)
  self.openTime = self:AddComponent(UIText, openTime_path)
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.jumpBtn = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.data and self.data:GetFirstActiveJumpTo() > 0 then
      GoToUtil.GoActWindow({
        self.data:GetFirstActiveJumpTo()
      }, false)
    end
  end)
  self.jumpBtnText = self:AddComponent(UIText, jumpBtnText_path)
  self.jumpBtn:SetActive(false)
  self.getItem = self:AddComponent(UICommonResItem, getItem_path)
  self.getItem1 = self:AddComponent(UICommonResItem, getItem1_path)
  self.getItem2 = self:AddComponent(UICommonResItem, getItem2_path)
  self.getItemList = {
    self.getItem,
    self.getItem1,
    self.getItem2
  }
  self.txt_act_name_OutLine = self:AddComponent(UIOutline, txt_act_name_path)
  self.txt_act_name_Shadow = self:AddComponent(UIShadow, txt_act_name_path)
  self.act_banner_effect_content = self:AddComponent(ActBannerEffectContent, act_banner_effect_content_path)
end

function LimitedTimeFeast:ComponentDestroy()
  self.intro_btn = nil
  self.txt_act_name = nil
  self.txt_act_extra = nil
  self.openTime = nil
  self.scroll_view = nil
  self.jumpBtn = nil
  self.getItem = nil
  self.getItem2 = nil
  self.getItem1 = nil
  self.act_banner_effect_content = nil
end

function LimitedTimeFeast:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LimitedTimeFeast:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:AddUIListener(EventId.MainTaskSuccess, self.RefreshView)
  self:AddUIListener(EventId.RefreshLimitedDropWayNum, self.RefreshView)
end

function LimitedTimeFeast:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshView)
  self:RemoveUIListener(EventId.RefreshLimitedDropWayNum, self.RefreshView)
  base.OnRemoveListener(self)
end

function LimitedTimeFeast:OnDisable()
  base.OnDisable(self)
end

function LimitedTimeFeast:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.data == nil then
    return
  end
  local jumpBtnKey = "snow_season_drop_UI2"
  if not string.IsNullOrEmpty(self.data.jumpbtn_desc) then
    jumpBtnKey = self.data.jumpbtn_desc
  end
  self.jumpBtnText:SetLocalText(jumpBtnKey)
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
  self:SetViewColor()
  self:RefreshView()
  self.act_banner_effect_content:SetData(self.data)
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
end

function LimitedTimeFeast:SetViewColor()
  local showTemp = self.data:GetShowConfigTemp()
  if showTemp == nil then
    return
  end
  local targetColor = {
    61,
    43,
    61,
    255
  }
  if #showTemp.title_stroke_color_tab == 4 then
    targetColor = showTemp.title_stroke_color_tab
  end
  self.txt_act_name_OutLine:SetColorRGBA255(table.unpack(targetColor))
  self.txt_act_name_Shadow:SetColorRGBA255(table.unpack(targetColor))
  UIActivityCenterCommonUtil.SetTopViewColor(self.txt_act_name.gameObject, self.txt_act_extra.gameObject, self.openTime.gameObject, showTemp)
end

function LimitedTimeFeast:SetBannerImg()
  if not string.IsNullOrEmpty(self.data.activity_pic) then
    self.banner:LoadSpriteAsync(string.format(LoadPath.ActivityLimitedTimeFeastBannerPath, self.data.activity_pic))
  end
end

function LimitedTimeFeast:ClickTip()
  if self.showDatalist and #self.showDatalist > 0 then
    local dataList = {}
    for i, v in ipairs(self.showDatalist) do
      if 0 < v.drop_info_para then
        table.insert(dataList, v)
      end
    end
    local param = {}
    param.activityId = self.activityId
    param.dataList = dataList
    UIManager:GetInstance():OpenWindow(UIWindowNames.LimitedTimeFeastNotice, {anim = true}, param)
  end
end

function LimitedTimeFeast:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(LimitedTimeFeastMethodItem)
  self.showDatalist = {}
end

function LimitedTimeFeast:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(LimitedTimeFeastMethodItem, itemObj)
  cellItem:SetData(self.showDatalist[index], self.activityId)
end

function LimitedTimeFeast:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, LimitedTimeFeastMethodItem)
end

function LimitedTimeFeast:RefreshView()
  if not self.activityId then
    return
  end
  if self.data == nil then
    return
  end
  self:ClearScroll()
  self.txt_act_name:SetLocalText(self.data.name)
  local cur, max = DataCenter.ActLimitedTimeFeastData:GetCurAndMax(tonumber(self.activityId))
  self.txt_act_extra:SetLocalText("snow_season_drop_UI1", cur, max)
  self.scroll_view:SetActive(true)
  self.showDatalist = self:CreateMethodsData()
  if #self.showDatalist > 0 then
    self.scroll_view:SetTotalCount(#self.showDatalist)
    self.scroll_view:RefillCells()
  else
    self.scroll_view:SetActive(false)
  end
  self:Update1000MS()
  self:SetBannerImg()
  self.jumpBtn:SetActive(self.data ~= nil and 0 < self.data:GetFirstActiveJumpTo())
  local str = string.split(self.data.para_2, "|")
  local count = #str
  if 0 < count then
    self.getItem:SetActive(0 < count)
    self.getItem1:SetActive(1 < count)
    self.getItem2:SetActive(2 < count)
    for i = 1, 3 do
      if i <= count then
        local itemData = {}
        itemData.rewardType = RewardType.GOODS
        itemData.itemId = tonumber(str[i])
        self.getItemList[i]:ReInit(itemData)
      end
    end
  end
end

function LimitedTimeFeast:Update1000MS()
  if not self.activityId then
    return
  end
  if self.data == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.data.endTime
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.openTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.openTime:SetLocalText(2800085)
  end
end

function LimitedTimeFeast:CreateMethodsData()
  if self.data then
    local dropId = self.data.subType
    local showDatalist = {}
    local methodsData = DataCenter.ActivityDropTemplateManager:GetTemplatesByDropId(dropId)
    for i = 1, #methodsData do
      local dropWayInfo = DataCenter.ActLimitedTimeFeastData:GetDropInfoById(tonumber(self.activityId), methodsData[i].id)
      if dropWayInfo then
        table.insert(showDatalist, methodsData[i])
      end
    end
    return showDatalist
  end
end

return LimitedTimeFeast
