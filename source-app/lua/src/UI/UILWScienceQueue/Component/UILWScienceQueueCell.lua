local UIBuildQueueCell = BaseClass("UIBuildQueueCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  uuid,
  index,
  enterParam
}
local SliderLength = 455
local icon_path = "Icon"
local build_name_text_path = "Layout/NameText"
local des_text_path = "Layout/DesText"
local slider_path = "Layout/TimeSlider_up"
local goto_btn_path = "TimeButton"
local goto_btn_name_path = "TimeButton/btnTxt_green_big_new"
local EMPTY_ICON = "Assets/Main/Sprites/UI/UIBuildBubble/lyp_zhujiemian_qipao_kejishu.png"
local GREEN_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png"
local BLUE_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png"
local YELLOW_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_4.png"
local GIFT_ICON = "Assets/Main/Sprites/UI/UILWScience/od_keyan2xinjianzhu.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.build_name_text = self:AddComponent(UIText, build_name_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn_img = self:AddComponent(UIImage, goto_btn_path)
  self.goto_btn_name = self:AddComponent(UIText, goto_btn_name_path)
  self.goto_btn_name_shadow = self:AddComponent(UIShadow, goto_btn_name_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.giftInfoLayOut = self:AddComponent(UIBaseContainer, "giftInfo")
  self.layOut = self:AddComponent(UIBaseContainer, "Layout")
  self.giftInfoText = self:AddComponent(UIText, "giftInfo/Text")
  self.goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.build_name_text = nil
  self.slider = nil
  self.slider_text = nil
  self.goto_btn = nil
  self.goto_btn_name = nil
  self.des_text = nil
  self.goto_btn_img = nil
  self.goto_btn_name_shadow = nil
end

local function DataDefine(self)
  self.param = {}
  self.endTime = 0
  self.startTime = 0
  self.laseTime = 0
  self.lastCurTime = 0
  self.state = nil
end

local function DataDestroy(self)
  self.param = nil
  self.endTime = nil
  self.startTime = nil
  self.laseTime = nil
  self.lastCurTime = nil
  self.state = nil
end

local function GetCurState(self)
  if self.queueInfo then
    return self.queueInfo:GetQueueState()
  else
    return NewQueueState.Work
  end
end

local function ReInit(self, param)
  self.param = param
  if self.param.isBuy then
    self:ShowBuy()
    return
  else
    self.giftInfoLayOut:SetActive(false)
    self.layOut:SetActive(true)
  end
  if param.uuid then
    self.queueInfo = DataCenter.QueueDataManager:GetQueueByUuid(param.uuid)
    self.state = GetCurState(self)
  else
    return
  end
  self:RefreshState()
  self:RefreshSlider(UITimeManager:GetInstance():GetServerTime())
end

function UIBuildQueueCell:ShowBuy()
  self.icon:LoadSprite(GIFT_ICON)
  self.goto_btn_img:LoadSprite(YELLOW_BTN)
  self.giftInfoLayOut:SetActive(true)
  if self.param.pack then
    self.goto_btn_name:SetText(self.param.pack:getPriceText())
  end
  self.icon:SetNativeSize()
  self.icon.transform.localScale = UIBuildQueueImageTypeScale.Unlock
  self.giftInfoText:SetLocalText(2000751)
  self.layOut:SetActive(false)
end

local function OnBtnClick(self)
  if self.param.isBuy then
    DataCenter.ScienceManager:OpenScienceGiftView()
    self.view.ctrl:CloseSelf()
    return
  end
  if self.state == NewQueueState.Free then
    GoToUtil.GotoScience(nil, nil, self.queueInfo.funcUuid)
  elseif self.state == NewQueueState.Work then
    if self.queueInfo ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Science, self.queueInfo.uuid)
    end
  elseif self.state == NewQueueState.Finish and self.queueInfo then
    local param = {}
    param.uuid = self.queueInfo.uuid
    SFSNetwork.SendMessage(MsgDefines.QueueFinish, param)
  end
end

local function RefreshSlider(self, curTime)
  if self.state == NewQueueState.Work then
    local changeTime = self.endTime - curTime
    local maxTime = self.endTime - self.startTime
    if 0 < changeTime then
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.laseTime then
        self.laseTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        self.des_text:SetText(Localization:GetString(100238) .. " " .. tempTimeValue)
      end
      if 0 < maxTime then
        local tempValue = 1 - changeTime / maxTime
        if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.endTime - self.lastCurTime, maxTime, SliderLength) then
          self.lastCurTime = curTime
          self.slider:SetValue(tempValue)
        end
      end
    else
      local state = GetCurState(self)
      self:ChangeState(state)
    end
  elseif self.state == NewQueueState.Finish then
    self.slider:SetValue(1)
  end
