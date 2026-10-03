local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIBattlePassForActSevenDay = BaseClass("UIBattlePassForActSevenDay", base)
local UIBattlePassRewardItem = require("UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassRewardItem")
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
local scroll_view_path = "Root/Mask/ScrollView"
local scroll_content_path = "Root/Mask/ScrollView/Content"
local mask_path = "Root/Mask"
local freeReward_txt_path = "Root/Mask/BoxBg/BoxTop/Txt_FreeReward"
local point_path = "Root/TitleBg/BuyBtn/UIGiftPackagePoint"
local oneGet_btn_path = "Root/Mask/Btn_List/Btn_OneGet"
local oneGet_txt_path = "Root/Mask/Btn_List/Btn_OneGet/Txt_OneGet"
local oneGetRed_rect_path = "Root/Mask/Btn_List/Btn_OneGet/CommonRedPoint"
local add_exp_btn_path = "Root/TitleBg/AddExpButton"
local intro_btn_path = "Root/TitleBg/Intro"
local title_txt_path = "Root/Txt_Title"
local exp_text_path = "Root/TitleBg/ExpArea/ExpText"
local progress_path = "Root/Mask/ScrollView/Content/ProgressBar"
local banner_path = "ImageBg2"
local txt_act_extra_path = "Root/TitleBg/Txt_ActExtra"
local heroSpineContainerPath = "Root/TitleBg/HeroSpineContainer"
local battlePassUnlimitedBox_path = "Root/Mask/BattlePassUnlimitedBox"
local bpScoreIcon_path = "Root/TitleBg/ExpArea/Icon"
local battle_pass_discount_path = "Root/BattlePassDiscount"
local discount_text_path = "Root/BattlePassDiscount/DiscountText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
end

local function ComponentDefine(self)
  self._actName_txt = self:AddComponent(UIText, actName_txt_path)
  self.buy_btn = self:AddComponent(LWBtnBuyRefundRemind, buy_btn_path)
  self.buy_btn:SetBuyClickAction(function()
    self:OnBuyClick()
  end)
  self.add_exp_btn = self:AddComponent(UIButton, add_exp_btn_path)
  self.add_exp_btn:SetOnClick(function()
    self:OnAddExpClick()
  end)
  self._buyTitle_txt = self:AddComponent(UIText, buyTitle_text_path)
  self._buyTitle_txt:SetLocalText(320464)
  self._time_txt = self:AddComponent(UIText, time_txt_path)
  self._title_txt = self:AddComponent(UIText, title_txt_path)
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.scroll_content = self:AddComponent(GridInfinityScrollView, scroll_content_path)
  self.mask_go = self:AddComponent(UIBaseContainer, mask_path)
  self._oneGet_btn = self:AddComponent(UIButton, oneGet_btn_path)
  self._oneGet_btn:SetOnClick(function()
    self:OneGetClick()
  end)
  self._oneGetRed_rect = self:AddComponent(UICommonRedPoint, oneGetRed_rect_path)
  self._oneGetRed_rect:SetType(CommonRedPointPriority.Level1)
  self._oneGet_txt = self:AddComponent(UIText, oneGet_txt_path)
  self._oneGet_txt:SetLocalText(110132)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    self:OnIntroClick()
  end)
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.txt_act_extra = self:AddComponent(UIText, txt_act_extra_path)
  self.expText = self:AddComponent(UIText, exp_text_path)
  self.progressSlider = self:AddComponent(UISlider, progress_path)
  self.progressSliderInstanceId = self.progressSlider.transform:GetInstanceID()
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.battlePassUnlimitedBox = self:AddComponent(BattlePassUnlimitedBox, battlePassUnlimitedBox_path)
  self.bpScoreIcon = self:AddComponent(UIImage, bpScoreIcon_path)
  if not IsNull(self.transform:Find(battle_pass_discount_path)) then
    self.battle_pass_discount = self:AddComponent(UIImage, battle_pass_discount_path)
    self.discount_text = self:AddComponent(UIText, discount_text_path)
  end
end

