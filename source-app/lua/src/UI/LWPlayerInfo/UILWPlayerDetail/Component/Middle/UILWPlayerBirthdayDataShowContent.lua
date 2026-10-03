local UILWPlayerBirthdayDataShowContent = BaseClass("UILWPlayerBirthdayDataShowContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local InBirthdayImgPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/ljq_liwu_dangao_icon.png"
local NotInBirthdayImgPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/ljq_liwu_dangao_icon.png"
local NotSetImgPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/ljq_liwu_dangao_anniu.png"
local icon_path = "birthdayIcon"
local text_path = "text"
local set_btn_red_path = "birthdayIcon/redDot"
local tip_pos_path = "TipPos"

function UILWPlayerBirthdayDataShowContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWPlayerBirthdayDataShowContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerBirthdayDataShowContent:OnAddListener()
  self:AddUIListener(EventId.OnSelfBirthdaySetNeedTipStatusChange, self.OnSelfBirthdaySetNeedTipStatusChange)
  self:AddUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccess)
  self:AddUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
  base.OnAddListener(self)
end

function UILWPlayerBirthdayDataShowContent:OnRemoveListener()
  self:RemoveUIListener(EventId.OnSelfBirthdaySetNeedTipStatusChange, self.OnSelfBirthdaySetNeedTipStatusChange)
  self:RemoveUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccess)
  self:RemoveUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
  base.OnRemoveListener(self)
end

function UILWPlayerBirthdayDataShowContent:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.set_btn_red = self:AddComponent(UIImage, set_btn_red_path)
  self.tip_pos = self:AddComponent(UIBaseContainer, tip_pos_path)
end

function UILWPlayerBirthdayDataShowContent:ComponentDestroy()
  self.icon = nil
  self.text = nil
  self.set_btn_red = nil
  self.tip_pos = nil
end

function UILWPlayerBirthdayDataShowContent:DataDestroy()
end

function UILWPlayerBirthdayDataShowContent:OnBtnClick()
  if self.data == nil then
    return
  end
  if self.data.uid ~= LuaEntry.Player.uid then
    local showStr = ""
    local numArr = string.string2array_i_oneSep(self.data.birthday, "-")
    if #numArr == 2 then
      showStr = Localization:GetString("birthday_desc_2", numArr[1], numArr[2])
    end
    UIUtil.ShowButtonTips(self.tip_pos, "", showStr, true)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.BirthdayDataSetPanel, {anim = true})
  end
end

function UILWPlayerBirthdayDataShowContent:ReInit(data)
  self.data = data
  if self.data == nil then
    return
  end
  local targetBirthdayStr = self.data.birthday
  if self.data.uid == LuaEntry.Player.uid then
    local selfBirthdayData = DataCenter.BirthdayDataManager:GetSetData()
    if selfBirthdayData then
      targetBirthdayStr = selfBirthdayData.birthday
    else
      targetBirthdayStr = nil
    end
  end
  self:RefreshBirthdaySetBtnRed()
  local isHaveSet = false
  if self.data.uid == LuaEntry.Player.uid then
    if not string.IsNullOrEmpty(targetBirthdayStr) then
      isHaveSet = true
    end
  elseif not string.IsNullOrEmpty(targetBirthdayStr) and DataCenter.BirthdayDataManager:CheckIsPassSetShowArea(self.data.uid, self.data.allianceId, self.data.birthdayDisplay) then
    isHaveSet = true
  end
  if isHaveSet then
    local isInBirthday = DataCenter.BirthdayDataManager:CheckIsSameTime(targetBirthdayStr)
    local isZodShow = false
    if self.data.uid == LuaEntry.Player.uid then
      local selfBirthdayData = DataCenter.BirthdayDataManager:GetSetData()
      if selfBirthdayData and selfBirthdayData.zodType and selfBirthdayData.zodType > 0 then
        isZodShow = true
      end
    elseif self.data.zodDisplay and 0 < self.data.zodDisplay then
      isZodShow = true
    end
    if isInBirthday then
      if isZodShow then
        local iconPath = DataCenter.BirthdayDataManager:GetConstellationImgPathByDate(targetBirthdayStr)
        self.icon:LoadSprite(iconPath)
      else
        self.icon:LoadSprite(InBirthdayImgPath)
      end
    elseif isZodShow then
      local iconPath = DataCenter.BirthdayDataManager:GetConstellationImgPathByDate(targetBirthdayStr, true)
      self.icon:LoadSprite(iconPath)
    else
      self.icon:LoadSprite(NotInBirthdayImgPath)
    end
    local numArr = string.string2array_i_oneSep(targetBirthdayStr, "-")
    if #numArr == 2 then
      self.text:SetLocalText("birthday_desc_1_limit", numArr[1], numArr[2])
    else
      self.text:SetText("")
    end
  else
    self.icon:LoadSprite(NotSetImgPath)
    self.text:SetText("")
  end
  self.icon:SetNativeSize()
  self:TryRecordServerGuide()
end

function UILWPlayerBirthdayDataShowContent:TryRecordServerGuide()
  if self.data.uid ~= LuaEntry.Player.uid then
    return
  end
  if DataCenter.BirthdayDataManager:GetIsSelfBirthdayFuncOpen() and not DataCenter.BirthdayDataManager:GetBirthdayGuidServerRecordInfoOpenHaveSet() then
    DataCenter.BirthdayDataManager:SendBirthdayGuidServerRecordInfoOpen()
  end
end

function UILWPlayerBirthdayDataShowContent:OnSelfBirthdaySetNeedTipStatusChange()
  self:RefreshBirthdaySetBtnRed()
end

function UILWPlayerBirthdayDataShowContent:RefreshBirthdaySetBtnRed()
  local isShow = false
  if self.data.uid == LuaEntry.Player.uid then
    if DataCenter.BirthdayDataManager.isBirthdayDataNeedSetTip then
      isShow = true
    elseif DataCenter.BirthdayDataManager:FirstSetRewardHaveGetRedDot() and DataCenter.BirthdayDataManager:CheckDisplayTypeNotOnlySelf() then
      isShow = true
    end
  end
  self.set_btn_red:SetActive(isShow)
end

function UILWPlayerBirthdayDataShowContent:OnBirthdaySetDataSuccess()
  self:ReInit(self.data)
end

function UILWPlayerBirthdayDataShowContent:OnBirthdaySetRewardGet()
  self:RefreshBirthdaySetBtnRed()
end

return UILWPlayerBirthdayDataShowContent
