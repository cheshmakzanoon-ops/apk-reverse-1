local UILWMailDetailInActivityMember = BaseClass("UILWMailDetailInActivityMember", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWInActivityMemberItem = require("UI.UILWMail.UILWMailMain.Component.UILWInActivityMemberItem")
local rapidjson = require("rapidjson")
local title_txt_path = "System/DetailTitle"
local sub_title_txt_path = "System/DSubTitle"
local message_txt_path = "System/DMessage"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local scroll_view_path = "System/DScroll"

function UILWMailDetailInActivityMember:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailInActivityMember:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailInActivityMember:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function UILWMailDetailInActivityMember:ComponentDestroy()
  self.titleTxt = nil
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
end

function UILWMailDetailInActivityMember:DataDefine()
  self.mailUid = {}
  self.mailData = {}
  self.inActiveList = {}
  self.cells = {}
  self.refreshed = false
end

function UILWMailDetailInActivityMember:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
  self.inActiveList = nil
  self.cells = nil
  self.refreshed = nil
end

function UILWMailDetailInActivityMember:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailInActivityMember:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailInActivityMember:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailInActivityMember:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailInActivityMember:RefreshContent()
  if self.refreshed == true then
    return
  end
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strSubTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  self.subTitleTxt:SetText(_strSubTitle)
  self.messageTxt:SetLocalText(455091)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
  local contents = self.mailData:GetMailBody()
  if contents.b then
    self.inActiveList = rapidjson.decode(contents.b.content.text)
  else
    self.inActiveList = {}
  end
  self:ClearScroll()
  self.scroll_view:SetTotalCount(#self.inActiveList)
  self.scroll_view:RefillCells()
  self.refreshed = true
end

function UILWMailDetailInActivityMember:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UILWInActivityMemberItem, itemObj)
  cellItem:SetData(self.inActiveList[index])
  self.cells[index] = cellItem
end

function UILWMailDetailInActivityMember:OnDeleteCell(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UILWInActivityMemberItem)
  self.cells[index] = nil
end

function UILWMailDetailInActivityMember:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILWInActivityMemberItem)
  self.cells = {}
end

return UILWMailDetailInActivityMember
