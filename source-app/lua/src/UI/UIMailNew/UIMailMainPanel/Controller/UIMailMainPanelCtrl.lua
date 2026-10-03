local MailWarInfoDataShow = {
  title_pos = "",
  title_time = "",
  result = "",
  fightReports = {},
  startRound = 0,
  battlePointInfo = nil
}
local MailListItemShow = {
  title = "",
  name = "",
  des = "",
  time = ""
}
local MailInfoCommonShow = {
  title = "",
  name = "",
  des = "",
  time = "",
  itemList = {}
}
local MailRewardItemData = {
  itemId = "",
  count = "",
  iconName = "",
  itemColor = "",
  itemName = "",
  itemFlag = "",
  isShowName = true
}
local rapidjson = require("rapidjson")
local UIMailCtrl = BaseClass("UIMailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local MailRewardData = DataClass("MailRewardData", MailRewardItemData)
local MailItemOneData = DataClass("MailItemOneData", MailListItemShow)
local MailWarOneData = DataClass("MailWarOneData", MailWarInfoDataShow)
local MailCommonData = DataClass("MailExchangeData", MailInfoCommonShow)
local MailList = {
  [1] = MailInternalGroup.MAIL_IN_system,
  [2] = MailInternalGroup.MAIL_IN_report,
  [3] = MailInternalGroup.MAIL_IN_alliance
}

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailNew)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
  self._nextShowMailId = ""
  self.currentMailId = ""
  self.mailList = {}
  self.currentTab = -1
end

local function GetCurrentMailListByType(self, tabType)
  self.mailList = DataCenter.MailDataManager:GetGroupMailList(tabType)
  return self.mailList
end

local function GetCurMailIndex(self)
  if self.currentMailId == "" then
    return -1
  end
  for i, v in pairs(self.mailList) do
    if v.uid == self.currentMailId then
      return i
    end
  end
  return -1
end

local function SetShowTranslated(self, show)
  self.showTranslated = show
end

local function GetShowTranslated(self)
  return self.showTranslated
end

local function SetNextShowMailid(self)
  if #self.mailList < 2 or self.currentMailId == "" then
    self._nextShowMailId = ""
    return
  end
  if self.mailList[#self.mailList].uid == self.currentMailId then
    self._nextShowMailId = self.mailList[#self.mailList - 1].uid
  else
    local index = GetCurMailIndex(self)
    if index == -1 then
      self._nextShowMailId = ""
    else
      self._nextShowMailId = self.mailList[index + 1].uid
    end
  end
end

local function SetCurrentMailId(self, mailid)
  if string.IsNullOrEmpty(mailid) then
    mailid = self:GetCurTabFirstMailId()
  end
  self.currentMailId = mailid
  SetNextShowMailid(self)
end

local function GetCurTabFirstMailId(self)
  if self.mailList ~= nil and #self.mailList > 0 then
    return self.mailList[1].uid
  end
  return ""
end

local function GetOneMailByUid(self, uid)
  local mailData = DataCenter.MailDataManager:GetMailInfoById(uid)
  if mailData == nil then
    MailPrint("mail not found ?" .. uid)
  end
  return mailData
end

local function GetCurrentMail(self)
  local mailData = self:GetOneMailByUid(self.currentMailId)
  if mailData == nil then
    MailPrint("mail not found? uid:" .. self.currentMailId)
  end
  return mailData
end

local function ReadMailByGroup(self)
  if self.currentTab == -1 then
    return
  end
  DataCenter.MailDataManager:ReadAndRewardGroupMail(self.currentTab)
end

local function ReadOneMail(self, uid)
  DataCenter.MailDataManager:ReadMail(uid)
end

local function DeleteCurrentMail(self)
  if string.IsNullOrEmpty(self.currentMailId) then
    return
  end
  DataCenter.MailDataManager:DeleteMail(self.currentMailId)
end

local function DeleteMailByGroup(self)
  if self.currentTab == -1 then
    return
  end
  DataCenter.MailDataManager:DeleteGroupMail(self.currentTab)
end

local function AddMailToFavor(self)
  local mailData = self:GetCurrentMail()
  if not mailData then
    return
  end
  if mailData.saveFlag and mailData.saveFlag == 1 then
    UIUtil.ShowTipsId(310111)
    return
  end
  DataCenter.MailDataManager:SetFavor(self.currentMailId)
end

local function GetCurrentFightContent(self, index)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailFightContent, {anim = true, hideTop = true}, self.currentMailId, index)
end

local function GetMailWarData(self)
  local oneData = MailWarOneData.New()
  local currentMail = self:GetCurrentMail()
  if currentMail.battleResult == 2 then
    oneData.result = "DRAW"
  elseif currentMail.battleResult == 0 then
    oneData.result = "WIN"
  elseif currentMail.battleResult == 1 then
    oneData.result = "LOSE"
  end
  local pos = SceneUtils.IndexToTilePos(currentMail.battlePointInfo.pointId, ForceChangeScene.World)
  oneData.title_time = UITimeManager:GetInstance():TimeStampToTimeForLocal(currentMail.createTime)
  oneData.title_pos = Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y)
  oneData.fightReports = currentMail.fightReports
  oneData.battlePointInfo = currentMail.battlePointInfo
  oneData.startRound = currentMail.startRound
  return oneData
