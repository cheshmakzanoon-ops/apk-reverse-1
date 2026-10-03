local LWSeasonTrendsItemFun = BaseClass("LWSeasonTrendsItemFun", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local un_lock_level_path = "unLockLevel"

function LWSeasonTrendsItemFun:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonTrendsItemFun:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonTrendsItemFun:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.iconBtn = self:AddComponent(UIButton, icon_path)
  self.un_lock_level = self:AddComponent(UITextMeshProUGUIEx, un_lock_level_path)
  self.iconBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function LWSeasonTrendsItemFun:ComponentDestroy()
  self.icon = nil
  self.iconBtn = nil
  self.un_lock_level = nil
end

function LWSeasonTrendsItemFun:OnAddListener()
  base.OnAddListener(self)
end

function LWSeasonTrendsItemFun:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeasonTrendsItemFun:SetData(data, jumpType, parent)
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

function LWSeasonTrendsItemFun:OnClick()
  self.parent:ShowEventTip(self.jumpType, self.data, self.transform.position)
end

return LWSeasonTrendsItemFun