end

local function RefreshState(self)
  if not self.queueInfo then
    return
  end
  if self.state == NewQueueState.Free then
    self.icon:LoadSprite(EMPTY_ICON)
    self.icon:SetNativeSize()
    self.icon.transform.localScale = UIBuildQueueImageTypeScale.Unlock
    self.des_text.gameObject:SetActive(false)
    self.build_name_text:SetLocalText(130077)
    self.slider:SetValue(0)
    self.slider.gameObject:SetActive(false)
    self.goto_btn:SetActive(true)
    self.goto_btn_img:LoadSprite(BLUE_BTN)
    if self.param.enterParam ~= nil then
    else
      self.goto_btn_name:SetLocalText(100094)
    end
    CS.UIGray.SetGray(self.goto_btn.transform, false, true)
    CS.UIGray.SetGray(self.icon.transform, false, true)
  elseif self.state == NewQueueState.Work then
    local scienceId = tonumber(self.queueInfo.itemId)
    local scienceTempalte = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
    if scienceTempalte ~= nil then
      self.des_text.gameObject:SetActive(true)
      self.slider.gameObject:SetActive(true)
      self.endTime = self.queueInfo.endTime
      local cur = UITimeManager:GetInstance():GetServerTime()
      self.startTime = self.queueInfo.startTime
      if cur < self.startTime then
        self.startTime = cur
      end
      self.icon:LoadSprite(string.format(LoadPath.UILWScience, scienceTempalte.icon))
      self.icon:SetNativeSize()
      self.icon.transform.localScale = UIBuildQueueImageTypeScale.Build
      local curLevel = DataCenter.ScienceManager:GetScienceLevel(scienceId)
      self.build_name_text:SetLocalText(135214, tostring(curLevel), Localization:GetString(scienceTempalte.name))
      self.goto_btn:SetActive(true)
      self.goto_btn_img:LoadSprite(BLUE_BTN)
      self.goto_btn_name:SetLocalText(100159)
    end
    CS.UIGray.SetGray(self.goto_btn.transform, false, true)
    CS.UIGray.SetGray(self.icon.transform, false, true)
  elseif self.state == NewQueueState.Finish then
    local scienceId = tonumber(self.queueInfo.itemId)
    local scienceTempalte = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
    if scienceTempalte ~= nil then
      self.des_text.gameObject:SetActive(false)
      self.slider.gameObject:SetActive(true)
      self.endTime = self.queueInfo.endTime
      local cur = UITimeManager:GetInstance():GetServerTime()
      self.startTime = self.queueInfo.startTime
      if cur < self.startTime then
        self.startTime = cur
      end
      self.icon:LoadSprite(string.format(LoadPath.UILWScience, scienceTempalte.icon))
      self.icon:SetNativeSize()
      self.icon.transform.localScale = UIBuildQueueImageTypeScale.Build
      local curLevel = DataCenter.ScienceManager:GetScienceLevel(scienceId)
      self.build_name_text:SetLocalText(200192, Localization:GetString(scienceTempalte.name))
      self.goto_btn:SetActive(true)
      self.goto_btn_img:LoadSprite(GREEN_BTN)
      self.goto_btn_name:SetLocalText(110009)
    end
    CS.UIGray.SetGray(self.goto_btn.transform, false, true)
    CS.UIGray.SetGray(self.icon.transform, false, true)
  end
end

local function ChangeState(self, state)
  if self.state ~= nil then
    self.state = state
    self:RefreshState()
  end
end

local function ChangeEndTime(self, endTime)
  self.endTime = endTime
end

UIBuildQueueCell.OnCreate = OnCreate
UIBuildQueueCell.OnDestroy = OnDestroy
UIBuildQueueCell.Param = Param
UIBuildQueueCell.OnEnable = OnEnable
UIBuildQueueCell.OnDisable = OnDisable
UIBuildQueueCell.ComponentDefine = ComponentDefine
UIBuildQueueCell.ComponentDestroy = ComponentDestroy
UIBuildQueueCell.DataDefine = DataDefine
UIBuildQueueCell.DataDestroy = DataDestroy
UIBuildQueueCell.ReInit = ReInit
UIBuildQueueCell.OnBtnClick = OnBtnClick
UIBuildQueueCell.RefreshSlider = RefreshSlider
UIBuildQueueCell.RefreshState = RefreshState
UIBuildQueueCell.ChangeState = ChangeState
UIBuildQueueCell.ChangeEndTime = ChangeEndTime
return UIBuildQueueCell