end

local function GetMailItemOneData(self, uid)
  local oneData = MailItemOneData.New()
  local mail = self:GetOneMailByUid(uid)
  if mail.type == MailType.NEW_FIGHT then
    local playerUid = LuaEntry.Player.uid
    oneData.name = Localization:GetString("300014")
    if mail.battleResult == 0 then
      oneData.des = Localization:GetString("310118", Localization:GetString("390074"))
    elseif mail.battleResult == 1 then
      oneData.des = Localization:GetString("290006", Localization:GetString("390074"))
    end
  elseif mail.type == MailType.GIFT_BUY_EXCHANGE then
    oneData.name = Localization:GetString("100074")
  elseif mail.type == MailType.MAIL_WOUNDED then
    oneData.name = Localization:GetString("310013")
  elseif mail.type == MailType.MAIL_SYSTEM or mail.type == MailType.ALLIANCE_CITY_OCCUPIED_REWARD then
    oneData.name = Localization:GetString("100164")
  elseif mail.type == MailType.MAIL_SELF_SEND then
    oneData.name = mail.fromName
    oneData.des = mail.title
  elseif mail.type == MailType.MAIL_USER then
    oneData.name = mail.fromName
    oneData.des = mail.title
  elseif mail.type == MailType.MAIL_ALLIANCE_ALL then
    oneData.name = Localization:GetString("390088")
    oneData.des = mail.title
  elseif mail.type == MailType.MAIL_PRESIDENT_SEND then
    oneData.name = Localization:GetString("390510")
    oneData.des = mail.title
  elseif mail.type == MailType.NEW_COLLECT_MAIL then
    oneData.name = Localization:GetString("300012")
  elseif mail.type == MailType.MAIL_UPDATE then
    oneData.name = Localization:GetString("100164")
  elseif mail.type == MailType.LW_METEORITE_COLLECT then
    oneData.name = Localization:GetString("300012")
  else
    oneData.name = mail.type
  end
  oneData.time = UITimeManager:GetInstance():TimeStampToTimeForLocal(mail.createTime)
  return oneData
end

