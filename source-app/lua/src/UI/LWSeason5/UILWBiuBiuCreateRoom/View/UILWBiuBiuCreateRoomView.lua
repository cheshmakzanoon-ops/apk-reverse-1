local base = UIBaseView
local UILWBiuBiuCreateRoomView = BaseClass("UILWBiuBiuCreateRoomView", base)
local Localization = CS.GameEntry.Localization
local btn_close_path = "Top/btn_close"
local input_field_path = "Center/InputField"
local holder_path = "Center/InputField/viewport/holder"
local txt_input_path = "Center/txt_input"
local intro_btn_path = "Center/money/IntroBtn"
local txt_money_count_path = "Center/InfoInput/TextBg/txt_money_count"
local toggle_path = "Center/money/toggle_bet"
local btn_challenge_path = "Buttom/btn_challenge"
local btn_bg_path = "btn_bg"
local img_icon_path = "Center/InfoInput/TextBg/img_icon"
local slider_path = "Center/InfoInput/Slider"
local dec_btn_path = "Center/InfoInput/DecBtn"
local add_btn_path = "Center/InfoInput/AddBtn"
local img_bg1_path = "Center/img_bg1"
local package_path = "Buttom/package"
local info_input_path = "Center/InfoInput"
local item_bet_path = "Center/money/item_bet"
local img_item_icon_path = "Center/money/item_bet/img_item_icon"
local txt_item_count_path = "Center/money/item_bet/txt_item_count"
local CreateRoomType = {Item = 1, Normal = 2}

function UILWBiuBiuCreateRoomView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.inputValue = nil
  self.showTip = nil
  self.type, self.fbiData = self:GetUserData()
  self:InitUI()
end

function UILWBiuBiuCreateRoomView:OnEnable()
  base.OnEnable(self)
  DataCenter.LWSoundManager:PlaySound(5100020, false)
end

function UILWBiuBiuCreateRoomView:OnDestroy()
  self.inputValue = nil
  self.showTip = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuCreateRoomView:ComponentDefine()
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.input_field = self:AddComponent(UIInput, input_field_path)
  self.holder = self:AddComponent(UITextMeshProUGUIEx, holder_path)
  self.txt_input = self:AddComponent(UITextMeshProUGUIEx, txt_input_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.txt_money_count = self:AddComponent(UITextMeshProUGUIEx, txt_money_count_path)
  self.toggle_bet = self:AddComponent(UIToggle, toggle_path)
  self.btn_challenge = self:AddComponent(UIButton, btn_challenge_path)
  self.btn_bg = self:AddComponent(UIButton, btn_bg_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.img_bg1 = self:AddComponent(UIImage, img_bg1_path)
  self.package = self:AddComponent(UIBaseContainer, package_path)
  self.info_input = self:AddComponent(UIBaseContainer, info_input_path)
  self.item_bet = self:AddComponent(UIBaseContainer, item_bet_path)
  self.img_item_icon = self:AddComponent(UIImage, img_item_icon_path)
  self.txt_item_count = self:AddComponent(UITextMeshProUGUIEx, txt_item_count_path)
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.input_field:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.input_field:SetOnPressEnter(function(value)
    if string.match(self.inputValue, "^%s*$") then
      self.inputValue = ""
    end
    if string.IsNullOrEmpty(self.inputValue) then
      self.inputValue = Localization:GetString("season_s5_activity_1200045_desc49")
      self.input_field:SetText(self.inputValue)
    end
  end)
  self.btn_close:SetOnClick(BindCallback(self, self.OnBackClick))
  self.btn_bg:SetOnClick(BindCallback(self, self.OnBackClick))
  self.intro_btn:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.toggle_bet:SetOnValueChanged(BindCallback(self, self.OnToggleClick))
  self.btn_challenge:SetOnClick(BindCallback(self, self.OnChallengeClick))
  self.slider:SetOnValueChanged(BindCallback(self, self.OnSliderChanged))
  self.dec_btn:SetOnClick(BindCallback(self, self.OnDecClick))
  self.add_btn:SetOnClick(BindCallback(self, self.OnAddClick))
end

function UILWBiuBiuCreateRoomView:ComponentDestroy()
  self.btn_close = nil
  self.input_field = nil
  self.holder = nil
  self.txt_input = nil
  self.intro_btn = nil
  self.txt_money_count = nil
  self.toggle_bet = nil
  self.btn_challenge = nil
  self.btn_bg = nil
  self.img_icon = nil
  self.slider = nil
  self.dec_btn = nil
  self.add_btn = nil
  self.img_bg1 = nil
  self.package = nil
  self.info_input = nil
  self.anim = nil
  self.item_bet = nil
  self.img_item_icon = nil
  self.txt_item_count = nil
end

function UILWBiuBiuCreateRoomView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBiuBiuPvpCreateRoomEnd, self.SeasonBiuBiuPvpCreateRoomEndHandle)
  self:AddUIListener(EventId.SeasonBiuBiuPvpCreateRoomError, self.SeasonBiuBiuPvpCreateRoomErrorHandle)
end

function UILWBiuBiuCreateRoomView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBiuBiuPvpCreateRoomEnd, self.SeasonBiuBiuPvpCreateRoomEndHandle)
  self:RemoveUIListener(EventId.SeasonBiuBiuPvpCreateRoomError, self.SeasonBiuBiuPvpCreateRoomErrorHandle)
  base.OnRemoveListener(self)
