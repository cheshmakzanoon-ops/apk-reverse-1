local ActTrendsItemFun = BaseClass("ActTrendsItemFun", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local un_lock_level_path = "unLockLevel"

function ActTrendsItemFun:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ActTrendsItemFun:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActTrendsItemFun:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.iconBtn = self:AddComponent(UIButton, icon_path)
  self.un_lock_level = self:AddComponent(UITextMeshProUGUIEx, un_lock_level_path)
  self.iconBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function ActTrendsItemFun:ComponentDestroy()
  self.icon = nil
  self.iconBtn = nil
  self.un_lock_level = nil
end

function ActTrendsItemFun:OnAddListener()
  base.OnAddListener(self)
end

function ActTrendsItemFun:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActTrendsItemFun:SetData(data, jumpType, parent)
  self.jumpType = jumpType
  self.data = data
  self.parent = parent
  self.icon:LoadSprite(data.icon)
  if self.jumpType == SeasonTrendJumpType.City then
    if self.data.city > 0 then
      self.un_lock_level:SetLocalText("2010379", tostring(self.data.city))
      self.un_lock_level:SetActive(true)
    else
      self.un_lock_level:SetActive(false)
    end
  else
    self.un_lock_level:SetActive(false)
  end
end

function ActTrendsItemFun:OnClick()
  self.parent:ShowEventTip(self.jumpType, self.data, self.transform.position)
end

return ActTrendsItemFun