local function GetMailCommonData(self)
  local oneData = {}
  local currentMail = self:GetCurrentMail()
  if currentMail.type == MailType.GIFT_BUY_EXCHANGE then
    oneData.title = Localization:GetString("100074")
    oneData.name = Localization:GetString("120114")
    local arr = string.split(currentMail.contents, "|")
    if #arr == 2 then
      local str = arr[1]
      local goldArr = string.split(arr[2], ",")
      if 2 < #goldArr then
        oneData.name = Localization:GetString(str) .. goldArr[3] .. Localization:GetString("100183")
      else
        oneData.name = Localization:GetString(currentMail.contents)
      end
    else
      oneData.name = Localization:GetString(currentMail.contents)
    end
    local str = currentMail.rewardId
    local arrMiddle = string.split(str, "|")
    if arrMiddle ~= nil and 0 < #arrMiddle then
      local tempList = {}
      for k, v in ipairs(arrMiddle) do
        local arr = string.split(v, ",")
        if arr[1] == "goods" then
          local param = {}
          param.itemId = arr[2]
          param.count = arr[3]
          table.insert(tempList, param)
        end
      end
      oneData.itemList = self:GetMailRewardItemList(tempList, true)
    end
    Logger.Log("contents", currentMail.contents)
    Logger.Log("type", currentMail.type)
    Logger.Log("rewardId", currentMail.rewardId)
  elseif currentMail.type == MailType.MAIL_SYSTEM or currentMail.type == MailType.ALLIANCE_CITY_OCCUPIED_REWARD then
    oneData.title = Localization:GetString(currentMail.title)
    local arr = string.split(currentMail.contents, "|")
    if #arr == 2 then
      oneData.name = Localization:GetString(arr[1], arr[2])
    elseif #arr == 3 then
      oneData.name = Localization:GetString(arr[1], arr[2], arr[3])
    else
      oneData.name = Localization:GetString(currentMail.contents)
    end
    local str = currentMail.rewardId
    local arrMiddle = string.split(str, "|")
    if arrMiddle ~= nil and 0 < #arrMiddle then
      local tempList = {}
      for k, v in ipairs(arrMiddle) do
        local arr = string.split(v, ",")
        if arr[1] == "goods" then
          local param = {}
          param.itemId = arr[2]
          param.count = arr[3]
          table.insert(tempList, param)
        end
      end
      oneData.itemList = self:GetMailRewardItemList(tempList, true)
    end
  elseif currentMail.type == MailType.MAIL_WOUNDED then
    Logger.Log("contents", currentMail.contents)
    local data = rapidjson.decode(currentMail.contents)
    local message = data.message
    if message ~= nil then
      oneData.title = Localization:GetString("310013")
      local arr = string.split(message, ",")
      oneData.name = Localization:GetString("A105551", arr[1], arr[2])
    end
  end
  oneData.time = UITimeManager:GetInstance():TimeStampToTimeForLocal(currentMail.createTime)
  return oneData
end

local function GetMailRewardItemList(self, list, showName)
  local showList = {}
  table.walk(list, function(k, v)
    local id = v.itemId
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    if goods ~= nil then
      local oneData = MailRewardData.New()
      oneData.itemId = id
      oneData.iconName = goods.icon
      oneData.count = v.count
      if showName then
        oneData.itemName = DataCenter.ItemTemplateManager:GetName(id)
      end
      oneData.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
      local itemType = goods.type
      if itemType == 2 then
        if goods.para1 ~= nil and goods.para1 ~= "" then
          local para1 = goods.para1
          local temp = string.split(para1, ";")
          if temp ~= nil and 1 < #temp then
            oneData.itemFlag = temp[1] .. temp[2]
          end
        end
      elseif itemType == 3 then
        local type2 = goods.type2
        if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
          local res_num = tonumber(goods.para)
          oneData.itemFlag = string.GetFormattedStr(res_num)
        end
      end
      table.insert(showList, oneData)
    end
  end)
  return showList
end

local function OnClickPosBtn(self, pos, serverId)
  if pos ~= 0 then
    self:CloseSelf()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World), CS.SceneManager.World.InitZoom, nil, nil, serverId)
  end
end

local function OnClickAlMarkBtn(self, pos)
  if pos ~= 0 then
    self:CloseSelf()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World), CS.SceneManager.World.InitZoom)
  end
end

local function GetCurrentMailUnReadCountTab(self)
  return DataCenter.MailDataManager:GetMailUnReadCountTable()
end

