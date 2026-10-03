local LWUIStageSkyBattleChapterCtrl = BaseClass("LWUIStageSkyBattleChapterCtrl", UIBaseCtrl)

function LWUIStageSkyBattleChapterCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWStageSkyBattleChapter)
end

return LWUIStageSkyBattleChapterCtrl
