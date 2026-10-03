local base = require("Scene.Monopoly.Performance.Performance.MonopolyPerBase")
local MonopolyPerEmpty = BaseClass("MonopolyPerEmpty", base)

function MonopolyPerEmpty:__init(mgr, id, lineData)
end

function MonopolyPerEmpty:__delete()
end

return MonopolyPerEmpty
