local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIBattlePassS5 = BaseClass("UIBattlePassS5", base)
local UIBattlePassNormalNewTaskCell = require("UI.LWSeason5.UIBattlePassS5.UIBattlePassTaskCellS5")
local UIBattlePassNormalNewRewardItem = require("UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassRewardItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local BattlePassUnlimitedBox = require("UI.UIActivityCenterTable.Component.UIBattlePass.BattlePassUnlimitedBox")
local UIBattlePassNormalNewViewShowConfig = require("UI.UIActivityCenterTable.Component.UIBattlePass.ViewShowConfig.UIBattlePassNormalNewViewShowConfig")
local BPDetailBtnContent = require("UI.UIActivityCenterTable.Component.UIBattlePass.BPDetailBtnContent")
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
local toggle1_line_path = "Root/Rect_Group/Toggle1/Line1"
local toggle2_line_path = "Root/Rect_Group/Toggle2/Line2"
local toggle3_line_path = "Root/Rect_Group/Toggle3/Line3"
local scroll_view_path = "Root/Mask/ScrollView"
local scroll_content_path = "Root/Mask/ScrollView/Content"
local mask_path = "Root/Mask"
local task_view_path = "Root/TaskView"
local task_content_path = "Root/TaskView/TaskContent"
local point_path = "Root/TitleBg/BuyBtn/UIGiftPackagePoint"
local oneGet_btn_path = "Root/Btn_List/Btn_OneGet"
local oneGet_txt_path = "Root/Btn_List/Btn_OneGet/Txt_OneGet"
local oneGetRed_rect_path = "Root/Btn_List/Btn_OneGet/Rect_OnGetRed"
local intro_btn_path = "Root/TitleBg/Intro"
local exp_text_path = "Root/TitleBg/ExpArea/ExpText"
local progress_path = "Root/Mask/ScrollView/Content/ProgressBar"
local banner_path = "ImageBg2"
local txt_act_extra_path = "Root/TitleBg/Txt_ActExtra"
local heroSpineContainerPath = "Root/TitleBg/HeroSpineContainer"
local battlePassUnlimitedBox_path = "Root/Mask/BattlePassUnlimitedBox"
local battle_pass_discount_path = "Root/BattlePassDiscount"
local discount_text_path = "Root/BattlePassDiscount/DiscountText"
local image_bg_path = "ImageBg"
local image_bg3_path = "ImageBg3"
local progress_bar_bg_path = "Root/Mask/ScrollView/Content/ProgressBar/ProgressBarBg"
local checkmark1_path = "Root/Rect_Group/Toggle1/Background/Checkmark1"
local checkmark2_path = "Root/Rect_Group/Toggle2/Background/Checkmark2"
local checkmark3_path = "Root/Rect_Group/Toggle3/Background/Checkmark3"
local b_p_detail_btn_content_path = "Root/TitleBg/BPDetailBtnContent"

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
  if self.viewShowConfig then
    self.viewShowConfig:Delete()
    self.viewShowConfig = nil
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
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle1Line = self:AddComponent(UIImage, toggle1_line_path)
  self.toggle2Line = self:AddComponent(UIImage, toggle2_line_path)
  self.toggle3Line = self:AddComponent(UIImage, toggle3_line_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(1)
    end
  end)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(2)
    end
  end)
  self.toggle3:SetIsOn(false)
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(3)
    end
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
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.txt_act_extra = self:AddComponent(UIText, txt_act_extra_path)
  self.expText = self:AddComponent(UIText, exp_text_path)
  self.expImg = self:AddComponent(UIImage, "Root/TitleBg/ExpArea/Icon")
  self.progressSlider = self:AddComponent(UISlider, progress_path)
  self.progressSliderInstanceId = self.progressSlider.transform:GetInstanceID()
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.battlePassUnlimitedBox = self:AddComponent(BattlePassUnlimitedBox, battlePassUnlimitedBox_path)
  if not IsNull(self.transform:Find(battle_pass_discount_path)) then
    self.battle_pass_discount = self:AddComponent(UIImage, battle_pass_discount_path)
    self.discount_text = self:AddComponent(UIText, discount_text_path)
  end
  self.image_bg = self:AddComponent(UIImage, image_bg_path)
  self.image_bg3 = self:AddComponent(UIImage, image_bg3_path)
  self.progress_bar_bg = self:AddComponent(UIImage, progress_bar_bg_path)
  self.checkmark1 = self:AddComponent(UIImage, checkmark1_path)
  self.checkmark2 = self:AddComponent(UIImage, checkmark2_path)
  self.checkmark3 = self:AddComponent(UIImage, checkmark3_path)
  if self.transform:Find(b_p_detail_btn_content_path) ~= nil then
    self.b_p_detail_btn_content = self:AddComponent(BPDetailBtnContent, b_p_detail_btn_content_path)
  end
