local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIBattlePassNewYear = BaseClass("UIBattlePassNewYear", base)
local UIBattlePassTaskCell = require("UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassTaskCellNewYear")
local UIBattlePassRewardItem = require("UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYearRewardItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local BattlePassUnlimitedBox = require("UI.UIActivityCenterTable.Component.UIBattlePass.BattlePassUnlimitedBox")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local time_txt_path = "Root/TitleBg/NotStarted/Txt_Times"
local actName_txt_path = "Root/TitleBg/Txt_ActName"
local buy_btn_path = "Root/TitleBg/BuyBtn"
local buy_text_path = "Root/TitleBg/BuyBtn/BuyText"
local buyTitle_text_path = "Root/TitleBg/BuyBtn/Txt_BuyTitle"
local toggle1_path = "Root/Rect_Group/Toggle1"
local toggle2_path = "Root/Rect_Group/Toggle2"
local toggle3_path = "Root/Rect_Group/Toggle3"
local toggle1_text_path = "Root/Rect_Group/Toggle1/Txt_ListToggle1"
local toggle2_text_path = "Root/Rect_Group/Toggle2/Txt_ListToggle2"
local toggle3_text_path = "Root/Rect_Group/Toggle3/Txt_ListToggle3"
local toggle1_line_path = "Root/Rect_Group/Toggle1/Line1"
local toggle2_line_path = "Root/Rect_Group/Toggle2/Line2"
local toggle3_line_path = "Root/Rect_Group/Toggle3/Line3"
local scroll_view_path = "Root/Mask/ScrollView"
local scroll_content_path = "Root/Mask/ScrollView/Content"
local mask_path = "Root/Mask"
local task_view_path = "Root/TaskView"
local task_content_path = "Root/TaskView/TaskContent"
local task_view_season_path = "Root/TaskViewSeason"
local task_content_season_path = "Root/TaskViewSeason/TaskContentSeason"
local point_path = "Root/TitleBg/BuyBtn/UIGiftPackagePoint"
local oneGet_btn_path = "Root/Btn_List/Btn_OneGet"
local oneGet_txt_path = "Root/Btn_List/Btn_OneGet/Txt_OneGet"
local oneGetRed_rect_path = "Root/Btn_List/Btn_OneGet/Rect_OnGetRed"
local intro_btn_path = "Root/TitleBg/Intro"
local title_txt_path = "Root/Txt_Title"
local exp_text_path = "Root/TitleBg/ExpArea/ExpText"
local progress_path = "Root/Mask/ScrollView/Content/ProgressBar"
local bg_path = "ImageBg"
local banner_path = "ImageBg2"
local txt_act_extra_path = "Root/TitleBg/Txt_ActExtra"
local heroSpineContainerPath = "Root/TitleBg/HeroSpineContainer"
local battlePassUnlimitedBox_path = "Root/Mask/BattlePassUnlimitedBox"
local state2BtnPath = "Root/Mask/States/State2Bg/State2Btn"
local state2LockIconPath = "Root/Mask/States/State2Bg/State2Btn/State2Icon/State2LockIcon"
local state3BtnPath = "Root/Mask/States/State3Bg/State3Btn"
local state3LockIconPath = "Root/Mask/States/State3Bg/State3Btn/State3Icon/State3LockIcon"
local state2EffectPath = "Root/Mask/States/State2Bg/State2Btn/Eff_ui_xinnian_bp_lan_xia"
local state2AnimPath = "Root/Mask/States/State2Bg"
local state3Effect1Path = "Root/Mask/States/State3Bg/State3Btn/Eff_ui_xinnian_bp_cheng_xia"
local state3Effect2Path = "Root/Mask/States/State3Bg/State3Btn/Eff_ui_xinnian_bp_cheng_shang"
local state3AnimPath = "Root/Mask/States/State3Bg"
local state2IconPath = "Root/Mask/States/State2Bg/State2Btn/State2Icon"
local state3IconPath = "Root/Mask/States/State3Bg/State3Btn/State3Icon"
local battle_pass_discount_path = "Root/BattlePassDiscount"
local discount_text_path = "Root/BattlePassDiscount/DiscountText"
local state1_icon_path = "Root/Mask/States/State1Bg/State1Icon"
local state1_bg_path = "Root/Mask/States/State1Bg"
local state2_bg_path = "Root/Mask/States/State2Bg"
local state3_bg_path = "Root/Mask/States/State3Bg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  if self.pointEffect ~= nil then
    self.pointEffect:Stop()
    self.pointEffect = nil
  end
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self:ClearScroll()
  self:DeleteTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.toggle1:SetIsOn(true)
  self.toggle2:SetIsOn(false)
  self.toggle3:SetIsOn(false)
end

local function ComponentDefine(self)
  self._actName_txt = self:AddComponent(UIText, actName_txt_path)
  self.buy_btn = self:AddComponent(LWBtnBuyRefundRemind, buy_btn_path)
  self.buy_btn:SetBuyClickAction(function()
    self:OnBuyClick()
  end)
  self.buy_btn:SetSafeClickMode(true)
  self._buyTitle_txt = self:AddComponent(UIText, buyTitle_text_path)
  self._buyTitle_txt:SetLocalText(320464)
  self._time_txt = self:AddComponent(UIText, time_txt_path)
  self._title_txt = self:AddComponent(UIText, title_txt_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle1Text = self:AddComponent(UIText, toggle1_text_path)
  self.toggle2Text = self:AddComponent(UIText, toggle2_text_path)
  self.toggle3Text = self:AddComponent(UIText, toggle3_text_path)
  self.toggle1Line = self:AddComponent(UIImage, toggle1_line_path)
  self.toggle2Line = self:AddComponent(UIImage, toggle2_line_path)
  self.toggle3Line = self:AddComponent(UIImage, toggle3_line_path)
  self.state1_bg = self:AddComponent(UIImage, state1_bg_path)
  self.state2_bg = self:AddComponent(UIImage, state2_bg_path)
  self.state3_bg = self:AddComponent(UIImage, state3_bg_path)
  self.toggle1:SetIsOn(true)
  self.toggle1.selecting = false
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      if not self.toggle1.selecting then
        DataCenter.LWSoundManager:PlaySound(6100023, false)
      end
      self:ToggleControlBorS(1)
    end
    self.toggle1.selecting = false
  end)
  self.toggle2:SetIsOn(false)
  self.toggle2.selecting = false
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      if not self.toggle2.selecting then
        DataCenter.LWSoundManager:PlaySound(6100023, false)
      end
      self:ToggleControlBorS(2)
    end
    self.toggle2.selecting = false
  end)
  self.toggle3:SetIsOn(false)
  self.toggle3.selecting = false
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      if not self.toggle3.selecting then
        DataCenter.LWSoundManager:PlaySound(6100023, false)
      end
      self:ToggleControlBorS(3)
    end
    self.toggle3.selecting = false
  end)
  self.toggleList = {}
  for i = 1, 3 do
    self.toggleList[i] = {}
    self.toggleList[i].img = self:AddComponent(UIImage, "Root/Rect_Group/Toggle" .. i .. "/RedDot" .. i)
    self.toggleList[i].txt = self:AddComponent(UIText, "Root/Rect_Group/Toggle" .. i .. "/RedDot" .. i .. "/Txt_RedNum" .. i)
  end
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.scroll_content = self:AddComponent(GridInfinityScrollView, scroll_content_path)
  self.mask_go = self:AddComponent(UIBaseContainer, mask_path)
  self.task_view = self:AddComponent(UIBaseContainer, task_view_path)
  self.task_content = self:AddComponent(GridInfinityScrollView, task_content_path)
  self.task_view_season = self:AddComponent(UIScrollRect, task_view_season_path)
  self.task_content_season = self:AddComponent(GridInfinityScrollView, task_content_season_path)
  self._oneGet_btn = self:AddComponent(UIButton, oneGet_btn_path)
  self._oneGet_btn:SetOnClick(function()
    self:OneGetClick()
  end)
  self._oneGetRed_rect = self:AddComponent(UIText, oneGetRed_rect_path)
  self._oneGet_txt = self:AddComponent(UIText, oneGet_txt_path)
  self._oneGet_txt:SetLocalText(110132)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    self:OnIntroClick()
  end)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.txt_act_extra = self:AddComponent(UIText, txt_act_extra_path)
  self.expText = self:AddComponent(UIText, exp_text_path)
  self.expImg = self:AddComponent(UIImage, "Root/TitleBg/ExpArea/Icon")
  self.progressSlider = self:AddComponent(UISlider, progress_path)
  self.progressSliderInstanceId = self.progressSlider.transform:GetInstanceID()
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.battlePassUnlimitedBox = self:AddComponent(BattlePassUnlimitedBox, battlePassUnlimitedBox_path)
  self.state2Btn = self:AddComponent(UIButton, state2BtnPath)
  self.state2Btn:SetOnClick(function()
    if self.actData and self.actData.battlePass.unlock == 0 then
      local windowName = self:GetPackagePopUpWindowName()
      UIManager:GetInstance():OpenWindow(windowName, tonumber(self.activityId), false)
    end
  end)
  self.state2LockIcon = self:AddComponent(UIImage, state2LockIconPath)
  self.state3Btn = self:AddComponent(UIButton, state3BtnPath)
  self.state3Btn:SetOnClick(function()
    if self.actData and self.actData.battlePass.high_unlock == 0 then
      local windowName = self:GetPackagePopUpWindowName()
      UIManager:GetInstance():OpenWindow(windowName, tonumber(self.activityId), true)
    end
  end)
  self.state3LockIcon = self:AddComponent(UIImage, state3LockIconPath)
  self.state2Effect = self:AddComponent(UIBaseContainer, state2EffectPath)
  self.state2Anim = self:AddComponent(UISimpleAnimation, state2AnimPath)
  self.state3Effect1 = self:AddComponent(UIBaseContainer, state3Effect1Path)
  self.state3Effect2 = self:AddComponent(UIBaseContainer, state3Effect2Path)
  self.state3Anim = self:AddComponent(UISimpleAnimation, state3AnimPath)
  self.state2Icon = self:AddComponent(UIImage, state2IconPath)
  self.state3Icon = self:AddComponent(UIImage, state3IconPath)
  if not IsNull(self.transform:Find(battle_pass_discount_path)) then
    self.battle_pass_discount = self:AddComponent(UIImage, battle_pass_discount_path)
    self.discount_text = self:AddComponent(UIText, discount_text_path)
  end
  self.state1Icon = self:AddComponent(UIImage, state1_icon_path)
