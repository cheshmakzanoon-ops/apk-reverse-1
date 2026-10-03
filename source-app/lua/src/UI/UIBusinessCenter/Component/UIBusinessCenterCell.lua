local UIResidentOrderCell = BaseClass("UIResidentOrderCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  uuid,
  callBack,
  index,
  orderId,
  isDoEnterAnim
}
local this_path = ""
local business_money_img_path = "Business_bg/Business_money_img"
local submit_tag_path = "Business_bg/Common_duihao"
local money_text_path = "Business_bg/MoneyText"
local exp_text_path = "Business_bg/Name_bg/ExpGo/ExpText"
local exp_go_path = "Business_bg/Name_bg"
local bg_anim_path = "Business_bg"
local gray_img_path = "Business_bg/gray"
local gray_lockIcon_path = "Business_bg/gray/lock"
local gray_deleteIcon_path = "Business_bg/gray/delete"
local gray_lockIcon_txt_path = "Business_bg/gray/lockText"
local gray_deleteIcon_time_path = "Business_bg/gray/delete/Text_time"
local bg_anim_copy_path = "Business_bgCopy"
local business_money_img_copy_path = "Business_bgCopy/Business_money_imgCopy"
local submit_tag_copy_path = "Business_bgCopy/Common_duihaoCopy"
local money_text_copy_path = "Business_bgCopy/MoneyTextCopy"
local exp_text_copy_path = "Business_bgCopy/Name_bgCopy/ExpGoCopy/ExpTextCopy"
local exp_go_copy_path = "Business_bgCopy/Name_bgCopy"
local select_copy_path = "Business_bgCopy/Hightlight"
local gray_img_copy_path = "Business_bgCopy/grayCopy"
local gray_lockIcon_copy_path = "Business_bgCopy/grayCopy/lockCopy"
local gray_deleteIcon_copy_path = "Business_bgCopy/grayCopy/deleteCopy"
local gray_lockIcon_txt_copy_path = "Business_bgCopy/grayCopy/lockTextCopy"
local gray_deleteIcon_time_copy_path = "Business_bgCopy/grayCopy/deleteCopy/Text_timeCopy"
local lockIcon_dot_01_path = "Business_bg/gray/lock/lockIcon_dot_01"
local lockIcon_dot_02_path = "Business_bg/gray/lock/lockIcon_dot_02"
local lockIcon_dot_03_path = "Business_bg/gray/lock/lockIcon_dot_03"
local lockIcon_01_path = "Business_bg/gray/lock/lockIcon_01"
local lockIcon_02_path = "Business_bg/gray/lock/lockIcon_02"
local lockIcon_01_glow_path = "Business_bg/gray/lock/lockIcon_01_glow"
local lockIcon_02_glow_path = "Business_bg/gray/lock/lockIcon_02_glow"
local money_icon_withExpPos = Vector3.New(0, -24, 0)
local money_icon_withOutExpPos = Vector3.New(0, -46.5, 0)
local money_text_withExpPos = Vector3.New(0, -152, 0)
local money_text_withOutExpPos = Vector3.New(0, -174.5, 0)
local PanelAni = {
  Show = "Business_show",
  Close = "Business_close",
  Dianji = "Business_dianji",
  Business_new = "Business_new",
  Business_idle = "Business_idle",
  Business_end = "Business_end",
  Business_delete = "Business_delete",
  Business_lock = "lock_jiesuo",
  Business_shuaxin = "Business_shuaxin",
  Business_show_rotation = "Business_show_rotation"
}

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
  self.submit_tag = self:AddComponent(UIBaseContainer, submit_tag_path)
  self.business_money_img = self:AddComponent(UIImage, business_money_img_path)
  self.money_text = self:AddComponent(UITweenNumberText, money_text_path)
  self.exp_text = self:AddComponent(UIText, exp_text_path)
  self.money_text:SetPrefix("+")
  self.exp_go = self:AddComponent(UIBaseContainer, exp_go_path)
  self.bg_anim = self:AddComponent(UIImage, bg_anim_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.gray_img = self:AddComponent(UIImage, gray_img_path)
  self.gray_lockIcon = self:AddComponent(UIBaseContainer, gray_lockIcon_path)
  self.gray_deleteIcon = self:AddComponent(UIBaseContainer, gray_deleteIcon_path)
  self.gray_lockIcon_txt = self:AddComponent(UIText, gray_lockIcon_txt_path)
  self.gray_deleteIcon_time = self:AddComponent(UIText, gray_deleteIcon_time_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.bg_anim_copy = self:AddComponent(UIImage, bg_anim_copy_path)
  self.submit_tag_copy = self:AddComponent(UIBaseContainer, submit_tag_copy_path)
  self.business_money_img_copy = self:AddComponent(UIImage, business_money_img_copy_path)
  self.money_text_copy = self:AddComponent(UIText, money_text_copy_path)
  self.exp_text_copy = self:AddComponent(UIText, exp_text_copy_path)
  self.exp_go_copy = self:AddComponent(UIBaseContainer, exp_go_copy_path)
  self.gray_img_copy = self:AddComponent(UIImage, gray_img_copy_path)
  self.gray_lockIcon_copy = self:AddComponent(UIBaseContainer, gray_lockIcon_copy_path)
  self.gray_deleteIcon_copy = self:AddComponent(UIBaseContainer, gray_deleteIcon_copy_path)
  self.gray_lockIcon_txt_copy = self:AddComponent(UIText, gray_lockIcon_txt_copy_path)
  self.gray_deleteIcon_time_copy = self:AddComponent(UIText, gray_deleteIcon_time_copy_path)
  self.select_copy = self:AddComponent(UIImage, select_copy_path)
  self.lockIcon_dot_01 = self:AddComponent(UIImage, lockIcon_dot_01_path)
  self.lockIcon_dot_02 = self:AddComponent(UIImage, lockIcon_dot_02_path)
  self.lockIcon_dot_03 = self:AddComponent(UIImage, lockIcon_dot_03_path)
  self.lockIcon_01 = self:AddComponent(UIImage, lockIcon_01_path)
  self.lockIcon_02 = self:AddComponent(UIImage, lockIcon_02_path)
  self.lockIcon_01_glow = self:AddComponent(UIImage, lockIcon_01_glow_path)
  self.lockIcon_02_glow = self:AddComponent(UIImage, lockIcon_02_glow_path)
end

local function ComponentDestroy(self)
  self.submit_tag = nil
  self.business_money_img = nil
  self.money_text = nil
  self.exp_text = nil
  self.exp_go = nil
  self.btn = nil
  self.bg_anim = nil
  self.gray_img = nil
  self.gray_icon = nil
  self.submit_tag_copy = nil
  self.business_money_img_copy = nil
  self.money_text_copy = nil
  self.exp_text_copy = nil
  self.exp_go_copy = nil
  self.btn_copy = nil
  self.bg_anim_copy = nil
  self.gray_img_copy = nil
  self.gray_icon_copy = nil
end

local function DataDefine(self)
  self.param = {}
  self.showTimer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.param = nil
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  self.timer_action = nil
  self:DeleteTimer()
end

local function ReInit(self, param)
  self.param = param
  local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.param.uuid)
  self.business_money_img.transform:Set_localScale(1, 1, 1)
  if param ~= nil and info ~= nil then
    local template = DataCenter.OrderTemplateManager:GetOrderTemplate(param.orderId)
    if template ~= nil then
      local icon = string.format(LoadPath.UIResidentOrder, template.icon)
      self.business_money_img:LoadSprite(icon)
      local exp = DataCenter.ResidentOrderDataManager:GetExp(template.exp, info.random ~= nil, info.random)
      self.exp_text:SetText("+" .. exp)
      self.business_money_img:SetNativeSize()
      local money = DataCenter.ResidentOrderDataManager:GetMoney(template:GetResidentOrderMoney(), info.random ~= nil, info.random)
      local oldMoney = DataCenter.ResidentOrderDataManager:GetOldMoney(self.param.uuid)
      money = DataCenter.HeroStationManager:CalcEffectedValue(money, HeroStationEffectType.GlobalMoney)
      money = Mathf.Round(money)
      if oldMoney == nil or oldMoney == money then
        self.money_text:SetNum(money)
      else
        self.money_text:FromNumTweenToNum(oldMoney, money, 2)
      end
      DataCenter.ResidentOrderDataManager:SetOldMoney(self.param.uuid, money)
      if toInt(exp) <= 0 then
        self.exp_go:SetActive(false)
        self.business_money_img.transform:Set_localPosition(money_icon_withOutExpPos.x, money_icon_withOutExpPos.y, money_icon_withOutExpPos.z)
        self.money_text.transform:Set_localPosition(money_text_withOutExpPos.x, money_text_withOutExpPos.y, money_text_withOutExpPos.z)
      else
        self.business_money_img.transform:Set_localPosition(money_icon_withExpPos.x, money_icon_withExpPos.y, money_icon_withExpPos.z)
        self.money_text.transform:Set_localPosition(money_text_withExpPos.x, money_text_withExpPos.y, money_text_withExpPos.z)
        self.exp_go:SetActive(true)
      end
    end
    if param.isDoEnterAnim then
      self.bg_anim_copy.gameObject:SetActive(false)
      self:PlayEnterAnim()
    else
      if self.param.index == self.param.changeIndex then
        self:PlayRefreshAnim()
      end
      self:RefreshState()
    end
    self.gray_lockIcon_txt:SetLocalText(130420)
  end
end

local function RefreshState(self, isShuaxin)
  if self.param == nil then
    return
  end
  if self.param.orderId > 0 then
    local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(self.param.uuid)
    if state == ResidentOrderState.Yes then
      self.submit_tag:SetActive(true)
    else
      self.submit_tag:SetActive(false)
    end
  else
    self.submit_tag:SetActive(false)
  end
  if isShuaxin ~= nil then
    self.business_money_img:SetActive(false)
    self.gray_img.gameObject:SetActive(true)
    self.gray_lockIcon.gameObject:SetActive(false)
    self.gray_deleteIcon.gameObject:SetActive(true)
    self.gray_lockIcon_txt.gameObject:SetActive(false)
    self.gray_deleteIcon_time:SetText("")
    return
  end
  local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.param.uuid)
  self.business_money_img:SetActive(info.state == PurchaseOrderState.NORMAL)
  if info.state == PurchaseOrderState.NORMAL then
    self.gray_img.gameObject:SetActive(false)
  elseif info.state == PurchaseOrderState.LOCKED then
    self.gray_img.gameObject:SetActive(true)
    self.gray_lockIcon.gameObject:SetActive(true)
    self.gray_deleteIcon.gameObject:SetActive(false)
    self.gray_lockIcon_txt.gameObject:SetActive(false)
  elseif info.state == PurchaseOrderState.DELETE then
    self.gray_img.gameObject:SetActive(true)
    self.gray_lockIcon.gameObject:SetActive(false)
    self.gray_deleteIcon.gameObject:SetActive(true)
    self.gray_lockIcon_txt.gameObject:SetActive(false)
    self.endTime = info.expTime
    self:RefreshTime()
    self:AddTimer()
  elseif info.state == PurchaseOrderState.FINISH then
    self.gray_img.gameObject:SetActive(true)
    self.gray_lockIcon.gameObject:SetActive(false)
    self.gray_deleteIcon.gameObject:SetActive(true)
    self.gray_lockIcon_txt.gameObject:SetActive(false)
    self.endTime = info.refreshTime
    self:RefreshTime()
    self:AddTimer()
  end
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    DOTween.Rewind(self.bg_anim.gameObject)
    DOTween.Restart(self.bg_anim.gameObject, PanelAni.Business_idle)
    DOTween.Restart(self.bg_anim.gameObject, PanelAni.Dianji)
    self.param.callBack(self.param.index)
  end