local function ComponentDestroy(self)
  self._actName_txt = nil
  self.buy_btn = nil
  self._buyTitle_txt = nil
  self._time_txt = nil
  self._title_txt = nil
  self._actIcon_img = nil
  self.scroll_view = nil
  self.scroll_content = nil
  self.mask_go = nil
  self._oneGet_btn = nil
  self._oneGetRed_rect = nil
  self._oneGet_txt = nil
  self.intro_btn = nil
  self.expText = nil
  self.progressSlider = nil
  self.progressSliderInstanceId = nil
  self.heroSpineContainer = nil
  self.battlePassUnlimitedBox = nil
  self.bpScoreIcon = nil
  self.battle_pass_discount = nil
  self.discount_text = nil
end

local function DataDefine(self)
  self.view = nil
  self.specialUnlocked = nil
  self.itemList = {}
  self.curLevel = 0
  self.curIndex = 0
  self.packageInfo = nil
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
  self:AddUIListener(EventId.ActBattlePass, self.OnRefresh)
  self:AddUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
  self:AddUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
  self:AddUIListener(EventId.ActBattlePassTask, self.OnTaskUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBattlePass, self.OnRefresh)
  self:RemoveUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
  self:RemoveUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
  self:RemoveUIListener(EventId.ActBattlePassTask, self.OnTaskUpdate)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  self.curType = 0
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if self.activityData then
    self:ReloadHeroSpine(self.activityData.activity_hero)
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self:OnRefresh()
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
  local step = 1 / (count - 2)
  local exp = self.curAccuExp
  if 0 < count then
    local needExp = DataCenter.ActBattlePassTemplateManager:GetLevelNeedExp(self.actData.activityId, 0)
    if exp >= needExp then
      exp = exp - needExp
    else
      exp = 0
    end
    if 0 < exp then
      for i = 1, count do
        needExp = DataCenter.ActBattlePassTemplateManager:GetLevelNeedExp(self.actData.activityId, self.actData.stateInfo[i].level)
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

local function OnRefresh(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.actData and self.actData.lastResetTime == nil then
    SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo, toInt(self.activityId))
    return
  elseif not UITimeManager:GetInstance():IsSameDayForServer(self.actData.lastResetTime, curTime) then
    SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo, toInt(self.activityId))
    return
  end
  self.lastLv = self.actData.battlePass.level
  self:RefreshTop()
  self:RefreshRed()
  self:ShowCells()
  self:RefreshExtraBox()
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
    local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
    self.buy_btn:Init(self.packageInfo)
    self.buy_btn:RefreshPoint()
  else
    self.buy_btn:SetActive(false)
  end
  local template = DataCenter.ActBattlePassTemplateManager:GetTemplateById(toInt(self.activityId), self.actData.battlePass.level)
  self.highReward = DataCenter.ActBattlePassTemplateManager:GetTemplateHighRewardById(toInt(self.activityId))
  if not string.IsNullOrEmpty(actListData.activity_pic) then
    self.banner:LoadSpriteAsync(string.format(LoadPath.ActivityBattlePassBannerPath, actListData.activity_pic))
  end
  if not string.IsNullOrEmpty(actListData.bannerTittle) then
    self.txt_act_extra:SetLocalText(actListData.bannerTittle)
  else
    self.txt_act_extra:SetText("")
  end
  if not string.IsNullOrEmpty(self.activityData.para_5) then
    local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(self.activityData.para_5))
    self.bpScoreIcon:LoadSprite(iconPath)
  else
    self.bpScoreIcon:LoadSprite(string.format(LoadPath.ItemPath, "zyf_battlepass_icon2"))
  end
  self.curAccuExp = self.actData:GetCurrentAccumulatedExp()
  self.expText:SetText(self.curAccuExp)
  RefreshProgressBar(self)
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

local function RefreshRed(self)
  local num = self.actData:GetRedNum(1)
  self._oneGetRed_rect:SetNum(num)
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
    data.showBallRight = self.actData.battlePass.level >= data.level
    data.curLv = self.actData.battlePass.level
    data.unlock = self.actData.battlePass.unlock
    data.actId = toInt(self.activityId)
    script:SetData(data, self, self.activityData.para_5)
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
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mask_go.transform)
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
  self.progressSlider.rectTransform:Set_sizeDelta(37, (count - 1) * 153.28)
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
    data.showBallRight = self.actData.battlePass.level >= data.level
    data.curLv = self.actData.battlePass.level
    data.unlock = self.actData.battlePass.unlock
    data.actId = toInt(self.activityId)
    item:SetData(data, self, self.activityData.para_5)
    go:SetActive(true)
    self.itemList[index] = item
  end