end

local function ComponentDestroy(self)
  self.state1_bg = nil
  self.state2_bg = nil
  self.state3_bg = nil
  self._actName_txt = nil
  self.buy_btn = nil
  self._buyTitle_txt = nil
  self._time_txt = nil
  self._title_txt = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.toggle3 = nil
  self.toggle1Text = nil
  self.toggle2Text = nil
  self.toggle3Text = nil
  self.toggleList = nil
  self.scroll_view = nil
  self.scroll_content = nil
  self.mask_go = nil
  self.task_view = nil
  self.task_content = nil
  self.task_view_season = nil
  self.task_content_season = nil
  self._oneGet_btn = nil
  self._oneGetRed_rect = nil
  self._oneGet_txt = nil
  self.intro_btn = nil
  self.expText = nil
  self.progressSlider = nil
  self.progressSliderInstanceId = nil
  self.heroSpineContainer = nil
  self.battlePassUnlimitedBox = nil
  self.battle_pass_discount = nil
  self.discount_text = nil
end

local function DataDefine(self)
  self.view = nil
  self.itemList = {}
  self.curLevel = 0
  self.curIndex = 0
  self.packageInfo = nil
  self.listGOReward = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.view = nil
  self.itemList = nil
  self.curLevel = nil
  self.curIndex = nil
  self.listGO = nil
  self.listGOReward = nil
  self.timer_action = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBattlePass, self.OnBattlePassInfoRefresh)
  self:AddUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
  self:AddUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
  self:AddUIListener(EventId.ActBattlePassTask, self.RefreshTaskCell)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBattlePass, self.OnBattlePassInfoRefresh)
  self:RemoveUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
  self:RemoveUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
  self:RemoveUIListener(EventId.ActBattlePassTask, self.RefreshTaskCell)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  self.curType = 0
  self:BindRedPoint()
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if self.task_view_season ~= nil and self.task_content_season ~= nil and self.activityData ~= nil and self.activityData.seasonSubdivisionType == SeasonMapType.NineNationRainforest then
    UIBattlePassTaskCell = require("UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassTaskCellSeason")
    self.task_view:SetActive(false)
    self.task_view = self.task_view_season
    self.task_content = self.task_content_season
    self.task_view_season = nil
    self.task_content_season = nil
  elseif self.task_view_season ~= nil and self.task_content_season ~= nil then
    UIBattlePassTaskCell = require("UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassTaskCellNewYear")
    self.task_view_season:SetActive(false)
  end
  self:OnRefresh()
  if self.activityData then
    self:ReloadHeroSpine(self.activityData.activity_hero)
  end