end

local function PlaySubmitAnim(self, orderId, isDelete, selectIndex)
  if self.bg_anim ~= nil then
    DOTween.Rewind(self.bg_anim.gameObject)
    DOTween.Rewind(self.bg_anim_copy.gameObject)
    if isDelete then
      DOTween.Restart(self.bg_anim.gameObject, PanelAni.Business_idle)
      DOTween.Restart(self.bg_anim.gameObject, PanelAni.Business_delete)
    else
      DOTween.Restart(self.bg_anim.gameObject, PanelAni.Business_idle)
      DOTween.Restart(self.bg_anim.gameObject, PanelAni.Business_end)
    end
    local param = {}
    param.orderId = orderId
    param.selectIndex = selectIndex
    self:RefreshCopy(param)
    return 1
  end
  return 0.1
end

local function RefreshCopy(self, param)
  if param ~= nil then
    self.bg_anim_copy.gameObject:SetActive(true)
    local template = DataCenter.OrderTemplateManager:GetOrderTemplate(param.orderId)
    local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.param.uuid)
    local money = DataCenter.ResidentOrderDataManager:GetMoney(template:GetResidentOrderMoney(), info.random ~= nil, info.random)
    money = DataCenter.HeroStationManager:CalcEffectedValue(money, HeroStationEffectType.GlobalMoney)
    money = Mathf.Round(money)
    self.business_money_img_copy.transform:Set_localScale(1, 1, 1)
    if template ~= nil and info ~= nil then
      local icon = string.format(LoadPath.UIResidentOrder, template.icon)
      self.business_money_img_copy:LoadSprite(icon)
      self.business_money_img_copy:SetNativeSize()
      local exp = DataCenter.ResidentOrderDataManager:GetExp(template.exp, info.random ~= nil, info.random)
      self.exp_text_copy:SetText("+" .. exp)
      local money = DataCenter.ResidentOrderDataManager:GetMoney(template:GetResidentOrderMoney(), info.random ~= nil, info.random)
      money = DataCenter.HeroStationManager:CalcEffectedValue(money, HeroStationEffectType.GlobalMoney)
      money = Mathf.Round(money)
      self.money_text_copy:SetText("+" .. money)
      if toInt(exp) <= 0 then
        self.exp_go_copy:SetActive(false)
        self.business_money_img_copy.transform:Set_localPosition(money_icon_withOutExpPos.x, money_icon_withOutExpPos.y, money_icon_withOutExpPos.z)
        self.money_text_copy.transform:Set_localPosition(money_text_withOutExpPos.x, money_text_withOutExpPos.y, money_text_withOutExpPos.z)
      else
        self.business_money_img_copy.transform:Set_localPosition(money_icon_withExpPos.x, money_icon_withExpPos.y, money_icon_withExpPos.z)
        self.money_text_copy.transform:Set_localPosition(money_text_withExpPos.x, money_text_withExpPos.y, money_text_withExpPos.z)
        self.exp_go_copy:SetActive(true)
      end
    end
    self.gray_lockIcon_txt_copy:SetLocalText(130420)
    if param.orderId > 0 then
      local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(self.param.uuid)
      if state == ResidentOrderState.Yes then
        self.submit_tag_copy:SetActive(true)
      else
        self.submit_tag_copy:SetActive(false)
      end
    end
    local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.param.uuid)
    if info.state == PurchaseOrderState.NORMAL then
      self.gray_img_copy.gameObject:SetActive(false)
    elseif info.state == PurchaseOrderState.LOCKED then
      self.gray_img_copy.gameObject:SetActive(true)
      self.gray_lockIcon_copy.gameObject:SetActive(true)
      self.gray_deleteIcon_copy.gameObject:SetActive(false)
      self.gray_lockIcon_txt_copy.gameObject:SetActive(false)
    elseif info.state == PurchaseOrderState.DELETE then
      self.gray_img_copy.gameObject:SetActive(true)
      self.gray_lockIcon_copy.gameObject:SetActive(false)
      self.gray_deleteIcon_copy.gameObject:SetActive(true)
      self.gray_lockIcon_txt_copy.gameObject:SetActive(false)
      local leftTime = info.expTime - UITimeManager:GetInstance():GetServerTime()
      self.gray_deleteIcon_time_copy:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    end
    if param.selectIndex ~= nil and self.param.index == param.selectIndex then
      self.select_copy.gameObject:SetActive(true)
    else
      self.select_copy.gameObject:SetActive(false)
    end
    DOTween.Restart(self.bg_anim_copy.gameObject, PanelAni.Business_new)
  end