end

function UILWBiuBiuCreateRoomView:SeasonBiuBiuPvpCreateRoomEndHandle()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuRoom, {anim = true})
  self.ctrl.req = nil
  self:OnBackClick()
end

function UILWBiuBiuCreateRoomView:SeasonBiuBiuPvpCreateRoomErrorHandle()
  self.ctrl.req = nil
end

function UILWBiuBiuCreateRoomView:IptOnValueChange(value)
  if #value > DataCenter.LWBiuBiuDataManager:GetPvpNotifyStrLength() then
    self.input_field:SetText(self.inputValue)
    return
  end
  self.inputValue = value
  self:CheckNameChangeState()
end

function UILWBiuBiuCreateRoomView:OnBackClick()
  if self.ctrl.req then
    return
  end
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
  end
  local ok, time = self.anim:PlayAnimationReturnTime("out")
  if ok then
    self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.ctrl:CloseSelf()
    end, time)
  else
    self.ctrl:CloseSelf()
  end
end

function UILWBiuBiuCreateRoomView:OnInfoClick()
  local param = {}
  param.type = "desc"
  param.desc = "season_s5_shoot_game_pvp_rule_01"
  param.alignObject = self.intro_btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UILWBiuBiuCreateRoomView:OnChallengeClick()
  if string.match(self.inputValue, "^%s*$") then
    self.inputValue = ""
  end
  if string.IsNullOrEmpty(self.inputValue) then
    self.inputValue = Localization:GetString("season_s5_activity_1200045_desc49")
    self.input_field:SetText(self.inputValue)
  end
  if string.IsNullOrEmpty(self.inputValue) then
    self.inputValue = Localization:GetString("season_s5_activity_1200045_desc49")
  end
  local checkState = self.ctrl:CheckName(self.inputValue)
  if checkState == CheckNameType.MaxNameChar then
    UIUtil.ShowTipsId(120193)
    return
  end
  if self.type == CreateRoomType.Item then
    self.ctrl.req = true
    DataCenter.LWBiuBiuManager:GameLiftPing(function(msg)
      if msg == "Error" then
        self.ctrl.req = nil
        return
      end
      self.fbiData.version = DataCenter.LWBiuBiuDataManager:GetVersion()
      self.fbiData.speak = self.inputValue
      SFSNetwork.SendMessage(MsgDefines.ItemUse, self.fbiData)
    end)
    return
  else
    local hasBet = self.toggle_bet:GetIsOn()
    local cost = hasBet and toInt(self.slider:GetValue()) or 0
    if 0 < cost then
      local room = DataCenter.LWBiuBiuDataManager:GetRoom()
      if room:GetBetCount() >= room:GetBetMaxCount() then
        UIUtil.ShowTipsId("season_s5_activity_1200045_desc70")
        return
      end
    end
    self.ctrl.req = true
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:ReqCreate({
      speak = self.inputValue,
      cost = cost
    }, function()
      self.ctrl.req = nil
    end)
  end
end