end

local function ResetSpineTransform(self, obj)
  if not obj then
    return
  end
  local parent = self.heroSpineContainer
  if not parent then
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil and self.activityData then
    local posAndScaleStr = self.activityData.hero_para
    local spinePos = {0, 0}
    local spineScale = 1
    if posAndScaleStr then
      local posAndScale = string.split(posAndScaleStr, "|")
      if not table.IsNullOrEmpty(posAndScale) then
        local spinePosTable = string.split(posAndScale[1], ";")
        if not table.IsNullOrEmpty(spinePosTable) and table.count(spinePosTable) >= 2 then
          spinePos = {
            tonumber(spinePosTable[1]),
            tonumber(spinePosTable[2])
          }
        end
        if table.count(posAndScale) >= 2 then
          spineScale = tonumber(posAndScale[2])
        end
      end
    end
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(spineScale, spineScale, 1)
    rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
  end
end

local function ReloadHeroSpine(self, spinePath)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  if self.lastSpinePath ~= spinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      ResetSpineTransform(self, request.gameObject)
    end)
    self.lastSpinePath = spinePath
  elseif self.heroSpineLoadRequest then
    ResetSpineTransform(self, self.heroSpineLoadRequest.gameObject)
  end
end

local function RefreshProgressBar(self)
  if self.curAccuExp == nil then
    self.progressSlider:SetValue(0)
  end
  local count = #self.actData.stateInfo
  local progress = 0
  local step = 1 / (count - 1)
  local exp = self.curAccuExp
  if 0 < count then
    local needExp = DataCenter.ActBattlePassTemplateManager:GetLevelNeedExp(self.actData.activityId, 0, self.actData.type)
    if exp >= needExp then
      exp = exp - needExp
    else
      exp = 0
    end
    if 0 < exp then
      for i = 1, count do
        needExp = DataCenter.ActBattlePassTemplateManager:GetLevelNeedExp(self.actData.activityId, self.actData.stateInfo[i].level, self.actData.type)
        if exp >= needExp then
          exp = exp - needExp
          progress = progress + step
        else
          progress = exp / needExp * step + progress
          break
        end
      end
    end
  end
  progress = math.max(progress, 0)
  self.progressSlider:SetValue(progress)
