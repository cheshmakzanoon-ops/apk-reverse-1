local UILWAlMailTip = BaseClass("UILWAlMailTip", UIBaseContainer)
local base = UIBaseContainer
local BtnType = {
  None = 0,
  System = 1,
  R5 = 2,
  SeasonReward = 3,
  ThanksLetter = 4,
  VipContact = 5
}

function UILWAlMailTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWAlMailTip:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMailTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, "Btn")
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.iconSystem = self:AddComponent(UIImage, "Btn/IconSystem")
  self.iconR5 = self:AddComponent(UIImage, "Btn/IconR5")
  self.Letter = self:AddComponent(UIImage, "Btn/Letter")
  self.openMailInfo = nil
end

function UILWAlMailTip:ComponentDestroy()
  self.clickBtn = nil
  self.openMailInfo = nil
end

function UILWAlMailTip:OnEnable()
  base.OnEnable(self)
  self:OnRefeshShow()
end

function UILWAlMailTip:OnDisable()
  base.OnDisable(self)
end

function UILWAlMailTip:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MailPush, self.OnRefeshShow)
end

function UILWAlMailTip:OnRemoveListener()
  self:RemoveUIListener(EventId.MailPush, self.OnRefeshShow)
  base.OnRemoveListener(self)
end

function UILWAlMailTip:OnClick()
  if self.openMailInfo and self.openMailInfo.uid then
    if self.btnType == BtnType.SeasonReward then
      UIManager.Instance:OpenWindow(UIWindowNames.UILWMailSeasonRewardView, {anim = true}, self.openMailInfo.uid)
      return
    end
    PostEventLog.Track(PostEventLog.Defines.MailTipIconClick, {
      i_common_num = self.btnType
    })
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.openMailInfo.uid)
    DataCenter.MailDataManager:ReadMail(self.openMailInfo.uid)
  end
end

function UILWAlMailTip:OnRefeshShow()
  self.openMailInfo = nil
  self.btnType = BtnType.None
  if self.openMailInfo == nil then
    local targetType = MailType.VIP_STRONG_CONTACT
    local list = DataCenter.MailDataManager:GetGroupMailList(MailTypeToInternalGroup[targetType])
    for i = #list, 1, -1 do
      local info = list[i]
      if info.status ~= 1 and info.type == targetType then
        self.openMailInfo = info
        self.btnType = BtnType.VipContact
        break
      end
    end
  end
  if self.openMailInfo == nil then
    local systemMailList = DataCenter.MailDataManager:GetGroupMailList(MailInternalGroup.MAIL_IN_system)
    for i = #systemMailList, 1, -1 do
      local info = systemMailList[i]
      if info.status ~= 1 then
        self.openMailInfo = info
        self.btnType = BtnType.System
        break
      end
    end
  end
  if self.openMailInfo == nil then
    local targetType = MailType.LW_ALLIANCE_GROUP_MAIL
    local list = DataCenter.MailDataManager:GetGroupMailList(MailTypeToInternalGroup[targetType])
    for i = #list, 1, -1 do
      local info = list[i]
      if info.status ~= 1 and info.type == targetType then
        self.openMailInfo = info
        self.btnType = BtnType.R5
        break
      end
    end
  end
  if self.openMailInfo == nil then
    local targetType = MailType.LW_SEASON_ALLIANCE_REWARD_MAIL
    local list = DataCenter.MailDataManager:GetGroupMailList(MailTypeToInternalGroup[targetType])
    for i = #list, 1, -1 do
      local info = list[i]
      if info.status ~= 1 and info.type == targetType then
        self.openMailInfo = info
        self.btnType = BtnType.SeasonReward
        break
      end
    end
  end
  if self.openMailInfo == nil or self.openMailInfo.type == MailType.THANKS_LETTER then
    local targetType = MailType.THANKS_LETTER
    local list = DataCenter.MailDataManager:GetGroupMailList(MailTypeToInternalGroup[targetType])
    for i = #list, 1, -1 do
      local info = list[i]
      if info.status ~= 1 and info.type == targetType then
        self.openMailInfo = info
        self.btnType = BtnType.ThanksLetter
        break
      end
    end
  end
  DataCenter.MailDataManager:SetMailTipBtnType(self.btnType)
  if self.btnType == BtnType.None then
    self.clickBtn:SetActive(false)
  elseif self.btnType == BtnType.System then
    self.clickBtn:SetActive(true)
    self.iconSystem:SetActive(true)
    self.iconR5:SetActive(false)
    self.Letter:SetActive(false)
    local isJap = LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen()
    local systemIconPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lyt_2025xinnian_monika02.png"
    if isJap then
      systemIconPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lyt_2025xinnian_monika01.png"
    end
    self.iconSystem:LoadSprite(systemIconPath)
  elseif self.btnType == BtnType.R5 then
    self.clickBtn:SetActive(true)
    self.iconSystem:SetActive(false)
    self.iconR5:SetActive(true)
    self.Letter:SetActive(false)
    local isR5 = false
    if self.openMailInfo then
      local extra = self.openMailInfo:GetMailMessageExtra()
      if tostring(extra) == "5" then
        isR5 = true
      end
    end
    if isR5 then
      self.iconR5:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_lianmeng_tubiao_r5.png")
    else
      self.iconR5:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_lianmeng_tubiao_r4.png")
    end
  elseif self.btnType == BtnType.SeasonReward then
    self.clickBtn:SetActive(true)
    self.iconSystem:SetActive(false)
    self.iconR5:SetActive(true)
    self.Letter:SetActive(false)
    self.iconR5:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/LRB_saiji_lichengbei_icon.png")
  elseif self.btnType == BtnType.ThanksLetter then
    self.clickBtn:SetActive(true)
    self.iconSystem:SetActive(false)
    self.iconR5:SetActive(false)
    self.Letter:SetActive(true)
    local isJap = LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen()
    local iconPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lyt_2025xinnian_monika02.png"
    if isJap then
      iconPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lyt_2025xinnian_monika01.png"
    end
    self.Letter:LoadSprite(iconPath)
  elseif self.btnType == BtnType.VipContact then
    self.clickBtn:SetActive(true)
    self.iconSystem:SetActive(false)
    self.iconR5:SetActive(true)
    self.Letter:SetActive(false)
    self.iconR5:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_vip_youjianqipao.png")
  end
end

return UILWAlMailTip
