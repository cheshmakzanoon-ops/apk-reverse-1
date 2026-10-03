local base = UIBaseView
local BankReport = BaseClass("BankReport", base)
local Localization = CS.GameEntry.Localization
local BankReportContent = require("UI.LWSeason5.LWBank.Group.BankReportContent")
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local root_path = "Root"
local title_path = "UICommonPopUpTitle"
local panel_path = "UICommonPopUpTitle/panel"
local titleTxt_path = "UICommonPopUpTitle/Title/titleText"
local tipsIcon_path = "UICommonPopUpTitle/Title/tipsIcon"
local stateBtn_path = "UICommonPopUpTitle/Title/tipsIcon"
local shareBtn_path = "UICommonPopUpTitle/btnGroup/shareBtn"
local detailBtn_path = "UICommonPopUpTitle/btnGroup/detailBtn"
local getBtn_path = "Root/getBtn"
local numberIcon_path = "Root/getBtn/getLayout/numberIcon"
local numberTxt_path = "Root/getBtn/getLayout/numberTxt"
local stampIcon_path = "Root/stampIcon"
local emojiIcon_path = "Root/emojiIcon"
local reportContent_path = "Root/BankReportContent"
local rightBtn_path = "Root/rightBtn"
local leftBtn_path = "Root/leftBtn"
local page_path = "Root/page"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.showType == self.SHOW_TYPE.NEW then
    self:PlayFlyReward()
  end
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.title = self:AddComponent(UIBaseContainer, title_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.tipsIcon = self:AddComponent(UIImage, tipsIcon_path)
  self.stateBtn = self:AddComponent(UIButton, stateBtn_path)
  self.shareBtn = self:AddComponent(UIButton, shareBtn_path)
  self.detailBtn = self:AddComponent(UIButton, detailBtn_path)
  self.getBtn = self:AddComponent(UIButton, getBtn_path)
  self.numberIcon = self:AddComponent(UIImage, numberIcon_path)
  self.numberTxt = self:AddComponent(UIText, numberTxt_path)
  self.stampIcon = self:AddComponent(UIRawImage, stampIcon_path)
  self.emojiIcon = self:AddComponent(UIImage, emojiIcon_path)
  self.reportContent = self:AddComponent(UIBaseContainer, reportContent_path)
  self.rightBtn = self:AddComponent(UIButton, rightBtn_path)
  self.leftBtn = self:AddComponent(UIButton, leftBtn_path)
  self.page = self:AddComponent(UIText, page_path)
  self.closeBtn:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.panel:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.reportContent = self:AddComponent(BankReportContent, reportContent_path)
  self.leftBtn:SetOnClick(BindCallback(self, self.JumpPreviousReport))
  self.rightBtn:SetOnClick(BindCallback(self, self.JumpNextReport))
  self.shareBtn:SetOnClick(BindCallback(self, self.OnClickShareBtn))
  self.detailBtn:SetOnClick(BindCallback(self, self.OnClickMailBtn))
  self.stateBtn:SetOnClick(BindCallback(self, self.OnClickStateBtn))
  self.getBtn:SetOnClick(BindCallback(self, self.OnClickGetReward))
  self.root:SetActive(false)
  self.title:SetActive(false)
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.root = nil
  self.title = nil
  self.panel = nil
  self.titleTxt = nil
  self.tipsIcon = nil
  self.stateBtn = nil
  self.shareBtn = nil
  self.detailBtn = nil
  self.getBtn = nil
  self.numberIcon = nil
  self.numberTxt = nil
  self.stampIcon = nil
  self.emojiIcon = nil
  self.reportContent = nil
  self.rightBtn = nil
  self.leftBtn = nil
  self.page = nil
end

local function DataDefine(self)
  self.curIndex = 1
  self.hasPlayedEffect = {}
  self.SHOW_TYPE = {
    OWN = 1,
    OTHER = 2,
    NEW = 3
  }
end

local function DataDestroy(self)
  self.curIndex = nil
end

function BankReport:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MailPush, self.OnShow)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function BankReport:OnRemoveListener()
  self:RemoveUIListener(EventId.MailPush, self.OnShow)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
  base.OnRemoveListener(self)
end

function BankReport:RefreshView()
  self.root:SetActive(false)
  self.title:SetActive(false)
  local data, closeParam = self:GetUserData()
  self.closeParam = closeParam
  self.totalCnt = nil
  if data == true then
    self.showType = self.SHOW_TYPE.OWN
    self.dataList = {}
    self.startIndex = 0
    self.queryIndex = 0
    self.queryCount = 2
    DataCenter.MailDataManager:ClearTempMailList()
    self:QueryMailsByFilter()
    self:QueryMailCount()
  elseif not table.IsNullOrEmpty(data) then
    self.showType = self.SHOW_TYPE.OTHER
    self.dataList = data
    self:UpdateData()
  else
    self.showType = self.SHOW_TYPE.NEW
    self.dataList = DataCenter.SeasonBankReportManager:GetAllNewBankDataList()
    self:UpdateData()
  end
