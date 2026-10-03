local UILWMailDetailAllianceStarCommend = BaseClass("UILWMailDetailAllianceStarCommend", UIBaseContainer)
local base = UIBaseContainer
local UILWMailDetailAllianceStarCommendItem = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailAllianceStarCommendItem")
local rapidjson = require("rapidjson")

function UILWMailDetailAllianceStarCommend:OnCreate()
  base.OnCreate(self)
  self.detail_title = self:AddComponent(UIText, "System/DetailTitle")
  self.detail_time = self:AddComponent(UIText, "System/DetailTimeBg/DetailTime")
  self.d_sub_title = self:AddComponent(UIText, "System/DSubTitle")
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "System/RewardScroll/ViewPort/RankContent")
  self.loopListView = self:AddComponent(UILoopListView2, "System/RewardScroll")
  self.logTipText = self:AddComponent(UIText, "System/LogItem/LogTipText")
  self.goLogBtn = self:AddComponent(UIButton, "System/LogItem/GoLogBtn")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

function UILWMailDetailAllianceStarCommend:OnDestroy()
  self.detail_title = nil
  self.detail_time = nil
  self.d_sub_title = nil
  self.items = nil
  self.content = nil
  self.loopListView = nil
  self.logTipText = nil
  self.goLogBtn = nil
  base.OnDestroy(self)
end

function UILWMailDetailAllianceStarCommend:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.detail_title:SetText(MailShowHelper.GetMainTitle(self.mailData))
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.detail_time:SetText(_strTime)
  self.d_sub_title:SetLocalText("mail_content_11037")
  self:ClearList()
  local msg = rapidjson.decode(self.mailData.contents)
  self.edition = msg.obj.edition
  self.allianceId = msg.obj.allianceId
  SFSNetwork.SendMessage(MsgDefines.AllianceStarGainThumbsUp, self.edition, self.allianceId)
  self.listData = msg.obj.allianceStarList
  if self.listData and #self.listData > 1 then
    self.loopListView:SetActive(true)
    self.loopListView:SetListItemCount(#self.listData, false, false)
    self.loopListView:RefreshAllShownItem()
  else
    self.loopListView:SetActive(false)
  end
  self.logTipText:SetLocalText("alliance_weeklyStar_mailToBook")
  self.goLogBtn:SetOnClick(function()
    if self.allianceId and self.allianceId == LuaEntry.Player:GetAllianceUid() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceStarBook, {anim = true})
    else
      UIUtil.ShowTipsId("alliance_weeklyStar_mail_err1")
    end
  end)
end

function UILWMailDetailAllianceStarCommend:ClearList()
  self.items = {}
  self.content:RemoveComponents(UILWMailDetailAllianceStarCommendItem)
  self.loopListView:ClearAllItems()
end

function UILWMailDetailAllianceStarCommend:GetScrollItem(listview, index)
  local listData = self.listData
  if listData == nil or #listData <= 1 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #listData then
    return nil
  end
  local csItem = listview:NewListViewItem("AwardItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "AwardItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(UILWMailDetailAllianceStarCommendItem, nameStr)
  end
  self.items[csItem]:SetData(listData[index], self.edition)
  return csItem
end

return UILWMailDetailAllianceStarCommend
