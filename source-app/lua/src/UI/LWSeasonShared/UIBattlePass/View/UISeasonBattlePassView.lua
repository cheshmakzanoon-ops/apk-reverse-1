local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UISeasonBattlePassView = BaseClass("UISeasonBattlePassView", base)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local UISeasonBattlePassTaskItem = require("UI.LWSeasonShared.UIBattlePass.Component.UISeasonBattlePassTaskItem")
local UISeasonBattlePassRewardItem = require("UI.LWSeasonShared.UIBattlePass.Component.UISeasonBattlePassRewardItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UISeasonBattlePassUnlimitBox = require("UI.LWSeasonShared.UIBattlePass.Component.UISeasonBattlePassUnlimitBox")
local UISeasonBattlePassCtrl = require("UI.LWSeasonShared.UIBattlePass.Controller.UISeasonBattlePassCtrl")
local battle_pass_discount_path = "Root/BattlePassDiscount"
local discount_text_path = "Root/BattlePassDiscount/DiscountText"

function UISeasonBattlePassView:OnCreate()
  base.OnCreate(self)
  if self.ctrl == nil then
    self.ctrl = UISeasonBattlePassCtrl.New()
  end
  self:ComponentDefine()
  self:DataDefine()
end

function UISeasonBattlePassView:OnDestroy()
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
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonBattlePassView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self._time_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self._actName_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.buy_btn = self.viewSkin:AddComponent(self, LWBtnBuyRefundRemind, 3)
  self._buyTitle_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.toggle1 = self.viewSkin:AddComponent(self, UIToggle, 5)
  self.toggle2 = self.viewSkin:AddComponent(self, UIToggle, 6)
  self.toggle3 = self.viewSkin:AddComponent(self, UIToggle, 7)
  self.toggle1Text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.toggle2Text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.toggle3Text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.toggle1Line = self.viewSkin:AddComponent(self, UIImage, 11)
  self.toggle2Line = self.viewSkin:AddComponent(self, UIImage, 12)
  self.toggle3Line = self.viewSkin:AddComponent(self, UIImage, 13)
  self.scroll_view = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.mask_go = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.scroll_content = self.viewSkin:AddComponent(self, GridInfinityScrollView, 16)
  self.task_view = self.viewSkin:AddComponent(self, UIScrollRect, 17)
  self.task_content = self.viewSkin:AddComponent(self, GridInfinityScrollView, 18)
  self._oneGet_btn = self.viewSkin:AddComponent(self, UIButton, 19)
  self._oneGet_btn:SetOnClick(function()
    self:On_oneGet_btnClick()
  end)
  self._oneGetRed_rect = self.viewSkin:AddComponent(self, UIBaseContainer, 20)
  self._oneGet_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.intro_btn = self.viewSkin:AddComponent(self, UIButton, 22)
  self.intro_btn:SetOnClick(function()
    self:OnIntro_btnClick()
  end)
  self._title_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.expText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.progressSlider = self.viewSkin:AddComponent(self, UISlider, 25)
  self.bg = self.viewSkin:AddComponent(self, UIImage, 26)
  self.banner = self.viewSkin:AddComponent(self, UIRawImage, 27)
  self.txt_act_extra = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.heroSpineContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 29)
  self.battlePassUnlimitedBox = self.viewSkin:AddComponent(self, UISeasonBattlePassUnlimitBox, 30)
  self.state2Btn = self.viewSkin:AddComponent(self, UIButton, 31)
  self.state2Btn:SetOnClick(function()
    self:OnState2BtnClick()
  end)
  self.state2LockIcon = self.viewSkin:AddComponent(self, UIImage, 32)
  self.state3Btn = self.viewSkin:AddComponent(self, UIButton, 33)
  self.state3Btn:SetOnClick(function()
    self:OnState3BtnClick()
  end)
  self.state3LockIcon = self.viewSkin:AddComponent(self, UIImage, 34)
  self.state2Effect = self.viewSkin:AddComponent(self, UIBaseContainer, 35)
  self.state2Anim = self.viewSkin:AddComponent(self, UISimpleAnimation, 36)
  self.state3Effect1 = self.viewSkin:AddComponent(self, UIBaseContainer, 37)
  self.state3Effect2 = self.viewSkin:AddComponent(self, UIBaseContainer, 38)
  self.state3Anim = self.viewSkin:AddComponent(self, UISimpleAnimation, 39)
  self.state2Icon = self.viewSkin:AddComponent(self, UIImage, 40)
  self.state3Icon = self.viewSkin:AddComponent(self, UIImage, 41)
  self.state1Icon = self.viewSkin:AddComponent(self, UIImage, 42)
  self.state1_bg = self.viewSkin:AddComponent(self, UIImage, 43)
  self.state2_bg = self.viewSkin:AddComponent(self, UIImage, 44)
  self.state3_bg = self.viewSkin:AddComponent(self, UIImage, 45)
  if not IsNull(self.transform:Find(battle_pass_discount_path)) then
    self.battle_pass_discount = self:AddComponent(UIImage, battle_pass_discount_path)
    self.discount_text = self:AddComponent(UIText, discount_text_path)
  end
  self._oneGet_txt:SetLocalText(110132)
  self._buyTitle_txt:SetLocalText(320464)
  self.expImg = self:AddComponent(UIImage, "Root/TitleBg/ExpArea/Icon")
  self:InitToggle()
  self.buy_btn:SetBuyClickAction(function()
    self:OnBuyClick()
  end)
  self.buy_btn:SetSafeClickMode(true)
  self.progressSliderInstanceId = self.progressSlider.transform:GetInstanceID()
