local gui, err = loadfile('gui.lua')
if err or not gui then
    printError(err)
    return
end
gui().show(...)