end

function BankReport:OnShow()
  self:RefreshJumpBtn()
  self.reportContent:ReInit(self.curExtData, self.curData)
  self:RefreshMenu()
  self:PlayEffect()
end

function BankReport:UpdateData()
  if table.IsNullOrEmpty(self.dataList) then
    self.ctrl:CloseSelf()
    if self.closeParam then
      UIManager:GetInstance():OpenWindow(UIWindowNames.BankDepositInfo, {anim = true}, self.closeParam)
    end
    return
  end
  self.root:SetActive(true)
  self.title:SetActive(true)
  self.curData = self.dataList[self.curIndex]
  if self.curData.GetMailExt then
    self.curDataExt = self.curData:GetMailExt()
    self.curExtData = self.curDataExt:GetExtData()
  else
    self.curDataExt = nil
    self.curExtData = self.curData
  end
  self:OnShow()
end

function BankReport:RefreshJumpBtn()
  self.rightBtn:SetActive(self.curIndex < #self.dataList)
  self.leftBtn:SetActive(self.curIndex > 1)
end

function BankReport:JumpNextReport()
  local total = #self.dataList
  if total > self.curIndex then
    self.curIndex = self.curIndex + 1
    self:UpdateData()
    if self.showType == self.SHOW_TYPE.OWN and self.curIndex == total then
      self:PullMoreMailList()
    end
  end
end

function BankReport:JumpPreviousReport()
  if self.curIndex > 1 then
    self.curIndex = self.curIndex - 1
    self:UpdateData()
  end
end

function BankReport:OnClickShareBtn()
  local data = self.curExtData
  if not data or not self.curData then
    return
  end
  local shareParam = {}
  shareParam.post = PostType.SeasonBankReport
  local param = {}
  param.reportUid = self.curData.uid
  param.reportLang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
  param.mailType = self.curData.type
  param.toUser = self.curData.toUser
  param.param = data
  shareParam.param = param
  data.uid = self.curData.uid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function BankReport:OnClickMailBtn()
  local uid = self.curData and self.curData.uid or self.curExtData and self.curExtData.uid or nil
  if not uid or not DataCenter.MailDataManager:GetMailInfoById(uid) then
    UIUtil.ShowTipsId("s5_bank_tips16")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.curData.uid, "DetectReward")
end

function BankReport:OnClickGetReward()
  local uid = self.curData and self.curData.uid or self.curExtData and self.curExtData.uid or nil
  if not uid then
    return
  end
  DataCenter.MailDataManager:RewardMail(uid)
end

function BankReport:OnClickStateBtn()
  UIUtil.ShowBubbleTips(Localization:GetString(self:GetReportInfo("tipsText")), self.stateBtn.transform.position, 0, -35, 0)
end

