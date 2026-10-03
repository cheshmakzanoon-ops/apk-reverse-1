local UILWMailListItem = BaseClass("UILWMailListItem", UIBaseContainer)
local base = UIBaseContainer
local time_txt_path = "TimeText"

function UILWMailListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListItem:ComponentDefine()
  self.timeText = self:AddComponent(UIText, time_txt_path)
end

function UILWMailListItem:ComponentDestroy()
  self.timeText = nil
end

function UILWMailListItem:DataDefine()
  self.mailDatas = {}
  self.mailUid = nil
end

function UILWMailListItem:DataDestroy()
  self.mailDatas = nil
  self.mailUid = nil
end

function UILWMailListItem:OnEnable()
  base.OnEnable(self)
end

function UILWMailListItem:OnDisable()
  base.OnDisable(self)
end

function UILWMailListItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailListItem:SetData(params)
  self.mailDatas = params.mail_data
  if not self.mailDatas then
    return
  end
  local createTime = MailShowHelper.GetRelativeCreateTime(self.mailDatas)
  self.timeText:SetText(createTime)
end

function UILWMailListItem:RefreshRedPoint()
end

return UILWMailListItem
