local TruckRobRecordItem = BaseClass("TruckRobRecordItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local read_img_path = "BgRead"
local name_txt_path = "TitleTxt"
local des_txt_path = "SubTitleTxt"
local time_txt_path = "TimeText"
local gift_img_path = "Gift"
local red_point_path = "RedPoint"
local btn_path = "ClickButton"
local truckIcon = "Assets/Main/Sprites/UI/UILWMail/lrb_chengjimaoyi_zhanbaoicon.png"
local trainIcon = "Assets/Main/Sprites/UI/UILWMail/zxl_youjian_huoche.png"

function TruckRobRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TruckRobRecordItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TruckRobRecordItem:ComponentDefine()
  self.readBg = self:AddComponent(UIBaseContainer, read_img_path)
  self.targetIcon = self:AddComponent(UIImage, "targetIcon")
  self.winIcon = self:AddComponent(UIImage, "winIcon")
  self.bg = self:AddComponent(UIImage, "Bg")
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.desText = self:AddComponent(UIText, des_txt_path)
  self.timeText = self:AddComponent(UIText, time_txt_path)
  self.giftIcon = self:AddComponent(UIBaseContainer, gift_img_path)
  self.redPoint = self:AddComponent(UIBaseContainer, red_point_path)
  self.clickBtn = self:AddComponent(UIButton, btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnMailClick()
  end)
end

function TruckRobRecordItem:ComponentDestroy()
  self.readBg = nil
  self.targetIcon = nil
  self.winIcon = nil
  self.nameText = nil
  self.desText = nil
  self.timeText = nil
  self.giftIcon = nil
  self.redPoint = nil
  self.clickBtn = nil
end

function TruckRobRecordItem:DataDefine()
end

function TruckRobRecordItem:DataDestroy()
  self.recordData = nil
  self.recordUuid = nil
end

function TruckRobRecordItem:OnEnable()
  base.OnEnable(self)
end

function TruckRobRecordItem:OnDisable()
  base.OnDisable(self)
end

function TruckRobRecordItem:OnAddListener()
  base.OnAddListener(self)
end

function TruckRobRecordItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TruckRobRecordItem:SetData(params)
  self.recordData = params
  if not self.recordData then
    return
  end
  self.mailUid = self.recordData.uid
  if not self.mailUid then
    return
  end
  local mainTitle = MailShowHelper.GetMainTitle(self.recordData)
  self.nameText:SetText(mainTitle)
  local subTitle = MailShowHelper.GetMailSubTitle(self.recordData)
  self.desText:SetText(subTitle)
  local createTime = MailShowHelper.GetRelativeCreateTime(self.recordData)
  self.timeText:SetText(createTime)
  self:RefreshIcon()
  if self.recordData and self.recordData:IsBattleReportMailType() and not self.recordData:IsBattleReportIntegrity() then
    self.recordData:OnMailIntegrityExecute(function(mailInfo)
      if self.view and self.recordData.uid == mailInfo.uid then
        self:SetData(params)
      end
    end)
  end
end

function TruckRobRecordItem:RefreshIcon()
  local win_icon_path
  local data = self.recordData:GetMailExt()
  if data.selfWin then
    win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
  else
    win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
  end
  if win_icon_path then
    self.winIcon:SetActive(true)
    self.winIcon:LoadSprite(win_icon_path)
    self.winIcon:SetNativeSize()
  else
    self.winIcon:SetActive(false)
  end
  local iconPath = truckIcon
  if self.recordData.type and self.recordData.type == MailType.TRAIN_KOF then
    iconPath = trainIcon
  end
  self.targetIcon:LoadSprite(iconPath)
end

function TruckRobRecordItem:OnMailClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.mailUid, "TruckRecord")
  self.view.ctrl:CloseSelf()
end

return TruckRobRecordItem