end

function UISeasonBattlePassView:ComponentDestroy()
  self.viewSkin = nil
  self._time_txt = nil
  self._actName_txt = nil
  self.buy_btn = nil
  self._buyTitle_txt = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.toggle3 = nil
  self.toggle1Text = nil
  self.toggle2Text = nil
  self.toggle3Text = nil
  self.toggle1Line = nil
  self.toggle2Line = nil
  self.toggle3Line = nil
  self.scroll_view = nil
  self.mask_go = nil
  self.scroll_content = nil
  self.task_view = nil
  self.task_content = nil
  self._oneGet_btn = nil
  self._oneGetRed_rect = nil
  self._oneGet_txt = nil
  self.intro_btn = nil
  self._title_txt = nil
  self.expText = nil
  self.progressSlider = nil
  self.bg = nil
  self.banner = nil
  self.txt_act_extra = nil
  self.heroSpineContainer = nil
  self.battlePassUnlimitedBox = nil
  self.state2Btn = nil
  self.state2LockIcon = nil
  self.state3Btn = nil
  self.state3LockIcon = nil
  self.state2Effect = nil
  self.state2Anim = nil
  self.state3Effect1 = nil
  self.state3Effect2 = nil
  self.state3Anim = nil
  self.state2Icon = nil
  self.state3Icon = nil
  self.state1Icon = nil
  self.state1_bg = nil
  self.state2_bg = nil
  self.state3_bg = nil
  self.battle_pass_discount = nil
  self.discount_text = nil
  self.toggleList = nil
  self.progressSliderInstanceId = nil
end

function UISeasonBattlePassView:DataDefine()
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

function UISeasonBattlePassView:DataDestroy()
  self.view = nil
  self.itemList = nil
  self.curLevel = nil
  self.curIndex = nil
  self.listGO = nil
  self.listGOReward = nil
  self.timer_action = nil
end

function UISeasonBattlePassView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBattlePass, self.OnBattlePassInfoRefresh)
  self:AddUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
  self:AddUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
  self:AddUIListener(EventId.ActBattlePassTask, self.RefreshTaskCell)
end

function UISeasonBattlePassView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActBattlePass, self.OnBattlePassInfoRefresh)
  self:RemoveUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
  self:RemoveUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
  self:RemoveUIListener(EventId.ActBattlePassTask, self.RefreshTaskCell)
  base.OnRemoveListener(self)
end

function UISeasonBattlePassView:OnEnable()
  base.OnEnable(self)
end

function UISeasonBattlePassView:OnDisable()
  base.OnDisable(self)
  self.toggle1:SetIsOn(true)
  self.toggle2:SetIsOn(false)
  self.toggle3:SetIsOn(false)
end

function UISeasonBattlePassView:On_oneGet_btnClick()
  self.ctrl:OnClickOneGet(self.activityId, self.actData)
end

function UISeasonBattlePassView:OnIntro_btnClick()
  self.ctrl:OnClickIntro(self.activityId)
end

function UISeasonBattlePassView:OnState2BtnClick()
  if self.actData and self.actData.battlePass.unlock == 0 then
    self.ctrl:OpenPackagePopUp(self.activityId, false)
  end
end

function UISeasonBattlePassView:OnState3BtnClick()
  if self.actData and self.actData.battlePass.high_unlock == 0 then
    self.ctrl:OpenPackagePopUp(self.activityId, true)
  end
end

function UISeasonBattlePassView:InitToggle()
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
end

function UISeasonBattlePassView:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  self.curType = 0
  self:BindRedPoint()
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self:OnRefresh()
  if self.activityData then
    self:ReloadHeroSpine(self.activityData.activity_hero)
  end
end

function UISeasonBattlePassView:ResetSpineTransform(obj)
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

function UISeasonBattlePassView:ReloadHeroSpine(spinePath)
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
      self:ResetSpineTransform(request.gameObject)
    end)
    self.lastSpinePath = spinePath
  elseif self.heroSpineLoadRequest then
    self:ResetSpineTransform(self.heroSpineLoadRequest.gameObject)
  end
