local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LimitedTimeFeast_Common2 = BaseClass("LimitedTimeFeast_Common2", base)
local M = LimitedTimeFeast_Common2
local Localization = CS.GameEntry.Localization
local LimitedTimeFeastMethodItem = require("UI.UIActivityCenterTable.Component.LimitedTimeFeast.LimitedTimeFeastMethodItem")
local ActBannerEffectContent = require("UI.UIActivityCenterTable.Component.LimitedTimeFeast.ActBannerEffectContent")
local intro_btn_path = "rect/ActivityTopGo/IntroBtn"
local txt_act_name_path = "rect/ActivityTopGo/Txt_ActName"
local txt_act_extra_path = "rect/ActivityTopGo/Txt_ActExtra"
local openTime_path = "rect/ActivityTopGo/TimeBg/openTime"
local banner_path = "rect/RawImage"
local scroll_view_path = "rect/CenterGo/Scroll View"
local jumpBtn_path = "rect/ActivityTopGo/BtnLayout/jumpBtn"
local jumpBtnText_path = "rect/ActivityTopGo/BtnLayout/jumpBtn/jumpBtnTxt"
local getItem_path = "rect/ActivityTopGo/LimitedTimeGetTextBg/LimitedTimeGet/LimitedTimeGetItem/UICommonResItem"
local getItem1_path = "rect/ActivityTopGo/LimitedTimeGetTextBg/LimitedTimeGet/LimitedTimeGetItem/UICommonResItem1"
local getItem2_path = "rect/ActivityTopGo/LimitedTimeGetTextBg/LimitedTimeGet/LimitedTimeGetItem/UICommonResItem2"
local act_banner_effect_content_path = "rect/ActBannerEffectContent"
local bg_image_path = "rect/bgImage"
local limited_time_get_text_bg_path = "rect/ActivityTopGo/LimitedTimeGetTextBg"
local desc_bg_path = "rect/CenterGo/DescBg"
local desc_text_path = "rect/CenterGo/DescBg/DescText"
local limited_time_get_text_path = "rect/ActivityTopGo/LimitedTimeGetTextBg/LimitedTimeGet/LimitedTimeGetText"
local limited_time_get_path = "rect/ActivityTopGo/LimitedTimeGetTextBg/LimitedTimeGet"
local drop_history_btn_path = "rect/ActivityTopGo/BtnLayout/DropHistoryBtn"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:ComponentDefine()
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.intro_btn2 = self:AddComponent(UIEventTrigger, "rect/ActivityTopGo/IntroBtn2")
  self.intro_btn2:OnPointerClick(function(eventData)
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString("snow_season_drop_UI3")
    param.alignObject = self.intro_btn2
    param.yPosFix = 20
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
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
  self.bgImage = self:AddComponent(UIImage, bg_image_path)
  self.getTextBg = self:AddComponent(UIImage, limited_time_get_text_bg_path)
  self.bgDesc = self:AddComponent(UIImage, desc_bg_path)
  self.descText = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.limitedTimeGetText = self:AddComponent(UITextMeshProUGUIEx, limited_time_get_text_path)
  self.limited_time_get = self:AddComponent(UIBaseContainer, limited_time_get_path)
  self.dropRecordBtn = self:AddComponent(UIButton, drop_history_btn_path)
  self.dropRecordBtn:SetOnClick(function()
    self:OnDropRecordBtnClick()
  end)
end

function M:ComponentDestroy()
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
  self.bgImage = nil
  self.getTextBg = nil
  self.bgDesc = nil
  self.descText = nil
  self.limitedTimeGetText = nil
  self.limited_time_get = nil
end

function M:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:AddUIListener(EventId.MainTaskSuccess, self.RefreshView)
  self:AddUIListener(EventId.RefreshLimitedDropWayNum, self.RefreshView)
  self:AddUIListener(EventId.ActLimitedTimeFeastDataUpdate, self.RefreshView)
  self:AddUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
  self:AddUIListener(EventId.SearchMonsterFailed, self.OnSearchFailed)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshView)
  self:RemoveUIListener(EventId.RefreshLimitedDropWayNum, self.RefreshView)
  self:RemoveUIListener(EventId.ActLimitedTimeFeastDataUpdate, self.RefreshView)
  self:RemoveUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
  self:RemoveUIListener(EventId.SearchMonsterFailed, self.OnSearchFailed)
  base.OnRemoveListener(self)