end

local function ComponentDestroy(self)
  self._actName_txt = nil
  self.buy_btn = nil
  self._buyTitle_txt = nil
  self._time_txt = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.toggle3 = nil
  self.toggleList = nil
  self.scroll_view = nil
  self.scroll_content = nil
  self.mask_go = nil
  self.task_view = nil
  self.task_content = nil
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
  self.image_bg = nil
  self.image_bg3 = nil
  self.progress_bar_bg = nil
  self.checkmark1 = nil
  self.checkmark2 = nil
  self.checkmark3 = nil
end

local function DataDefine(self)
  self.view = nil
  self.specialUnlocked = nil
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
  self.specialUnlocked = nil
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
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if self.viewShowConfig == nil then
    self.viewShowConfig = UIBattlePassNormalNewViewShowConfig.New()
  end
  self.targetShowConfig = self.viewShowConfig:GetViewShowConfig(self.activityData.subViewType)
  self:OnRefresh()
  if self.activityData then
    self:ReloadHeroSpine(self.activityData.activity_hero)
    if self.b_p_detail_btn_content then
      self.b_p_detail_btn_content:ReInit(self.activityData)
    end
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

function UIBattlePassS5:SendBattlePassMessage()
  if self.activityData.type == EnumActivity.BattlePass_new.Type then
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
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.actData and self.actData.lastResetTime == nil then
    self:SendBattlePassMessage()
    return
  else
  end
  self.lastLv = self.actData.battlePass.level
  RefreshTogglesVisible(self)
  self:RefreshTop()
  self:RefreshRed()
  self:ShowCells()
  self:ToggleControlBorS(1)
  self:RefreshExtraBox()
end

local function OnBattlePassInfoRefresh(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.actData and self.actData.lastResetTime == nil then
    self:SendBattlePassMessage()
    return
  else
  end
  self.lastLv = self.actData.battlePass.level
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

local function RefreshTop(self, lastLv)
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actListData then
    self._actName_txt:SetLocalText(actListData.name)
    self:RefreshTime(actListData)
    self:AddTimer(actListData)
  end
  self.packageInfo = GiftPackageData.get(self.actData:GetExchangeId())
  if self.packageInfo and self.actData.battlePass.unlock == 0 then
    self.buy_btn:SetActive(true)
    self.buy_btn:Init(self.packageInfo)
    self.buy_btn:RefreshPoint()
  else
    self.buy_btn:SetActive(false)
  end
  self.highReward = DataCenter.ActBattlePassTemplateManager:GetTemplateHighRewardById(toInt(self.activityId))
  if not string.IsNullOrEmpty(actListData.bannerTittle) then
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
  self:RefreshDiscountContent()
end

local function RefreshDiscountContent(self)
  if self.battle_pass_discount then
    if self.packageInfo then
      self.battle_pass_discount:SetActive(true)
      self.discount_text:SetText(self.packageInfo:getPercent())
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
  local item = self.task_view:AddComponent(UIBattlePassNormalNewTaskCell, go)
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
    local item = loopScroll:NewListViewItem("UIBattlePassNormalNewItem")
    local script = self.scroll_content:GetComponent(item.gameObject.name, UIBattlePassNormalNewRewardItem)
    if script == nil then
      local objectName = tostring(self.itemIndex)
      self.itemIndex = self.itemIndex + 1
      item.gameObject.name = objectName
      script = self.scroll_content:AddComponent(UIBattlePassNormalNewRewardItem, objectName)
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
  local item = self.scroll_view:AddComponent(UIBattlePassNormalNewRewardItem, go)
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
    data.showBallRight = self.actData.battlePass.level >= data.level
    data.curLv = self.actData.battlePass.level
    data.unlock = self.actData.battlePass.unlock
    data.actId = toInt(self.activityId)
    data.type = self.actData.type
    item:SetData(data, self)
    go:SetActive(true)
    self.itemList[index] = item
  end
end

local function OnDestroyRewardScrollItem(self, go, index)
end

local function ToggleControlBorS(self, index)
  if self.curType == index then
    return
  end
  self.curType = index
  local unselectedTextColor = self.targetShowConfig.NotOnListToggleTxtColor
  local selectedTextColor = self.targetShowConfig.OnListToggleTxtColor
  if index == 1 then
    self.task_view:SetActive(false)
    self.mask_go:SetActive(true)
    self._oneGet_btn:SetActive(true)
    self.taskIndex = 0
  elseif index == 2 then
    self.task_view:SetActive(true)
    self.mask_go:SetActive(false)
    self.actData:TaskSortHandle(1, self.actData.type)
    self.taskList = self.actData.taskArr[1]
    self:InitTask(1)
    self._oneGet_btn:SetActive(true)
    self.taskIndex = 1
    self.task_content:SetItemCount(#self.taskList)
  elseif index == 3 then
    self.task_view:SetActive(true)
    self.mask_go:SetActive(false)
    self.actData:TaskSortHandle(2, self.actData.type)
    self.taskList = self.actData.taskArr[2]
    self:InitTask(2)
    self._oneGet_btn:SetActive(true)
    self.taskIndex = 2
    self.task_content:SetItemCount(#self.taskList)
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

local function RefreshBattlePass(self)
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
  self:RefreshTop(self.lastLv)
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

local function OnBuyPackageSucc(self)
end

local function ClearScroll(self)
  self.scroll_view:RemoveComponents(UIBattlePassNormalNewRewardItem)
  self.scroll_content:DestroyChildNodeExceptIndex(self.progressSliderInstanceId)
  self.task_view:RemoveComponents(UIBattlePassNormalNewTaskCell)
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
  if self.actData and self.actData.battlePass.unlock == 0 then
    if self.activityData.subViewType == BattlePassType.Christmas then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUpChristmas, tonumber(self.activityId))
    elseif self.activityData.subViewType == BattlePassType.SpringFestival then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUpSpringFestival, tonumber(self.activityId))
    elseif self.activityData.subViewType == BattlePassType.Ramadan then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassRamadanGiftPackagePopUp, tonumber(self.activityId))
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, tonumber(self.activityId))
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

