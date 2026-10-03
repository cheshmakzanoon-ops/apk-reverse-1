local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_BuyGiftPackage = BaseClass("ResLackItem_BuyGiftPackage", ResLackItemBase)

function ResLackItem_BuyGiftPackage:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  local str = string.split(self._config:getValue("para1"), ";")
  if str[1] ~= "" then
    local data = GiftPackManager.getFirstShowTypeGiftPack(str[1])
    if data then
      self.data = data
      return true
    end
    return false
  end
  return false
end

function ResLackItem_BuyGiftPackage:TodoAction()
  if self._config == nil then
    return
  end
  GoToUtil.GotoGiftPackView(self.data)
end

return ResLackItem_BuyGiftPackage
