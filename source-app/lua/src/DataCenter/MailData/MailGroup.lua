local MailGroup = BaseClass("MailGroup")

function MailGroup:__init(InternalType)
  self.groupId = InternalType
  self:__reset()
end

function MailGroup:__delete()
end

function MailGroup:__reset()
  self.unreadCount = 0
  self.unrewardCount = 0
  self.total = 0
  self.hide = 0
  self.mailList = {}
  self.uiShowIndex = nil
end

function MailGroup:SetTotal(total)
  self.total = total
  if self.total < 0 then
    self.total = 0
    MailPrint("SetTotal error?")
  end
end

function MailGroup:GetTotal()
  return self.total
end

function MailGroup:SetUnrewardCount(c)
  self.unrewardCount = c
  if self.unrewardCount < 0 then
    self.unrewardCount = 0
    MailPrint("SetUnrewardCount error?")
  end
end

function MailGroup:GetUnrewardCount()
  return self.unrewardCount
end

function MailGroup:SetUnreadCount(c)
  self.unreadCount = c
  if self.unreadCount < 0 then
    self.unreadCount = 0
    MailPrint("SetUnreadCount error?")
  end
end

function MailGroup:GetUnreadCount()
  return self.unreadCount
end

local function compareMail(k1, k2)
  return k1.createTime > k2.createTime
end

function MailGroup:AddMail(mailData, calcTotal)
  MailPrint("AddMail: group[%d], mailId[%s]", self.groupId, mailData.uid)
  local isInsert = false
  if not table.IsNullOrEmpty(self.mailList) then
    local lastMail = self.mailList[#self.mailList]
    if lastMail.createTime < mailData.createTime then
      table.bininsert(self.mailList, mailData, compareMail)
      isInsert = true
    end
  end
  if isInsert == false then
    table.insert(self.mailList, mailData)
  end
  mailData.groupId = self.groupId
  if calcTotal ~= false then
    self.total = self.total + 1
    if mailData.status == 0 then
      self.unreadCount = self.unreadCount + 1
    end
    if mailData.rewardStatus == 0 then
      self.unrewardCount = self.unrewardCount + 1
    end
  end
end

function MailGroup:RemoveMail(mailId)
  MailPrint("RemoveMail: group[%d], mailId[%s]", self.groupId, mailId)
  for _, v in ipairs(self.mailList) do
    if v.uid == mailId then
      v.groupId = -1
      table.remove(self.mailList, _)
      self.total = self.total - 1
      if v.status == 0 then
        self.unreadCount = self.unreadCount - 1
      end
      if v.rewardStatus == 0 then
        self.unrewardCount = self.unrewardCount - 1
      end
      break
    end
  end
end

function MailGroup:CleanMail()
  local delete = {}
  local hide = {}
  for i = #self.mailList, 1, -1 do
    local mailInfo = self.mailList[i]
    local mailExt = mailInfo:GetMailExt()
    if mailExt ~= nil then
      local version = mailExt.version
      if type(version) == "number" and version < 3 then
        table.insert(delete, mailInfo.uid)
      elseif mailExt.parseFail then
        table.insert(hide, mailInfo.uid)
        table.remove(self.mailList, i)
        self.total = self.total - 1
        self.hide = self.hide + 1
        if mailInfo.status == 0 then
          self.unreadCount = self.unreadCount - 1
        end
        if mailInfo.rewardStatus == 0 then
          self.unrewardCount = self.unrewardCount - 1
        end
      end
    end
  end
  return delete, hide
end

function MailGroup:RemoveMailAll()
  MailPrint("RemoveMailAll: group[%d]", self.groupId)
  self:__reset()
end

function MailGroup:HasMail()
  return not table.IsNullOrEmpty(self.mailList)
end

function MailGroup:Sort()
end

function MailGroup:IsGetAll()
  if #self.mailList == self.total then
    return true
  end
  if #self.mailList > self.total then
    MailPrint("IsGetAll bug!!!")
    return true
  end
  return false
end

function MailGroup:GetAllMail()
  return self.mailList
end

function MailGroup:GetAllMailCountIncludeHide()
  return #self.mailList + self.hide
end

function MailGroup:GetShowIndex()
  if self.uiShowIndex == nil then
    self.uiShowIndex = 20
  end
  return self.uiShowIndex
end

function MailGroup:GetUIMailList()
  local showIndex = self:GetShowIndex()
  local list = {}
  for i = 1, showIndex do
    local info = self.mailList[i]
    if info == nil then
      break
    end
    table.insert(list, info)
  end
  return list
end

function MailGroup:CleanUIMailList()
  local delete = {}
  local hide = {}
  local isInSeason = SeasonUtil.IsInSeason(false)
  local showIndex = self:GetShowIndex()
  local seasonNum = SeasonUtil.GetSeason()
  local i = 1
  while showIndex >= i do
    local mailInfo = self.mailList[i]
    if mailInfo == nil then
      break
    end
    local mailExt = mailInfo:GetMailExt()
    local mailCustom = mailInfo:GetMailCustom()
    if isInSeason and mailCustom ~= nil and mailCustom.c ~= nil and mailCustom.c.checkSeason == true and mailCustom.c.seasonId ~= nil and mailCustom.c.seasonId ~= seasonNum then
      table.insert(delete, mailInfo.uid)
      i = i + 1
    elseif mailExt ~= nil then
      local version = mailExt.version
      if type(version) == "number" and version < 3 then
        table.insert(delete, mailInfo.uid)
        i = i + 1
      elseif mailExt.parseFail then
        table.insert(hide, mailInfo.uid)
        table.remove(self.mailList, i)
        self.total = self.total - 1
        self.hide = self.hide + 1
        if mailInfo.status == 0 then
          self.unreadCount = self.unreadCount - 1
        end
        if mailInfo.rewardStatus == 0 then
          self.unrewardCount = self.unrewardCount - 1
        end
      else
        i = i + 1
      end
    else
      i = i + 1
    end
  end
  return delete, hide
end

function MailGroup:PullMore()
  local index = self:GetShowIndex()
  self.uiShowIndex = math.min(math.max(#self.mailList, 20), index + 20)
end

function MailGroup:ClearShowIndex()
  self.uiShowIndex = nil
end

return MailGroup
