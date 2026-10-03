local UIRankDetailListCtrl = require("UI.UIRank.UIRankDetailList.Controller.UIRankDetailListCtrl")
local base = UIRankDetailListCtrl
local ServerBattleScoreRankCtrl = BaseClass("ServerBattleScoreRankCtrl", base)

function ServerBattleScoreRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIServerBattleScoreRank)
end

return ServerBattleScoreRankCtrl
