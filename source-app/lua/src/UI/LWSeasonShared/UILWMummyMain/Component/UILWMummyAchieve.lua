local UILWMummyAchieve = BaseClass("UILWMummyAchieve", UIBaseContainer)
local base = UIBaseContainer

function UILWMummyAchieve:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "icon")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.share = self:AddComponent(UIButton, "share")
  self.share:SetOnClick(function()
    UIUtil.ShowTipsId(120018)
  end)
end

function UILWMummyAchieve:OnDestroy()
  self.icon = nil
  self.desc = nil
  self.share = nil
  base.OnDestroy(self)
end

function UILWMummyAchieve:ReInit(template, dataList)
  self.icon:LoadSprite(template.icon)
  self.desc:SetLocalText(template.desc, 0)
  if dataList then
    for _, v in pairs(dataList) do
      if v.type == template.id then
        self.desc:SetLocalText(template.desc, v.num)
        break
      end
    end
  end
end

return UILWMummyAchieve
