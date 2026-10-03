local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("Favorite")
config.isFavorite = true
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 9527
config.label = "\230\148\182\232\151\143"
config.icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_shamofengbao_btn_shoucang.png"
config:Add()
return config
