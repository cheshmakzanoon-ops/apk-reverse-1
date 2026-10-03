local CollectRewardResItem = BaseClass("CollectRewardResItem", UIAsyncContainer)
local base = UIAsyncContainer

function CollectRewardResItem:OnCreate()
  base.OnCreate(self)
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
end

function CollectRewardResItem:OnDestroy()
  self.resItem = nil
  self.param = nil
  base.OnDestroy(self)
end

function CollectRewardResItem:ReInit(param)
  self.param = param
  self:UpdateData()
end

function CollectRewardResItem:UpdateData()
  if IsNotNull(self.gameObject) then
    if self.param then
      self.resItem:ReInit(self.param)
      self:SetActive(true)
    else
      self:SetActive(false)
    end
  end
end

return CollectRewardResItem