function BankReport:RefreshMenu()
  local data = self.curExtData
  self.reportType = data.logTypeCode or 1
  self.titleTxt:SetLocalText(self:GetReportInfo("mailName"))
  self.tipsIcon:LoadSpriteAsync(self:GetReportInfo("tipsIcon"))
  self.emojiIcon:LoadSpriteAsync(self:GetReportInfo("bankEmoji"))
  self.stampIcon:LoadSpriteAsync(self:GetReportInfo("bankStamp"))
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(data.bankAddr.id, data.bankAddr.serverId)
  DataCenter.SeasonBankManager:LoadItemIcon(self.numberIcon, meta)
  self.numberTxt:SetText(data.settleAmount)
  self.titleTxt:SetColor(self:GetReportInfo("color"))
  self.isSelf = self.curData and self.curData.toUser == LuaEntry.Player.uid
  self.getBtn:SetActive(self.isSelf and self.curData and self.curData.rewardStatus == 0)
  self.shareBtn:SetActive(self.isSelf)
  self.detailBtn:SetActive(self.isSelf)
  self:UpdateProgress(self.curIndex, self.totalCnt or #self.dataList)
end

function BankReport:UpdateProgress(index, totalCnt)
  if 1 < totalCnt then
    self.page:SetLocalText("135225", index, totalCnt)
    self.page:SetActive(true)
  else
    self.page:SetActive(false)
  end
end

function BankReport:PlayEffect()
  if not self.reportType then
    return
  end
  local id = self.curData and self.curData.uid or self.curExtData and self.curExtData.uid or nil
  if not id or self.hasPlayedEffect[id] then
    return
  end
  self.hasPlayedEffect[id] = true
  if self.reportType == SeasonBankReportType.BE_ROBBED then
    DataCenter.LWSoundManager:PlaySound(5100003, false)
    return
  end
  if self.reportType == SeasonBankReportType.DEPOSIT_DUE then
    DataCenter.LWSoundManager:PlaySound(5100004, false)
    return
  end
end

function BankReport:GetReportInfo(key)
  local reportInfo = DataCenter.SeasonBankTemplateManager[key]
  return reportInfo and reportInfo[self.reportType] or nil
end

function BankReport:PlayFlyReward()
  if table.IsNullOrEmpty(self.dataList) then
    return
  end
  local itemId = LuaEntry.DataConfig:TryGetNum("s5_bank_config", "k7", 650088)
  if UIUtil.GetMonthActiveCount(string.format("%s_%s", "s5_bank_config", itemId), true) > 0 then
    DataCenter.SeasonBankReportManager:ClearNewBankDataList(self.dataList)
    return
  end
  local rewardList = {
    {
      itemId = itemId,
      rewardType = RewardType.GOODS,
      sortOrder = 0,
      count = 1
    }
  }
  TimerManager:GetInstance():DelayInvoke(function()
    if self and self.dataList then
      EventManager:GetInstance():Broadcast(EventId.OnClaimCollectRewardSucc, rewardList)
      DataCenter.SeasonBankReportManager:ClearNewBankDataList(self.dataList)
    end
  end, 0.2)
end

function BankReport:RewardSuccess()
  local uid = self.curData and self.curData.uid or self.curExtData and self.curExtData.uid or nil
  if not uid then
    return
  end
  local mailData = DataCenter.MailDataManager:GetMailInfoById(uid)
  if not mailData then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local pay = mailData:GetMailPay()
  if pay and pay.gold > 0 then
    UIUtil.DoFly(RewardType.GOLD, 2, DataCenter.RewardManager:GetPicByType(RewardType.GOLD), self.numberIcon.transform.position, Vector3.New(0, 0, 0), 100, 100)
  end
  local reward = mailData:GetMailReward()
  local tempType = {}
  if reward and reward.rewardInfo then
    for i = 1, #reward.rewardInfo do
      if reward.rewardInfo[i].type ~= RewardType.FOOD and reward.rewardInfo[i].type ~= RewardType.GOLD then
        table.insert(tempType, RewardToResType[reward.rewardInfo[i].type])
      end
    end
  end
  if next(tempType) then
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
  end
  if reward and 0 < table.count(reward.rewardInfo) then
    for i = 1, #reward.rewardInfo do
      local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
      local flyPos = Vector3.New(0, 0, 0)
      UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, self.numberIcon.transform.position, flyPos, 100, 100)
    end
  end
end

function BankReport:QueryMailsByFilter()
  if self.querying then
    return
  end
  self.querying = true
  self:QueryMailsDirect()
end

function BankReport:QueryMailsDirect()
  local function callback(mailDatas)
    if not mailDatas then
      self.querying = false
      
      return
    end
    for k, v in ipairs(mailDatas) do
      DataCenter.MailDataManager:AddTempMailData(v)
      local mail = DataCenter.MailDataManager:GetTempMailById(v.uid)
      table.insert(self.dataList, mail)
    end
    table.sort(self.dataList, function(a, b)
      return a.createTime > b.createTime
    end)
    self.querying = false
    self:UpdateData()
  end
  
  DataCenter.MailDataManager.DB:QueryMailsByTypesAndMailIdsWithTime(MailInternalGroup.MAIL_IN_season, {
    {
      MailType.SEASON_BANK
    }
  }, 7, self.startIndex, self.queryCount, callback)
  self.startIndex = self.startIndex + self.queryCount
end

function BankReport:PullMoreMailList()
  DataCenter.MailDataManager:ReqMore(MailInternalGroup.MAIL_IN_season, function()
    if self.view then
      self:QueryMailsByFilter()
    end
  end)
end

function BankReport:QueryMailCount()
  local function GetTotalCnt(list)
    if list and list[1] and list[1].count then
      self.totalCnt = list[1] and list[1].count
    end
    self:UpdateProgress(self.curIndex or 0, self.totalCnt or #self.dataList)
  end
  
  DataCenter.MailDataManager.DB:QueryMailsByTypesAndMailIdsWithTime(MailInternalGroup.MAIL_IN_season, {
    {
      MailType.SEASON_BANK
    }
  }, 7, self.queryIndex, self.queryCount, GetTotalCnt, true)
end

BankReport.OnCreate = OnCreate
BankReport.OnDestroy = OnDestroy
BankReport.OnEnable = OnEnable
BankReport.OnDisable = OnDisable
BankReport.ComponentDefine = ComponentDefine
BankReport.ComponentDestroy = ComponentDestroy
BankReport.DataDefine = DataDefine
BankReport.DataDestroy = DataDestroy
return BankReport
