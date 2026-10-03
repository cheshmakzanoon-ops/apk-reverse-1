local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_Quest = BaseClass("ResLackItem_Quest", ResLackItemBase)

function ResLackItem_Quest:CheckIsOk(_resType, _needCnt)
  return true
end

function ResLackItem_Quest:TodoAction()
  local param = {}
  param.roomId = QuestRoomId
  GoToUtil.OpenChatView(true, {anim = false}, param)
end

return ResLackItem_Quest