end

function M:FindMonsterEnd(param)
  local worldPosition = SceneUtils.TileIndexToWorld(param.pointId)
  WorldArrowManager:GetInstance():ShowArrowEffect(param.uuid, worldPosition, ArrowType.Monster)
  GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom)
  GoToUtil.CloseAllWindows()
end

function M:OnSearchFailed()
  UIUtil.ShowTipsId("target_not_found_tips")
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:SetData(activityId)
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
  self:InitViewByConfig()
end

function M:SetViewColor()
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

function M:SetBannerImg()
  if not string.IsNullOrEmpty(self.data.activity_pic) then
    local path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.UILimitedTimeFeastFestival, self.data.activity_pic)
    if not string.IsNullOrEmpty(path) then
      self.banner:LoadSpriteAsyncWithCallback(path, function()
        self.banner:SetNativeSize()
      end)
    end
  end
end

function M:ClickTip()
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
    local isUse = DataCenter.ActFestivalPopUpManager:CheckActFestivalUseNewSkin(self.activityId, UIWindowNames.UIActLimitedTimeFeastNoticeCommon)
    if not isUse then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LimitedTimeFeastNotice, {anim = true}, param)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActLimitedTimeFeastNoticeCommon, {anim = true}, param)
    end
  end
end

function M:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(LimitedTimeFeastMethodItem)
  self.showDatalist = {}
end

function M:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(LimitedTimeFeastMethodItem, itemObj)
  cellItem:SetData(self.showDatalist[index], self.activityId)
end

function M:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, LimitedTimeFeastMethodItem)
end

function M:RefreshView()
  if not self.activityId then
    return
  end
  if self.data == nil then
    return
  end
  self:ClearScroll()
  local name = not string.IsNullOrEmpty(self.data.bannerTittle) and self.data.bannerTittle or self.data.name
  self.txt_act_name:SetLocalText(name)
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

function M:Update1000MS()
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

function M:CreateMethodsData()
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

function M:InitViewByConfig()
  if not self.data then
    Logger.LogError("activity data is nil")
    return
  end
  local showTemp = self.data:GetShowConfigTemp()
  if showTemp == nil then
    return
  end
  local picSpec1 = showTemp.pic_spec1
  if string.IsNullOrEmpty(picSpec1) then
    Logger.LogError("pic_spec1 is null")
    return
  end
  local bgPath1, bgColor1 = self:ParseImageAndColor(picSpec1)
  self.getTextBg:LoadSprite(bgPath1)
  self.limitedTimeGetText:SetColor(bgColor1)
  self.limitedTimeGetText:SetText(CS.GameEntry.Localization:GetString(2800100))
  local pinSpec2 = showTemp.pic_spec2
  if string.IsNullOrEmpty(pinSpec2) then
    Logger.LogError("pic_spec2 is null")
    return
  end
  local bgPath2, bgColor2 = self:ParseImageAndColor(pinSpec2)
  self.bgDesc:LoadSprite(bgPath2)
  self.descText:SetColor(bgColor2)
  local pinSpec4 = showTemp.pic_spec4
  if string.IsNullOrEmpty(pinSpec4) then
    Logger.LogError("pic_spec4 is null")
    return
  end
  local bgPath4, bgColor4 = self:ParseImageAndColor(pinSpec4)
  self.bgImage:LoadSprite(bgPath4)
  if bgColor4 then
    self.bgImage:SetColor(bgColor4)
  end
end

function M:ParseImageAndColor(configStr)
  local path = ""
  local color
  local picArr = string.split(configStr, "|")
  path = string.format(LoadPath.UILimitedTimeFeastFestival, picArr[1])
  if picArr[2] then
    local colorStr = string.split(picArr[2], ",")
    color = Color.New(toInt(colorStr[1]) / 255, toInt(colorStr[2]) / 255, toInt(colorStr[3]) / 255, toInt(colorStr[4]) / 255)
  end
  return path, color
end

function M:OnDropRecordBtnClick()
  if not self.activityId then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILimitDropHistory, {anim = true}, self.activityId)
end

return M