end

local function GetSelectTransform(self)
  return self.bg_anim.transform
end

local function PlayEnterAnim(self)
  DOTween.Restart(self.bg_anim.gameObject, PanelAni.Show)
  local showAnimation = true
  local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.param.uuid)
  if info ~= nil then
    local playLock = false
    local state = Setting:GetString(LuaEntry.Player.uid .. "ResidentOrderState" .. self.param.index, "-1")
    if Mathf.Floor(info.state) ~= Mathf.Floor(state) and info.state == PurchaseOrderState.NORMAL then
      playLock = true
      DOTween.Restart(self.lockIcon_dot_01.gameObject, PanelAni.Business_lock)
      DOTween.Restart(self.lockIcon_dot_02.gameObject, PanelAni.Business_lock)
      DOTween.Restart(self.lockIcon_dot_03.gameObject, PanelAni.Business_lock)
      DOTween.Restart(self.lockIcon_01.gameObject, PanelAni.Business_lock)
      DOTween.Restart(self.lockIcon_02.gameObject, PanelAni.Business_lock)
      DOTween.Restart(self.lockIcon_01_glow.gameObject, PanelAni.Business_lock)
      DOTween.Restart(self.lockIcon_02_glow.gameObject, PanelAni.Business_lock)
      Setting:SetString(LuaEntry.Player.uid .. "ResidentOrderState" .. self.param.index, info.state)
      TimerManager:GetInstance():DelayInvoke(function()
        self:RefreshState()
      end, 2)
    end
    local leftTime = Setting:GetString(LuaEntry.Player.uid .. "ResidentOrder" .. self.param.index, "0")
    local isShuaxin
    if Mathf.Floor(info.expTime) ~= Mathf.Floor(leftTime) and info.state == PurchaseOrderState.NORMAL and playLock == false then
      DOTween.Restart(self.bg_anim.gameObject, PanelAni.Business_shuaxin)
      Setting:SetString(LuaEntry.Player.uid .. "ResidentOrder" .. self.param.index, info.expTime)
      showAnimation = false
      isShuaxin = true
    end
    if playLock == false then
      self:RefreshState(isShuaxin)
      TimerManager:GetInstance():DelayInvoke(function()
        self:RefreshState()
      end, 1.7)
    end
    if showAnimation == true then
      DOTween.Restart(self.bg_anim.gameObject, PanelAni.Business_show_rotation)
    end
  end
