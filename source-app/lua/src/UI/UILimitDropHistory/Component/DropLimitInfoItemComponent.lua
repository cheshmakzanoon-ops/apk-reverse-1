local base = UIBaseContainer
local DropLimitInfoItemComponent = BaseClass("DropLimitInfoItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function DropLimitInfoItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DropLimitInfoItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DropLimitInfoItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function DropLimitInfoItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.textTime = nil
end

function DropLimitInfoItemComponent:DataDefine()
end

function DropLimitInfoItemComponent:DataDestroy()
end

function DropLimitInfoItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function DropLimitInfoItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function DropLimitInfoItemComponent:SetData(itemData)
  self.itemData = itemData
  self.type = itemData.type
  self.data = itemData.data
  self.dropCount = self.data.dropCount or 0
  self.dropLimitCount = self.data.dropLimitCount or 0
  self.time = self.data.time or 0
  self.isFull = self.dropCount >= self.dropLimitCount
  self:RefreshView()
end

function DropLimitInfoItemComponent:RefreshView()
  self:RefreshDesc()
  self:RefreshTime()
end

function DropLimitInfoItemComponent:RefreshDesc()
  local infoStr = Localization:GetString("drop_record_board_desc2", self.dropCount, self.dropLimitCount)
  if self.isFull then
    local fullStr = Localization:GetString("drop_record_board_desc3")
    self.textDesc:SetLocalText(372621, infoStr, fullStr)
  else
    self.textDesc:SetText(infoStr)
  end
end

function DropLimitInfoItemComponent:RefreshTime()
  local timeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.time or 0)
  self.textTime:SetText(timeStr)
end

return DropLimitInfoItemComponent
