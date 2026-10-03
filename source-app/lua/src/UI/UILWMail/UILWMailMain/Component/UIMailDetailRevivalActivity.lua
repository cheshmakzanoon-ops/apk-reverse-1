local base = UIBaseContainer
local UIMailDetailRevivalActivity = BaseClass("UIMailDetailRevivalActivity", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local UIMailDetailRevivalActivityItemComponent = require("UI.UILWMail.UILWMailMain.Component.UIMailDetailRevivalActivityItemComponent")

function UIMailDetailRevivalActivity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMailDetailRevivalActivity:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMailDetailRevivalActivity:ComponentDefine()
  self.textDetailTitle = self:AddComponent(UIText, "System/DetailTitle")
  self.textDesc = self:AddComponent(UIText, "System/Desc")
  self.textStageTitle = self:AddComponent(UIText, "System/titleRoot/stageTitle")
  self.textRankTitle = self:AddComponent(UIText, "System/titleRoot/rankTitle")
  self.textScoreTitle = self:AddComponent(UIText, "System/titleRoot/scoreTitle")
  self.scrollViewScrollView = self:AddComponent(UIScrollView, "System/ScrollView")
  self.textDetailTime = self:AddComponent(UIText, "System/DetailTimeBg/DetailTime")
  self.textStageTitle:SetText(Localization:GetString("revival_plan_032"))
  self.textRankTitle:SetText(Localization:GetString("revival_plan_033"))
  self.textScoreTitle:SetText(Localization:GetString("revival_plan_034"))
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
end

function UIMailDetailRevivalActivity:ComponentDestroy()
  self.textDetailTitle = nil
  self.textDesc = nil
  self.textStageTitle = nil
  self.textRankTitle = nil
  self.textScoreTitle = nil
  self.scrollViewScrollView = nil
  self.textDetailTime = nil
end

function UIMailDetailRevivalActivity:DataDefine()
end

function UIMailDetailRevivalActivity:DataDestroy()
  self:ClearScrollView()
end

function UIMailDetailRevivalActivity:OnAddListener()
  base.OnAddListener(self)
end

function UIMailDetailRevivalActivity:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMailDetailRevivalActivity:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.textDetailTitle:SetText(MailShowHelper.GetMainTitle(self.mailData))
  self.textDesc:SetText(self.mailData:GetMailMessage())
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.textDetailTime:SetText(_strTime)
  local contents = self.mailData:GetMailBody()
  if contents.obj then
    self.dataList = contents.obj
  else
    self.dataList = {}
  end
  local count = 0
  if self.dataList then
    count = #self.dataList
  end
  self.scrollViewScrollView:SetTotalCount(count)
  if 0 < count then
    self.scrollViewScrollView:RefillCells()
    self.scrollViewScrollView:SetVerticalNormalizedPosition(0)
  end
end

function UIMailDetailRevivalActivity:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollViewScrollView:AddComponent(UIMailDetailRevivalActivityItemComponent, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(index, self.dataList[index])
end

function UIMailDetailRevivalActivity:OnItemDeleteCell(itemObj, index)
end

function UIMailDetailRevivalActivity:ClearScrollView()
  self.scrollViewScrollView:ClearCells()
  self.scrollViewScrollView:RemoveComponents(UIMailDetailRevivalActivityItemComponent)
  self.scrollCellPool = {}
end

return UIMailDetailRevivalActivity
