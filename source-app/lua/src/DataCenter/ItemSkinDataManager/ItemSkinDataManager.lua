local ItemSkinDataManager = BaseClass("ItemSkinDataManager")
local ItemSkinData = require("DataCenter.ItemSkinDataManager.ItemSkinData")

function ItemSkinDataManager:__init()
  self.allItemSkins = {}
  self:AddListener()
end

function ItemSkinDataManager:__delete()
  self.allItemSkins = {}
  self:RemoveListener()
end

function ItemSkinDataManager:AddListener()
end

function ItemSkinDataManager:RemoveListener()
end

function ItemSkinDataManager:InitUserSkins(t)
  local useColor = t.userSkinColourArr
  if useColor then
    for _, v in ipairs(useColor) do
      self:UpdateOnUserSkin(v)
    end
  end
end

function ItemSkinDataManager:UpdateOnUserSkin(data)
  local colourId = data.colourId
  if self.allItemSkins[colourId] == nil then
    self.allItemSkins[colourId] = ItemSkinData.New()
  end
  self.allItemSkins[colourId]:ParseData(data)
end

function ItemSkinDataManager:GetItemSkinDataById(colourId)
  return self.allItemSkins[colourId]
end

function ItemSkinDataManager:UpdateSkinData(t)
  if t.skinColourInfo ~= nil then
    self:UpdateOnUserSkin(t.skinColourInfo)
    EventManager:GetInstance():Broadcast(EventId.UpdateItemSkinData)
  end
end

return ItemSkinDataManager