local function GetMailChatData(self)
  local oneData = MailCommonData.New()
  local currentMail = self:GetCurrentMail()
  if currentMail.type == MailType.MAIL_SELF_SEND then
    oneData.title = currentMail.title
    oneData.name = currentMail.fromName
    oneData.fromUser = currentMail.fromUser
  elseif currentMail.type == MailType.MAIL_USER then
    oneData.title = currentMail.title
    oneData.name = currentMail.fromName
    oneData.fromUser = currentMail.fromUser
  elseif currentMail.type == MailType.MAIL_ALLIANCE_ALL then
    oneData.title = currentMail.title
    oneData.name = Localization:GetString("390088")
    oneData.fromUser = ""
  elseif currentMail.type == MailType.MAIL_PRESIDENT_SEND then
    oneData.title = currentMail.title
    oneData.name = Localization:GetString("390510")
    oneData.fromUser = ""
  end
  oneData.contents = currentMail.contents
  oneData.type = currentMail.type
  oneData.time = UITimeManager:GetInstance():TimeStampToTimeForLocal(currentMail.createTime)
  return oneData
end

local function OnBackMessageClick(self, name, fromUser, title, contents, time)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailReturn, {anim = true, hideTop = true}, name, fromUser, title, contents, time)
end

local function OnNewMailClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailSend, {anim = true, hideTop = true}, MailType.MAIL_SELF_SEND, "", "")
end

local function OnMoreHero(self)
  local scienceId = DataCenter.ArmyFormationDataManager:GetFirstFormationUnlockScienceId()
  if scienceId ~= nil then
    GoToUtil.GotoScience(CommonUtil.GetScienceBaseType(scienceId))
    self:CloseSelf()
  end
end

local function OnUpgradeHeroLevel(self, heroUuid)
  GoToUtil.GotoOpenView(UIWindowNames.UIHeroList, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, heroUuid)
end

local function OnRecruitHero(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit)
end

local function OnUpgradeHeroQuality(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance)
end

UIMailCtrl.OnMoreHero = OnMoreHero
UIMailCtrl.OnUpgradeHeroLevel = OnUpgradeHeroLevel
UIMailCtrl.OnRecruitHero = OnRecruitHero
UIMailCtrl.OnUpgradeHeroQuality = OnUpgradeHeroQuality
UIMailCtrl.CloseSelf = CloseSelf
UIMailCtrl.Close = Close
UIMailCtrl.InitData = InitData
UIMailCtrl.GetCurrentMailListByType = GetCurrentMailListByType
UIMailCtrl.GetOneMailByUid = GetOneMailByUid
UIMailCtrl.GetCurrentMail = GetCurrentMail
UIMailCtrl.DeleteCurrentMail = DeleteCurrentMail
UIMailCtrl.DeleteMailByGroup = DeleteMailByGroup
UIMailCtrl.ReadOneMail = ReadOneMail
UIMailCtrl.ReadMailByGroup = ReadMailByGroup
UIMailCtrl.GetMailWarData = GetMailWarData
UIMailCtrl.GetMailItemOneData = GetMailItemOneData
UIMailCtrl.GetMailCommonData = GetMailCommonData
UIMailCtrl.OnClickPosBtn = OnClickPosBtn
UIMailCtrl.GetCurrentMailUnReadCountTab = GetCurrentMailUnReadCountTab
UIMailCtrl.GetCurrentFightContent = GetCurrentFightContent
UIMailCtrl.GetMailRewardItemList = GetMailRewardItemList
UIMailCtrl.GetMailChatData = GetMailChatData
UIMailCtrl.OnBackMessageClick = OnBackMessageClick
UIMailCtrl.OnNewMailClick = OnNewMailClick
UIMailCtrl.AddMailToFavor = AddMailToFavor
UIMailCtrl.SetCurrentMailId = SetCurrentMailId
UIMailCtrl.GetCurTabFirstMailId = GetCurTabFirstMailId
UIMailCtrl.OnClickAlMarkBtn = OnClickAlMarkBtn
UIMailCtrl.SetShowTranslated = SetShowTranslated
UIMailCtrl.GetShowTranslated = GetShowTranslated
return UIMailCtrl