end

function UISeasonBattlePassView:RefreshProgressBar()
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

function UISeasonBattlePassView:SendBattlePassMessage()
  self.ctrl:SendBattlePassMessage(self.activityId)
end

function UISeasonBattlePassView:RefreshTogglesVisible()
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

function UISeasonBattlePassView:OnRefresh()
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  if self.actData and self.actData.lastResetTime == nil then
    self:SendBattlePassMessage()
    return
  end
  self:RefreshTogglesVisible()
  self:RefreshTop()
  self:RefreshRed()
  self:ShowCells()
  self:ToggleControlBorS(1)
  self:RefreshExtraBox()
end

function UISeasonBattlePassView:OnBattlePassInfoRefresh()
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  if self.actData and self.actData.lastResetTime == nil then
    self:SendBattlePassMessage()
    return
  end
  self:RefreshTop()
  self:RefreshExtraBox()
  self:RefreshCurSelectContent()
  self:RefreshRed()
end

function UISeasonBattlePassView:RefreshExtraBox()
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

function UISeasonBattlePassView:RefreshTop()
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
  self:RefreshProgressBar()
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

function UISeasonBattlePassView:RefreshDiscountContent()
  if self.battle_pass_discount then
    if self.packageInfo then
      self.battle_pass_discount:SetActive(true)
      self.discount_text:SetText(string.format("%s%%", self.packageInfo:getPercent()))
    else
      self.battle_pass_discount:SetActive(false)
    end
  end
end

function UISeasonBattlePassView:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UISeasonBattlePassView:RefreshTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime then
    self:DeleteTimer()
  else
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
  end
end

function UISeasonBattlePassView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UISeasonBattlePassView:BindRedPoint()
end

function UISeasonBattlePassView:RefreshRed()
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

function UISeasonBattlePassView:InitTask(type)
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

function UISeasonBattlePassView:OnInitScroll(go, index)
  local item = self.task_view:AddComponent(UISeasonBattlePassTaskItem, go)
  self.listGO[go] = item
end

function UISeasonBattlePassView:OnUpdateScroll(go, index)
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

function UISeasonBattlePassView:OnDestroyScrollItem(go, index)
end

function UISeasonBattlePassView:OnGetRewardItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.actData.stateInfo then
    return nil
  end
  index = index + 1
  if index <= #self.actData.stateInfo then
    local item = loopScroll:NewListViewItem("UIBattlePassItem")
    local script = self.scroll_content:GetComponent(item.gameObject.name, UISeasonBattlePassRewardItem)
    if script == nil then
      local objectName = tostring(self.itemIndex)
      self.itemIndex = self.itemIndex + 1
      item.gameObject.name = objectName
      script = self.scroll_content:AddComponent(UISeasonBattlePassRewardItem, objectName)
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

function UISeasonBattlePassView:ShowCells()
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

function UISeasonBattlePassView:SetBlackPos(nextTemplate)
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

function UISeasonBattlePassView:OnInitRewardScroll(go, index)
  local item = self.scroll_view:AddComponent(UISeasonBattlePassRewardItem, go)
  self.listGOReward[go] = item
end

function UISeasonBattlePassView:OnUpdateRewardScroll(go, index)
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

function UISeasonBattlePassView:OnDestroyRewardScrollItem(go, index)
end

local unselectedTextColor = Color.New(0.4667, 0.4431, 0.4431, 1)
local selectedTextColor = Color.New(0.1647, 0.1569, 0.1882, 1)

function UISeasonBattlePassView:ToggleControlBorS(index)
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

function UISeasonBattlePassView:RefreshCurSelectContent()
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

function UISeasonBattlePassView:RefreshBattlePass(actId)
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

function UISeasonBattlePassView:RefreshRewardCell()
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
end

function UISeasonBattlePassView:RefreshTaskCell()
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

function UISeasonBattlePassView:ClearScroll()
  self.scroll_view:RemoveComponents(UISeasonBattlePassRewardItem)
  self.scroll_content:DestroyChildNodeExceptIndex(self.progressSliderInstanceId)
  self.task_view:RemoveComponents(UISeasonBattlePassTaskItem)
  self.task_content:DestroyChildNode()
end

function UISeasonBattlePassView:OnBuyLvUpClick()
  self.ctrl:BuyLvUp(self.activityId)
end

function UISeasonBattlePassView:OnBuyClick()
  if self.actData then
    if self.actData.battlePass.unlock == 0 then
      self.ctrl:OpenPackagePopUp(self.activityId, false)
    elseif self.actData.battlePass.high_unlock == 0 then
      self.ctrl:OpenPackagePopUp(self.activityId, true)
    end
  end
end

return UISeasonBattlePassView