end

local function PlayRefreshAnim(self)
  if self.bg_anim ~= nil then
    DOTween.Rewind(self.bg_anim.gameObject)
    DOTween.Restart(self.bg_anim.gameObject, PanelAni.Business_idle)
    self.bg_anim_copy.gameObject:SetActive(false)
  end
  return 0.8
end

local function RefreshTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.endTime ~= nil then
    local leftTime = self.endTime - now
    if self.lastTime ~= leftTime and self.gray_deleteIcon_time ~= nil then
      self.lastTime = leftTime
      if leftTime <= 0 then
        self.gray_deleteIcon_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
      else
        self.gray_deleteIcon_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
      end
    end
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

UIResidentOrderCell.OnCreate = OnCreate
UIResidentOrderCell.OnDestroy = OnDestroy
UIResidentOrderCell.Param = Param
UIResidentOrderCell.OnEnable = OnEnable
UIResidentOrderCell.OnDisable = OnDisable
UIResidentOrderCell.ComponentDefine = ComponentDefine
UIResidentOrderCell.ComponentDestroy = ComponentDestroy
UIResidentOrderCell.DataDefine = DataDefine
UIResidentOrderCell.DataDestroy = DataDestroy
UIResidentOrderCell.ReInit = ReInit
UIResidentOrderCell.RefreshState = RefreshState
UIResidentOrderCell.OnBtnClick = OnBtnClick
UIResidentOrderCell.PlaySubmitAnim = PlaySubmitAnim
UIResidentOrderCell.GetSelectTransform = GetSelectTransform
UIResidentOrderCell.PlayEnterAnim = PlayEnterAnim
UIResidentOrderCell.PlayRefreshAnim = PlayRefreshAnim
UIResidentOrderCell.RefreshCopy = RefreshCopy
UIResidentOrderCell.RefreshTime = RefreshTime
UIResidentOrderCell.AddTimer = AddTimer
UIResidentOrderCell.DeleteTimer = DeleteTimer
return UIResidentOrderCell
