local MailMonsterReward = BaseClass("MailMonsterReward", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local Setting = CS.GameEntry.Setting
local MailMonsterRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MonsterReward.MailMonsterRewardItem")
local MailContentTitle = require("UI.UIMailNew.UIMailMainPanel.Component.MailContentTitle")
local _cp_looplist = "ScrollRect"
local _cp_loopContent = "ScrollRect/Viewport/ScrollContent"

function MailMonsterReward:DataDefine()
  self._lastRewardCnt = 0
  self._collectMail = {}
  self._objList = {}
  self._toLoadMore = false
  self._loadingMail = false
  self._openTimeStamp = UITimeManager:GetInstance():GetServerSeconds()
end

function MailMonsterReward:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self._looplist = self:AddComponent(UILoopListView2, _cp_looplist)
  self._scrollviewContent = self:AddComponent(UIBaseContainer, _cp_loopContent)
  self._looplist:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self._looplist:SetOnDragingAction(function()
    self:OnDragingAction()
  end)
  self._looplist:SetOnEndDragAction(function(...)
    self:OnEndDragAction()
  end)
end

function MailMonsterReward:OnDestroy()
  self._looplist:SetListItemCount(0, true, true)
  Setting:SetPrivateInt(SettingKeys.MAIL_MONSTER_REWARD_LAST_OPEN, self._openTimeStamp)
end

function MailMonsterReward:GetScrollItem(listview, index)
  if index < 0 or index > #self._collectMail then
    return nil
  end
  local itemObj, baseCom
  if index == 0 then
    itemObj = listview:NewListViewItem("UIMailItemTitle")
    baseCom = MailContentTitle
  else
    itemObj = listview:NewListViewItem("MailMonsterRewardItem")
    baseCom = MailMonsterRewardItem
  end
  if self._objList[itemObj] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    itemObj.gameObject.name = nameStr
    local mailItem = self._scrollviewContent:AddComponent(baseCom, nameStr)
    self._objList[itemObj] = mailItem
    local oldPosY = mailItem.rectTransform.anchoredPosition.y
    mailItem.rectTransform.anchoredPosition = Vector2.New(0, oldPosY)
  end
  if index == 0 then
    local param = {}
    param.main = Localization:GetString("310173")
    param.sub = ""
    local mailTime = self._collectMail[1].createTime or 0
    local strMailTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(mailTime)
    param.time = strMailTime
    self._objList[itemObj]:SetData(param)
  else
    self._objList[itemObj]:SetData(self._collectMail[index])
  end
  return itemObj
end

function MailMonsterReward:OnDragingAction()
  local _totalCnt = #self._collectMail
  if self._loadingMail == true then
    return
  end
  local _lastItem = self._looplist:GetShownItemByItemIndex(_totalCnt - 1)
  if _lastItem == nil then
    return
  end
  local _lastItemY = self._looplist:GetItemCornerPosInViewPort(_lastItem).y
  local _viewPortSize = self._looplist.unity_looplistview2.ViewPortSize
  if 50 <= _lastItemY + _viewPortSize then
    self._toLoadMore = true
  end
end

function MailMonsterReward:OnEndDragAction()
  if self._toLoadMore == true then
    self._loadingMail = false
    self._toLoadMore = false
    self:GetMoreMail()
  end
end

function MailMonsterReward:GetMoreMail()
  DataCenter.MailDataManager:ReqMore(MailInternalGroup.MAIL_IN_monsterReward, function()
    self:Refresh(false)
  end)
end

function MailMonsterReward:setData(maildata)
  self._virtualGatherItem = maildata
  self:Refresh(true)
end

function MailMonsterReward:Refresh(resetPos)
  local collectMail = DataCenter.MailDataManager:GetGroupMailList(MailInternalGroup.MAIL_IN_monsterReward)
  local collectMailCnt = table.count(collectMail)
  if collectMailCnt ~= 0 and collectMailCnt == self._lastRewardCnt then
    return
  end
  self._lastRewardCnt = table.count(collectMail)
  self._collectMail = {}
  local inCity = CS.SceneManager:IsInCity()
  for _, mailInfo in pairs(collectMail) do
    local tabMailInfo = rapidjson.decode(mailInfo.contents)
    local mailObj = tabMailInfo.obj or {}
    local mailData = PBController.ParsePb1(mailObj.rewardContent, "protobuf.MonsterCollectRewardMail")
    if mailData ~= nil then
      local inUserWorld = mailData.needCollectReward.inUserWorld
      if inCity == inUserWorld then
        self._collectMail[#self._collectMail + 1] = mailInfo
      end
    end
  end
  local count = #self._collectMail + 1
  self._looplist:SetListItemCount(count, resetPos, true)
  self._looplist:RefreshAllShownItem()
end

return MailMonsterReward
