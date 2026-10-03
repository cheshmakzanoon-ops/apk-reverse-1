local UILWPlayerDeatilBirthdayInfoItem = BaseClass("UILWPlayerDeatilBirthdayInfoItem", UIBaseContainer)
local base = UIBaseContainer
local InBirthdayImgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_dangao_icon.png"
local NotInBirthdayImgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_dangao_icon2.png"
local icon_path = "infoContent/icon"
local text_path = "infoContent/text"
local set_btn_red_path = "SetBtn/Image/setBtnRed"

function UILWPlayerDeatilBirthdayInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWPlayerDeatilBirthdayInfoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerDeatilBirthdayInfoItem:OnAddListener()
  self:AddUIListener(EventId.OnSelfBirthdaySetNeedTipStatusChange, self.OnSelfBirthdaySetNeedTipStatusChange)
  self:AddUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccess)
  self:AddUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
  base.OnAddListener(self)
end

function UILWPlayerDeatilBirthdayInfoItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OnSelfBirthdaySetNeedTipStatusChange, self.OnSelfBirthdaySetNeedTipStatusChange)
  self:RemoveUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccess)
  self:RemoveUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
  base.OnRemoveListener(self)
end

function UILWPlayerDeatilBirthdayInfoItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.btn = self:AddComponent(UIButton, "SetBtn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.set_btn_red = self:AddComponent(UIImage, set_btn_red_path)
end

function UILWPlayerDeatilBirthdayInfoItem:ComponentDestroy()
  self.icon = nil
  self.text = nil
  self.set_btn_red = nil
end

function UILWPlayerDeatilBirthdayInfoItem:DataDestroy()
end

function UILWPlayerDeatilBirthdayInfoItem:OnBtnClick()
  if self.data == nil then
    return
  end
  if self.data.uid ~= LuaEntry.Player.uid then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.BirthdayDataSetPanel, {anim = true})
end

function UILWPlayerDeatilBirthdayInfoItem:ReInit(data)
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
  self.btn:SetActive(self.data.uid == LuaEntry.Player.uid)
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
      self.text:SetLocalText("birthday_tips_2", numArr[1], numArr[2])
    else
      self.text:SetText("")
    end
  else
    self.icon:LoadSprite(NotInBirthdayImgPath)
    self.text:SetLocalText("birthday_tips_1")
  end
  self:TryRecordServerGuide()
end

function UILWPlayerDeatilBirthdayInfoItem:TryRecordServerGuide()
  if self.data.uid ~= LuaEntry.Player.uid then
    return
  end
  if DataCenter.BirthdayDataManager:GetIsSelfBirthdayFuncOpen() and not DataCenter.BirthdayDataManager:GetBirthdayGuidServerRecordInfoOpenHaveSet() then
    DataCenter.BirthdayDataManager:SendBirthdayGuidServerRecordInfoOpen()
  end
end

function UILWPlayerDeatilBirthdayInfoItem:OnSelfBirthdaySetNeedTipStatusChange()
  self:RefreshBirthdaySetBtnRed()
end

function UILWPlayerDeatilBirthdayInfoItem:RefreshBirthdaySetBtnRed()
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

function UILWPlayerDeatilBirthdayInfoItem:OnBirthdaySetDataSuccess()
  self:ReInit(self.data)
end

function UILWPlayerDeatilBirthdayInfoItem:OnBirthdaySetRewardGet()
  self:RefreshBirthdaySetBtnRed()
end

return UILWPlayerDeatilBirthdayInfoItem
