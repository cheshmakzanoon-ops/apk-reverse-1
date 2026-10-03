local BirthdayDataSetPanelView = BaseClass("BirthdayDataSetPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local bgChangeAniTIme = 2000
local BirthdayDisplayContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayDisplayContent")
local BirthdayMenuContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayMenuContent")
local BirthdayZodContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayZodContent")
local BirthdayAgeSelectContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayAgeSelectContent")
local BirthdayRewardContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayRewardContent")
local BirthdayVisibleContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayVisibleContent")
local BirthdayNumSelectContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayNumSelectContent")
local NormalBg = require("UI.Birthday.BirthdayDataSetPanel.Component.NormalBg")
local SznBg = require("UI.Birthday.BirthdayDataSetPanel.Component.SznBg")
local BirthdayBgConfig = {
  [BirthdaySzn.Default] = {
    path = "Assets/Main/Prefabs/UI/LWPlayerInfo/Birthday/BgSzn/NormalBg.prefab",
    script = NormalBg
  },
  [BirthdaySzn.Spring] = {
    path = "Assets/Main/Prefabs/UI/LWPlayerInfo/Birthday/BgSzn/SpringBg.prefab",
    script = SznBg
  },
  [BirthdaySzn.Summer] = {
    path = "Assets/Main/Prefabs/UI/LWPlayerInfo/Birthday/BgSzn/SummerBg.prefab",
    script = SznBg
  },
  [BirthdaySzn.Fall] = {
    path = "Assets/Main/Prefabs/UI/LWPlayerInfo/Birthday/BgSzn/FallBg.prefab",
    script = SznBg
  },
  [BirthdaySzn.Winter] = {
    path = "Assets/Main/Prefabs/UI/LWPlayerInfo/Birthday/BgSzn/WinterBg.prefab",
    script = SznBg
  }
}
local panel_path = "panel"
local root_path = "Root"
local title_text_path = "Root/Common_img_title/titleText"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local set_content_path = "Root/InfoContent/SetContent"
local dis_play_content_path = "Root/InfoContent/DisPlayContent"
local visible_content_path = "Root/InfoContent/VisibleContent"
local confirm_btn_path = "Root/InfoContent/ConfirmBtnContent/confirmBtn"
local confirm_btn_txt_path = "Root/InfoContent/ConfirmBtnContent/confirmBtn/confirmBtnTxt"
local select_menu_path = "Root/SelectMenu"
local select_menu_pos_set_path = "Root/SelectMenuPosSet"
local birth_num_select_path = "Root/InfoContent/SetContent/birthNumSelect"
local confirm_tip_txt_path = "Root/InfoContent/ConfirmTipContent/ConfirmTipTxt"
local bg_path = "Root/bg"
local loading_root_path = "LoadingRoot"
local wait_image_path = "LoadingRoot/WaitImage"
local age_content_path = "Root/InfoContent/AgeContent"
local reward_get_btn_path = "Root/InfoContent/ConfirmBtnContent/rewardGetBtn"
local star_show_content_path = "Root/InfoContent/StarShowContent"
local tip_btn_path = "Root/Common_img_title/TipBtn"

function BirthdayDataSetPanelView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function BirthdayDataSetPanelView:OnDestroy()
  self:RemoveBgReq()
  self:StopWaitTween()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BirthdayDataSetPanelView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
end

function BirthdayDataSetPanelView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dis_play_content = self:AddComponent(BirthdayDisplayContent, dis_play_content_path)
  self.visible_content = self:AddComponent(BirthdayVisibleContent, visible_content_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn_txt = self:AddComponent(UITextMeshProUGUIEx, confirm_btn_txt_path)
  self.select_menu = self:AddComponent(BirthdayMenuContent, select_menu_path)
  self.select_menu_pos_set = self:AddComponent(UIBaseContainer, select_menu_pos_set_path)
  self.birth_num_select = self:AddComponent(BirthdayNumSelectContent, birth_num_select_path)
  self.confirm_tip_txt = self:AddComponent(UITextMeshProUGUIEx, confirm_tip_txt_path)
  self.loading_root = self:AddComponent(UIBaseContainer, loading_root_path)
  self.wait_image = self:AddComponent(UIImage, wait_image_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.age_content = self:AddComponent(BirthdayAgeSelectContent, age_content_path)
  self.reward_get_btn = self:AddComponent(BirthdayRewardContent, reward_get_btn_path)
  self.star_show_content = self:AddComponent(BirthdayZodContent, star_show_content_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
end

function BirthdayDataSetPanelView:ComponentDestroy()
  self.panel = nil
  self.root = nil
  self.title_text = nil
  self.close_btn = nil
  self.dis_play_content = nil
  self.visible_content = nil
  self.confirm_btn = nil
  self.confirm_btn_txt = nil
  self.select_menu = nil
  self.select_menu_pos_set = nil
  self.birth_num_select = nil
  self.confirm_tip_txt = nil
  self.loading_root = nil
  self.wait_image = nil
  self.bg = nil
  self.age_content = nil
  self.reward_get_btn = nil
  self.star_show_content = nil
  self.tip_btn = nil
end

function BirthdayDataSetPanelView:DataDefine()
  self.saveData = nil
  self.ageListData = nil
  self.curShowBgType = nil
  self.nextShowBgType = nil
  self.bgReqDict = {}
  self.bgWaitTween = nil
  self.bgChangeType = nil
  self.bgChangeFinTime = nil
  self.nextChangeTime = nil
end

function BirthdayDataSetPanelView:DataDestroy()
  self.saveData = nil
  self.ageListData = nil
  self.curShowBgType = nil
  self.nextShowBgType = nil
  self.bgReqDict = nil
  self.bgWaitTween = nil
  self.bgChangeType = nil
  self.bgChangeFinTime = nil
  self.nextChangeTime = nil
end

function BirthdayDataSetPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BirthdaySetPanelShowDataChange, self.OnPanelShowDataChange)
  self:AddUIListener(EventId.BirthdaySetPanelMenuHide, self.OnMenuHideMsg)
  self:AddUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
  self:AddUIListener(EventId.BirthdaySetDataSuccess, self.OnSetDataSuccess)
end

function BirthdayDataSetPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.BirthdaySetPanelShowDataChange, self.OnPanelShowDataChange)
  self:RemoveUIListener(EventId.BirthdaySetPanelMenuHide, self.OnMenuHideMsg)
  self:RemoveUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
  self:RemoveUIListener(EventId.BirthdaySetDataSuccess, self.OnSetDataSuccess)
  base.OnRemoveListener(self)
end

function BirthdayDataSetPanelView:ReInit()
  self:InitData()
  self:InitView()
  self:RefreshBgChange(true)
  self:TryRecordServerGuide()
end

function BirthdayDataSetPanelView:InitData()
  self.saveData = {
    age = nil,
    birthdayMonth = nil,
    birthdayDay = nil,
    modifyTime = nil,
    modifyNextTime = nil,
    receiveYear = nil,
    displayType = BirthdayShowArea.All,
    zodType = BirthdayZodType.ShowAll,
    rewarded = false
  }
  local setData = DataCenter.BirthdayDataManager:GetSetData()
  if setData then
    self.saveData.age = setData.age
    local birthday = setData.birthday
    if not string.IsNullOrEmpty(birthday) then
      local numArr = string.string2array_i_oneSep(birthday, "-")
      if #numArr == 2 then
        self.saveData.birthdayMonth = numArr[1]
        self.saveData.birthdayDay = numArr[2]
      end
    end
    self.saveData.modifyTime = setData.modifyTime
    self.saveData.receiveYear = setData.receiveYear
    self.saveData.displayType = setData.displayType
    self.saveData.zodType = setData.zodType
    self.saveData.rewarded = setData.rewarded
    local modifySpaceDayNum = DataCenter.BirthdayDataManager:GetBirthdayDataModifyTimeSpaceDayNum()
    if self.saveData.modifyTime then
      self.saveData.modifyNextTime = self.saveData.modifyTime + modifySpaceDayNum * 24 * 60 * 60 * 1000
    end
  end
  self.ageListData = DataCenter.BirthdayDataManager:GetAgeListTab()
end

function BirthdayDataSetPanelView:InitView()
  self.title_text:SetLocalText("birthday_3_limit_15")
  self.age_content:SetAgeListData(self.ageListData)
  self:RefreshView()
  self.select_menu:SetActive(false)
end

function BirthdayDataSetPanelView:RefreshBgChange(isInit)
  local isChange = false
  local isNextBgLoadFin = self.nextShowBgType and self.bgReqDict[self.nextShowBgType] and self.bgReqDict[self.nextShowBgType].comp
  if isInit or isNextBgLoadFin then
    isChange = true
  end
  if isChange == false then
    return
  end
  if self.curShowBgType == nil then
    if isNextBgLoadFin then
      self.curShowBgType = self.nextShowBgType
      self.nextShowBgType = nil
      self.bgChangeType = nil
      self.bgChangeFinTime = nil
      self:StopWaitTween()
      self.loading_root:SetActive(false)
      self.root:SetActive(true)
      for k, v in pairs(self.bgReqDict) do
        if v.comp then
          v.comp:SetActive(k == self.curShowBgType)
          if k == self.curShowBgType then
            v.comp:SetIdelAni()
            v.comp:SetData(self.saveData.birthdayMonth, self.saveData.birthdayDay, self.curShowBgType)
            v.comp:SetAsLastSibling()
          end
        end
      end
    elseif isInit then
      self:StopWaitTween()
      self.loading_root:SetActive(true)
      self.root:SetActive(false)
      self.bgWaitTween = self.wait_image.transform:DOLocalRotate(Vector3(0, 0, -360), 1, CS.DG.Tweening.RotateMode.LocalAxisAdd):SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
    end
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.bgChangeType == nil then
    else
      self.curShowBgType = self.bgChangeType
    end
    self.bgChangeType = self.nextShowBgType
    self.bgChangeFinTime = curTime + bgChangeAniTIme
    self.nextShowBgType = nil
    for k, v in pairs(self.bgReqDict) do
      if v.comp then
        v.comp:SetActive(k == self.curShowBgType or k == self.bgChangeType)
        if k == self.bgChangeType then
          v.comp:SetChangeAni()
          v.comp:SetData(self.saveData.birthdayMonth, self.saveData.birthdayDay, self.bgChangeType)
          v.comp:SetAsLastSibling()
        elseif k == self.curShowBgType then
          v.comp:SetIdelAni()
          v.comp:SetData(self.saveData.birthdayMonth, self.saveData.birthdayDay, self.curShowBgType)
        end
      end
    end
  end
end

function BirthdayDataSetPanelView:StopWaitTween()
  if self.bgWaitTween ~= nil then
    self.bgWaitTween:Kill()
    self.bgWaitTween = nil
  end
end

function BirthdayDataSetPanelView:RemoveBgReq()
  self.bg:RemoveComponents(NormalBg)
  self.bg:RemoveComponents(SznBg)
  for k, v in pairs(self.bgReqDict) do
    if v.req then
      self:GameObjectDestroy(v.req)
    end
  end
  self.bgReqDict = {}
end

function BirthdayDataSetPanelView:RefreshConfirmTipContent()
  self.nextChangeTime = nil
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isCanSend = self:CheckCanSendAtTime() and self:CheckCanSendAtEmpty() and self:CheckCanSendAtDataReal() and self:CheckHaveChange()
  UIGray.SetGray(self.confirm_btn.transform, not isCanSend, isCanSend)
  if isCanSend then
    self.confirm_tip_txt:SetLocalText("birthday_4_limit_20")
    if self.saveData.modifyNextTime and curTime < self.saveData.modifyNextTime then
      self.nextChangeTime = self.saveData.modifyNextTime
      self:Update1000MS()
    end
  elseif not self:CheckCanSendAtTime() then
    self.confirm_tip_txt:SetLocalText("birthday_4_limit_20")
    if self.saveData.modifyNextTime and curTime < self.saveData.modifyNextTime then
      self.nextChangeTime = self.saveData.modifyNextTime
      self:Update1000MS()
    end
  elseif not self:CheckCanSendAtEmpty() then
    local emptyName = ""
    if self.saveData.birthdayMonth == nil then
      emptyName = Localization:GetString("birthday_tips_34")
    elseif self.saveData.birthdayDay == nil then
      emptyName = Localization:GetString("birthday_tips_34")
    elseif self.saveData.age == nil then
      emptyName = Localization:GetString("birthday_tips_31")
    elseif self.saveData.displayType == nil then
      emptyName = Localization:GetString("birthday_tips_32")
    end
    self.confirm_tip_txt:SetLocalText("birthday_tips_27", emptyName)
  elseif not self:CheckCanSendAtDataReal() then
    self.confirm_tip_txt:SetLocalText("birthday_tips_28")
  else
    self.confirm_tip_txt:SetLocalText("birthday_4_limit_20")
    if self.saveData.modifyNextTime and curTime < self.saveData.modifyNextTime then
      self.nextChangeTime = self.saveData.modifyNextTime
      self:Update1000MS()
    end
  end
end

function BirthdayDataSetPanelView:Update1000MS()
  if self.nextChangeTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.nextChangeTime then
    self.nextChangeTime = nil
    self:RefreshConfirmTipContent()
  else
    local leftTime = self.nextChangeTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.confirm_tip_txt:SetLocalText("birthday_tips_21", countDownTimeStr)
  end
end

function BirthdayDataSetPanelView:RefreshView()
  self.dis_play_content:SetData(self.saveData)
  self.visible_content:SetData(self.saveData)
  self.birth_num_select:SetData(self.saveData)
  self.age_content:SetData(self.saveData)
  self.star_show_content:SetData(self.saveData)
  self.reward_get_btn:SetData(self.saveData)
  self:RefreshConfirmTipContent()
  local curMonth = self.saveData.birthdayMonth
  local bgSznType = BirthdaySzn.Default
  if curMonth then
    bgSznType = DataCenter.BirthdayDataManager:GetSznTypeByMonth(curMonth)
  end
  if BirthdayBgConfig[bgSznType] then
    local isNeedChange = false
    if self.bgChangeType then
      if self.bgChangeType ~= bgSznType then
        isNeedChange = true
      end
    elseif self.curShowBgType then
      if self.curShowBgType ~= bgSznType then
        isNeedChange = true
      end
    else
      isNeedChange = true
    end
    if isNeedChange then
      self.nextShowBgType = bgSznType
      if self.bgReqDict[bgSznType] == nil then
        self.bgReqDict[bgSznType] = {}
      end
      if self.bgReqDict[bgSznType].comp then
        self:RefreshBgChange(false)
      elseif self.bgReqDict[bgSznType].req == nil then
        local bgCfg = BirthdayBgConfig[bgSznType]
        self.bgReqDict[bgSznType].req = self:GameObjectInstantiateAsync(bgCfg.path, function(req)
          if req == nil or IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.transform:SetParent(self.bg.transform)
          self.bgReqDict[bgSznType].comp = self.bg:AddComponent(bgCfg.script, item.name)
          self.bgReqDict[bgSznType].comp:SetLocalScaleXYZ(1, 1, 1)
          self.bgReqDict[bgSznType].comp:SetAnchoredPositionXY(0, 0)
          self:RefreshBgChange(false)
        end)
      end
    else
      if self.bgReqDict[bgSznType] == nil then
        self.bgReqDict[bgSznType] = {}
      end
      if self.bgReqDict[bgSznType].comp then
        self.bgReqDict[bgSznType].comp:SetData(self.saveData.birthdayMonth, self.saveData.birthdayDay, bgSznType)
      end
    end
  end
end

function BirthdayDataSetPanelView:OnPanelShowDataChange()
  self:RefreshView()
  self.select_menu:SetActive(false)
end

function BirthdayDataSetPanelView:OnMenuHideMsg()
  self.visible_content:SetData(self.saveData)
  self.birth_num_select:SetData(self.saveData)
  self.age_content:SetData(self.saveData)
  self.select_menu:SetActive(false)
end

function BirthdayDataSetPanelView:OnBirthdaySetRewardGet()
  self.reward_get_btn:SetData(self.saveData)
end

function BirthdayDataSetPanelView:OnSetDataSuccess()
  self:ReInit()
  self.reward_get_btn:SetData(self.saveData)
  self:RefreshConfirmTipContent()
end

function BirthdayDataSetPanelView:OnSetMenuShow(targetContainer, dataList, selectKey, selectFunc)
  local targetSizeDelta = targetContainer:GetSizeDelta()
  self.select_menu_pos_set:SetSizeDeltaXY(targetSizeDelta.x, targetSizeDelta.y)
  self.select_menu_pos_set:SetPosition(targetContainer:GetPosition())
  local posSetPos = self.select_menu_pos_set:GetAnchoredPosition()
  self.select_menu:SetActive(true)
  self.select_menu:SetAnchoredPositionXY(posSetPos.x, posSetPos.y + targetSizeDelta.y / 2)
  self.select_menu:SetData(targetContainer, dataList, selectKey, selectFunc, targetSizeDelta.y)
end

function BirthdayDataSetPanelView:OnConfirmBtnClick()
  if not (self:CheckCanSendAtTime() and self:CheckCanSendAtEmpty()) or not self:CheckCanSendAtDataReal() then
    return
  end
  if self:IsOnlyDisplayTypeChangeAndOtherDataHave() then
    local setData = DataCenter.BirthdayDataManager:GetSetData()
    if setData.displayType == self.saveData.displayType then
      if setData.age ~= self.saveData.age or setData.zodType ~= self.saveData.zodType then
        SFSNetwork.SendMessage(MsgDefines.UserSetBirthday, nil, self.saveData.age, self.saveData.displayType, self.saveData.zodType)
        self.ctrl:CloseSelf()
        UIUtil.ShowTipsId("birthday_tips_54")
      end
    else
      local visibleName = DataCenter.BirthdayDataManager:GetVisibleNameByType(self.saveData.displayType)
      UIUtil.ShowMessage(Localization:GetString("birthday_tips_37", visibleName), 1, nil, nil, function()
        SFSNetwork.SendMessage(MsgDefines.UserSetBirthday, nil, self.saveData.age, self.saveData.displayType, self.saveData.zodType)
        self.ctrl:CloseSelf()
        UIUtil.ShowTipsId("birthday_tips_54")
      end)
    end
  else
    local setData = DataCenter.BirthdayDataManager:GetSetData()
    local isFirstChange = false
    if setData == nil or setData.birthday == nil then
      isFirstChange = true
    end
    local birthday = string.format("%02d-%02d", self.saveData.birthdayMonth, self.saveData.birthdayDay)
    local visibleName = DataCenter.BirthdayDataManager:GetVisibleNameByType(self.saveData.displayType)
    UIUtil.ShowMessage(Localization:GetString("birthday_tips_15", visibleName), 1, nil, nil, function()
      SFSNetwork.SendMessage(MsgDefines.UserSetBirthday, birthday, self.saveData.age, self.saveData.displayType, self.saveData.zodType)
      UIUtil.ShowTipsId("birthday_tips_54")
      if isFirstChange then
      else
        self.ctrl:CloseSelf()
      end
    end)
  end
end

function BirthdayDataSetPanelView:TryRecordServerGuide()
  if not DataCenter.BirthdayDataManager:GetBirthdayGuidServerRecordHaveSet() then
    DataCenter.BirthdayDataManager:SendBirthdayGuidServerRecord()
  end
end

function BirthdayDataSetPanelView:CheckCanSendAtTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not self:IsOnlyDisplayTypeChangeAndOtherDataHave() and self.saveData.modifyNextTime and curTime < self.saveData.modifyNextTime then
    return false
  end
  return true
end

function BirthdayDataSetPanelView:IsOnlyDisplayTypeChangeAndOtherDataHave()
  local result = false
  local birthday = ""
  if self.saveData.birthdayMonth and self.saveData.birthdayDay then
    birthday = string.format("%02d-%02d", self.saveData.birthdayMonth, self.saveData.birthdayDay)
  end
  local setData = DataCenter.BirthdayDataManager:GetSetData()
  if setData and setData.birthday == birthday then
    result = true
  end
  return result
end

function BirthdayDataSetPanelView:CheckCanSendAtEmpty()
  if self.saveData.age == nil or self.saveData.birthdayMonth == nil or self.saveData.birthdayDay == nil or self.saveData.displayType == nil then
    return false
  end
  return true
end

function BirthdayDataSetPanelView:CheckCanSendAtDataReal()
  local dayMaxNum = MonthMaxDay[self.saveData.birthdayMonth]
  if dayMaxNum < self.saveData.birthdayDay then
    return false
  end
  return true
end

function BirthdayDataSetPanelView:CheckHaveChange()
  local haveChange = false
  local setData = DataCenter.BirthdayDataManager:GetSetData()
  if setData then
    if self.saveData.displayType ~= setData.displayType or self.saveData.age ~= setData.age or self.saveData.zodType ~= setData.zodType then
      haveChange = true
    elseif self.saveData.birthdayMonth and self.saveData.birthdayDay then
      local birthday = string.format("%02d-%02d", self.saveData.birthdayMonth, self.saveData.birthdayDay)
      if setData.birthday ~= birthday then
        haveChange = true
      end
    end
  else
    haveChange = true
  end
  return haveChange
end

function BirthdayDataSetPanelView:OnTipBtnClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("birthday_tips_6")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return BirthdayDataSetPanelView
