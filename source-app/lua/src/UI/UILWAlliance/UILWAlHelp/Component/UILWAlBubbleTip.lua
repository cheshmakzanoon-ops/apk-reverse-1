local UILWAlBubbleTip = BaseClass("UILWAlBubbleTip", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local click_btn_path = "Btn"

function UILWAlBubbleTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlBubbleTip:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlBubbleTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWAlBubbleTip:ComponentDestroy()
  self.clickBtn = nil
end

function UILWAlBubbleTip:DataDefine()
end

function UILWAlBubbleTip:DataDestroy()
end

function UILWAlBubbleTip:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UILWAlBubbleTip:OnDisable()
  base.OnDisable(self)
end

function UILWAlBubbleTip:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshShow)
  self:AddUIListener(EventId.UpdateMainAllianceRedCount, self.OnRefreshShow)
end

function UILWAlBubbleTip:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshShow)
  self:RemoveUIListener(EventId.UpdateMainAllianceRedCount, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UILWAlBubbleTip:OnClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  SFSNetwork.SendMessage(MsgDefines.AlHelpAll, math.floor(curTime), self.clickBtn.transform.position, nil, nil, true)
end

function UILWAlBubbleTip:OnRefreshShow()
  local helpNum = DataCenter.AllianceHelpDataManager:GetHelpNum()
  if 0 < helpNum then
    self:TrySetShow(true)
  else
    self:TrySetShow(false)
  end
end

function UILWAlBubbleTip:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Help, bool)
end

function UILWAlBubbleTip:SetShow(bool)
  self.clickBtn:SetActive(bool)
end

return UILWAlBubbleTip