end

function UIBattlePassNewYear:SendBattlePassMessage()
  if self.actData.type == EnumActivity.BattlePass_new.Type then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
  else
    SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo, toInt(self.activityId))
  end
end

local function RefreshTogglesVisible(self)
  if not self.actData then
    self.toggle2:SetActive(false)
    self.toggle3:SetActive(false)
    self.toggle1Line:SetActive(false)
    return
  end
  local toggle2Visible = true
  local toggle3Visible = true
  if table.IsNullOrEmpty(self.actData.taskArr[1]) then
    toggle2Visible = false
    self.toggle2:SetActive(false)
  else
    toggle2Visible = true
    self.toggle2:SetActive(true)
  end
  if table.IsNullOrEmpty(self.actData.taskArr[2]) then
    toggle3Visible = false
    self.toggle3:SetActive(false)
  else
    toggle3Visible = true
    self.toggle3:SetActive(true)
  end
  if toggle2Visible or toggle3Visible then
    self.toggle1Line:SetActive(true)
  else
    self.toggle1Line:SetActive(false)
  end
  if toggle2Visible then
    if toggle3Visible then
      self.toggle2Line:SetActive(true)
    else
      self.toggle2Line:SetActive(false)
    end
  end
end

local function OnRefresh(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  if self.actData and self.actData.lastResetTime == nil then
    self:SendBattlePassMessage()
    return
  end
  RefreshTogglesVisible(self)
  self:RefreshTop()
  self:RefreshRed()
  self:ShowCells()
  self:ToggleControlBorS(1)
  self:RefreshExtraBox()
end

local function OnBattlePassInfoRefresh(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  if self.actData and self.actData.lastResetTime == nil then
    self:SendBattlePassMessage()
    return
  end
  self:RefreshTop()
  self:RefreshExtraBox()
  self:RefreshCurSelcetContent()
  self:RefreshRed()
end

local function RefreshExtraBox(self)
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    self.battlePassUnlimitedBox:SetActive(false)
    local curOffsetMin = self.scroll_view:GetOffsetMin()
    self.scroll_view:SetOffsetMin({
      x = curOffsetMin.x,
      y = 0
    })
  else
    self.battlePassUnlimitedBox:SetActive(true)
    local curOffsetMin = self.scroll_view:GetOffsetMin()
    self.scroll_view:SetOffsetMin({
      x = curOffsetMin.x,
      y = 160
    })
    self.battlePassUnlimitedBox:ReInit(self.activityId)
  end
end

local function RefreshTop(self)
  local actListData = self.activityData
  if actListData then
    self._actName_txt:SetLocalText(actListData.name)
    self:RefreshTime(actListData)
    self:AddTimer(actListData)
  end
  local config = BattlePassUtil[actListData.subViewType]
  if config then
    self.state1Icon:LoadSprite(config.icon1)
    self.state2Icon:LoadSprite(config.icon2)
    self.state3Icon:LoadSprite(config.icon3)
    self.state1Icon:SetNativeSize()
    self.state2Icon:SetNativeSize()
    self.state3Icon:SetNativeSize()
  else
    if actListData and not string.IsNullOrEmpty(actListData.para_6) then
      local str = string.split(actListData.para_6, "|")
      if str and 3 <= #str then
        self.state1Icon:LoadSprite(string.format(LoadPath.BPNewYear, str[1]))
        self.state2Icon:LoadSprite(string.format(LoadPath.BPNewYear, str[2]))
        self.state3Icon:LoadSprite(string.format(LoadPath.BPNewYear, str[3]))
      end
    else
      self.state1Icon:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_maozi1.png")
      self.state2Icon:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_maozi2.png")
      self.state3Icon:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_maozi3.png")
    end
    self.state1Icon:SetNativeSize()
    self.state2Icon:SetNativeSize()
    self.state3Icon:SetNativeSize()
  end
  self.packageInfo = nil
  if self.actData.battlePass.unlock == 1 and self.actData:HaveHighPayStage() then
    self.packageInfo = GiftPackageData.get(self.actData:GetHighExchangeId())
    self._buyTitle_txt:SetLocalText("bp_buy_tips_super")
  else
    self.packageInfo = GiftPackageData.get(self.actData:GetExchangeId())
    self._buyTitle_txt:SetLocalText(320464)
  end
  if self.packageInfo and (self.actData.battlePass.unlock == 0 or self.actData.battlePass.high_unlock == 0) then
    self.buy_btn:SetActive(true)
    local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
    self.buy_btn:Init(self.packageInfo)
    self.buy_btn:RefreshPoint()
  else
    self.buy_btn:SetActive(false)
  end
  if actListData and actListData.forSeason and actListData.seasonType == SeasonMapType.NineNation then
    if actListData.seasonSubdivisionType == SeasonMapType.NineNation then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_dadiban.png")
      self.banner:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Textures/Activity/Bg/lrb_s5_zhanling_banner.png")
      self.state1_bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/bp/lrb_s5_zhanling_title1.png")
      self.state2_bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/bp/lrb_s5_zhanling_title2.png")
      self.state3_bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/bp/lrb_s5_zhanling_title3.png")
    elseif actListData.seasonSubdivisionType == SeasonMapType.NineNationRainforest then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_dadiban.png")
      self.banner:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Textures/Activity/Bg/mjc_s6_zhanling_banner.png")
      self.state1_bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/bp/mjc_s6_zhanling_title1.png")
      self.state2_bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/bp/mjc_s6_zhanling_title2.png")
      self.state3_bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/bp/mjc_s6_zhanling_title3.png")
    end
  else
    local defaultFlag = true
    if actListData and not string.IsNullOrEmpty(actListData.activity_pic) then
      defaultFlag = false
      self.banner:LoadSpriteAsync(string.format(LoadPath.ActivityBattlePassBannerPath, actListData.activity_pic))
    end
    if defaultFlag then
      self.banner:LoadSpriteAsync(string.format(LoadPath.ActivityBattlePassBannerPath, "zyf_xinnianbp_banner"))
    end
    if actListData and actListData.subViewType == BattlePassType.NormalDouble then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyon_quanping_erji_chen.png")
    elseif actListData and actListData.subViewType == BattlePassType.Easter then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_fuhuojie_dadiban.png")
    else
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_dadiban.png")
    end
    self.state1_bg:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_title1.png")
    self.state2_bg:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_title2.png")
    self.state3_bg:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_title3.png")
  end
  if actListData and not string.IsNullOrEmpty(actListData.bannerTittle) then
    self.txt_act_extra:SetLocalText(actListData.bannerTittle)
  else
    self.txt_act_extra:SetText("")
  end
  self.curAccuExp = self.actData:GetCurrentAccumulatedExp()
  local itemId = GetTableData(TableName.Activity, self.activityId, "para_5")
  if not string.IsNullOrEmpty(itemId) then
    local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(itemId))
    self.expImg:LoadSprite(iconPath)
  else
    self.expImg:LoadSprite(string.format(LoadPath.ItemPath, "zyf_battlepass_icon2"))
  end
  self.expText:SetText(self.curAccuExp)
  RefreshProgressBar(self)
  self.state2LockIcon:SetActive(self.actData.battlePass.unlock == 0)
  self.state2Btn:SetInteractable(self.actData.battlePass.unlock == 0)
  self.state3LockIcon:SetActive(self.actData.battlePass.high_unlock == 0)
  self.state3Btn:SetInteractable(self.actData.battlePass.high_unlock == 0)
  if self.actData.battlePass.unlock == 0 then
    self.state2Effect:SetActive(true)
    self.state2Anim:Play("move")
  else
    self.state2Effect:SetActive(false)
    self.state2Anim:Stop()
    self.state2Icon:SetLocalScaleXYZ(1, 1, 1)
  end
  if self.actData.battlePass.high_unlock == 0 then
    self.state3Effect1:SetActive(true)
    self.state3Effect2:SetActive(true)
    self.state3Anim:Play("move")
  else
    self.state3Effect1:SetActive(false)
    self.state3Effect2:SetActive(false)
    self.state3Anim:Stop()
    self.state3Icon:SetLocalScaleXYZ(1, 1, 1)
  end
  self:RefreshDiscountContent()
end

local function RefreshDiscountContent(self)
  if self.battle_pass_discount then
    if self.packageInfo then
      self.battle_pass_discount:SetActive(true)
      self.discount_text:SetText(string.format("%s%%", self.packageInfo:getPercent()))
    else
      self.battle_pass_discount:SetActive(false)
    end
  end
end

local function AddTimer(self, actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self, actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime then
    self:DeleteTimer()
  else
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function BindRedPoint(self)
end

local function RefreshRed(self)
  for i = 1, 3 do
    local num = self.actData:GetRedNum(i)
    if 0 < num then
      self.toggleList[i].img:SetActive(true)
      self.toggleList[i].txt:SetText(num)
    else
      self.toggleList[i].img:SetActive(false)
    end
  end
  local num = self.actData:GetRedNum()
  self._oneGetRed_rect:SetActive(0 < num)
end

local function InitTask(self, type)
  if self.listGO then
    return
  end
  self.listGO = {}
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.task_content:Init(bindFunc1, bindFunc2, bindFunc3)
  self.taskList = self.actData.taskArr[type]
  self.task_content:SetItemCount(#self.taskList)
end

local function OnInitScroll(self, go, index)
  local item = self.task_view:AddComponent(UIBattlePassTaskCell, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local sub = self.taskList[index + 1]
  local cellItem = self.listGO[go]
  if sub == nil then
    return
  end
  local param = {}
  param.info = sub
  param.index = index + 1
  param.actId = toInt(self.activityId)
  param.unlock = self.actData.battlePass.unlock
  param.high_unlock = self.actData.battlePass.high_unlock
  param.flyPos = self.expImg.transform.position
  param.type = self.actData.type
  cellItem:RefreshData(param)
end

local function OnDestroyScrollItem(self, go, index)
end

local function OnGetRewardItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.actData.stateInfo then
    return nil
  end
  index = index + 1
  if index <= #self.actData.stateInfo then
    local item = loopScroll:NewListViewItem("UIBattlePassItem")
    local script = self.scroll_content:GetComponent(item.gameObject.name, UIBattlePassRewardItem)
    if script == nil then
      local objectName = tostring(self.itemIndex)
      self.itemIndex = self.itemIndex + 1
      item.gameObject.name = objectName
      script = self.scroll_content:AddComponent(UIBattlePassRewardItem, objectName)
    end
    local data = self.actData.stateInfo[index]
    data.isFirst = index == 1
    data.isLast = index == #self.actData.stateInfo
    if index == 1 then
      data.pro = self.actData.battlePass.level / data.level
      data.showBallLeft = false
      if self.actData.battlePass.level < data.level then
        self.curIndex = index
      end
    else
      local lastData = self.actData.stateInfo[index - 1]
      data.pro = (self.actData.battlePass.level - lastData.level) / (data.level - lastData.level)
      data.showBallLeft = self.actData.battlePass.level >= lastData.level
      if self.actData.battlePass.level < data.level and self.actData.battlePass.level >= lastData.level then
        self.curIndex = index
      end
    end
    if self.activityData then
      data.forSeason = self.activityData.forSeason
      data.seasonType = self.activityData.seasonType
      data.seasonSubdivisionType = self.activityData.seasonSubdivisionType
    end
    data.showBallRight = self.actData.battlePass.level >= data.level
    data.curLv = self.actData.battlePass.level
    data.unlock = self.actData.battlePass.unlock
    data.actId = toInt(self.activityId)
    script:SetData(data, self)
    self.itemList[index] = item
    self.listGOReward[item] = script
    return item
  else
    return nil
  end
end

local function ShowCells(self)
  if self.listGOReward then
    return
  end
  self.listGOReward = {}
  local bindFunc1 = BindCallback(self, self.OnInitRewardScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateRewardScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyRewardScrollItem)
  self.scroll_content:Init(bindFunc1, bindFunc2, bindFunc3)
  local count = #self.actData.stateInfo
  if count == 0 then
    self.scroll_view:SetActive(false)
  else
    self.scroll_view:SetActive(true)
    self.scroll_content:SetItemCount(count)
    self.scroll_content:ForceUpdate()
    local index = DataCenter.ActBattlePassData:CheckCurGetReward(tonumber(self.activityId))
    self.scroll_content:MoveItemByIndex(index - 1, 0)
  end
  local renderItemSizeY = self.scroll_content:GetRenderItemSizeY()
  self.progressSlider.rectTransform:Set_sizeDelta(37, (count - 1) * renderItemSizeY)
end

local function SetBlackPos(self, nextTemplate)
  if nextTemplate then
    self.black_mask_go.transform:SetParent(self.scroll_content.transform)
    local width = 130 * (#self.actData.stateInfo - self.actData.battlePass.level)
    self.black_mask_go.rectTransform.sizeDelta = Vector2.New(width, 463)
    self.black_mask_go.transform:SetAsLastSibling()
    self.black_mask_go:SetAnchoredPositionXY(0, 0)
    self.black_mask_go:SetActive(true)
  else
    self.black_mask_go:SetActive(false)
  end
end

local function OnInitRewardScroll(self, go, index)
  local item = self.scroll_view:AddComponent(UIBattlePassRewardItem, go)
  self.listGOReward[go] = item
end

local function OnUpdateRewardScroll(self, go, index)
  index = index + 1
  if index <= #self.actData.stateInfo then
    local item = self.listGOReward[go]
    local data = self.actData.stateInfo[index]
    data.isFirst = index == 1
    data.isLast = index == #self.actData.stateInfo
    if index == 1 then
      data.pro = self.actData.battlePass.level / data.level
      data.showBallLeft = false
      if self.actData.battlePass.level < data.level then
        self.curIndex = index
      end
    else
      local lastData = self.actData.stateInfo[index - 1]
      data.pro = (self.actData.battlePass.level - lastData.level) / (data.level - lastData.level)
      data.showBallLeft = self.actData.battlePass.level >= lastData.level
      if self.actData.battlePass.level < data.level and self.actData.battlePass.level >= lastData.level then
        self.curIndex = index
      end
    end
    if self.activityData then
      data.forSeason = self.activityData.forSeason
      data.seasonType = self.activityData.seasonType
      data.seasonSubdivisionType = self.activityData.seasonSubdivisionType
    end
    data.showBallRight = self.actData.battlePass.level >= data.level
    data.curLv = self.actData.battlePass.level
    data.unlock = self.actData.battlePass.unlock
    data.high_unlock = self.actData.battlePass.high_unlock
    data.actId = toInt(self.activityId)
    data.type = self.actData.type
    item:SetData(data, self)
    go:SetActive(true)
    self.itemList[index] = item
  end
end

local function OnDestroyRewardScrollItem(self, go, index)
end

local unselectedTextColor = Color.New(0.4667, 0.4431, 0.4431, 1)
local selectedTextColor = Color.New(0.1647, 0.1569, 0.1882, 1)

local function ToggleControlBorS(self, index)
  if self.curType == index then
    return
  end
  local actListData = self.activityData
  self.curType = index
  if index == 1 then
    self.task_view:SetActive(false)
    self.mask_go:SetActive(true)
    self._oneGet_btn:SetActive(true)
    self.taskIndex = 0
    self._title_txt:SetLocalText(130065)
    self.toggle1Text:SetColor(selectedTextColor)
    self.toggle2Text:SetColor(unselectedTextColor)
    self.toggle3Text:SetColor(unselectedTextColor)
  elseif index == 2 then
    self.task_view:SetActive(true)
    self.mask_go:SetActive(false)
    self.actData:TaskSortHandle(1, self.actData.type)
    self.taskList = self.actData.taskArr[1]
    self:InitTask(1)
    self._oneGet_btn:SetActive(true)
    self.taskIndex = 1
    self.task_content:SetItemCount(#self.taskList)
    self._title_txt:SetLocalText(170015)
    self.toggle1Text:SetColor(unselectedTextColor)
    self.toggle2Text:SetColor(selectedTextColor)
    self.toggle3Text:SetColor(unselectedTextColor)
  elseif index == 3 then
    self.task_view:SetActive(true)
    self.mask_go:SetActive(false)
    self.actData:TaskSortHandle(2, self.actData.type)
    self.taskList = self.actData.taskArr[2]
    self:InitTask(2)
    self._oneGet_btn:SetActive(true)
    self.taskIndex = 2
    self.task_content:SetItemCount(#self.taskList)
    self._title_txt:SetLocalText(320430)
    self.toggle1Text:SetColor(unselectedTextColor)
    self.toggle2Text:SetColor(unselectedTextColor)
    self.toggle3Text:SetColor(selectedTextColor)
  end
end

local function RefreshCurSelcetContent(self)
  if not self.curType then
    return
  end
  if self.curType == 1 then
    self.taskIndex = 0
    self:ShowCells()
  elseif self.curType == 2 then
    self.actData:TaskSortHandle(1, self.actData.type)
    self.taskList = self.actData.taskArr[1]
    self:InitTask(1)
    self.taskIndex = 1
    self.task_content:SetItemCount(#self.taskList)
  elseif self.curType == 3 then
    self.actData:TaskSortHandle(2, self.actData.type)
    self.taskList = self.actData.taskArr[2]
    self:InitTask(2)
    self.taskIndex = 2
    self.task_content:SetItemCount(#self.taskList)
  end
end

local function RefreshBattlePass(self, actId)
  if actId and tonumber(actId) and tonumber(actId) ~= tonumber(self.activityId) then
    return
  end
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self:RefreshTop()
  if self.taskIndex == 0 then
    self.taskList = self.actData.taskArr[1]
  else
    self.taskList = self.actData.taskArr[self.taskIndex]
  end
  if self.listGO then
    self.task_content:ForceUpdate()
  end
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
  self:RefreshExtraBox()
end

local function RefreshRewardCell(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
end

local function RefreshTaskCell(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self:RefreshTop()
  if self.taskIndex == 0 then
    self.actData:TaskSortHandle(1, self.actData.type)
    self.taskList = self.actData.taskArr[1]
  else
    self.actData:TaskSortHandle(self.taskIndex, self.actData.type)
    self.taskList = self.actData.taskArr[self.taskIndex]
  end
  if self.listGO then
    self.task_content:ForceUpdate()
  end
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
  self:RefreshExtraBox()
end

local function ClearScroll(self)
  self.scroll_view:RemoveComponents(UIBattlePassRewardItem)
  self.scroll_content:DestroyChildNodeExceptIndex(self.progressSliderInstanceId)
  self.task_view:RemoveComponents(UIBattlePassTaskCell)
  self.task_content:DestroyChildNode()
end

local function OnBuyLvUpClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassBuy, toInt(self.activityId))
end

local function OneGetClick(self)
  local num = self.actData:GetRedNum()
  if 0 < num then
    if self.actData.type == EnumActivity.BattlePass_new.Type then
      SFSNetwork.SendMessage(MsgDefines.NewReceiveBPAllReward, toInt(self.activityId))
    else
      SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassAllReward, toInt(self.activityId))
    end
  else
    UIUtil.ShowTipsId(320446)
  end
end

local function OnBuyClick(self)
  if self.actData then
    local windowName = self:GetPackagePopUpWindowName()
    if self.actData.battlePass.unlock == 0 then
      UIManager:GetInstance():OpenWindow(windowName, tonumber(self.activityId), false)
    elseif self.actData.battlePass.high_unlock == 0 then
      UIManager:GetInstance():OpenWindow(windowName, tonumber(self.activityId), true)
    end
  end
end

local function OnIntroClick(self)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityData == nil then
    return
  end
  local param = {}
  param.activityRulesStr = Localization:GetString(activityData.story)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
end

local function GetPackagePopUpWindowName(self)
  local activityData = self.activityData
  local viewName = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp
  if activityData then
    if activityData.subViewType == BattlePassType.NewYear then
      viewName = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp
    elseif activityData.subViewType == BattlePassType.Valentine then
      viewName = UIWindowNames.UIBattlePassValentineGiftPackagePopUp
    elseif activityData.subViewType == BattlePassType.Easter then
      viewName = UIWindowNames.UIBattlePassEasterGiftPackagePopUp
    elseif activityData.subViewType == BattlePassType.Ramadan then
      viewName = UIWindowNames.UIBattlePassRamadanGiftPackagePopUp
    end
  end
  return viewName
end

UIBattlePassNewYear.OnCreate = OnCreate
UIBattlePassNewYear.OnDestroy = OnDestroy
UIBattlePassNewYear.OnEnable = OnEnable
UIBattlePassNewYear.OnDisable = OnDisable
UIBattlePassNewYear.ComponentDefine = ComponentDefine
UIBattlePassNewYear.ComponentDestroy = ComponentDestroy
UIBattlePassNewYear.DataDefine = DataDefine
UIBattlePassNewYear.DataDestroy = DataDestroy
UIBattlePassNewYear.OnAddListener = OnAddListener
UIBattlePassNewYear.OnRemoveListener = OnRemoveListener
UIBattlePassNewYear.SetData = SetData
UIBattlePassNewYear.OnRefresh = OnRefresh
UIBattlePassNewYear.RefreshTop = RefreshTop
UIBattlePassNewYear.BindRedPoint = BindRedPoint
UIBattlePassNewYear.RefreshRed = RefreshRed
UIBattlePassNewYear.RefreshDiscountContent = RefreshDiscountContent
UIBattlePassNewYear.InitTask = InitTask
UIBattlePassNewYear.OnInitScroll = OnInitScroll
UIBattlePassNewYear.OnUpdateScroll = OnUpdateScroll
UIBattlePassNewYear.OnDestroyScrollItem = OnDestroyScrollItem
UIBattlePassNewYear.ShowCells = ShowCells
UIBattlePassNewYear.OnInitRewardScroll = OnInitRewardScroll
UIBattlePassNewYear.OnUpdateRewardScroll = OnUpdateRewardScroll
UIBattlePassNewYear.OnDestroyRewardScrollItem = OnDestroyRewardScrollItem
UIBattlePassNewYear.ToggleControlBorS = ToggleControlBorS
UIBattlePassNewYear.RefreshBattlePass = RefreshBattlePass
UIBattlePassNewYear.RefreshRewardCell = RefreshRewardCell
UIBattlePassNewYear.RefreshTaskCell = RefreshTaskCell
UIBattlePassNewYear.RefreshExtraBox = RefreshExtraBox
UIBattlePassNewYear.ClearScroll = ClearScroll
UIBattlePassNewYear.AddTimer = AddTimer
UIBattlePassNewYear.RefreshTime = RefreshTime
UIBattlePassNewYear.DeleteTimer = DeleteTimer
UIBattlePassNewYear.OneGetClick = OneGetClick
UIBattlePassNewYear.OnBuyLvUpClick = OnBuyLvUpClick
UIBattlePassNewYear.OnBuyClick = OnBuyClick
UIBattlePassNewYear.OnIntroClick = OnIntroClick
UIBattlePassNewYear.SetBlackPos = SetBlackPos
UIBattlePassNewYear.OnGetRewardItemByIndex = OnGetRewardItemByIndex
UIBattlePassNewYear.ReloadHeroSpine = ReloadHeroSpine
UIBattlePassNewYear.OnBattlePassInfoRefresh = OnBattlePassInfoRefresh
UIBattlePassNewYear.RefreshCurSelcetContent = RefreshCurSelcetContent
UIBattlePassNewYear.GetPackagePopUpWindowName = GetPackagePopUpWindowName
return UIBattlePassNewYear
