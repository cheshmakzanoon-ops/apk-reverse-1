local GMPageConfig = BaseClass("GMPageConfig")
local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")

function GMPageConfig:__init(pageName)
  self.pageName = pageName
  self.isFavorite = false
  self.style = GMPageStyle.PageTemplate.Vertical
  self.order = 100
  self.label = "New"
  self.icon = "Assets/Main/Sprites/UI/GMPanel/gmSettings.png"
  self.items = {}
  self.itemsDic = {}
end

function GMPageConfig:__delete()
  self.pageName = nil
  self.isFavorite = nil
  self.style = nil
  self.order = nil
  self.label = nil
  self.icon = nil
  self.items = nil
  self.itemsDic = nil
end

function GMPageConfig:Add(item)
  if not item or not item.name then
    return
  end
  if self.itemsDic[item.name] then
    GMUtils.LogError("\229\136\157\229\167\139\229\140\150GMPage:%s\229\188\130\229\184\184\239\188\140\233\135\141\229\164\141\230\183\187\229\138\160\229\144\141\229\173\151\228\184\186%s\231\154\132item", self.pageName, item.name)
    return
  end
  item.pageName = self.pageName
  table.insert(self.items, item)
  self.itemsDic[item.name] = item
end

function GMPageConfig:Get(name)
  return self.itemsDic and self.itemsDic[name]
end

return GMPageConfig