function UILWBiuBiuCreateRoomView:OnToggleClick(isOn)
  local isItem = self.type == CreateRoomType.Item
  if isItem then
    self.toggle_bet:SetIsOnWithoutNotify(not isOn)
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc84")
    return
  end
  local openTime = GetTableData(TableName.DataConfig, "season_shoot_game_pvp", "k3")
  if isOn then
    local canBetTime = false
    local timeNeed = 0
    if not string.IsNullOrEmpty(openTime) then
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      local curDate = UITimeManager:GetInstance():TimeStampToServerDate(serverTime)
      local curSec = curDate.hour * 3600 + curDate.min * 60 + curDate.sec
      local openTimeStr = string.split(openTime, "|")
      local minDiff = 999999
      local earliestStartSec = 999999
      for i = 1, #openTimeStr do
        local start_time, end_time = openTimeStr[i]:match("([^;]+);([^;]+)")
        if start_time and end_time then
          local sH, sM, sS = string.match(start_time, "(%d+):(%d+):(%d+)")
          local eH, eM, eS = string.match(end_time, "(%d+):(%d+):(%d+)")
          sH, sM, sS, eH, eM, eS = tonumber(sH), tonumber(sM), tonumber(sS), tonumber(eH), tonumber(eM), tonumber(eS)
          if sH and sM and sS and eH and eM and eS then
            local startSec = sH * 3600 + sM * 60 + sS
            local endSec = eH * 3600 + eM * 60 + eS
            local curCheck = curSec
            if earliestStartSec > startSec then
              earliestStartSec = startSec
            end
            if startSec <= curCheck and endSec >= curCheck then
              canBetTime = true
              timeNeed = 0
              break
            elseif startSec > curCheck then
              local diff = startSec - curCheck
              if minDiff > diff then
                minDiff = diff
              end
            end
          end
        end
      end
      if not canBetTime then
        if minDiff < 999999 then
          timeNeed = minDiff
        else
          timeNeed = 86400 - curSec + earliestStartSec
        end
        local tipStr = UITimeManager:GetInstance():SecondToFmtString(timeNeed)
        UIUtil.ShowTips(Localization:GetString("season_s5_shoot_game_pvp_error_tips01", tipStr))
        self.toggle_bet:SetIsOnWithoutNotify(not isOn)
        return
      end
    end
  end
  local betData = DataCenter.LWBiuBiuDataManager:GetBetData()
  local hasCount = DataCenter.ItemData:GetItemCount(betData.id)
  if hasCount <= 0 then
    UIUtil.ShowTipsId(120021)
    self.toggle_bet:SetIsOnWithoutNotify(not isOn)
    return
  end
  self.img_bg1:SetActive(not isOn)
  self.info_input:SetActive(isOn)
  if isOn then
    self.package:SetAnchoredPositionXY(0, -183)
  else
    self.package:SetAnchoredPositionXY(0, -98)
  end
end

function UILWBiuBiuCreateRoomView:OnSliderChanged(value)
  local betData = DataCenter.LWBiuBiuDataManager:GetBetData()
  local hasCount = DataCenter.ItemData:GetItemCount(betData.id)
  if hasCount < toInt(value) then
    self.slider:SetValueWithoutNotify(hasCount)
    self.txt_money_count:SetText(toInt(hasCount))
    if self.showTip then
      UIUtil.ShowTipsId(120021)
      self.showTip = false
    end
    return
  end
  self.showTip = true
  self.txt_money_count:SetText(toInt(value))
end

function UILWBiuBiuCreateRoomView:OnDecClick()
  local curValue = toInt(self.slider:GetValue())
  local newValue = math.max(curValue - 1, 0)
  if newValue ~= curValue then
    self.slider:SetValue(newValue)
  end
end

function UILWBiuBiuCreateRoomView:OnAddClick()
  local curValue = toInt(self.slider:GetValue())
  local newValue = math.min(curValue + 1, toInt(self.slider.unity_uislider.maxValue))
  if newValue ~= curValue then
    self.slider:SetValue(newValue)
  end
end

function UILWBiuBiuCreateRoomView:CheckNameChangeState()
  local maxLength = DataCenter.LWBiuBiuDataManager:GetPvpNotifyStrLength()
  if self.inputValue == "" then
    self.txt_input:SetText(string.format("0/%d", maxLength))
  else
    local len = #self.inputValue
    self.txt_input:SetText(string.format("%d/%d", len, maxLength))
  end
end

function UILWBiuBiuCreateRoomView:InitUI()
  self:IptOnValueChange(Localization:GetString("season_s5_activity_1200045_desc49"))
  self.input_field:SetText(self.inputValue)
  local betData = DataCenter.LWBiuBiuDataManager:GetBetData()
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  self.slider.unity_uislider.minValue = 0
  self.slider.unity_uislider.maxValue = betData.count + room:GetBetExtraNum()
  self.slider:SetValueWithoutNotify(0)
  self.txt_money_count:SetText(0)
  self.img_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(betData.id))
  self.package:SetAnchoredPositionXY(0, -98)
  self.toggle_bet:SetIsOnWithoutNotify(false)
  self.img_bg1:SetActive(true)
  self.info_input:SetActive(false)
  local isItem = self.type == CreateRoomType.Item
  self.item_bet:SetActive(isItem)
  if isItem then
    self.toggle_bet:SetIsOnWithoutNotify(true)
    self.img_item_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(self.fbiData.betid))
  end
end

return UILWBiuBiuCreateRoomView