end

local function OnDestroyRewardScrollItem(self, go, index)
end

local function RefreshBattlePass(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self:RefreshTop()
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
  self:RefreshExtraBox()
end

local function RefreshRewardCell(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
end

local function OnTaskUpdate(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self:RefreshTop(self.lastLv)
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
  self:RefreshExtraBox()
end

local function ClearScroll(self)
  self.scroll_view:RemoveComponents(UIBattlePassRewardItem)
  self.scroll_content:DestroyChildNodeExceptIndex(self.progressSliderInstanceId)
end

local function OnBuyLvUpClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassBuy, toInt(self.activityId))
end

local function OneGetClick(self)
  local num = self.actData:GetRedNum(1)
  if 0 < num then
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassAllReward, toInt(self.activityId))
  else
    UIUtil.ShowTipsId(320446)
  end
end

local function OnBuyClick(self)
  if self.actData and self.actData.battlePass.unlock == 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, tonumber(self.activityId))
  end
end

local function OnAddExpClick(self)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityData and activityData:GetFirstActiveJumpTo() > 0 then
    local jumpTo = activityData:GetFirstActiveJumpTo()
    local targetActivityData = DataCenter.ActivityListDataManager:GetActivityDataById(jumpTo)
    if targetActivityData then
      GoToUtil.GoActWindow({jumpTo}, false)
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

UIBattlePassForActSevenDay.OnCreate = OnCreate
UIBattlePassForActSevenDay.OnDestroy = OnDestroy
UIBattlePassForActSevenDay.OnEnable = OnEnable
UIBattlePassForActSevenDay.OnDisable = OnDisable
UIBattlePassForActSevenDay.ComponentDefine = ComponentDefine
UIBattlePassForActSevenDay.ComponentDestroy = ComponentDestroy
UIBattlePassForActSevenDay.DataDefine = DataDefine
UIBattlePassForActSevenDay.DataDestroy = DataDestroy
UIBattlePassForActSevenDay.OnAddListener = OnAddListener
UIBattlePassForActSevenDay.OnRemoveListener = OnRemoveListener
UIBattlePassForActSevenDay.SetData = SetData
UIBattlePassForActSevenDay.OnRefresh = OnRefresh
UIBattlePassForActSevenDay.RefreshTop = RefreshTop
UIBattlePassForActSevenDay.RefreshRed = RefreshRed
UIBattlePassForActSevenDay.RefreshDiscountContent = RefreshDiscountContent
UIBattlePassForActSevenDay.OnDestroyScrollItem = OnDestroyScrollItem
UIBattlePassForActSevenDay.ShowCells = ShowCells
UIBattlePassForActSevenDay.OnInitRewardScroll = OnInitRewardScroll
UIBattlePassForActSevenDay.OnUpdateRewardScroll = OnUpdateRewardScroll
UIBattlePassForActSevenDay.OnDestroyRewardScrollItem = OnDestroyRewardScrollItem
UIBattlePassForActSevenDay.RefreshBattlePass = RefreshBattlePass
UIBattlePassForActSevenDay.RefreshRewardCell = RefreshRewardCell
UIBattlePassForActSevenDay.RefreshExtraBox = RefreshExtraBox
UIBattlePassForActSevenDay.ClearScroll = ClearScroll
UIBattlePassForActSevenDay.AddTimer = AddTimer
UIBattlePassForActSevenDay.RefreshTime = RefreshTime
UIBattlePassForActSevenDay.DeleteTimer = DeleteTimer
UIBattlePassForActSevenDay.OneGetClick = OneGetClick
UIBattlePassForActSevenDay.OnBuyLvUpClick = OnBuyLvUpClick
UIBattlePassForActSevenDay.OnBuyClick = OnBuyClick
UIBattlePassForActSevenDay.OnAddExpClick = OnAddExpClick
UIBattlePassForActSevenDay.OnIntroClick = OnIntroClick
UIBattlePassForActSevenDay.SetBlackPos = SetBlackPos
UIBattlePassForActSevenDay.OnGetRewardItemByIndex = OnGetRewardItemByIndex
UIBattlePassForActSevenDay.ReloadHeroSpine = ReloadHeroSpine
UIBattlePassForActSevenDay.OnTaskUpdate = OnTaskUpdate
return UIBattlePassForActSevenDay
