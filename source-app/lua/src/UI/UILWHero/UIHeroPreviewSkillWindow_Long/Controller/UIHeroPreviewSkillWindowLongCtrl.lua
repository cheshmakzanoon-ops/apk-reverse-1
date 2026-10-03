local base = require("UI/UILWHero/UIHeroPreviewSkillWindow/Controller/UIHeroPreviewSkillWindowCtrl")
local UIHeroPreviewSkillWindowLongCtrl = BaseClass("UIHeroPreviewSkillWindowLongCtrl", base)

function UIHeroPreviewSkillWindowLongCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPreviewSkillWindow_Long)
end

return UIHeroPreviewSkillWindowLongCtrl
