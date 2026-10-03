local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("_PAGE_NAME_")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 500
config.label = "\230\150\176\233\161\181\231\173\190"
config.icon = "Assets/Main/Sprites/UI/GMPanel/gmSettings.png"
config:Add()
config:Add()
config:Add()
config:Add()
config:Add()
config:Add()
return config