UIBattlePassS5.OnCreate = OnCreate
UIBattlePassS5.OnDestroy = OnDestroy
UIBattlePassS5.OnEnable = OnEnable
UIBattlePassS5.OnDisable = OnDisable
UIBattlePassS5.ComponentDefine = ComponentDefine
UIBattlePassS5.ComponentDestroy = ComponentDestroy
UIBattlePassS5.DataDefine = DataDefine
UIBattlePassS5.DataDestroy = DataDestroy
UIBattlePassS5.OnAddListener = OnAddListener
UIBattlePassS5.OnRemoveListener = OnRemoveListener
UIBattlePassS5.SetData = SetData
UIBattlePassS5.OnRefresh = OnRefresh
UIBattlePassS5.RefreshTop = RefreshTop
UIBattlePassS5.RefreshRed = RefreshRed
UIBattlePassS5.InitTask = InitTask
UIBattlePassS5.OnInitScroll = OnInitScroll
UIBattlePassS5.OnUpdateScroll = OnUpdateScroll
UIBattlePassS5.OnDestroyScrollItem = OnDestroyScrollItem
UIBattlePassS5.ShowCells = ShowCells
UIBattlePassS5.OnInitRewardScroll = OnInitRewardScroll
UIBattlePassS5.OnUpdateRewardScroll = OnUpdateRewardScroll
UIBattlePassS5.OnDestroyRewardScrollItem = OnDestroyRewardScrollItem
UIBattlePassS5.ToggleControlBorS = ToggleControlBorS
UIBattlePassS5.RefreshBattlePass = RefreshBattlePass
UIBattlePassS5.RefreshRewardCell = RefreshRewardCell
UIBattlePassS5.RefreshTaskCell = RefreshTaskCell
UIBattlePassS5.OnBuyPackageSucc = OnBuyPackageSucc
UIBattlePassS5.RefreshExtraBox = RefreshExtraBox
UIBattlePassS5.RefreshDiscountContent = RefreshDiscountContent
UIBattlePassS5.ClearScroll = ClearScroll
UIBattlePassS5.AddTimer = AddTimer
UIBattlePassS5.RefreshTime = RefreshTime
UIBattlePassS5.DeleteTimer = DeleteTimer
UIBattlePassS5.OneGetClick = OneGetClick
UIBattlePassS5.OnBuyLvUpClick = OnBuyLvUpClick
UIBattlePassS5.OnBuyClick = OnBuyClick
UIBattlePassS5.OnIntroClick = OnIntroClick
UIBattlePassS5.SetBlackPos = SetBlackPos
UIBattlePassS5.OnGetRewardItemByIndex = OnGetRewardItemByIndex
UIBattlePassS5.ReloadHeroSpine = ReloadHeroSpine
UIBattlePassS5.OnBattlePassInfoRefresh = OnBattlePassInfoRefresh
UIBattlePassS5.RefreshCurSelcetContent = RefreshCurSelcetContent
return UIBattlePassS5
