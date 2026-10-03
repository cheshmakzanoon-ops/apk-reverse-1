local ChatGovIcon = BaseClass("ChatGovIcon", UIAsyncContainer)
local base = UIAsyncContainer

function ChatGovIcon:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatGovIcon:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatGovIcon:ComponentDefine()
  self.img = self:AddComponent(UIImage, "")
end

function ChatGovIcon:ComponentDestroy()
  self.img = nil
  self.imgPath = nil
end

function ChatGovIcon:SetData(imgPath)
  self.imgPath = imgPath
end

function ChatGovIcon:UpdateData()
  self.img:LoadSpriteAsync(self.imgPath)
end

return ChatGovIcon
