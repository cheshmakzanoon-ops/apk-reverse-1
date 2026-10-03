local UILWMummyAchieveS5 = BaseClass("UILWMummyAchieveS5", UIBaseContainer)
local base = UIBaseContainer

function UILWMummyAchieveS5:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "icon")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.share = self:AddComponent(UIButton, "share")
  self.share:SetOnClick(function()
    UIUtil.ShowTipsId(120018)
  end)
end

function UILWMummyAchieveS5:OnDestroy()
  self.icon = nil
  self.desc = nil
  self.share = nil
  base.OnDestroy(self)
end

function UILWMummyAchieveS5:ReInit(template, dataList)
  self.icon:LoadSpriteAsync(template.icon)
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

return UILWMummyAchieveS5
